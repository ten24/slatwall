var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var SWGiftCardDetailController = (function () {
        function SWGiftCardDetailController($slatwall) {
            var _this = this;
            this.$slatwall = $slatwall;
            this.init = function () {
                var giftCardConfig = new slatwalladmin.CollectionConfig(_this.$slatwall, 'GiftCard');
                giftCardConfig.setDisplayProperties("giftCardID, giftCardCode, currencyCode, giftCardPin, expirationDate, ownerFirstName, ownerLastName, ownerEmailAddress, activeFlag, balanceAmount,  originalOrderItem.sku.product.productName, originalOrderItem.sku.product.productID, originalOrderItem.order.orderID, originalOrderItem.orderItemID, orderItemGiftRecipient.firstName, orderItemGiftRecipient.lastName, orderItemGiftRecipient.emailAddress, orderItemGiftRecipient.giftMessage");
                giftCardConfig.addFilter('giftCardID', _this.giftCardId);
                giftCardConfig.setAllRecords(true);
                giftCardConfig.getEntity().then(function (response) {
                    _this.giftCard = response.records[0];
                });
            };
            this.$slatwall = $slatwall;
            this.init();
        }
        return SWGiftCardDetailController;
    })();
    slatwalladmin.SWGiftCardDetailController = SWGiftCardDetailController;
    var GiftCardDetail = (function () {
        function GiftCardDetail($slatwall, partialsPath) {
            this.$slatwall = $slatwall;
            this.partialsPath = partialsPath;
            this.scope = {};
            this.bindToController = {
                giftCardId: "@",
                giftCard: "=?"
            };
            this.controller = SWGiftCardDetailController;
            this.controllerAs = "swGiftCardDetail";
            this.link = function (scope, element, attrs) {
            };
            this.templateUrl = partialsPath + "/entity/giftcard/basic.html";
            this.restrict = "E";
            this.$slatwall = $slatwall;
        }
        GiftCardDetail.$inject = ["$slatwall", "partialsPath"];
        return GiftCardDetail;
    })();
    slatwalladmin.GiftCardDetail = GiftCardDetail;
    angular.module('slatwalladmin')
        .directive('swGiftCardDetail', ["$slatwall", "partialsPath",
        function ($slatwall, partialsPath) {
            return new GiftCardDetail($slatwall, partialsPath);
        }
    ]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=swgiftcarddetail.js.map
