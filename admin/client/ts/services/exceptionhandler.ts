/// <reference path="../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../client/typings/slatwallTypeScript.d.ts" />

module logger{
	angular.module('logger')
	.factory('$exceptionHandler', [ '$injector', function ($injector) {
	    return function (exception, cause) {
	    	var $http = $injector.get('$http');

	        $http({
	        	url:'/api/log',
	        	method:'POST', 
	        	data:{
	        		"exception":exception
	        	},
	        	headers:{'Content-Type':'application/json'}

	        }).error(function(data, status, headers, config) {
    				console.error('failure logging client errors to the server');
  				});
	    };
	}]);
}