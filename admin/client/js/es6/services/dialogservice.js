/// <reference path='../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    class DialogService extends slatwalladmin.BaseService {
        constructor(partialsPath) {
            super();
            this.partialsPath = partialsPath;
            this.get = () => {
                return this._pageDialogs || [];
            };
            this.addPageDialog = (name, params) => {
                var newDialog = {
                    'path': this.partialsPath + name + '.html',
                    'params': params
                };
                this._pageDialogs.push(newDialog);
            };
            this.removePageDialog = (index) => {
                this._pageDialogs.splice(index, 1);
            };
            this.getPageDialogs = () => {
                return this._pageDialogs;
            };
            this.getCurrentDialog = () => {
                return this._pageDialogs[this._pageDialogs.length - 1];
            };
            this._pageDialogs = [];
        }
    }
    DialogService.$inject = [
        'partialsPath'
    ];
    slatwalladmin.DialogService = DialogService;
    angular.module('slatwalladmin').service('dialogService', DialogService);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../services/dialogservice.js.map