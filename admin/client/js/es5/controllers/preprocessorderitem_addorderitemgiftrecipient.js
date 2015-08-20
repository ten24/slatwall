var slatwalladmin;
(function (slatwalladmin) {
    var OrderItemGiftRecipientControl = (function () {
        function OrderItemGiftRecipientControl($scope) {
            var _this = this;
            this.$scope = $scope;
            this.getUnassignedCount = function () {
                return _this.quantity - _this.orderItemGiftRecipients.length;
            };
            this.addGiftRecipient = function () {
                console.log("adding recipient");
                var recipient = new slatwalladmin.GiftRecipient();
                recipient.firstName = _this.$scope.giftRecipient.firstName;
                recipient.lastName = _this.$scope.giftRecipient.lastName;
                recipient.email = _this.$scope.giftRecipient.email;
                recipient.giftMessage = _this.$scope.giftRecipient.giftMessage;
                _this.orderItemGiftRecipients.push(recipient);
            };
            this.saveGiftRecipient = function (recipient) {
                console.log("saving recipient");
                recipient.editing = false;
            };
            this.getTotalQuantity = function () {
                var totalQuantity = 0;
                angular.forEach(_this.orderItemGiftRecipients, function (orderItemGiftRecipient) {
                    totalQuantity += orderItemGiftRecipient.quantity;
                });
                return totalQuantity;
            };
            this.getMessageCharactersLeft = function () {
                var totalChar = 250;
                //get chars subtract return
            };
            this.edit = function (recipient) {
                console.log("editing recipient");
                if (!recipient.editing) {
                    recipient.editing = true;
                }
            };
            this.delete = function (recipient) {
                console.log("deleting recipient");
                _this.orderItemGiftRecipients.splice(_this.orderItemGiftRecipients.indexOf(recipient), 1);
            };
            this.$scope;
            this.orderItemGiftRecipients = $scope.orderItemGiftRecipients = [];
            this.quantity = angular.element("input[ng-model='giftRecipientControl.quantity']").val();
            this.quantityOptions = [];
            var count = 1;
            while (count <= this.quantity) {
                this.quantityOptions.push(count++);
            }
        }
        OrderItemGiftRecipientControl.$inject = [
            '$scope'
        ];
        return OrderItemGiftRecipientControl;
    })();
    slatwalladmin.OrderItemGiftRecipientControl = OrderItemGiftRecipientControl;
    angular.module('slatwalladmin').controller('preprocessorderitem_addorderitemgiftrecipient', OrderItemGiftRecipientControl);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../controllers/preprocessorderitem_addorderitemgiftrecipient.js.map