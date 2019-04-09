import {BaseEntityService} from "./baseentityservice";
import * as Entities from "../model/entity/entities";
import * as Processes from "../model/process/processes";

abstract class EntityService extends BaseEntityService{

    //@ngInject
    constructor(
        public $injector,
        public $hibachi,
        public utilityService
    ){
        super(
            $injector,
            $hibachi,
            utilityService
        );

    }

}
export{EntityService};

