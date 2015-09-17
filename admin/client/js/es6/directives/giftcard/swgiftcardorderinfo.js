var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class SWGiftCardOrderInfoController {
        constructor($slatwall) {
            this.$slatwall = $slatwall;
            this.init = () => {
                var orderConfig = new slatwalladmin.CollectionConfig($slatwall, 'Order');
                orderConfig.setDisplayProperties("orderID, orderNumber, orderOpenDateTime, account.firstName, account.lastName");
                orderConfig.addFilter('orderID', this.giftCard.originalOrderItem_order_orderID);
                orderConfig.setAllRecords(true);
                orderConfig.getEntity().then((response) => {
                    this.order = response.records[0];
                });
            };
            this.$slatwall = $slatwall;
            this.init();
        }
    }
    slatwalladmin.SWGiftCardOrderInfoController = SWGiftCardOrderInfoController;
    class GiftCardOrderInfo {
        constructor($slatwall, partialsPath) {
            this.$slatwall = $slatwall;
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
    GiftCardOrderInfo.$inject = ["$slatwall", "partialsPath"];
    slatwalladmin.GiftCardOrderInfo = GiftCardOrderInfo;
    angular.module('slatwalladmin')
        .directive('swGiftCardOrderInfo', ["$slatwall", "partialsPath",
            ($slatwall, partialsPath) => new GiftCardOrderInfo($slatwall, partialsPath)
    ]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/giftcard/swgiftcardorderinfo.js.map