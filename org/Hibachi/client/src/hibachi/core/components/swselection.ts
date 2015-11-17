'use strict';
angular.module('slatwalladmin')
.directive('swSelection', [
	'$log',
    'selectionService',
    'observerService',
    'partialsPath', 
	function(
		$log,
        selectionService,
        observerService,
        partialsPath
	){
		return {
			restrict: 'E',
			templateUrl:partialsPath+"selection.html",
            scope:{
                selection:"=",
                selectionid:"@",
                id:"=",
                isRadio:"=",
                name:"@",
                disabled:"="
            },
			link: function(scope,$element,$attrs){
                if(!scope.name){
                    scope.name = 'selection';    
                }
                if(selectionService.hasSelection(scope.selectionid,scope.selection)){
                    scope.toggleValue = true;    
                }
                
				scope.toggleSelection = function(toggleValue,selectionid,selection){
                    if(scope.isRadio){
                        selectionService.radioSelection(selectionid,selection);
                        return;
                    }
                    if(toggleValue){
                        selectionService.addSelection(selectionid,selection);
                    }else{
                        selectionService.removeSelection(selectionid,selection);
                    }
                    observerService.notify('swSelectionToggleSelection',{selectionid,selection});
                }
			}
		};
	}
]);
	