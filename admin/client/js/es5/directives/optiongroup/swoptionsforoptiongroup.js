/// <reference path="../../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../../client/typings/slatwallTypeScript.d.ts" />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var SWOptionsForOptionGroupController = (function () {
        function SWOptionsForOptionGroupController($slatwall, $timeout, collectionConfigService, observerService) {
            var _this = this;
            this.$slatwall = $slatwall;
            this.$timeout = $timeout;
            this.collectionConfigService = collectionConfigService;
            this.observerService = observerService;
            this.validateChoice = function () {
                _this.observerService.notify("validateOptions", [_this.selectedOption, _this.optionGroup]);
            };
            this.optionGroupCollectionConfig = collectionConfigService.newCollectionConfig("OptionGroup");
            this.optionGroupCollectionConfig.getEntity(this.optionGroupId).then(function (response) {
                _this.optionGroup = response;
            });
            this.optionCollectionConfig = collectionConfigService.newCollectionConfig("Option");
            this.optionCollectionConfig.setDisplayProperties("optionID, optionName, optionGroup.optionGroupID");
            this.optionCollectionConfig.addFilter("optionGroup.optionGroupID", this.optionGroupId);
            this.optionCollectionConfig.setAllRecords(true);
            this.optionCollectionConfig.getEntity().then(function (response) {
                _this.options = response.records;
            });
        }
        SWOptionsForOptionGroupController.$inject = ["$slatwall", "$timeout", "collectionConfigService", "observerService"];
        return SWOptionsForOptionGroupController;
    })();
    slatwalladmin.SWOptionsForOptionGroupController = SWOptionsForOptionGroupController;
    var SWOptionsForOptionGroup = (function () {
        function SWOptionsForOptionGroup($slatwall, $timeout, collectionConfigService, observerService, partialsPath) {
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
            this.link = function ($scope, element, attrs) {
            };
            this.templateUrl = partialsPath + "entity/OptionGroup/optionsforoptiongroup.html";
        }
        SWOptionsForOptionGroup.$inject = ["$slatwall", "$timeout", "collectionConfigService", "observerService", "partialsPath"];
        return SWOptionsForOptionGroup;
    })();
    slatwalladmin.SWOptionsForOptionGroup = SWOptionsForOptionGroup;
    angular.module('slatwalladmin').directive('swOptionsForOptionGroup', ["$slatwall", "$timeout", "collectionConfigService", "observerService", "partialsPath",
        function ($slatwall, $timeout, collectionConfigService, observerService, partialsPath) {
            return new SWOptionsForOptionGroup($slatwall, $timeout, collectionConfigService, observerService, partialsPath);
        }]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=swoptionsforoptiongroup.js.map
