/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
/*
angular.module('slatwalladmin')
.directive('swFormFieldNumber', [
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
            templateUrl:partialsPath+'formfields/number.html',
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
]);
*/
var slatwalladmin;
(function (slatwalladmin) {
    var swFormFieldNumberController = (function () {
        function swFormFieldNumberController() {
            this.propertyDisplay = {
                form: {},
                property: any,
                isDirty: false
            };
            this.propertyDisplay.form[this.propertyDisplay.property].$dirty = this.propertyDisplay.isDirty;
        }
        return swFormFieldNumberController;
    })();
    slatwalladmin.swFormFieldNumberController = swFormFieldNumberController;
    var swFormFieldNumber = (function () {
        function swFormFieldNumber($log, $slatwall, formService, partialsPath) {
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
            this.$inject = ['partialsPath'];
            this.link = function (scope, element, attrs, formController) { };
            this.templateUrl = this.partialsPath + "swformfieldnumber.html";
        }
        return swFormFieldNumber;
    })();
    slatwalladmin.swFormFieldNumber = swFormFieldNumber;
    angular.module('slatwalladmin').directive('swFormFieldNumberController', ['$log', '$slatwall', 'formService', 'partialsPath', function ($log, $slatwall, formService, partialsPath) { return new swFormFieldNumber($log, $slatwall, formService, partialsPath); }]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../../directives/common/form/swformfieldnumber.js.map