/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var SWEntityActionBarButtonGroupController = (function () {
        function SWEntityActionBarButtonGroupController() {
        }
        return SWEntityActionBarButtonGroupController;
    })();
    slatwalladmin.SWEntityActionBarButtonGroupController = SWEntityActionBarButtonGroupController;
    var SWEntityActionBarButtonGroup = (function () {
        function SWEntityActionBarButtonGroup(partialsPath) {
            this.partialsPath = partialsPath;
            this.restrict = 'E';
            this.scope = {};
            this.transclude = true;
            this.bindToController = {};
            this.controller = SWEntityActionBarButtonGroupController;
            this.controllerAs = "swEntityActionBarButtonGroup";
            this.link = function (scope, element, attrs) {
            };
            this.templateUrl = partialsPath + 'entityactionbarbuttongroup.html';
        }
        return SWEntityActionBarButtonGroup;
    })();
    slatwalladmin.SWEntityActionBarButtonGroup = SWEntityActionBarButtonGroup;
    angular.module('slatwalladmin').directive('swEntityActionBarButtonGroup', ['partialsPath', function (partialsPath) { return new SWEntityActionBarButtonGroup(partialsPath); }]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/common/swentityactionbarbuttongroup.js.map