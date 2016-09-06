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

            var cacheState = {
                instantiationKey:false,
                attributeCacheKey:false
            }

            if(
                localStorage.getItem('appConfig')
                && localStorage.getItem('appConfig') !== 'undefined'
                && localStorage.getItem('resourceBundles')
                && localStorage.getItem('resourceBundles') !== 'undefined'
                && localStorage.getItem('attributeMetaData')
                && localStorage.getItem('attributeMetaData') !== 'undefined'
            ){
                 return $http.get(hibachiConfig.baseURL+'?'+hibachiConfig.action+'=api:main.getInstantiationKey')

                .then( (resp)=> {

                    var appConfig = JSON.parse(localStorage.getItem('appConfig'));
                    var attributeMetaData = JSON.parse(localStorage.getItem('attributeMetaData'));
                    var invalidCache = [];
                    for(var key in resp.data.data){
                        if(key==='attributeCacheKey'){

                            var hashedData = md5(localStorage.getItem('attributeMetaData'));
                            if(resp.data.data[key] === hashedData.toUpperCase()){
                                coremodule.constant('attributeMetaData',JSON.parse(localStorage.getItem('attributeMetaData')));
                            }else{
                                invalidCache.push(key);
                            }

                        }else if (key === 'instantiationKey'){

                            this.instantiationKey = resp.data.data[key];
                            if(resp.data.data[key] === appConfig[key]){
                                coremodule.constant('appConfig',appConfig)
                                .constant('resourceBundles',JSON.parse(localStorage.getItem('resourceBundles')));
                            }else{
                                invalidCache.push(key);
                            }
                        }
                    }

                    if( invalidCache.length > 0 ){
                        return this.getData(invalidCache);
                    }

                });
            }else{
                var invalidCache = Object.keys(cacheState);
                return this.getData(invalidCache);
            }
        }])
        .loading(function(){
            //angular.element('#loading').show();
        })
        .error(function(){
            //angular.element('#error').show();
        })
        .done(function() {
            //angular.element('#loading').hide();
        });

    }

    getData=(invalidCache:string[])=>{
        var promises:{[id:string]:ng.IPromise<any>} ={};
        for(var i in invalidCache){
            var invalidCacheName = invalidCache[i];
            var functionName = invalidCacheName.charAt(0).toUpperCase()+invalidCacheName.slice(1);
            promises[invalidCacheName] = this['get'+functionName+'Data']();

        }

        return this.$q.all(promises).then((data)=>{
        });
    }

    getAttributeCacheKeyData = ()=>{

        return this.$http.get(hibachiConfig.baseURL+'?'+hibachiConfig.action+'=api:main.getAttributeModel')
        .then( (resp:any)=> {
            coremodule.constant('attributeMetaData',resp.data.data);
            localStorage.setItem('attributeMetaData',JSON.stringify(resp.data.data));
            this.attributeMetaData = resp.data.data;
        },(response:any) => {

        });

    }

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
        
        return this.$http.get(urlString+'custom/config/config.json?instantiationKey='+this.instantiationKey)
        .then( (resp:any)=> {
            coremodule.constant('appConfig',resp.data.data);
            localStorage.setItem('appConfig',JSON.stringify(resp.data.data));
            this.appConfig = resp.data.data;
            return this.getResourceBundles();

        },(response:any) => {

        });

    }

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
        ////$log.debug('hasResourceBundle');
        ////$log.debug(this._loadedResourceBundle);
        //$log.debug(this.getConfigValue('rbLocale').split('_'));
        var rbLocale = this.appConfig.rbLocale.split('_');
        var localeListArray = rbLocale;
        var rbPromise;
        var rbPromises = [];
        rbPromise = this.getResourceBundle(this.appConfig.rbLocale);
        rbPromises.push(rbPromise);
        if(localeListArray.length === 2) {
            //$log.debug('has two');
            rbPromise = this.getResourceBundle(localeListArray[0]);
            rbPromises.push(rbPromise);
        }
        if(localeListArray[0] !== 'en') {
            //$log.debug('get english');
            this.getResourceBundle('en_us');
            this.getResourceBundle('en');
        }
        var resourceBundlePromises = this.$q.all(rbPromises).then((data) => {
            coremodule.constant('resourceBundles',this._resourceBundle);
            localStorage.setItem('resourceBundles',JSON.stringify(this._resourceBundle));

        },(error) =>{
            //can enterhere due to 404
            coremodule.constant('resourceBundles',this._resourceBundle);
            localStorage.setItem('resourceBundles',JSON.stringify(this._resourceBundle));
        });
        return resourceBundlePromises;

    }
}




