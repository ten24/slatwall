"use strict";

angular.module("slatwalladmin").directive("swExportAction", ["$log", "partialsPath", function ($log, partialsPath) {
	return {
		restrict: "A",
		templateUrl: partialsPath + "exportaction.html",
		scope: {},
		link: function (scope, element, attrs) {}
	};
}]);