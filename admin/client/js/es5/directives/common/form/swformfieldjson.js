/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    var SWFormFieldJsonController = (function () {
        function SWFormFieldJsonController(formService) {
            this.propertyDisplay.form[this.propertyDisplay.property].$dirty = this.propertyDisplay.isDirty;
        }
        return SWFormFieldJsonController;
    })();
    slatwalladmin.SWFormFieldJsonController = SWFormFieldJsonController;
    var SWFormFieldJson = (function () {
        function SWFormFieldJson($log, $slatwall, formService, partialsPath) {
            this.$log = $log;
            this.partialsPath = partialsPath;
            this.restrict = 'E';
            this.require = "^form";
            this.scope = {};
            this.controller = SWFormFieldJsonController;
            this.bindToController = {
                propertyDisplay: "=?"
            };
            this.controllerAs = "jsonCtrl";
            this.templateUrl = "";
            this.$inject = ['partialsPath'];
            this.link = function (scope, element, attrs, formController) { };
            this.templateUrl = this.partialsPath + "formfields/json.html";
        }
        return SWFormFieldJson;
    })();
    slatwalladmin.SWFormFieldJson = SWFormFieldJson;
    angular.module('slatwalladmin').directive('swFormFieldJson', ['$log', '$slatwall', 'formService', 'partialsPath', function ($log, $slatwall, formService, partialsPath) { return new SWFormFieldJson($log, $slatwall, formService, partialsPath); }]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../../directives/common/form/swformfieldjson.js.map