var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var GiftRecipient = (function () {
        function GiftRecipient(firstName, lastName, email, giftMessage, quantity) {
            var _this = this;
            this.firstName = firstName;
            this.lastName = lastName;
            this.email = email;
            this.giftMessage = giftMessage;
            this.quantity = quantity;
            this.getFullName = function () {
                return _this.firstName + ' ' + _this.lastName;
            };
            this.quantity = 1;
            this.firstName = "";
            this.lastName = "";
            this.email = "";
            this.giftMessage = "";
        }
        return GiftRecipient;
    })();
    slatwalladmin.GiftRecipient = GiftRecipient;
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../model/giftRecipient.js.map