var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class swGiftCardOverviewController {
        constructor() {
        }
    }
    slatwalladmin.swGiftCardOverviewController = swGiftCardOverviewController;
    class GiftCardOverview {
        constructor($slatwall, partialsPath) {
            this.$slatwall = $slatwall;
            this.partialsPath = partialsPath;
            this.scope = {};
            this.bindToController = {
                giftCard: "=?"
            };
            this.controller = swGiftCardOverviewController;
            this.controllerAs = "swGiftCardOverview";
            this.templateUrl = partialsPath + "/entity/giftcard/overview.html";
            this.restrict = "EA";
        }
    }
    GiftCardOverview.$inject = ["$slatwall", "partialsPath"];
    slatwalladmin.GiftCardOverview = GiftCardOverview;
    angular.module('slatwalladmin')
        .directive('swGiftCardOverview', ["$slatwall", "partialsPath",
            ($slatwall, partialsPath) => new GiftCardOverview($slatwall, partialsPath)
    ])
        .controller('MyController', ['$scope', function ($scope) {
            $scope.textToCopy = 'I can copy by clicking!';
            $scope.success = function () {
                console.log('Copied!');
            };
            $scope.fail = function (err) {
                console.error('Error!', err);
            };
        }]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/giftcard/swgiftcardoverview.js.map