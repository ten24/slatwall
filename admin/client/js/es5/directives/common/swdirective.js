"use strict";
'use strict';
angular.module('slatwalladmin').directive('swDirective', ['$compile', function($compile) {
  return {
    restrict: 'A',
    replace: true,
    scope: {
      variables: "=",
      directive: "="
    },
    link: function(scope, element, attrs) {
      var template = '<span ' + scope.directive + ' ';
      if (angular.isDefined(scope.variables)) {
        angular.forEach(scope.variables, function(value, key) {
          template += ' ' + key + '=' + value + ' ';
        });
      }
      template += +'>';
      template += '</span>';
      element.html('').append($compile(template)(scope));
    }
  };
}]);

//# sourceMappingURL=../../directives/common/swdirective.js.map