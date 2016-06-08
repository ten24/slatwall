import {BaseService} from "./baseservice";

class ScopeService { 

    constructor(){

    }

    public locateParentScope = (scope, targetName) =>{ 
        var currentScope = scope; 
        while(angular.isUndefined(currentScope[targetName])){
            if(angular.isDefined(currentScope.$parent)){
                currentScope = currentScope.$parent; 
            } else { 
                break; 
            }
        }
        if(angular.isDefined(currentScope[targetName])){
            return currentScope;
        } else {
            throw('scopeService.locateParentScope was unabled to find: ' + targetName);
        }
    }
}
export {
    ScopeService
}