var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var GiftRecipient = (function () {
        function GiftRecipient(giftCardID, giftCardCode, giftCardPin, expirationDate, ownerFirstName, ownerLastName, ownerEmailAddress, activeFlag) {
            this.giftCardID = giftCardID;
            this.giftCardCode = giftCardCode;
            this.giftCardPin = giftCardPin;
            this.expirationDate = expirationDate;
            this.ownerFirstName = ownerFirstName;
            this.ownerLastName = ownerLastName;
            this.ownerEmailAddress = ownerEmailAddress;
            this.activeFlag = activeFlag;
        }
        return GiftRecipient;
    })();
    slatwalladmin.GiftRecipient = GiftRecipient;
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=giftCard.js.map
