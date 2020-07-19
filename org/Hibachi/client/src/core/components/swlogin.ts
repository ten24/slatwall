/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


class SWLoginController{
    public account_login;
    //@ngInject
    constructor(
        private $route,
        private $log:ng.ILogService, 
        private $window:ng.IWindowService, 
        private corePartialsPath, 
        private $hibachi, 
        private dialogService, 
        public hibachiScope
    ){
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

    public template = require("./login.html");

	public static Factory(){
		return /** @ngInject; */ () => new this();
	}
}
export{
    SWLogin
}

