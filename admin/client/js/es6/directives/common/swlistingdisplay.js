/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class SWListingDisplayController {
        constructor($scope, $element, $transclude, $slatwall, partialsPath, utilityService, collectionConfigService, paginationService) {
            this.$scope = $scope;
            this.$element = $element;
            this.$transclude = $transclude;
            this.$slatwall = $slatwall;
            this.partialsPath = partialsPath;
            this.utilityService = utilityService;
            this.collectionConfigService = collectionConfigService;
            this.paginationService = paginationService;
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
            this.getCollection = () => {
                this.collectionConfig.setPageShow(this.paginator.getPageShow());
                this.collectionConfig.setCurrentPage(this.paginator.getCurrentPage());
                this.collectionConfig.setKeywords(this.paginator.keywords);
                this.collectionPromise = this.collectionConfig.getEntity();
                this.collectionPromise.then((data) => {
                    this.collectionData = data;
                    this.collectionData.pageRecords = this.collectionData.pageRecords || this.collectionData.records;
                    this.paginator.setPageRecordsInfo(this.collectionData);
                    //prepare an exampleEntity for use
                    this.init();
                });
                return this.collectionPromise;
            };
            this.escapeRegExp = (str) => {
                return str.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1");
            };
            this.replaceAll = (str, find, replace) => {
                return str.replace(new RegExp(this.escapeRegExp(find), 'g'), replace);
            };
            this.getPageRecordKey = (propertyIdentifier) => {
                if (propertyIdentifier) {
                    var propertyIdentifierWithoutAlias = '';
                    if (propertyIdentifier.indexOf('_') === 0) {
                        propertyIdentifierWithoutAlias = propertyIdentifier.substring(propertyIdentifier.indexOf('.') + 1, propertyIdentifier.length);
                    }
                    else {
                        propertyIdentifierWithoutAlias = propertyIdentifier;
                    }
                    return this.replaceAll(propertyIdentifierWithoutAlias, '.', '_');
                }
                return '';
            };
            this.init = () => {
                //set defaults if value is not specified
                //this.edit = this.edit || $location.edit
                this.processObjectProperties = this.processObjectProperties || '';
                this.recordProcessButtonDisplayFlag = this.recordProcessButtonDisplayFlag || true;
                this.collectionConfig = this.collectionConfig || this.collectionData.collectionConfig;
                this.collectionID = this.collectionData.collectionID;
                this.collectionObject = this.collectionData.collectionObject;
                this.norecordstext = this.$slatwall.getRBKey('entity.' + this.collectionObject + '.norecords');
                //Setup Sortability
                if (this.sortProperty && this.sortProperty.length) {
                }
                //Setup the admin meta info
                this.administrativeCount = 0;
                //Detail
                if (this.recordDetailAction && this.recordDetailAction.length) {
                    this.administrativeCount++;
                    this.adminattributes = this.getAdminAttributesByType('detail');
                }
                //Edit
                if (this.recordEditAction && this.recordEditAction.length) {
                    this.administrativeCount++;
                    this.adminattributes = this.getAdminAttributesByType('edit');
                }
                //Delete
                if (this.recordDeleteAction && this.recordDeleteAction.length) {
                    this.administrativeCount++;
                    this.adminattributes = this.getAdminAttributesByType('delete');
                }
                //Process
                if (this.recordProcessAction && this.recordProcessAction.length && this.recordProcessButtonDisplayFlag) {
                    this.administrativeCount++;
                    this.tableattributes = this.utilityService.listAppend(this.tableattributes, 'data-processcontext="' + this.recordProcessContext + '"', " ");
                    this.tableattributes = this.utilityService.listAppend(this.tableattributes, 'data-processentity="' + this.recordProcessEntity.getClassName() + '"', " ");
                    this.tableattributes = this.utilityService.listAppend(this.tableattributes, 'data-processentityid="' + this.recordProcessEntity.getPrimaryIDValue() + '"', " ");
                    this.adminattributes = this.utilityService.listAppend(this.adminattributes, 'data-processaction="' + this.recordProcessAction + '"', " ");
                    this.adminattributes = this.utilityService.listAppend(this.adminattributes, 'data-processcontext="' + this.recordProcessContext + '"', " ");
                    this.adminattributes = this.utilityService.listAppend(this.adminattributes, 'data-processquerystring="' + this.recordProcessQueryString + '"', " ");
                    this.adminattributes = this.utilityService.listAppend(this.adminattributes, 'data-processupdatetableid="' + this.recordProcessUpdateTableID + '"', " ");
                }
                //Setup the primary representation column if no columns were passed in
                /*
                <cfif not arrayLen(thistag.columns)>
                    <cfset arrayAppend(thistag.columns, {
                        propertyIdentifier = thistag.exampleentity.getSimpleRepresentationPropertyName(),
                        title = "",
                        tdclass="primary",
                        search = true,
                        sort = true,
                        filter = false,
                        range = false,
                        editable = false,
                        buttonGroup = true
                    }) />
                </cfif>
                */
                //Setup the list of all property identifiers to be used later
                angular.forEach(this.columns, (column) => {
                    //If this is a standard propertyIdentifier
                    if (column.propertyIdentifier) {
                        //Add to the all property identifiers
                        this.allpropertyidentifiers = this.utilityService.listAppend(this.allpropertyidentifiers, column.propertyIdentifier);
                        //Check to see if we need to setup the dynamic filters, etc
                        //<cfif not len(column.search) || not len(column.sort) || not len(column.filter) || not len(column.range)>
                        if (!column.searchable || !!column.searchable.length || !column.sort || !column.sort.length) {
                            //Get the entity object to get property metaData
                            var thisEntityName = this.$slatwall.getLastEntityNameInPropertyIdentifier(this.exampleEntity.metaData.className, column.propertyIdentifier);
                            var thisPropertyName = this.utilityService.listLast(column.propertyIdentifier, '.');
                            var thisPropertyMeta = this.$slatwall.getPropertyByEntityNameAndPropertyName(thisEntityName, thisPropertyName);
                        }
                    }
                    else if (column.processObjectProperty) {
                        column.searchable = false;
                        column.sort = false;
                        /*
                        <cfset column.filter = false />
                        <cfset column.range = false />
                        */
                        this.allprocessobjectproperties = this.utilityService.listAppend(this.allprocessobjectproperties, column.processObjectProperty);
                    }
                    if (column.tdclass) {
                        var tdclassArray = column.tdclass.split(' ');
                        if (tdclassArray.indexOf("primary") >= 0 && this.expandable) {
                            this.tableattributes = this.utilityService.listAppend(this.tableattributes, 'data-expandsortproperty=' + column.propertyIdentifier, " ");
                            column.sort = false;
                        }
                    }
                });
                //Setup a variable for the number of columns so that the none can have a proper colspan
                this.columnCount = this.columns.length;
                if (this.selectable) {
                    this.columnCount++;
                }
                if (this.multiselectable) {
                    this.columnCount++;
                }
                if (this.sortable) {
                    this.columnCount++;
                }
                if (this.administrativeCount) {
                    this.administrativeCount++;
                }
            };
            this.getAdminAttributesByType = (type) => {
                var recordActionName = 'record' + type.toUpperCase() + 'Action';
                var recordActionPropertyName = recordActionName + 'Property';
                var recordActionQueryStringName = recordActionName + 'QueryString';
                var recordActionModalName = recordActionName + 'Modal';
                this.adminattributes = this.utilityService.listAppend(this.adminattributes, 'data-' + type + 'action="' + this[recordActionName] + '"', " ");
                if (this[recordActionPropertyName] && this[recordActionPropertyName].length) {
                    this.adminattributes = this.utiltyService.listAppend(this.adminattribtues, 'data-' + type + 'actionproperty="' + this[recordActionPropertyName] + '"', " ");
                }
                this.adminattributes = this.utilityService.listAppend(this.adminattributes, 'data-' + type + 'querystring="' + this[recordActionQueryStringName] + '"', " ");
                this.adminattributes = this.utilityService.listAppend(this.adminattributes, 'data-' + type + 'modal="' + this[recordActionModalName] + '"', " ");
            };
            this.getExportAction = () => {
                return this.exportAction + this.collectionID;
            };
            this.$slatwall = $slatwall;
            this.partialsPath = partialsPath;
            this.utilityService = utilityService;
            this.$scope = $scope;
            this.$element = $element;
            this.collectionConfigService = collectionConfigService;
            this.paginationService = paginationService;
            //this is performed early to populate columns with swlistingcolumn info
            this.$transclude = $transclude;
            this.$transclude(this.$scope, () => { });
            this.paginator = paginationService.createPagination();
            this.paginator.getCollection = this.getCollection;
            this.tableID = 'LD' + this.utilityService.createID();
            //if collection Value is string instead of an object then create a collection
            if (angular.isString(this.collection)) {
                this.collectionConfig = this.collectionConfigService.newCollectionConfig(this.collection);
                if (!this.collectionConfig.columns) {
                    this.collectionConfig.columns = [];
                }
                angular.forEach(this.columns, (column) => {
                    var lastEntity = this.$slatwall.getLastEntityNameInPropertyIdentifier(this.collection, column.propertyIdentifier);
                    column.title = this.$slatwall.getRBKey('entity.' + lastEntity.toLowerCase() + '.' + this.utilityService.listLast(column.propertyIdentifier, '.'));
                    column.isVisible = column.isVisible || true;
                    this.collectionConfig.columns.push(column);
                });
                this.collectionConfig.setPageShow(this.paginator.pageShow);
                this.collectionConfig.setCurrentPage(this.paginator.currentPage);
                this.exampleEntity = this.$slatwall.newEntity(this.collection);
                var primarycolumn = {
                    propertyIdentifier: this.exampleEntity.$$getIDName(),
                    isVisible: false
                };
                this.collectionConfig.columns.push(primarycolumn);
            }
            //setup export action
            if (angular.isDefined(this.exportAction)) {
                this.exportAction = "/?slatAction=main.collectionExport&collectionExportID=";
            }
            //Setup table class
            this.tableclass = this.tableclass || '';
            this.tableclass = this.utilityService.listPrepend(this.tableclass, 'table table-bordered table-hover', ' ');
            //Setup Select
            if (this.selectFieldName && this.selectFieldName.length) {
                this.selectable = true;
                this.tableclass = this.utilityService.listAppend(this.tableclass, 'table-select', ' ');
                this.tableattributes = this.utilityService.listAppend(this.tableattributes, 'data-selectfield="' + this.selectFieldName + '"', ' ');
            }
            //Setup MultiSelect
            if (this.multiselectFieldName && this.multiselectFieldName.length) {
                this.multiselectable = true;
                this.tableclass = this.utilityService.listAppend(this.tableclass, 'table-multiselect', ' ');
                this.tableattributes = this.utilityService.listAppend(this.tableattributes, 'data-multiselectpropertyidentifier="' + this.multiselectPropertyIdentifier + '"', ' ');
            }
            if (this.multiselectable && !this.columns.length) {
                //check if it has an active flag and if so then add the active flag
                if (this.exampleEntity.metaData.activeProperty) {
                    this.collectionConfig.addFilter('activeFlag', 1);
                }
            }
            //Look for Hierarchy in example entity
            if (!this.parentPropertyName || (this.parentPropertyName && !this.parentProopertyName.length)) {
                if (this.exampleEntity.metaData.hb_parentPropertyName) {
                    this.parentPropertyName = this.exampleEntity.metaData.hb_parentPropertyName;
                }
            }
            //Setup Hierachy Expandable
            if (this.parentPropertyName && this.parentPropertyName.length) {
                this.expandable = true;
                this.tableclass = this.utilityService.listAppend(this.tableclass, 'table-expandable', ' ');
                this.collectionConfig.addFilter(this.parentPropertyName + '.' + this.exampleEntity.$$getIDName(), 'NULL', 'IS');
                this.allpropertyidentifiers = this.utilityService.listAppend(this.allpropertyidentifiers, this.exampleEntity.$$getIDName() + 'Path');
                this.tableattributes = this.utilityService.listAppend(this.tableattributes, 'data-parentidproperty=' + this.parentPropertyname + '.' + this.exampleEntity.$$getIDName(), ' ');
                this.collectionConfig.setAllRecords(true);
            }
            if (!this.edit
                && this.multiselectable
                && (!this.parentPropertyName || !!this.parentPropertyName.length)
                && (this.multiselectPropertyIdentifier && this.multiselectPropertyIdentifier.length)) {
                if (this.multiselectValues && this.multiselectValues.length) {
                    this.collectionConfig.addFilter(this.multiselectPropertyIdentifier, this.multiselectValues, 'IN');
                }
                else {
                    this.collectionConfig.addFilter(this.multiselectPropertyIdentifier, '_', 'IN');
                }
            }
            this.getCollection();
        }
    }
    SWListingDisplayController.$inject = ['$scope', '$element', '$transclude', '$slatwall', 'partialsPath', 'utilityService', 'collectionConfigService', 'paginationService'];
    slatwalladmin.SWListingDisplayController = SWListingDisplayController;
    class SWListingDisplay {
        constructor(partialsPath) {
            this.partialsPath = partialsPath;
            this.restrict = 'E';
            this.scope = {};
            this.transclude = true;
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
                recordEditAction: "@",
                recordEditActionProperty: "@",
                recordEditQueryString: "@",
                recordEditModal: "=",
                recordEditDisabled: "=",
                recordDetailAction: "@",
                recordDetailActionProperty: "@",
                recordDetailQueryString: "@",
                recordDetailModal: "=",
                recordDeleteAction: "@",
                recordDeleteActionProperty: "@",
                recordDeleteQueryString: "@",
                recordProcessAction: "@",
                recordProcessActionProperty: "@",
                recordProcessQueryString: "@",
                recordProcessContext: "@",
                recordProcessEntity: "=",
                recordProcessUpdateTableID: "=",
                recordProcessButtonDisplayFlag: "=",
                /*Hierachy Expandable*/
                parentPropertyName: "@",
                /*Sorting*/
                sortProperty: "@",
                sortContextIDColumn: "@",
                sortContextIDValue: "@",
                /*Single Select*/
                selectFiledName: "@",
                selectValue: "@",
                selectTitle: "@",
                /*Multiselect*/
                multiselectFieldName: "@",
                multiselectPropertyIdentifier: "@",
                multiselectValues: "@",
                /*Helper / Additional / Custom*/
                tableattributes: "@",
                tableclass: "@",
                adminattributes: "@",
                /* Settings */
                showheader: "=",
                /* Basic Action Caller Overrides*/
                createModal: "=",
                createAction: "@",
                createQueryString: "@",
                exportAction: "@"
            };
            this.controller = SWListingDisplayController;
            this.controllerAs = "swListingDisplay";
            this.link = (scope, element, attrs, controller, transclude) => {
            };
            this.partialsPath = partialsPath;
            this.templateUrl = this.partialsPath + 'listingdisplay.html';
        }
    }
    SWListingDisplay.$inject = ['partialsPath'];
    slatwalladmin.SWListingDisplay = SWListingDisplay;
    angular.module('slatwalladmin').directive('swListingDisplay', ['partialsPath', (partialsPath) => new SWListingDisplay(partialsPath)]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/common/swlistingdisplay.js.map