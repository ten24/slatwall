var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class SWGiftCardBalanceController {
        constructor($slatwall) {
            this.$slatwall = $slatwall;
            this.init = () => {
                var initialBalance = 0;
                var totalDebit = 0;
                var transactionConfig = new slatwalladmin.CollectionConfig(this.$slatwall, 'GiftCardTransaction');
                transactionConfig.setDisplayProperties("giftCardTransactionID, creditAmount, debitAmount, giftCard.giftCardID");
                transactionConfig.addFilter('giftCard.giftCardID', this.giftCard.giftCardID);
                transactionConfig.setAllRecords(true);
                var transactionPromise = this.$slatwall.getEntity("GiftCardTransaction", transactionConfig.getOptions());
                transactionPromise.then((response) => {
                    this.transactions = response.records;
                    angular.forEach(this.transactions, function (transaction, index) {
                        if (typeof transaction.creditAmount !== "string") {
                            initialBalance += transaction.creditAmount;
                        }
                        if (typeof transaction.debitAmount !== "string") {
                            totalDebit += transaction.debitAmount;
                        }
                    });
                    var currentBalance = initialBalance - totalDebit;
                    //temporarily hardcoded to $
                    this.currentBalanceFormatted = "$" + parseFloat(currentBalance.toString()).toFixed(2);
                    //temporarily hardcoded to $
                    this.initialBalanceFormatted = "$" + parseFloat(initialBalance.toString()).toFixed(2);
                    this.balancePercentage = ((currentBalance / initialBalance) * 100);
                });
            };
            this.$slatwall = $slatwall;
            this.init();
        }
    }
    slatwalladmin.SWGiftCardBalanceController = SWGiftCardBalanceController;
    class GiftCardBalance {
        constructor($slatwall, partialsPath) {
            this.$slatwall = $slatwall;
            this.partialsPath = partialsPath;
            this.scope = {};
            this.bindToController = {
                giftCard: "=?",
                transactions: "=?",
                initialBalanceFormatted: "=?",
                currentBalanceFormatted: "=?",
                balancePercentage: "=?"
            };
            this.controller = SWGiftCardBalanceController;
            this.controllerAs = "swGiftCardBalance";
            this.link = (scope, element, attrs) => {
            };
            this.templateUrl = partialsPath + "/entity/giftcard/balance.html";
            this.restrict = "EA";
        }
    }
    GiftCardBalance.$inject = ["$slatwall", "partialsPath"];
    slatwalladmin.GiftCardBalance = GiftCardBalance;
    angular.module('slatwalladmin')
        .directive('swGiftCardBalance', ["$slatwall", "partialsPath",
            ($slatwall, partialsPath) => new GiftCardBalance($slatwall, partialsPath)
    ]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/giftcard/swgiftcardbalance.js.map