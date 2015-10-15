var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
/*services return promises which can be handled uniquely based on success or failure by the controller*/
var slatwalladmin;
(function (slatwalladmin) {
    var SelectionService = (function (_super) {
        __extends(SelectionService, _super);
        function SelectionService() {
            var _this = this;
            _super.call(this);
            this._selection = {};
            this.radioSelection = function (selectionid, selection) {
                _this._selection[selectionid] = [];
                _this._selection[selectionid].push(selection);
            };
            this.addSelection = function (selectionid, selection) {
                if (angular.isUndefined(_this._selection[selectionid])) {
                    _this._selection[selectionid] = [];
                }
                _this._selection[selectionid].push(selection);
            };
            this.setSelection = function (seleciontid, selections) {
                _this._selection[selectionid] = selections;
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
        }
        return SelectionService;
    })(slatwalladmin.BaseService);
    slatwalladmin.SelectionService = SelectionService;
    angular.module('slatwalladmin').service('selectionService', SelectionService);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=selectionservice.js.map
