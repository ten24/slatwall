/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />


module slatwalladmin {
    'use strict';
    
    export class SWListingColumnController{
        constructor(
            
        ){
            this.init();
        } 
        
        public init = () =>{
            this.editable = this.editable || false;
        }
    }
        
	export class SWListingColumn implements ng.IDirective{
	   public restrict:string = 'EA';
       public scope=true; 
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
        public static $inject = ['utilityService'];
		constructor(private utilityService){
            
		}
		
		public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
            
            var column = {
                propertyIdentifier:scope.swListingColumn.propertyIdentifier,
                processObjectProperty:scope.swListingColumn.processObjectProperty,
                title:scope.swListingColumn.title,
                tdclass:scope.swListingColumn.tdclass,
                search:scope.swListingColumn.search,
                sort:scope.swListingColumn.sort,
                filter:scope.swListingColumn.filter,
                range:scope.swListingColumn.range,
                editable:scope.swListingColumn.editable,
                buttonGroup:scope.swListingColumn.buttonGroup
            };
            if(utilityService.ArrayFindByPropertyValue(scope.$parent.swListingDisplay.columns,'propertyIdentifier',column.propertyIdentifier) === -1){
                scope.$parent.swListingDisplay.columns.push(column);
            }
		}
	}
    
	angular.module('slatwalladmin').directive('swListingColumn',['utilityService',(utilityService) => new SWListingColumn(utilityService)]);
}

