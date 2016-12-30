/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


class SWLoginController{
    public account_login;
    //@ngInject
    constructor(private $route,private $log:ng.ILogService, private $window:ng.IWindowService, private corePartialsPath, private $hibachi, private dialogService, public hibachiScope){
        this.$hibachi = $hibachi;
        this.$window = $window;
        this.$route = $route;
        this.hibachiScope = hibachiScope;
        this.account_login = $hibachi.newEntity('Account_Login');
    }
    public login = ():void =>{
        var loginPromise = this.$hibachi.login(this.account_login.data.emailAddress, this.account_login.data.password);
        loginPromise.then((loginResponse)=>{
            if(loginResponse && loginResponse.data && loginResponse.data.token){
                this.$window.localStorage.setItem('token',loginResponse.data.token);
                this.hibachiScope.loginDisplayed = false;
                this.$route.reload();
                this.dialogService.removeCurrentDialog();
            }
        },function(rejection){
            
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
            corePartialsPath,
            $hibachi,
            dialogService,
			hibachiPathBuilder
        )=>new SWLogin(
            $route,
            $log,
            $window,
            corePartialsPath,
            $hibachi,
            dialogService,
			hibachiPathBuilder
        );
        directive.$inject = [
            '$route',
            '$log',
            '$window',
            'corePartialsPath',
            '$hibachi',
            'dialogService',
			'hibachiPathBuilder'
        ]
        return directive;
    }
    //@ngInject
    constructor(private $route,private $log:ng.ILogService, private $window:ng.IWindowService, private corePartialsPath, private $hibachi, private dialogService,
			hibachiPathBuilder ){
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(this.corePartialsPath+'/login.html');
    }

    public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

    }
}
export{
    SWLogin
}

