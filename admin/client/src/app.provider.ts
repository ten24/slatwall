import { Injectable } from '@angular/core';
import { HttpClient, HttpResponse } from '@angular/common/http';
import { Observable } from 'rxjs/Observable';
import { Subject } from 'rxjs/Subject';

declare var hibachiConfig: any;
declare var window: any;
var md5 = require('md5');
@Injectable()
export class AppConfig {
    public action: string = "";
    public applicationKey: string = "";
    public attributeCacheKey: string = "";
    public baseURL: string = "";
    public dateFormat: string = "";
    public debugFlag: boolean;
    public instantiationKey: string = "";
    public modelConfig: any = {};
    public rbLocale: string = "";
    public timeFormat: string = "";
    constructor() {
    }
}
@Injectable()
export class ResourceBundles {
    constructor() {
    }
}

@Injectable()
export class AttributeMetaData {
    constructor() {
    }
}

@Injectable()
export class AppProvider {
    public hasData$: Observable<boolean>;
    public hasDataSubject: Subject<boolean>;
    public appConfig;
    public _resourceBundle = {};
    public attributeMetaData: any;
    public instantiationKey: string;
    public _hasData: boolean;
    public isPrivate:boolean;

    constructor(private http: HttpClient) {
        this.hasDataSubject = new Subject<boolean>();
        this.hasData$ = this.hasDataSubject.asObservable();
    }

    set hasData(newValue) {
        this._hasData = newValue;
        this.hasDataSubject.next(newValue);
    }

    public async fetchData(): Promise<any> {
        var baseURL = hibachiConfig.baseURL;
        if (!baseURL) {
            baseURL = ''
        }
        if (baseURL.length && baseURL.slice(-1) !== '/') {
            baseURL += '/';
        } 
        this.instantiationKey = await this.getInstantiationKey(baseURL);
        var invalidCache = [];
        
        return this.isPrivateMode().then( async (isPrivate)=>{
            if(!isPrivate){
                this.isPrivate = true;
            }
        
            try { 
                var hashedData = localStorage.getItem('attributeChecksum');
                if (hashedData !== null && hibachiConfig.attributeCacheKey === hashedData.toUpperCase()) {
                    this.attributeMetaData = JSON.parse(localStorage.getItem('attributeMetaData'));
                } else {
                    invalidCache.push('attributeCacheKey');
                }
            } catch (e) {
                invalidCache.push('attributeCacheKey');
            }
    
            try {
                if(!isPrivate) {
                    this.appConfig = JSON.parse(localStorage.getItem('appConfig'));    
                } else {
                    this.appConfig= {
                        instantiationKey:undefined      
                    };    
                }
                console.log(hibachiConfig);
                console.log(this.appConfig);
                if (hibachiConfig.instantiationKey === this.appConfig.instantiationKey) {
                    console.log('test', this.appConfig);
                    if (invalidCache.length) {
                        this.getData(invalidCache).then(resp => {
                            return this.getResourceBundles().then((resp) => {
                                Promise.resolve(resp);
                            });
                        });
                    }
                    
                    var ResourceBundles = await this.getResourceBundles();
                    return ResourceBundles;
                } else {
                    invalidCache.push('instantiationKey');
                }
            } catch (e) {
                invalidCache.push('instantiationKey');
            }
    
            return await this.getData(invalidCache);
        });
    }

