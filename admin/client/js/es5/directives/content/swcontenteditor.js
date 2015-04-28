"use strict";

angular.module("slatwalladmin").directive("swContentEditor", ["$log", "$location", "$slatwall", "formService", "contentPartialsPath", function ($log, $location, $slatwall, formService, contentPartialsPath) {
	return {
		restrict: "EA",
		scope: {
			content: "="
		},
		templateUrl: contentPartialsPath + "contenteditor.html",
		link: function (scope, element, attrs) {
			scope.editorOptions = CKEDITOR.editorConfig;

			scope.saveContent = function () {
				console.log("save");
				console.log(scope.content.templateHTML);
			};
		}
	};
}]);