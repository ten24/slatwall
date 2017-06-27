import {BaseService} from "./baseservice";

class ScopeService { 

    //ngInject
    constructor(){

    }

    public getRootParentScope = (scope, targetScopeName) =>{ 
        var currentScope = scope; 
        while(currentScope != null && angular.isUndefined(currentScope[targetScopeName])){
            if(angular.isDefined(currentScope.$parent)){
                currentScope = currentScope.$parent; 
            } else { 
                break; 
            }
        }
        if(currentScope != null && angular.isDefined(currentScope[targetScopeName])){
            return currentScope;
        } 
    }

    public hasParentScope = (scope, targetScopeName) =>{
        if(this.getRootParentScope(scope, targetScopeName) != null){
            return true; 
        }
        return false; 
    }
}
export {
    ScopeService
}
