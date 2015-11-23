/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var SWListingGlobalSearchController = (function () {
        function SWListingGlobalSearchController($timeout) {
            var _this = this;
            this.$timeout = $timeout;
            this.init = function () {
                _this.searching = false;
            };
            this.search = function () {
                if (_this.searchText.length >= 2) {
                    _this.searching = true;
                    if (_this._timeoutPromise) {
                        _this.$timeout.cancel(_this._timeoutPromise);
                    }
                    _this._timeoutPromise = _this.$timeout(function () {
                        _this.getCollection();
                    }, 500);
                }
                else if (_this.searchText.length === 0) {
                    _this.$timeout(function () {
                        _this.getCollection();
                    });
                }
            };
            this.init();
        }
        SWListingGlobalSearchController.$inject = ['$timeout'];
        return SWListingGlobalSearchController;
    })();
    slatwalladmin.SWListingGlobalSearchController = SWListingGlobalSearchController;
    var SWListingGlobalSearch = (function () {
        function SWListingGlobalSearch(utilityService, partialsPath) {
            this.utilityService = utilityService;
            this.partialsPath = partialsPath;
            this.restrict = 'EA';
            this.scope = {};
            this.bindToController = {
                searching: "=",
                searchText: "=",
                getCollection: "="
            };
            this.controller = SWListingGlobalSearchController;
            this.controllerAs = "swListingGlobalSearch";
            this.link = function (scope, element, attrs) {
            };
            this.templateUrl = partialsPath + "listingglobalsearch.html";
        }
        SWListingGlobalSearch.$inject = ['utilityService'];
        return SWListingGlobalSearch;
    })();
    slatwalladmin.SWListingGlobalSearch = SWListingGlobalSearch;
    angular.module('slatwalladmin').directive('swListingGlobalSearch', ['utilityService', 'partialsPath', function (utilityService, partialsPath) { return new SWListingGlobalSearch(utilityService, partialsPath); }]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/common/swlistingglobalsearch.js.map