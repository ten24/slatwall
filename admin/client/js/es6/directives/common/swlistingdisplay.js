/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class SWListingDisplayController {
        constructor() {
        }
    }
    slatwalladmin.SWListingDisplayController = SWListingDisplayController;
    class SWListingDisplay {
        constructor(partialsPath) {
            this.partialsPath = partialsPath;
            this.restrict = 'E';
            this.scope = {};
            this.bindToController = {
                paginator: "="
            };
            this.controller = SWListingDisplayController;
            this.controllerAs = "swListingDisplay";
            this.link = (scope, element, attrs) => {
            };
            this.templateUrl = partialsPath + 'listingdisplay.html';
        }
    }
    slatwalladmin.SWListingDisplay = SWListingDisplay;
    angular.module('slatwalladmin').directive('swListingDisplay', ['partialsPath', (partialsPath) => new slatwalladmin.SWPaginationBar(partialsPath)]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/common/swlistingdisplay.js.map