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
		
		//add filterProperties
		var filterPropertiesPromise = slatwallService.getFilterPropertiesByBaseEntityName($scope.collectionConfig.baseEntityAlias);
		
		filterPropertiesPromise.then(function(value){
			//var fomattedFilterProperties = slatwallService.formatFilterProperties(value)
			
			$scope.filterProperties = value;
			console.log($scope.filterProperties);
		}, function(reason){
			
		});
		
		//populate existing collections drop down
		var existingCollectionsPromise = slatwallService.getExistingCollectionsByBaseEntity($scope.collectionConfig.baseEntityAlias);
		existingCollectionsPromise.then(function(value){
			$scope.existingCollections = value.DATA;
		},function(reason){
			
		});
		
	},function(reason){
		//display error message
	});
	
	
	
	
	//public functions
	$scope.copyExistingCollection = function(){
		console.log($scope.selectedExistingCollection);
		$scope.collection.collectionConfig = $scope.selectedExistingCollection;
	}
	
	$scope.setSelectedExistingCollection = function(selectedExistingCollection){
		$scope.selectedExistingCollection = selectedExistingCollection;
	}
	
	$scope.setSelectedFilterProperty = function(selectedFilterProperty){
		$scope.selectedFilterProperty = selectedFilterProperty;
		console.log($scope.selectedFilterProperty);
		
		//after we have selected a property we need to figure out what to show them
		if(typeof $scope.selectedFilterProperty.ORMTYPE !== "undefined"){
			switch($scope.selectedFilterProperty.ORMTYPE){
				case "boolean":
					//then display partial for boolean toggle
					break;
				case "one-to-many":
					//load partial of join relationship
					break;
				case "timestamp":
					//load partial for handling dates and times
					break;
			}
		}
		if(typeof $scope.selectedFilterProperty.FIELDTYPE !== "undefined"){
			switch($scope.selectedFilterProperty.FIELDTYPE){
				case "many-to-one":
					//display partial for many-to-one
					break;
				case "one-to-many":
					//display partial for one-to-many
					break;
				case "many-to-many":
					//display partail for many-to-many
					break;
				case "one-to-one":
					//... one-to-one
					break;
			}
		}
	}
	
	
}]);
