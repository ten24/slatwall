/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    class SWFormFieldJsonController {
        constructor(formService) {
            this.propertyDisplay.form[this.propertyDisplay.property].$dirty = this.propertyDisplay.isDirty;
        }
    }
    slatwalladmin.SWFormFieldJsonController = SWFormFieldJsonController;
    class SWFormFieldJson {
        constructor($log, $slatwall, formService, partialsPath) {
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
            this.link = (scope, element, attrs, formController) => { };
            this.templateUrl = this.partialsPath + "formfields/json.html";
        }
    }
    slatwalladmin.SWFormFieldJson = SWFormFieldJson;
    angular.module('slatwalladmin').directive('swFormFieldJson', ['$log', '$slatwall', 'formService', 'partialsPath', ($log, $slatwall, formService, partialsPath) => new SWFormFieldJson($log, $slatwall, formService, partialsPath)]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../../directives/common/form/swformfieldjson.js.map