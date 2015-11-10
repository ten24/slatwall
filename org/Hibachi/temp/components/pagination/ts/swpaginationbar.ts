/// <reference path="../../../../typings/tsd.d.ts" />
/// <reference path="../../../../typings/slatwallTypeScript.d.ts" />

module hibachi.pagination {
    'use strict';
    
    export class SWPaginationBarController{
        public paginator;
        constructor(){
            if(angular.isUndefined(this.paginator)){
                this.paginator = hibachi.pagination.PaginationService.createPagination();    
            }
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
		
		constructor(private $log:ng.ILogService, private $timeout:ng.ITimeoutService, private partialsPath, private paginationService ){
			this.templateUrl = partialsPath+'paginationbar.html';
		}
		
		public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
			
		}
	}
    
}

