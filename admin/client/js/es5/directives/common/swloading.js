"use strict";
'use strict';
angular.module('slatwalladmin').directive('swLoading', ['$log', 'partialsPath', function($log, partialsPath) {
  return {
    restrict: 'A',
    transclude: true,
    templateUrl: partialsPath + 'loading.html',
    scope: {swLoading: '='},
    link: function(scope, attrs, element) {}
  };
}]);

//# sourceMappingURL=../../directives/common/swloading.js.map