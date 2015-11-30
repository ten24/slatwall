/// <reference path="../../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../../client/typings/slatwallTypeScript.d.ts" />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var SWGiftCardBalanceController = (function () {
        function SWGiftCardBalanceController(collectionConfigService) {
            var _this = this;
            this.collectionConfigService = collectionConfigService;
            this.init = function () {
                _this.initialBalance = 0;
                var totalDebit = 0;
                var totalCredit = 0;
                var transactionConfig = _this.collectionConfigService.newCollectionConfig('GiftCardTransaction');
                transactionConfig.setDisplayProperties("giftCardTransactionID, creditAmount, debitAmount, giftCard.giftCardID");
                transactionConfig.addFilter('giftCard.giftCardID', _this.giftCard.giftCardID);
                transactionConfig.setAllRecords(true);
                transactionConfig.setOrderBy("createdDateTime|DESC");
                var transactionPromise = transactionConfig.getEntity();
                transactionPromise.then(function (response) {
                    _this.transactions = response.records;
                    var initialCreditIndex = _this.transactions.length - 1;
                    _this.initialBalance = _this.transactions[initialCreditIndex].creditAmount;
                    angular.forEach(_this.transactions, function (transaction, index) {
                        if (!angular.isString(transaction.debitAmount)) {
                            totalDebit += transaction.debitAmount;
                        }
                        if (!angular.isString(transaction.creditAmount)) {
                            totalCredit += transaction.creditAmount;
                        }
                    });
                    _this.currentBalance = totalCredit - totalDebit;
                    _this.balancePercentage = parseInt(((_this.currentBalance / _this.initialBalance) * 100).toString());
                });
            };
            this.init();
        }
        SWGiftCardBalanceController.$inject = ["collectionConfigService"];
        return SWGiftCardBalanceController;
    })();
    slatwalladmin.SWGiftCardBalanceController = SWGiftCardBalanceController;
    var GiftCardBalance = (function () {
        function GiftCardBalance(collectionConfigService, partialsPath) {
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
            this.link = function (scope, element, attrs) {
            };
            this.templateUrl = partialsPath + "/entity/giftcard/balance.html";
            this.restrict = "EA";
        }
        GiftCardBalance.$inject = ["collectionConfigService", "partialsPath"];
        return GiftCardBalance;
    })();
    slatwalladmin.GiftCardBalance = GiftCardBalance;
    angular.module('slatwalladmin')
        .directive('swGiftCardBalance', ["collectionConfigService", "partialsPath",
        function (collectionConfigService, partialsPath) {
            return new GiftCardBalance(collectionConfigService, partialsPath);
        }
    ]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/giftcard/swgiftcardbalance.js.map