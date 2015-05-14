"use strict";
angular.module('slatwalladmin').directive("swvalidationunique", ['$http', '$q', '$slatwall', '$log', function($http, $q, $slatwall, $log) {
  return {
    restrict: "A",
    require: "ngModel",
    link: function(scope, element, attributes, ngModel) {
      ngModel.$asyncValidators.swvalidationunique = function(modelValue, viewValue) {
        $log.debug('asyc');
        var deferred = $q.defer(),
            currentValue = modelValue || viewValue,
            key = scope.propertyDisplay.object.metaData.className,
            property = scope.propertyDisplay.property;
        if (key && property) {
          $slatwall.checkUniqueValue(key, property, currentValue).then(function(unique) {
            $log.debug('uniquetest');
            $log.debug(unique);
            if (unique) {
              deferred.resolve();
            } else {
              deferred.reject();
            }
          });
        } else {
          deferred.resolve();
        }
        return deferred.promise;
      };
    }
  };
}]);

//# sourceMappingURL=../../../directives/common/validation/swvalidationunique.js.map