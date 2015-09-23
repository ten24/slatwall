/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />


module slatwalladmin {
    'use strict';
    
    export class SWListingColumnController{
        public static $inject = ['$scope','utilityService','$slatwall'];
        constructor(
            private $scope,
            private utilityService:slatwalladmin.UtilityService, 
            private $slatwall:ngSlatwall.SlatwallService
        ){
            this.$scope = $scope;
			this.$slatwall = $slatwall;
			this.utilityService = utilityService;
            console.log('ListingColumn');
            console.log(this);
            
            
            
            // if(angular.isUndefined(this.$scope.$parent.$parent.swListingDisplay.columns)){
            //     this.$scope.$parent.$parent.swListingDisplay.columns = [];
            // }
            // if(!this.$scope.$parent.$parent.swListingDisplay.columns){
            //     this.$scope.$parent.$parent.swListingDisplay.columns = [];
            // }
            
            // this.$scope.$parent.$parent.swListingDisplay.columns.push(column);
			//need to perform init after promise completes
            
            
			this.init();
            
        } 
        
        public init = () =>{
            this.editable = this.editable || false;
            
        }
		
    }
        
	export class SWListingColumn implements ng.IDirective{
	   public restrict:string = 'EA';
       // public scope={}; 
	   // public bindToController={
        //    propertyIdentifier:"@",
        //    processObjectProperty:"@",
        //    title:"@",
        //    tdclass:"@",
        //    search:"=",
        //    sort:"=",
        //    filter:"=",
        //    range:"=",
        //    editable:"=",
        //    buttonGroup:"="
       // };
        public controller=SWListingColumnController;
        public controllerAs="swListingColumn";
        
		constructor(){
            console.log('column cons');
		}
		
		public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
            console.log('column scope');
            console.log(scope);
            var column = {
                propertyIdentifier:scope.propertyIdentifier,
                processObjectProperty:scope.processObjectProperty,
                title:scope.title,
                tdclass:scope.tdclass,
                search:scope.search,
                sort:scope.sort,
                filter:scope.filter,
                range:scope.range,
                editable:scope.editable,
                buttonGroup:scope.buttonGroup
            };
            scope.swListingDisplay.columns.push(column);
            
		}
	}
    
	angular.module('slatwalladmin').directive('swListingColumn',[() => new SWListingColumn()]);
}

