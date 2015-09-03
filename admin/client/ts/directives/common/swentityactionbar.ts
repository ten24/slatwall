/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />


module slatwalladmin {
    'use strict';
    
    export class SWEntityActionBarController{
        constructor(){
           
        }
    }
	
	export class SWEntityActionBar implements ng.IDirective{
		
		public restrict:string = 'E';
		public scope = {};
        public bindToController={
            /*Core settings*/
            type:"=",
            object:"=",
            pageTitle:"=",
            edit:"=",
            /*Action Callers (top buttons)*/
            showcancel:"=",
            showcreate:"=",
            showedit:"=",
            showdelete:"=",
            
            /*Basic Action Caller Overrides*/
            createModal:"=",
            createAction:"=",
            createQueryString:"=",
            
            backAction:"=",
            backQueryString:"=",
            
            cancelAction:"=",
            cancelQueryString:"=",
            
            deleteAction:"=",
            deleteQueryString:"=",
            
            /*Process Specific Values*/
            processAction:"=",
            processContext:"="
            
        };
        public controller=SWEntityActionBarController
        public controllerAs="swEntityActionBar";
		public templateUrl;
		
		constructor(private partialsPath:slatwalladmin.partialsPath){
			this.templateUrl = partialsPath+'entityactionbar.html';
		}
		
		public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
			
		}
	}
    
	angular.module('slatwalladmin').directive('swEntityActionBar',['partialsPath',(partialsPath) => new SWEntityActionBar(partialsPath)]);
}

