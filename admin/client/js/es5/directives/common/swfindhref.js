"use strict";
angular.module("slatwalladmin").directive("swFindHref", ["$location", "$log", function ($location, $log) {
	return {
		restrict: "A",
		link: function (scope, element, attrs) {
			var url = $location.path();
			var splitUrl = url.split("/");
			var id = splitUrl[splitUrl.length - 1];
			$log.debug("My id is: " + id);
			var originalHref = attrs.href;
			$log.debug(originalHref);
			attrs.href = originalHref.concat(id);
			$log.debug(attrs.href);
		}
	};
}]);