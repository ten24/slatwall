'use strict';
angular.module('slatwalladmin')
.directive('swAddFilterButtons', 
['$http',
'$compile',
'$templateCache',
'collectionService',
'partialsPath',

function($http,
$compile,
$templateCache,
collectionService,
partialsPath){
	return {
		require:'^swFilterGroups',
		restrict: 'A',
		templateUrl:partialsPath+"addfilterbuttons.html",
		scope:{
			itemInUse:"="
		},
		link: function(scope, element,attrs,filterGroupsController){
			scope.filterGroupItem = filterGroupsController.getFilterGroupItem();
			
			scope.addFilterItem = function(){
				collectionService.newFilterItem(filterGroupsController.getFilterGroupItem(),filterGroupsController.setItemInUse);
			};
			
			scope.addFilterGroupItem = function(){
				collectionService.newFilterItem(filterGroupsController.getFilterGroupItem(),filterGroupsController.setItemInUse,true);
				//collectionService.newFilterGroupItem(filterGroupsController.getFilterGroupItem(),filterGroupsController.setItemInUse);
			};
		}
	};
}]);
	
