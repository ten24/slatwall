/// <reference path="../../../../overrides.d.ts"/>

import * as angular from "angular";
import * as md5 from "md5";
import "angular-resource";
import "angular-cookies";
import "angular-route";
import "angular-animate";
import "angular-sanitize";
import "../lib//angular-lazy-bootstrap/bootstrap.js";
import "../lib/angular-ui-bootstrap/ui.bootstrap.min.js";
import "../lib/metismenu/metismenu.js";
import "../lib/angularjs-datetime-picker/angularjs-datetime-picker.js";
import "../..//HibachiAssets/js/jquery-typewatch-2.0.js";
import "../..//HibachiAssets/js/jquery-ui-timepicker-addon-1.3.1.js";

import { coremodule } from "./core/core.module";

declare var hibachiConfig: any;
declare var window: any;
//generic bootstrapper
export class BaseBootStrapper {
    public myApplication: any;
    public _resourceBundle = {};
    public $http: ng.IHttpService;
    public $q: ng.IQService;
    public appConfig: any;
    public attributeMetaData: any;
    public instantiationKey: string;
    public isPrivate: boolean;


    constructor(myApplication) {
        console.log("Angular boostraped vjghd");
        this.myApplication = myApplication;
        return angular.lazy(this.myApplication).resolve(['$http', '$q', ($http: ng.IHttpService, $q: ng.IQService) => {
            this.$http = $http;
            this.$q = $q;
            var baseURL = hibachiConfig.baseURL;
            if (!baseURL) {
                baseURL = ''
            }
            if (baseURL.length && baseURL.slice(-1) !== '/') {
                baseURL += '/';
            }

            return this.getInstantiationKey(baseURL).then((instantiationKey: string) => {
                this.instantiationKey = instantiationKey;
                var invalidCache = [];

                return this.isPrivateMode().then((isPrivate) => {
                    if (!isPrivate) {
                        this.isPrivate = true;
                    }

                    // Inspecting attribute model metadata in local storage (retreived from slatAction=api:main.getAttributeModel)
                    try {
                        var hashedData = localStorage.getItem('attributeChecksum');

                        // attributeMetaData is valid and can be restored from local storage cache
                        if (hashedData !== null && hibachiConfig.attributeCacheKey === hashedData.toUpperCase()) {
                            coremodule.constant('attributeMetaData', JSON.parse(localStorage.getItem('attributeMetaData')));

                            // attributeMetaData is invalid and needs to be refreshed
                        } else {
                            invalidCache.push('attributeCacheKey');
                        }

                        // attributeMetaData is invalid and needs to be refreshed
                    } catch (e) {
                        invalidCache.push('attributeCacheKey');
                    }

                    // Inspecting app config/model metadata in local storage (retreived from /custom/system/config.json)
                    try {
                        if (!isPrivate) {
                            this.appConfig = JSON.parse(localStorage.getItem('appConfig'));
                        } else {
                            this.appConfig = {
                                instantiationKey: undefined
                            };

                        }

                        // appConfig instantiation key is valid (but attribute model may need to be refreshed)
                        if (
                            hibachiConfig.instantiationKey
                            && this.appConfig.instantiationKey
                            && hibachiConfig.instantiationKey === this.appConfig.instantiationKey
                        ) {


                            // NOTE: Return a promise so bootstrapping process will wait to continue executing until after the last step of loading the resourceBundles

                            coremodule.constant('appConfig', this.appConfig);
                            // If invalidCache, that indicates a need to refresh attribute metadata prior to retrieving resourceBundles
                            if (invalidCache.length) {
                                let deferred = $q.defer();
                                this.getData(invalidCache).then(resp => {
                                    this.getResourceBundles().then((resp) => {
                                        deferred.resolve(resp);
                                    });
                                });

                                // Ends bootstrapping the process
                                return deferred.promise;
                            }

                            // All appConfig and attribute model valid, nothing to refresh prior, ends the bootstrapping process
                            return this.getResourceBundles();


                            // Entire app config needs to be refreshed
                        } else {
                            invalidCache.push('instantiationKey');
                        }

                        // Entire app config needs to be refreshed
                    } catch (e) {
                        invalidCache.push('instantiationKey');
                    }

                    // NOTE: If invalidCache array does not contain 'instantiationKey' this will not work because getResourceBundles will not be in the promise chain when the bootstrapping process ends
                    return this.getData(invalidCache);
                });

            });
        }])

    }

