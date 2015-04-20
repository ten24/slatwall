"use strict";
'use strict';
angular.module('slatwalladmin').directive('swContentList', ['$log', '$slatwall', 'partialsPath', function($log, $slatwall, partialsPath) {
  return {
    restrict: 'E',
    templateUrl: partialsPath + 'content/contentlist.html',
    link: function(scope, element, attr) {
      $log.debug('slatwallcontentList init');
      scope.getCollection = function() {
        var pageShow = 50;
        if (scope.pageShow !== 'Auto') {
          pageShow = scope.pageShow;
        }
        var columnsConfig = [{
          propertyIdentifier: '_content.contentID',
          isVisible: false,
          isSearchable: false
        }, {
          propertyIdentifier: '_content.title',
          isVisible: true,
          isSearchable: true
        }, {
          propertyIdentifier: '_content.site.siteName',
          isVisible: true,
          isSearchable: true
        }, {
          propertyIdentifier: '_content.contentTemplateFile',
          persistent: false,
          setting: true,
          isVisible: true
        }, {
          propertyIdentifier: '_content.allowPurchaseFlag',
          isVisible: true,
          isSearchable: true
        }, {
          propertyIdentifier: '_content.productListingPageFlag',
          isVisible: true,
          isSearchable: true
        }, {
          propertyIdentifier: '_content.activeFlag',
          isVisible: true,
          isSearchable: true
        }];
        var collectionListingPromise = $slatwall.getEntity(scope.entityName, {
          currentPage: scope.currentPage,
          pageShow: pageShow,
          keywords: scope.keywords,
          columnsConfig: angular.toJson(columnsConfig)
        });
        collectionListingPromise.then(function(value) {
          scope.collection = value;
          scope.collectionConfig = angular.fromJson(scope.collection.collectionConfig);
          scope.collectionConfig.columns = columnsConfig;
          scope.collection.collectionConfig = scope.collectionConfig;
          scope.contents = $slatwall.populateCollection(value.pageRecords, scope.collectionConfig);
        });
      };
      scope.getCollection();
    }
  };
}]);
