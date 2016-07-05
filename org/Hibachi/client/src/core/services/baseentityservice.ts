/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
import {BaseObject} from "../model/baseobject";
import * as Entities from "../model/entity/entities";

abstract class BaseEntityService extends BaseObject{

    //@ngInject
    constructor(
        public $injector,
        public $hibachi,
        public utilityService,
        public baseObjectName:string,
        public objectName?:string
    ){
        super($injector);

        if(!this.objectName){
            this.objectName = this.baseObjectName;
        }

        this['new'+this.objectName] = ()=>{
            var baseObject = this.$hibachi.getEntityDefinition(this.baseObjectName);
            this.utilityService.extend(Entities[this.objectName],baseObject);
            var entity = new Entities[this.objectName]($injector);
            for(var key in entity){
                if(entity[key] === null){
                    entity[key] = undefined
                }
            }
            return entity;
        }
    }
}
export{BaseEntityService};

