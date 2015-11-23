/// <reference path="../../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../../client/typings/slatwallTypeScript.d.ts" />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class SWTypeaheadSearchController {
        constructor($slatwall, $timeout, collectionConfigService) {
            this.$slatwall = $slatwall;
            this.$timeout = $timeout;
            this.collectionConfigService = collectionConfigService;
            this.search = (search) => {
                if (angular.isDefined(this.modelBind)) {
                    this.modelBind = search;
                }
                if (search.length > 2) {
                    if (this._timeoutPromise) {
                        this.$timeout.cancel(this._timeoutPromise);
                    }
                    this._timeoutPromise = this.$timeout(() => {
                        if (this.hideSearch) {
                            this.hideSearch = false;
                        }
                        this.results = new Array();
                        this.typeaheadCollectionConfig.setKeywords(search);
                        if (angular.isDefined(this.filterGroupsConfig)) {
                            //allows for filtering on search text
                            var filterConfig = this.filterGroupsConfig.replace("replaceWithSearchString", search);
                            filterConfig = filterConfig.trim();
                            this.typeaheadCollectionConfig.loadFilterGroups(JSON.parse(filterConfig));
                        }
                        var promise = this.typeaheadCollectionConfig.getEntity();
                        promise.then((response) => {
                            if (angular.isDefined(this.allRecords) && this.allRecords == false) {
                                this.results = response.pageRecords;
                            }
                            else {
                                this.results = response.records;
                            }
                            //Custom method for gravatar on accounts (non-persistant-property)
                            if (angular.isDefined(this.results) && this.entity == "Account") {
                                angular.forEach(this.results, (account) => {
                                    account.gravatar = "http://www.gravatar.com/avatar/" + md5(account.primaryEmailAddress_emailAddress.toLowerCase().trim());
                                });
                            }
                        });
                    }, 500);
                }
                else {
                    this.results = [];
                    this.hideSearch = true;
                }
            };
            this.addItem = (item) => {
                if (!this.hideSearch) {
                    this.hideSearch = true;
                }
                if (angular.isDefined(this.displayList)) {
                    this.searchText = item[this.displayList[0]];
                }
                if (angular.isDefined(this.addFunction)) {
                    this.addFunction({ item: item });
                }
            };
            this.addButtonItem = () => {
                if (!this.hideSearch) {
                    this.hideSearch = true;
                }
                if (angular.isDefined(this.modelBind)) {
                    this.searchText = this.modelBind;
                }
                else {
                    this.searchText = "";
                }
                if (angular.isDefined(this.addButtonFunction)) {
                    this.addButtonFunction({ searchString: this.searchText });
                }
            };
            this.closeThis = (clickOutsideArgs) => {
                this.hideSearch = true;
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
    }
    SWTypeaheadSearchController.$inject = ["$slatwall", "$timeout", "collectionConfigService"];
    slatwalladmin.SWTypeaheadSearchController = SWTypeaheadSearchController;
    class SWTypeaheadSearch {
        constructor($slatwall, $timeout, collectionConfigService, partialsPath) {
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
            this.link = ($scope, element, attrs) => {
            };
            this.templateUrl = partialsPath + "typeaheadsearch.html";
        }
    }
    SWTypeaheadSearch.$inject = ["$slatwall", "$timeout", "collectionConfigService", "partialsPath"];
    slatwalladmin.SWTypeaheadSearch = SWTypeaheadSearch;
    angular.module('slatwalladmin').directive('swTypeaheadSearch', ["$slatwall", "$timeout", "collectionConfigService", "partialsPath",
            ($slatwall, $timeout, collectionConfigService, partialsPath) => new SWTypeaheadSearch($slatwall, $timeout, collectionConfigService, partialsPath)]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/common/swtypeaheadsearch.js.map