/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class HibachiScope{
    
    public loginDisplayed:boolean=false;
    public config:any;
    public token:string;
    public jwtInfo:any;
    public session:any;
    public isValidToken:boolean=true;
    //@ngInject
    constructor(
        appConfig
    ){
        this.config = appConfig;
    }
    
    public setToken = (token:string):void=>{
        this.token = token;
        var stringArray = token.split('.');
        try{
            this.jwtInfo = angular.fromJson(window.atob(stringArray[0]).trim());
            this.session = angular.fromJson(window.atob(stringArray[1]).trim());
        }catch(err){
            this.isValidToken = false;
        }
    }
    
}
export{
    HibachiScope
}



