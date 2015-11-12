/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
/*
angular.module('slatwalladmin')
.directive('swFormFieldPassword', [
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
            templateUrl:partialsPath+'formfields/password.html',
            require:"^form",
            restrict: 'E',
            scope:{
                propertyDisplay:"="
            },
            link:function(scope,element,attr,formController){
                
                scope.propertyDisplay.form[scope.propertyDisplay.property].$dirty = scope.propertyDisplay.isDirty;
                formService.setPristinePropertyValue(scope.propertyDisplay.property,scope.propertyDisplay.object.data[scope.propertyDisplay.property]);
                
            }
        };
    }
]);
*/
var slatwalladmin;
(function (slatwalladmin) {
    class swFormFieldPasswordController {
        constructor() {
            this.propertyDisplay = {
                form: {},
                property: any,
                isDirty: false
            };
            this.propertyDisplay.form[this.propertyDisplay.property].$dirty = this.propertyDisplay.isDirty;
        }
    }
    slatwalladmin.swFormFieldPasswordController = swFormFieldPasswordController;
    class swFormFieldPassword {
        constructor($log, $slatwall, formService, partialsPath) {
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
            this.link = (scope, element, attrs, formController) => { };
            this.templateUrl = this.partialsPath + "formfields/password.html";
        }
    }
    slatwalladmin.swFormFieldPassword = swFormFieldPassword;
    angular.module('slatwalladmin').directive('swFormFieldPassword', ['$log', '$slatwall', 'formService', 'partialsPath', ($log, $slatwall, formService, partialsPath) => new swFormFieldPassword($log, $slatwall, formService, partialsPath)]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../../directives/common/form/swformfieldpassword.js.map