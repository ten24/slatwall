/// <reference path='../typings/hibachiTypescript.d.ts' />
/// <reference path='../typings/tsd.d.ts' />
import {coremodule} from "./core/core.module";
declare var angular:any;
declare var hibachiConfig:any;
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

    constructor(myApplication){
        this.myApplication = myApplication;
        return angular.lazy(this.myApplication)
        .resolve(['$http','$q','$timeout', ($http,$q,$timeout)=> {
            this.$http = $http;
            this.$q = $q;

            this.instantiationKey = hibachiConfig.instantiationKey;
            var invalidCache = [];

            try{
                var hashedData = md5(localStorage.getItem('attributeMetaData'));
                if(hibachiConfig.attributeCacheKey === hashedData.toUpperCase()){
                    coremodule.constant('attributeMetaData',JSON.parse(localStorage.getItem('attributeMetaData')));
                }else{
                    invalidCache.push('attributeCacheKey');
                }
            }catch(e){
                invalidCache.push('attributeCacheKey');
            }

            if(localStorage.getItem('appConfig') !== null){
                try{
                    this.appConfig = JSON.parse(localStorage.getItem('appConfig'));
                    if(this.appConfig.instantiationKey === null || this.appConfig.instantiationKey != this.instantiationKey){
                        invalidCache.push('instantiationKey');
                    }else{
                        coremodule.constant('appConfig',this.appConfig);
                    }
                }catch(e){
                    invalidCache.push('instantiationKey');
                }
            }
            return this.getData(invalidCache);

        }])

    }

    getData=(invalidCache:string[])=>{
        console.log(invalidCache);
        var promises:{[id:string]:ng.IPromise<any>} ={};
        for(var i in invalidCache){
            var invalidCacheName = invalidCache[i];
            var functionName = invalidCacheName.charAt(0).toUpperCase()+invalidCacheName.slice(1);
            promises[invalidCacheName] = this['get'+functionName+'Data']();

        }

        return this.$q.all(promises).finally(()=>{
            return this.getResourceBundles();
        });
    };

    getAttributeCacheKeyData = ()=>{


        var urlString = "";

        if(!hibachiConfig){
            hibachiConfig = {};
        }

        if(!hibachiConfig.baseURL){
            hibachiConfig.baseURL = '';
        }
        urlString += hibachiConfig.baseURL;

         if(urlString.length && urlString.slice(-1) !== '/'){
            urlString += '/';
         }

        return this.$http.get(urlString+'?'+hibachiConfig.action+'=api:main.getAttributeModel')
        .then( (resp:any)=> {
            coremodule.constant('attributeMetaData',resp.data.data);
            //for safari private mode which has no localStorage
            try{
                localStorage.setItem('attributeMetaData',JSON.stringify(resp.data.data));
            }catch(e){}
            this.attributeMetaData = resp.data.data;
        });

    };

    getInstantiationKeyData = ()=>{
        if(!this.instantiationKey){
            var d = new Date();
            var n = d.getTime();
            this.instantiationKey = n.toString();
        }

        var urlString = "";

        if(!hibachiConfig){
            hibachiConfig = {};
        }

        if(!hibachiConfig.baseURL){
            hibachiConfig.baseURL = '';
        }
        urlString += hibachiConfig.baseURL;
        if(hibachiConfig.baseURL.length && hibachiConfig.baseURL.charAt(hibachiConfig.baseURL.length-1) != '/'){
            urlString+='/';
        }

        return this.$http.get(urlString+'/custom/config/config.json?instantiationKey='+this.instantiationKey)
        .then( (resp:any)=> {
        	var appConfig = resp.data.data;
            if(hibachiConfig.baseURL.length){
                appConfig.baseURL=urlString;    
            }
            //for safari private mode which has no localStorage
            try{
                localStorage.setItem('appConfig',JSON.stringify(resp.data.data));
            }catch(e){}
            coremodule.constant('appConfig',resp.data.data);
            this.appConfig = appConfig;
        });

    };

    getResourceBundle= (locale) => {
        var deferred = this.$q.defer();
        var locale = locale || this.appConfig.rbLocale;

        if(this._resourceBundle[locale]) {
            return this._resourceBundle[locale];
        }

        var urlString = this.appConfig.baseURL+'/custom/config/resourceBundles/'+locale+'.json?instantiationKey='+this.appConfig.instantiationKey;

        this.$http(
            {
                url:urlString,
                method:"GET"
            }
        ).success((response:any,status,headersGetter) => {
            this._resourceBundle[locale] = response;

            deferred.resolve(response);
        }).error((response:any,status) => {
            if(status === 404){
                this._resourceBundle[locale] = {};

                deferred.resolve(response);
            }else{
                deferred.reject(response);
            }

        });
        return deferred.promise
    }

    getResourceBundles= () => {
        var localeListArray = this.appConfig.rbLocale.split('_');
        var rbPromise;
        var rbPromises = [];
        rbPromise = this.getResourceBundle(this.appConfig.rbLocale);
        rbPromises.push(rbPromise);
        for(var i = 0; i > localeListArray.length; i++){
            rbPromise = this.getResourceBundle(localeListArray[i]);
            rbPromises.push(rbPromise);
        }
        if(localeListArray[0] !== 'en') {
            this.getResourceBundle('en');
        }
        return this.$q.all(rbPromises).finally(() => {
            coremodule.constant('resourceBundles',this._resourceBundle);
        });

    }
}




