var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var swGiftCardOverviewController = (function () {
        function swGiftCardOverviewController() {
        }
        return swGiftCardOverviewController;
    })();
    slatwalladmin.swGiftCardOverviewController = swGiftCardOverviewController;
    var GiftCardOverview = (function () {
        function GiftCardOverview($slatwall, partialsPath) {
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
        GiftCardOverview.$inject = ["$slatwall", "partialsPath"];
        return GiftCardOverview;
    })();
    slatwalladmin.GiftCardOverview = GiftCardOverview;
    angular.module('slatwalladmin')
        .directive('swGiftCardOverview', ["$slatwall", "partialsPath",
        function ($slatwall, partialsPath) {
            return new GiftCardOverview($slatwall, partialsPath);
        }
    ]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/giftcard/swgiftcardoverview.js.map