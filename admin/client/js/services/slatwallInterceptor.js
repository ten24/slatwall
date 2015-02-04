'use strict';
angular.module('slatwalladmin')
.factory('slatwallInterceptor',[
	'$q',
	'$log',
	'alertService',
	function(
		$q,
		$log,
		alertService
	){
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
				$log.debug('requestError');
				return $q.reject(rejection);
			},
			'responseError':function(rejection){
				$log.debug('responseReject');
				//$log.debug(rejection);
				
				
				if(angular.isDefined(rejection.data.messages)){
					var messages = rejection.data.messages;
					var alerts = alertService.formatMessagesToAlerts(messages);
					alertService.addAlerts(alerts);
				}else{
					var message = {
						msg:'there was error retrieving data',
						type:'error'
					};
					alertService.addAlert(message);
				}
				
				return $q.reject(rejection);
			},
		};
		return interceptor;
	}
]);
