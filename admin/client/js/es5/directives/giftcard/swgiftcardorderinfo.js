var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var SWGiftCardOrderInfoController = (function () {
        function SWGiftCardOrderInfoController($slatwall) {
            var _this = this;
            this.$slatwall = $slatwall;
            this.init = function () {
                var orderConfig = new slatwalladmin.CollectionConfig($slatwall, 'Order');
                orderConfig.setDisplayProperties("orderID, orderNumber, orderOpenDateTime, account.firstName, account.lastName");
                orderConfig.addFilter('orderID', _this.giftCard.originalOrderItem_order_orderID);
                orderConfig.setAllRecords(true);
                orderConfig.getEntity().then(function (response) {
                    _this.order = response.records[0];
                });
            };
            this.$slatwall = $slatwall;
            this.init();
        }
        return SWGiftCardOrderInfoController;
    })();
    slatwalladmin.SWGiftCardOrderInfoController = SWGiftCardOrderInfoController;
    var GiftCardOrderInfo = (function () {
        function GiftCardOrderInfo($slatwall, partialsPath) {
            this.$slatwall = $slatwall;
            this.partialsPath = partialsPath;
            this.scope = {};
            this.bindToController = {
                giftCard: "=?",
                order: "=?"
            };
            this.controller = SWGiftCardOrderInfoController;
            this.controllerAs = "swGiftCardOrderInfo";
            this.link = function (scope, element, attrs) {
            };
            this.templateUrl = partialsPath + "/entity/giftcard/orderinfo.html";
            this.restrict = "EA";
        }
        GiftCardOrderInfo.$inject = ["$slatwall", "partialsPath"];
        return GiftCardOrderInfo;
    })();
    slatwalladmin.GiftCardOrderInfo = GiftCardOrderInfo;
    angular.module('slatwalladmin')
        .directive('swGiftCardOrderInfo', ["$slatwall", "partialsPath",
        function ($slatwall, partialsPath) {
            return new GiftCardOrderInfo($slatwall, partialsPath);
        }
    ]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=swgiftcardorderinfo.js.map
