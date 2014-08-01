angular.module('slatwalladmin')
//using $location to get url params, this will probably change to using routes eventually
.controller('collections', [ '$scope','$location','slatwallService', function($scope,$location,slatwallService){
	
	
	//get url param to retrieve collection listing
	$scope.collectionID = $location.search().collectionid;
	var collectionListingPromise = slatwallService.getEntity('collection',$scope.collectionID);
	
	collectionListingPromise.then(function(value){
		$scope.collection = value;
		$scope.collectionConfig = JSON.parse($scope.collection.collectionConfig);
		console.log($scope.collectionConfig);
		//$scope.collection.totalPagesArray = new Array(parseInt($scope.collection.totalPages));
		
		var filterPropertiesPromise = slatwallService.getFilterPropertiesByBaseEntityName($scope.collectionConfig.baseEntityAlias);
		
		filterPropertiesPromise.then(function(value){
			$scope.filterProperties = value;
			console.log($scope.filterProperties);
		}, function(reason){
			
		});
		
	},function(reason){
		//display error message
	});
	
	//populate existing collections drop down
	var existingCollectionsPromise = slatwallService.getExistingCollections();
	existingCollectionsPromise.then(function(value){
		$scope.existingCollections = value.DATA;
	},function(reason){
		
	});
	
	
	
	$scope.copyExistingCollection = function(){
		console.log($scope.selectedExistingCollection);
		$scope.collection.collectionConfig = $scope.selectedExistingCollection;
	}
	
	$scope.setSelectedExistingCollection = function(selectedExistingCollection){
		$scope.selectedExistingCollection = selectedExistingCollection;
	}
	
	
}]);
