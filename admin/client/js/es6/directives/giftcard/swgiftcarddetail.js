var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class GiftCardDetail {
        constructor($slatwall, $templateCache, partialsPath) {
            this.$slatwall = $slatwall;
            this.$templateCache = $templateCache;
            this.partialsPath = partialsPath;
            this.scope = {
                giftCardId: "@",
                giftCard: "=?"
            };
            this.link = (scope, element, attrs) => {
                var giftCardConfig = new slatwalladmin.CollectionConfig($slatwall, 'GiftCard');
                giftCardConfig.setDisplayProperties("giftCardID, giftCardCode, giftCardPin, expirationDate, ownerFirstName, ownerLastName, ownerEmailAddress, activeFlag, balanceAmount,  originalOrderItem.sku.product.productName, originalOrderItem.order.orderID, originalOrderItem.orderItemID, orderItemGiftRecipient.firstName, orderItemGiftRecipient.lastName, orderItemGiftRecipient.emailAddress, orderItemGiftRecipient.giftMessage");
                giftCardConfig.addFilter('giftCardID', scope.giftCardId);
                giftCardConfig.setAllRecords(true);
                giftCardConfig.getEntity().then((response) => {
                    scope.giftCard = response.records[0];
                });
            };
            this.templateUrl = partialsPath + "/entity/giftcard/basic.html";
            this.restrict = "E";
        }
    }
    GiftCardDetail.$inject = ["$slatwall", "$templateCache", "partialsPath"];
    slatwalladmin.GiftCardDetail = GiftCardDetail;
    angular.module('slatwalladmin').directive('swGiftCardDetail', ["$slatwall", "$templateCache", "partialsPath", ($slatwall, $templateCache, partialsPath) => new GiftCardDetail($slatwall, $templateCache, partialsPath)]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/giftcard/swgiftcarddetail.js.map