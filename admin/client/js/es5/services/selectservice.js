"use strict";
'use strict';
angular.module('slatwalladmin').factory('selectService', [function() {
  var _selection = {};
  var selectService = {addSelection: function(selectionid, selection) {
      if (angular.isUndefined(_selection[selectionid])) {
        _selection[selectionid] = [];
      }
      _selection[selectionid].push(selection);
    }};
  return selectService;
}]);

//# sourceMappingURL=../services/selectservice.js.map