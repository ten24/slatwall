var slatwalladmin;
(function (slatwalladmin) {
    class OrderItemGiftRecipientControl {
        constructor($scope, $slatwall) {
            this.$scope = $scope;
            this.getQuantity = () => {
                if (isNaN(this.quantity)) {
                    return 0;
                }
                else {
                    return this.quantity;
                }
            };
            this.getSearch = (keyword = "test") => {
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
                return this.$slatwall.getEntity('account', { filterAccountsConfig: filterAccountsConfig.trim() });
            };
            this.getUnassignedCountArray = () => {
                var unassignedCountArray = new Array();
                if (this.getUnassignedCount() > 1) {
                    for (var i = 1; i < this.getUnassignedCount(); i++) {
                        unassignedCountArray.push(i);
                    }
                }
                else {
                    unassignedCountArray.push(1);
                }
                console.log(unassignedCountArray);
                return unassignedCountArray;
            };
            this.getUnassignedCount = () => {
                var unassignedCount = this.getQuantity();
                angular.forEach(this.orderItemGiftRecipients, (orderItemGiftRecipient) => {
                    unassignedCount -= orderItemGiftRecipient.quantity;
                });
                return unassignedCount;
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
            this.$slatwall;
            this.orderItemGiftRecipients = $scope.orderItemGiftRecipients = [];
            this.quantity = angular.element("input[ng-model='giftRecipientControl.quantity']").val();
            var count = 1;
            this.currentGiftRecipient = new slatwalladmin.GiftRecipient();
            console.log(this.getSearch());
        }
    }
    OrderItemGiftRecipientControl.$inject = [
        '$scope',
        "$slatwall"
    ];
    slatwalladmin.OrderItemGiftRecipientControl = OrderItemGiftRecipientControl;
    angular.module('slatwalladmin').controller('preprocessorderitem_addorderitemgiftrecipient', OrderItemGiftRecipientControl);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../controllers/preprocessorderitem_addorderitemgiftrecipient.js.map