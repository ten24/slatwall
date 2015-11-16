/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />


module slatwalladmin {
    'use strict';
    
    export class SWListingGlobalSearchController{
        private searching; 
        private searchText; 
        private savedSearchText; 
        private _timeoutPromise
        
        public static $inject = ['$timeout'];
        
        constructor(
            private $timeout
        ){
            this.init();
        } 
        
        public init = () =>{
            this.searching = false; 
        }
        
        public search = () =>{
            if(this.searchText.length >= 2){
                this.searching = true; 
                
                if(this._timeoutPromise){
					this.$timeout.cancel(this._timeoutPromise); 
				}
                
                this._timeoutPromise = this.$timeout(()=>{
                   this.getCollection();
				}, 500);
            }else if(this.searchText.length === 0){
                this.$timeout(()=>{
                    this.getCollection();
                });
            }
        }
    }
        
	export class SWListingGlobalSearch implements ng.IDirective{
	   public restrict:string = 'EA';
       public scope={}; 
	   public bindToController={
           searching:"=",
           searchText:"=",
           getCollection:"="
       };
        public controller=SWListingGlobalSearchController;
        public controllerAs="swListingGlobalSearch";
        public templateUrl;
        public static $inject = ['utilityService'];
		constructor(private utilityService, private partialsPath){
            this.templateUrl = partialsPath + "listingglobalsearch.html";
		}
		
		public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

		}
	}
    
	angular.module('slatwalladmin').directive('swListingGlobalSearch',['utilityService', 'partialsPath',(utilityService, partialsPath) => new SWListingGlobalSearch(utilityService, partialsPath)]);
}

