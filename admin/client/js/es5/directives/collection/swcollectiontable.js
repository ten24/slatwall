"use strict";
'use strict';
angular.module('slatwalladmin').directive('swCollectionTable', ['$http', '$compile', '$log', 'collectionPartialsPath', 'paginationService', function($http, $compile, $log, collectionPartialsPath, paginationService) {
  return {
    restrict: 'E',
    templateUrl: collectionPartialsPath + "collectiontable.html",
    scope: {
      collection: "=",
      collectionConfig: "="
    },
    link: function(scope, element, attrs) {
      var _collectionObject = scope.collection.collectionObject.charAt(0).toLowerCase() + scope.collection.collectionObject.slice(1);
      var _recordKeyForObjectID = _collectionObject + 'ID';
      scope.$watch('collection.pageRecords', function() {
        for (var record in scope.collection.pageRecords) {
          var _detailLink = void 0;
          var _editLink = void 0;
          var _pageRecord = scope.collection.pageRecords[record];
          var _objectID = _pageRecord[_recordKeyForObjectID];
          if (_objectID && _collectionObject !== 'country') {
            _detailLink = "?slatAction=entity.detail" + _collectionObject + "&" + _collectionObject + "ID=" + _objectID;
            _editLink = "?slatAction=entity.edit" + _collectionObject + "&" + _collectionObject + "ID=" + _objectID;
          } else if (_collectionObject === 'country') {
            _detailLink = "?slatAction=entity.detail" + _collectionObject + "&countryCode=" + _pageRecord["countryCode"];
            _detailLink = "?slatAction=entity.edit" + _collectionObject + "&countryCode=" + _pageRecord["countryCode"];
          }
          _pageRecord["detailLink"] = _detailLink;
          _pageRecord["editLink"] = _editLink;
        }
      });
      angular.forEach(scope.collectionConfig.columns, function(column) {
        $log.debug("Config Key : " + column);
        column.key = column.propertyIdentifier.replace(/\./g, '_').replace(scope.collectionConfig.baseEntityAlias + '_', '');
      });
    }
  };
}]);

//# sourceMappingURL=../../directives/collection/swcollectiontable.js.map