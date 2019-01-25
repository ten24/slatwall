/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
import {Injectable,Inject} from "@angular/core";
import {LocalStorageService} from "./localstorageservice";
import {AlertService} from "../../alert/service/alertservice";
import {DialogService} from "../../dialog/services/dialogservice";
import {UtilityService} from "./utilityservice";
import {HibachiPathBuilder} from './hibachipathbuilder';
import {ObserverService} from './observerservice';
import {AppConfig} from "../../../../../../admin/client/src/app.provider";

export interface IHibachiConfig{
    baseURL;
    debugFlag;
    instantiationKey;
}
export interface IHibachi{
    getConfig():IHibachiConfig;
}
export interface HibachiJQueryStatic extends JQueryStatic{
    hibachi:IHibachi
}
declare var $:HibachiJQueryStatic;

export interface IInterceptor {
    request: Function;
    requestError: Function;
    response: Function;
    responseError: Function;
}

interface IParams{
    serializedJsonData?:any,
    context?:string,

}

export interface IHibachiInterceptorPromise<T> extends ng.IPromise<any>{
    data:any;
    status:number;
}


@Injectable()
export class HibachiInterceptor implements IInterceptor{

    /*public static Factory() {
        var eventHandler = (
            $location:ng.ILocationService,
            $q:ng.IQService,
            $log:ng.ILogService,
            $rootScope,
            $window,
            $injector:ng.auto.IInjectorService,
            localStorageService,
            alertService,
            appConfig:string,
            dialogService,
            utilityService,
            hibachiPathBuilder,
            observerService
        )=> new HibachiInterceptor(
            $location,
            $q,
            $log,
            $rootScope,
            $window,
            $injector,
            localStorageService,
            alertService,
            appConfig,
            dialogService,
            utilityService,
            hibachiPathBuilder,
            observerService
        );
        eventHandler.$inject = [
            '$location',
            '$q',
            '$log',
            '$rootScope',
            '$window',
            '$injector',
            'localStorageService',
            'alertService',
            'appConfig',
            'dialogService',
            'utilityService',
            'hibachiPathBuilder',
            'observerService'
        ];
        return eventHandler;
    }*/

    public urlParam = null;
    public authHeader = 'Authorization';
    public authPrefix = 'Bearer ';
    public baseUrl:string;
    
    constructor(
        @Inject("$location") public $location:ng.ILocationService,
        @Inject("$q") public $q:ng.IQService,
        @Inject("$log") public $log:ng.ILogService,
        @Inject("$rootScope") public $rootScope,
        @Inject("$window") public $window,
        @Inject("$injector") public $injector:ng.auto.IInjectorService,
        public localStorageService : LocalStorageService,
        public alertService : AlertService,
        public appConfig : AppConfig,
        public dialogService : DialogService,
        public utilityService : UtilityService,
        public hibachiPathBuilder : HibachiPathBuilder,
        public observerService : ObserverService
    ) {

        this.$location = $location;
        this.$q = $q;
        this.$log = $log;
        this.$rootScope = $rootScope;
        this.$window = $window;
        this.$injector = $injector;
        this.localStorageService = localStorageService;
        this.alertService = alertService;
        this.appConfig = appConfig;
        this.dialogService = dialogService;
        this.utilityService = utilityService;
        this.hibachiPathBuilder = hibachiPathBuilder;
        this.baseUrl = appConfig.baseURL;
    }
    
    public getJWTDataFromToken = (function(ref) {
            return function (str):void {
            // Going backwards: from bytestream, to percent-encoding, to original string.
            str = str.split('.')[1];
            var decodedString = decodeURIComponent(ref.$window.atob(str).split('').map((c)=> {
                return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
            }).join(''));
            
            var jwtData = angular.fromJson(decodedString);
            var now = +new Date();
            var nowString = now.toString().substr(0,jwtData.exp.toString().length);
            now = +nowString;
            if(jwtData.issuer && jwtData.issuer == ref.$window.location.hostname && jwtData.exp > now){
                if(!ref.$rootScope.slatwall.account){
                    ref.$rootScope.slatwall.account = {};
                }
                ref.$rootScope.slatwall.account.accountID = jwtData.accountid;
            }
        }
    })(this);
    
