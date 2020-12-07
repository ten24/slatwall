/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
interface IHibachiConfig{
    baseURL;
    debugFlag;
	instantiationKey;
}
interface IHibachi{
    getConfig():IHibachiConfig;
}
interface HibachiJQueryStatic extends JQueryStatic{
    hibachi:IHibachi
}
declare var $:HibachiJQueryStatic;

interface IInterceptor {
    request: Function;
    requestError: Function;
    response: Function;
    responseError: Function;
}

interface IParams{
	serializedJsonData?:any,
	context?:string,

}

interface IHibachiInterceptorPromise<T> extends ng.IPromise<any>{
	data:any;
    status:number;
}



class HibachiInterceptor implements IInterceptor{

	public static Factory() {
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
			token:string,
			dialogService,
			utilityService,
            hibachiPathBuilder,
            observerService,
            hibachiAuthenticationService
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
			token,
			dialogService,
			utilityService,
            hibachiPathBuilder,
            observerService,
            hibachiAuthenticationService
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
			'token',
			'dialogService',
			'utilityService',
            'hibachiPathBuilder',
            'observerService',
            'hibachiAuthenticationService'
		];
		return eventHandler;
	}
    public urlParam = null;
    public authHeader = 'Authorization';
    public authPrefix = 'Bearer ';
    public baseUrl:string;
    public loginResponse=null;
    public authPromise=null;
	//@ngInject
    constructor(
        public $location:ng.ILocationService,
		public $q:ng.IQService,
		public $log:ng.ILogService,
		public $rootScope,
		public $window,
		public $injector:ng.auto.IInjectorService,
		public localStorageService,
		public alertService,
		public appConfig:any,
		public token:string,
		public dialogService,
        public utilityService,
        public hibachiPathBuilder,
        public observerService,
        public hibachiAuthenticationService
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
		this.token = token;
		this.dialogService = dialogService;
        this.utilityService = utilityService;
        this.hibachiPathBuilder = hibachiPathBuilder;
        this.baseUrl = appConfig.baseURL;
        this.hibachiAuthenticationService = hibachiAuthenticationService;
    }
    
    public getJWTDataFromToken = ():void =>{
	    this.hibachiAuthenticationService.getJWTDataFromToken(this.token);
	}
	
    
	public request = (config): ng.IPromise<any> => {
        this.$log.debug('request');
        
        //bypass interceptor rules when checking template cache
        if(config.url.charAt(0) !== '/'){
            return config;
        }

        if(config.method == 'GET' && config.url.indexOf('.html') >= 0 && config.url.indexOf('/') >= 0)  {
            //all partials are bound to instantiation key
            config.url = config.url + '?instantiationKey='+this.appConfig.instantiationKey;

            return config;
        }
        config.cache = true;
        config.headers = config.headers || {};
        if(this.token){
        	config.headers['Auth-Token'] = 'Bearer ' + this.token;
            this.getJWTDataFromToken();
        }
        var queryParams = this.utilityService.getQueryParamsFromUrl(config.url);
		if(config.method == 'GET' && (queryParams[this.appConfig.action] && queryParams[this.appConfig.action] === 'api:main.get')){
            this.$log.debug(config);
			config.method = 'POST';
			config.data = {};
			var data = {};
			if(angular.isDefined(config.params)){
				data = config.params;
			}
			var params:IParams = {};
			params.serializedJsonData = angular.toJson(data);
			params.context="GET";
			config.data = $.param(params);
			delete config.params;
			config.headers['Content-Type']= 'application/x-www-form-urlencoded';
		}else if((queryParams[this.appConfig.action] && queryParams[this.appConfig.action].indexOf('api:main.get')!==-1)){
			
			if(queryParams && !queryParams['context']){
				if(!config.data){
					config.data = {};
				}
				config.data.context = 'GET';
			}
 		}

		return config;
    }
    public requestError = (rejection): ng.IPromise<any> => {
		return this.$q.reject(rejection);
    }
    public response = (response): ng.IPromise<any> => {
		if(response.data.messages){
            var alerts = this.alertService.formatMessagesToAlerts(response.data.messages);
            this.alertService.addAlerts(alerts);

        }

		return response;
    }
    public responseError = (rejection): ng.IPromise<any> => {
    	
		if(angular.isDefined(rejection.status) && rejection.status !== 404 && rejection.status !== 403 && rejection.status !== 499){
			if (rejection.data && rejection.data.errors) {
				var messages = {
					msg: rejection.data.errors[Object.keys(rejection.data.errors)[0]],
					type:'error'
				};
				var alerts = this.alertService.addAlert(messages);
				this.alertService.addAlerts(alerts);
			} else if(rejection.data && rejection.data.messages){
				var alerts = this.alertService.formatMessagesToAlerts(rejection.data.messages);
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
			// handle the case where the user is not authenticated
			if(rejection.data && rejection.data.messages){
				//var deferred = $q.defer();
				var $http = this.$injector.get<ng.IHttpService>('$http');
				if(rejection.data.messages[0].message === 'timeout'){
					//open dialog
					this.dialogService.addPageDialog(this.hibachiPathBuilder.buildPartialsPath('preprocesslogin'),{} );
				}else if(rejection.data.messages[0].message === 'invalid_token'){
                    //logic to resolve all 499s in a single login call
                    if(!this.authPromise){
                    	return this.authPromise = $http.get(this.baseUrl+'?'+this.appConfig.action+'=api:main.login').then(  (loginResponse:IHibachiInterceptorPromise<any>)=>{
	                        this.loginResponse=loginResponse;
	                        if(loginResponse.status === 200){
	                            this.hibachiAuthenticationService.jwtToken = loginResponse.data.token;
	                            rejection.config.headers = rejection.config.headers || {};
	                            rejection.config.headers['Auth-Token'] = 'Bearer ' + loginResponse.data.token;
	                            this.token = loginResponse.data.token;
	                            this.getJWTDataFromToken();
	                            return $http(rejection.config).then(function(response) {
	                               return response;
	                            });
	                            
	                        }
						},function(rejection){
	                        return rejection;
	                    });
                    }else{
                    	
                    	return this.authPromise.then(()=>{
                        
                        if(this.loginResponse.status === 200){
                        	
                            rejection.config.headers = rejection.config.headers || {};
                            rejection.config.headers['Auth-Token'] = 'Bearer ' + this.loginResponse.data.token;
                            this.token=this.loginResponse.data.token;
                            this.getJWTDataFromToken();
                            
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
        }
		return rejection;
    }

}
export{
	HibachiInterceptor,
	IInterceptor,
	IHibachi,
	IHibachiConfig,
	HibachiJQueryStatic
};
