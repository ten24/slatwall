/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var SWListingDisplayController = (function () {
        function SWListingDisplayController() {
        }
        return SWListingDisplayController;
    })();
    slatwalladmin.SWListingDisplayController = SWListingDisplayController;
    var SWListingDisplay = (function () {
        function SWListingDisplay(partialsPath) {
            this.partialsPath = partialsPath;
            this.restrict = 'E';
            this.scope = {};
            this.bindToController = {
                collection: "=",
                collectionConfig: "=",
                isRadio: "=",
                //angularLink:true || false
                angularLinks: "=",
                paginator: "="
            };
            this.controller = SWListingDisplayController;
            this.controllerAs = "swListingDisplay";
            this.link = function (scope, element, attrs) {
            };
            this.templateUrl = partialsPath + 'listingdisplay.html';
        }
        return SWListingDisplay;
    })();
    slatwalladmin.SWListingDisplay = SWListingDisplay;
    angular.module('slatwalladmin').directive('swListingDisplay', ['partialsPath', function (partialsPath) { return new slatwalladmin.SWPaginationBar(partialsPath); }]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/common/swlistingdisplay.js.map