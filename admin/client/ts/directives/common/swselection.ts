'use strict';
angular.module('slatwalladmin')
.directive('swSelection', [
	'$log',
    'selectionService',
    'partialsPath',
	function(
		$log,
        selectionService,
        partialsPath
	){
		return {
			restrict: 'E',
			templateUrl:partialsPath+"selection.html",
            scope:{
                selection:"=",
                selectionid:"@",
                id:"="  
            },
			link: function(scope,$element,$attrs){
                
                if(selectionService.hasSelection(scope.selectionid,scope.selection)){
                    scope.toggleValue = true;    
                }
                
				scope.toggleSelection = function(toggleValue,selectionid,selection){
                    if(toggleValue){
                        selectionService.addSelection(selectionid,selection);
                    }else{
                        selectionService.removeSelection(selectionid,selection);
                    }
                }
			}
		};
	}
]);
	