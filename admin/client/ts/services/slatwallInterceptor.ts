/// <reference path='../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../client/typings/tsd.d.ts' />
module slatwalladmin{
	export interface IInterceptor {
        request: Function;
        requestError: Function;
        response: Function;
        responseError: Function;
    }
	
	export class SlatwallInterceptor implements slatwalladmin.IInterceptor{
		public static $inject = ['$window','$q','$log','alertService'];
		
		public static Factory($window:ng.IWindowService ,$q:ng.IQService,$log:ng.ILogService,alertService:slatwalladmin.IAlertService) {
            return new SlatwallInterceptor($window, $q, $log, alertService);
        }
        
        public urlParam = null;
        public authHeader = 'Authorization';
        public authPrefix = 'Bearer ';

        constructor(public $window:ng.IWindowService, public $q:ng.IQService, public $log:ng.ILogService, public alertService:slatwalladmin.IAlertService) {
        	this.$window = $window;
			this.$q = $q;
			this.$log = $log;
			this.alertService = alertService;
            
        }
        
        public tokenGetter = () =>{
          return null;
        }
		
		public request = (config): ng.IPromise<any> => {
            this.$log.debug('request');
            config.headers = config.headers || {};
            if (this.$window.sessionStorage.token) {
               config.headers.Authorization = 'Bearer ' + this.$window.sessionStorage.token;
            }
            
			if(config.method == 'GET' && (config.url.indexOf('.html') == -1) && config.url.indexOf('.json') == -1){
				config.method = 'POST';
				config.data = {};
				var data = {};
				if(angular.isDefined(config.params)){
					data = config.params;
				}
				var params = {};
				params.serializedJsonData = angular.toJson(data);
				params.context="GET";
				config.data = $.param(params);
				delete config.params;
				config.headers['Content-Type']= 'application/x-www-form-urlencoded';
			}else if(config.method == 'GET' && config.url.indexOf('.html') > 0 && config.url.indexOf('admin/client/partials') > 0) {
				//all partials are bound to instantiation key
				config.url = config.url + '?instantiationKey='+$.slatwall.getConfig().instantiationKey;
			}
			
			return config;
        }
        public requestError = (rejection): ng.IPromise<any> => {
             this.$log.debug('requestError');
			return this.$q.reject(rejection);
        }
        public response = (response): ng.IPromise<any> => {
            this.$log.debug('response');
            if (response.status === 401) {
               // handle the case where the user is not authenticated
            }
              
			var messages = response.data.messages;
			var alerts = this.alertService.formatMessagesToAlerts(messages);
			this.alertService.addAlerts(alerts);
			return response;
        }
        public responseError = (rejection): ng.IPromise<any> => {
           
			this.$log.debug('responseReject');
			if(angular.isDefined(rejection.status) && rejection.status !== 404){
				if(angular.isDefined(rejection.data) && angular.isDefined(rejection.data.messages)){
					var messages = rejection.data.messages;
					var alerts = this.alertService.formatMessagesToAlerts(messages);
					this.alertService.addAlerts(alerts);
				}else{
					var message = {
						msg:'there was error retrieving data',
						type:'error'
					};
					this.alertService.addAlert(message);
				}
			}
			
			return this.$q.reject(rejection);
        }
		
	}
	angular.module('slatwalladmin').service('slatwallInterceptor', SlatwallInterceptor);
}