    isPrivateMode = () => {
        return new Promise((resolve) => {
            const on = () => resolve(true); // is in private mode
            const off = () => resolve(false); // not private mode
            const testLocalStorage = () => {
                try {
                    if (localStorage.length) off();
                    else {
                        localStorage.setItem('x', '1');
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

    getInstantiationKey = (baseURL: string): ng.IPromise<any> => {
        return this.$q((resolve, reject) => {
            if (hibachiConfig.instantiationKey) {
                resolve(hibachiConfig.instantiationKey);
            } else {

                this.$http.get(baseURL + '?' + hibachiConfig.action + '=api:main.getInstantiationKey').then((resp: any) => resolve(resp.data.data.instantiationKey));

            }
        });
    };


    getData = (invalidCache: string[]) => {
        var promises: { [id: string]: ng.IPromise<any> } = {};
        for (var i in invalidCache) {
            var invalidCacheName = invalidCache[i];
            var functionName = invalidCacheName.charAt(0).toUpperCase() + invalidCacheName.slice(1);
            promises[invalidCacheName] = this['get' + functionName + 'Data']();

        }
        return this.$q.all(promises);
    };

    getAttributeCacheKeyData = () => {
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

        return this.$http.get(urlString + '?' + hibachiConfig.action + '=api:main.getAttributeModel')
            .then((resp: any) => {
                coremodule.constant('attributeMetaData', resp.data.data);
                //for safari private mode which has no localStorage
                try {
                    localStorage.setItem('attributeMetaData', JSON.stringify(resp.data.data));
                    localStorage.setItem('attributeChecksum', md5(JSON.stringify(resp.data.data)));

                    // NOTE: at this point attributeChecksum == hibachiConfig.attributeCacheKey
                    // Keeps localStorage appConfig.attributeCacheKey consistent after attributeChecksum updates (even though it is not referenced apparently)
                    this.appConfig.attributeCacheKey = localStorage.getItem('attributeChecksum').toUpperCase();
                    localStorage.setItem('appConfig', JSON.stringify(this.appConfig));
                } catch (e) { }
                this.attributeMetaData = resp.data.data;
            });

    };

    getInstantiationKeyData = () => {
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

        return this.$http.get(urlString + '/custom/system/config.json?instantiationKey=' + this.instantiationKey)
            .then((resp: any) => {

                var appConfig = resp.data.data;
                if (hibachiConfig.baseURL.length) {
                    appConfig.baseURL = urlString;
                }
                coremodule.constant('appConfig', appConfig);
                try {
                    if (!this.isPrivate) {
                        localStorage.setItem('appConfig', JSON.stringify(resp.data.data));
                    }
                } catch (e) { }
                this.appConfig = appConfig;
                return this.getResourceBundles();
            });

    };

    getResourceBundle = (locale) => {
        var deferred = this.$q.defer();
        var locale = locale || this.appConfig.rbLocale;

        if (this._resourceBundle[locale]) {
            return this._resourceBundle[locale];
        }

        var urlString = this.appConfig.baseURL + '/custom/system/resourceBundles/' + locale + '.json?instantiationKey=' + this.appConfig.instantiationKey;

        this.$http({ url: urlString, method: "GET" })
            .then(
                (response) => {
                    if (response.status === 404) {
                        this._resourceBundle[locale] = {};
                        deferred.resolve(response);
                    } else {
                        this._resourceBundle[locale] = response.data;
                        deferred.resolve(response.data);
                    }
                },
                (reason) => { deferred.reject(reason) }
            )
            .catch((reason) => deferred.reject(reason));
        return deferred.promise
    };

    getResourceBundles = (): ng.IPromise<{}> => {
        var rbLocale = this.appConfig.rbLocale;
          if(rbLocale == 'en_us'){
              rbLocale = 'en'
          }
        var localeListArray = rbLocale.split('_');
        var rbPromises = [];
        var rbPromise = this.getResourceBundle(rbLocale);
        rbPromises.push(rbPromise);
        if (localeListArray.length === 2) {
            rbPromise = this.getResourceBundle(localeListArray[0]);
            rbPromises.push(rbPromise);
        }
        if(localeListArray[0] !== 'en') {
            this.getResourceBundle('en');
        }
        return this.$q.all(rbPromises).then((data): any => {
            coremodule.constant('resourceBundles', this._resourceBundle);
        }, (error): any => {
            //can enter here due to 404
            coremodule.constant('resourceBundles', this._resourceBundle);
        });

    }
}