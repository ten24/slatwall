/// <reference path="../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../client/typings/slatwallTypeScript.d.ts" />

module logger{
	angular.module('logger')
	.factory('$exceptionHandler', [ '$injector', function ($injector) {
	    return function (exception, cause) {
	    	var $http = $injector.get('$http');
	        $http({
	        	url:'?slatAction=admin:error&ajaxRequest=true&exception=ClientSideException',
	        	method:'POST', 
	        	data:{
	        		"exception":exception,
	        		"cause":cause
	        	},
	        	headers:{'Content-Type':'application/json'}
	        });
	    }
	}]);
}