/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    var SWFormFieldTextController = (function () {
        function SWFormFieldTextController(formService) {
            this.formService = formService;
            console.log("Text Field Property Display: ", this.propertyDisplay);
            if (this.propertyDisplay.isDirty == undefined)
                this.propertyDisplay.isDirty = false;
            this.propertyDisplay.form.$dirty = this.propertyDisplay.isDirty;
            this.formService.setPristinePropertyValue(this.propertyDisplay.property, this.propertyDisplay.object.data[this.propertyDisplay.property]);
        }
        SWFormFieldTextController.$inject = ['formService'];
        return SWFormFieldTextController;
    })();
    slatwalladmin.SWFormFieldTextController = SWFormFieldTextController;
    var SWFormFieldText = (function () {
        function SWFormFieldText($log, $slatwall, formService, partialsPath) {
            this.$log = $log;
            this.partialsPath = partialsPath;
            this.restrict = 'E';
            this.require = "^form";
            this.controller = SWFormFieldTextController;
            this.controllerAs = "ctrl";
            this.scope = true;
            this.bindToController = {
                propertyDisplay: "="
            };
            this.link = function (scope, element, attr, formController) {
            };
            this.templateUrl = this.partialsPath + "formfields/text.html";
            console.log("Partial: ", this.templateUrl);
        }
        SWFormFieldText.$inject = ['$scope', '$element', '$attribute', 'formController'];
        SWFormFieldText.$inject = ['$log', '$slatwall', 'formService', 'partialsPath'];
        return SWFormFieldText;
    })();
    slatwalladmin.SWFormFieldText = SWFormFieldText;
    angular.module('slatwalladmin').directive('swFormFieldText', ['$log', '$slatwall', 'formService', 'partialsPath', function ($log, $slatwall, formService, partialsPath) { return new SWFormFieldText($log, $slatwall, formService, partialsPath); }]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../../directives/common/form/swformfieldtext.js.map