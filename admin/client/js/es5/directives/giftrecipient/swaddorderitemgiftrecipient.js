/// <reference path="../../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../../client/typings/slatwallTypeScript.d.ts" />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var SWAddOrderItemRecipientController = (function () {
        function SWAddOrderItemRecipientController($slatwall) {
            var _this = this;
            this.$slatwall = $slatwall;
            this.unassignedCountArray = [];
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
                if (_this.getUnassignedCount() < _this.unassignedCountArray.length) {
                    _this.unassignedCountArray.splice(_this.getUnassignedCount(), _this.unassignedCountArray.length);
                }
                if (_this.getUnassignedCount() > _this.unassignedCountArray.length) {
                    for (var i = _this.unassignedCountArray.length + 1; i <= _this.getUnassignedCount(); i++) {
                        _this.unassignedCountArray.push({ name: i, value: i });
                    }
                }
                return _this.unassignedCountArray;
            };
            this.getAssignedCount = function () {
                _this.assignedCount = 0;
                angular.forEach(_this.orderItemGiftRecipients, function (orderItemGiftRecipient) {
                    _this.assignedCount += orderItemGiftRecipient.quantity;
                });
                return _this.assignedCount;
            };
            this.getUnassignedCount = function () {
                _this.unassignedCount = _this.quantity;
                angular.forEach(_this.orderItemGiftRecipients, function (orderItemGiftRecipient) {
                    _this.unassignedCount -= orderItemGiftRecipient.quantity;
                });
                return _this.unassignedCount;
            };
            this.addGiftRecipient = function () {
                if (_this.currentGiftRecipient.forms.createRecipient.$valid) {
                    _this.showInvalidAddFormMessage = true;
                    _this.adding = false;
                    var giftRecipient = new slatwalladmin.GiftRecipient();
                    angular.extend(giftRecipient, _this.currentGiftRecipient.data);
                    _this.orderItemGiftRecipients.push(giftRecipient);
                    _this.searchText = "";
                    _this.currentGiftRecipient = _this.$slatwall.newEntity("OrderItemGiftRecipient");
                }
                else {
                    _this.showInvalidAddFormMessage = true;
                }
            };
            this.cancelAddRecipient = function () {
                _this.adding = false;
                _this.currentGiftRecipient.reset();
                _this.searchText = "";
                _this.showInvalidAddFormMessage = false;
            };
            this.startFormWithName = function (searchString) {
                if (searchString === void 0) { searchString = _this.searchText; }
                _this.adding = true;
                _this.currentGiftRecipient.forms.createRecipient.$setUntouched();
                _this.currentGiftRecipient.forms.createRecipient.$setPristine();
                if (searchString != "") {
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
            this.assignedCount = 0;
            this.searchText = "";
            var count = 1;
            this.currentGiftRecipient = $slatwall.newEntity("OrderItemGiftRecipient");
            this.orderItemGiftRecipients = [];
            this.showInvalidAddFormMessage = false;
        }
        SWAddOrderItemRecipientController.$inject = ["$slatwall"];
        return SWAddOrderItemRecipientController;
    })();
    slatwalladmin.SWAddOrderItemRecipientController = SWAddOrderItemRecipientController;
    var SWAddOrderItemGiftRecipient = (function () {
        function SWAddOrderItemGiftRecipient($slatwall, partialsPath) {
            this.$slatwall = $slatwall;
            this.partialsPath = partialsPath;
            this.require = "^form";
            this.restrict = "EA";
            this.transclude = true;
            this.scope = {};
            this.bindToController = {
                "quantity": "=",
                "orderItemGiftRecipients": "=",
                "adding": "=",
                "searchText": "=",
                "currentgiftRecipient": "=",
                "showInvalidAddFormMessage": "=?",
                "showInvalidRowMessage": "=?",
                "tableForm": "=",
                "recipientAddForm": "="
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

//# sourceMappingURL=swaddorderitemgiftrecipient.js.map
