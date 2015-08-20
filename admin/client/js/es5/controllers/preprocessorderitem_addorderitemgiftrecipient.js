var slatwalladmin;
(function (slatwalladmin) {
    var OrderItemGiftRecipientControl = (function () {
        function OrderItemGiftRecipientControl($scope) {
            var _this = this;
            this.$scope = $scope;
            this.getUnassignedCountArray = function () {
                if (_this.getUnassignedCount() != 0) {
                    var unassignedCountArray = new Array(_this.getUnassignedCount());
                    for (var i = 0; i < unassignedCountArray.length; i++) {
                        unassignedCountArray[i] = i + 1;
                    }
                }
                else {
                    var unassignedCountArray = new Array();
                    unassignedCountArray[0] = 1;
                    console.log("countarray: " + unassignedCountArray);
                }
                return unassignedCountArray;
            };
            this.getUnassignedCount = function () {
                var unassignedCount = _this.quantity;
                angular.forEach(_this.orderItemGiftRecipients, function (orderItemGiftRecipient) {
                    unassignedCount -= orderItemGiftRecipient.quantity;
                });
                return unassignedCount;
            };
            this.addGiftRecipient = function () {
                var giftRecipient = new slatwalladmin.GiftRecipient();
                angular.extend(giftRecipient, _this.currentGiftRecipient);
                _this.orderItemGiftRecipients.push(giftRecipient);
                _this.currentGiftRecipient = new slatwalladmin.GiftRecipient();
                ;
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
            this.$scope;
            this.orderItemGiftRecipients = $scope.orderItemGiftRecipients = [];
            this.quantity = angular.element("input[ng-model='giftRecipientControl.quantity']").val();
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