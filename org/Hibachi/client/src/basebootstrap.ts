/// <reference path='../typings/hibachiTypescript.d.ts' />
/// <reference path='../typings/tsd.d.ts' />
import {coremodule} from "./core/core.module";
declare var angular:any;
declare var hibachiConfig:any;
declare var window:any;
var md5 = require('md5');
//generic bootstrapper
export class BaseBootStrapper{
    public myApplication:any;
    public _resourceBundle = {};
    public $http:ng.IHttpService;
    public $q:ng.IQService;
    public appConfig:any;
    public attributeMetaData:any;
    public instantiationKey:string;
    public isPrivate:boolean;
    

    constructor(myApplication){
        this.myApplication = myApplication;
        this.appConfig = {
            instantiationKey : undefined
        }
        // Inspecting app config/model metadata in local storage (retreived from /custom/system/config.json)
        return angular.lazy(this.myApplication)
        .resolve( ['$http','$q', ($http, $q) => {
            this.$http = $http;
            this.$q = $q;
            var baseURL = this.getBaseUrl();
            return this.getInstantiationKey(baseURL)
            .then( (instantiationKey: string) => {
                var invalidCache = [];
                // NOTE: Return a promise so bootstrapping process will wait to continue executing until after the last step of loading the resourceBundles
                return this.isPrivateMode()
                .then( (privateMode) => {
                    if(privateMode){
                        throw("Private mode");
                    }else {
                        return invalidCache;
                    }
                })
                .then( () => {
		            // Inspecting attribute model metadata in local storage (retreived from slatAction=api:main.getAttributeModel)
                    var hashedData = localStorage.getItem('attributeChecksum');
                    if(hashedData !== null && hibachiConfig.attributeCacheKey === hashedData.toUpperCase() ) {
                        // attributeMetaData is valid and can be restored from local storage cache
                        coremodule.constant('attributeMetaData', JSON.parse(localStorage.getItem('attributeMetaData')) );
                    } else {
                        invalidCache.push('attributeCacheKey');
                    }
                })
                .then( () => {
                    if(localStorage.getItem('appConfig') != null) {
                        this.appConfig = JSON.parse(localStorage.getItem('appConfig'));
                    }
                    
                    if( hibachiConfig.instantiationKey
                        && this.appConfig.instantiationKey
                        && hibachiConfig.instantiationKey === this.appConfig.instantiationKey
                    ){
                        // appConfig instantiation key is valid (but attribute model may need to be refreshed)
                        coremodule.constant('appConfig', this.appConfig);
                    } else {
                        invalidCache.push('instantiationKey');
                    }
                })
                .catch( () => {
                    invalidCache.push('attributeCacheKey');
                    invalidCache.push('instantiationKey');
                })
                .then( () => {
                    // If invalidCache, that indicates a need to refresh attribute metadata prior to retrieving resourceBundles
                     if (invalidCache.length) {
                        let deferred = $q.defer();
                        this.getData(invalidCache) .then(resp => { deferred.resolve(resp); });
                        return deferred.promise;
                    }
                })
                .then( () =>  {
                    let deferred = $q.defer();
                    this.getResourceBundles().then( (resp) => deferred.resolve(resp) )
                    return deferred.promise;
                })
                .catch( (e) => { 
                    console.error(e);
                });
           });
      }])

    }
    
    getBaseUrl = () => {
        var urlString = "";
        
        if(!hibachiConfig){
            hibachiConfig = {};
        }
        
        if(!hibachiConfig.baseURL){
            hibachiConfig.baseURL = '';
        }
        
        urlString += hibachiConfig.baseURL;
        if( hibachiConfig.baseURL.length && hibachiConfig.baseURL.charAt(hibachiConfig.baseURL.length-1) != '/' ) {
            urlString += '/';
        }
        
        return urlString;
    }
    
    isPrivateMode = () => {
        
      return this.$q( (resolve, reject) => {
        
        const on = () => {
            this.isPrivate = true;// is in private mode
            resolvePromise();
        }
        
        const off = () => {
            this.isPrivate = false; // not private mode 
            resolvePromise()
        }
        
        const resolvePromise = () => {
            resolve(this.isPrivate);
        }
        
        
        if(this.isPrivate !== null) { //if already determined, (in some earlier call)
            return resolvePromise();
        }
        
        const testLocalStorage = () => {
          
            try {
                if(localStorage.length) {
                    off();
                } else {
                  localStorage.setItem('x','1');
                  localStorage.removeItem('x');
                  off();
                }
            } catch (e) {
                // Safari only enables cookie in private mode
                // if cookie is disabled then all client side storage is disabled
                // if all client side storage is disabled, then there is no point
                // in using private mode
                navigator.cookieEnabled ? on() : off();
            }
        };
        
        // Chrome & Opera
        if (window.webkitRequestFileSystem) {
          return void window.webkitRequestFileSystem(0, 0, off, on);
        }
        
        // Firefox
        if ('MozAppearance' in document.documentElement.style) {
          const db = indexedDB.open('test');
          db.onerror = on;
          db.onsuccess = off;
          return void 0;
        }
        
        // Safari
        if (/constructor/i.test(window.HTMLElement)) {
          return testLocalStorage();
        }
        
        // IE10+ & Edge
        if (!window.indexedDB && (window.PointerEvent || window.MSPointerEvent)) {
          return on();
        }
        
        // others
        return off();
      });
    }

