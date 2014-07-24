angular.module('slatwalladmin').controller('ngtest', [ '$scope','slatwallService', function($scope,slatwallService){
	console.log(slatwallService.getEntity('product','2c909fc546edd3000146edddda920004'));
	$scope.myVal = 'controller value injected';
}]);
