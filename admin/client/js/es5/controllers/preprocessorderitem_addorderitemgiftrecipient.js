var slatwalladmin;
(function (slatwalladmin) {
    var OrderItemGiftRecipientControl = (function () {
        function OrderItemGiftRecipientControl($scope, $slatwall) {
            var _this = this;
            this.$scope = $scope;
            this.getQuantity = function () {
                if (isNaN(_this.quantity)) {
                    return 0;
                }
                else {
                    return _this.quantity;
                }
            };
            this.getSearch = function (keyword) {
                if (keyword === void 0) { keyword = "test"; }
                var filterAccountsConfig = '[' +
                    ' {  ' +
                    '"filterGroup":[  ' +
                    ' {  ' +
                    ' "propertyIdentifier":"_account.firstName",' +
                    ' "comparisonOperator":"like",' +
                    ' "conditionDisplay":"Equals"' +
                    ' "ormtype":"string",' +
                    ' "value":"%' + keyword + '%"' +
                    '},' +
                    '{' +
                    ' "logicalOperator":"AND",' +
                    ' "propertyIdentifier":"_account.lastName",' +
                    ' "comparisonOperator":"like",' +
                    ' "ormtype":"string",' +
                    ' "value":"%' + keyword + '%"' +
                    '  }' +
                    ' ]' +
                    ' }' +
                    ']';
                return _this.$slatwall.getEntity('account', { filterAccountsConfig: filterAccountsConfig.trim() });
            };
            this.getUnassignedCountArray = function () {
                var unassignedCountArray = new Array();
                if (_this.getUnassignedCount() > 1) {
                    for (var i = 1; i < _this.getUnassignedCount(); i++) {
                        unassignedCountArray.push(i);
                    }
                }
                else {
                    unassignedCountArray.push(1);
                }
                console.log(unassignedCountArray);
                return unassignedCountArray;
            };
            this.getUnassignedCount = function () {
                var unassignedCount = _this.getQuantity();
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
            this.$slatwall;
            this.orderItemGiftRecipients = $scope.orderItemGiftRecipients = [];
            this.quantity = angular.element("input[ng-model='giftRecipientControl.quantity']").val();
            var count = 1;
            this.currentGiftRecipient = new slatwalladmin.GiftRecipient();
            console.log(this.getSearch());
        }
        OrderItemGiftRecipientControl.$inject = [
            '$scope',
            "$slatwall"
        ];
        return OrderItemGiftRecipientControl;
    })();
    slatwalladmin.OrderItemGiftRecipientControl = OrderItemGiftRecipientControl;
    angular.module('slatwalladmin').controller('preprocessorderitem_addorderitemgiftrecipient', OrderItemGiftRecipientControl);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../controllers/preprocessorderitem_addorderitemgiftrecipient.js.map