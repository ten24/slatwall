'use strict';
angular.module('slatwalladmin')
    .controller('createCollection', [
    '$scope', '$log', '$timeout', '$slatwall', 'collectionService', 'formService',
    'metadataService', 'paginationService', 'dialogService', 'observerService', 'selectionService',
    function ($scope, $log, $timeout, $slatwall, collectionService, formService, metadataService, paginationService, dialogService, observerService, selectionService) {
        $scope.params = dialogService.getCurrentDialog().params;
        $scope.myCollection = new slatwalladmin.CollectionConfig($slatwall, $scope.params.entityName);
        $scope.keywords = '';
        $scope.paginator = paginationService.createPagination();
        //$scope.isRadio = true;
        //$scope.closeSaving = true;
        $scope.newCollection = $slatwall.newCollection();
        $scope.newCollection.data.collectionCode = $scope.params.entityName + "-" + new Date().valueOf();
        $scope.newCollection.data.collectionObject = $scope.params.entityName;
        if (angular.isDefined($scope.params.entityID)) {
            $scope.newCollection.data.collectionID = $scope.params.entityID;
            $timeout(function () {
                $scope.newCollection.forms['form.createCollection'].$setDirty();
            });
        }
        if (angular.isDefined($scope.params.collectionName)) {
            $scope.newCollection.data.collectionName = $scope.params.collectionName;
            $timeout(function () {
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
            if (angular.isDefined($scope.params.entityID)) {
                collectionOptions = {
                    id: $scope.params.entityID,
                    currentPage: $scope.paginator.getCurrentPage(),
                    pageShow: $scope.paginator.getPageShow(),
                    keywords: $scope.keywords
                };
            }
            else {
                collectionOptions = $scope.myCollection.getOptions();
            }
            $log.debug($scope.myCollection.getOptions());
            var collectionListingPromise = $slatwall.getEntity($scope.myCollection.getEntityName(), collectionOptions);
            collectionListingPromise.then(function (value) {
                $scope.collection = value;
                $scope.collection.collectionObject = $scope.myCollection.baseEntityName;
                $scope.collectionInitial = angular.copy($scope.collection);
                $scope.paginator.setRecordsCount($scope.collection.recordsCount);
                $scope.paginator.setPageRecordsInfo($scope.collection.recordsCount, $scope.collection.pageRecordsStart, $scope.collection.pageRecordsEnd, $scope.collection.totalPages);
                if (angular.isUndefined($scope.myCollection.columns)) {
                    var colConfig = angular.fromJson(value.collectionConfig);
                    colConfig.baseEntityName = colConfig.baseEntityName.replace(new RegExp('^' + hibachiConfig.applicationKey, 'i'), '');
                    $scope.myCollection.loadJson(colConfig);
                }
                if (angular.isUndefined($scope.collectionConfig)) {
                    $scope.collectionConfig = $scope.myCollection.getCollectionConfig();
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
                    var filterPropertiesPromise = $slatwall.getFilterPropertiesByBaseEntityName($scope.collectionConfig.baseEntityAlias);
                    filterPropertiesPromise.then(function (value) {
                        metadataService.setPropertiesList(value, $scope.collectionConfig.baseEntityAlias);
                        $scope.filterPropertiesList[$scope.collectionConfig.baseEntityAlias] = metadataService.getPropertiesListByBaseEntityAlias($scope.collectionConfig.baseEntityAlias);
                        metadataService.formatPropertiesList($scope.filterPropertiesList[$scope.collectionConfig.baseEntityAlias], $scope.collectionConfig.baseEntityAlias);
                    });
                }
                unbindCollectionObserver();
            }
        });
        var filterItemCounter = function (filterGroupArray) {
            var filterItemCount = 0;
            if (!angular.isDefined(filterGroupArray)) {
                filterGroupArray = $scope.collectionConfig.filterGroups[0].filterGroup;
            }
            //Start out loop
            for (var index in filterGroupArray) {
                //If filter isn't new then increment the count
                if (!filterGroupArray[index].$$isNew && !angular.isDefined(filterGroupArray[index].filterGroup)) {
                    filterItemCount++;
                }
                else if (angular.isDefined(filterGroupArray[index].filterGroup)) {
                    //Call function recursively
                    filterItemCount += filterItemCounter(filterGroupArray[index].filterGroup);
                }
                else {
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
        $scope.searchCollection = function () {
            if (searchPromise) {
                $timeout.cancel(searchPromise);
            }
            searchPromise = $timeout(function () {
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
            if ($scope.closeSaving)
                return;
            $scope.closeSaving = true;
            if (!angular.isUndefined(selectionService.getSelections('collectionSelection'))
                && (selectionService.getSelections('collectionSelection').length > 0)) {
                $scope.collectionConfig.filterGroups[0].filterGroup = [
                    {
                        "displayPropertyIdentifier": $slatwall.getRBKey("entity." + $scope.myCollection.baseEntityName.toLowerCase() + "." + $scope.myCollection.collection.$$getIDName().toLowerCase()),
                        "propertyIdentifier": $scope.myCollection.baseEntityAlias + "." + $scope.myCollection.collection.$$getIDName(),
                        "comparisonOperator": "in",
                        "value": selectionService.getSelections('collectionSelection').join(),
                        "displayValue": selectionService.getSelections('collectionSelection').join(),
                        "ormtype": "string",
                        "fieldtype": "id",
                        "conditionDisplay": "In List"
                    }
                ];
            }
            $scope.newCollection.data.collectionConfig = $scope.collectionConfig;
            if (!$scope.newCollection.data.collectionConfig.baseEntityName.startsWith(hibachiConfig.applicationKey))
                $scope.newCollection.data.collectionConfig.baseEntityName = hibachiConfig.applicationKey + $scope.newCollection.data.collectionConfig.baseEntityName;
            $scope.newCollection.$$save().then(function () {
                observerService.notify('addCollection', $scope.newCollection.data);
                dialogService.removePageDialog($index);
                $scope.closeSaving = false;
            }, function () {
                $scope.closeSaving = false;
            });
        };
    }
]);

//# sourceMappingURL=../controllers/createcollection.js.map