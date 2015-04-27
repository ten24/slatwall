"use strict";

angular.module("slatwalladmin").directive("swContentList", ["$log", "$timeout", "$slatwall", "partialsPath", "paginationService", function ($log, $timeout, $slatwall, partialsPath, paginationService) {
    return {
        restrict: "E",
        templateUrl: partialsPath + "content/contentlist.html",
        link: function (scope, element, attr) {
            $log.debug("slatwallcontentList init");
            var pageShow = 50;
            if (scope.pageShow !== "Auto") {
                pageShow = scope.pageShow;
            }

            var columnsConfig = [{
                propertyIdentifier: "_content.contentID",
                isVisible: false,
                ormtype: "id",
                isSearchable: false
            }, {
                propertyIdentifier: "_content.title",
                isVisible: true,
                ormtype: "string",
                isSearchable: true
            }, {
                propertyIdentifier: "_content.site.siteName",
                isVisible: true,
                ormtype: "string",
                isSearchable: true
            }, {
                propertyIdentifier: "_content.contentTemplateFile",
                persistent: false,
                setting: true,
                isVisible: true,
                isSearchable: false
            },
            //need to get template via settings
            {
                propertyIdentifier: "_content.allowPurchaseFlag",
                isVisible: true,
                isSearchable: false
            }, {
                propertyIdentifier: "_content.productListingPageFlag",
                isVisible: true,
                isSearchable: false
            }, {
                propertyIdentifier: "_content.activeFlag",
                isVisible: true,
                isSearchable: false
            }];

            var filterGroupsConfig = [{
                filterGroup: [{
                    propertyIdentifier: "_content.parentContent",
                    comparisonOperator: "is",
                    value: "null"
                }]
            }];

            scope.getCollection = function () {
                var collectionListingPromise = $slatwall.getEntity(scope.entityName, {
                    currentPage: scope.currentPage,
                    pageShow: pageShow,
                    keywords: scope.keywords,
                    columnsConfig: angular.toJson(columnsConfig),
                    filterGroupsConfig: angular.toJson(filterGroupsConfig)
                });
                collectionListingPromise.then(function (value) {
                    scope.collection = value;
                    scope.collectionConfig = angular.fromJson(scope.collection.collectionConfig);
                    scope.collectionConfig.columns = columnsConfig;
                    scope.collection.collectionConfig = scope.collectionConfig;
                    //scope.contents = $slatwall.populateCollection(value.pageRecords,scope.collectionConfig);
                });
            };
            scope.getCollection();

            scope.keywords = "";
            scope.loadingCollection = false;
            var searchPromise;
            scope.searchCollection = function () {
                if (searchPromise) {
                    $timeout.cancel(searchPromise);
                }

                searchPromise = $timeout(function () {
                    $log.debug("search with keywords");
                    $log.debug(scope.keywords);
                    //Set current page here so that the pagination does not break when getting collection
                    paginationService.setCurrentPage(1);
                    scope.loadingCollection = true;
                    scope.getCollection();
                }, 500);
            };
        }
    };
}]);