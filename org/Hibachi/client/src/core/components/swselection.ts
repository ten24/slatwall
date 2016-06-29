/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWSelectionController{
    private isRadio;
    private name;
    private selectionid;
    private toggleValue;
    private selection;
    //@ngInject
    constructor(
        public selectionService,
        public observerService
    ){
        if(angular.isUndefined(this.name)){
            this.name = 'selection';
        }

        if(selectionService.isAllSelected(this.selectionid)){
            this.toggleValue = !selectionService.hasSelection(this.selectionid,this.selection);
        }else{
            this.toggleValue = selectionService.hasSelection(this.selectionid,this.selection);
        }

        //attach observer so we know when a selection occurs
        observerService.attach(this.updateSelectValue,'swSelectionToggleSelection');
    }

    private updateSelectValue = (res)=>{
        if(res.action == 'clear'){
            this.toggleValue = false;
        }else if(res.action == 'selectAll'){
            this.toggleValue = true;
        }else if(res.selection== this.selection){
            this.toggleValue = (res.action == 'check');
        }
    };
    private toggleSelection = (toggleValue,selectionid,selection)=>{
        if(this.isRadio){
            this.selectionService.radioSelection(selectionid,selection);
            this.toggleValue = toggleValue;
        }else{
            if(toggleValue){
                this.selectionService.addSelection(selectionid,selection);
            }else{
                this.selectionService.removeSelection(selectionid,selection);
            }
        }
    }
}

class SWSelection  implements ng.IDirective{

    public static $inject = ['corePartialsPath', 'hibachiPathBuilder'];
    public templateUrl;
    public restrict = 'E';
    public scope = {};

    public bindToController =  {
        selection:"=",
        selectionid:"@",
        id:"=",
        isRadio:"=",
        name:"@",
        disabled:"="
    };
    public controller = SWSelectionController;
    public controllerAs = 'swSelection';

    constructor(
        public collectionPartialsPath,
        public hibachiPathBuilder
    ){
        this.templateUrl = this.hibachiPathBuilder.buildPartialsPath(this.collectionPartialsPath) + "selection.html";
    }

    public static Factory(){
        var directive = (
            corePartialsPath,
            hibachiPathBuilder
        )=> new SWSelection(
            corePartialsPath,
            hibachiPathBuilder
        );
        directive.$inject = [ 'corePartialsPath', 'hibachiPathBuilder'];
        return directive;
    }
}
export{
    SWSelection
}