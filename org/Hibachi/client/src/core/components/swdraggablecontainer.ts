/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWDraggableContainerController{
    
    public draggable:boolean; 

    //@ngInject
    constructor(){
        if(angular.isUndefined(this.draggable)){
            this.draggable = false; 
        }
    }

}

class SWDraggableContainer implements ng.IDirective{
    public restrict:string = 'EA';
    public scope={};
    public bindToController={
        draggable:"=?"
    };

    public static Factory(){
        var directive:ng.IDirectiveFactory=(
            corePartialsPath,
            utilityService,
            expandableService,
			hibachiPathBuilder
        ) => new SWDraggableContainer(
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

    public controller=SWDraggableContainerController;
    public controllerAs="swDraggableContainer";
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
 
    }
}
export{
    SWDraggableContainer
}

