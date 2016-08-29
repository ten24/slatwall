import {BaseService} from "./baseservice";

class ScopeService { 

    constructor(){

    }

    public getRootParentScope = (scope, targetName) =>{ 
        var currentScope = scope; 
        while(currentScope != null && angular.isUndefined(currentScope[targetName])){
            if(angular.isDefined(currentScope.$parent)){
                currentScope = currentScope.$parent; 
            } else { 
                break; 
            }
        }
        if(currentScope != null && angular.isDefined(currentScope[targetName])){
            return currentScope;
        } 
    }
}
export {
    ScopeService
}
