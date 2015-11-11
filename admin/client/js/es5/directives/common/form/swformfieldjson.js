/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
/*angular.module('slatwalladmin')
.directive('swFormFieldJson', [
'$log',
'$slatwall',
'formService',
'partialsPath',
    function(
    $log,
    $slatwall,
    formService,
    partialsPath
    ){
        return{
            templateUrl:partialsPath+'formfields/json.html',
            require:"^form",
            restrict: 'E',
            scope:{
                propertyDisplay:"="
            },
            link:function(scope,element,attr,formController){
                scope.propertyDisplay.form[scope.propertyDisplay.property].$dirty = scope.propertyDisplay.isDirty;
            }
        };
    }
]);*/
var slatwalladmin;
(function (slatwalladmin) {
    var swFormFieldJsonController = (function () {
        function swFormFieldJsonController(formService) {
            this.propertyDisplay = {
                form: {},
                property: any,
                isDirty: false,
                object: {
                    data: {}
                }
            };
            this.propertyDisplay.form[this.propertyDisplay.property].$dirty = this.propertyDisplay.isDirty;
        }
        return swFormFieldJsonController;
    })();
    slatwalladmin.swFormFieldJsonController = swFormFieldJsonController;
    var swFormFieldJson = (function () {
        function swFormFieldJson($log, $slatwall, formService, partialsPath) {
            this.$log = $log;
            this.partialsPath = partialsPath;
            this.restrict = 'E';
            this.require = "^form";
            this.scope = {};
            this.transclude = true;
            this.controller = swFormFieldJsonController;
            this.bindToController = {
                propertyDisplay: "=?"
            };
            this.templateUrl = "";
            this.$inject = ['partialsPath'];
            this.link = function (scope, element, attrs, formController) { };
            this.templateUrl = this.partialsPath + "formfields/json.html";
        }
        return swFormFieldJson;
    })();
    slatwalladmin.swFormFieldJson = swFormFieldJson;
    angular.module('slatwalladmin').directive('swFormFieldJson', ['$log', '$slatwall', 'formService', 'partialsPath', function ($log, $slatwall, formService, partialsPath) { return new swFormFieldJson($log, $slatwall, formService, partialsPath); }]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../../directives/common/form/swformfieldjson.js.map