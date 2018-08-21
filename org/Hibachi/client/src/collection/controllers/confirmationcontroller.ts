/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class ConfirmationController{
  //@ngInject
  constructor($scope,$log,$modalInstance,callback,workflowtrigger){
      $scope.deleteEntity = function (entity) {
      $log.debug("Deleting an entity.");
      $log.debug($scope.entity);
      this.close();
    };

    $scope.fireCallback = function () {
      callback(workflowtrigger,workflowtrigger.$$index);
      this.close();
    }
    /**
    * Closes the modal window
    */
    $scope.close = function () {
      $modalInstance.close();
    };
    /**
    * Cancels the modal window
    */
    $scope.cancel = function () {
      $modalInstance.dismiss("cancel");
    };
  }
}
export{
  ConfirmationController
}
