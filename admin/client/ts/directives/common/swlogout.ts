/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />


module slatwalladmin {
    'use strict';
    
    export class SWLogoutController{
        private account_logout = {};
        constructor(private $route,private $log:ng.ILogService, private $window:ng.IWindowService, private partialsPath:slatwalladmin.partialsPath, private $slatwall:ngSlatwall.SlatwallService, private dialogService:slatwalladmin.IDialogService){
            this.$slatwall = $slatwall;
            this.$window = $window;
            this.$route = $route;
            this.account_logout = $slatwall.newEntity('Account_Logout');
        }
        public login = ():void =>{
            var loginPromise = this.$slatwall.logout();
            loginPromise.then((loginResponse)=>{
                if( loginResponse && loginResponse.data ){
                    
                    this.$route.reload();
                    this.dialogService.removeCurrentDialog();
                }
            });
        }
    }
    
    export class SWLogout implements ng.IDirective{
        
        public restrict:string = 'E';
        public scope = {};
        public bindToController={
        };
        public controller=SWLoginController
        public controllerAs="SwLogin";
        public templateUrl;
        
        constructor(private $route,private $log:ng.ILogService, private $window:ng.IWindowService, private partialsPath:slatwalladmin.partialsPath, private $slatwall:ngSlatwall.SlatwallService, private dialogService:slatwalladmin.IDialogService ){
            this.templateUrl = this.partialsPath+'/logout.html';
        }
        
        public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
            
        }
    }
    
    angular.module('slatwalladmin').directive('swLogout',['$route','$log','$window','partialsPath','$slatwall',($route,$log,$window,partialsPath,$slatwall,dialogService) => new SWLogout($route,$log,$window,partialsPath,$slatwall,dialogService)]);
}

