"use strict";
'use strict';
angular.module('slatwalladmin').directive("sw:sortable", ['expression', 'compiledElement', function(expression, compiledElement) {
  compiledElement.children().attr("sw:sortable-index", "{{$index}}");
  return function(linkElement) {
    var scope = this;
    linkElement.sortable({
      placeholder: "placeholder",
      opacity: 0.8,
      axis: "y",
      update: function(event, ui) {
        var model = scope.$apply(expression);
        var modelLength = model.length;
        var items = [];
        linkElement.children().each(function(index) {
          var item = $(this);
          var oldIndex = parseInt(item.attr("sw:sortable-index"), 10);
          model.push(model[oldIndex]);
          if (item.attr("sw:sortable-index")) {
            items[oldIndex] = item;
            item.detach();
          }
        });
        model.splice(0, modelLength);
        linkElement.append.apply(linkElement, items);
        scope.$digest();
      }
    });
  };
}]);
