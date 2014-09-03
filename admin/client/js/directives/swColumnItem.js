'use strict';
angular.module('slatwalladmin')
.directive('swColumnItem', 
['$http',
'$compile',
'$templateCache',
'collectionService',
'partialsPath',
'$log',
function($http,
$compile,
$templateCache,
collectionService,
partialsPath,
$log){
	return {
		restrict: 'A',
		require:"^swDisplayOptions",
		//transclude:true,
		scope:{
			column:"=",
			columnIndex:"=",
			saveCollection:"&"
		},
		templateUrl:partialsPath+"columnItem.html",
		link: function(scope, element,attrs,displayOptionsController){
			$log.debug('displayOptionsController');
			$log.debug(displayOptionsController);
			
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
			
			scope.removeColumn = function(columnIndex){
				$log.debug('remove column');
				$log.debug(columnIndex);
				displayOptionsController.removeColumn(columnIndex);
				scope.saveCollection();
			};
			
		}
	};
}]);
	
