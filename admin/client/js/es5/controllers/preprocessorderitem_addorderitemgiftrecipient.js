var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var AddOrderItemGiftRecipient = (function () {
        function AddOrderItemGiftRecipient() {
            this.orderItemGiftRecipients = [];
        }
        AddOrderItemGiftRecipient.prototype.onTodos = function () {
            this.$scope.remainingCount = this.totalQuantity - this.orderItemGiftRecipients.length;
            this.$scope.totalCount = this.orderItemGiftRecipients.length;
        };
        AddOrderItemGiftRecipient.prototype.add = function () {
            this.orderItemGiftRecipients.push(recipient);
        };
        AddOrderItemGiftRecipient.prototype.edit = function (recipient) {
        };
        AddOrderItemGiftRecipient.prototype.delete = function (recipient) {
        };
        AddOrderItemGiftRecipient.$inject = [
            '$scope'
        ];
        return AddOrderItemGiftRecipient;
    })();
    slatwalladmin.AddOrderItemGiftRecipient = AddOrderItemGiftRecipient;
    angular.module('slatwalladmin').controller('preprocesorderitem_addorderitemgiftrecipient', AddOrderItemGiftRecipient);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../controllers/preprocessorderitem_addorderitemgiftrecipient.js.map