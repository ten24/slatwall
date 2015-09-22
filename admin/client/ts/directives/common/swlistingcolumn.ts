/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />


module slatwalladmin {
    'use strict';
    
    export class SWListingColumnController{
        
        constructor(private partialsPath, private utilityService:slatwalladmin.UtilityService, private $slatwall:ngSlatwall.SlatwallService){
            console.log('ListingColumn');
			this.$slatwall = $slatwall;
			this.utilityService = utilityService;
			//need to perform init after promise completes
			this.init();
            
        }
        
        public init = () =>{
            this.editable = this.editable || false;
        }
		
    }
        
	export class SWListingColumn implements ng.IDirective{
		public restrict:string = 'EA';
        public scope={}; 
		public bindToController={
            propertyIdentifier:"@",
            processObjectProperty:"@",
            title:"@",
            tdclass:"@",
            search:"=",
            sort:"=",
            filter:"=",
            range:"=",
            editable:"=",
            buttonGroup:"="
        };
        public controller=SWListingColumnController;
        public controllerAs="swListingColumn";
		public templateUrl;
        
		constructor(private partialsPath:slatwalladmin.partialsPath,private utiltiyService:slatwalladmin.UtilityService,private $slatwall:ngSlatwall.SlatwallService){
            this.templateUrl = partialsPath+'listingcolumn.html';
		}
		
		public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
		}
	}
    
	angular.module('slatwalladmin').directive('swListingColumn',['partialsPath','utilityService','$slatwall',(partialsPath,utilityService,$slatwall) => new SWListingColumn(partialsPath,utilityService,$slatwall)]);
}

