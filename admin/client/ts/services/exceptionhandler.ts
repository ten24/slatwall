/// <reference path="../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../client/typings/slatwallTypeScript.d.ts" />

module logger{
	angular.module('logger')
	.factory('$exceptionHandler', function () {
	    return function (exception, cause) {
	        alert(exception.message);
	    };
	});
}