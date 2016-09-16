/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class DraggableService{
    
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
        console.log("isMouseInFirstHalf", mousePointer < targetPosition + targetSize / 2);
        return mousePointer < targetPosition + targetSize / 2;
    }
}

export{
    DraggableService
};