/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
module slatwalladmin {
    'use strict';
    
    export class SWLogoutTestController{
        constructor(private $route,private $log:ng.ILogService, private $window:ng.IWindowService, private partialsPath:slatwalladmin.partialsPath, private $slatwall:ngSlatwall.SlatwallService, private dialogService:slatwalladmin.IDialogService){
            this.$slatwall = $slatwall; 
        }
    }
    
    export class SWLogoutTest implements ng.IDirective{
        
        public restrict:string = 'E';
        public scope = {};
        public bindToController={
        };
        public controller=SWLogoutTestController
        public controllerAs="SwLogoutTest";
        public templateUrl;
        
        constructor(private partialsPath ){
            this.templateUrl = this.partialsPath+'/frontend/Logouttestdirectivepartial.html';
        }
        
        public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
            
        }
    }
    angular.module('slatwalladmin').directive('swLogoutTest',['partialsPath',(partialsPath) => new SWLogoutTest(partialsPath)]);
}

