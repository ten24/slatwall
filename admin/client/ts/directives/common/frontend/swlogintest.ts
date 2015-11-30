/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
module slatwalladmin {
    'use strict';
    
    export class SWLoginTestController{
        constructor(private $route,private $log:ng.ILogService, private $window:ng.IWindowService, private partialsPath:slatwalladmin.partialsPath, private $slatwall:ngSlatwall.SlatwallService, private dialogService:slatwalladmin.IDialogService){
            this.$slatwall = $slatwall; 
            this.pObject   = "Account_Login";
        }
    }
    
    export class SWLoginTest implements ng.IDirective{
        
        public restrict:string = 'E';
        public scope = {};
        public bindToController={
        };
        public controller=SWLoginTestController
        public controllerAs="swLoginTest";
        public templateUrl;
        
        constructor(private partialsPath ){
            this.templateUrl = this.partialsPath+'/frontend/logintestdirectivepartial.html';
        }
        
        public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
            
        }
    }
    angular.module('slatwalladmin').directive('swLoginTest',['partialsPath',(partialsPath) => new SWLoginTest(partialsPath)]);
}

