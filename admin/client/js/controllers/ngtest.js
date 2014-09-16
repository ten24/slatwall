angular.module('slatwalladmin').controller('ngtest', [ '$scope','slatwallService', function($scope,slatwallService){
	$scope.myVal = 'controller value injected';
	var promise = slatwallService.getEntity('collection','abcd');
	console.log(promise);
	promise.then(function(value){
		console.log(value);
	},function(reason){
		
	});
	
	var postData = {
		collectionName:"postCollectionName",
		context:"save"
	};
	
	var postPromise = slatwallService.saveEntity('collection','abcd',postData);
		
	
}]);
