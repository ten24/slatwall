var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class OrderItemGiftRecipientControl {
        constructor($scope, $slatwall) {
            this.$scope = $scope;
            this.$slatwall = $slatwall;
            this.addGiftRecipientFromAccountList = (account) => {
                var giftRecipient = new slatwalladmin.GiftRecipient();
                giftRecipient.firstName = account.firstName;
                giftRecipient.lastName = account.lastName;
                giftRecipient.email = account.primaryEmailAddress_emailAddress;
                giftRecipient.account = true;
                this.orderItemGiftRecipients.push(giftRecipient);
                this.searchText = "";
            };
            this.updateResults = (keyword) => {
                var options = {
                    baseEntityName: "SlatwallAccount",
                    baseEntityAlias: "_account",
                    keywords: keyword,
                    defaultColumns: false,
                    columnsConfig: angular.toJson([
                        {
                            isDeletable: false,
                            isSearchable: false,
                            isVisible: true,
                            ormtype: "id",
                            propertyIdentifier: "_account.accountID",
                        },
                        {
                            isDeletable: false,
                            isSearchable: true,
                            isVisible: true,
                            ormtype: "string",
                            propertyIdentifier: "_account.firstName",
                        },
                        {
                            isDeletable: false,
                            isSearchable: true,
                            isVisible: true,
                            ormtype: "string",
                            propertyIdentifier: "_account.lastName",
                        },
                        {
                            isDeletable: false,
                            isSearchable: true,
                            title: "Email Address",
                            isVisible: true,
                            ormtype: "string",
                            propertyIdentifier: "_account.primaryEmailAddress.emailAddress",
                        }
                    ])
                };
                var accountPromise = $slatwall.getEntity('account', options);
                accountPromise.then((response) => {
                    this.$scope.collection = response;
                    if (angular.isDefined(this.$scope.collection)) {
                        angular.forEach(this.$scope.collection.pageRecords, (account) => {
                            account.gravatar = "http://www.gravatar.com/avatar/" + md5(account.primaryEmailAddress_emailAddress.toLowerCase().trim());
                        });
                    }
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
            this.getAssignedCount = () => {
                var assignedCount = 0;
                angular.forEach(this.orderItemGiftRecipients, (orderItemGiftRecipient) => {
                    assignedCount += orderItemGiftRecipient.quantity;
                });
                return assignedCount;
            };
            this.getUnassignedCount = () => {
                var unassignedCount = this.quantity;
                angular.forEach(this.orderItemGiftRecipients, (orderItemGiftRecipient) => {
                    unassignedCount -= orderItemGiftRecipient.quantity;
                });
                return unassignedCount;
            };
            this.addGiftRecipient = () => {
                this.adding = false;
                var giftRecipient = new slatwalladmin.GiftRecipient();
                angular.extend(giftRecipient, this.currentGiftRecipient);
                this.orderItemGiftRecipients.push(giftRecipient);
                this.currentGiftRecipient = new slatwalladmin.GiftRecipient();
                this.searchText = "";
            };
            this.startFormWithName = () => {
                this.adding = true;
                if (this.searchText == "") {
                    this.currentGiftRecipient.firstName = this.searchText;
                }
                else {
                    this.currentGiftRecipient.firstName = this.searchText;
                    this.searchText = "";
                }
            };
            this.getTotalQuantity = () => {
                var totalQuantity = 0;
                angular.forEach(this.orderItemGiftRecipients, (orderItemGiftRecipient) => {
                    totalQuantity += orderItemGiftRecipient.quantity;
                });
                return totalQuantity;
            };
            this.getMessageCharactersLeft = () => {
                if (angular.isDefined(this.currentGiftRecipient.giftMessage)) {
                    return 250 - this.currentGiftRecipient.giftMessage.length;
                }
                else {
                    return 250;
                }
            };
            this.orderItemGiftRecipients = $scope.orderItemGiftRecipients = [];
            $scope.collection = {};
            this.adding = false;
            this.searchText = "";
            var count = 1;
            this.currentGiftRecipient = new slatwalladmin.GiftRecipient();
        }
    }
    OrderItemGiftRecipientControl.$inject = ["$scope", "$slatwall"];
    slatwalladmin.OrderItemGiftRecipientControl = OrderItemGiftRecipientControl;
    angular.module('slatwalladmin').controller('preprocessorderitem_addorderitemgiftrecipient', OrderItemGiftRecipientControl);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=preprocessorderitem_addorderitemgiftrecipient.js.map
