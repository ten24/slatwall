/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />


module slatwalladmin {
    'use strict';
    
    export class SWEntityActionBarButtonGroupController{
        constructor(){
            
        }
    }
	
	export class SWEntityActionBarButtonGroup implements ng.IDirective{
		
		public restrict:string = 'E';
		public scope = {};
        public transclude=true;
        public bindToController={
            
        };
        public controller=SWEntityActionBarButtonGroupController
        public controllerAs="swEntityActionBarButtonGroup";
		public templateUrl;
		
		constructor(private partialsPath:slatwalladmin.partialsPath){
			this.templateUrl = partialsPath+'entityactionbarbuttongroup.html';
		}
		
		public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
			
		}
	}
    
	angular.module('slatwalladmin').directive('swEntityActionBarButtonGroup',['partialsPath',(partialsPath) => new SWEntityActionBarButtonGroup(partialsPath)]);
}

