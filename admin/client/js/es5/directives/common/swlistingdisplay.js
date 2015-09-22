/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var SWListingDisplayController = (function () {
        function SWListingDisplayController($slatwall, partialsPath, utilityService) {
            var _this = this;
            this.$slatwall = $slatwall;
            this.partialsPath = partialsPath;
            this.utilityService = utilityService;
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
            this.init = function () {
                //if collection Value is string instead of an object then create a collection
                if (angular.isString(_this.collection)) {
                    _this.collectionPromise = _this.$slatwall.getEntity(_this.collection);
                    _this.collectionPromise.then(function (data) {
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
                //setup export action
                if (angular.isDefined(_this.exportAction)) {
                    _this.exportAction = "/?slatAction=main.collectionExport&collectionExportID=";
                }
                //Setup table class
                _this.tableclass = _this.tableclass || '';
                _this.tableclass = _this.utilityService.listPrepend(_this.tableclass, 'table table-bordered table-hover', ' ');
                //Setup Select
                if (_this.selectFieldName && _this.selectFieldName.length) {
                    _this.selectable = true;
                    _this.tableclass = _this.utilityService.listAppend(_this.tableclass, 'table-select', ' ');
                    _this.tableattributes = _this.utilityService.listAppend(_this.tableattributes, 'data-selectfield="' + _this.selectFieldName + '"', ' ');
                }
                //Setup MultiSelect
                if (_this.multiselectFieldName && _this.multiselectFieldName.length) {
                    _this.multiselectable = true;
                    _this.tableclass = _this.utilityService.listAppend(_this.tableclass, 'table-multiselect', ' ');
                    _this.tableattributes = _this.utiltiyService.listAppend(_this.tableattributes, 'data-multiselectpropertyidentifier="' + _this.multiselectPropertyIdentifier + '"', ' ');
                }
                if (_this.multiselectable && !_this.columns.length) {
                }
                //Look for Hierarchy in example entity
                /*
                <cfif not len(attributes.parentPropertyName)>
                    <cfset thistag.entityMetaData = getMetaData(thisTag.exampleEntity) />
                    <cfif structKeyExists(thisTag.entityMetaData, "hb_parentPropertyName")>
                        <cfset attributes.parentPropertyName = thisTag.entityMetaData.hb_parentPropertyName />
                    </cfif>
                </cfif>
                */
                //Setup Hierachy Expandable
                /*
                <cfif len(attributes.parentPropertyName) && attributes.parentPropertyName neq 'false'>
                    <cfset thistag.expandable = true />
        
                    <cfset attributes.tableclass = listAppend(attributes.tableclass, 'table-expandable', ' ') />
        
                    <cfset attributes.smartList.joinRelatedProperty( attributes.smartList.getBaseEntityName() , attributes.parentPropertyName, "LEFT") />
                    <cfset attributes.smartList.addFilter("#attributes.parentPropertyName#.#thistag.exampleEntity.getPrimaryIDPropertyName()#", "NULL") />
        
                    <cfset thistag.allpropertyidentifiers = listAppend(thistag.allpropertyidentifiers, "#thisTag.exampleEntity.getPrimaryIDPropertyName()#Path") />
        
                    <cfset attributes.tableattributes = listAppend(attributes.tableattributes, 'data-parentidproperty="#attributes.parentPropertyName#.#thistag.exampleEntity.getPrimaryIDPropertyName()#"', " ") />
        
                    <cfset attributes.smartList.setPageRecordsShow(1000000) />
                </cfif>
                */
                //Setup Sortability
                if (_this.sortProperty && _this.sortProperty.length) {
                }
                //Setup the admin meta info
                _this.administrativeCount = 0;
                //Detail
                if (_this.recordDetailAction && _this.recordDetailAction.length) {
                    _this.administrativeCount++;
                    _this.adminattributes = _this.getAdminAttributesByRecordAction('detail');
                }
                //Edit
                if (_this.recordEditAction && _this.recordEditAction.length) {
                    _this.administrativeCount++;
                    _this.adminattributes = _this.getAdminAttributesByRecordAction('edit');
                }
                //Delete
                if (_this.recordDeleteAction && _this.recordDeleteAction.length) {
                    _this.administrativeCount++;
                    _this.adminattributes = _this.getAdminAttributesByRecordAction('delete');
                }
                //Process
                if (_this.recordProcessAction && _this.recordProcessAction.length && _this.recordProcessButtonDisplayFlag) {
                    _this.administrativeCount++;
                    _this.tableattributes = _this.utilityService.listAppend(_this.tableattributes, 'data-processcontext="' + _this.recordProcessContext + '"', " ");
                    _this.tableattributes = _this.utilityService.listAppend(_this.tableattributes, 'data-processentity="' + _this.recordProcessEntity.getClassName() + '"', " ");
                    _this.tableattributes = _this.utilityService.listAppend(_this.tableattributes, 'data-processentityid="' + _this.recordProcessEntity.getPrimaryIDValue() + '"', " ");
                    _this.adminattributes = _this.utilityService.listAppend(_this.adminattributes, 'data-processaction="' + _this.recordProcessAction + '"', " ");
                    _this.adminattributes = _this.utilityService.listAppend(_this.adminattributes, 'data-processcontext="' + _this.recordProcessContext + '"', " ");
                    _this.adminattributes = _this.utilityService.listAppend(_this.adminattributes, 'data-processquerystring="' + _this.recordProcessQueryString + '"', " ");
                    _this.adminattributes = _this.utilityService.listAppend(_this.adminattributes, 'data-processupdatetableid="' + _this.recordProcessUpdateTableID + '"', " ");
                }
                //Setup the primary representation column if no columns were passed in
                /*
                <cfif not arrayLen(thistag.columns)>
                    <cfset arrayAppend(thistag.columns, {
                        propertyIdentifier = thistag.exampleentity.getSimpleRepresentationPropertyName(),
                        title = "",
                        tdClass="primary",
                        search = true,
                        sort = true,
                        filter = false,
                        range = false,
                        editable = false,
                        buttonGroup = true
                    }) />
                </cfif>
                */
                /*
                <!--- Setup the list of all property identifiers to be used later --->
                <cfloop array="#thistag.columns#" index="column">
        
                    <!--- If this is a standard propertyIdentifier --->
                    <cfif len(column.propertyIdentifier)>
        
                        <!--- Add to the all property identifiers --->
                        <cfset thistag.allpropertyidentifiers = listAppend(thistag.allpropertyidentifiers, column.propertyIdentifier) />
        
                        <!--- Check to see if we need to setup the dynamic filters, ect --->
                        <cfif not len(column.search) || not len(column.sort) || not len(column.filter) || not len(column.range)>
        
                            <!--- Get the entity object to get property metaData --->
                            <cfset thisEntityName = attributes.hibachiScope.getService("hibachiService").getLastEntityNameInPropertyIdentifier( attributes.smartList.getBaseEntityName(), column.propertyIdentifier ) />
                            <cfset thisPropertyName = listLast( column.propertyIdentifier, "." ) />
                            <cfset thisPropertyMeta = attributes.hibachiScope.getService("hibachiService").getPropertyByEntityNameAndPropertyName( thisEntityName, thisPropertyName ) />
        
                            <!--- Setup automatic search, sort, filter & range --->
                            <cfif not len(column.search) && (!structKeyExists(thisPropertyMeta, "persistent") || thisPropertyMeta.persistent) && (!structKeyExists(thisPropertyMeta, "ormType") || thisPropertyMeta.ormType eq 'string')>
                                <cfset column.search = true />
                            <cfelseif !isBoolean(column.search)>
                                <cfset column.search = false />
                            </cfif>
                            <cfif not len(column.sort) && (!structKeyExists(thisPropertyMeta, "persistent") || thisPropertyMeta.persistent)>
                                <cfset column.sort = true />
                            <cfelseif !isBoolean(column.sort)>
                                <cfset column.sort = false />
                            </cfif>
                            <cfif not len(column.filter) && (!structKeyExists(thisPropertyMeta, "persistent") || thisPropertyMeta.persistent)>
                                <cfset column.filter = false />
        
                                <cfif structKeyExists(thisPropertyMeta, "ormtype") && thisPropertyMeta.ormtype eq 'boolean'>
                                    <cfset column.filter = true />
                                </cfif>
                                <!---
                                <cfif !column.filter && listLen(column.propertyIdentifier, '._') gt 1>
        
                                    <cfset oneUpPropertyIdentifier = column.propertyIdentifier />
                                    <cfset oneUpPropertyIdentifier = listDeleteAt(oneUpPropertyIdentifier, listLen(oneUpPropertyIdentifier, '._'), '._') />
                                    <cfset oneUpPropertyName = listLast(oneUpPropertyIdentifier, '.') />
                                    <cfset twoUpEntityName = attributes.hibachiScope.getService("hibachiService").getLastEntityNameInPropertyIdentifier( attributes.smartList.getBaseEntityName(), oneUpPropertyIdentifier ) />
                                    <cfset oneUpPropertyMeta = attributes.hibachiScope.getService("hibachiService").getPropertyByEntityNameAndPropertyName( twoUpEntityName, oneUpPropertyName ) />
                                    <cfif structKeyExists(oneUpPropertyMeta, "fieldtype") && oneUpPropertyMeta.fieldtype eq 'many-to-one' && (!structKeyExists(thisPropertyMeta, "ormtype") || listFindNoCase("boolean,string", thisPropertyMeta.ormtype))>
                                        <cfset column.filter = true />
                                    </cfif>
                                </cfif>
                                --->
                            <cfelseif !isBoolean(column.filter)>
                                <cfset column.filter = false />
                            </cfif>
                            <cfif not len(column.range) && (!structKeyExists(thisPropertyMeta, "persistent") || thisPropertyMeta.persistent) && structKeyExists(thisPropertyMeta, "ormType") && (thisPropertyMeta.ormType eq 'integer' || thisPropertyMeta.ormType eq 'big_decimal' || thisPropertyMeta.ormType eq 'timestamp')>
                                <cfset column.range = true />
                            <cfelseif !isBoolean(column.range)>
                                <cfset column.range = false />
                            </cfif>
                        </cfif>
                    <!--- Otherwise this is a processObject property --->
                    <cfelseif len(column.processObjectProperty)>
                        <cfset column.search = false />
                        <cfset column.sort = false />
                        <cfset column.filter = false />
                        <cfset column.range = false />
        
                        <cfset thistag.allprocessobjectproperties = listAppend(thistag.allprocessobjectproperties, column.processObjectProperty) />
                    </cfif>
                    <cfif findNoCase("primary", column.tdClass) and thistag.expandable>
                        <cfset attributes.tableattributes = listAppend(attributes.tableattributes, 'data-expandsortproperty="#column.propertyIdentifier#"', " ") />
                        <cfset column.sort = false />
                    </cfif>
                </cfloop>
                */
                /*
                <!--- Setup a variable for the number of columns so that the none can have a proper colspan --->
                <cfset thistag.columnCount = arrayLen(thisTag.columns) />
                <cfif thistag.selectable>
                    <cfset thistag.columnCount += 1 />
                </cfif>
                <cfif thistag.multiselectable>
                    <cfset thistag.columnCount += 1 />
                </cfif>
                <cfif thistag.sortable>
                    <cfset thistag.columnCount += 1 />
                </cfif>
                <cfif attributes.administativeCount>
                    <cfset thistag.columnCount += 1 />
                </cfif>
                <cfif attributes.administativeCount>
                </cfif>
                */
            };
            this.getAdminAttributesByType = function (type) {
                var recordActionName = 'record' + type.toUpperCase() + 'Action';
                var recordActionPropertyName = recordActionName + 'Property';
                var recordActionQueryStringName = recordActionName + 'QueryString';
                var recordActionModalName = recordActionName + 'Modal';
                _this.adminattributes = _this.utilityService.listAppend(_this.adminattributes, 'data-' + type + 'action="' + _this[recordActionName] + '"', " ");
                if (_this[recordActionPropertyName] && _this[recordActionPropertyName].length) {
                    _this.adminattributes = _this.utiltyService.listAppend(_this.adminattribtues, 'data-' + type + 'actionproperty="' + _this[recordActionPropertyName] + '"', " ");
                }
                _this.adminattributes = _this.utilityService.listAppend(_this.adminattributes, 'data-' + type + 'querystring="' + _this[recordActionQueryStringName] + '"', " ");
                _this.adminattributes = _this.utilityService.listAppend(_this.adminattributes, 'data-' + type + 'modal="' + _this[recordActionModalName] + '"', " ");
            };
            this.getExportAction = function () {
                return _this.exportAction + _this.collectionID;
            };
            console.log('listingDisplayTest');
            console.log(this);
            this.$slatwall = $slatwall;
            this.partialsPath = partialsPath;
            this.utilityService = utilityService;
            // this.init();
        }
        return SWListingDisplayController;
    })();
    slatwalladmin.SWListingDisplayController = SWListingDisplayController;
    var SWListingDisplay = (function () {
        function SWListingDisplay($slatwall, partialsPath, utilityService) {
            this.$slatwall = $slatwall;
            this.partialsPath = partialsPath;
            this.utilityService = utilityService;
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
            console.log('listingDisplay constructor');
            this.templateUrl = this.partialsPath + 'listingdisplay.html';
        }
        return SWListingDisplay;
    })();
    slatwalladmin.SWListingDisplay = SWListingDisplay;
    angular.module('slatwalladmin').directive('swListingDisplay', ['$slatwall', 'partialsPath', 'utilityService', function ($slatwall, partialsPath, utilityService) { return new SWListingDisplay($slatwall, partialsPath, utilityService); }]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/common/swlistingdisplay.js.map