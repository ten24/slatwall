var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class GiftCardHistory {
        constructor($slatwall, $templateCache, partialsPath) {
            this.$slatwall = $slatwall;
            this.$templateCache = $templateCache;
            this.partialsPath = partialsPath;
            this.scope = {
                giftCard: "=?"
            };
            this.link = (scope, element, attrs) => {
                var initialBalance = 0;
                var totalDebit = 0;
                var transactionConfig = new slatwalladmin.CollectionConfig($slatwall, 'GiftCardTransaction');
                transactionConfig.setDisplayProperties("giftCardTransactionID, creditAmount, debitAmount, createdDateTime, orderPayment.order.orderNumber");
                transactionConfig.addFilter('giftCard.giftCardID', scope.giftCard.giftCardID);
                transactionConfig.setAllRecords(true);
                transactionConfig.setOrderBy("createdDateTime");
                var transactionPromise = $slatwall.getEntity("GiftCardTransaction", transactionConfig.getOptions());
                transactionPromise.then((response) => {
                    scope.transactions = response.records;
                    angular.forEach(scope.transactions, function (transaction, index) {
                        initialBalance += transaction.creditAmount;
                        totalDebit += transaction.debitAmount;
                    });
                    var currentBalance = initialBalance - totalDebit;
                    scope.currentBalanceFormatted = "$" + parseFloat(currentBalance.toString()).toFixed(2);
                    scope.initialBalanceFormatted = "$" + parseFloat(initialBalance.toString()).toFixed(2);
                    console.log(scope);
                });
                var orderConfig = new slatwalladmin.CollectionConfig($slatwall, 'Order');
                orderConfig.setDisplayProperties("orderID, orderNumber, orderOpenDateTime, account.firstName, account.lastName, account.primaryEmailAddress.emailAddress");
                orderConfig.addFilter('orderID', scope.giftCard.originalOrderItem_order_orderID);
                orderConfig.setAllRecords(true);
                orderConfig.getEntity().then((response) => {
                    scope.order = response.records[0];
                    console.log(scope);
                });
            };
            this.templateUrl = partialsPath + "/entity/giftcard/history.html";
            this.restrict = "EA";
        }
    }
    GiftCardHistory.$inject = ["$slatwall", "$templateCache", "partialsPath"];
    slatwalladmin.GiftCardHistory = GiftCardHistory;
    angular.module('slatwalladmin').directive('swGiftCardHistory', ["$slatwall", "$templateCache", "partialsPath", ($slatwall, $templateCache, partialsPath) => new GiftCardHistory($slatwall, $templateCache, partialsPath)]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/giftcard/swgiftcardhistory.js.map