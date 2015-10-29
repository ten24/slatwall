/// <reference path="../../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../../client/typings/slatwallTypeScript.d.ts" />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class SWGiftCardOrderInfoController {
        constructor(collectionConfigService) {
            this.collectionConfigService = collectionConfigService;
            this.init = () => {
                var orderConfig = this.collectionConfigService.newCollectionConfig('Order');
                orderConfig.setDisplayProperties("orderID, orderNumber, orderOpenDateTime, account.firstName, account.lastName");
                orderConfig.addFilter('orderID', this.giftCard.originalOrderItem_order_orderID);
                orderConfig.setAllRecords(true);
                orderConfig.getEntity().then((response) => {
                    this.order = response.records[0];
                });
            };
            this.init();
        }
    }
    SWGiftCardOrderInfoController.$inject = ["collectionConfigService"];
    slatwalladmin.SWGiftCardOrderInfoController = SWGiftCardOrderInfoController;
    class GiftCardOrderInfo {
        constructor(collectionConfigService, partialsPath) {
            this.collectionConfigService = collectionConfigService;
            this.partialsPath = partialsPath;
            this.scope = {};
            this.bindToController = {
                giftCard: "=?",
                order: "=?"
            };
            this.controller = SWGiftCardOrderInfoController;
            this.controllerAs = "swGiftCardOrderInfo";
            this.link = (scope, element, attrs) => {
            };
            this.templateUrl = partialsPath + "/entity/giftcard/orderinfo.html";
            this.restrict = "EA";
        }
    }
    GiftCardOrderInfo.$inject = ["collectionConfigService", "partialsPath"];
    slatwalladmin.GiftCardOrderInfo = GiftCardOrderInfo;
    angular.module('slatwalladmin')
        .directive('swGiftCardOrderInfo', ["collectionConfigService", "partialsPath",
            (collectionConfigService, partialsPath) => new GiftCardOrderInfo(collectionConfigService, partialsPath)
    ]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/giftcard/swgiftcardorderinfo.js.map