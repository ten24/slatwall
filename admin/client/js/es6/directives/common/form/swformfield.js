/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    class swFormField {
        constructor($log, $templateCache, $window, $slatwall, formService, partialsPath) {
            this.$log = $log;
            this.$templateCache = $templateCache;
            this.$window = $window;
            this.$slatwall = $slatwall;
            this.formService = formService;
            this.partialsPath = partialsPath;
            this.partialsPath = partialsPath;
            this.$templateCache = $templateCache;
            this.$window = $window;
            this.$slatwall = $slatwall;
            this.formService = formService;
            this.partialsPath = partialsPath;
            return this.GetInstance();
        }
        GetInstance() {
            return {
                require: "^form",
                restrict: 'AE',
                scope: {
                    propertyDisplay: "="
                },
                templateUrl: this.partialsPath + 'formfields/formfield.html',
                link: (scope, element, attrs, formController) => {
                    if (angular.isUndefined(scope.propertyDisplay.object.$$getID) || scope.propertyDisplay.object.$$getID() === '') {
                        scope.propertyDisplay.isDirty = true;
                    }
                    if (angular.isDefined(formController[scope.propertyDisplay.property])) {
                        scope.propertyDisplay.errors = formController[scope.propertyDisplay.property].$error;
                        formController[scope.propertyDisplay.property].formType = scope.propertyDisplay.fieldType;
                    }
                }
            };
        }
    }
    swFormField.$inject = ['$log', 'templateCache', '$window', '$slatwall', 'formService', 'partialsPath'];
    slatwalladmin.swFormField = swFormField;
    angular.module('slatwalladmin').directive('swFormField', ['$log', '$templateCache', '$window', '$slatwall', 'formService', 'partialsPath', ($log, $templateCache, $window, $slatwall, formService, partialsPath) => new swFormField($log, $templateCache, $window, $slatwall, formService, partialsPath)]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../../directives/common/form/swformfield.js.map