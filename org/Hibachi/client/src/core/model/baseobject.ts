/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

declare var angular:any;
class BaseObject{
    constructor(){

    }

    public getService=(serviceName)=>{
        if(angular.element(document.body).injector().has(serviceName)){
            return angular.element(document.body).injector().get(serviceName);
        }
    }

    public getHibachiScope=()=>{
        return this.getService('publicService');
    }
}
export{
    BaseObject
}