angular.module('slatwalladmin').controller('ngtest', [ 
	'$scope',
	'$slatwall', 
	function($scope, $slatwall){
		$scope.test = "Slatwall Test Runner";
		$scope.sku = $slatwall.newSku();
		$scope.saveSku = 
			function(){
				$scope.sku.$$save();
			}
	}
]);
