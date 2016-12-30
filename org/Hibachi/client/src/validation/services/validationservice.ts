/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/*services return promises which can be handled uniquely based on success or failure by the controller*/

class ValidationService{
    public MY_EMAIL_REGEXP =  /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    //@ngInject
    constructor(
        public $hibachi,
        public $q
    ){
        this.$hibachi = $hibachi;
        this.$q = $q;
    }



    public validateUnique=(value, objectName, property)=>{
        var deferred = this.$q.defer();
        //First time the asyncValidators function is loaded the
        //key won't be set  so ensure that we have
        //key and propertyName before checking with the server
        if (objectName && property) {
            this.$hibachi.checkUniqueValue(objectName, property, value)
            .then((unique)=> {
                if (unique) {
                    deferred.resolve(); //It's unique
                }
                else {
                    deferred.reject(); //Add unique to $errors
                }
            });
        }
        else {
            deferred.resolve(); //Ensure promise is resolved if we hit this
        }

        return deferred.promise;
    }

    public validateUniqueOrNull=(value, objectName, property)=>{
        var deferred = this.$q.defer();
        //First time the asyncValidators function is loaded the
        //key won't be set  so ensure that we have
        //key and propertyName before checking with the server
        if (objectName && property) {
            this.$hibachi.checkUniqueOrNullValue(objectName, property, value)
            .then((unique)=> {
                if (unique) {
                    deferred.resolve(); //It's unique
                }
                else {
                    deferred.reject(); //Add unique to $errors
                }
            });
        }
        else {
            deferred.resolve(); //Ensure promise is resolved if we hit this
        }

        return deferred.promise;
    }

    public validateEmail=(value):boolean=>{
        return this.validateDataType(value,'email')
    }

    public validateDataType=(value,type):boolean=>{
        if (angular.isString(value) && type === "string"){return true;}
        if (angular.isNumber(parseInt(value)) && type === "numeric"){return true;}
        if (angular.isArray(value) && type === "array"){return true;}
        if (angular.isDate(value) && type === "date"){return true;}
        if (angular.isObject(value) && type === "object"){return true;}
        if (type === 'email'){
            return this.MY_EMAIL_REGEXP.test(value);
        }
        if	(angular.isUndefined(value && type === "undefined")){return true;}
        return false;
    }

    public validateEq=(value,expectedValue):boolean=>{
        return (value === expectedValue);
    }

    public validateNeq=(value,expectedValue):boolean=>{
        return (value !== expectedValue);
    }



    public validateGte=(value:number|string,comparisonValue:number|string=0):boolean=>{
        if(angular.isString(value)){
            value = parseInt(<string>value)
        }
        if(angular.isString(comparisonValue)){
            comparisonValue = parseInt(<string>comparisonValue)
        }
        return (value >= comparisonValue);
    }

    public validateLte=(value:number|string,comparisonValue:number|string=0):boolean=>{
        if(angular.isString(value)){
            value = parseInt(<string>value)
        }
        if(angular.isString(comparisonValue)){
            comparisonValue = parseInt(<string>comparisonValue)
        }
        return (value <= comparisonValue);
    }

    public validateMaxLength=(value:number|string,comparisonValue:number|string=0):boolean=>{
        return this.validateLte(value,comparisonValue);
    }

    public validateMaxValue=(value:number|string,comparisonValue:number|string=0):boolean=>{
        return this.validateLte(value,comparisonValue);
    }

    public validateMinLength=(value:number|string,comparisonValue:number|string=0):boolean=>{
        return this.validateGte(value,comparisonValue);
    }

    public validateMinValue=(value:number|string,comparisonValue:number|string=0):boolean=>{
        return this.validateGte(value,comparisonValue);
    }

    public validateNumeric=(value):boolean=>{
        return !isNaN(value);
    }

    public validateRegex=(value:string,pattern:string):boolean=>{
        var regex:RegExp = new RegExp(pattern);
        return regex.test(value);
    }

    public validateRequired=(value):boolean=>{

        if(value){
            return true;
        }else{
            return false;
        }
    }

}
export {
    ValidationService
};

