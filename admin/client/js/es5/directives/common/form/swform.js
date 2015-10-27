/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    var swForm = (function () {
        function swForm(formService) {
            this.formService = formService;
            this.formService = formService;
            return this.GetInstance();
        }
        swForm.prototype.GetInstance = function () {
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
        };
        swForm.$inject = ['formService'];
        return swForm;
    })();
    slatwalladmin.swForm = swForm;
    angular.module('slatwalladmin').directive('swForm', ['formService', function (formService) { return new swForm(formService); }]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../../directives/common/form/swform.js.map