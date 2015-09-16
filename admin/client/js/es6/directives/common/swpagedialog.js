/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class SWPageDialogController {
        constructor(partialsPath) {
            this.partialsPath = partialsPath;
        }
    }
    slatwalladmin.SWPageDialogController = SWPageDialogController;
    class SWPageDialog {
        constructor() {
            this.restrict = 'E';
            this.scope = {};
            this.bindToController = {
                pageDialog: "="
            };
            this.controller = SWPageDialogController;
            this.controllerAs = "swPageDialog";
            this.link = (scope, element, attrs) => {
            };
            console.log('paged');
            console.log(this);
            this.templateUrl = partialsPath + this.pageDialog.path + '.html';
        }
    }
    slatwalladmin.SWPageDialog = SWPageDialog;
    angular.module('slatwalladmin').directive('swPageDialog', ['partialsPath', (partialsPath) => new SWPageDialog(partialsPath)]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/common/swpagedialog.js.map