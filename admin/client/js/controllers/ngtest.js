angular.module('slatwalladmin').controller('ngtest', [ 
	'$scope',
	'$slatwall', 
	function(
		$scope,
		$slatwall
	){
		$scope.myVal = 'controller value injected';
		var promise = $slatwall.getEntity('collection','abcd');
		console.log(promise);
		promise.then(function(value){
			console.log(value);
		},function(reason){
			
		});
		
		var postData = {
			collectionName:"postCollectionName",
			context:"save"
		};
		
		var postPromise = $slatwall.saveEntity('collection','abcd',postData);
	
	}
]);
