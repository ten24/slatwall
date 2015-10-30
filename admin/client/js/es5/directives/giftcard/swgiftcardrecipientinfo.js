/// <reference path="../../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../../client/typings/slatwallTypeScript.d.ts" />
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
        function GiftCardRecipientInfo(partialsPath) {
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
        GiftCardRecipientInfo.$inject = ["partialsPath"];
        return GiftCardRecipientInfo;
    })();
    slatwalladmin.GiftCardRecipientInfo = GiftCardRecipientInfo;
    angular.module('slatwalladmin')
        .directive('swGiftCardRecipientInfo', ["partialsPath",
        function (partialsPath) {
            return new GiftCardRecipientInfo(partialsPath);
        }
    ]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/giftcard/swgiftcardrecipientinfo.js.map