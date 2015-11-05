/// <reference path="../../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../../client/typings/slatwallTypeScript.d.ts" />
angular.module('slatwalladmin')
    .directive('swOrderItemGiftRecipientRow', [
    '$templateCache',
    'partialsPath',
    function ($templateCache, partialsPath) {
        return {
            restrict: 'AE',
            templateUrl: partialsPath + "orderitemgiftrecipientrow.html",
            scope: {
                recipient: "=",
                recipients: "=",
                quantity: "=",
                showInvalidRecipientMessage: "=",
                tableForm: "=?",
                index: "="
            },
            bindToController: {
                recipient: "=",
                recipients: "=",
                quantity: "=",
                showInvalidRecipientMessage: "=",
                tableForm: "=?",
                index: "="
            },
            controller: function () {
                this.edit = (recipient) => {
                    angular.forEach(this.recipients, (recipient) => {
                        recipient.editing = false;
                    });
                    if (!recipient.editing) {
                        recipient.editing = true;
                    }
                };
                this.delete = (recipient) => {
                    this.recipients.splice(this.recipients.indexOf(recipient), 1);
                };
                this.saveGiftRecipient = (recipient) => {
                    if (this.tableForm.$valid) {
                        this.showInvalidRecipientMessage = false;
                        recipient.editing = false;
                    }
                    else {
                        this.showInvalidRecipientMessage = true;
                    }
                };
                this.getQuantity = () => {
                    if (isNaN(this.quantity)) {
                        return 0;
                    }
                    else {
                        return this.quantity;
                    }
                };
                this.getUnassignedCount = () => {
                    var unassignedCount = this.getQuantity();
                    angular.forEach(this.recipients, (recipient) => {
                        unassignedCount -= recipient.quantity;
                    });
                    return unassignedCount;
                };
                this.getMessageCharactersLeft = () => {
                    if (angular.isDefined(this.recipient.giftMessage)) {
                        return 250 - this.recipient.giftMessage.length;
                    }
                    else {
                        return 250;
                    }
                };
                this.getUnassignedCountArray = () => {
                    var unassignedCountArray = new Array();
                    for (var i = 1; i <= this.recipient.quantity + this.getUnassignedCount(); i++) {
                        unassignedCountArray.push(i);
                    }
                    return unassignedCountArray;
                };
            },
            controllerAs: "giftRecipientRowControl"
        };
    }
]);

//# sourceMappingURL=sworderitemgiftrecipientrow.js.map
