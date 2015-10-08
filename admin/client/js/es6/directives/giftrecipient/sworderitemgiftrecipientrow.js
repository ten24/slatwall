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
                index: "="
            },
            bindToController: {
                recipient: "=",
                recipients: "=",
                quantity: "="
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
                    recipient.editing = false;
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
