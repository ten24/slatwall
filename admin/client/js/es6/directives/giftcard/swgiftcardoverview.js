var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class GiftCardOverview {
        constructor($slatwall, $templateCache, partialsPath) {
            this.$slatwall = $slatwall;
            this.$templateCache = $templateCache;
            this.partialsPath = partialsPath;
            this.scope = {
                giftCard: "=?"
            };
            this.templateUrl = partialsPath + "/entity/giftcard/overview.html";
            this.restrict = "EA";
        }
    }
    GiftCardOverview.$inject = ["$slatwall", "$templateCache", "partialsPath"];
    slatwalladmin.GiftCardOverview = GiftCardOverview;
    angular.module('slatwalladmin')
        .directive('swGiftCardOverview', ["$slatwall", "$templateCache", "partialsPath",
            ($slatwall, $templateCache, partialsPath) => new GiftCardOverview($slatwall, $templateCache, partialsPath)
    ]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/giftcard/swgiftcardoverview.js.map