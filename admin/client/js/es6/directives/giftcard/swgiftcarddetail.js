var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class SWGiftCardDetailController {
        constructor($slatwall) {
            this.$slatwall = $slatwall;
            this.init = () => {
                var giftCardConfig = new slatwalladmin.CollectionConfig(this.$slatwall, 'GiftCard');
                giftCardConfig.setDisplayProperties("giftCardID, giftCardCode, currencyCode, giftCardPin, expirationDate, ownerFirstName, ownerLastName, ownerEmailAddress, activeFlag, balanceAmount,  originalOrderItem.sku.product.productName, originalOrderItem.sku.product.productID, originalOrderItem.order.orderID, originalOrderItem.orderItemID, orderItemGiftRecipient.firstName, orderItemGiftRecipient.lastName, orderItemGiftRecipient.emailAddress, orderItemGiftRecipient.giftMessage");
                giftCardConfig.addFilter('giftCardID', this.giftCardId);
                giftCardConfig.setAllRecords(true);
                giftCardConfig.getEntity().then((response) => {
                    this.giftCard = response.records[0];
                });
            };
            this.$slatwall = $slatwall;
            this.init();
        }
    }
    SWGiftCardDetailController.$inject = ["$slatwall"];
    slatwalladmin.SWGiftCardDetailController = SWGiftCardDetailController;
    class GiftCardDetail {
        constructor($slatwall, partialsPath) {
            this.$slatwall = $slatwall;
            this.partialsPath = partialsPath;
            this.scope = {};
            this.bindToController = {
                giftCardId: "@",
                giftCard: "=?"
            };
            this.controller = SWGiftCardDetailController;
            this.controllerAs = "swGiftCardDetail";
            this.link = (scope, element, attrs) => {
            };
            this.templateUrl = partialsPath + "/entity/giftcard/basic.html";
            this.restrict = "E";
            this.$slatwall = $slatwall;
        }
    }
    GiftCardDetail.$inject = ["$slatwall", "partialsPath"];
    slatwalladmin.GiftCardDetail = GiftCardDetail;
    angular.module('slatwalladmin')
        .directive('swGiftCardDetail', ["$slatwall", "partialsPath",
            ($slatwall, partialsPath) => new GiftCardDetail($slatwall, partialsPath)
    ]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/giftcard/swgiftcarddetail.js.map