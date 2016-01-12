/*jshint browser:true */
//'use strict';
require('./vendor.ts')();
import {coremodule} from "./core/core.module";
//import {BaseBootStrapper} from "./basebootstrap";
import {slatwalladminmodule} from "./slatwall/slatwalladmin.module";
import {loggermodule} from "./logger/logger.module";

//custom bootstrapper
class bootstrapper /*extends BaseBootStrapper*/{
    public _resourceBundle = {};
    constructor(){
      //super();
        
        
//      this.bootstrapConfigPromise.then((response:any)=>{
//          var config = response.data;
//          this.myApplication.constant("appConfig",config);
//          var initInjector = angular.injector(["ng",this.myApplication.name]);
//          console.log(initInjector.get('appConfig'));
////          var rbkeyService = initInjector.get('rbkeyService');
////          rbkeyService.getResourceBundles().then(()=>{
//            this.bootstrapApplication();    
////          });
//          
//      });
        
        console.log('test');
        console.log(angular);
        angular.lazy(slatwalladminmodule.name)
            .resolve(['$http','$q', ($http,$q)=> {
                this.$http = $http;
                this.$q = $q;
                return $http.get('/index.cfm/?slatAction=api:main.getConfig')
                .then( (resp)=> {
                    coremodule.constant('appConfig',resp.data.data);
                    console.log('that');
                    console.log(this);
                    this.appConfig = resp.data.data;
                    return this.getResourceBundles();
                    
                });
            }])
            .loading(function(){
                angular.element('#loading').show();
            })
            .error(function(){
                angular.element('#error').show();
            })
            .done(function() {
                angular.element('#loading').hide();
            })
            .bootstrap();
//        window.deferredBootstrapper.bootstrap({
//          element: document,
//          module: slatwalladminmodule.name,
//          resolve: {
//            appConfig: ['$http', function ($http) {
//              return $http.get('/index.cfm/?slatAction=api:main.getConfig');
//            }]
////              ,
////            OTHER_CONFIG: ['$http', function ($http) {
////              return $http.get('/api/demo-config-2');
////            }],
////            USING_Q: ['$http', '$q', '$timeout', function ($http, $q, $timeout) {
////              var deferred = $q.defer();
////              $timeout(function () {
////                deferred.resolve('MyConstant');
////              }, 2000);
////              return deferred.promise;
////            }]
//          }
//        });
        
    }
    
    getResourceBundle= (locale) => {
        var deferred = this.$q.defer();
        var locale = locale || this.appConfig.rbLocale;

        if(this._resourceBundle[locale]) {
            return this._resourceBundle[locale];
        }

        var urlString = this.appConfig.baseURL+'/index.cfm/?slatAction=api:main.getResourceBundle&instantiationKey='+this.appConfig.instantiationKey+'&locale='+locale;

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
        },(error) =>{
        });
        return resourceBundlePromises;

    }
    

//    bootstrapApplication = ()=> {
//        angular.element(document).ready(function() {
//            angular.bootstrap(document, [loggermodule.name,slatwalladminmodule.name], {
//            //strictDi: true
//
//          });
//
//        });
//
//    }
} 

export = new bootstrapper();



