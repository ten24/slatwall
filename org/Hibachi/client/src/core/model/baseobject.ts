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

    public getService=(serviceName)=>{
        //return;
        console.log('injector',this.$injector);
        if(this.$injector.has(serviceName)){
            return this.$injector.get(serviceName);
        }

    }

    public getHibachiScope=()=>{
        return this.getService('publicService');
    }
}
export{
    BaseObject
}