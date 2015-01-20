'use strict';
angular.module('slatwalladmin').controller('slatwall-clickoutside-controller', [
    '$scope',
function(
	$scope
){

	$scope.closeThis = function () {
        console.log('closing');
    }
    	
}]);