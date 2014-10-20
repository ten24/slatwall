//services return promises which can be handled uniquely based on success or failure by the controller
angular.module('slatwalladmin.services')
.factory('slatwallInterceptor',['$q','$log','alertService',function($q,$log,alertService){
	var interceptor = {
		'request':function(config){
			// Successful request method
			$log.debug('request');
			return config;
		},
		'response':function(response){
			// Successful response 
			$log.debug('response');
			$log.debug(response);
			var messages = response.data.MESSAGES;
			var alerts = alertService.formatMessagesToAlerts(messages);
			alertService.addAlerts(alerts);
			return response;
		},
		'requestError':function(rejection){
			$log.debug('requestReject');
			$log.debug(rejection);
			// an error happend during request method
			return rejection;
		},
		'responseError':function(rejection){
			$log.debug('responseReject');
			$log.debug(rejection);
			// an error happened during response
			//display error message if getter fails
			var messages = rejection.data.MESSAGES;
			var alerts = alertService.formatMessagesToAlerts(messages);
			alertService.addAlerts(alerts);
			return rejection;
		},
	};
	return interceptor;
}]);
