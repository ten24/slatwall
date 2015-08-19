var slatwalladmin;
(function (slatwalladmin) {
    var OrderItemGiftRecipientControl = (function () {
        function OrderItemGiftRecipientControl($scope) {
            var _this = this;
            this.$scope = $scope;
            //        public quantityChanged = (quantity:number) =>{
            //            this.unassignedCount = this.calculateUnassignedCount();
            //        }
            this.getUnassignedCount = function () {
                return _this.quantity - _this.orderItemGiftRecipients.length;
            };
            this.addGiftRecipient = function () {
                var giftRecipient = new slatwalladmin.GiftRecipient();
                _this.orderItemGiftRecipients.push(giftRecipient);
            };
            this.getTotalQuantity = function () {
                var totalQuantity = 0;
                angular.forEach(_this.orderItemGiftRecipients, function (orderItemGiftRecipient) {
                    totalQuantity += orderItemGiftRecipient.quantity;
                });
                return totalQuantity;
            };
            //		private add = (recipient) =>{
            //			
            //            
            //		}
            this.edit = function (recipient) {
            };
            this.delete = function (recipient) {
            };
            this.orderItemGiftRecipients = $scope.orderItemGiftRecipients = [];
            this.quantity = angular.element("input[ng-model='giftRecipientControl.quantity']").val();
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