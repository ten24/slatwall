/// <reference path="../../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../../client/typings/slatwallTypeScript.d.ts" />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var SWGiftCardHistoryController = (function () {
        function SWGiftCardHistoryController(collectionConfigService) {
            var _this = this;
            this.collectionConfigService = collectionConfigService;
            this.init = function () {
                var initialBalance = 0;
                var totalDebit = 0;
                var transactionConfig = _this.collectionConfigService.newCollectionConfig('GiftCardTransaction');
                transactionConfig.setDisplayProperties("giftCardTransactionID, creditAmount, debitAmount, createdDateTime, giftCard.giftCardID, orderPayment.order.orderNumber, orderPayment.order.orderOpenDateTime", "id,credit,debit,created,giftcardID,ordernumber,orderdatetime");
                transactionConfig.addFilter('giftCard.giftCardID', _this.giftCard.giftCardID);
                transactionConfig.setAllRecords(true);
                transactionConfig.setOrderBy("createdDateTime|DESC");
                var emailBounceConfig = _this.collectionConfigService.newCollectionConfig('EmailBounce');
                emailBounceConfig.setDisplayProperties("emailBounceID, rejectedEmailTo, rejectedEmailSendTime, relatedObject, relatedObjectID");
                emailBounceConfig.addFilter('relatedObjectID', _this.giftCard.giftCardID);
                emailBounceConfig.setAllRecords(true);
                emailBounceConfig.setOrderBy("rejectedEmailSendTime|DESC");
                var emailConfig = _this.collectionConfigService.newCollectionConfig('Email');
                emailConfig.setDisplayProperties('emailID, emailTo, relatedObject, relatedObjectID, createdDateTime');
                emailConfig.addFilter('relatedObjectID', _this.giftCard.giftCardID);
                emailConfig.setAllRecords(true);
                emailConfig.setOrderBy("createdDateTime|DESC");
                emailConfig.getEntity().then(function (response) {
                    _this.emails = response.records;
                    emailBounceConfig.getEntity().then(function (response) {
                        _this.bouncedEmails = response.records;
                        transactionConfig.getEntity().then(function (response) {
                            _this.transactions = response.records;
                            var initialCreditIndex = _this.transactions.length - 1;
                            var initialBalance = _this.transactions[initialCreditIndex].creditAmount;
                            var currentBalance = initialBalance;
                            for (var i = initialCreditIndex; i >= 0; i--) {
                                var transaction = _this.transactions[i];
                                if (typeof transaction.debitAmount !== "string") {
                                    transaction.debit = true;
                                    totalDebit += transaction.debitAmount;
                                }
                                else if (typeof transaction.creditAmount !== "string") {
                                    if (i != initialCreditIndex) {
                                        currentBalance += transaction.creditAmount;
                                    }
                                    transaction.debit = false;
                                }
                                var tempCurrentBalance = currentBalance - totalDebit;
                                transaction.balance = tempCurrentBalance;
                                if (i == initialCreditIndex) {
                                    var activeCard = {
                                        activated: true,
                                        debit: false,
                                        activeAt: transaction.orderPayment_order_orderOpenDateTime,
                                        balance: initialBalance
                                    };
                                    _this.transactions.splice(i, 0, activeCard);
                                    if (angular.isDefined(_this.bouncedEmails)) {
                                        angular.forEach(_this.bouncedEmails, function (email, bouncedEmailIndex) {
                                            email.bouncedEmail = true;
                                            email.balance = initialBalance;
                                            _this.transactions.splice(i, 0, email);
                                        });
                                    }
                                    if (angular.isDefined(_this.emails)) {
                                        angular.forEach(_this.emails, function (email) {
                                            email.emailSent = true;
                                            email.debit = false;
                                            email.sentAt = email.createdDateTime;
                                            email.balance = initialBalance;
                                            _this.transactions.splice(i, 0, email);
                                        });
                                    }
                                }
                            }
                        });
                    });
                });
                var orderConfig = _this.collectionConfigService.newCollectionConfig('Order');
                orderConfig.setDisplayProperties("orderID,orderNumber,orderOpenDateTime,account.firstName,account.lastName,account.accountID,account.primaryEmailAddress.emailAddress");
                orderConfig.addFilter('orderID', _this.giftCard.originalOrderItem_order_orderID);
                orderConfig.setAllRecords(true);
                orderConfig.getEntity().then(function (response) {
                    _this.order = response.records[0];
                });
            };
            this.init();
        }
        SWGiftCardHistoryController.$inject = ["collectionConfigService"];
        return SWGiftCardHistoryController;
    })();
    slatwalladmin.SWGiftCardHistoryController = SWGiftCardHistoryController;
    var GiftCardHistory = (function () {
        function GiftCardHistory(collectionConfigService, partialsPath) {
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
            this.link = function (scope, element, attrs) {
            };
            this.templateUrl = partialsPath + "/entity/giftcard/history.html";
            this.restrict = "EA";
        }
        GiftCardHistory.$inject = ["collectionConfigService", "partialsPath"];
        return GiftCardHistory;
    })();
    slatwalladmin.GiftCardHistory = GiftCardHistory;
    angular.module('slatwalladmin')
        .directive('swGiftCardHistory', ["collectionConfigService", "partialsPath",
        function (collectionConfigService, partialsPath) {
            return new GiftCardHistory(collectionConfigService, partialsPath);
        }
    ]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/giftcard/swgiftcardhistory.js.map