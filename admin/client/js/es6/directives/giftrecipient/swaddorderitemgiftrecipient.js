/// <reference path="../../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../../client/typings/slatwallTypeScript.d.ts" />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class SWAddOrderItemRecipientController {
        constructor($slatwall) {
            this.$slatwall = $slatwall;
            this.unassignedCountArray = [];
            this.addGiftRecipientFromAccountList = (account) => {
                var giftRecipient = new slatwalladmin.GiftRecipient();
                giftRecipient.firstName = account.firstName;
                giftRecipient.lastName = account.lastName;
                giftRecipient.email = account.primaryEmailAddress_emailAddress;
                giftRecipient.account = true;
                this.orderItemGiftRecipients.push(giftRecipient);
                this.searchText = "";
            };
            this.getUnassignedCountArray = () => {
                if (this.getUnassignedCount() < this.unassignedCountArray.length) {
                    this.unassignedCountArray.splice(this.getUnassignedCount(), this.unassignedCountArray.length);
                }
                if (this.getUnassignedCount() > this.unassignedCountArray.length) {
                    for (var i = this.unassignedCountArray.length + 1; i <= this.getUnassignedCount(); i++) {
                        this.unassignedCountArray.push({ name: i, value: i });
                    }
                }
                return this.unassignedCountArray;
            };
            this.getAssignedCount = () => {
                this.assignedCount = 0;
                angular.forEach(this.orderItemGiftRecipients, (orderItemGiftRecipient) => {
                    this.assignedCount += orderItemGiftRecipient.quantity;
                });
                return this.assignedCount;
            };
            this.getUnassignedCount = () => {
                this.unassignedCount = this.quantity;
                angular.forEach(this.orderItemGiftRecipients, (orderItemGiftRecipient) => {
                    this.unassignedCount -= orderItemGiftRecipient.quantity;
                });
                return this.unassignedCount;
            };
            this.addGiftRecipient = () => {
                if (this.currentGiftRecipient.forms.createRecipient.$valid) {
                    this.showInvalidAddFormMessage = true;
                    this.adding = false;
                    var giftRecipient = new slatwalladmin.GiftRecipient();
                    angular.extend(giftRecipient, this.currentGiftRecipient.data);
                    this.orderItemGiftRecipients.push(giftRecipient);
                    this.searchText = "";
                    this.currentGiftRecipient = this.$slatwall.newEntity("OrderItemGiftRecipient");
                }
                else {
                    this.showInvalidAddFormMessage = true;
                }
            };
            this.cancelAddRecipient = () => {
                this.adding = false;
                this.currentGiftRecipient.reset();
                this.searchText = "";
                this.showInvalidAddFormMessage = false;
            };
            this.startFormWithName = (searchString = this.searchText) => {
                this.adding = true;
                this.currentGiftRecipient.forms.createRecipient.$setUntouched();
                this.currentGiftRecipient.forms.createRecipient.$setPristine();
                if (searchString != "") {
                    this.currentGiftRecipient.firstName = searchString;
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
            this.adding = false;
            this.assignedCount = 0;
            this.searchText = "";
            var count = 1;
            this.currentGiftRecipient = $slatwall.newEntity("OrderItemGiftRecipient");
            this.orderItemGiftRecipients = [];
            this.showInvalidAddFormMessage = false;
        }
    }
    SWAddOrderItemRecipientController.$inject = ["$slatwall"];
    slatwalladmin.SWAddOrderItemRecipientController = SWAddOrderItemRecipientController;
    class SWAddOrderItemGiftRecipient {
        constructor($slatwall, partialsPath) {
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
            this.link = ($scope, element, attrs) => {
            };
            this.templateUrl = partialsPath + "entity/OrderItemGiftRecipient/addorderitemgiftrecipient.html";
        }
    }
    SWAddOrderItemGiftRecipient.$inject = ["$slatwall"];
    slatwalladmin.SWAddOrderItemGiftRecipient = SWAddOrderItemGiftRecipient;
    angular.module('slatwalladmin').directive('swAddOrderItemGiftRecipient', ["$slatwall", "partialsPath",
            ($slatwall, partialsPath) => new SWAddOrderItemGiftRecipient($slatwall, partialsPath)]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=swaddorderitemgiftrecipient.js.map
