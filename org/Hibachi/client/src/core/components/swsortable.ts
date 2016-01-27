/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWSortable{
    public static Factory(){
        var directive = (expression, compiledElement)=> new SWSortable(expression, compiledElement);
        directive.$inject = ['expression', 'compiledElement'];
        return directive;
    }
    constructor(
        expression, compiledElement
    ){
        return function(linkElement){
            var scope = this;             
            
            linkElement.sortable({
                placeholder: "placeholder",
                opacity: 0.8,
                axis: "y",
                update: function(event, ui) {
                    // get model
                    var model = scope.$apply(expression);
                    // remember its length
                    var modelLength = model.length;
                    // rember html nodes
                    var items = [];
    
                    // loop through items in new order
                    linkElement.children().each(function(index) {
                        var item = $(this);
                        
                        // get old item index
                        var oldIndex = parseInt(item.attr("sw:sortable-index"), 10);
                        
                        // add item to the end of model
                        model.push(model[oldIndex]);
    
                        if(item.attr("sw:sortable-index")) {
                            // items in original order to restore dom
                            items[oldIndex] = item;
                            // and remove item from dom
                            item.detach();
                        }
                    });
                    
                    model.splice(0, modelLength);
    
                    // restore original dom order, so angular does not get confused
                    linkElement.append.apply(linkElement,items);
    
                    // notify angular of the change
                    scope.$digest();
                }
            });
        };
    }
}
export{
    SWSortable
}