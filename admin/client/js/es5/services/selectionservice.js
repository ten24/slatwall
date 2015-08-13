var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
/*services return promises which can be handled uniquely based on success or failure by the controller*/
var slatwalladmin;
(function (slatwalladmin) {
    var SelectionService = (function (_super) {
        __extends(SelectionService, _super);
        function SelectionService() {
            var _this = this;
            this.addSelection = function (selectionid, selection) {
                if (angular.isUndefined(_this._selection[selectionid])) {
                    _this._selection[selectionid] = [];
                }
                _this._selection[selectionid].push(selection);
            };
            this.removeSelection = function (selectionid, selection) {
                if (angular.isUndefined(_this._selection[selectionid])) {
                    _this._selection[selectionid] = [];
                }
                var index = _this._selection[selectionid].indexOf(selection);
                if (index > -1) {
                    _this._selection[selectionid].splice(index, 1);
                }
            };
            this.hasSelection = function (selectionid, selection) {
                if (angular.isUndefined(_this._selection[selectionid])) {
                    return false;
                }
                var index = _this._selection[selectionid].indexOf(selection);
                if (index > -1) {
                    return true;
                }
            };
            this.getSelections = function (selectionid) {
                return _this._selection[selectionid];
            };
            this._selection = {};
        }
        return SelectionService;
    })(slatwalladmin.BaseService);
    slatwalladmin.SelectionService = SelectionService;
    angular.module('slatwalladmin').service('selectionService', SelectionService);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../services/selectionservice.js.map