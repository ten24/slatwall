"use strict";
'use strict';
angular.module('slatwalladmin').directive('swContentList', ['$log', '$timeout', '$slatwall', 'partialsPath', 'paginationService', function($log, $timeout, $slatwall, partialsPath, paginationService) {
  return {
    restrict: 'E',
    templateUrl: partialsPath + 'content/contentlist.html',
    link: function(scope, element, attr) {
      $log.debug('slatwallcontentList init');
      var pageShow = 50;
      if (scope.pageShow !== 'Auto') {
        pageShow = scope.pageShow;
      }
      scope.loadingCollection = false;
      scope.getCollection = function(isSearching) {
        var columnsConfig = [{
          propertyIdentifier: '_content.contentID',
          isVisible: false,
          ormtype: 'id',
          isSearchable: false
        }, {
          propertyIdentifier: '_content.site.siteID',
          isVisible: false,
          ormtype: 'id',
          isSearchable: true
        }, {
          propertyIdentifier: '_content.site.siteName',
          isVisible: true,
          ormtype: 'string',
          isSearchable: true
        }, {
          propertyIdentifier: '_content.contentTemplateFile',
          persistent: false,
          setting: true,
          isVisible: true,
          isSearchable: false
        }, {
          propertyIdentifier: '_content.allowPurchaseFlag',
          isVisible: true,
          isSearchable: false
        }, {
          propertyIdentifier: '_content.productListingPageFlag',
          isVisible: true,
          isSearchable: false
        }, {
          propertyIdentifier: '_content.activeFlag',
          isVisible: true,
          isSearchable: false
        }];
        var filterGroupsConfig = [{"filterGroup": [{
            "propertyIdentifier": "_content.parentContent",
            "comparisonOperator": "is",
            "value": 'null'
          }]}];
        var options = {
          currentPage: scope.currentPage,
          pageShow: paginationService.getPageShow(),
          keywords: scope.keywords
        };
        var column = {};
        if (!isSearching || scope.keywords === '') {
          options.filterGroupsConfig = angular.toJson(filterGroupsConfig);
          column = {
            propertyIdentifier: '_content.title',
            isVisible: true,
            ormtype: 'string',
            isSearchable: true
          };
        } else {
          column = {
            propertyIdentifier: '_content.fullTitle',
            isVisible: true,
            persistent: false,
            isSearchable: true
          };
        }
        columnsConfig.unshift(column);
        options.columnsConfig = angular.toJson(columnsConfig);
        var collectionListingPromise = $slatwall.getEntity(scope.entityName, options);
        collectionListingPromise.then(function(value) {
          scope.collection = value;
          scope.collectionConfig = angular.fromJson(scope.collection.collectionConfig);
          scope.collectionConfig.columns = columnsConfig;
          scope.collection.collectionConfig = scope.collectionConfig;
          scope.loadingCollection = false;
        });
      };
      scope.getCollection(false);
      scope.keywords = "";
      scope.loadingCollection = false;
      var searchPromise;
      scope.searchCollection = function() {
        if (searchPromise) {
          $timeout.cancel(searchPromise);
        }
        searchPromise = $timeout(function() {
          $log.debug('search with keywords');
          $log.debug(scope.keywords);
          $('.childNode').remove();
          paginationService.setCurrentPage(1);
          scope.loadingCollection = true;
          scope.getCollection(true);
        }, 500);
      };
    }
  };
}]);

//# sourceMappingURL=../../directives/content/swcontentlist.js.map