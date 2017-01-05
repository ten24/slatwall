import {BaseService} from "./baseservice";

class FilterService { 

    //ngInject
    constructor(){

    }

    public filterMatch = (valueToCompareAgainst, comparisonOperator, comparisonValue) => {
        switch (comparisonOperator){
            case "!=":
                if(valueToCompareAgainst != comparisonValue){
                    return true;
                }
                break; 
            case ">":
                if(valueToCompareAgainst > comparisonValue){
                    return true; 
                }
                break;
            case ">=":  
                if(valueToCompareAgainst >= comparisonValue){
                    return true;
                }
                break;
            case "<":
                if(valueToCompareAgainst < comparisonValue){
                    return true;
                }
                break; 
            case "<=":
                if(valueToCompareAgainst <= comparisonValue){
                    return true;
                }
                break; 
            case "is":
                if(valueToCompareAgainst == comparisonValue){
                    return true;
                }
                break;
            case "is not": 
                if(valueToCompareAgainst != comparisonValue){
                    return true;
                }
                break; 
            default: 
                //= case
                if(valueToCompareAgainst == comparisonValue){
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