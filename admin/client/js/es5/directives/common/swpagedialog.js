/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var SWPageDialogController = (function () {
        function SWPageDialogController(partialsPath) {
            this.partialsPath = partialsPath;
        }
        return SWPageDialogController;
    })();
    slatwalladmin.SWPageDialogController = SWPageDialogController;
    var SWPageDialog = (function () {
        function SWPageDialog() {
            this.restrict = 'E';
            this.scope = {};
            this.bindToController = {
                pageDialog: "="
            };
            this.controller = SWPageDialogController;
            this.controllerAs = "swPageDialog";
            this.link = function (scope, element, attrs) {
            };
            console.log('paged');
            console.log(this);
            this.templateUrl = partialsPath + this.pageDialog.path + '.html';
        }
        return SWPageDialog;
    })();
    slatwalladmin.SWPageDialog = SWPageDialog;
    angular.module('slatwalladmin').directive('swPageDialog', ['partialsPath', function (partialsPath) { return new SWPageDialog(partialsPath); }]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/common/swpagedialog.js.map