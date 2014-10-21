'use strict';
angular.module('slatwalladmin')
//using $location to get url params, this will probably change to using routes eventually
.controller('collections', 
[ '$scope',
'$location',
'$slatwall',
'alertService',
'collectionService', 
'metadataService',
'paginationService',
'$log',
'$timeout',
function($scope,
$location,
$slatwall,
alertService,
collectionService,
metadataService,
paginationService,
$log,
$timeout
){
	
	//init values
	//$scope.collectionTabs =[{tabTitle:'PROPERTIES',isActive:true},{tabTitle:'FILTERS ('+filterCount+')',isActive:false},{tabTitle:'DISPLAY OPTIONS',isActive:false}];
	$scope.$id="collectionsController";
	//get url param to retrieve collection listing
	$scope.collectionID = $location.search().collectionID;
	$scope.currentPage= paginationService.getCurrentPage();
	$scope.pageShow = paginationService.getPageShow();
	$scope.pageStart = paginationService.getPageStart;
	$scope.pageEnd = paginationService.getPageEnd;
	$scope.recordsCount = paginationService.getRecordsCount;
	$scope.autoScrollPage = 1;
	$scope.autoScrollDisabled = false;
	
	$scope.$watch('pageShow',function(newValue,oldValue){
		if(newValue !== oldValue){
			$log.debug('pageShowChanged');
			$scope.currentPage = 1;
			paginationService.setCurrentPage(1);
			$scope.getCollection();
		}
	});
	
	$scope.$watch('currentPage',function(newValue,oldValue){
		if(newValue !== oldValue){
			$log.debug('currentPageChanged');
			if($scope.pageShow === 'Auto'){
				$scope.autoScrollPage = 1;
				$scope.appendToCollection();
			}else{
				$scope.getCollection();
			}
		}
	});
	
	$scope.appendToCollection = function(){
		if($scope.pageShow === 'Auto'){
			$log.debug('AppendToCollection');
			if($scope.autoScrollPage < $scope.collection.totalPages){
				$scope.autoScrollDisabled = true;
				$scope.autoScrollPage++;
				
				var collectionListingPromise = $slatwall.getEntity('collection', {id:$scope.collectionID, currentPage:$scope.autoScrollPage, pageShow:50});
				collectionListingPromise.then(function(value){
					
					$scope.collection.pageRecords = collectionService.getCollection().pageRecords.concat(value.pageRecords);
					collectionService.setCollection($scope.collection);
					$scope.autoScrollDisabled = false;
				},function(reason){
					//display error message if getter fails
					var messages = reason.MESSAGES;
					var alerts = alertService.formatMessagesToAlerts(messages);
					alertService.addAlerts(alerts);
				});
			}
		}
	};
	
	$scope.keywords = "";
	$scope.searchCollection = function(){
		$log.debug('search with keywords');
		$log.debug($scope.keywords);
		$timeout($scope.getCollection(), 3000);
		$log.debug();
	};

	$scope.getCollection = function(){
		var pageShow = 50;
		if($scope.pageShow !== 'Auto'){
			pageShow = $scope.pageShow;
		}
		
		var collectionListingPromise = $slatwall.getEntity('collection', {id:$scope.collectionID, currentPage:$scope.currentPage, pageShow:pageShow, keywords:$scope.keywords});
		collectionListingPromise.then(function(value){
			collectionService.setCollection(value);
			$scope.collection = collectionService.getCollection();
			$scope.collectionInitial = angular.copy(collectionService.getCollection());
			if(angular.isUndefined($scope.collectionConfig)){
				$scope.collectionConfig = collectionService.getCollectionConfig();
			}
			//check if we have any filter Groups
			$scope.collectionConfig.filterGroups = collectionService.getRootFilterGroup();
		},function(reason){
			//display error message if getter fails
			var messages = reason.MESSAGES;
			var alerts = alertService.formatMessagesToAlerts(messages);
			alertService.addAlerts(alerts);
		});
	};
	
	$scope.getCollection();
	
	var unbindCollectionObserver = $scope.$watch('collection',function(newValue,oldValue){
		if(newValue !== oldValue){
			if(angular.isUndefined($scope.filterPropertiesList)){
				$scope.filterPropertiesList = {};
				var filterPropertiesPromise = $slatwall.getFilterPropertiesByBaseEntityName($scope.collectionConfig.baseEntityAlias);
				filterPropertiesPromise.then(function(value){
					metadataService.setPropertiesList(value,$scope.collectionConfig.baseEntityAlias);
					$scope.filterPropertiesList[$scope.collectionConfig.baseEntityAlias] = metadataService.getPropertiesListByBaseEntityAlias($scope.collectionConfig.baseEntityAlias);
					metadataService.formatPropertiesList($scope.filterPropertiesList[$scope.collectionConfig.baseEntityAlias],$scope.collectionConfig.baseEntityAlias);
				}, function(reason){
					
				});
			}
			unbindCollectionObserver();
		}
	});
	
	$scope.setCollectionForm= function(form){
	   $scope.collectionForm = form;
	};
	
	
	$scope.collectionDetails = {
		isOpen:false,
		openCollectionDetails:function(){
			$scope.collectionDetails.isOpen = true;
		}
	};
	
	$scope.errorMessage = {
			
	};
	
	$scope.saveCollection = function(){
		$log.debug('saving Collection');
		
		var entityName = 'collection';
		var collection = $scope.collection;
		$log.debug($scope.collectionConfig);
		var collectionConfigString = collectionService.stringifyJSON($scope.collectionConfig);
		$log.debug(collectionConfigString);
		collection.collectionConfig = collectionConfigString;
		if(isFormValid($scope.collectionForm)){
			var data = angular.copy(collection);
			//has to be removed in order to save transient correctly
			delete data.pageRecords;
			
			var saveCollectionPromise = $slatwall.saveEntity(entityName,collection.collectionID,data);
			saveCollectionPromise.then(function(value){
				var messages = value.MESSAGES;
				var alerts = alertService.formatMessagesToAlerts(messages);
				alertService.addAlerts(alerts);
				$scope.errorMessage = {};
				//$scope.collectionForm.$setPristine();
				$scope.getCollection();
				$scope.collectionDetails.isOpen = false;
				//$scope.collectionConfig = $scope.collectionConfigCopy;
			}, function(reason){
				//revert to original
				angular.forEach(reason.errors,function(value,key){
					$scope.collectionForm[key].$invalid = true;
					$scope.errorMessage[key] = value[0];
				});
				//$scope.collection = angular.copy($scope.collectionInitial);
				var messages = reason.MESSAGES;
				var alerts = alertService.formatMessagesToAlerts(messages);
				alertService.addAlerts(alerts);
			});
		}
	};
	
	var isFormValid = function (angularForm){
		$log.debug('validateForm');
		var formValid = true;
	     for (var field in angularForm) {
	         // look at each form input with a name attribute set
	         // checking if it is pristine and not a '$' special field
	         if (field[0] != '$') {
			 	// need to use formValid variable instead of formController.$valid because checkbox dropdown is not an input
				// and somehow formController didn't invalid if checkbox dropdown is invalid
			 	if (angularForm[field].$invalid) {
					formValid = false;
					for(var error in angularForm[field].$error){
						if(error == 'required'){
							$scope.errorMessage[field] = 'This field is required';
						}
					}
					
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
	
	
	
	$scope.filterCount = collectionService.getFilterCount;
	
}]);
