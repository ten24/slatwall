/// <reference path='../typings/hibachiTypescript.d.ts' />
/// <reference path='../typings/tsd.d.ts' />
import {coremodule} from "./core/core.module";
declare var angular:any;
declare var hibachiConfig:any;

//generic bootstrapper
export class BaseBootStrapper{
    public myApplication:any;
    public _resourceBundle = {};
    public $http:ng.IHttpService;
    public $q:ng.IQService;
    public appConfig:any;

    constructor(myApplication){
      this.myApplication = myApplication;
      return angular.lazy(this.myApplication)
        .resolve(['$http','$q','$timeout', ($http,$q,$timeout)=> {
            this.$http = $http;
            this.$q = $q;

            if(
                localStorage.getItem('appConfig')
                && localStorage.getItem('appConfig') !== 'undefined'
                && localStorage.getItem('resourceBundles')
                && localStorage.getItem('resourceBundles') !== 'undefined'
            ){
                 return $http.get(hibachiConfig.baseURL+'?'+hibachiConfig.action+'=api:main.getInstantiationKey')

                .then( (resp)=> {
                    var appConfig = JSON.parse(localStorage.getItem('appConfig'));
                    if(resp.data.data === appConfig.instantiationKey){
                        coremodule.constant('appConfig',appConfig)
                        .constant('resourceBundles',JSON.parse(localStorage.getItem('resourceBundles')));
                    }else{
                        return this.getData();
                    }
                });
            }else{
                return this.getData();
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

    getData=()=>{

        return this.$http.get(hibachiConfig.baseURL+'?'+hibachiConfig.action+'=api:main.getConfig')

        .then( (resp:any)=> {
            coremodule.constant('appConfig',resp.data.data);
            localStorage.setItem('appConfig',JSON.stringify(resp.data.data));
            this.appConfig = resp.data.data;
            return this.getResourceBundles();

        });
    }

    getResourceBundle= (locale) => {
        var deferred = this.$q.defer();
        var locale = locale || this.appConfig.rbLocale;

        if(this._resourceBundle[locale]) {
            return this._resourceBundle[locale];
        }

        var urlString = this.appConfig.baseURL+'/index.cfm/?'+this.appConfig.action+'=api:main.getResourceBundle&instantiationKey='+this.appConfig.instantiationKey+'&locale='+locale;

        this.$http(
            {
                url:urlString,
                method:"GET"
            }
        ).success((response:any,status,headersGetter) => {
            this._resourceBundle[locale] = response.data;
            console.log(this._resourceBundle);
            deferred.resolve(response);
        }).error((response:any) => {
            this._resourceBundle[locale] = {};
            deferred.reject(response);
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
        });
        return resourceBundlePromises;

    }
}




