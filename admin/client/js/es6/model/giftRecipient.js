var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class GiftRecipient {
        constructor(firstName, lastName, email, giftMessage, quantity) {
            this.firstName = firstName;
            this.lastName = lastName;
            this.email = email;
            this.giftMessage = giftMessage;
            this.quantity = quantity;
            this.getFullName = () => {
                return this.firstName + ' ' + this.lastName;
            };
            this.quantity = 1;
            this.firstName = "";
            this.lastName = "";
            this.email = "";
            this.giftMessage = "";
        }
    }
    slatwalladmin.GiftRecipient = GiftRecipient;
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../model/giftRecipient.js.map