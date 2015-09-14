var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class GiftCardBalance {
        constructor($slatwall, $templateCache, partialsPath) {
            this.$slatwall = $slatwall;
            this.$templateCache = $templateCache;
            this.partialsPath = partialsPath;
            this.scope = {
                giftCard: "=?",
                transactions: "=?",
                initialBalanceFormatted: "=?",
                currentBalanceFormatted: "=?",
                balancePercentage: "=?"
            };
            this.link = (scope, element, attrs) => {
                var initialBalance = 0;
                var totalDebit = 0;
                var transactionConfig = new slatwalladmin.CollectionConfig($slatwall, 'GiftCardTransaction');
                transactionConfig.setDisplayProperties("giftCardTransactionID, creditAmount, debitAmount, giftCard.giftCardID");
                transactionConfig.addFilter('giftCard.giftCardID', scope.giftCard.giftCardID);
                transactionConfig.setAllRecords(true);
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
                    scope.balancePercentage = ((initialBalance / currentBalance) * 100);
                });
            };
            this.templateUrl = partialsPath + "/entity/giftcard/balance.html";
            this.restrict = "EA";
        }
    }
    GiftCardBalance.$inject = ["$slatwall", "$templateCache", "partialsPath"];
    slatwalladmin.GiftCardBalance = GiftCardBalance;
    angular.module('slatwalladmin').directive('swGiftCardBalance', ["$slatwall", "$templateCache", "partialsPath", ($slatwall, $templateCache, partialsPath) => new GiftCardBalance($slatwall, $templateCache, partialsPath)]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/giftcard/swgiftcardbalance.js.map