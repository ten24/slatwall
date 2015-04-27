"use strict";
'use strict';
angular.module('slatwalladmin').directive('swHref', [function() {
  return {
    restrict: 'A',
    scope: {swHref: "@"},
    link: function(scope, element, attrs) {
      scope.$watch('swHref', function(newValue) {
        if (newValue) {
          var hrefValue = '?ng#!' + newValue;
          element.attr('href', hrefValue);
        }
      });
    }
  };
}]);
