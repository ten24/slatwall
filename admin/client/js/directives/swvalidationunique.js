/**
 * Validates true if the given object is 'unique' and false otherwise.
 */
angular.module('slatwalladmin').directive("swvalidationunique", ['$http','$q','$slatwall',  function($http,$q,$slatwall) {
	return {
		restrict : "A",
		require : "ngModel",
		link : function(scope, element, attributes, ngModel) {
			//var value = ngModel.modelValue || ngModel.viewValue;
			//var valObj = scope.propertyDisplay.object.metaData.$$className; 
			ngModel.$asyncValidators.swvalidationunique = function (modelValue, viewValue) {
				console.log('asyc');
                var deferred = $q.defer(),
                    currentValue = modelValue || viewValue,
                    key = scope.propertyDisplay.object.metaData.className,
                    property = scope.propertyDisplay.property;
                //First time the asyncValidators function is loaded the
                //key won't be set  so ensure that we have 
                //key and propertyName before checking with the server 
                if (key && property) {
                    $slatwall.checkUniqueValue(key, property, currentValue)
                    .then(function (unique) {
                    	console.log('uniquetest');
                    	console.log(unique);
                    	
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
}]);