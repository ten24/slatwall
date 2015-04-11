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
      if (!$slatwall.getRBLoaded()) {
        var hasResourceBundleListener = $rootScope.$on('hasResourceBundle', function(event, data) {
          if (angular.isDefined(rbKeyValue) && angular.isString(rbKeyValue)) {
            $log.debug($slatwall.getRBKey(rbKeyValue));
            element.text($slatwall.getRBKey(rbKeyValue));
          }
          hasResourceBundleListener();
        });
      } else {
        if (angular.isDefined(rbKeyValue) && angular.isString(rbKeyValue)) {
          element.text($slatwall.getRBKey(rbKeyValue));
        }
      }
    }
  };
}]);
