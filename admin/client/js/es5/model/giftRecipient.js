var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var GiftRecipient = (function () {
        function GiftRecipient(firstName, lastName, email, giftMessage, quantity, editing) {
            this.firstName = firstName;
            this.lastName = lastName;
            this.email = email;
            this.giftMessage = giftMessage;
            this.quantity = quantity;
            this.editing = editing;
            this.quantity = 1;
            this.editing = false;
        }
        return GiftRecipient;
    })();
    slatwalladmin.GiftRecipient = GiftRecipient;
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../model/giftRecipient.js.map