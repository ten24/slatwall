var slatwalladmin;
(function (slatwalladmin) {
    class OrderItemGiftRecipientControl {
        constructor($scope) {
            this.$scope = $scope;
            this.getUnassignedCount = () => {
                return this.quantity - this.orderItemGiftRecipients.length;
            };
            this.addGiftRecipient = () => {
                console.log("adding recipient");
                var recipient = new slatwalladmin.GiftRecipient();
                recipient.firstName = this.$scope.giftRecipient.firstName;
                recipient.lastName = this.$scope.giftRecipient.lastName;
                recipient.email = this.$scope.giftRecipient.email;
                recipient.giftMessage = this.$scope.giftRecipient.giftMessage;
                this.orderItemGiftRecipients.push(recipient);
            };
            this.saveGiftRecipient = (recipient) => {
                console.log("saving recipient");
                recipient.editing = false;
            };
            this.getTotalQuantity = () => {
                var totalQuantity = 0;
                angular.forEach(this.orderItemGiftRecipients, (orderItemGiftRecipient) => {
                    totalQuantity += orderItemGiftRecipient.quantity;
                });
                return totalQuantity;
            };
            this.getMessageCharactersLeft = () => {
                var totalChar = 250;
                //get chars subtract return
            };
            this.edit = (recipient) => {
                console.log("editing recipient");
                if (!recipient.editing) {
                    recipient.editing = true;
                }
            };
            this.delete = (recipient) => {
                console.log("deleting recipient");
                this.orderItemGiftRecipients.splice(this.orderItemGiftRecipients.indexOf(recipient), 1);
            };
            this.$scope;
            this.orderItemGiftRecipients = $scope.orderItemGiftRecipients = [];
            this.quantity = angular.element("input[ng-model='giftRecipientControl.quantity']").val();
        }
    }
    OrderItemGiftRecipientControl.$inject = [
        '$scope'
    ];
    slatwalladmin.OrderItemGiftRecipientControl = OrderItemGiftRecipientControl;
    angular.module('slatwalladmin').controller('preprocessorderitem_addorderitemgiftrecipient', OrderItemGiftRecipientControl);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../controllers/preprocessorderitem_addorderitemgiftrecipient.js.map