    getInstantiationKey = (baseURL:string): ng.IPromise<any> => {
        return this.$q( (resolve, reject) => {
            if(this.instantiationKey) {
                resolve(this.instantiationKey);
            } else if(hibachiConfig.instantiationKey) {
                resolve(hibachiConfig.instantiationKey);
            } else {
                this.$http.get(baseURL + '?' + hibachiConfig.action + '=api:main.getInstantiationKey')
                .then( (resp:any) => { 
                    this.instantiationKey = resp.data.data.instantiationKey;
                    resolve(this.instantiationKey); 
                })
            }
        });
    };

    getData = ( invalidCache: string[] ) => {
        var promises: { [id:string]: ng.IPromise<any> } = {};
        for(var i in invalidCache) { // attributeCacheKey, instantiationKey
            var invalidCacheName = invalidCache[i];
            var functionName = invalidCacheName.charAt(0).toUpperCase()+invalidCacheName.slice(1);
            promises[invalidCacheName] = this['get'+functionName+'Data'](); // mind the syntax 8)
        }
        return this.$q.all(promises);
    };

    getAttributeCacheKeyData = () => {
        
        var urlString = this.getBaseUrl();

        return this.$http
        .get( urlString + '?' + hibachiConfig.action + '=api:main.getAttributeModel' )
        .then( (resp:any) => resp.data.data )
        .then( (data) => {
            coremodule.constant('attributeMetaData', data);
            this.attributeMetaData = data;
            return data;
        })
        .then( (data) => {
            return this.$q( (resolve, reject) => {
                this.isPrivateMode().then( (privateMode) => {
                    if(!privateMode) {
                        var metadataSreing = JSON.stringify(data);
                        localStorage.setItem('attributeMetaData', metadataSreing );
                        localStorage.setItem('attributeChecksum', md5(metadataSreing) );
                        
                        // NOTE: at this point attributeChecksum == hibachiConfig.attributeCacheKey
                        // Keeps localStorage appConfig.attributeCacheKey consistent after attributeChecksum updates (even though it is not referenced apparently)
                        this.appConfig['attributeCacheKey'] = localStorage.getItem('attributeChecksum').toUpperCase();
                        localStorage.setItem('appConfig', JSON.stringify(this.appConfig));
                    }
                    resolve(data);
                });
            });
        })
        .catch( (e) => {
            console.error(e); 
        });

    };

    getInstantiationKeyData = () => {
        
        if( !this.instantiationKey ){
            var d = new Date();
            var n = d.getTime();
            this.instantiationKey = n.toString();
        }
        
        var urlString = this.getBaseUrl();
        return this.$http
        .get( urlString + '/custom/system/config.json?instantiationKey=' + this.instantiationKey )
        .then( (resp: any) => resp.data.data )
        .then( (data) => {
            return this.$q( (resolve, reject) => {
                this.isPrivateMode().then( (privateMode) => {
                    if(!privateMode) {
                        localStorage.setItem('appConfig', JSON.stringify(data) );
                    }
                    resolve(data);
                });
            });
        })
        .then( (appConfig: any) => {
            if(hibachiConfig.baseURL.length) {
                appConfig.baseURL = urlString;    
            }
            coremodule.constant('appConfig', appConfig);
            this.appConfig = appConfig;
        })
        .then( () => this.getResourceBundles() )
        .catch( (e) => {
            console.error(e); 
        });

    };

    getResourceBundle = (locale) => {
        var deferred = this.$q.defer();
        var locale = locale || this.appConfig.rbLocale;

        if(this._resourceBundle[locale] ) {
            return this._resourceBundle[locale];
        }

        var urlString = this.appConfig.baseURL + '/custom/system/resourceBundles/' + locale + '.json?instantiationKey=' + this.appConfig.instantiationKey;
        this.$http({ url:urlString,  method:"GET" })
        .success( (response:any, status, headersGetter ) => {
            this._resourceBundle[locale] = response;
            deferred.resolve(response);
        })
        .error( (response:any, status) => {
            if(status === 404){
                this._resourceBundle[locale] = {};
                deferred.resolve(response);
            } else {
                deferred.reject(response);
            }
        });
        
        return deferred.promise
    };
    
    getResourceBundles = () => {
        var rbLocale = this.appConfig.rbLocale;
        if(rbLocale == 'en_us'){
            rbLocale = 'en'
        }
        var localeListArray = rbLocale.split('_');
        var rbPromises = [];
        var rbPromise = this.getResourceBundle(rbLocale);
        rbPromises.push(rbPromise);
        
        if(localeListArray.length === 2) {
            rbPromise = this.getResourceBundle(localeListArray[0]);
            rbPromises.push(rbPromise);
        }
        
        if(localeListArray[0] !== 'en') {
            this.getResourceBundle('en');
        }

		return this.$q.all(rbPromises)
		    .then( (data) => {
                coremodule.constant('resourceBundles', this._resourceBundle);
            })
            .catch( (e) => {
                //can enter here due to 404
                coremodule.constant('resourceBundles', this._resourceBundle);
                console.error(e);
            });
    }

    getAuthInfo = () => {
		return this.$http
		.get(this.appConfig.baseURL + '?' + this.appConfig.action + '=api:main.login' )
		.then( (loginResponse:any) => {
			if(loginResponse.status === 200){
				coremodule.value('token', loginResponse.data.token);
			} else {
			    throw loginResponse;
			}
		})
		.catch( (e) => {
		    coremodule.value('token', 'invalidToken');
            console.error(e);
        });
    }

}
