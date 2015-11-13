/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    var swFormFieldTextController = (function () {
        function swFormFieldTextController(formService) {
            this.propertyDisplay = {
                form: {},
                property: any,
                isDirty: false,
                object: {
                    data: {}
                }
            };
            this.propertyDisplay.form[this.propertyDisplay.property].$dirty = this.propertyDisplay.isDirty;
            formService.setPristinePropertyValue(this.propertyDisplay.property, this.propertyDisplay.object.data[this.propertyDisplay.property]);
        }
        return swFormFieldTextController;
    })();
    slatwalladmin.swFormFieldTextController = swFormFieldTextController;
    var swFormFieldText = (function () {
        function swFormFieldText($log, $slatwall, formService, partialsPath) {
            this.$log = $log;
            this.partialsPath = partialsPath;
            this.restrict = 'E';
            this.require = "^form";
            this.scope = {};
            this.transclude = true;
            this.controller = swFormFieldTextController;
            this.bindToController = {
                propertyDisplay: "=?"
            };
            this.templateUrl = "";
            this.$inject = ['partialsPath'];
            this.link = function (scope, element, attrs, formController) { };
            this.templateUrl = this.partialsPath + "formfields/text.html";
        }
        return swFormFieldText;
    })();
    slatwalladmin.swFormFieldText = swFormFieldText;
    angular.module('slatwalladmin').directive('swFormFieldText', ['$log', '$slatwall', 'formService', 'partialsPath', function ($log, $slatwall, formService, partialsPath) { return new swFormFieldText($log, $slatwall, formService, partialsPath); }]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../../directives/common/form/swformfieldtext.js.map