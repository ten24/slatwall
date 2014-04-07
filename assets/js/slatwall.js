var ngSlatwall = angular.module('ng-slatwall', []);


ngSlatwall.controller('admin-entity-preprocessaccount_addaccountpayment', function($scope) {
	$scope.totalAmountToApply = 0;
	
	//$scope.totalAmountToApply = $scope.appliedOrderPayments_1_amount;
	//console.log($scope);
	alert($scope.appliedOrderPayments);
	$scope.totalAmountToApply.toFixed(2);
});