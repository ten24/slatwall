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
        return angular.lazy(this.myApplication).resolve(['$http','$q', ($http,$q)=> {
            this.$http = $http;
            this.$q = $q;
            var baseURL = hibachiConfig.baseURL;
            if(!baseURL) {
                baseURL = ''
            }
            if(baseURL.length && baseURL.slice(-1) !== '/'){
                baseURL += '/';
            }

           return this.getInstantiationKey(baseURL).then((instantiationKey:string)=>{
                this.instantiationKey = instantiationKey;
                var invalidCache = [];
                try{
                    var hashedData = localStorage.getItem('attributeChecksum');
                    if(hashedData !== null && hibachiConfig.attributeCacheKey === hashedData.toUpperCase()){
                        coremodule.constant('attributeMetaData',JSON.parse(localStorage.getItem('attributeMetaData')));
                    }else{
                        invalidCache.push('attributeCacheKey');
                    }
                }catch(e){
                    invalidCache.push('attributeCacheKey');
                }

                try{
                    this.appConfig = JSON.parse(localStorage.getItem('appConfig'));
                    if(hibachiConfig.instantiationKey === this.appConfig.instantiationKey){
                        coremodule.constant('appConfig', this.appConfig);
                        return this.getResourceBundles();
                    }else{
                        invalidCache.push('instantiationKey');
                    }
                }catch(e){
                    invalidCache.push('instantiationKey');
                }

                return this.getData(invalidCache);
            });
      }])

    }

    getInstantiationKey=(baseURL:string):ng.IPromise<any>=>{
        return this.$q((resolve, reject)=> {
            if(hibachiConfig.instantiationKey){
                resolve(hibachiConfig.instantiationKey);
            }else{

                this.$http.get(baseURL+'?'+hibachiConfig.action+'=api:main.getInstantiationKey').then((resp:any) => resolve(resp.data.data.instantiationKey));

            }
        });
    };


    getData=(invalidCache:string[])=>{
        var promises:{[id:string]:ng.IPromise<any>} ={};
        for(var i in invalidCache){
            var invalidCacheName = invalidCache[i];
            var functionName = invalidCacheName.charAt(0).toUpperCase()+invalidCacheName.slice(1);
            promises[invalidCacheName] = this['get'+functionName+'Data']();

        }
        return this.$q.all(promises);
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
                localStorage.setItem('attributeChecksum',md5(JSON.stringify(resp.data.data)));
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
            coremodule.constant('appConfig',resp.data.data);
            try{
                localStorage.setItem('appConfig',JSON.stringify(resp.data.data));
            }catch(e){}
            this.appConfig = appConfig;
            return this.getResourceBundles();
        });

    };

    getResourceBundle= (locale) => {
        var deferred = this.$q.defer();
        var locale = locale || this.appConfig.rbLocale;

        if(this._resourceBundle[locale]) {
            return this._resourceBundle[locale];
        }

        var urlString = this.appConfig.baseURL+'/custom/config/resourceBundles/'+locale+'.json?instantiationKey='+this.appConfig.instantiationKey;

        this.$http({
            url:urlString,
            method:"GET"
        }).success((response:any,status,headersGetter) => {
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
    };

    getResourceBundles= () => {
        var localeListArray = this.appConfig.rbLocale.split('_');
        var rbPromise;
        var rbPromises = [];
        rbPromise = this.getResourceBundle(this.appConfig.rbLocale);
        rbPromises.push(rbPromise);
        if(localeListArray.length === 2) {
            rbPromise = this.getResourceBundle(localeListArray[0]);
            rbPromises.push(rbPromise);
        }
        if(localeListArray[0] !== 'en') {
            //this.getResourceBundle('en_us');
            this.getResourceBundle('en');
        }
        return this.$q.all(rbPromises).then((data) => {
            coremodule.constant('resourceBundles',this._resourceBundle);
        },(error) =>{
            //can enter here due to 404
            coremodule.constant('resourceBundles',this._resourceBundle);
        });

    }
}



