/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    var swFormFieldPasswordController = (function () {
        function swFormFieldPasswordController() {
            this.propertyDisplay = {
                form: {},
                property: any,
                isDirty: false
            };
            this.propertyDisplay.form[this.propertyDisplay.property].$dirty = this.propertyDisplay.isDirty;
        }
        return swFormFieldPasswordController;
    })();
    slatwalladmin.swFormFieldPasswordController = swFormFieldPasswordController;
    var swFormFieldPassword = (function () {
        function swFormFieldPassword($log, $slatwall, formService, partialsPath) {
            this.$log = $log;
            this.partialsPath = partialsPath;
            this.restrict = 'E';
            this.require = "^form";
            this.scope = {};
            this.transclude = true;
            this.bindToController = {
                propertyDisplay: "=?"
            };
            this.templateUrl = "";
            this.controller = swFormFieldPasswordController;
            this.$inject = ['partialsPath'];
            this.link = function (scope, element, attrs, formController) { };
            this.templateUrl = this.partialsPath + "formfields/password.html";
        }
        return swFormFieldPassword;
    })();
    slatwalladmin.swFormFieldPassword = swFormFieldPassword;
    angular.module('slatwalladmin').directive('swFormFieldPassword', ['$log', '$slatwall', 'formService', 'partialsPath', function ($log, $slatwall, formService, partialsPath) { return new swFormFieldPassword($log, $slatwall, formService, partialsPath); }]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../../directives/common/form/swformfieldpassword.js.map