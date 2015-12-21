/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/slatwallTypescript.d.ts' />


class SWLoginController{
    public account_login;
    constructor(private $route,private $log:ng.ILogService, private $window:ng.IWindowService, private corePartialsPath, private $slatwall, private dialogService){
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
            corePartialsPath,
            $slatwall,
            dialogService,
			pathBuilderConfig
        )=>new SWLogin(
            $route,
            $log,
            $window,
            corePartialsPath,
            $slatwall,
            dialogService,
			pathBuilderConfig
        );
        directive.$inject = [
            '$route',
            '$log',
            '$window',
            'corePartialsPath',
            '$slatwall',
            'dialogService',
			'pathBuilderConfig'
        ]
        return directive;
    }

    constructor(private $route,private $log:ng.ILogService, private $window:ng.IWindowService, private corePartialsPath, private $slatwall, private dialogService,
			pathBuilderConfig ){
        this.templateUrl = pathBuilderConfig.buildPartialsPath(this).corePartialsPath+'/login.html';
    }

    public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

    }
}
export{
    SWLogin
}

