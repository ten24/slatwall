/*services return promises which can be handled uniquely based on success or failure by the controller*/
var slatwalladmin;
(function (slatwalladmin) {
    class SelectionService extends slatwalladmin.BaseService {
        constructor() {
            this.addSelection = (selectionid, selection) => {
                if (angular.isUndefined(this._selection[selectionid])) {
                    this._selection[selectionid] = [];
                }
                this._selection[selectionid].push(selection);
            };
            this.removeSelection = (selectionid, selection) => {
                if (angular.isUndefined(this._selection[selectionid])) {
                    this._selection[selectionid] = [];
                }
                var index = this._selection[selectionid].indexOf(selection);
                if (index > -1) {
                    this._selection[selectionid].splice(index, 1);
                }
            };
            this.hasSelection = (selectionid, selection) => {
                if (angular.isUndefined(this._selection[selectionid])) {
                    return false;
                }
                var index = this._selection[selectionid].indexOf(selection);
                if (index > -1) {
                    return true;
                }
            };
            this.getSelections = (selectionid) => {
                return this._selection[selectionid];
            };
            this._selection = {};
        }
    }
    slatwalladmin.SelectionService = SelectionService;
    angular.module('slatwalladmin').service('selectionService', SelectionService);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../services/selectionservice.js.map