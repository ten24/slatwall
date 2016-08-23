/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
import {BaseObject} from "../model/baseobject";
import * as Entities from "../model/entity/entities";
import * as Processes from "../model/process/processes";

abstract class BaseEntityService extends BaseObject{

    //@ngInject
    constructor(
        public $injector,
        public $hibachi,
        public utilityService,
        public baseObjectName?:string,
        public objectName?:string
    ){
        super($injector);
        this.utilityService = utilityService;
        this.$hibachi = $hibachi;
        this.$injector = $injector;
        if(!this.objectName){
            this.objectName = this.baseObjectName;
        }

        this['new'+this.objectName] = ()=>{
            return this.newEntity(this.baseObjectName,this.objectName);
        }

    }

    public newEntity = (baseObjectName:string,objectName?:string)=>{
        if(!objectName){
            objectName = baseObjectName;
        }

        return this.newObject('Entity',baseObjectName,objectName);
    }

    public newProcessObject = (baseObjectName:string,objectName?:string)=>{
        if(!objectName){
            objectName = baseObjectName;
        }
        return this.newObject('Process',baseObjectName,objectName);
    }

    public newObject = (type:string,baseObjectName:string,objectName?:string)=>{
        if(!objectName){
            objectName = baseObjectName;
        }
        var baseObject = this.$hibachi.getEntityDefinition(baseObjectName);
        var Barrell = {};
        if(type === 'Entity'){
            Barrell = Entities;
        }else if(type === 'Process'){
            Barrell = Processes;
        }
        if(Barrell[objectName]){
            this.utilityService.extend(Barrell[objectName],baseObject);
            var entity = new Barrell[objectName](this.$injector);
        }else{
            var entity = new baseObject();
            //throw('need to add '+ objectName+' class');
        }

        return entity;
    }

}
export{BaseEntityService};

