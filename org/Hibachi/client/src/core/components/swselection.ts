/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWSelection{
    public static Factory(){
        var directive = (
            $log,
            selectionService,
            observerService,
            corePartialsPath,
            pathBuilderConfig
        )=>new SWSelection(
            $log,
            selectionService,
            observerService,
            corePartialsPath,
            pathBuilderConfig
        );
        directive.$inject = [
            '$log',
            'selectionService',
            'observerService',
            'corePartialsPath',
            'pathBuilderConfig'
        ];
        return directive;
    }
    constructor(
        $log,
        selectionService,
        observerService,
        corePartialsPath,
        pathBuilderConfig
    ){
        return {
			restrict: 'E',
			templateUrl:pathBuilderConfig.buildPartialsPath(corePartialsPath)+"selection.html",
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
}
export{
    SWSelection
}