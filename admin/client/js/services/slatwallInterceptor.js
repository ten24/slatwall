angular.module('slatwalladmin')
.factory('slatwallInterceptor',['$q','$log','alertService',function($q,$log,alertService){
	var interceptor = {
		'request':function(config){
			return config;
		},
		'response':function(response){
			var messages = response.data.messages;
			var alerts = alertService.formatMessagesToAlerts(messages);
			alertService.addAlerts(alerts);
			return response;
		},
		'requestError':function(rejection){
			return rejection;
		},
		'responseError':function(rejection){
			$log.debug('responseReject');
			$log.debug(rejection);
			if(angular.isDefined(rejection.data.messages)){
				var messages = rejection.data.messages;
				var alerts = alertService.formatMessagesToAlerts(messages);
				alertService.addAlerts(alerts);
			}
			
			return rejection;
		},
	};
	return interceptor;
}]);
