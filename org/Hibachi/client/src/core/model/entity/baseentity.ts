
import { BaseTransient } from "../transient/basetransient";

declare var angular: any;
abstract class BaseEntity extends BaseTransient {
    public request;

    //@ngInject
    constructor($injector) {
        super($injector);

    }

}
export {
    BaseEntity
}