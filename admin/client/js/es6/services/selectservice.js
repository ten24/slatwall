/*services return promises which can be handled uniquely based on success or failure by the controller*/
'use strict';
angular.module('slatwalladmin').factory('selectService', [
    function () {
        //declare public and private variables
        //selections have a unique identifier for the instance they are related to 
        //_selection{"selectionid":[{"entityID":entityid}]}
        var _selection = {};
        //declare service we are returning
        var selectService = {
            addSelection: function (selectionid, selection) {
                if (angular.isUndefined(_selection[selectionid])) {
                    _selection[selectionid] = [];
                }
                _selection[selectionid].push(selection);
            },
        };
        return selectService;
    }
]);

//# sourceMappingURL=../services/selectservice.js.map