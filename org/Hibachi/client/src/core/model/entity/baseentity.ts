/// <reference path='../../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../typings/tsd.d.ts' />

import {BaseTransient} from "../transient/basetransient";

declare var angular:any;
class BaseEntity extends BaseTransient{
    public errors:any={};
    public messages:any={};
    constructor(){
        super();
    }

    public populate = (data)=>{

        for(var key in data){
            var value = data[key];
            this[key] = value;
        }
        console.log('cartObject',this);
    }

}
export{
    BaseEntity
}