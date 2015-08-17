var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class AddOrderItemGiftRecipient {
        constructor() {
            this.orderItemGiftRecipients = [];
        }
        onTodos() {
            this.$scope.remainingCount = this.totalQuantity - this.orderItemGiftRecipients.length;
            this.$scope.totalCount = this.orderItemGiftRecipients.length;
        }
        add() {
            this.orderItemGiftRecipients.push(recipient);
        }
        edit(recipient) {
        }
        delete(recipient) {
        }
    }
    AddOrderItemGiftRecipient.$inject = [
        '$scope'
    ];
    slatwalladmin.AddOrderItemGiftRecipient = AddOrderItemGiftRecipient;
    angular.module('slatwalladmin').controller('preprocesorderitem_addorderitemgiftrecipient', AddOrderItemGiftRecipient);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../controllers/preprocessorderitem_addorderitemgiftrecipient.js.map