    public request = (function (ref) {

        return function (config): ng.IPromise<any> {
            ref.$log.debug('request');
            //bypass interceptor rules when checking template cache
            if (config.url.charAt(0) !== '/') {
                return config;
            }

            if (config.method == 'GET' && config.url.indexOf('.html') >= 0 && config.url.indexOf('/') >= 0) {
                //all partials are bound to instantiation key
                config.url = config.url + '?instantiationKey=' + ref.appConfig.instantiationKey;

                return config;
            }
            config.cache = true;
            config.headers = config.headers || {};
            if (ref.localStorageService.hasItem('token')) {
                config.headers['Auth-Token'] = 'Bearer ' + ref.localStorageService.getItem('token');
                ref.getJWTDataFromToken(ref.localStorageService.getItem('token'));
            }
            var queryParams = ref.utilityService.getQueryParamsFromUrl(config.url);
            if (config.method == 'GET' && (queryParams[ref.appConfig.action] && queryParams[ref.appConfig.action] === 'api:main.get')) {
                ref.$log.debug(config);
                config.method = 'POST';
                config.data = {};
                var data = {};
                if (angular.isDefined(config.params)) {
                    data = config.params;
                }
                var params: IParams = {};
                params.serializedJsonData = angular.toJson(data);
                params.context = "GET";
                config.data = $.param(params);
                delete config.params;
                config.headers['Content-Type'] = 'application/x-www-form-urlencoded';
            }else if((queryParams[ref.appConfig.action] && queryParams[ref.appConfig.action].indexOf('api:main.get')!==-1)){
                if(queryParams && !queryParams['context']){    
                    if(!config.data){
                        config.data = {};
                    }
                    config.data.context = 'GET';
                }
             }

            return config;
        }
    })(this);
    
    public requestError = (function(ref) {
            return function(rejection): ng.IPromise<any> {
            return ref.$q.reject(rejection);
        }
    })(this);
    
    public response = (function(ref) {
            return function (response): ng.IPromise<any> {
            if(response.data.messages){
                var alerts = ref.alertService.formatMessagesToAlerts(response.data.messages);
                ref.alertService.addAlerts(alerts);
    
            }
    
            if(response.data.hasOwnProperty('token')){
                ref.localStorageService.setItem('token',response.data.token);
            }
            return response;
        }
    })(this);
    
    public responseError = (function(ref) {
        return function(rejection): ng.IPromise<any> {
            
            if(angular.isDefined(rejection.status) && rejection.status !== 404 && rejection.status !== 403 && rejection.status !== 499){
                if(rejection.data && rejection.data.messages){
                    var alerts = ref.alertService.formatMessagesToAlerts(rejection.data.messages);
                    ref.alertService.addAlerts(alerts);
                }else{
                    var message = {
                        msg:'there was error retrieving data',
                        type:'error'
                    };
                    ref.alertService.addAlert(message);
                }
            }
            if(rejection.status === 403 || rejection.status == 401){
                ref.observerService.notify('Unauthorized');
            }
            if (rejection.status === 499) {
                // handle the case where the user is not authenticated
                if(rejection.data && rejection.data.messages){
                    //var deferred = $q.defer();
                    var $http = ref.$injector.get<ng.IHttpService>('$http');
                    if(rejection.data.messages[0].message === 'timeout'){
                        //open dialog
                        ref.dialogService.addPageDialog(ref.hibachiPathBuilder.buildPartialsPath('preprocesslogin'),{} );
                    }else if(rejection.data.messages[0].message === 'invalid_token'){
                        return $http.get(ref.baseUrl+'?'+ref.appConfig.action+'=api:main.login').then((loginResponse:IHibachiInterceptorPromise<any>)=>{
                            if(loginResponse.status === 200){
                                ref.localStorageService.setItem('token',loginResponse.data.token);
                                rejection.config.headers = rejection.config.headers || {};
                                rejection.config.headers['Auth-Token'] = 'Bearer ' + loginResponse.data.token;
                                ref.getJWTDataFromToken(loginResponse.data.token);
                                
                                return $http(rejection.config).then(function(response) {
                                   return response;
                                });
                            }
                        },function(rejection){
                            return rejection;
                        });
                    }
                }
            }
            return rejection;
        }
    })(this);

}

