/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    class swForm {
        constructor(formService) {
            this.formService = formService;
            this.formService = formService;
            return this.GetInstance();
        }
        GetInstance() {
            return {
                restrict: 'E',
                transclude: true,
                scope: {
                    object: "=",
                    context: "@",
                    name: "@"
                },
                template: '<ng-form><sw-form-registrar ng-transclude></sw-form-registrar></ng-form>',
                replace: true,
                link: function (scope) {
                    scope.context = scope.context || 'save';
                }
            };
        }
    }
    swForm.$inject = ['formService'];
    slatwalladmin.swForm = swForm;
    angular.module('slatwalladmin').directive('swForm', ['formService', (formService) => new swForm(formService)]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../../directives/common/form/swform.js.map