"use strict";
angular.module("slatwalladmin").directive("swCriteria", ["$log", "$slatwall", "$filter", "collectionPartialsPath", "collectionService", "metadataService", function ($log, $slatwall, $filter, collectionPartialsPath, collectionService, metadataService) {


	return {
		restrict: "E",
		scope: {
			filterItem: "=",
			selectedFilterProperty: "=",
			filterPropertiesList: "=",
			selectedFilterPropertyChanged: "&"
		},
		templateUrl: collectionPartialsPath + "criteria.html",
		link: function (scope, element, attrs) {}
	};
}]);