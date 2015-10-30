/// <reference path="../../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../../client/typings/slatwallTypeScript.d.ts" />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class SWGiftCardBalanceController {
        constructor(collectionConfigService) {
            this.collectionConfigService = collectionConfigService;
            this.init = () => {
                this.initialBalance = 0;
                var totalDebit = 0;
                var transactionConfig = this.collectionConfigService.newCollectionConfig('GiftCardTransaction');
                transactionConfig.setDisplayProperties("giftCardTransactionID, creditAmount, debitAmount, giftCard.giftCardID");
                transactionConfig.addFilter('giftCard.giftCardID', this.giftCard.giftCardID);
                transactionConfig.setAllRecords(true);
                var transactionPromise = transactionConfig.getEntity();
                transactionPromise.then((response) => {
                    this.transactions = response.records;
                    angular.forEach(this.transactions, (transaction, index) => {
                        if (typeof transaction.creditAmount !== "string") {
                            this.initialBalance += transaction.creditAmount;
                        }
                        if (typeof transaction.debitAmount !== "string") {
                            totalDebit += transaction.debitAmount;
                        }
                    });
                    this.currentBalance = this.initialBalance - totalDebit;
                    this.balancePercentage = ((this.currentBalance / this.initialBalance) * 100);
                });
            };
            this.init();
        }
    }
    SWGiftCardBalanceController.$inject = ["collectionConfigService"];
    slatwalladmin.SWGiftCardBalanceController = SWGiftCardBalanceController;
    class GiftCardBalance {
        constructor(collectionConfigService, partialsPath) {
            this.collectionConfigService = collectionConfigService;
            this.partialsPath = partialsPath;
            this.scope = {};
            this.bindToController = {
                giftCard: "=?",
                transactions: "=?",
                initialBalance: "=?",
                currentBalance: "=?",
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
    GiftCardBalance.$inject = ["collectionConfigService", "partialsPath"];
    slatwalladmin.GiftCardBalance = GiftCardBalance;
    angular.module('slatwalladmin')
        .directive('swGiftCardBalance', ["collectionConfigService", "partialsPath",
            (collectionConfigService, partialsPath) => new GiftCardBalance(collectionConfigService, partialsPath)
    ]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/giftcard/swgiftcardbalance.js.map