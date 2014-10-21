//services return promises which can be handled uniquely based on success or failure by the controller

angular.module('slatwalladmin.services')
.factory('alertService',[ '$timeout',
function($timeout){
	var _alerts = [];
	
	return factory = {
		addAlert: function(alert){
			_alerts.push(alert);
			$timeout(function() {
		      _alerts.splice(0,1);
		    }, 3500);
		},
		addAlerts: function(alerts){
			for(alert in alerts){
				_alerts.push(alerts[alert]);
				$timeout(function() {
			      _alerts.splice(0,1);
			    }, 3500);
			}
		},
		formatMessagesToAlerts: function(messages){
			var alerts = [];
			for(message in messages){
				var alert = {
					msg:messages[message].message,
					type:messages[message].messageType
				};
				alerts.push(alert);
				if(alert.type === 'success' || alert.type === 'error'){
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
		},
		getAlerts: function(){
			return _alerts;
		},
		removeAlert:function(alert){
			for(i in _alerts){
				if(_alerts[i] === alert){
					delete _alerts[i];
				}
			}
		},
		removeOldestAlert:function(){
			console.log('removeoldest');
			_alert.splice(0,1);
		}
	};
}]);
