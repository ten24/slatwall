
import { BaseTransient } from "../transient/basetransient";

declare var angular: any;
abstract class BaseProcess extends BaseTransient {

    //@ngInject
    constructor($injector) {
        super($injector);

    }

}
export {
    BaseProcess
}