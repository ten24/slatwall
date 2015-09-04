/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class SWActionCallerDropdownController {
        constructor() {
        }
    }
    slatwalladmin.SWActionCallerDropdownController = SWActionCallerDropdownController;
    class SWActionCallerDropdown {
        constructor(partialsPath) {
            this.partialsPath = partialsPath;
            this.restrict = 'E';
            this.scope = {};
            this.transclude = true;
            this.bindToController = {};
            this.controller = SWActionCallerDropdownController;
            this.controllerAs = "swActionCallerDropdown";
            this.link = (scope, element, attrs) => {
            };
            this.templateUrl = partialsPath + 'actioncallerdropdown.html';
        }
    }
    slatwalladmin.SWActionCallerDropdown = SWActionCallerDropdown;
    angular.module('slatwalladmin').directive('swActionCallerDropdown', ['partialsPath', (partialsPath) => new SWActionCallerDropdown(partialsPath)]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/common/swactioncallerdropdown.js.map