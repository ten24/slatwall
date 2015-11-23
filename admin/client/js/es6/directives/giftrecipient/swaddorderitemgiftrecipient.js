/// <reference path="../../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../../client/typings/slatwallTypeScript.d.ts" />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class SWAddOrderItemRecipientController {
        constructor($slatwall) {
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
                if (this.recipientAddForm.$valid) {
                    this.showInvalidAddFormMessage = true;
                    this.adding = false;
                    var giftRecipient = new slatwalladmin.GiftRecipient();
                    angular.extend(giftRecipient, this.currentGiftRecipient);
                    this.orderItemGiftRecipients.push(giftRecipient);
                    this.searchText = "";
                    this.currentGiftRecipient.reset();
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
            this.searchText = "";
            var count = 1;
            this.currentGiftRecipient = new slatwalladmin.GiftRecipient();
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

//# sourceMappingURL=../../directives/giftrecipient/swaddorderitemgiftrecipient.js.map