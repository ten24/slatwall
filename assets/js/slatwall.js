var ngSlatwall = angular.module('ng-slatwall', []);

ngSlatwall.controller('admin-entity-preprocessaccount_addaccountpayment', function($scope, $compile) {
	alert("Loaded Controller");
	$scope.updateSubTotal = function() {
		$scope.totalAmountToApply = 0;
		
		//Loop through all the amount fields and create a running subtotal
		angular.forEach($scope.appliedOrderPayment, function(value, key){
			$scope.totalAmountToApply += parseFloat(value);
	    });
	}
	
	$scope.recompile = function() {
		alert("CALLED REFRESH");
		console.log("test");
		//$compile($('html'))($scope);
		
	}
});