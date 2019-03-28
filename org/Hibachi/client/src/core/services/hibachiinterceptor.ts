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
	}

    public urlParam = null;
    public authHeader = 'Authorization';
    public authPrefix = 'Bearer ';
    public baseUrl:string;
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
		public dialogService,
        public utilityService,
        public hibachiPathBuilder,
        public observerService
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
    
    public getJWTDataFromToken = (str):void =>{
	    // Going backwards: from bytestream, to percent-encoding, to original string.
	    str = str.split('.')[1];
	    var decodedString = decodeURIComponent(this.$window.atob(str).split('').map((c)=> {
	        return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
	    }).join(''));
	    
	    var jwtData = angular.fromJson(decodedString);
		var now = +new Date();
		var nowString = now.toString().substr(0,jwtData.exp.toString().length);
		now = +nowString;
		if(jwtData.issuer && jwtData.issuer == this.$window.location.hostname && jwtData.exp > now){
		    if(!this.$rootScope.slatwall.account){
		    	this.$rootScope.slatwall.account = {};
		    }
		    this.$rootScope.slatwall.account.accountID = jwtData.accountid;
    	}
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
        if (this.localStorageService.hasItem('token')) {
            config.headers['Auth-Token'] = 'Bearer ' + this.localStorageService.getItem('token');
            this.getJWTDataFromToken(this.localStorageService.getItem('token'));
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

        if(response.data.hasOwnProperty('token')){
        	this.localStorageService.setItem('token',response.data.token);
        }
		return response;
    }
    public responseError = (rejection): ng.IPromise<any> => {
    	
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
                    return $http.get(this.baseUrl+'?'+this.appConfig.action+'=api:main.login').then((loginResponse:IHibachiInterceptorPromise<any>)=>{
                        if(loginResponse.status === 200){
                            this.localStorageService.setItem('token',loginResponse.data.token);
                            rejection.config.headers = rejection.config.headers || {};
                            rejection.config.headers['Auth-Token'] = 'Bearer ' + loginResponse.data.token;
                            this.getJWTDataFromToken(loginResponse.data.token);
                            
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

}
export{
	HibachiInterceptor,
	IInterceptor,
	IHibachi,
	IHibachiConfig,
	HibachiJQueryStatic
};
