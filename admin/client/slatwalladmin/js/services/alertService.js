//services return promises which can be handled uniquely based on success or failure by the controller

angular.module('slatwalladmin.services')
.factory('alertService',[ '$rootScope','$timeout',
function($rootScope,$timeout){
	return factory = {
		addAlert: function(alert){
			$rootScope.alerts.push(alert);
		},
		addAlerts: function(alerts){
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
				if(alert.type === 'success' || alert.type === 'danger'){
					 $timeout(function() {
				      alert.fade = true;
				    }, 3500);
				    alert.dismissable = false;
				}else{
					alert.fade = false;
					alert.dismissable = true;
				}
			}
			return alerts;
		}
	};
}]);
