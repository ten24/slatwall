/*services return promises which can be handled uniquely based on success or failure by the controller*/
'use strict';
angular.module('slatwalladmin').factory('selectionService', [
    function () {
        //declare public and private variables
        //selections have a unique identifier for the instance they are related to 
        var _selection = {};
        //declare service we are returning
        var selectService = {
            addSelection: function (selectionid, selection) {
                if (angular.isUndefined(_selection[selectionid])) {
                    _selection[selectionid] = [];
                }
                _selection[selectionid].push(selection);
            },
            removeSelection: function (selectionid, selection) {
                if (angular.isUndefined(_selection[selectionid])) {
                    _selection[selectionid] = [];
                }
                var index = _selection[selectionid].indexOf(selection);
                if (index > -1) {
                    _selection[selectionid].splice(index, 1);
                }
            },
            hasSelection: function (selectionid, selection) {
                if (angular.isUndefined(_selection[selectionid])) {
                    return false;
                }
                var index = _selection[selectionid].indexOf(selection);
                if (index > -1) {
                    return true;
                }
            },
            getSelections: function (selectionid) {
                return _selection[selectionid];
            }
        };
        return selectService;
    }
]);

//# sourceMappingURL=../services/selectionservice.js.map