var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class GiftCardOrderInfo {
        constructor($slatwall, $templateCache, partialsPath) {
            this.$slatwall = $slatwall;
            this.$templateCache = $templateCache;
            this.partialsPath = partialsPath;
            this.scope = {
                giftCard: "=?",
                order: "=?"
            };
            this.link = (scope, element, attrs) => {
                var orderConfig = new slatwalladmin.CollectionConfig($slatwall, 'Order');
                orderConfig.setDisplayProperties("orderID, orderNumber, orderOpenDateTime, account.firstName, account.lastName");
                orderConfig.addFilter('orderID', scope.giftCard.originalOrderItem_order_orderID);
                orderConfig.setAllRecords(true);
                orderConfig.getEntity().then((response) => {
                    scope.order = response.records[0];
                });
            };
            this.templateUrl = partialsPath + "/entity/giftcard/orderinfo.html";
            this.restrict = "EA";
        }
    }
    GiftCardOrderInfo.$inject = ["$slatwall", "$templateCache", "partialsPath"];
    slatwalladmin.GiftCardOrderInfo = GiftCardOrderInfo;
    angular.module('slatwalladmin').directive('swGiftCardOrderInfo', ["$slatwall", "$templateCache", "partialsPath", ($slatwall, $templateCache, partialsPath) => new GiftCardOrderInfo($slatwall, $templateCache, partialsPath)]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/giftcard/swgiftcardorderinfo.js.map