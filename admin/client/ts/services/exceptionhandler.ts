/// <reference path="../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../client/typings/slatwallTypeScript.d.ts" />

module logger{
	angular.module('logger')
	.factory('$exceptionHandler', [ '$injector', function ($injector) {
	    return function (exception, cause) {
	    	var $http = $injector.get('$http');
	        $http({
	        	url:'?slatAction=api:main.log',
	        	method:'POST', 
	        	data:{
	        		exception:exception,
	        		cause:cause,
                    apiRequest:true
	        	},
	        	headers:{'Content-Type':'application/json'}
	        });
	    }
	}]);
}