/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/**
 * Validates true if the given object is 'unique' and false otherwise.
 */
class SWValidationUniqueOrNull{
    constructor($http,$q,$hibachi,$log){
        return {
            restrict : "A",
            require : "ngModel",
            link : function(scope, element, attributes, ngModel) {
                ngModel.$asyncValidators.swvalidationuniqueornull = function (modelValue, viewValue) {
                    $log.debug('async');
                    var deferred = $q.defer(),
                        currentValue = modelValue || viewValue,
                        key = scope.propertyDisplay.object.metaData.className,
                        property = scope.propertyDisplay.property;
                    //First time the asyncValidators function is loaded the
                    //key won't be set  so ensure that we have
                    //key and propertyName before checking with the server
                    if (key && property) {
                        $hibachi.checkUniqueOrNullValue(key, property, currentValue)
                        .then(function (unique) {
                            $log.debug('uniquetest');
                            $log.debug(unique);

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
                };

            }
        };
    }
    public static Factory(){
        var directive = ($http,$q,$hibachi,$log)=>new SWValidationUniqueOrNull($http,$q,$hibachi,$log);
        directive.$inject = ['$http','$q','$hibachi','$log'];
        return directive;
    }
}
export{
    SWValidationUniqueOrNull
}