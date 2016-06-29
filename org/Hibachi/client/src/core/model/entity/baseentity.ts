/// <reference path='../../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../typings/tsd.d.ts' />

import {BaseTransient} from "../transient/basetransient";

declare var angular:any;
class BaseEntity extends BaseTransient{
    public errors:any={};
    public messages:any={};
    public request;

    constructor($injector){
        super($injector);
    }

    public populate = (response)=>{
        var data = response;
        if(response.data){
            data= response.data;
        }

        for(var key in data){
            var value = data[key];
            this[key] = value;
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