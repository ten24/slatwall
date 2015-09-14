var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class GiftCardRecipientInfo {
        constructor($slatwall, $templateCache, partialsPath) {
            this.$slatwall = $slatwall;
            this.$templateCache = $templateCache;
            this.partialsPath = partialsPath;
            this.scope = {
                giftCard: "=?"
            };
            this.templateUrl = partialsPath + "/entity/giftcard/recipientinfo.html";
            this.restrict = "EA";
        }
    }
    GiftCardRecipientInfo.$inject = ["$slatwall", "$templateCache", "partialsPath"];
    slatwalladmin.GiftCardRecipientInfo = GiftCardRecipientInfo;
    angular.module('slatwalladmin').directive('swGiftCardRecipientInfo', ["$slatwall", "$templateCache", "partialsPath", ($slatwall, $templateCache, partialsPath) => new GiftCardRecipientInfo($slatwall, $templateCache, partialsPath)]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/giftcard/swgiftcardrecipientinfo.js.map