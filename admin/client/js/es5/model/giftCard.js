/// <reference path="../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../client/typings/slatwallTypeScript.d.ts" />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var GiftCard = (function () {
        function GiftCard(giftCardID, giftCardCode, giftCardPin, expirationDate, ownerFirstName, ownerLastName, ownerEmailAddress, activeFlag) {
            this.giftCardID = giftCardID;
            this.giftCardCode = giftCardCode;
            this.giftCardPin = giftCardPin;
            this.expirationDate = expirationDate;
            this.ownerFirstName = ownerFirstName;
            this.ownerLastName = ownerLastName;
            this.ownerEmailAddress = ownerEmailAddress;
            this.activeFlag = activeFlag;
        }
        return GiftCard;
    })();
    slatwalladmin.GiftCard = GiftCard;
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=giftCard.js.map
