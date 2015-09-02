/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class SWListingDisplayController {
        constructor($slatwall) {
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
                this.collectionPromise.then((data) => {
                    this.collectionConfig = data.collectionConfig;
                    this.collection = data.pageRecords;
                    this.collectionID = data.collectionID;
                    this.collectionObject = data.collectionObject;
                    //prepare an exampleEntity for use
                    this.exampleEntity = this.$slatwall.newEntity(this.collectionObject);
                });
            }
            else {
            }
            if (angular.isDefined(this.exportAction)) {
                exportAction = "/?slatAction=main.collectionExport&collectionExportID=";
            }
        }
        getExportAction() {
            return this.exportAction + this.collectionID;
        }
    }
    slatwalladmin.SWListingDisplayController = SWListingDisplayController;
    class SWListingDisplay {
        constructor($slatwall, partialsPath) {
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
            this.link = (scope, element, attrs) => {
            };
            this.templateUrl = partialsPath + 'listingdisplay.html';
        }
    }
    slatwalladmin.SWListingDisplay = SWListingDisplay;
    angular.module('slatwalladmin').directive('swListingDisplay', ['$slatwall', 'partialsPath', ($slatwall, partialsPath) => new SWListingDisplay($slatwall, partialsPath)]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/common/swlistingdisplay.js.map