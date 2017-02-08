/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class CollectionController{
	//@ngInject
	constructor(
		$scope,
		$location,
		$log,
		$timeout,
		$hibachi,
		collectionService,
		metadataService,
		selectionService,
		paginationService,
		collectionConfigService,
        appConfig
	){
		//init values
		//$scope.collectionTabs =[{tabTitle:'PROPERTIES',isActive:true},{tabTitle:'FILTERS ('+filterCount+')',isActive:false},{tabTitle:'DISPLAY OPTIONS',isActive:false}];
		$scope.$id="collectionsController";
		/*used til we convert to use route params*/
		var QueryString:any = function () {
		  // This function is anonymous, is executed immediately and
		  // the return value is assigned to QueryString!
		  var query_string = {};
		  var query = window.location.search.substring(1);
		  var vars = query.split("&");
		  for (var i=0;i<vars.length;i++) {
		    var pair = vars[i].split("=");
		    	// If first entry with this name
		    if (typeof query_string[pair[0]] === "undefined") {
		      query_string[pair[0]] = pair[1];
		    	// If second entry with this name
		    } else if (typeof query_string[pair[0]] === "string") {
		      var arr = [ query_string[pair[0]], pair[1] ];
		      query_string[pair[0]] = arr;
		    	// If third or later entry with this name
		    } else {
		      query_string[pair[0]].push(pair[1]);
		    }
		  }
		    return query_string;
		} ();
		//get url param to retrieve collection listing
		$scope.collectionID = QueryString.collectionID;

		$scope.paginator = paginationService.createPagination();

		$scope.appendToCollection = function(){
			if($scope.paginator.getPageShow() === 'Auto'){
				$log.debug('AppendToCollection');
				if($scope.autoScrollPage < $scope.collection.totalPages){
					$scope.autoScrollDisabled = true;
					$scope.autoScrollPage++;

					var collectionListingPromise = $hibachi.getEntity('collection', {id:$scope.collectionID, currentPage:$scope.paginator.autoScrollPage, pageShow:50});
					collectionListingPromise.then(function(value){
						$scope.collection.pageRecords = $scope.collection.pageRecords.concat(value.pageRecords);
						$scope.autoScrollDisabled = false;
					},function(reason){
					});
				}
			}
		};

		$scope.keywords = "";
		$scope.loadingCollection = false;
		var searchPromise;
		$scope.searchCollection = function(){
			if(searchPromise) {
				$timeout.cancel(searchPromise);
			}

			searchPromise = $timeout(function(){
				$log.debug('search with keywords');
				$log.debug($scope.keywords);
				//Set current page here so that the pagination does not break when getting collection
				$scope.paginator.setCurrentPage(1);
				$scope.loadingCollection = true;
			}, 500);
		};

		$scope.getCollection = function(){
			var pageShow = 50;
			if($scope.paginator.getPageShow() !== 'Auto'){
				pageShow = $scope.paginator.getPageShow();
			}
//			$scope.currentPage = $scope.pagination.getCurrentPage();
			var collectionListingPromise = $hibachi.getEntity('collection', {id:$scope.collectionID, currentPage:$scope.paginator.getCurrentPage(), pageShow:pageShow, keywords:$scope.keywords});
			collectionListingPromise.then(function(value){
				$scope.collection = value;
				$scope.paginator.setPageRecordsInfo($scope.collection);
				$scope.collectionInitial = angular.copy($scope.collection);
				if(angular.isUndefined($scope.collectionConfig)){

                    var test = collectionConfigService.newCollectionConfig();
					test.loadJson(value.collectionConfig);
                    $scope.collectionConfig = test.getCollectionConfig();
				}

				//check if we have any filter Groups
				if(angular.isUndefined($scope.collectionConfig.filterGroups)){
					$scope.collectionConfig.filterGroups = [
						{
							filterGroup:[

							]
						}
					];
				}
				collectionService.setFilterCount(filterItemCounter());
				$scope.loadingCollection = false;
			},function(reason){
			});
            return collectionListingPromise;
		};
		$scope.paginator.getCollection = $scope.getCollection;
		$scope.getCollection();

		var unbindCollectionObserver = $scope.$watch('collection',function(newValue,oldValue){
			if(newValue !== oldValue){
				if(angular.isUndefined($scope.filterPropertiesList) ){
					$scope.filterPropertiesList = {};
					var filterPropertiesPromise = $hibachi.getFilterPropertiesByBaseEntityName($scope.collectionConfig.baseEntityAlias);
					filterPropertiesPromise.then(function(value){
						metadataService.setPropertiesList(value,$scope.collectionConfig.baseEntityAlias);
						$scope.filterPropertiesList[$scope.collectionConfig.baseEntityAlias] = metadataService.getPropertiesListByBaseEntityAlias($scope.collectionConfig.baseEntityAlias);
						metadataService.formatPropertiesList($scope.filterPropertiesList[$scope.collectionConfig.baseEntityAlias],$scope.collectionConfig.baseEntityAlias);

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

		var filterItemCounter = function(filterGroupArray?){
			var filterItemCount = 0;

			if(!angular.isDefined(filterGroupArray)){
				filterGroupArray = $scope.collectionConfig.filterGroups[0].filterGroup;
			}

			//Start out loop
			for(var index in filterGroupArray){

				//If filter isn't new then increment the count
				if(!filterGroupArray[index].$$isNew
						&& !angular.isDefined(filterGroupArray[index].filterGroup)){
					filterItemCount++;
				// If there are nested filter groups run introspectively
				} else if(angular.isDefined(filterGroupArray[index].filterGroup)){
					//Call function recursively
					filterItemCount += filterItemCounter(filterGroupArray[index].filterGroup);

				//Otherwise make like the foo fighters and "Break Out!"
				} else {
					break;
				}

			}
			return filterItemCount;
		};


		$scope.saveCollection = function(){
			$timeout(function(){
				$log.debug('saving Collection');
				var entityName = 'collection';
				var collection = $scope.collection;
				$log.debug($scope.collectionConfig);
				if(isFormValid($scope.collectionForm)){
                    if(angular.isDefined($scope.collectionConfig)
                        && angular.isDefined($scope.collectionConfig.groupBys)
                        && $scope.collectionConfig.groupBys.split(',').length != $scope.collectionConfig.columns.length) {
                        var groupbyArray = $scope.collectionConfig.groupBys.split(',');
                        for (var column = 0; column < $scope.collectionConfig.columns.length; column++) {
                            if (groupbyArray.indexOf($scope.collectionConfig.columns[column].propertyIdentifier) == -1) {
                                groupbyArray.push($scope.collectionConfig.columns[column].propertyIdentifier);
                            }
                        }
                        $scope.collectionConfig.groupBys = groupbyArray.join(',');
                    }
					var collectionConfigString = collectionService.stringifyJSON($scope.collectionConfig);
					$log.debug(collectionConfigString);
					var data = angular.copy(collection);

					data.collectionConfig = collectionConfigString;
					//has to be removed in order to save transient correctly
					delete data.pageRecords;
					var saveCollectionPromise = $hibachi.saveEntity(entityName,collection.collectionID,data,'save');
					saveCollectionPromise.then(function(value){

						$scope.errorMessage = {};
						//Set current page here so that the pagination does not break when getting collection
						$scope.paginator.setCurrentPage( 1);
						$scope.collectionDetails.isOpen = false;
					}, function(reason){
						//revert to original
						angular.forEach(reason.errors,function(value,key){
							$scope.collectionForm[key].$invalid = true;
							$scope.errorMessage[key] = value[0];
						});
						//$scope.collection = angular.copy($scope.collectionInitial);
					});
				}

				collectionService.setFilterCount(filterItemCounter());
			});
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

		};

		$scope.filterCount = collectionService.getFilterCount;

        //export action
        $scope.exportCollection = function(){

            var url = '/?'+appConfig.action+'=main.collectionExport&collectionExportID='+$scope.collectionID+'&downloadReport=1';
            var data = {
                "ids":selectionService.getSelections('collectionSelection'),
                "keywords":$scope.keywords
               };
            console.log('exportData',data);
            var target="downloadCollection";
            $('body').append('<form action="'+url+'" method="post" target="'+target+'" id="postToIframe"></form>');
            $.each(data,function(n,v){
                $('#postToIframe').append('<input type="hidden" name="'+n+'" value="'+v+'" />');
            });
            $('#postToIframe').submit().remove();
        }
	}

}
export{
	CollectionController
}

// 'use strict';
// angular.module('slatwalladmin')
// //using $location to get url params, this will probably change to using routes eventually
// .controller('collections', [
// 	'$scope',
// '$location',
// '$log',
// '$timeout',
// '$hibachi',
// 'collectionService',
// 'metadataService',
// 'selectionService',
// 'paginationService',
// 	function(
// 		$scope,
// $location,
// $log,
// $timeout,
// $hibachi,
// collectionService,
// metadataService,
// selectionService,
// paginationService
// 	){
//
// 	}
// ]);
