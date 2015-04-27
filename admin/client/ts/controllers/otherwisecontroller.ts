'use strict';
angular.module('slatwalladmin').controller('otherwiseController', [
	'$scope',
	function(
		$scope
	){
		$scope.$id="otherwiseController";
        console.log('otherwise');
        console.log($scope);
	}
]);