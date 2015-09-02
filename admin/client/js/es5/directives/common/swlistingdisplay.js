/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var SWListingDisplayController = (function () {
        function SWListingDisplayController($slatwall) {
            var _this = this;
            this.$slatwall = $slatwall;
            /* local state variables */
            this.columns = [];
            this.allpropertyidentifiers = "";
            this.allprocessobjectproperties = "false";
            this.selectable = false;
            this.multiselectable = false;
            this.expandable = false;
            this.sortable = false;
            this.exampleEntity = "";
            this.buttonGroup = [];
            console.log('listingDisplayTest');
            console.log(this);
            //if collection Value is string instead of an object then create a collection
            if (angular.isString(this.collection)) {
                this.collectionPromise = this.$slatwall.getEntity(this.collection);
                this.collectionPromise.then(function (data) {
                    _this.collectionConfig = data.collectionConfig;
                    _this.collection = data.pageRecords;
                    _this.collectionID = data.collectionID;
                    _this.collectionObject = data.collectionObject;
                    //prepare an exampleEntity for use
                    _this.exampleEntity = _this.$slatwall.newEntity(_this.collectionObject);
                });
            }
            else {
            }
            if (angular.isDefined(this.exportAction)) {
                exportAction = "/?slatAction=main.collectionExport&collectionExportID=";
            }
        }
        SWListingDisplayController.prototype.getExportAction = function () {
            return this.exportAction + this.collectionID;
        };
        return SWListingDisplayController;
    })();
    slatwalladmin.SWListingDisplayController = SWListingDisplayController;
    var SWListingDisplay = (function () {
        function SWListingDisplay($slatwall, partialsPath) {
            this.$slatwall = $slatwall;
            this.partialsPath = partialsPath;
            this.restrict = 'E';
            this.scope = {};
            this.bindToController = {
                isRadio: "=",
                //angularLink:true || false
                angularLinks: "=",
                /*required*/
                collection: "=",
                collectionConfig: "=",
                edit: "=",
                /*Optional*/
                title: "@",
                /*Admin Actions*/
                recordEditAction: "=",
                recordEditActionProperty: "=",
                recordEditQueryString: "=",
                recordEditModal: "=",
                recordEditDisabled: "=",
                recordDetailAction: "=",
                recordDetailActionProperty: "=",
                recordDetailModal: "=",
                recordDeleteAction: "=",
                recordDeleteActionProperty: "=",
                recordDeleteQueryString: "=",
                recordProcessAction: "=",
                recordProcessActionProperty: "=",
                recordProcessQueryString: "=",
                recordProcessContext: "=",
                recordProcessEntity: "=",
                recordProcessUpdateTableID: "=",
                recordProcessButtonDisplayFlag: "=",
                /*Hierachy Expandable*/
                parentPropertyName: "=",
                /*Sorting*/
                sortProperty: "=",
                sortContextIDColumn: "=",
                sortContextIDValue: "=",
                /*Single Select*/
                selectFiledName: "=",
                selectValue: "=",
                selectTitle: "=",
                /*Multiselect*/
                multiselectFieldName: "=",
                multiselectPropertyIdentifier: "=",
                multiselectValues: "=",
                /*Helper / Additional / Custom*/
                tableattributes: "=",
                tableclass: "=",
                adminattributes: "=",
                /* Settings */
                showheader: "=",
                /* Basic Action Caller Overrides*/
                createModal: "=",
                createAction: "=",
                createQueryString: "=",
                exportAction: "="
            };
            this.controller = SWListingDisplayController;
            this.controllerAs = "swListingDisplay";
            this.link = function (scope, element, attrs) {
            };
            this.templateUrl = partialsPath + 'listingdisplay.html';
        }
        return SWListingDisplay;
    })();
    slatwalladmin.SWListingDisplay = SWListingDisplay;
    angular.module('slatwalladmin').directive('swListingDisplay', ['$slatwall', 'partialsPath', function ($slatwall, partialsPath) { return new SWListingDisplay($slatwall, partialsPath); }]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/common/swlistingdisplay.js.map