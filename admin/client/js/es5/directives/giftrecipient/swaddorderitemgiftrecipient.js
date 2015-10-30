var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var SWAddOrderItemRecipientController = (function () {
        function SWAddOrderItemRecipientController($slatwall) {
            var _this = this;
            this.$slatwall = $slatwall;
            this.addGiftRecipientFromAccountList = function (account) {
                var giftRecipient = new slatwalladmin.GiftRecipient();
                giftRecipient.firstName = account.firstName;
                giftRecipient.lastName = account.lastName;
                giftRecipient.email = account.primaryEmailAddress_emailAddress;
                giftRecipient.account = true;
                _this.orderItemGiftRecipients.push(giftRecipient);
                _this.searchText = "";
            };
            this.getUnassignedCountArray = function () {
                var unassignedCountArray = new Array();
                for (var i = 1; i <= _this.getUnassignedCount(); i++) {
                    unassignedCountArray.push(i);
                }
                return unassignedCountArray;
            };
            this.getAssignedCount = function () {
                var assignedCount = 0;
                angular.forEach(_this.orderItemGiftRecipients, function (orderItemGiftRecipient) {
                    assignedCount += orderItemGiftRecipient.quantity;
                });
                return assignedCount;
            };
            this.getUnassignedCount = function () {
                var unassignedCount = _this.quantity;
                angular.forEach(_this.orderItemGiftRecipients, function (orderItemGiftRecipient) {
                    unassignedCount -= orderItemGiftRecipient.quantity;
                });
                return unassignedCount;
            };
            this.addGiftRecipient = function () {
                _this.adding = false;
                var giftRecipient = new slatwalladmin.GiftRecipient();
                angular.extend(giftRecipient, _this.currentGiftRecipient);
                _this.orderItemGiftRecipients.push(giftRecipient);
                _this.currentGiftRecipient = new slatwalladmin.GiftRecipient();
                _this.searchText = "";
            };
            this.startFormWithName = function (searchString) {
                if (searchString === void 0) { searchString = _this.searchText; }
                _this.adding = true;
                if (searchString == "") {
                    _this.currentGiftRecipient.firstName = searchString;
                }
                else {
                    _this.currentGiftRecipient.firstName = searchString;
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
            this.adding = false;
            this.searchText = "";
            var count = 1;
            this.currentGiftRecipient = new slatwalladmin.GiftRecipient();
            this.orderItemGiftRecipients = [];
        }
        SWAddOrderItemRecipientController.$inject = ["$slatwall"];
        return SWAddOrderItemRecipientController;
    })();
    slatwalladmin.SWAddOrderItemRecipientController = SWAddOrderItemRecipientController;
    var SWAddOrderItemGiftRecipient = (function () {
        function SWAddOrderItemGiftRecipient($slatwall, partialsPath) {
            this.$slatwall = $slatwall;
            this.partialsPath = partialsPath;
            this.restrict = "EA";
            this.transclude = true;
            this.scope = {};
            this.bindToController = {
                "quantity": "=",
                "orderItemGiftRecipients": "=",
                "adding": "=",
                "searchText": "=",
                "currentgiftRecipient": "="
            };
            this.controller = SWAddOrderItemRecipientController;
            this.controllerAs = "addGiftRecipientControl";
            this.link = function ($scope, element, attrs) {
            };
            this.templateUrl = partialsPath + "entity/OrderItemGiftRecipient/addorderitemgiftrecipient.html";
        }
        SWAddOrderItemGiftRecipient.$inject = ["$slatwall"];
        return SWAddOrderItemGiftRecipient;
    })();
    slatwalladmin.SWAddOrderItemGiftRecipient = SWAddOrderItemGiftRecipient;
    angular.module('slatwalladmin').directive('swAddOrderItemGiftRecipient', ["$slatwall", "partialsPath",
        function ($slatwall, partialsPath) {
            return new SWAddOrderItemGiftRecipient($slatwall, partialsPath);
        }]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/giftrecipient/swaddorderitemgiftrecipient.js.map