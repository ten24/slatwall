/// <reference path="../../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../../client/typings/slatwallTypeScript.d.ts" />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class SWGiftCardDetailController {
        constructor(collectionConfigService) {
            this.collectionConfigService = collectionConfigService;
            this.init = () => {
                var giftCardConfig = this.collectionConfigService.newCollectionConfig('GiftCard');
                giftCardConfig.setDisplayProperties("giftCardID, giftCardCode, currencyCode, giftCardPin, expirationDate, ownerFirstName, ownerLastName, ownerEmailAddress, activeFlag, balanceAmount,  originalOrderItem.sku.product.productName, originalOrderItem.sku.product.productID, originalOrderItem.order.orderID, originalOrderItem.orderItemID, orderItemGiftRecipient.firstName, orderItemGiftRecipient.lastName, orderItemGiftRecipient.emailAddress, orderItemGiftRecipient.giftMessage");
                giftCardConfig.addFilter('giftCardID', this.giftCardId);
                giftCardConfig.setAllRecords(true);
                giftCardConfig.getEntity().then((response) => {
                    this.giftCard = response.records[0];
                });
            };
            this.init();
        }
    }
    SWGiftCardDetailController.$inject = ["collectionConfigService"];
    slatwalladmin.SWGiftCardDetailController = SWGiftCardDetailController;
    class GiftCardDetail {
        constructor(collectionConfigService, partialsPath) {
            this.collectionConfigService = collectionConfigService;
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
        }
    }
    GiftCardDetail.$inject = ["collectionConfigService", "partialsPath"];
    slatwalladmin.GiftCardDetail = GiftCardDetail;
    angular.module('slatwalladmin')
        .directive('swGiftCardDetail', ["collectionConfigService", "partialsPath",
            (collectionConfigService, partialsPath) => new GiftCardDetail(collectionConfigService, partialsPath)
    ]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/giftcard/swgiftcarddetail.js.map