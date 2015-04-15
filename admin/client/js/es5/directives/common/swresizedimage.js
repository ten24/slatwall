/**
 * Displays an image for an order item.
 * @module slatwalladmin
 * @class swoiimage
 */
"use strict";
angular.module("slatwalladmin").directive("swresizedimage", ["$http", "$log", "$q", "$slatwall", "partialsPath", function ($http, $log, $q, $slatwall, partialsPath) {
	return {
		restrict: "E",
		scope: {
			orderItem: "=" },
		templateUrl: partialsPath + "orderitem-image.html",
		link: function (scope, element, attrs) {
			var profileName = attrs.profilename;
			var skuID = scope.orderItem.data.sku.data.skuID;
			//Get the template.
			//Call slatwallService to get the path from the image.
			$slatwall.getResizedImageByProfileName(profileName, skuID).then(function (response) {
				$log.debug("Get the image");
				$log.debug(response.data.RESIZEDIMAGEPATHS[0]);
				scope.orderItem.imagePath = response.data.RESIZEDIMAGEPATHS[0];
			});

		}
	};
}]);