var slatwalladmin;
(function (slatwalladmin) {
    var OrderItemGiftRecipientControl = (function () {
        function OrderItemGiftRecipientControl($scope) {
            this.$scope = $scope;
            this.orderItemGiftRecipients = $scope.orderItemGiftRecipients = [];
            console.log('init gift');
        }
        OrderItemGiftRecipientControl.prototype.add = function (recipient) {
            this.orderItemGiftRecipients.push(recipient);
        };
        OrderItemGiftRecipientControl.prototype.edit = function (recipient) {
        };
        OrderItemGiftRecipientControl.prototype.delete = function (recipient) {
        };
        OrderItemGiftRecipientControl.$inject = [
            '$scope'
        ];
        return OrderItemGiftRecipientControl;
    })();
    slatwalladmin.OrderItemGiftRecipientControl = OrderItemGiftRecipientControl;
    angular.module('slatwalladmin').controller('preprocessorderitem_addorderitemgiftrecipient', OrderItemGiftRecipientControl);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../controllers/preprocessorderitem_addorderitemgiftrecipient.js.map