/// <reference path="../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../client/typings/slatwallTypeScript.d.ts" />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var GiftRecipient = (function () {
        function GiftRecipient(firstName, lastName, emailAddress, giftMessage, quantity, account, editing) {
            var _this = this;
            this.reset = function () {
                _this.firstName = null;
                _this.lastName = null;
                _this.emailAddress = null;
                _this.account = null;
                _this.editing = false;
                _this.quantity = 1;
            };
            this.quantity = 1;
            this.editing = false;
            this.account = false;
        }
        return GiftRecipient;
    })();
    slatwalladmin.GiftRecipient = GiftRecipient;
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=giftRecipient.js.map
