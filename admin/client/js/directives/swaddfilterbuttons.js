'use strict';
angular.module('slatwalladmin')
.directive('swAddFilterButtons', [
	'$http',
	'$compile',
	'$templateCache',
	'collectionService',
	'collectionPartialsPath',
	function(
		$http,
		$compile,
		$templateCache,
		collectionService,
		collectionPartialsPath
	){
		return {
			require:'^swFilterGroups',
			restrict: 'A',
			templateUrl:collectionPartialsPath+"addfilterbuttons.html",
			scope:{
				itemInUse:"="
			},
			link: function(scope, element,attrs,filterGroupsController){
				scope.filterGroupItem = filterGroupsController.getFilterGroupItem();
				
				scope.addFilterItem = function(){
					console.log(filterGroupsController.getFilterGroupItem());
					collectionService.newFilterItem(filterGroupsController.getFilterGroupItem(),filterGroupsController.setItemInUse);
					console.log(filterGroupsController.getFilterGroupItem());
				};
				
				scope.addFilterGroupItem = function(){
					collectionService.newFilterItem(filterGroupsController.getFilterGroupItem(),filterGroupsController.setItemInUse,true);
				};
			}
		};
	}
]);
	
