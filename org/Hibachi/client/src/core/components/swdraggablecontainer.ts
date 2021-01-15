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
    public _timeoutPromise;
    public restrict:string = 'EA';
    public scope={};
    public bindToController={
        draggable:"=?",
        draggableRecords:"=?",
        dropEventName:"@?",
        listingId:"@?"
    };

    public static Factory(){
        var directive:ng.IDirectiveFactory=(
            $timeout,
            corePartialsPath,
            utilityService,
            listingService,
            observerService,
            draggableService,
			hibachiPathBuilder
        ) => new SWDraggableContainer(
            $timeout,
            corePartialsPath,
            utilityService,
            listingService,
            observerService,
            draggableService,
			hibachiPathBuilder
        );
        directive.$inject = [
            '$timeout',
            'corePartialsPath',
            'utilityService',
            'listingService',
            'observerService',
            'draggableService',
			'hibachiPathBuilder'
        ];
        return directive;
    }

    public controller=SWDraggableContainerController;
    public controllerAs="swDraggableContainer";
    //@ngInject
    constructor(
        public $timeout,
        public corePartialsPath,
        public utilityService,
        public listingService,
        public observerService,
        public draggableService,
		public hibachiPathBuilder
     ){
    }

    public link:ng.IDirectiveLinkFn = (scope:any, element:any, attrs:any) =>{
        scope.$watch('swDraggableContainer.draggable',(newValue,oldValue)=>{

            angular.element(element).attr("draggable", newValue);

            var placeholderElement = angular.element("<tr class='s-placeholder'><td>placeholder</td><td>placeholder</td><td>placeholder</td><td>placeholder</td><td>placeholder</td><td></td></tr>");//temporarirly hardcoding tds so it will show up

            var id = angular.element(element).attr("id");
            if (!id) {
                id = this.utilityService.createID(32);
            }

            var listNode = element[0];
            var placeholderNode = placeholderElement[0];
            placeholderElement.remove();
            if(newValue){
                element.on('drop', (e)=>{
                    e = e.originalEvent || e;
                    e.preventDefault();

                    if(!this.draggableService.isDropAllowed(e)) return true;

                    var record = e.dataTransfer.getData("application/json") || e.dataTransfer.getData("text/plain");
                    var parsedRecord = JSON.parse(record);

                    var index =  Array.prototype.indexOf.call(listNode.children, placeholderNode);
                    if(index < parsedRecord.draggableStartKey){
                        parsedRecord.draggableStartKey++;
                    }

                    this.$timeout(
                        ()=>{
                            scope.swDraggableContainer.draggableRecords.splice(index, 0, parsedRecord);
                            scope.swDraggableContainer.draggableRecords.splice(parsedRecord.draggableStartKey, 1);
                        }, 0
                    );

                    if (angular.isDefined(scope.swDraggableContainer.listingId)){
                        this.listingService.notifyListingPageRecordsUpdate(scope.swDraggableContainer.listingId);
                    } else if (angular.isDefined(scope.swDraggableContainer.dropEventName)){
                        this.observerService.notify(scope.swDraggableContainer.dropEventName);
                    }

                    placeholderElement.remove();
                    e.stopPropagation();
                    return false;
                });

                element.on('dragenter', (e)=>{
                    e = e.originalEvent || e;
                    if (!this.draggableService.isDropAllowed(e)) return true;
                    e.preventDefault();
                });

                element.on('dragleave', (e)=>{
                    e = e.originalEvent || e;

                    if (e.pageX != 0 || e.pageY != 0) {
                        return false;
                    }

                    return false;
                });

                element.on('dragover', (e)=>{
                    e = e.originalEvent || e;
                    e.stopPropagation();

                    if(placeholderNode.parentNode != listNode) {
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

                    element.addClass("s-dragged-over");
                    return false;
                });
            }
        });
    }
}
export{
    SWDraggableContainer
}

