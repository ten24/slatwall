"use strict";
'use strict';
angular.module('slatwalladmin').controller("confirmationController", ["$scope", "$log", "$modalInstance", function($scope, $log, $modalInstance) {
  $scope.deleteEntity = function(entity) {
    $log.debug("Deleting an entity.");
    $log.debug($scope.entity);
    this.close();
  };
  $scope.close = function() {
    $modalInstance.close();
  };
  $scope.cancel = function() {
    $modalInstance.dismiss("cancel");
  };
}]);

//# sourceMappingURL=../controllers/confirmationcontroller.js.map