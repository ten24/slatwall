/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    var SWFormFieldNumberController = (function () {
        function SWFormFieldNumberController() {
            if (this.propertyDisplay.isDirty == undefined)
                this.propertyDisplay.isDirty = false;
            this.propertyDisplay.form.$dirty = this.propertyDisplay.isDirty;
        }
        return SWFormFieldNumberController;
    })();
    slatwalladmin.SWFormFieldNumberController = SWFormFieldNumberController;
    var SWFormFieldNumber = (function () {
        function SWFormFieldNumber($log, $slatwall, formService, partialsPath) {
            this.$log = $log;
            this.partialsPath = partialsPath;
            this.restrict = 'E';
            this.require = "^form";
            this.scope = true;
            this.bindToController = {
                propertyDisplay: "=?"
            };
            this.templateUrl = "";
            this.controller = SWFormFieldNumberController;
            this.controllerAs = "ctrl";
            this.link = function (scope, element, attrs, formController) { };
            this.templateUrl = this.partialsPath + "formfields/number.html";
        }
        SWFormFieldNumber.$inject = ['$log', '$slatwall', 'formService', 'partialsPath'];
        return SWFormFieldNumber;
    })();
    slatwalladmin.SWFormFieldNumber = SWFormFieldNumber;
    angular.module('slatwalladmin').directive('swFormFieldNumber', ['$log', '$slatwall', 'formService', 'partialsPath', function ($log, $slatwall, formService, partialsPath) { return new SWFormFieldNumber($log, $slatwall, formService, partialsPath); }]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../../directives/common/form/swformfieldnumber.js.map