/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
import "angular";
declare var angular:any;

class BaseObject{
    public $injector:ng.auto.IInjectorService;
    //@ngInject
    constructor($injector){
        this.$injector = $injector;
    }

    public getService=<service>(serviceName:string):service=>{
        //return;

        if(this.$injector.has(serviceName)){
            //returns a generic service
            return this.$injector.get<service>(serviceName);
        }

    }

    public getHibachiScope=()=>{
        return this.getService('publicService');
    }

    public getAppConfig=()=>{
        return this.getService('appConfig');
    }
}
export{
    BaseObject
}