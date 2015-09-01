/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />


module slatwalladmin {
    'use strict';
    
    export class SWListingDisplayController{
        constructor(){
        }
    }
	
	export class SWListingDisplay implements ng.IDirective{
		
		public restrict:string = 'E';
		public scope = {};
        public bindToController={
            collection:"=",
            collectionConfig:"=",
            isRadio:"=",
            //angularLink:true || false
            angularLinks:"=",
            paginator:"="
        };
        public controller=SWListingDisplayController
        public controllerAs="swListingDisplay";
		public templateUrl;
		
		constructor(private partialsPath:slatwalladmin.partialsPath){
			this.templateUrl = partialsPath+'listingdisplay.html';
		}
		
		public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
			
		}
	}
    
	angular.module('slatwalladmin').directive('swListingDisplay',['partialsPath',(partialsPath) => new SWPaginationBar(partialsPath)]);
}

