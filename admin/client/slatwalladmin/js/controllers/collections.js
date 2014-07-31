angular.module('slatwalladmin')
//using $location to get url params, this will probably change to using routes eventually
.controller('collections', [ '$scope','$location','slatwallService', function($scope,$location,slatwallService){
	
	//get url param to retrieve collection listing
	$scope.collectionID = $location.search().collectionid;
	var collectionListingPromise = slatwallService.getEntity('collection',$scope.collectionID);
	
	collectionListingPromise.then(function(value){
		$scope.collection = value;
		$scope.collectionNameDisplay = $scope.collection.collectionName + ' Listing';
		
		//$scope.collection.totalPagesArray = new Array(parseInt($scope.collection.totalPages));
		
	},function(reason){
		//display error message
	});
	
	//populate existing collections drop down
	var existingCollectionsPromise = slatwallService.getExistingCollections();
	existingCollectionsPromise.then(function(value){
		$scope.existingCollections = value.DATA;
		console.log($scope.existingCollections);
	},function(reason){
		
	});
	
	
	
	
}]);
