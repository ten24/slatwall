//services return promises which can be handled uniquely based on success or failure by the controller

angular.module('slatwalladmin.services')
.factory('alertService',[ '$rootScope',
function($rootScope){
	console.log($rootScope.alerts);
	return factory = {
		addAlert: function(alert){
			$rootScope.alerts.push(alert);
			console.log($rootScope.alerts);
		},
		addAlerts: function(alerts){
			console.log(alerts);
			for(alert in alerts){
				$rootScope.alerts.push(alerts[alert]);
			}
		},
		formatMessagesToAlerts: function(messages){
			var alerts = [];
			for(message in messages){
				var alert = {
					msg:messages[message].MESSAGE,
					type:messages[message].TYPE
				};
				alerts.push(alert);
			}
			console.log(alerts);
			return alerts;
		}
	};
}]);
