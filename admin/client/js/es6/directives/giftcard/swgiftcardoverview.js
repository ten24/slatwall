var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class swGiftCardOverviewController {
        constructor() {
        }
    }
    slatwalladmin.swGiftCardOverviewController = swGiftCardOverviewController;
    class GiftCardOverview {
        constructor(partialsPath) {
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
    GiftCardOverview.$inject = ["partialsPath"];
    slatwalladmin.GiftCardOverview = GiftCardOverview;
    angular.module('slatwalladmin')
        .directive('swGiftCardOverview', ["partialsPath",
            (partialsPath) => new GiftCardOverview(partialsPath)
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