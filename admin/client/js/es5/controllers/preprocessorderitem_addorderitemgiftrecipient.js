var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var OrderItemGiftRecipientControl = (function () {
        function OrderItemGiftRecipientControl($scope, $slatwall) {
            var _this = this;
            this.$scope = $scope;
            this.$slatwall = $slatwall;
            this.getQuantity = function () {
                if (angular.isUndefined(_this.quantity)) {
                    return 0;
                }
                else {
                    return _this.quantity;
                }
            };
            this.addGiftRecipientFromAccountList = function (account) {
                var giftRecipient = new slatwalladmin.GiftRecipient();
                giftRecipient.firstName = account.firstName;
                giftRecipient.lastName = account.lastName;
                giftRecipient.email = account.primaryEmailAddress_emailAddress;
                _this.orderItemGiftRecipients.push(giftRecipient);
                _this.searchText = "";
            };
            this.updateResults = function (keyword) {
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
                var accountPromise = $slatwall.getEntity('account', options);
                accountPromise.then(function (response) {
                    _this.$scope.collection = response;
                });
                return _this.$scope.collection;
            };
            this.getUnassignedCountArray = function () {
                var unassignedCountArray = new Array();
                for (var i = 1; i <= _this.getUnassignedCount(); i++) {
                    unassignedCountArray.push(i);
                }
                return unassignedCountArray;
            };
            this.getUnassignedCount = function () {
                var unassignedCount = _this.getQuantity();
                angular.forEach(_this.orderItemGiftRecipients, function (orderItemGiftRecipient) {
                    unassignedCount -= orderItemGiftRecipient.quantity;
                });
                return unassignedCount;
            };
            this.addGiftRecipient = function () {
                var giftRecipient = new slatwalladmin.GiftRecipient();
                angular.extend(giftRecipient, _this.currentGiftRecipient);
                _this.orderItemGiftRecipients.push(giftRecipient);
                _this.currentGiftRecipient = new slatwalladmin.GiftRecipient();
                _this.searchText = "";
            };
            this.startFormWithName = function () {
                if (_this.searchText == "") {
                    _this.currentGiftRecipient.firstName = _this.searchText;
                }
                else {
                    _this.currentGiftRecipient.firstName = _this.searchText;
                    _this.searchText = "";
                }
            };
            this.getTotalQuantity = function () {
                var totalQuantity = 0;
                angular.forEach(_this.orderItemGiftRecipients, function (orderItemGiftRecipient) {
                    totalQuantity += orderItemGiftRecipient.quantity;
                });
                return totalQuantity;
            };
            this.getMessageCharactersLeft = function () {
                if (angular.isDefined(_this.currentGiftRecipient.giftMessage)) {
                    return 250 - _this.currentGiftRecipient.giftMessage.length;
                }
                else {
                    return 250;
                }
            };
            this.orderItemGiftRecipients = $scope.orderItemGiftRecipients = [];
            $scope.collection = {};
            this.quantity = angular.element("input[ng-model='giftRecipientControl.quantity']").val();
            this.searchText = "";
            var count = 1;
            this.currentGiftRecipient = new slatwalladmin.GiftRecipient();
        }
        OrderItemGiftRecipientControl.$inject = ["$scope", "$slatwall"];
        return OrderItemGiftRecipientControl;
    })();
    slatwalladmin.OrderItemGiftRecipientControl = OrderItemGiftRecipientControl;
    angular.module('slatwalladmin').controller('preprocessorderitem_addorderitemgiftrecipient', OrderItemGiftRecipientControl);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../controllers/preprocessorderitem_addorderitemgiftrecipient.js.map