'use strict';
angular.module('slatwalladmin')
.directive('swColumnItem', 
['$http',
'$compile',
'$templateCache',
'$log',
'collectionService',
'collectionPartialsPath',
function($http,
$compile,
$templateCache,
$log,
collectionService,
collectionPartialsPath){
	return {
		restrict: 'A',
		require:"^swDisplayOptions",
		scope:{
			column:"=",
			columnIndex:"=",
			saveCollection:"&",
			propertiesList:"="
		},
		templateUrl:collectionPartialsPath+"columnitem.html",
		link: function(scope, element,attrs,displayOptionsController){
			$log.debug('displayOptionsController');
			if(angular.isUndefined(scope.column.sorting)){
				scope.column.sorting = {
						active:true,
						sortOrder:'asc'
				};
			}
			
			scope.toggleVisible = function(column){
				$log.debug('toggle visible');
				if(angular.isUndefined(column.isVisible)){
					column.isVisible = false;
				}
				column.isVisible = !column.isVisible;
				scope.saveCollection();
			};
			
			scope.toggleSearchable = function(column){
				$log.debug('toggle searchable');
				if(angular.isUndefined(column.isSearchable)){
					column.isSearchable = false;
				}
				column.isSearchable = !column.isSearchable;
				scope.saveCollection();
			};
			
			scope.toggleExportable = function(column){
				$log.debug('toggle exporable');
				if(angular.isUndefined(column.isExportable)){
					column.isExportable = false;
				}
				column.isExportable = !column.isExportable;
				scope.saveCollection();
			};
			
			scope.toggleSortable = function(column){
				$log.debug('toggle sortable');
				/*if(angular.isUndefined(column.sorting)){
					column.sorting = {
							active:true,
							sortOrder:'asc'
					};
				}
				
				if(column.sorting.active === true){
					if(column.sorting.sortOrder === 'asc'){
						column.sorting.sortOrder = 'desc';
					}else{
						column.sorting.active = false;
					}
				}else{
					column.sorting.active = true;
					column.sorting.sortOrder = 'asc';
				}
				scope.saveCollection();*/
			};
			
			scope.removeColumn = function(columnIndex){
				$log.debug('remove column');
				$log.debug(columnIndex);
				displayOptionsController.removeColumn(columnIndex);
				scope.saveCollection();
			};
			
		}
	};
}]);
	
