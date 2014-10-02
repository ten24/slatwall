'use strict';
angular.module('slatwalladmin').controller('alertController', [
	'$scope',
	'alertService',
function(
	$scope,
	alertService
){
	$scope.alerts = alertService.getAlerts();
}]);