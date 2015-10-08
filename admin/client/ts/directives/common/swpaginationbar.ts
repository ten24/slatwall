/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />


module slatwalladmin {
    'use strict';
    
    export class SWPaginationBarController{
        constructor(){
        }
    }
	
	export class SWPaginationBar implements ng.IDirective{
		
		public restrict:string = 'E';
		public scope = {};
        public bindToController={
            paginator:"="    
        };
        public controller=SWPaginationBarController
        public controllerAs="swPaginationBar";
		public templateUrl;
		
		constructor(private $log:ng.ILogService, private $timeout:ng.ITimeoutService, private partialsPath:slatwalladmin.partialsPath, private paginationService:slatwalladmin.paginationService ){
			this.templateUrl = partialsPath+'paginationbar.html';
		}
		
		public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
			
		}
	}
    
	angular.module('slatwalladmin').directive('swPaginationBar',['$log','$timeout','partialsPath','paginationService',($log,$timeout,partialsPath,paginationService) => new SWPaginationBar($log,$timeout,partialsPath,paginationService)]);
}

