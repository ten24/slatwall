
import {BaseTransient} from "../transient/basetransient";

declare var angular:any;
abstract class BaseEntity extends BaseTransient{
    public request;

    constructor($injector){
        super($injector);

    }

}
export{
    BaseEntity
}