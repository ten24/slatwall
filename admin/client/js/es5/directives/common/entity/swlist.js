"use strict";
'use strict';
angular.module('slatwalladmin').directive('swList', ['$log', '$slatwall', 'partialsPath', function($log, $slatwall, partialsPath) {
  return {
    restrict: 'E',
    templateUrl: partialsPath + 'entity/list.html',
    link: function(scope, element, attr) {
      $log.debug('slatwallList init');
      scope.getCollection = function() {
        var pageShow = 50;
        if (scope.pageShow !== 'Auto') {
          pageShow = scope.pageShow;
        }
        var collectionListingPromise = $slatwall.getEntity(scope.entityName, {
          currentPage: scope.currentPage,
          pageShow: pageShow,
          keywords: scope.keywords
        });
        collectionListingPromise.then(function(value) {
          scope.collection = value;
          scope.collectionConfig = angular.fromJson(scope.collection.collectionConfig);
        });
      };
      scope.getCollection();
    }
  };
}]);

//# sourceMappingURL=../../../directives/common/entity/swlist.js.map