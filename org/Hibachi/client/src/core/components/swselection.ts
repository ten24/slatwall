/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWSelection{
    public static Factory(){
        var directive = (
            $log,
            selectionService,
            observerService,
            corePartialsPath,
            hibachiPathBuilder
        )=>new SWSelection(
            $log,
            selectionService,
            observerService,
            corePartialsPath,
            hibachiPathBuilder
        );
        directive.$inject = [
            '$log',
            'selectionService',
            'observerService',
            'corePartialsPath',
            'hibachiPathBuilder'
        ];
        return directive;
    }
    constructor(
        $log,
        selectionService,
        observerService,
        corePartialsPath,
        hibachiPathBuilder
    ){
        return {
			restrict: 'E',
			templateUrl:hibachiPathBuilder.buildPartialsPath(corePartialsPath)+"selection.html",
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
                    console.log('selected!');
                    console.log(toggleValue);
                    console.log(selectionid);
                    console.log(selection);
                    if(scope.isRadio){
                        selectionService.radioSelection(selectionid,selection);
                    }else{
                        if(toggleValue){
                            selectionService.addSelection(selectionid,selection);
                        }else{
                            selectionService.removeSelection(selectionid,selection);
                        }
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