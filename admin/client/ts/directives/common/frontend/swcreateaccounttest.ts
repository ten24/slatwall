/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
module slatwalladmin {
    'use strict';
    
    export class SWCreateAccountTestController{
        constructor(private $route,private $log:ng.ILogService, private $window:ng.IWindowService, private partialsPath:slatwalladmin.partialsPath, private $slatwall:ngSlatwall.SlatwallService, private dialogService:slatwalladmin.IDialogService){
            this.$slatwall = $slatwall; 
        }
    }
    
    export class SWCreateAccountTest implements ng.IDirective{
        
        public restrict:string = 'E';
        public scope = {};
        public bindToController={
        };
        public controller=SWCreateAccountTestController
        public controllerAs="SwCreateAccountTest";
        public templateUrl;
        
        constructor(private partialsPath:slatwalladmin.partialsPath){
            this.templateUrl = this.partialsPath+'/frontend/createAccountTestPartial.html';
        }
        
        public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
            
        }
    }
    
    angular.module('slatwalladmin').directive('swCreateAccountTest',['partialsPath',(partialsPath) => new SWCreateAccountTest(partialsPath)]);
}