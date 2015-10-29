var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class GiftRecipient {
        constructor(firstName, lastName, email, giftMessage, quantity, account, editing) {
            this.firstName = firstName;
            this.lastName = lastName;
            this.email = email;
            this.giftMessage = giftMessage;
            this.quantity = quantity;
            this.account = account;
            this.editing = editing;
            this.quantity = 1;
            this.editing = false;
            this.account = false;
        }
    }
    slatwalladmin.GiftRecipient = GiftRecipient;
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=giftRecipient.js.map
