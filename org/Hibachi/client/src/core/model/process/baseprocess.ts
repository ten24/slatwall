
import {BaseTransient} from "../transient/basetransient";

declare var angular:any;
abstract class BaseProcess extends BaseTransient{


    constructor($injector){
        super($injector);

    }

}
export{
    BaseProcess
}