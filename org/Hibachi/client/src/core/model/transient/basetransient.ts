/// <reference path='../../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../typings/tsd.d.ts' />

import {BaseObject} from "../baseobject";

class BaseTransient extends BaseObject{

    public errors:{ [errorName: string]: any; }={};

    constructor(){
        super();
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