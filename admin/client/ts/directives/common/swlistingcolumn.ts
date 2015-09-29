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
       // public scope={}; 
//	   public bindToController={
//           propertyIdentifier:"@",
//           processObjectProperty:"@",
//           title:"@",
//           tdclass:"@",
//           search:"=",
//           sort:"=",
//           filter:"=",
//           range:"=",
//           editable:"=",
//           buttonGroup:"="
//       };
        public controller=SWListingColumnController;
        public controllerAs="swListingColumn";
        
		constructor(){
            
		}
		
		public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
            
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

