/// <reference path='../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var OrderItemGiftRecipientControl = (function () {
        function OrderItemGiftRecipientControl($scope, $slatwall) {
            var _this = this;
            this.$scope = $scope;
            this.$slatwall = $slatwall;
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
            this.orderItemGiftRecipients = $scope.orderItemGiftRecipients = [];
            $scope.collection = {};
            this.adding = false;
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

//# sourceMappingURL=preprocessorderitem_addorderitemgiftrecipient.js.map
