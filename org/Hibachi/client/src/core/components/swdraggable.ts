/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWDraggableController{
    
    //@ngInject
    constructor(){

    }

}

class SWDraggable implements ng.IDirective{
    public restrict:string = 'EA';
    public scope={};
    public bindToController={

    };

    public static Factory(){
        var directive:ng.IDirectiveFactory=(
            corePartialsPath,
            utilityService,
            expandableService,
			hibachiPathBuilder
        ) => new SWDraggable(
            corePartialsPath,
            utilityService,
            expandableService,
			hibachiPathBuilder
        );
        directive.$inject = [
            'corePartialsPath',
            'utilityService',
            'expandableService',
			'hibachiPathBuilder'
        ];
        return directive;
    }

    public controller=SWDraggableController;
    public controllerAs="swExpandableRecord";
    //@ngInject
    constructor(
        public corePartialsPath,
        public utilityService,
        public expandableService,
		public hibachiPathBuilder
     ){
    }

    public link:ng.IDirectiveLinkFn = (scope:any, element:any, attrs:any) =>{
        angular.element(element).attr("draggable", "true");
        console.log("draggable link");
        var id = angular.element(element).attr("id");
        if (!id) {
            id = this.utilityService.createID(32);  
        } 
        element.bind("dragstart", function(e) {

        });
        element.bind("dragend", function(e) {

        });
    }
}
export{
    SWDraggable
}

