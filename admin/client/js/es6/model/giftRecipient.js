/// <reference path="../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../client/typings/slatwallTypeScript.d.ts" />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class GiftRecipient {
        constructor(firstName, lastName, emailAddress, giftMessage, quantity, account, editing) {
            this.reset = () => {
                this.firstName = null;
                this.lastName = null;
                this.emailAddress = null;
                this.account = null;
                this.editing = false;
                this.quantity = 1;
            };
            this.quantity = 1;
            this.editing = false;
            this.account = false;
        }
    }
    slatwalladmin.GiftRecipient = GiftRecipient;
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=giftRecipient.js.map
