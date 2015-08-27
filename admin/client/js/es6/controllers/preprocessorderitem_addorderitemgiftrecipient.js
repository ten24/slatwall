var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class OrderItemGiftRecipientControl {
        constructor($scope, $injector, $slatwall) {
            this.$scope = $scope;
            this.$injector = $injector;
            this.$slatwall = $slatwall;
            this.getQuantity = () => {
                if (isNaN(this.quantity)) {
                    return 0;
                }
                else {
                    return this.quantity;
                }
            };
            this.addGiftRecipientFromAccountList = (account) => {
                var giftRecipient = new slatwalladmin.GiftRecipient();
                giftRecipient.firstName = account.firstName;
                giftRecipient.lastName = account.lastName;
                giftRecipient.email = account.primaryEmailAddress_emailAddress;
                this.orderItemGiftRecipients.push(giftRecipient);
            };
            this.updateResults = (keyword) => {
                console.log("searching for:" + keyword);
                var options = {
                    baseEntityName: "SlatwallAccount",
                    baseEntityAlias: "_account",
                    keywords: keyword,
                    defaultColumns: false,
                    columnsConfig: angular.toJson([
                        { isDeletable: false,
                            isSearchable: false,
                            isVisible: true,
                            ormtype: "id",
                            propertyIdentifier: "_account.accountID",
                        },
                        { isDeletable: false,
                            isSearchable: true,
                            isVisible: true,
                            ormtype: "string",
                            propertyIdentifier: "_account.firstName",
                        },
                        { isDeletable: false,
                            isSearchable: true,
                            isVisible: true,
                            ormtype: "string",
                            propertyIdentifier: "_account.lastName",
                        },
                        { isDeletable: false,
                            isSearchable: true,
                            title: "Email Address",
                            isVisible: true,
                            ormtype: "string",
                            propertyIdentifier: "_account.primaryEmailAddress.emailAddress",
                        }
                    ])
                };
                console.log(angular.toJson(options));
                var accountPromise = $slatwall.getEntity('account', options);
                accountPromise.then((response) => {
                    this.$scope.collection = response;
                    console.log(this.$scope.collection);
                });
                return this.$scope.collection;
            };
            this.getUnassignedCountArray = () => {
                var unassignedCountArray = new Array();
                for (var i = 1; i <= this.getUnassignedCount(); i++) {
                    unassignedCountArray.push(i);
                }
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
            this.orderItemGiftRecipients = $scope.orderItemGiftRecipients = [];
            $scope.collection = {};
            this.quantity = angular.element("input[ng-model='giftRecipientControl.quantity']").val();
            var count = 1;
            this.currentGiftRecipient = new slatwalladmin.GiftRecipient();
        }
    }
    OrderItemGiftRecipientControl.$inject = ["$scope", "$injector", "$slatwall"];
    slatwalladmin.OrderItemGiftRecipientControl = OrderItemGiftRecipientControl;
    this.getMessageCharactersLeft = () => {
        if (angular.isDefined(this.currentGiftRecipient.giftMessage)) {
            return 250 - this.currentGiftRecipient.giftMessage.length;
        }
        else {
            return 250;
        }
    };
})(slatwalladmin || (slatwalladmin = {}));
angular.module('slatwalladmin').controller('preprocessorderitem_addorderitemgiftrecipient', OrderItemGiftRecipientControl);

//# sourceMappingURL=../controllers/preprocessorderitem_addorderitemgiftrecipient.js.map