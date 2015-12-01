/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
module slatwalladmin {
    'use strict';
    
    export class SWPromoTestController{
        constructor(private $route,private $log:ng.ILogService, private $window:ng.IWindowService, private partialsPath:slatwalladmin.partialsPath, private $slatwall:ngSlatwall.SlatwallService, private dialogService:slatwalladmin.IDialogService){
            this.$slatwall = $slatwall; 
        }
    }
    
    export class SWPromoTest implements ng.IDirective{
        
        public restrict:string = 'E';
        public scope = {};
        public bindToController={};
        public controller=SWPromoTestController
        public controllerAs="SwPromoTest";
        public templateUrl;
        
        constructor(private partialsPath ){
            this.templateUrl = this.partialsPath + '/frontend/promotestpartial.html';
        }
        
        public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
            
        }
    }
    angular.module('slatwalladmin').directive('swPromoTest',['partialsPath',(partialsPath) => new SWPromoTest(partialsPath)]);
}

