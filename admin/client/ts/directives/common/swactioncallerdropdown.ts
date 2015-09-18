/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />


module slatwalladmin {
    'use strict';
    
    export class SWActionCallerDropdownController{
        
        constructor(){
            this.title = this.title || '';
            this.icon = this.icon || 'plus';
            this.type = this.type || 'button';
            this.dropdownClass = this.dropdownClass || '';
            this.dropdownId = this.dropdownId || '';
            this.buttonClass = this.buttonClass || 'btn-primary';
        }
    }
	
	export class SWActionCallerDropdown implements ng.IDirective{
		
		public restrict:string = 'E';
		public scope = {};
        public transclude=true;
        public bindToController={
            title:"@",
            icon:"@",
            type:"=",
            dropdownClass:"=",
            dropdownId:"@",
            buttonClass:"="
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

