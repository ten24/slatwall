/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class CreateCollection{

    //@ngInject
    constructor(
        $scope, $log, $timeout, $hibachi, collectionService, metadataService, paginationService, dialogService,
        observerService, selectionService,collectionConfigService, rbkeyService, $window
    ){
        $window.scrollTo(0,0);
        $scope.params = dialogService.getCurrentDialog().params;
        $scope.readOnly = angular.isDefined($scope.params.readOnly) && $scope.params.readOnly == true;

        $scope.myCollection = collectionConfigService.newCollectionConfig($scope.params.entityName);
        var hibachiConfig = $hibachi.getConfig();

        if($scope.params.entityName == 'Type' && angular.isUndefined($scope.params.entityId) && angular.isDefined($scope.params.parentEntity)){
            $scope.params.parentEntity = $scope.params.parentEntity.replace(new RegExp('^'+hibachiConfig.applicationKey, 'i'), '');
            var systemCode = $scope.params.parentEntity.charAt(0).toLowerCase() + $scope.params.parentEntity.slice(1) + 'Type';
            $scope.myCollection.addFilter('parentType.systemCode', systemCode);
        }

        $scope.keywords = '';
        $scope.paginator = paginationService.createPagination();

        //$scope.isRadio = true;
        $scope.hideEditView=true;
        //$scope.closeSaving = true;
        $scope.hasSelection = selectionService.getSelectionCount;
        $scope.idsSelected = selectionService.getSelections;
        $scope.unselectAll = function () {
            selectionService.clearSelections('collectionSelection');
            $scope.getCollection();
        };

        $scope.newCollection = $hibachi.newCollection();
        $scope.newCollection.data.collectionCode = $scope.params.entityName+"-"+new Date().valueOf();
        $scope.newCollection.data.collectionObject = $scope.params.entityName;



        if(angular.isDefined($scope.params.entityId)){
            $scope.newCollection.data.collectionID = $scope.params.entityId;
            $timeout(function(){
                $scope.newCollection.forms['form.createCollection'].$setDirty();

            });
        }

        if(angular.isDefined($scope.params.collectionName)){
            $scope.newCollection.data.collectionName = $scope.params.collectionName;
            $timeout(function(){
                $scope.newCollection.forms['form.createCollection'].$setDirty();

            });
        }

        $scope.saveCollection = function () {
            $scope.myCollection.loadJson($scope.collectionConfig);
            $scope.getCollection();
        };

        $scope.getCollection = function () {
            $scope.closeSaving = true;
            $scope.myCollection.setPageShow($scope.paginator.getPageShow());
            $scope.myCollection.setCurrentPage($scope.paginator.getCurrentPage());
            $scope.myCollection.setKeywords($scope.keywords);

            var collectionOptions;

            if(angular.isDefined($scope.params.entityId)){
                collectionOptions= {
                    id:$scope.params.entityId,
                    currentPage:$scope.paginator.getCurrentPage(),
                    pageShow:$scope.paginator.getPageShow(),
                    keywords:$scope.keywords
                }
            }else{
                collectionOptions = $scope.myCollection.getOptions()
            }

            $log.debug($scope.myCollection.getOptions());
            var collectionListingPromise = $hibachi.getEntity(
                $scope.myCollection.getEntityName(), collectionOptions
            );
            collectionListingPromise.then(function (value) {
                if(angular.isDefined($scope.params.entityId)){
                    $scope.newCollection.data.collectionName = value.collectionName;
                }
                $scope.collection = value;
                $scope.collection.collectionObject = $scope.myCollection.baseEntityName;
                $scope.collectionInitial = angular.copy($scope.collection);
                $scope.paginator.setRecordsCount( $scope.collection.recordsCount);
                $scope.paginator.setPageRecordsInfo($scope.collection);

               if(angular.isUndefined($scope.myCollection.columns)){
                    var colConfig = angular.fromJson(value.collectionConfig)
                    colConfig.baseEntityName = colConfig.baseEntityName.replace(new RegExp('^'+hibachiConfig.applicationKey, 'i'), '');
                    $scope.myCollection.loadJson(colConfig);
                }

                if (angular.isUndefined($scope.collectionConfig)) {
                    var tempCollectionConfig = collectionConfigService.newCollectionConfig();
                    tempCollectionConfig.loadJson(value.collectionConfig);
                    $scope.collectionConfig = tempCollectionConfig.getCollectionConfig();
                }
                if (angular.isUndefined($scope.collectionConfig.filterGroups) || !$scope.collectionConfig.filterGroups.length) {
                    $scope.collectionConfig.filterGroups = [
                        {
                            filterGroup: []
                        }
                    ];
                }



                collectionService.setFilterCount(filterItemCounter());
                $scope.loadingCollection = false;
                $scope.closeSaving = false;
            }, function (reason) {
            });
            return collectionListingPromise;
        };

        $scope.paginator.collection = $scope.newCollection;
        $scope.paginator.getCollection = $scope.getCollection;

        var unbindCollectionObserver = $scope.$watch('collection', function (newValue, oldValue) {
            if (newValue !== oldValue) {
                if (angular.isUndefined($scope.filterPropertiesList)) {
                    $scope.filterPropertiesList = {};
                    var filterPropertiesPromise = $hibachi.getFilterPropertiesByBaseEntityName($scope.collectionConfig.baseEntityAlias);
                    filterPropertiesPromise.then(function (value) {
                        metadataService.setPropertiesList(value, $scope.collectionConfig.baseEntityAlias);
                        $scope.filterPropertiesList[$scope.collectionConfig.baseEntityAlias] = metadataService.getPropertiesListByBaseEntityAlias($scope.collectionConfig.baseEntityAlias);
                        metadataService.formatPropertiesList($scope.filterPropertiesList[$scope.collectionConfig.baseEntityAlias], $scope.collectionConfig.baseEntityAlias);

                    });
                }
                unbindCollectionObserver();
            }
        });

        var filterItemCounter = function (filterGroupArray?) {
            var filterItemCount = 0;

            if (!angular.isDefined(filterGroupArray)) {
                filterGroupArray = $scope.collectionConfig.filterGroups[0].filterGroup;
            }
            //Start out loop
            for (var index in filterGroupArray) {
                //If filter isn't new then increment the count
                if (!filterGroupArray[index].$$isNew && !angular.isDefined(filterGroupArray[index].filterGroup)) {
                    filterItemCount++;
                    // If there are nested filter groups run introspectively
                } else if (angular.isDefined(filterGroupArray[index].filterGroup)) {
                    //Call function recursively
                    filterItemCount += filterItemCounter(filterGroupArray[index].filterGroup);
                    //Otherwise make like the foo fighters and "Break Out!"
                } else {
                    break;
                }

            }
            return filterItemCount;
        };

        $scope.getCollection();


        $scope.copyExistingCollection = function () {
            $scope.collection.collectionConfig = $scope.selectedExistingCollection;
        };

        $scope.setSelectedExistingCollection = function (selectedExistingCollection) {
            $scope.selectedExistingCollection = selectedExistingCollection;
        };

        $scope.setSelectedFilterProperty = function (selectedFilterProperty) {
            $scope.selectedFilterProperty = selectedFilterProperty;
        };


        $scope.loadingCollection = false;
        var searchPromise;
        $scope.searchCollection = function(){
            if(searchPromise) {
                $timeout.cancel(searchPromise);
            }

            searchPromise = $timeout(function(){
                //$log.debug('search with keywords');
                //$log.debug($scope.keywords);
                //Set current page here so that the pagination does not break when getting collection
                $scope.paginator.setCurrentPage(1);
                $scope.loadingCollection = true;
                $scope.getCollection();
            }, 500);
        };

        $scope.filterCount = collectionService.getFilterCount;

        //
        $scope.hideExport = true;
        $scope.saveNewCollection = function ($index) {
            if($scope.closeSaving) return;
            $scope.closeSaving = true;

            if(!angular.isUndefined(selectionService.getSelections('collectionSelection'))
                && (selectionService.getSelections('collectionSelection').length > 0)){
                $scope.collectionConfig.filterGroups[0].filterGroup = [
                    {
                        "displayPropertyIdentifier": rbkeyService.getRBKey("entity."+$scope.myCollection.baseEntityName.toLowerCase()+"."+$scope.myCollection.collection.$$getIDName().toLowerCase()),
                        "propertyIdentifier": $scope.myCollection.baseEntityAlias + "."+$scope.myCollection.collection.$$getIDName(),
                        "comparisonOperator":"in",
                        "value":selectionService.getSelections('collectionSelection').join(),
                        "displayValue":selectionService.getSelections('collectionSelection').join(),
                        "ormtype":"string",
                        "fieldtype":"id",
                        "conditionDisplay":"In List"
                    }
                ];
            }

            $scope.newCollection.data.collectionConfig = $scope.collectionConfig;
            if($scope.newCollection.data.collectionConfig.baseEntityName.lastIndexOf(hibachiConfig.applicationKey, 0) !== 0) {
                $scope.newCollection.data.collectionConfig.baseEntityName = hibachiConfig.applicationKey + $scope.newCollection.data.collectionConfig.baseEntityName;
            }
            $scope.newCollection.$$save().then(function () {
                observerService.notify('addCollection', $scope.newCollection.data);
                selectionService.clearSelection('collectionSelection');
                dialogService.removePageDialog($index);
                $scope.closeSaving = false;
            }, function(){
                $scope.closeSaving = false;
            });
        }
    }
}
export{CreateCollection}