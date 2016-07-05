/// <reference path='../../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../typings/tsd.d.ts' />

import {BaseTransient} from "../transient/basetransient";

declare var angular:any;
abstract class BaseEntity extends BaseTransient{


    constructor($injector){
        super($injector);
        this.$hibachi = this.getService('$hibachi');
    }

}
export{
    BaseEntity
}