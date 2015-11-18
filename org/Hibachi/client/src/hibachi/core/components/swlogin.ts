/// <reference path='../../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../typings/tsd.d.ts' />

    
class SWLoginController{
    public account_login;
    constructor(private $route,private $log:ng.ILogService, private $window:ng.IWindowService, private partialsPath, private $slatwall, private dialogService){
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

class SWLogin implements ng.IDirective{
    
    public restrict:string = 'E';
    public scope = {};
    public bindToController={
    };
    public controller=SWLoginController
    public controllerAs="SwLogin";
    public templateUrl;
    
    public static Factory(){
        var directive:ng.IDirectiveFactory=(
            $route,
            $log:ng.ILogService,  
            $window:ng.IWindowService, 
            partialsPath, 
            $slatwall,
            dialogService
        )=>new SWLogin(
            $route,
            $log,  
            $window, 
            partialsPath, 
            $slatwall,
            dialogService
        );
        directive.$inject = [
            '$route',
            '$log',  
            '$window', 
            'partialsPath', 
            '$slatwall',
            'dialogService'
        ]
        return directive;
    }
    
    constructor(private $route,private $log:ng.ILogService, private $window:ng.IWindowService, private partialsPath, private $slatwall, private dialogService ){
        this.templateUrl = this.partialsPath+'/login.html';
    }
    
    public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
        
    }
}
export{
    SWLogin
}
    
    // angular.module('slatwalladmin').directive('swLogin',['$route','$log','$window','partialsPath','$slatwall',($route,$log,$window,partialsPath,$slatwall,dialogService) => new SWLogin($route,$log,$window,partialsPath,$slatwall,dialogService)]);

