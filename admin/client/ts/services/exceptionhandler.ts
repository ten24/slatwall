/// <reference path="../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../client/typings/slatwallTypeScript.d.ts" />

module logger { 

  exceptionHandlerProvider.$inject = ["$injector"]

  function exceptionHandlerProvider($injector, exception:any, cause:any) { 
	  return function(exception: any, cause: any) {
		  var $http = $injector.get('$http');
		  var alertService = $injector.get('alertService');

		  $http({
			  url: '?slatAction=api:main.log',
			  method: 'POST',
			  data: $.param({
				  exception: exception,
				  cause: cause,
				  apiRequest: true
			  }),
			  headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
		  }).error(function(data) {
			  alertService.addAlert({ msg: exception, type: 'error' });
			  console.log(exception);
		  });
	  };
  }

  angular.module('logger').factory('$exceptionHandler', exceptionHandlerProvider);

}
