/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class SWListingColumnController {
        constructor(partialsPath, utilityService, $slatwall) {
            this.partialsPath = partialsPath;
            this.utilityService = utilityService;
            this.$slatwall = $slatwall;
            this.init = () => {
                this.editable = this.editable || false;
            };
            console.log('ListingColumn');
            this.$slatwall = $slatwall;
            this.utilityService = utilityService;
            //need to perform init after promise completes
            this.init();
        }
    }
    slatwalladmin.SWListingColumnController = SWListingColumnController;
    class SWListingColumn {
        constructor(partialsPath, utiltiyService, $slatwall) {
            this.partialsPath = partialsPath;
            this.utiltiyService = utiltiyService;
            this.$slatwall = $slatwall;
            this.restrict = 'EA';
            this.scope = {};
            this.bindToController = {
                propertyIdentifier: "@",
                processObjectProperty: "@",
                title: "@",
                tdclass: "@",
                search: "=",
                sort: "=",
                filter: "=",
                range: "=",
                editable: "=",
                buttonGroup: "="
            };
            this.controller = SWListingColumnController;
            this.controllerAs = "swListingColumn";
            this.link = (scope, element, attrs) => {
            };
            this.templateUrl = partialsPath + 'listingcolumn.html';
        }
    }
    slatwalladmin.SWListingColumn = SWListingColumn;
    angular.module('slatwalladmin').directive('swListingColumn', ['partialsPath', 'utilityService', '$slatwall', (partialsPath, utilityService, $slatwall) => new SWListingColumn(partialsPath, utilityService, $slatwall)]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/common/swlistingcolumn.js.map