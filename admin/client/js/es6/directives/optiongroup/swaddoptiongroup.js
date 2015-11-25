/// <reference path="../../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../../client/typings/slatwallTypeScript.d.ts" />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class optionWithGroup {
        constructor(optionID, optionGroupID, match) {
            this.optionID = optionID;
            this.optionGroupID = optionGroupID;
            this.match = match;
            this.toString = () => {
                return this.optionID;
            };
        }
    }
    slatwalladmin.optionWithGroup = optionWithGroup;
    class SWAddOptionGroupController {
        constructor($slatwall, $timeout, collectionConfigService, observerService, utilityService) {
            this.$slatwall = $slatwall;
            this.$timeout = $timeout;
            this.collectionConfigService = collectionConfigService;
            this.observerService = observerService;
            this.utilityService = utilityService;
            this.getOptionList = () => {
                return this.utilityService.arrayToList(this.selection);
            };
            this.validateOptions = (args) => {
                this.addToSelection(args[0], args[1].optionGroupID);
                if (this.hasCompleteSelection()) {
                    if (this.validateSelection()) {
                        this.selectedOptionList = this.getOptionList();
                        this.showValidFlag = true;
                        this.showInvalidFlag = false;
                    }
                    else {
                        this.showValidFlag = false;
                        this.showInvalidFlag = true;
                    }
                }
            };
            this.validateSelection = () => {
                var valid = true;
                angular.forEach(this.usedOptions, (combination) => {
                    if (valid) {
                        var counter = 0;
                        angular.forEach(combination, (usedOption) => {
                            if (this.selection[counter].optionGroupID === usedOption.optionGroup_optionGroupID
                                && this.selection[counter].optionID != usedOption.optionID) {
                                this.selection[counter].match = true;
                            }
                            counter++;
                        });
                        if (!this.allSelectionFieldsValidForThisCombination()) {
                            valid = false;
                        }
                    }
                });
                return valid;
            };
            this.allSelectionFieldsValidForThisCombination = () => {
                var matches = 0;
                angular.forEach(this.selection, (pair) => {
                    if (!pair.match) {
                        matches++;
                    }
                    //reset 
                    pair.match = false;
                });
                return matches != this.selection.length;
            };
            this.hasCompleteSelection = () => {
                var answer = true;
                angular.forEach(this.selection, (pair) => {
                    if (pair.optionID.length === 0) {
                        answer = false;
                    }
                });
                return answer;
            };
            this.addToSelection = (optionId, optionGroupId) => {
                angular.forEach(this.selection, (pair) => {
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
            this.productCollectionConfig.getEntity(this.productId).then((response) => {
                this.product = response;
                this.productTypeID = response.productType_productTypeID;
                this.skuCollectionConfig = collectionConfigService.newCollectionConfig("Sku");
                this.skuCollectionConfig.setDisplayProperties("skuID, skuCode, product.productID");
                this.skuCollectionConfig.addFilter("product.productID", this.productId);
                this.skuCollectionConfig.setAllRecords(true);
                this.usedOptions = [];
                this.skuCollectionConfig.getEntity().then((response) => {
                    this.skus = response.records;
                    angular.forEach(this.skus, (sku) => {
                        var optionCollectionConfig = collectionConfigService.newCollectionConfig("Option");
                        optionCollectionConfig.setDisplayProperties("optionID, optionName, optionCode, optionGroup.optionGroupID");
                        optionCollectionConfig.setAllRecords(true);
                        optionCollectionConfig.addFilter("skus.skuID", sku.skuID);
                        optionCollectionConfig.getEntity().then((response) => {
                            this.usedOptions.push(utilityService.arraySorter(response.records, ["optionGroup_optionGroupID"]));
                        });
                    });
                });
            });
            this.observerService.attach(this.validateOptions, "validateOptions");
        }
    }
    SWAddOptionGroupController.$inject = ["$slatwall", "$timeout", "collectionConfigService", "observerService", "utilityService"];
    slatwalladmin.SWAddOptionGroupController = SWAddOptionGroupController;
    class SWAddOptionGroup {
        constructor($slatwall, $timeout, collectionConfigService, observerService, partialsPath) {
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
            this.link = ($scope, element, attrs) => {
            };
            this.templateUrl = partialsPath + "entity/OptionGroup/addoptiongroup.html";
        }
    }
    SWAddOptionGroup.$inject = ["$slatwall", "$timeout", "collectionConfigService", "observerService", "partialsPath"];
    slatwalladmin.SWAddOptionGroup = SWAddOptionGroup;
    angular.module('slatwalladmin').directive('swAddOptionGroup', ["$slatwall", "$timeout", "collectionConfigService", "observerService", "partialsPath",
            ($slatwall, $timeout, collectionConfigService, observerService, partialsPath) => new SWAddOptionGroup($slatwall, $timeout, collectionConfigService, observerService, partialsPath)]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=swaddoptiongroup.js.map
