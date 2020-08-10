/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWExpiringSessionNotifierController{

    public confirmText:string; 

    //@ngInject
    constructor(public $timeout,
                public $http,
                public $hibachi,
                public localStorageService){

        console.warn("Expiring Session Notifier Constructed.");

        if(angular.isUndefined(this.confirmText)){
            this.confirmText = 'Are you still there? You are about to be logged out.';
        }
        
        this.startTimeout(); 
    }

    public startTimeout = () =>{
       this.$timeout(
            ()=>{
                console.warn("Session Is About To Expire, 3 Minutes Left");
                
                //regardless of user input as long as they respond 
                var answer = confirm(this.confirmText);
    
                this.$http.get(this.$hibachi.buildUrl('api:main.login')).then(
                    (response)=>{
                        if(response.status === 200){
                            this.localStorageService.setItem('token',response.data.token);
                            this.startTimeout();

                        } else {
                            alert('Unable To Login');
                            location.reload();
                        }
                    },
                    (rejection)=>{
                        throw('Login Failed');
                    }
                );
            }
        ,720000);
    }
}

class SWExpiringSessionNotifier implements ng.IDirective{

    public restrict:string = 'E';
    public scope = {};
    public transclude = false;
    public bindToController={
        confirmText:'@?'
    };
    public controller=SWExpiringSessionNotifierController
    public controllerAs="swExpiringSessionNotifier";
    public template;

    public static Factory(){
        var directive:ng.IDirectiveFactory=(
            corePartialsPath,hibachiPathBuilder
        ) => new SWExpiringSessionNotifier(corePartialsPath,hibachiPathBuilder);
        directive.$inject = ['corePartialsPath','hibachiPathBuilder'];
        return directive;

    }

    //@ngInject
    constructor(private corePartialsPath,hibachiPathBuilder){
        this.template = '';
    }

    public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

    }
}
export{
    SWExpiringSessionNotifier
}
