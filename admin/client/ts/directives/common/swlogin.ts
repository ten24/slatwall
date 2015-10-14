/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />


module slatwalladmin {
    'use strict';
    
    export class SWLoginController{
        constructor(private $route,private $log:ng.ILogService, private $window:ng.IWindowService, private partialsPath:slatwalladmin.partialsPath, private $slatwall:ngSlatwall.SlatwallService, private dialogService:slatwalladmin.IDialogService){
            this.$slatwall = $slatwall;
            this.$window = $window;
            this.$route = $route;
            this.account_login = $slatwall.newEntity('Account_Login');
        }
        public login = ():void =>{
            var loginPromise = this.$slatwall.login(this.account_login.data.emailAddress, this.account_login.data.password);
            loginPromise.then((loginResponse)=>{
                if(loginResponse && loginResponse.data && loginResponse.data.token){
                    this.$window.localStorage.setItem('token',loginResponse.data.token);
                    this.$route.reload();
                    this.dialogService.removeCurrentDialog();
                }
            });
        }
    }
    
    export class SWLogin implements ng.IDirective{
        
        public restrict:string = 'E';
        public scope = {};
        public bindToController={
        };
        public controller=SWLoginController
        public controllerAs="SwLogin";
        public templateUrl;
        
        constructor(private $route,private $log:ng.ILogService, private $window:ng.IWindowService, private partialsPath:slatwalladmin.partialsPath, private $slatwall:ngSlatwall.SlatwallService, private dialogService:slatwalladmin.IDialogService ){
            this.templateUrl = this.partialsPath+'/login.html';
        }
        
        public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
            
        }
    }
    
    angular.module('slatwalladmin').directive('swLogin',['$route','$log','$window','partialsPath','$slatwall',($route,$log,$window,partialsPath,$slatwall,dialogService) => new SWLogin($route,$log,$window,partialsPath,$slatwall,dialogService)]);
}

