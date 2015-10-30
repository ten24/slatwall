/// <reference path="../../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../../client/typings/slatwallTypeScript.d.ts" />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class swGiftCardRecipientInfoController {
        constructor() {
        }
    }
    slatwalladmin.swGiftCardRecipientInfoController = swGiftCardRecipientInfoController;
    class GiftCardRecipientInfo {
        constructor(partialsPath) {
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
    GiftCardRecipientInfo.$inject = ["partialsPath"];
    slatwalladmin.GiftCardRecipientInfo = GiftCardRecipientInfo;
    angular.module('slatwalladmin')
        .directive('swGiftCardRecipientInfo', ["partialsPath",
            (partialsPath) => new GiftCardRecipientInfo(partialsPath)
    ]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/giftcard/swgiftcardrecipientinfo.js.map