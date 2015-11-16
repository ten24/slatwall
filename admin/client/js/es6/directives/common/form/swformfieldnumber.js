/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    class SWFormFieldNumberController {
        constructor() {
            this.propertyDisplay.form.$dirty = this.propertyDisplay.isDirty;
        }
    }
    slatwalladmin.SWFormFieldNumberController = SWFormFieldNumberController;
    class SWFormFieldNumber {
        constructor($log, $slatwall, formService, partialsPath) {
            this.$log = $log;
            this.partialsPath = partialsPath;
            this.restrict = 'E';
            this.require = "^form";
            this.scope = {};
            this.bindToController = {
                propertyDisplay: "=?"
            };
            this.templateUrl = "";
            this.controller = SWFormFieldNumberController;
            this.controllerAs = "numberCtrl";
            this.link = (scope, element, attrs, formController) => { };
            this.templateUrl = this.partialsPath + "formfields/number.html";
        }
    }
    SWFormFieldNumber.$inject = ['$log', '$slatwall', 'formService', 'partialsPath'];
    slatwalladmin.SWFormFieldNumber = SWFormFieldNumber;
    angular.module('slatwalladmin').directive('swFormFieldNumber', ['$log', '$slatwall', 'formService', 'partialsPath', ($log, $slatwall, formService, partialsPath) => new SWFormFieldNumber($log, $slatwall, formService, partialsPath)]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../../directives/common/form/swformfieldnumber.js.map