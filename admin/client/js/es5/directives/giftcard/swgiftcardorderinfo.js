/// <reference path="../../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../../client/typings/slatwallTypeScript.d.ts" />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var SWGiftCardOrderInfoController = (function () {
        function SWGiftCardOrderInfoController(collectionConfigService) {
            var _this = this;
            this.collectionConfigService = collectionConfigService;
            this.init = function () {
                var orderConfig = _this.collectionConfigService.newCollectionConfig('Order');
                orderConfig.setDisplayProperties("orderID, orderNumber, orderOpenDateTime, account.firstName, account.lastName");
                orderConfig.addFilter('orderID', _this.giftCard.originalOrderItem_order_orderID);
                orderConfig.setAllRecords(true);
                orderConfig.getEntity().then(function (response) {
                    _this.order = response.records[0];
                });
            };
            this.init();
        }
        SWGiftCardOrderInfoController.$inject = ["collectionConfigService"];
        return SWGiftCardOrderInfoController;
    })();
    slatwalladmin.SWGiftCardOrderInfoController = SWGiftCardOrderInfoController;
    var GiftCardOrderInfo = (function () {
        function GiftCardOrderInfo(collectionConfigService, partialsPath) {
            this.collectionConfigService = collectionConfigService;
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
        GiftCardOrderInfo.$inject = ["collectionConfigService", "partialsPath"];
        return GiftCardOrderInfo;
    })();
    slatwalladmin.GiftCardOrderInfo = GiftCardOrderInfo;
    angular.module('slatwalladmin')
        .directive('swGiftCardOrderInfo', ["collectionConfigService", "partialsPath",
        function (collectionConfigService, partialsPath) {
            return new GiftCardOrderInfo(collectionConfigService, partialsPath);
        }
    ]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/giftcard/swgiftcardorderinfo.js.map