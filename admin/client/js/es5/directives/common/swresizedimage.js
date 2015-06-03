"use strict";
'use strict';
angular.module('slatwalladmin').directive('swresizedimage', ["$http", "$log", "$q", "$slatwall", "partialsPath", function($http, $log, $q, $slatwall, partialsPath) {
  return {
    restrict: 'E',
    scope: {orderItem: "="},
    templateUrl: partialsPath + "orderitem-image.html",
    link: function(scope, element, attrs) {
      var profileName = attrs.profilename;
      var skuID = scope.orderItem.data.sku.data.skuID;
      $slatwall.getResizedImageByProfileName(profileName, skuID).then(function(response) {
        $log.debug('Get the image');
        $log.debug(response.data.RESIZEDIMAGEPATHS[0]);
        scope.orderItem.imagePath = response.data.RESIZEDIMAGEPATHS[0];
      });
    }
  };
}]);

//# sourceMappingURL=../../directives/common/swresizedimage.js.map