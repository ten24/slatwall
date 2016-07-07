/// <reference path='../../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../typings/tsd.d.ts' />

import {BaseObject} from "../baseobject";
import {HibachiService} from "../../services/hibachiservice";
import {HibachiValidationService} from "../../services/hibachivalidationservice";

abstract class BaseTransient extends BaseObject{

    public errors:{ [errorName: string]: any; }={};
    public messages:any={};
    public $hibachi:HibachiService;
    public hibachiValidationService:HibachiValidationService;
    public metaData:Object;

    constructor($injector){
        super($injector);
        this.$hibachi = <HibachiService>this.getService('$hibachi');
        this.hibachiValidationService = <HibachiValidationService>this.getService('hibachiValidationService');
    }

    public populate = (response)=>{
        var data = response;
        if(response.data){
            data= response.data;
        }

        for(var key in data){

            let propertyIdentifier = key.replace(this.className.toLowerCase()+'.','');
			let propertyIdentifierArray = propertyIdentifier.split('.');
			let propertyIdentifierKey = propertyIdentifier.replace(/\./g,'_');
            let currentEntity = this;

            angular.forEach(propertyIdentifierArray,(property,propertyKey)=>{
                if(currentEntity.metaData[property]){
                    //if we are on the last item in the array
                    if(propertyKey === propertyIdentifierArray.length-1){

                        if(angular.isObject(property) && currentEntity.metaData[property].fieldtype && currentEntity.metaData[property].fieldtype === 'many-to-one'){
                            var relatedEntity = this.getService('entityService').newEntity(currentEntity.metaData[property].cfc);
                            if(relatedEntity.populate){
                                relatedEntity.populate(property);
                            }else{
                                relatedEntity.$$init(data[propertyIdentifierKey][0]);
                                currentEntity['$$set'+currentEntity.metaData[property].name.charAt(0).toUpperCase()+currentEntity.metaData[property].name.slice(1)](relatedEntity);
                            }
                        }else if(angular.isArray(data[propertyIdentifierKey]) && currentEntity.metaData[property].fieldtype && (currentEntity.metaData[property].fieldtype === 'one-to-many')){
                            angular.forEach(data[propertyIdentifierKey],(arrayItem,propertyKey)=>{
                                var relatedEntity = this.getService('entityService').newEntity(currentEntity.metaData[property].cfc);;
                                if(relatedEntity.populate){
                                    relatedEntity.populate(arrayItem)
                                }else{
                                    relatedEntity.$$init(arrayItem);
                                    currentEntity['$$add'+currentEntity.metaData[property].singularname.charAt(0).toUpperCase()+currentEntity.metaData[property].singularname.slice(1)](relatedEntity);
                                }
                            });
                        }else{

                            currentEntity[property] = data[propertyIdentifierKey];
                        }

                    }else{
                        this[key] = data[key];
                        if(currentEntity.metaData[property]){
                            var propertyMetaData = currentEntity.metaData[property];

                            if(angular.isUndefined(currentEntity.data[property])){
                                if(propertyMetaData.fieldtype === 'one-to-many'){
                                    relatedEntity = [];
                                }else{
                                    relatedEntity = this.$hibachi['new'+propertyMetaData.cfc]();
                                }
                            }else{
                                relatedEntity = currentEntity.data[property];
                            }
                            currentEntity['$$set'+propertyMetaData.name.charAt(0).toUpperCase()+propertyMetaData.name.slice(1)](relatedEntity);
                            currentEntity = relatedEntity;
                        }
                    }

                }else{
                    this[key] = data[key];
                }

            });


        }

        if(response.errors){
            this.errors = response.errors;
            this.messages = response.messages;
        }

    }

    public addError=(errorName:string,errorMessage:any)=>{
        if(!this.errors[errorName]){
            this.errors[errorName] = [];
        }
        if(angular.isArray(errorMessage)){
            this.addErrorsByArray(errorName,errorMessage);
        }else if(angular.isObject(errorMessage)){
            this.addErrorsByObject(errorName,errorMessage);
        }else{
            this.errors[errorName].push(errorMessage);
        }
    }

    public addErrorsByArray=(errorName,errorMessages)=>{
        for(var i=0; i<errorMessages.length;i++){
            var message = errorMessages[i];
            this.errors[errorName].push(message);
        }
    }

    public addErrorsByObject = (errorName,errorMessage:any)=>{
        if(!this.errors[errorName]){
            this.errors[errorName] = [];
        }
        for(var key in errorMessage){
            for(var i=0; i<errorMessage[key].length;i++){
                var message = errorMessage[i];
                this.errors[errorName].push(message);
            }
        }
    }

    public addErrors=(errors:any)=>{
        for(var key in errors) {
			if(!this.errors[key]){
                this.errors[key] = [];
            }
			for(var message in errors[key]) {
				this.errors[key].push(message);
			}
		}
    }

    public isValid=():boolean=>{
        var validationInfo = this.hibachiValidationService.validateObject(this);
        return validationInfo.valid;
    }

    public getError=(errorName:string)=>{
        return this.getErrorByErrorName(errorName);
    }

    public getErrorByErrorName=(errorName)=>{
        return this.errors[errorName];
    }

    public hasError=(errorName:string)=>{
        return this.hasErrorByErrorName(errorName);
    }

    public hasErrorByErrorName=(errorName:string)=>{
        return angular.isDefined(this.errors[errorName]);
    }

    public hasErrors=()=>{
        return Object.keys(this.errors).length;
    }

    public hasSuccessfulAction=(action)=>{
        return
    }
}
export {
    BaseTransient
}