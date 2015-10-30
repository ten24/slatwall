/// <reference path="../../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../../client/typings/slatwallTypeScript.d.ts" />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class SWOptionsForOptionGroupController {
        constructor($slatwall, $timeout, collectionConfigService, observerService) {
            this.$slatwall = $slatwall;
            this.$timeout = $timeout;
            this.collectionConfigService = collectionConfigService;
            this.observerService = observerService;
            this.validateChoice = () => {
                this.observerService.notify("validateOptions", [this.selectedOption, this.optionGroup]);
            };
            this.optionGroupCollectionConfig = collectionConfigService.newCollectionConfig("OptionGroup");
            this.optionGroupCollectionConfig.getEntity(this.optionGroupId).then((response) => {
                this.optionGroup = response;
            });
            this.optionCollectionConfig = collectionConfigService.newCollectionConfig("Option");
            this.optionCollectionConfig.setDisplayProperties("optionID, optionName, optionGroup.optionGroupID");
            this.optionCollectionConfig.addFilter("optionGroup.optionGroupID", this.optionGroupId);
            this.optionCollectionConfig.setAllRecords(true);
            this.optionCollectionConfig.getEntity().then((response) => {
                this.options = response.records;
            });
        }
    }
    SWOptionsForOptionGroupController.$inject = ["$slatwall", "$timeout", "collectionConfigService", "observerService"];
    slatwalladmin.SWOptionsForOptionGroupController = SWOptionsForOptionGroupController;
    class SWOptionsForOptionGroup {
        constructor($slatwall, $timeout, collectionConfigService, observerService, partialsPath) {
            this.$slatwall = $slatwall;
            this.$timeout = $timeout;
            this.collectionConfigService = collectionConfigService;
            this.observerService = observerService;
            this.partialsPath = partialsPath;
            this.restrict = "EA";
            this.scope = {};
            this.bindToController = {
                optionGroupId: "@",
                usedOptions: "="
            };
            this.controller = SWOptionsForOptionGroupController;
            this.controllerAs = "swOptionsForOptionGroup";
            this.link = ($scope, element, attrs) => {
            };
            this.templateUrl = partialsPath + "entity/OptionGroup/optionsforoptiongroup.html";
        }
    }
    SWOptionsForOptionGroup.$inject = ["$slatwall", "$timeout", "collectionConfigService", "observerService", "partialsPath"];
    slatwalladmin.SWOptionsForOptionGroup = SWOptionsForOptionGroup;
    angular.module('slatwalladmin').directive('swOptionsForOptionGroup', ["$slatwall", "$timeout", "collectionConfigService", "observerService", "partialsPath",
            ($slatwall, $timeout, collectionConfigService, observerService, partialsPath) => new SWOptionsForOptionGroup($slatwall, $timeout, collectionConfigService, observerService, partialsPath)]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/optiongroup/swoptionsforoptiongroup.js.map