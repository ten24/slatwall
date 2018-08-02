/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
import {Injectable, Inject} from "@angular/core";
import {LocalStorageService} from "./localstorageservice";
import {AlertService} from "../../alert/service/alertservice";
import {DialogService} from "../../dialog/services/dialogservice";
import {UtilityService} from "./utilityservice";
import {HibachiPathBuilder} from './hibachipathbuilder';
import {ObserverService} from './observerservice';
import {AppConfig} from "../../../../../../admin/client/src/app.provider";
import {    XHRBackend,
            ConnectionBackend, 
            RequestOptions, 
            Request, 
            RequestOptionsArgs, 
            Response, 
            Http, 
            Headers, 
            RequestMethod,
            URLSearchParams} from '@angular/http';
import {Observable} from "rxjs/Rx";
import 'rxjs/add/operator/catch';


@Injectable()
export class HttpInterceptor extends Http {
    public urlParam = null;
    public authHeader = 'Authorization';
    public authPrefix = 'Bearer ';
    public baseUrl: string;

    constructor(
        private backend: XHRBackend,
        private defaultOptions: RequestOptions,
        @Inject("$location") public $location: ng.ILocationService,
        @Inject("$q") public $q: ng.IQService,
        @Inject("$log") public $log: ng.ILogService,
        @Inject("$rootScope") public $rootScope,
        @Inject("$window") public $window,
        @Inject("$injector") public $injector: ng.auto.IInjectorService,
        public localStorageService: LocalStorageService,
        public alertService: AlertService,
        public appConfig: AppConfig,
        public dialogService: DialogService,
        public utilityService: UtilityService,
        public hibachiPathBuilder: HibachiPathBuilder,
        public observerService: ObserverService,

    ) {
        super(backend, defaultOptions);
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

    private getJWTDataFromToken(str): void {
        // Going backwards: from bytestream, to percent-encoding, to original string.
        str = str.split('.')[1];
        var decodedString = decodeURIComponent(this.$window.atob(str).split('').map((c) => {
            return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
        }).join(''));

        var jwtData = angular.fromJson(decodedString);
        var now = +new Date();
        var nowString = now.toString().substr(0, jwtData.exp.toString().length);
        now = +nowString;
        if (jwtData.issuer && jwtData.issuer == this.$window.location.hostname && jwtData.exp > now) {
            if (!this.$rootScope.slatwall.account) {
                this.$rootScope.slatwall.account = {};
            }
            this.$rootScope.slatwall.account.accountID = jwtData.accountid;
        }
    }
    
    request(config: string|Request, options?: RequestOptionsArgs): Observable<Response>  {
        if (typeof config === 'string') { // meaning we have to add the token to the options, not in url
            if (!options) {
                // let's make option object
                options = {headers: new Headers()};
            }
            options.headers.set('Accept', `application/json, text/plain, */*`);
            //bypass interceptor rules when checking template cache
            if (config.charAt(0) !== '/') {
                return super.request(config, options);
            }
        } 
        else {
            // we have to add the token to the url object
            config.headers.set('Accept', 'application/json, text/plain, */*');
            //bypass interceptor rules when checking template cache
            if (config.url.charAt(0) !== '/') {
                return super.request(config, options);
            }
            if (config.method === RequestMethod.Get && config.url.indexOf('.html') >= 0 && config.url.indexOf('/') >= 0) {
                //all partials are bound to instantiation key
                config.url = config.url + '?instantiationKey=' + this.appConfig.instantiationKey;
                return super.request(config, options);
            }
            
            if (this.localStorageService.hasItem('token')) {
                config.headers.set('Auth-Token', 'Bearer ' + this.localStorageService.getItem('token'));
                this.getJWTDataFromToken(this.localStorageService.getItem('token'));
            }
            var queryParams = this.utilityService.getQueryParamsFromUrl(config.url);
            if (config.method === RequestMethod.Get && (queryParams[this.appConfig.action] && queryParams[this.appConfig.action] === 'api:main.get')) {
                this.$log.debug(config);
                config.method = RequestMethod.Post;
                config["_body"] = {};
                var data = {};
                if (angular.isDefined(config['params'])) {
                    data = config['params'];
                }
                var params = { 'serializedJsonData' : angular.toJson(data), 'context' : 'GET'  };
                config['_body'] = $.param(params);
                delete config['params'];
                config.headers.set('Content-Type', 'application/x-www-form-urlencoded');
            }
            else if((queryParams[this.appConfig.action] && queryParams[this.appConfig.action].indexOf('api:main.get')!==-1)){
                if(!config["_body"]){
                    config["_body"] = {};
                }
                config["_body"] = { context : 'GET' };
            }
        }
            
        return super.request(config, options);//.catch(console.log("error"));
    }
    
    get(url: string, options?: RequestOptionsArgs): Observable<any> {
        return super.get(url, options)
            .catch(this.onCatch)
            .do((res:Response)=>{
                this.onSuccess(res);
            },(error:any) => {
                this.onError(error,RequestMethod.Get);
            });
    }
    
    post(url: string, body: string, options?: RequestOptionsArgs): Observable<any> {
        return super.post(url,body, options)
            .catch(this.onCatch)
            .do((res:Response)=>{
                this.onSuccess(res);
            },(error:any) => {
                this.onError(error,RequestMethod.Post);
            });
    }
    
    delete(url: string, options?: RequestOptionsArgs): Observable<any> {
        return super.delete(url, options)
            .catch(this.onCatch)
            .do((res:Response)=>{
                this.onSuccess(res);
            },(error:any) => {
                this.onError(error,RequestMethod.Delete);
            });
    }
    
    put(url: string, body: string, options?: RequestOptionsArgs): Observable<any> {
        return super.put(url,body, options)
            .catch(this.onCatch)
            .do((res:Response)=>{
                this.onSuccess(res);
            },(error:any) => {
                this.onError(error, RequestMethod.Put);
            });
    }
    
    private onSuccess(response: Response): void {
        if(response["_body"].messages) {
            var alerts = this.alertService.formatMessagesToAlerts(response["_body"].messages);
            this.alertService.addAlerts(alerts);
        }
        if(response["_body"].hasOwnProperty('token')){
            this.localStorageService.setItem('token',response["_body"].token);
        }
    }
    
    private onError(rejection: any,requestMethod:RequestMethod): any {
        if(rejection.status !== undefined && rejection.status !== 404 && rejection.status !== 403 && rejection.status !== 499){
            if(rejection["_body"] && rejection["_body"].messages){
                var alerts = this.alertService.formatMessagesToAlerts(rejection["_body"].messages);
                this.alertService.addAlerts(alerts);
            }else{
                var message = {
                    msg:'there was error retrieving data',
                    type:'error'
                };
                this.alertService.addAlert(message);
            }
        }
        if(rejection.status === 403 || rejection.status == 401){
            this.observerService.notify('Unauthorized');
        }
        if (rejection.status === 499) {
            rejection["_body"] = JSON.parse(rejection["_body"]);
            // handle the case where the user is not authenticated
            if(rejection["_body"] && rejection["_body"].messages){
                //var deferred = $q.defer();
                if(rejection["_body"].messages[0].message === 'timeout'){
                    //open dialog
                    this.dialogService.addPageDialog(this.hibachiPathBuilder.buildPartialsPath('preprocesslogin'),{} );
                }else if(rejection["_body"].messages[0].message === 'invalid_token'){
                    return this.get(this.baseUrl+'?'+this.appConfig.action+'=api:main.login').subscribe((loginResponse)=>{
                        if(loginResponse.status === 200){
                            loginResponse["_body"] = JSON.parse(loginResponse["_body"]);
                            this.localStorageService.setItem('token',loginResponse["_body"].token);
                            var request_new = new Request({url:rejection.url,method:requestMethod});
                            request_new.headers.set('Auth-Token', 'Bearer ' + loginResponse["_body"].token);
                            this.getJWTDataFromToken(loginResponse["_body"].token);
                            request_new["_body"] = rejection["_body"];
                            
                            return this.request(request_new).subscribe(function(response) {
                                return response;
                            });
                        }
                    });
                }
            }
        }
    }
    
    private onCatch(error: any, caught: Observable<any>): Observable<any> {
        return Observable.throw(error);
    }
    
}