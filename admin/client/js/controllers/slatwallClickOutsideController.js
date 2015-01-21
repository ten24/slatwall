'use strict';
angular.module('slatwalladmin').controller('slatwallClickOutsideController', [
    '$scope',
function(
	$scope
){

	$scope.closeThis = function (callBackArgs) {
		//Check against the condition
		if(callBackArgs.callBackCondition){
			//Perform all callback actions
	        for(var callBackAction in callBackArgs.callBackActions){
	        	callBackArgs.callBackActions[callBackAction]();

	        }
		}
    }
    	
}]);