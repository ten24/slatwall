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
                scope.test = {};

                if(selectionService.isAllSelected(scope.selectionid)){
                    scope.test.toggleValue = true;
                }else{
                    scope.test.toggleValue = selectionService.hasSelection(scope.selectionid,scope.selection);
                }


                scope.updateSelectValue = function(res){
                    if(res.action == 'clear'){
                        scope.test.toggleValue = false;
                    }else if(res.action == 'selectAll'){
                        scope.test.toggleValue = true;
                    }else if(res.selection== scope.selection){
                        scope.test.toggleValue = (res.action == 'check');
                    }

                };

                //attach observer so we know when a selection occurs
                observerService.attach(scope.updateSelectValue,'swSelectionToggleSelection');
                
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
                }
			}
		};
    }
}
export{
    SWSelection
}