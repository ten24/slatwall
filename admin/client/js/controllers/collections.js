'use strict';
angular.module('slatwalladmin')
//using $location to get url params, this will probably change to using routes eventually
.controller('collections', 
[ '$scope',
'$location',
'slatwallService',
'alertService',
'collectionService', 
'$log',
function($scope,
$location,
slatwallService,
alertService,
collectionService,
$log
){
	
	//init values
	
	$scope.pageShowOptions = [
		{display:5,value:5},
		{display:10,value:10},
		{display:20,value:20},
		{display:"All",value:"All"}
	];
	$scope.pageShowOptions.selected = $scope.pageShowOptions[1];
	
	$scope.filterCount = 0;
	$scope.incrementFilterCount = function(number){
		if(angular.isDefined(number)){
			$scope.filterCount = $scope.filterCount + number;
		}
	};
	
	//$scope.collectionTabs =[{tabTitle:'PROPERTIES',isActive:true},{tabTitle:'FILTERS ('+filterCount+')',isActive:false},{tabTitle:'DISPLAY OPTIONS',isActive:false}];
	
	
	//get url param to retrieve collection listing
	$scope.collectionID = $location.search().collectionID;
	
	
	$scope.getCollection = function(){
		var collectionListingPromise = slatwallService.getEntity('collection',$scope.collectionID);
		collectionListingPromise.then(function(value){
			$scope.collection = value;
			$scope.collectionInitial = angular.copy($scope.collection);
			if(angular.isUndefined($scope.collectionConfig)){
				$scope.collectionConfig = angular.fromJson($scope.collection.collectionConfig);
			}
			
			//check if we have any filter Groups
			//console.log($scope.collectionConfig.columns);
			if(angular.isUndefined($scope.collectionConfig.filterGroups)){
				$scope.collectionConfig.filterGroups = [
					{
						filterGroup:[
							
						]
					}
				];
			}
			
			var filterPropertiesPromise = slatwallService.getFilterPropertiesByBaseEntityName($scope.collectionConfig.baseEntityAlias);
			filterPropertiesPromise.then(function(value){
				$scope.filterPropertiesList = value;
				collectionService.formatFilterPropertiesList($scope.filterPropertiesList);
			}, function(reason){
				
			});
			
		},function(reason){
			//display error message if getter fails
			var messages = reason.MESSAGES;
			var alerts = alertService.formatMessagesToAlerts(messages);
			alertService.addAlerts(alerts);
		});
	};
	
	$scope.getCollection();
	
	$scope.setCollectionForm= function(form){
	   $scope.collectionForm = form;
	};
	
	//public functions
	$scope.saveCollection = function(){
		$log.debug('saving Collection');
		var entityName = 'collection';
		var collection = $scope.collection;
		$log.debug($scope.collectionConfig);
		var collectionConfigString = collectionService.stringifyJSON($scope.collectionConfig);
		$log.debug(collectionConfigString);
		collection.collectionConfig = collectionConfigString;
		console.log(collection);
		console.log($scope.collectionConfig);
		var collectionForm = $scope.collectionFormScope;
		if(isFormValid(collectionForm)){
			var data = angular.copy(collection);
			//has to be removed in order to save transient correctly
			delete data.pageRecords;
			
			var saveCollectionPromise = slatwallService.saveEntity(entityName,collection.collectionID,data);
			saveCollectionPromise.then(function(value){
				var messages = value.MESSAGES;
				var alerts = alertService.formatMessagesToAlerts(messages);
				alertService.addAlerts(alerts);
				
				$scope.getCollection();
				//$scope.collectionConfig = $scope.collectionConfigCopy;
			}, function(reason){
				//revert to original
				$scope.collection = angular.copy($scope.collectionInitial);
				var messages = reason.MESSAGES;
				var alerts = alertService.formatMessagesToAlerts(messages);
				alertService.addAlerts(alerts);
			});
		}
	};
	
	$scope.copyExistingCollection = function(){
		$scope.collection.collectionConfig = $scope.selectedExistingCollection;
	};
	
	$scope.setSelectedExistingCollection = function(selectedExistingCollection){
		$scope.selectedExistingCollection = selectedExistingCollection;
	};
	
	$scope.setSelectedFilterProperty = function(selectedFilterProperty){
		$scope.selectedFilterProperty = selectedFilterProperty;
		
		//after we have selected a property we need to figure out what to show them
		if(angular.isDefined($scope.selectedFilterProperty.ormtype)){
			switch($scope.selectedFilterProperty.ormtype){
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
		if(angular.isDefined($scope.selectedFilterProperty.fieldtype)){
			switch($scope.selectedFilterProperty.fieldtype){
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
	};
	
	$scope.pageShowOptionChanged = function(pageShowOption){
		slatwallService.getEntity('collection',$scope.collectionID);
	};
	
	
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
					if (angular.isUndefined(angularForm[field].$viewValue)) { 
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
