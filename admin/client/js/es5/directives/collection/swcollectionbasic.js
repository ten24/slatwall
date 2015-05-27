"use strict";
angular.module('slatwalladmin').directive('swCollectionBasic', ['$log', '$location', '$slatwall', 'formService', 'collectionPartialsPath', function($log, $location, $slatwall, formService, collectionPartialsPath) {
  return {
    restrict: 'E',
    scope: {collection: "="},
    templateUrl: collectionPartialsPath + "collectionbasic.html",
    link: function(scope, element, attrs) {
      $log.debug(scope.collection);
      scope.openTab = true;
    }
  };
}]);

//# sourceMappingURL=../../directives/collection/swcollectionbasic.js.map