import {BaseService} from "./baseservice";

class FilterService { 

    constructor(){

    }

    public filterMatch = (valueToCompare, comparisonOperator, comparisonValue) => {
        switch (comparisonOperator){
            case "!=":
                if(valueToCompare != comparisonValue){
                    return true;
                }
                break; 
            case ">":
                if(valueToCompare > comparisonValue){
                    return true; 
                }
                break;
            case ">=":  
                if(valueToCompare >= comparisonValue){
                    return true;
                }
                break;
            case "<":
                if(valueToCompare < comparisonValue){
                    return true;
                }
                break; 
            case "<=":
                if(valueToCompare <= comparisonValue){
                    return true;
                }
                break; 
            case "is":
                if(valueToCompare == comparisonValue){
                    return true;
                }
                break;
            case "is not": 
                if(valueToCompare != comparisonValue){
                    return true;
                }
                break; 
            default: 
                //= case
                if(valueToCompare == comparisonValue){
                    return true;
                }
                break; 
        }
        return false; 
    }
}
export {
    FilterService
}