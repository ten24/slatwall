/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />


module slatwalladmin {
    'use strict';
    
    export class SWPageDialogController{
        constructor(private partialsPath:slatwalladmin.partialsPath){
            
        }
    }
	
	export class SWPageDialog implements ng.IDirective{
		
		public restrict:string = 'E';
		public scope = {};
        public bindToController={
            pageDialog:"="    
        };
        public controller=SWPageDialogController
        public controllerAs="swPageDialog";
		public templateUrl;
		
		constructor(){
            console.log('paged');
            console.log(this);
            this.templateUrl = partialsPath+this.pageDialog.path+'.html';
		}
		
		public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
			
		}
	}
    
	angular.module('slatwalladmin').directive('swPageDialog',['partialsPath',(partialsPath) => new SWPageDialog(partialsPath)]);
}

