/// <reference path='../../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../typings/tsd.d.ts' />

import {BaseTransient} from "../transient/basetransient";

declare var angular:any;
abstract class BaseEntity extends BaseTransient{
    public errors:any={};
    public messages:any={};
    public request;
    public entity:Object;
    public $hibachi:any;

    constructor($injector){
        super($injector);
        this.$hibachi = this.getService('$hibachi');
    }


    public populate = (response)=>{
        var data = response;
        if(response.data){
            data= response.data;
        }

        for(var key in data){
            let value = data[key];
            this[key] = value;
            if(this.entity && this.entity.hasOwnProperty(key)){
                this.entity[key] = value;
            }else{
                this[key] = value;
            }

        }

        if(response.errors){
            this.errors = response.errors;
            this.messages = response.messages;
        }
        console.log('cartObject',this);
    }

}
export{
    BaseEntity
}