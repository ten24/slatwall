/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    class swFormFieldPasswordController {
        constructor() {
            this.propertyDisplay.form.$dirty = this.propertyDisplay.isDirty;
        }
    }
    slatwalladmin.swFormFieldPasswordController = swFormFieldPasswordController;
    class SWFormFieldPassword {
        constructor($log, $slatwall, formService, partialsPath) {
            this.$log = $log;
            this.partialsPath = partialsPath;
            this.restrict = 'E';
            this.require = "^form";
            this.scope = true;
            this.bindToController = {
                propertyDisplay: "=?"
            };
            this.controller = swFormFieldPasswordController;
            this.controllerAs = "ctrl";
            this.link = (scope, element, attrs, formController) => { };
            this.$inject = ['$log', '$slatwall', 'formService', 'partialsPath'];
            this.templateUrl = this.partialsPath + "formfields/password.html";
        }
    }
    slatwalladmin.SWFormFieldPassword = SWFormFieldPassword;
    angular.module('slatwalladmin').directive('swFormFieldPassword', ['$log', '$slatwall', 'formService', 'partialsPath', ($log, $slatwall, formService, partialsPath) => new SWFormFieldPassword($log, $slatwall, formService, partialsPath)]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../../directives/common/form/swformfieldpassword.js.map