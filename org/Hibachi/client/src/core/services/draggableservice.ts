/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class DraggableService{

    //ngInject
    constructor(

    ){

    }

    public isDropAllowed = (event) =>{
        //todo implement

        return true;
    }

    public isMouseInFirstHalf = (event, targetNode, relativeToParent, horizontal) =>{
        var mousePointer = horizontal ? (event.offsetX || event.layerX)
                                      : (event.offsetY || event.layerY);
        var targetSize = horizontal ? targetNode.offsetWidth : targetNode.offsetHeight;
        var targetPosition = horizontal ? targetNode.offsetLeft : targetNode.offsetTop;
        targetPosition = relativeToParent ? targetPosition : 0;

        return mousePointer < targetPosition + targetSize / 2;
    }
}

export{
    DraggableService
};