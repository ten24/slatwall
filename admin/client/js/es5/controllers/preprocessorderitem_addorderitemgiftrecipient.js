var slatwalladmin;
(function (slatwalladmin) {
    var OrderItemGiftRecipientControl = (function () {
        function OrderItemGiftRecipientControl($scope) {
            var _this = this;
            this.$scope = $scope;
            this.getUnassignedCountArray = function () {
                var unassignedCountArray = new Array(_this.getUnassignedCount());
                for (var i = 0; i < unassignedCountArray.length; i++) {
                    unassignedCountArray[i] = i + 1;
                }
                return unassignedCountArray;
            };
            this.getUnassignedCount = function () {
                return _this.quantity - _this.orderItemGiftRecipients.length;
            };
            this.addGiftRecipient = function () {
                var giftRecipient = new slatwalladmin.GiftRecipient();
                angular.extend(giftRecipient, _this.currentGiftRecipient);
                _this.orderItemGiftRecipients.push(giftRecipient);
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
            this.currentGiftRecipient = new slatwalladmin.GiftRecipient();
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