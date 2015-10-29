/// <reference path="../../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../../client/typings/slatwallTypeScript.d.ts" />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var optionWithGroup = (function () {
        function optionWithGroup(optionID, optionGroupID, match) {
            var _this = this;
            this.optionID = optionID;
            this.optionGroupID = optionGroupID;
            this.match = match;
            this.toString = function () {
                return _this.optionID;
            };
        }
        return optionWithGroup;
    })();
    slatwalladmin.optionWithGroup = optionWithGroup;
    var SWAddOptionGroupController = (function () {
        function SWAddOptionGroupController($slatwall, $timeout, collectionConfigService, observerService, utilityService) {
            var _this = this;
            this.$slatwall = $slatwall;
            this.$timeout = $timeout;
            this.collectionConfigService = collectionConfigService;
            this.observerService = observerService;
            this.utilityService = utilityService;
            this.getOptionList = function () {
                return _this.utilityService.arrayToList(_this.selection);
            };
            this.validateOptions = function (args) {
                _this.addToSelection(args[0], args[1].optionGroupID);
                if (_this.hasCompleteSelection()) {
                    if (_this.validateSelection()) {
                        _this.selectedOptionList = _this.getOptionList();
                        _this.showValidFlag = true;
                        _this.showInvalidFlag = false;
                    }
                    else {
                        _this.showValidFlag = false;
                        _this.showInvalidFlag = true;
                    }
                }
            };
            this.validateSelection = function () {
                var valid = true;
                angular.forEach(_this.usedOptions, function (combination) {
                    if (valid) {
                        var counter = 0;
                        angular.forEach(combination, function (usedOption) {
                            if (_this.selection[counter].optionGroupID === usedOption.optionGroup_optionGroupID
                                && _this.selection[counter].optionID != usedOption.optionID) {
                                _this.selection[counter].match = true;
                            }
                            counter++;
                        });
                        if (!_this.allSelectionFieldsValidForThisCombination()) {
                            valid = false;
                        }
                    }
                });
                return valid;
            };
            this.allSelectionFieldsValidForThisCombination = function () {
                var matches = 0;
                angular.forEach(_this.selection, function (pair) {
                    if (!pair.match) {
                        matches++;
                    }
                    //reset 
                    pair.match = false;
                });
                return matches != _this.selection.length;
            };
            this.hasCompleteSelection = function () {
                var answer = true;
                angular.forEach(_this.selection, function (pair) {
                    if (pair.optionID.length === 0) {
                        answer = false;
                    }
                });
                return answer;
            };
            this.addToSelection = function (optionId, optionGroupId) {
                angular.forEach(_this.selection, function (pair) {
                    if (pair.optionGroupID === optionGroupId) {
                        pair.optionID = optionId;
                        return true;
                    }
                });
                return false;
            };
            this.optionGroupIds = this.optionGroups.split(",");
            this.optionGroupIds.sort();
            this.selection = [];
            this.showValidFlag = false;
            this.showInvalidFlag = false;
            for (var i = 0; i < this.optionGroupIds.length; i++) {
                this.selection.push(new optionWithGroup("", this.optionGroupIds[i], false));
            }
            this.productCollectionConfig = collectionConfigService.newCollectionConfig("Product");
            this.productCollectionConfig.setDisplayProperties("productID, productName, productType.productTypeID");
            this.productCollectionConfig.getEntity(this.productId).then(function (response) {
                _this.product = response;
                _this.productTypeID = response.productType_productTypeID;
                _this.skuCollectionConfig = collectionConfigService.newCollectionConfig("Sku");
                _this.skuCollectionConfig.setDisplayProperties("skuID, skuCode, product.productID");
                _this.skuCollectionConfig.addFilter("product.productID", _this.productId);
                _this.skuCollectionConfig.setAllRecords(true);
                _this.usedOptions = [];
                _this.skuCollectionConfig.getEntity().then(function (response) {
                    _this.skus = response.records;
                    angular.forEach(_this.skus, function (sku) {
                        var optionCollectionConfig = collectionConfigService.newCollectionConfig("Option");
                        optionCollectionConfig.setDisplayProperties("optionID, optionName, optionCode, optionGroup.optionGroupID");
                        optionCollectionConfig.setAllRecords(true);
                        optionCollectionConfig.addFilter("skus.skuID", sku.skuID);
                        optionCollectionConfig.getEntity().then(function (response) {
                            _this.usedOptions.push(utilityService.arraySorter(response.records, ["optionGroup_optionGroupID"]));
                        });
                    });
                });
            });
            this.observerService.attach(this.validateOptions, "validateOptions");
        }
        SWAddOptionGroupController.$inject = ["$slatwall", "$timeout", "collectionConfigService", "observerService", "utilityService"];
        return SWAddOptionGroupController;
    })();
    slatwalladmin.SWAddOptionGroupController = SWAddOptionGroupController;
    var SWAddOptionGroup = (function () {
        function SWAddOptionGroup($slatwall, $timeout, collectionConfigService, observerService, partialsPath) {
            this.$slatwall = $slatwall;
            this.$timeout = $timeout;
            this.collectionConfigService = collectionConfigService;
            this.observerService = observerService;
            this.partialsPath = partialsPath;
            this.restrict = "EA";
            this.scope = {};
            this.bindToController = {
                productId: "@",
                optionGroups: "="
            };
            this.controller = SWAddOptionGroupController;
            this.controllerAs = "swAddOptionGroup";
            this.link = function ($scope, element, attrs) {
            };
            this.templateUrl = partialsPath + "entity/OptionGroup/addoptiongroup.html";
        }
        SWAddOptionGroup.$inject = ["$slatwall", "$timeout", "collectionConfigService", "observerService", "partialsPath"];
        return SWAddOptionGroup;
    })();
    slatwalladmin.SWAddOptionGroup = SWAddOptionGroup;
    angular.module('slatwalladmin').directive('swAddOptionGroup', ["$slatwall", "$timeout", "collectionConfigService", "observerService", "partialsPath",
        function ($slatwall, $timeout, collectionConfigService, observerService, partialsPath) {
            return new SWAddOptionGroup($slatwall, $timeout, collectionConfigService, observerService, partialsPath);
        }]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=swaddoptiongroup.js.map
