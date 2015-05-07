"use strict";
'use strict';
angular.module('slatwalladmin').directive('sworderitemrow', [function() {
  var getRow = function(orderItem) {
    var row = "<td>TEST ROW</td>";
    return row;
  };
  return {
    restrict: 'A',
    transclude: false,
    scope: {
      orderItem: "=",
      orderId: "@"
    },
    replace: true,
    link: function(scope, element, attrs) {
      element.html(getRow(scope.orderItem));
    }
  };
  var merchTemplate = "<td>Merch</td>";
  var eventTemplate = "<td>Event</td>";
}]);

//# sourceMappingURL=../../directives/orderitem/sworderitemrow.js.map