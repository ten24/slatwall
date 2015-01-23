angular.module('slatwalladmin').controller('ngtest', [ 
	'$scope',
	'$slatwall', 
	function(
		$scope,
		$slatwall
	){
		$scope.sku = $slatwall.newSku();
		$scope.saveSku = function(){
			$scope.sku.$$save();
		}
	}
]);
