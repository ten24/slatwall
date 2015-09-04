/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class SWActionCallerController {
        constructor(utilityService, $slatwall) {
            this.utilityService = utilityService;
            this.$slatwall = $slatwall;
        }
    }
    slatwalladmin.SWActionCallerController = SWActionCallerController;
    class SWActionCaller {
        constructor(partialsPath, utiltiyService, $slatwall) {
            this.partialsPath = partialsPath;
            this.utiltiyService = utiltiyService;
            this.$slatwall = $slatwall;
            this.restrict = 'E';
            this.scope = {};
            this.transclude = true;
            this.bindToController = {
                action: "@",
                text: "=",
                type: "=",
                queryString: "=",
                title: "=",
                class: "=",
                icon: "=",
                iconOnly: "=",
                name: "=",
                confirm: "=",
                confirmtext: "=",
                disabled: "=",
                disabledtext: "=",
                modal: "=",
                modalFullWidth: "=",
                id: "="
            };
            this.controller = SWActionCallerController;
            this.controllerAs = "swActionCaller";
            this.link = (scope, element, attrs) => {
            };
            this.templateUrl = partialsPath + 'actioncaller.html';
        }
    }
    slatwalladmin.SWActionCaller = SWActionCaller;
    angular.module('slatwalladmin').directive('swActionCaller', ['partialsPath', 'utilityService', '$slatwall', (partialsPath, utilityService, $slatwall) => new SWActionCaller(partialsPath, utilityService, $slatwall)]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/common/swactioncaller.js.map