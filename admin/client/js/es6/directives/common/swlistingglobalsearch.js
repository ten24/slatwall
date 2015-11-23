/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class SWListingGlobalSearchController {
        constructor($timeout) {
            this.$timeout = $timeout;
            this.init = () => {
                this.searching = false;
            };
            this.search = () => {
                if (this.searchText.length >= 2) {
                    this.searching = true;
                    if (this._timeoutPromise) {
                        this.$timeout.cancel(this._timeoutPromise);
                    }
                    this._timeoutPromise = this.$timeout(() => {
                        this.getCollection();
                    }, 500);
                }
                else if (this.searchText.length === 0) {
                    this.$timeout(() => {
                        this.getCollection();
                    });
                }
            };
            this.init();
        }
    }
    SWListingGlobalSearchController.$inject = ['$timeout'];
    slatwalladmin.SWListingGlobalSearchController = SWListingGlobalSearchController;
    class SWListingGlobalSearch {
        constructor(utilityService, partialsPath) {
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
            this.link = (scope, element, attrs) => {
            };
            this.templateUrl = partialsPath + "listingglobalsearch.html";
        }
    }
    SWListingGlobalSearch.$inject = ['utilityService'];
    slatwalladmin.SWListingGlobalSearch = SWListingGlobalSearch;
    angular.module('slatwalladmin').directive('swListingGlobalSearch', ['utilityService', 'partialsPath', (utilityService, partialsPath) => new SWListingGlobalSearch(utilityService, partialsPath)]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/common/swlistingglobalsearch.js.map