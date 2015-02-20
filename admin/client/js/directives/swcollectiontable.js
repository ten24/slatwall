'use strict';
angular.module('slatwalladmin')
.directive('swCollectionTable', [
	'$http',
	'$compile',
	'$log',
	'collectionPartialsPath',
	'paginationService',
	function(
		$http,
		$compile,
		$log,
		collectionPartialsPath,
		paginationService
	){
		return {
			restrict: 'E',
			templateUrl:collectionPartialsPath+"collectiontable.html",
			scope:{
				collection:"=",
				collectionConfig:"="
			},
			link: function(scope,$element,$attrs){
				//need to move pagination into table section
				
				
			}
		};
	}
]);
	