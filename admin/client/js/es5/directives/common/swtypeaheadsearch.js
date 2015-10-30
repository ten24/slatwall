/// <reference path="../../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../../client/typings/slatwallTypeScript.d.ts" />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var SWTypeaheadSearchController = (function () {
        function SWTypeaheadSearchController($slatwall, $timeout, collectionConfigService) {
            var _this = this;
            this.$slatwall = $slatwall;
            this.$timeout = $timeout;
            this.collectionConfigService = collectionConfigService;
            this.search = function (search) {
                if (angular.isDefined(_this.modelBind)) {
                    _this.modelBind = search;
                }
                if (search.length > 2) {
                    if (_this._timeoutPromise) {
                        _this.$timeout.cancel(_this._timeoutPromise);
                    }
                    _this._timeoutPromise = _this.$timeout(function () {
                        if (_this.hideSearch) {
                            _this.hideSearch = false;
                        }
                        _this.results = new Array();
                        _this.typeaheadCollectionConfig.setKeywords(search);
                        if (angular.isDefined(_this.filterGroupsConfig)) {
                            //allows for filtering on search text
                            var filterConfig = _this.filterGroupsConfig.replace("replaceWithSearchString", search);
                            filterConfig = filterConfig.trim();
                            _this.typeaheadCollectionConfig.loadFilterGroups(JSON.parse(filterConfig));
                        }
                        var promise = _this.typeaheadCollectionConfig.getEntity();
                        promise.then(function (response) {
                            if (angular.isDefined(_this.allRecords) && _this.allRecords == false) {
                                _this.results = response.pageRecords;
                            }
                            else {
                                _this.results = response.records;
                            }
                            //Custom method for gravatar on accounts (non-persistant-property)
                            if (angular.isDefined(_this.results) && _this.entity == "Account") {
                                angular.forEach(_this.results, function (account) {
                                    account.gravatar = "http://www.gravatar.com/avatar/" + md5(account.primaryEmailAddress_emailAddress.toLowerCase().trim());
                                });
                            }
                        });
                    }, 500);
                }
                else {
                    _this.results = [];
                    _this.hideSearch = true;
                }
            };
            this.addItem = function (item) {
                if (!_this.hideSearch) {
                    _this.hideSearch = true;
                }
                if (angular.isDefined(_this.displayList)) {
                    _this.searchText = item[_this.displayList[0]];
                }
                if (angular.isDefined(_this.addFunction)) {
                    _this.addFunction({ item: item });
                }
            };
            this.addButtonItem = function () {
                if (!_this.hideSearch) {
                    _this.hideSearch = true;
                }
                if (angular.isDefined(_this.modelBind)) {
                    _this.searchText = _this.modelBind;
                }
                else {
                    _this.searchText = "";
                }
                if (angular.isDefined(_this.addButtonFunction)) {
                    _this.addButtonFunction({ searchString: _this.searchText });
                }
            };
            this.closeThis = function (clickOutsideArgs) {
                _this.hideSearch = true;
                if (angular.isDefined(clickOutsideArgs)) {
                    for (var callBackAction in clickOutsideArgs.callBackActions) {
                        clickOutsideArgs.callBackActions[callBackAction]();
                    }
                }
            };
            this.typeaheadCollectionConfig = collectionConfigService.newCollectionConfig(this.entity);
            this.typeaheadCollectionConfig.setDisplayProperties(this.properties);
            if (angular.isDefined(this.propertiesToDisplay)) {
                this.displayList = this.propertiesToDisplay.split(",");
            }
            if (angular.isDefined(this.allRecords)) {
                this.typeaheadCollectionConfig.setAllRecords(this.allRecords);
            }
            else {
                this.typeaheadCollectionConfig.setAllRecords(true);
            }
        }
        SWTypeaheadSearchController.$inject = ["$slatwall", "$timeout", "collectionConfigService"];
        return SWTypeaheadSearchController;
    })();
    slatwalladmin.SWTypeaheadSearchController = SWTypeaheadSearchController;
    var SWTypeaheadSearch = (function () {
        function SWTypeaheadSearch($slatwall, $timeout, collectionConfigService, partialsPath) {
            this.$slatwall = $slatwall;
            this.$timeout = $timeout;
            this.collectionConfigService = collectionConfigService;
            this.partialsPath = partialsPath;
            this.restrict = "EA";
            this.scope = {};
            this.bindToController = {
                entity: "@",
                properties: "@",
                propertiesToDisplay: "@?",
                filterGroupsConfig: "@?",
                placeholderText: "@?",
                searchText: "=?",
                results: "=?",
                addFunction: "&?",
                addButtonFunction: "&?",
                hideSearch: "=",
                modelBind: "=?",
                clickOutsideArgs: "@"
            };
            this.controller = SWTypeaheadSearchController;
            this.controllerAs = "swTypeaheadSearch";
            this.link = function ($scope, element, attrs) {
            };
            this.templateUrl = partialsPath + "typeaheadsearch.html";
        }
        SWTypeaheadSearch.$inject = ["$slatwall", "$timeout", "collectionConfigService", "partialsPath"];
        return SWTypeaheadSearch;
    })();
    slatwalladmin.SWTypeaheadSearch = SWTypeaheadSearch;
    angular.module('slatwalladmin').directive('swTypeaheadSearch', ["$slatwall", "$timeout", "collectionConfigService", "partialsPath",
        function ($slatwall, $timeout, collectionConfigService, partialsPath) {
            return new SWTypeaheadSearch($slatwall, $timeout, collectionConfigService, partialsPath);
        }]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/common/swtypeaheadsearch.js.map