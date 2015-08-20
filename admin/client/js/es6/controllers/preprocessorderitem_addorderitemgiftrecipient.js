var slatwalladmin;
(function (slatwalladmin) {
    class OrderItemGiftRecipientControl {
        constructor($scope) {
            this.$scope = $scope;
            this.getUnassignedCountArray = () => {
                if (this.getUnassignedCount() > 0) {
                    var unassignedCountArray = new Array(this.getUnassignedCount());
                    for (var i = 0; i < unassignedCountArray.length; i++) {
                        unassignedCountArray[i] = i + 1;
                    }
                }
                else {
                    var unassignedCountArray = new Array(this.getUnassignedCount());
                    unassignedCountArray[0] = 1;
                }
                return unassignedCountArray;
            };
            this.getUnassignedCount = () => {
                return this.quantity - this.orderItemGiftRecipients.length;
            };
            this.addGiftRecipient = () => {
                var giftRecipient = new slatwalladmin.GiftRecipient();
                angular.extend(giftRecipient, this.currentGiftRecipient);
                this.orderItemGiftRecipients.push(giftRecipient);
                this.currentGiftRecipient = new slatwalladmin.GiftRecipient();
                ;
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
            this.$scope;
            this.orderItemGiftRecipients = $scope.orderItemGiftRecipients = [];
            this.quantity = angular.element("input[ng-model='giftRecipientControl.quantity']").val();
            var count = 1;
            this.currentGiftRecipient = new slatwalladmin.GiftRecipient();
        }
    }
    OrderItemGiftRecipientControl.$inject = [
        '$scope'
    ];
    slatwalladmin.OrderItemGiftRecipientControl = OrderItemGiftRecipientControl;
    angular.module('slatwalladmin').controller('preprocessorderitem_addorderitemgiftrecipient', OrderItemGiftRecipientControl);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../controllers/preprocessorderitem_addorderitemgiftrecipient.js.map