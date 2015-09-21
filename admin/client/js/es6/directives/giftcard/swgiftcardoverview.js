var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class swGiftCardOverviewController {
        constructor() {
        }
    }
    slatwalladmin.swGiftCardOverviewController = swGiftCardOverviewController;
    class GiftCardOverview {
        constructor($slatwall, partialsPath) {
            this.$slatwall = $slatwall;
            this.partialsPath = partialsPath;
            this.scope = {};
            this.bindToController = {
                giftCard: "=?"
            };
            this.controller = swGiftCardOverviewController;
            this.controllerAs = "swGiftCardOverview";
            this.templateUrl = partialsPath + "/entity/giftcard/overview.html";
            this.restrict = "EA";
        }
    }
    GiftCardOverview.$inject = ["$slatwall", "partialsPath"];
    slatwalladmin.GiftCardOverview = GiftCardOverview;
    angular.module('slatwalladmin')
        .directive('swGiftCardOverview', ["$slatwall", "partialsPath",
            ($slatwall, partialsPath) => new GiftCardOverview($slatwall, partialsPath)
    ]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/giftcard/swgiftcardoverview.js.map