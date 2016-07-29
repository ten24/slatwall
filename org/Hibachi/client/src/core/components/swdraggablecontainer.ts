/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWDraggableContainerController{
    
    public draggable:boolean; 

    //@ngInject
    constructor(public draggableService){
        if(angular.isUndefined(this.draggable)){
            this.draggable = false; 
        }
    }

}

class SWDraggableContainer implements ng.IDirective{
    public restrict:string = 'EA';
    public scope={};
    public bindToController={
        draggable:"=?",
        draggableRecords:"=?"
    };

    public static Factory(){
        var directive:ng.IDirectiveFactory=(
            corePartialsPath,
            utilityService,
            draggableService,
			hibachiPathBuilder
        ) => new SWDraggableContainer(
            corePartialsPath,
            utilityService,
            draggableService,
			hibachiPathBuilder
        );
        directive.$inject = [
            'corePartialsPath',
            'utilityService',
            'draggableService',
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
        public draggableService,
		public hibachiPathBuilder
     ){
    }

    public link:ng.IDirectiveLinkFn = (scope:any, element:any, attrs:any) =>{
        
        angular.element(element).attr("draggable", "true");

        var placeholderElement = angular.element("<tr class='s-placeholder'><td></td><td></td><td></td><td></td><td></td></tr>");//temporarirly hardcoding tds so it will show up
        
        var id = angular.element(element).attr("id");
        if (!id) {
            id = this.utilityService.createID(32);  
        } 

        var listNode = element[0];
        var placeholderNode = placeholderElement[0]; 
        placeholderElement.remove();

        element.on('drop', (e)=>{
            e = e.originalEvent || e;
            if(!this.draggableService.isDropAllowed(e)) return true; 

            e.preventDefault();

            var data = e.dataTransfer.getData("Text") || e.dataTransfer.getData("text/plain");
            var record = JSON.parse(data);
        
            // Invoke the callback, which can transform the transferredObject and even abort the drop.
            var index =  Array.prototype.indexOf.call(listNode.children, placeholderNode);

            scope.swDraggableContainer.draggableRecords.splice(index, 0, record);

            placeholderElement.remove();

            return false;
        });

        element.on('dragover', (e)=>{
            e = e.originalEvent || e;
            e.stopPropagation(); 
            if(placeholderNode.parentNode != listNode) {
                console.log("appending placeholder");
                element.append(placeholderElement);
            }

            if(e.target !== listNode) {
                var listItemNode = e.target;
                while (listItemNode.parentNode !== listNode && listItemNode.parentNode) {
                    listItemNode = listItemNode.parentNode;
                }

                if (listItemNode.parentNode === listNode && listItemNode !== placeholderNode) {
                    if (this.draggableService.isMouseInFirstHalf(e, listItemNode)) {
                        listNode.insertBefore(placeholderNode, listItemNode);
                    } else {
                        listNode.insertBefore(placeholderNode, listItemNode.nextSibling);
                    }
                }
            }

            return false; 
        }); 

        
 
    }   
}
export{
    SWDraggableContainer
}

