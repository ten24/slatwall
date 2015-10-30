/// <reference path="../../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../../client/typings/slatwallTypeScript.d.ts" />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class SWGiftCardHistoryController {
        constructor(collectionConfigService) {
            this.collectionConfigService = collectionConfigService;
            this.init = () => {
                var initialBalance = 0;
                var totalDebit = 0;
                var transactionConfig = this.collectionConfigService.newCollectionConfig('GiftCardTransaction');
                transactionConfig.setDisplayProperties("giftCardTransactionID, creditAmount, debitAmount, createdDateTime, giftCard.giftCardID, orderPayment.order.orderNumber, orderPayment.order.orderOpenDateTime");
                transactionConfig.addFilter('giftCard.giftCardID', this.giftCard.giftCardID);
                transactionConfig.setAllRecords(true);
                transactionConfig.setOrderBy("orderPayment.order.orderOpenDateTime");
                var transactionPromise = transactionConfig.getEntity();
                var emailBounceConfig = this.collectionConfigService.newCollectionConfig('EmailBounce');
                emailBounceConfig.setDisplayProperties("emailBounceID, rejectedEmailTo, rejectedEmailSendTime, relatedObject, relatedObjectID");
                emailBounceConfig.addFilter('relatedObject', "giftCard");
                emailBounceConfig.addFilter('relatedObjectID', this.giftCard.giftCardID);
                emailBounceConfig.setAllRecords(true);
                emailBounceConfig.setOrderBy("rejectedEmailSendTime");
                var emailBouncePromise = emailBounceConfig.getEntity();
                emailBouncePromise.then((response) => {
                    this.bouncedEmails = response.records;
                });
                transactionPromise.then((response) => {
                    this.transactions = response.records;
                    var initialCreditIndex = this.transactions.length - 1;
                    var initialBalance = this.transactions[initialCreditIndex].creditAmount;
                    var currentBalance = initialBalance;
                    angular.forEach(this.transactions, (transaction, index) => {
                        if (typeof transaction.debitAmount !== "string") {
                            transaction.debit = true;
                            totalDebit += transaction.debitAmount;
                        }
                        else {
                            if (index != initialCreditIndex) {
                                currentBalance += transaction.creditAmount;
                            }
                            transaction.debit = false;
                        }
                        var tempCurrentBalance = currentBalance - totalDebit;
                        transaction.balance = tempCurrentBalance;
                        if (index == initialCreditIndex) {
                            var emailSent = {
                                emailSent: true,
                                debit: false,
                                sentAt: transaction.orderPayment_order_orderOpenDateTime,
                                balance: initialBalance
                            };
                            var activeCard = {
                                activated: true,
                                debit: false,
                                activeAt: transaction.orderPayment_order_orderOpenDateTime,
                                balance: initialBalance
                            };
                            this.transactions.splice(index, 0, activeCard);
                            this.transactions.splice(index, 0, emailSent);
                            if (angular.isDefined(this.bouncedEmails)) {
                                angular.forEach(this.bouncedEmails, (email, bouncedEmailIndex) => {
                                    email.bouncedEmail = true;
                                    email.balance = initialBalance;
                                    this.transactions.splice(index, 0, email);
                                });
                            }
                        }
                    });
                });
                var orderConfig = this.collectionConfigService.newCollectionConfig('Order');
                orderConfig.setDisplayProperties("orderID, orderNumber, orderOpenDateTime, account.firstName, account.lastName, account.accountID, account.primaryEmailAddress.emailAddress");
                orderConfig.addFilter('orderID', this.giftCard.originalOrderItem_order_orderID);
                orderConfig.setAllRecords(true);
                orderConfig.getEntity().then((response) => {
                    this.order = response.records[0];
                });
            };
            this.init();
        }
    }
    SWGiftCardHistoryController.$inject = ["collectionConfigService"];
    slatwalladmin.SWGiftCardHistoryController = SWGiftCardHistoryController;
    class GiftCardHistory {
        constructor(collectionConfigService, partialsPath) {
            this.collectionConfigService = collectionConfigService;
            this.partialsPath = partialsPath;
            this.scope = {};
            this.bindToController = {
                giftCard: "=?",
                transactions: "=?",
                bouncedEmails: "=?",
                order: "=?"
            };
            this.controller = SWGiftCardHistoryController;
            this.controllerAs = "swGiftCardHistory";
            this.link = (scope, element, attrs) => {
            };
            this.templateUrl = partialsPath + "/entity/giftcard/history.html";
            this.restrict = "EA";
        }
    }
    GiftCardHistory.$inject = ["collectionConfigService", "partialsPath"];
    slatwalladmin.GiftCardHistory = GiftCardHistory;
    angular.module('slatwalladmin')
        .directive('swGiftCardHistory', ["collectionConfigService", "partialsPath",
            (collectionConfigService, partialsPath) => new GiftCardHistory(collectionConfigService, partialsPath)
    ]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/giftcard/swgiftcardhistory.js.map