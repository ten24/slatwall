/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />


module slatwalladmin {
    'use strict';
    
    export class SWActionCallerDropdownController{
        constructor(){
            
        }
    }
	
	export class SWActionCallerDropdown implements ng.IDirective{
		
		public restrict:string = 'E';
		public scope = {};
        public transclude=true;
        public bindToController={
            
        };
        public controller=SWActionCallerDropdownController
        public controllerAs="swActionCallerDropdown";
		public templateUrl;
		
		constructor(private partialsPath:slatwalladmin.partialsPath){
			this.templateUrl = partialsPath+'actioncallerdropdown.html';
		}
		
		public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
			
		}
	}
    
	angular.module('slatwalladmin').directive('swActionCallerDropdown',['partialsPath',(partialsPath) => new SWActionCallerDropdown(partialsPath)]);
}

