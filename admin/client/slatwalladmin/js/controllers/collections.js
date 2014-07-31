angular.module('slatwalladmin')
//using $location to get url params, this will probably change to using routes eventually
.controller('collections', [ '$scope','$location','slatwallService', function($scope,$location,slatwallService){
	//get url param
	$scope.collectionID = $location.search().collectionid;
	var collectionPromise = slatwallService.getEntity('collection',$scope.collectionID);
	
	collectionPromise.then(function(value){
		$scope.collection = value;
		$scope.collectionNameDisplay = $scope.collection.collectionName + ' Listing';
		
		$scope.collection.totalPagesArray = new Array(parseInt($scope.collection.totalPages));
		
	},function(reason){
		//display error message
	});
	
	
	
	
}]);
