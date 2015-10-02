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
                var _this = this;
                this.edit = function (recipient) {
                    angular.forEach(_this.recipients, function (recipient) {
                        recipient.editing = false;
                    });
                    if (!recipient.editing) {
                        recipient.editing = true;
                    }
                };
                this.delete = function (recipient) {
                    _this.recipients.splice(_this.recipients.indexOf(recipient), 1);
                };
                this.saveGiftRecipient = function (recipient) {
                    recipient.editing = false;
                };
                this.getQuantity = function () {
                    if (isNaN(_this.quantity)) {
                        return 0;
                    }
                    else {
                        return _this.quantity;
                    }
                };
                this.getUnassignedCount = function () {
                    var unassignedCount = _this.getQuantity();
                    angular.forEach(_this.recipients, function (recipient) {
                        unassignedCount -= recipient.quantity;
                    });
                    return unassignedCount;
                };
                this.getMessageCharactersLeft = function () {
                    if (angular.isDefined(_this.recipient.giftMessage)) {
                        return 250 - _this.recipient.giftMessage.length;
                    }
                    else {
                        return 250;
                    }
                };
                this.getUnassignedCountArray = function () {
                    var unassignedCountArray = new Array();
                    for (var i = 1; i <= _this.recipient.quantity + _this.getUnassignedCount(); i++) {
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
