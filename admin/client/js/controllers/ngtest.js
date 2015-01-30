angular.module('slatwalladmin').controller('ngtest', [ '$scope', '$slatwall', 
	function($scope, $slatwall){
		//Just used for practice testing.
		$scope.test = "Slatwall Test Runner";
		$scope.defineTest = 
			function(){
				$scope.test = $scope.test + "Works";
				$scope.slatwallScope = $slatwall;
			}
		$scope.sku = $slatwall.newSku();
		$scope.saveSku = 
			function(){
				$scope.sku.$$save(); 
			}
	}
]);
