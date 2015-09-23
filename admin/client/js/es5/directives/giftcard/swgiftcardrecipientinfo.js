var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var swGiftCardRecipientInfoController = (function () {
        function swGiftCardRecipientInfoController() {
        }
        return swGiftCardRecipientInfoController;
    })();
    slatwalladmin.swGiftCardRecipientInfoController = swGiftCardRecipientInfoController;
    var GiftCardRecipientInfo = (function () {
        function GiftCardRecipientInfo($slatwall, partialsPath) {
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
        GiftCardRecipientInfo.$inject = ["$slatwall", "partialsPath"];
        return GiftCardRecipientInfo;
    })();
    slatwalladmin.GiftCardRecipientInfo = GiftCardRecipientInfo;
    angular.module('slatwalladmin')
        .directive('swGiftCardRecipientInfo', ["$slatwall", "partialsPath",
        function ($slatwall, partialsPath) {
            return new GiftCardRecipientInfo($slatwall, partialsPath);
        }
    ]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/giftcard/swgiftcardrecipientinfo.js.map