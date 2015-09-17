var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class GiftRecipient {
        constructor(giftCardID, giftCardCode, giftCardPin, expirationDate, ownerFirstName, ownerLastName, ownerEmailAddress, activeFlag) {
            this.giftCardID = giftCardID;
            this.giftCardCode = giftCardCode;
            this.giftCardPin = giftCardPin;
            this.expirationDate = expirationDate;
            this.ownerFirstName = ownerFirstName;
            this.ownerLastName = ownerLastName;
            this.ownerEmailAddress = ownerEmailAddress;
            this.activeFlag = activeFlag;
        }
    }
    slatwalladmin.GiftRecipient = GiftRecipient;
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../model/giftCard.js.map