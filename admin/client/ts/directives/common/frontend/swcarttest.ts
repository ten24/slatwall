/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
module slatwalladmin {
    'use strict';
    
    interface FindArray<T> extends Array<T> {
        find(predicate: (T) => boolean) : T;
    }
    export class SWCartTestController{
        public cart:{};
        public account:{};
        public validCartObjects:FindArray<Object>;
        public hibachiScope:any;
        
        constructor(private $route,private $log:ng.ILogService, private $window:ng.IWindowService, private partialsPath:slatwalladmin.partialsPath, public $rootScope){
            this.$rootScope         = $rootScope;
            this.hibachiScope       = this.$rootScope.hibachiScope;
            this.cart               = this.hibachiScope.cart;
            this.account            = this.hibachiScope.account;
            this.objectFound        = false;
            this.listItem = this.hibachiScope.cart[this.object];
            console.log("ListItem", this.listItem); 
        } 
    }
    
    export class SWCartTest implements ng.IDirective{
        
        public restrict:string = 'E';
        public scope = {};
        public bindToController={
            object: "@?"
        };
        public controller=SWCartTestController
        public controllerAs="SwCartTest";
        public templateUrl;
        
        constructor(private partialsPath:slatwalladmin.partialsPath){
            this.templateUrl = this.partialsPath+'/frontend/carttestpartial.html';
        }
        
        public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
            
        }
    }
    
    angular.module('slatwalladmin').directive('swCartTest',['partialsPath',(partialsPath) => new SWCartTest(partialsPath)]);
}