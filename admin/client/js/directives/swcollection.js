'use strict';
angular.module('slatwalladmin')
.directive('swCollection', [
	'$http',
	'$compile',
	'$log',
	'collectionPartialsPath',
	'collectionService',
	function(
		$http,
		$compile,
		$log,
		collectionPartialsPath,
		collectionService
	){
		
		return {
			restrict: 'A',
			templateUrl:collectionPartialsPath+"collection.html",
			link: function(scope,$element,$attrs){
				//Defaults Cog to whatever the user passes into the directive
				scope.toggleCogOpen = $attrs.toggleoption;
				scope.toggleCogOpen = false;
			}
		};

	}
]);
	