    isPrivateMode=()=> {
      return new Promise((resolve) => {
        const on = () => resolve(true); // is in private mode
        const off = () => resolve(false); // not private mode
        const testLocalStorage = () => {
          try {
            if (localStorage.length) off();
            else {
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
    
    public getInstantiationKey(baseURL: string): Promise<any> {
        return new Promise((resolve, reject) => {
            if (hibachiConfig.instantiationKey) {
                resolve(hibachiConfig.instantiationKey);
            } else {
                return this.http.get(baseURL + '?' + hibachiConfig.action + '=api:main.getInstantiationKey').toPromise().then((resp: any) => resolve(resp.data.instantiationKey));
            }
        });
    };

    public async getData(invalidCache: string[]): Promise<any> {
        var promises: any = {};
        for (var i in invalidCache) {
            var invalidCacheName = invalidCache[i];
            var functionName = invalidCacheName.charAt(0).toUpperCase() + invalidCacheName.slice(1);
            promises[invalidCacheName] = await this['get' + functionName + 'Data']();

        }
        return Promise.all(promises);
    };

    public getAttributeCacheKeyData(): Promise<any> {
        var urlString = "";

        if (!hibachiConfig) {
            hibachiConfig = {};
        }

        if (!hibachiConfig.baseURL) {
            hibachiConfig.baseURL = '';
        }
        urlString += hibachiConfig.baseURL;

        if (urlString.length && urlString.slice(-1) !== '/') {
            urlString += '/';
        }
        return new Promise((resolve, reject) => {
            return this.http.get(urlString + '?' + hibachiConfig.action + '=api:main.getAttributeModel')
                .subscribe((resp: any) => {
                    //for safari private mode which has no localStorage
                    try {
                        localStorage.setItem('attributeMetaData', JSON.stringify(resp.data));
                        localStorage.setItem('attributeChecksum', md5(JSON.stringify(resp.data)));
                        // NOTE: at this point attributeChecksum == hibachiConfig.attributeCacheKey
                        // Keeps localStorage appConfig.attributeCacheKey consistent after attributeChecksum updates (even though it is not referenced apparently)
                        this.appConfig.attributeCacheKey = localStorage.getItem('attributeChecksum').toUpperCase();
                        this.appConfig = resp.data;
                        localStorage.setItem('appConfig',JSON.stringify(this.appConfig));
                    } catch (e) { }
                    this.attributeMetaData = resp.data;
                    resolve(true);
                });
        });

    };


    public async getInstantiationKeyData(): Promise<any> {
        if (!this.instantiationKey) {
            var d = new Date();
            var n = d.getTime();
            this.instantiationKey = n.toString();
        }
        var urlString = "";
        if (!hibachiConfig) {
            hibachiConfig = {};
        }
        if (!hibachiConfig.baseURL) {
            hibachiConfig.baseURL = '';
        }
        urlString += hibachiConfig.baseURL;
        if (hibachiConfig.baseURL.length && hibachiConfig.baseURL.charAt(hibachiConfig.baseURL.length - 1) != '/') {
            urlString += '/';
        }

        return await this.http.get(urlString + '/custom/system/config.json?instantiationKey=' + this.instantiationKey)
            .toPromise().then(async (resp: any) => {
                console.log('testhere');
                this.appConfig = resp.data;
                if (hibachiConfig.baseURL.length) {
                    this.appConfig.baseURL = urlString;
                }
                try {
                    if(!this.isPrivate) {
                        localStorage.setItem('appConfig', JSON.stringify(resp.data));
                    }
                } catch (e) { }

                //this.appConfig = appConfig;
                console.log('getINstan2');
                var ResourceBundles = await this.getResourceBundles();
                return ResourceBundles;
            });

    };

    public getResourceBundle(locale): Promise<any> {
        var locale = locale || this.appConfig.rbLocale;

        if (this._resourceBundle[locale]) {
            return this._resourceBundle[locale];
        }

        var urlString = this.appConfig.baseURL + '/custom/system/resourceBundles/' + locale + '.json?instantiationKey=' + this.appConfig.instantiationKey;

        return new Promise((resolve, reject) => {
            this.http.get(urlString).toPromise().then((response: any) => {

                this._resourceBundle[locale] = response;
                resolve(true);
            }, (error: any) => {
                if (error.status === 404) {
                    this._resourceBundle[locale] = {};
                    resolve(true);
                } else {
                    reject(true);
                }
            });
        });
    };

    public getResourceBundles(): Promise<any> {
        console.log('test4');
        var localeListArray = this.appConfig.rbLocale.split('_');
        var rbPromise;
        var rbPromises = [];
        rbPromise = this.getResourceBundle(this.appConfig.rbLocale);
        rbPromises.push(rbPromise);
        if (localeListArray.length === 2) {
            rbPromise = this.getResourceBundle(localeListArray[0]);
            rbPromises.push(rbPromise);
        }
        if (localeListArray[0] !== 'en') {
            //this.getResourceBundle('en_us');
            this.getResourceBundle('en');
        }
        console.log('test5');
        return Promise.all(rbPromises)
        /*.then((data) => {
          console.log('test',this._resourceBundle,data);
        },(error) =>{
            //can enter here due to 404
        });*/

    }
}
