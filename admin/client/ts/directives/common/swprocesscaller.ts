/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />


module slatwalladmin {
    'use strict';
    
    export class SWProcessCallerController{
        constructor(){
            this.type = this.type || 'link';
			console.log('init process caller controller');
            console.log(this);
        }
    }
	
	export class SWProcessCaller implements ng.IDirective{
		
		public restrict:string = 'E';
		public scope = {};
        public transclude=true;
        public bindToController={
            action:"@",
			entity:"@",
			processContext:"@",
			hideDisabled:"=",
			type:"@",
			querystring:"@",
			text:"@",
			title:"@",
			class:"@",
			icon:"=",
			iconOnly:"=",
			submit:"=",
			confirm:"=",
			disabled:"=",
            disabledText:"@",
			modal:"="
        };
        public controller=SWProcessCallerController
        public controllerAs="swProcessCaller";
		public templateUrl;
		
		constructor(private partialsPath:slatwalladmin.partialsPath){
			this.templateUrl = partialsPath+'processcaller.html';
		}
		
		public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
			
		}
	}
    
	angular.module('slatwalladmin').directive('swProcessCaller',['partialsPath',(partialsPath) => new SWProcessCaller(partialsPath)]);
}

