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
}



class HibachiInterceptor implements IInterceptor{

	public static Factory() {
        var eventHandler = (
			$location:ng.ILocationService,
			$window:ng.IWindowService ,
			$q:ng.IQService,
			$log:ng.ILogService,
			$injector:ng.auto.IInjectorService,
			alertService,
			appConfig:string,
			dialogService,
			utilityService,
            hibachiPathBuilder
		)=> new HibachiInterceptor(
			$location,
			$window,
			$q,
			$log,
			$injector,
			alertService,
			appConfig,
			dialogService,
			utilityService,
            hibachiPathBuilder
		);
		eventHandler.$inject = [
			'$location',
			'$window',
			'$q',
			'$log',
			'$injector',
			'alertService',
			'appConfig',
			'dialogService',
			'utilityService',
            'hibachiPathBuilder'
		];
		return eventHandler;
	}

    public urlParam = null;
    public authHeader = 'Authorization';
    public authPrefix = 'Bearer ';
    public baseUrl:string;
	//@ngInject
    constructor(
        public $location:ng.ILocationService,
		public $window:ng.IWindowService,
		public $q:ng.IQService,
		public $log:ng.ILogService,
		public $injector:ng.auto.IInjectorService,
		public alertService,
		public appConfig:any,
		public dialogService,
        public utilityService,
        public hibachiPathBuilder
	) {
        this.$location = $location;
    	this.$window = $window;
		this.$q = $q;
		this.$log = $log;
		this.$injector = $injector;
		this.alertService = alertService;
		this.appConfig = appConfig;
        this.baseUrl = appConfig.baseURL;
		this.dialogService = dialogService;
        this.utilityService = utilityService;
        this.hibachiPathBuilder = hibachiPathBuilder;
    }

	public request = (config): ng.IPromise<any> => {
        this.$log.debug('request');
        //bypass interceptor rules when checking template cache
        if(config.url.charAt(0) !== '/'){
            return config;
        }
        if(config.method == 'GET' && config.url.indexOf('.html') > 0 && config.url.indexOf('admin/client/partials') > 0) {
            //all partials are bound to instantiation key
            config.url = config.url + '?instantiationKey='+$.hibachi.getConfig().instantiationKey;
            return config;
        }
        config.cache = true;
        config.headers = config.headers || {};
        if (this.$window.localStorage.getItem('token') && this.$window.localStorage.getItem('token') !== "undefined") {

            config.headers.Authorization = 'Bearer ' + this.$window.localStorage.getItem('token');
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
		}

		return config;
    }
    public requestError = (rejection): ng.IPromise<any> => {
         this.$log.debug('requestError');
		return this.$q.reject(rejection);
    }
    public response = (response): ng.IPromise<any> => {
        this.$log.debug('response');
		console.log(response);
		if(response.data.messages){
            var alerts = this.alertService.formatMessagesToAlerts(response.data.messages);
            this.alertService.addAlerts(alerts);

        }
		return response;
    }
    public responseError = (rejection): ng.IPromise<any> => {

		this.$log.debug('responseReject');
		if(angular.isDefined(rejection.status) && rejection.status !== 404 && rejection.status !== 403 && rejection.status !== 499){
			if(rejection.data && rejection.data.messages){
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
		if (rejection.status === 499) {
			// handle the case where the user is not authenticated
			if(rejection.data && rejection.data.messages){
				//var deferred = $q.defer();
				var $http = this.$injector.get<ng.IHttpService>('$http');
				if(rejection.data.messages[0].message === 'timeout'){
					//open dialog
					this.dialogService.addPageDialog(this.hibachiPathBuilder.buildPartialsPath('preprocesslogin'),{} );
				}else if(rejection.data.messages[0].message === 'invalid_token'){
                    return $http.get(this.baseUrl+'/index.cfm/api/auth/login').then((loginResponse:IHibachiInterceptorPromise<any>)=>{
                        this.$window.localStorage.setItem('token',loginResponse.data.token);
                        rejection.config.headers = rejection.config.headers || {};
                        rejection.config.headers.Authorization = 'Bearer ' + this.$window.localStorage.getItem('token');
                        return $http(rejection.config).then(function(response) {
                           return response;
                        });
					},function(rejection){
                        return rejection;
                    });
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