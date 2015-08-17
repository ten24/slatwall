var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var GiftRecipient = (function () {
        function GiftRecipient(firstName, lastName, email, giftMessage) {
            this.firstName = firstName;
            this.lastName = lastName;
            this.email = email;
            this.giftMessage = giftMessage;
        }
        return GiftRecipient;
    })();
    slatwalladmin.GiftRecipient = GiftRecipient;
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../model/giftRecipient.js.map