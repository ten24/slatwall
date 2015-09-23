/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />


module slatwalladmin {
    'use strict';
    
    export class SWListingColumnController{
        public static $inject = ['partialsPath','utilityService','$slatwall'];
        constructor(
            private partialsPath, 
            private utilityService:slatwalladmin.UtilityService, 
            private $slatwall:ngSlatwall.SlatwallService
        ){
			this.$slatwall = $slatwall;
			this.utilityService = utilityService;
            console.log('ListingColumn');
            console.log(this);
			//need to perform init after promise completes
			this.init();
            
        }
        
        public init = () =>{
            this.editable = this.editable || false;
            // var column ={
            //     propertyIdentifier:this.proopertyIdentifier    
            // }
            // this.swListingDisplay.columns(column);
        }
		
    }
        
	export class SWListingColumn implements ng.IDirective{
		public restrict:string = 'EA';
        //public bindToController=true;
        // public scope = {
        //     propertyIdentifier:"@",
        //     processObjectProperty:"@",
        //     title:"@",
        //     tdclass:"@",
        //     search:"=",
        //     sort:"=",
        //     filter:"=",
        //     range:"=",
        //     editable:"=",
        //     buttonGroup:"="    
        // };
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
        public static $inject = ['partialsPath','utilityService','$slatwall'];
		constructor(private partialsPath:slatwalladmin.partialsPath,private utiltiyService:slatwalladmin.UtilityService,private $slatwall:ngSlatwall.SlatwallService,private $scope){
            console.log('listing column constructor');
            console.log(this);
		}
		
		public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes, swListingDisplay) =>{
            //this.swListingDisplay = swListingDisplay;
            // console.log('scopelistingcolumn');
            // console.log(scope);
            // console.log(this);
		}
	}
    
	angular.module('slatwalladmin').directive('swListingColumn',['partialsPath','utilityService','$slatwall',(partialsPath,utilityService,$slatwall) => new SWListingColumn(partialsPath,utilityService,$slatwall)]);
}

