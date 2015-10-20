/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class SWActionCallerDropdownController {
        constructor() {
            this.title = this.title || '';
            this.icon = this.icon || 'plus';
            this.type = this.type || 'button';
            this.dropdownClass = this.dropdownClass || '';
            this.dropdownId = this.dropdownId || '';
            this.buttonClass = this.buttonClass || 'btn-primary';
        }
    }
    slatwalladmin.SWActionCallerDropdownController = SWActionCallerDropdownController;
    class SWActionCallerDropdown {
        constructor(partialsPath) {
            this.partialsPath = partialsPath;
            this.restrict = 'E';
            this.scope = {};
            this.transclude = true;
            this.bindToController = {
                title: "@",
                icon: "@",
                type: "=",
                dropdownClass: "@",
                dropdownId: "@",
                buttonClass: "@"
            };
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