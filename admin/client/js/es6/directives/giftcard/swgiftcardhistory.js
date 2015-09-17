var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class SWGiftCardHistoryController {
        constructor($slatwall) {
            this.$slatwall = $slatwall;
            this.init = () => {
                var initialBalance = 0;
                var totalDebit = 0;
                var transactionConfig = new slatwalladmin.CollectionConfig(this.$slatwall, 'GiftCardTransaction');
                transactionConfig.setDisplayProperties("giftCardTransactionID, creditAmount, debitAmount, createdDateTime, giftCard.giftCardID, orderPayment.order.orderNumber, orderPayment.order.orderOpenDateTime");
                transactionConfig.addFilter('giftCard.giftCardID', this.giftCard.giftCardID);
                transactionConfig.setAllRecords(true);
                transactionConfig.setOrderBy("orderPayment.order.orderOpenDateTime", "DESC");
                var transactionPromise = this.$slatwall.getEntity("GiftCardTransaction", transactionConfig.getOptions());
                transactionPromise.then((response) => {
                    this.transactions = response.records;
                    var initialCreditIndex = this.transactions.length - 1;
                    var initialBalance = this.transactions[initialCreditIndex].creditAmount;
                    var currentBalance = initialBalance;
                    angular.forEach(this.transactions, (transaction, index) => {
                        if (typeof transaction.debitAmount !== "string") {
                            transaction.debit = true;
                            totalDebit += transaction.debitAmount;
                            transaction.debitAmount = "$" + parseFloat(transaction.debitAmount.toString()).toFixed(2);
                        }
                        else {
                            if (index != initialCreditIndex) {
                                currentBalance += transaction.creditAmount;
                            }
                            transaction.debit = false;
                            transaction.creditAmount = "$" + parseFloat(transaction.creditAmount.toString()).toFixed(2);
                        }
                        var tempCurrentBalance = currentBalance - totalDebit;
                        transaction.balanceFormatted = "$" + parseFloat(tempCurrentBalance.toString()).toFixed(2);
                        if (index == initialCreditIndex) {
                            var emailSent = {
                                emailSent: true,
                                debit: false,
                                sentAt: transaction.orderPayment_order_orderOpenDateTime,
                                balanceFormatted: "$" + parseFloat(initialBalance.toString()).toFixed(2)
                            };
                            var activeCard = {
                                activated: true,
                                debit: false,
                                activeAt: transaction.orderPayment_order_orderOpenDateTime,
                                balanceFormatted: "$" + parseFloat(initialBalance.toString()).toFixed(2)
                            };
                            this.transactions.splice(index, 0, activeCard);
                            this.transactions.splice(index, 0, emailSent);
                        }
                    });
                });
                var orderConfig = new slatwalladmin.CollectionConfig(this.$slatwall, 'Order');
                orderConfig.setDisplayProperties("orderID, orderNumber, orderOpenDateTime, account.firstName, account.lastName, account.primaryEmailAddress.emailAddress");
                orderConfig.addFilter('orderID', this.giftCard.originalOrderItem_order_orderID);
                orderConfig.setAllRecords(true);
                orderConfig.getEntity().then((response) => {
                    this.order = response.records[0];
                });
            };
            this.$slatwall = $slatwall;
            this.init();
        }
    }
    slatwalladmin.SWGiftCardHistoryController = SWGiftCardHistoryController;
    class GiftCardHistory {
        constructor($slatwall, partialsPath) {
            this.$slatwall = $slatwall;
            this.partialsPath = partialsPath;
            this.scope = {};
            this.bindToController = {
                giftCard: "=?"
            };
            this.controller = SWGiftCardHistoryController;
            this.controllerAs = "swGiftCardHistory";
            this.link = (scope, element, attrs) => {
            };
            this.templateUrl = partialsPath + "/entity/giftcard/history.html";
            this.restrict = "EA";
        }
    }
    GiftCardHistory.$inject = ["$slatwall", "partialsPath"];
    slatwalladmin.GiftCardHistory = GiftCardHistory;
    angular.module('slatwalladmin')
        .directive('swGiftCardHistory', ["$slatwall", "partialsPath",
            ($slatwall, partialsPath) => new GiftCardHistory($slatwall, partialsPath)
    ]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/giftcard/swgiftcardhistory.js.map