/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    var swFormFieldPasswordController = (function () {
        function swFormFieldPasswordController() {
            this.propertyDisplay.form.$dirty = this.propertyDisplay.isDirty;
        }
        return swFormFieldPasswordController;
    })();
    slatwalladmin.swFormFieldPasswordController = swFormFieldPasswordController;
    var SWFormFieldPassword = (function () {
        function SWFormFieldPassword($log, $slatwall, formService, partialsPath) {
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
            this.link = function (scope, element, attrs, formController) { };
            this.$inject = ['$log', '$slatwall', 'formService', 'partialsPath'];
            this.templateUrl = this.partialsPath + "formfields/password.html";
        }
        return SWFormFieldPassword;
    })();
    slatwalladmin.SWFormFieldPassword = SWFormFieldPassword;
    angular.module('slatwalladmin').directive('swFormFieldPassword', ['$log', '$slatwall', 'formService', 'partialsPath', function ($log, $slatwall, formService, partialsPath) { return new SWFormFieldPassword($log, $slatwall, formService, partialsPath); }]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../../directives/common/form/swformfieldpassword.js.map