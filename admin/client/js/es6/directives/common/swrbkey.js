"use strict";
'use strict';
angular.module('slatwalladmin').directive('swRbkey', ['$slatwall', '$rootScope', '$log', function($slatwall, $rootScope, $log) {
  return {
    restrict: 'A',
    scope: {swRbkey: "="},
    link: function(scope, element, attrs) {
      var rbKeyValue = scope.swRbkey;
      $log.debug('running rbkey');
      $log.debug(rbKeyValue);
      $rootScope.$on('hasResourceBundle', function(event, data) {
        element.text($slatwall.getRBKey(rbKeyValue));
      });
    }
  };
}]);
