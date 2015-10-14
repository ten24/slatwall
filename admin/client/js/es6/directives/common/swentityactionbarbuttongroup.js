/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class SWEntityActionBarButtonGroupController {
        constructor() {
        }
    }
    slatwalladmin.SWEntityActionBarButtonGroupController = SWEntityActionBarButtonGroupController;
    class SWEntityActionBarButtonGroup {
        constructor(partialsPath) {
            this.partialsPath = partialsPath;
            this.restrict = 'E';
            this.scope = {};
            this.transclude = true;
            this.bindToController = {};
            this.controller = SWEntityActionBarButtonGroupController;
            this.controllerAs = "swEntityActionBarButtonGroup";
            this.link = (scope, element, attrs) => {
            };
            this.templateUrl = partialsPath + 'entityactionbarbuttongroup.html';
        }
    }
    slatwalladmin.SWEntityActionBarButtonGroup = SWEntityActionBarButtonGroup;
    angular.module('slatwalladmin').directive('swEntityActionBarButtonGroup', ['partialsPath', (partialsPath) => new SWEntityActionBarButtonGroup(partialsPath)]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/common/swentityactionbarbuttongroup.js.map