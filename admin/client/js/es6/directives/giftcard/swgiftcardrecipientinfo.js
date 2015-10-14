var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class swGiftCardRecipientInfoController {
        constructor() {
        }
    }
    slatwalladmin.swGiftCardRecipientInfoController = swGiftCardRecipientInfoController;
    class GiftCardRecipientInfo {
        constructor($slatwall, partialsPath) {
            this.$slatwall = $slatwall;
            this.partialsPath = partialsPath;
            this.scope = {};
            this.bindToController = {
                giftCard: "=?"
            };
            this.controller = swGiftCardRecipientInfoController;
            this.controllerAs = "swGiftCardRecipientInfo";
            this.templateUrl = partialsPath + "/entity/giftcard/recipientinfo.html";
            this.restrict = "EA";
        }
    }
    GiftCardRecipientInfo.$inject = ["$slatwall", "partialsPath"];
    slatwalladmin.GiftCardRecipientInfo = GiftCardRecipientInfo;
    angular.module('slatwalladmin')
        .directive('swGiftCardRecipientInfo', ["$slatwall", "partialsPath",
            ($slatwall, partialsPath) => new GiftCardRecipientInfo($slatwall, partialsPath)
    ]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/giftcard/swgiftcardrecipientinfo.js.map