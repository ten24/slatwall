/// <reference path="../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../client/typings/slatwallTypeScript.d.ts" />

import slatwalladmin = require("slatwalladmin");
import {auto as ngAuto} from "angular";

module logger{

	export interface IExceptionThrown {
		paramException: error, 
		cause: string
	}; 

	export class ClientLoggingService implements ng.IExceptionHandlerService {

		static $inject = ["$injector"];

		constructor($injector: ngAuto.IInjectorService) {
            this.$injector = $injector; 
        }

   		public exception: ng.IExceptionHandlerService = (paramException: Error, cause?: string):func => {
			return function():IExceptionThrown{ 
				var $http = this.$injector.get('$http');
	            var alertService = this.$injector.get('alertService');
		      	
		      	$http({
		        	url:'?slatAction=api:main.log',
		        	method:'POST', 
		        	data:$.param({
	                    exception:paramException,
	                    cause:cause,
	                    apiRequest:true
	                }),
		        	headers:{'Content-Type': 'application/x-www-form-urlencoded'}
		        }).error(function(data){
	                alertService.addAlert({msg:paramException,type:'error'});
	           	    console.log(paramException);
	            });
	    	};	
    	};
    	
	}
	angular.module('logger').factory('$exceptionHandler', ["$injector", ($injector) => new ClientLoggingService($injector)]);
}
