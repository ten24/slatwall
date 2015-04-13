"use strict";
angular.module("slatwalladmin").directive("sw:sortable", ["expression", "compiledElement", function (expression, compiledElement) {
    // add my:sortable-index to children so we know the index in the model
    compiledElement.children().attr("sw:sortable-index", "{{$index}}");

    return function (linkElement) {
        var scope = this;

        linkElement.sortable({
            placeholder: "placeholder",
            opacity: 0.8,
            axis: "y",
            update: function (event, ui) {
                // get model
                var model = scope.$apply(expression);
                // remember its length
                var modelLength = model.length;
                // rember html nodes
                var items = [];

                // loop through items in new order
                linkElement.children().each(function (index) {
                    var item = $(this);

                    // get old item index
                    var oldIndex = parseInt(item.attr("sw:sortable-index"), 10);

                    // add item to the end of model
                    model.push(model[oldIndex]);

                    if (item.attr("sw:sortable-index")) {
                        // items in original order to restore dom
                        items[oldIndex] = item;
                        // and remove item from dom
                        item.detach();
                    }
                });

                model.splice(0, modelLength);

                // restore original dom order, so angular does not get confused
                linkElement.append.apply(linkElement, items);

                // notify angular of the change
                scope.$digest();
            }
        });
    };

}]);