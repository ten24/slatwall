/// <reference path='../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../client/typings/tsd.d.ts' />
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var slatwalladmin;
(function (slatwalladmin) {
    var DialogService = (function (_super) {
        __extends(DialogService, _super);
        function DialogService(partialsPath) {
            var _this = this;
            _super.call(this);
            this.partialsPath = partialsPath;
            this.get = function () {
                return _this._pageDialogs || [];
            };
            this.addPageDialog = function (name, params) {
                var newDialog = {
                    'path': _this.partialsPath + name + '.html',
                    'params': params
                };
                _this._pageDialogs.push(newDialog);
            };
            this.removePageDialog = function (index) {
                _this._pageDialogs.splice(index, 1);
            };
            this.getPageDialogs = function () {
                return _this._pageDialogs;
            };
            this.getCurrentDialog = function () {
                return _this._pageDialogs[_this._pageDialogs.length - 1];
            };
            this._pageDialogs = [];
        }
        DialogService.$inject = [
            'partialsPath'
        ];
        return DialogService;
    })(slatwalladmin.BaseService);
    slatwalladmin.DialogService = DialogService;
    angular.module('slatwalladmin').service('dialogService', DialogService);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../services/dialogservice.js.map