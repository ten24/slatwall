angular.module('slatwalladmin')
//using $location to get url params, this will probably change to using routes eventually
.controller('collections', [ '$scope','$location','slatwallService','alertService','$log', function($scope,$location,slatwallService,alertService,$log){
	//init values
	$scope.pageShowOptions = [
		{display:5,value:5},
		{display:10,value:10},
		{display:20,value:20},
		{display:"All",value:"All"}
	];
	$scope.pageShowOptions.selected = $scope.pageShowOptions[1];
	
	//get url param to retrieve collection listing
	$scope.collectionID = $location.search().collectionID;
	var collectionListingPromise = slatwallService.getEntity('collection',$scope.collectionID);
	collectionListingPromise.then(function(value){
		$scope.collection = value;
		$scope.collectionInitial = angular.copy($scope.collection);
		$scope.collectionConfig = JSON.parse($scope.collection.collectionConfig);
		//$scope.filterGroups = $scope.collectionConfig.filterGroups;
		//console.log($scope.filterGroups[0].filterGroup[2].hasOwnProperty('filterGroup'));
		//on the backend everything is treated as a filter group. To the user, a filter group with only one filter is seen as a filter and not a filter group
		console.log($scope.collection);
		console.log($scope.collectionConfig);
		console.log($scope.collectionConfig.hasOwnProperty('filterGroups'));
		//$scope.collection.totalPagesArray = new Array(parseInt($scope.collection.totalPages));
		
		//add filterProperties
		/*var filterPropertiesPromise = slatwallService.getFilterPropertiesByBaseEntityName($scope.collectionConfig.baseEntityAlias);
		
		filterPropertiesPromise.then(function(value){
			//var fomattedFilterProperties = slatwallService.formatFilterProperties(value)
			
			$scope.filterProperties = value;
			//console.log($scope.filterProperties);
		}, function(reason){
			
		});
		
		//populate existing collections drop down
		var existingCollectionsPromise = slatwallService.getExistingCollectionsByBaseEntity($scope.collectionConfig.baseEntityName);
		existingCollectionsPromise.then(function(value){
			$scope.existingCollections = value.DATA;
		},function(reason){
			
		});*/
		
	},function(reason){
		//display error message if getter fails
		var messages = reason.MESSAGES;
		var alerts = alertService.formatMessagesToAlerts(messages);
		alertService.addAlerts(alerts);
	});
	
	//public functions
	$scope.saveCollection = function(entityName,collection,collectionForm){
		
		if(isFormValid(collectionForm)){
			var data = angular.copy(collection);
			//has to be removed in order to save transient correctly
			delete data.pageRecords;
			
			var saveCollectionPromise = slatwallService.saveEntity(entityName,collection.collectionID,data);
			saveCollectionPromise.then(function(value){
				var messages = value.MESSAGES;
				var alerts = alertService.formatMessagesToAlerts(messages);
				alertService.addAlerts(alerts);
			}, function(reason){
				//revert to original
				$scope.collection = angular.copy($scope.collectionInitial);
				var messages = reason.MESSAGES;
				var alerts = alertService.formatMessagesToAlerts(messages);
				alertService.addAlerts(alerts);
			});
		}
	}
	
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
	
	$scope.pageShowOptionChanged = function(pageShowOption){
		slatwallService.getEntity('collection',$scope.collectionID);
	}
	
	//private Function
	var isFormValid = function (angularForm){
		var formValid = true;
	     for (field in angularForm) {
	         // look at each form input with a name attribute set
	         // checking if it is pristine and not a '$' special field
	         if (field[0] != '$') {
			 	// need to use formValid variable instead of formController.$valid because checkbox dropdown is not an input
				// and somehow formController didn't invalid if checkbox dropdown is invalid
			 	if (angularForm[field].$invalid) {
					formValid = false;
				}
				if (angularForm[field].$pristine) {
					if (angularForm[field].$viewValue === undefined) {
						angularForm[field].$setViewValue("");
					}
					else {
						angularForm[field].$setViewValue(angularForm[field].$viewValue);
					}
				}
	         }
	     }
		 return formValid;   
	};
}]);
