/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
/*angular.module('slatwalladmin')
.directive('swFormFieldText', [
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
            templateUrl:partialsPath+'formfields/text.html',
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
]);*/
var slatwalladmin;
(function (slatwalladmin) {
    class swFormFieldTextController {
        constructor(formService) {
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
    }
    slatwalladmin.swFormFieldTextController = swFormFieldTextController;
    class swFormFieldText {
        constructor($log, $slatwall, formService, partialsPath) {
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
            this.link = (scope, element, attrs, formController) => { };
            this.templateUrl = this.partialsPath + "formfields/text.html";
        }
    }
    slatwalladmin.swFormFieldText = swFormFieldText;
    angular.module('slatwalladmin').directive('swFormFieldText', ['$log', '$slatwall', 'formService', 'partialsPath', ($log, $slatwall, formService, partialsPath) => new swFormFieldText($log, $slatwall, formService, partialsPath)]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../../directives/common/form/swformfieldtext.js.map