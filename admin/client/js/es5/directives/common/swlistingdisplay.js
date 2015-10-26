/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var SWListingDisplayController = (function () {
        function SWListingDisplayController($scope, $element, $transclude, $timeout, $q, $slatwall, partialsPath, utilityService, collectionConfigService, paginationService, selectionService, observerService) {
            var _this = this;
            this.$scope = $scope;
            this.$element = $element;
            this.$transclude = $transclude;
            this.$timeout = $timeout;
            this.$q = $q;
            this.$slatwall = $slatwall;
            this.partialsPath = partialsPath;
            this.utilityService = utilityService;
            this.collectionConfigService = collectionConfigService;
            this.paginationService = paginationService;
            this.selectionService = selectionService;
            this.observerService = observerService;
            /* local state variables */
            this.columns = [];
            this.allpropertyidentifiers = "";
            this.allprocessobjectproperties = "false";
            this.selectable = false;
            this.multiselectable = false;
            this.sortable = false;
            this.exampleEntity = "";
            this.buttonGroup = [];
            this.setupDefaultCollectionInfo = function () {
                if (_this.hasCollectionPromise) {
                    _this.collectionObject = _this.collection.collectionObject;
                    _this.collectionConfig = _this.collectionConfigService.newCollectionConfig(_this.collectionObject);
                    _this.collectionConfig.loadJson(_this.collection.collectionConfig);
                }
                _this.collectionConfig.setPageShow(_this.paginator.getPageShow());
                _this.collectionConfig.setCurrentPage(_this.paginator.getCurrentPage());
                _this.collectionConfig.setKeywords(_this.paginator.keywords);
            };
            this.setupDefaultGetCollection = function () {
                _this.collectionPromise = _this.collectionConfig.getEntity();
                return function () {
                    _this.collectionPromise.then(function (data) {
                    });
                };
            };
            this.initData = function () {
                _this.collectionConfig.setPageShow(_this.paginator.pageShow);
                _this.collectionConfig.setCurrentPage(_this.paginator.currentPage);
                //setup export action
                if (angular.isDefined(_this.exportAction)) {
                    _this.exportAction = "/?slatAction=main.collectionExport&collectionExportID=";
                }
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
                    _this.tableattributes = _this.utilityService.listAppend(_this.tableattributes, 'data-multiselectpropertyidentifier="' + _this.multiselectPropertyIdentifier + '"', ' ');
                    //attach observer so we know when a selection occurs
                    _this.observerService.attach(_this.updateMultiselectValues, 'swSelectionToggleSelection', _this.collectionObject);
                }
                if (_this.multiselectable && !_this.columns.length) {
                    //check if it has an active flag and if so then add the active flag
                    if (_this.exampleEntity.metaData.activeProperty && !_this.hasCollectionPromise) {
                        _this.collectionConfig.addFilter('activeFlag', 1);
                    }
                }
                //Look for Hierarchy in example entity
                if (!_this.parentPropertyName || (_this.parentPropertyName && !_this.parentPropertyName.length)) {
                    if (_this.exampleEntity.metaData.hb_parentPropertyName) {
                        _this.parentPropertyName = _this.exampleEntity.metaData.hb_parentPropertyName;
                    }
                }
                if (!_this.childPropertyName || (_this.childPropertyName && !_this.childPropertyName.length)) {
                    if (_this.exampleEntity.metaData.hb_childPropertyName) {
                        _this.childPropertyName = _this.exampleEntity.metaData.hb_childPropertyName;
                    }
                }
                //Setup Hierachy Expandable
                if (_this.parentPropertyName && _this.parentPropertyName.length) {
                    if (angular.isUndefined(_this.expandable)) {
                        _this.expandable = true;
                    }
                    _this.tableclass = _this.utilityService.listAppend(_this.tableclass, 'table-expandable', ' ');
                    //add parent property root filter
                    if (!_this.hasCollectionPromise) {
                        _this.collectionConfig.addFilter(_this.parentPropertyName + '.' + _this.exampleEntity.$$getIDName(), 'NULL', 'IS');
                    }
                    //add children column
                    if (_this.childPropertyName && _this.childPropertyName.length) {
                        if (_this.getChildCount || !_this.hasCollectionPromise) {
                            _this.collectionConfig.addDisplayAggregate(_this.childPropertyName, 'COUNT', _this.childPropertyName + 'Count');
                        }
                    }
                    _this.allpropertyidentifiers = _this.utilityService.listAppend(_this.allpropertyidentifiers, _this.exampleEntity.$$getIDName() + 'Path');
                    _this.tableattributes = _this.utilityService.listAppend(_this.tableattributes, 'data-parentidproperty=' + _this.parentPropertyname + '.' + _this.exampleEntity.$$getIDName(), ' ');
                    _this.collectionConfig.setAllRecords(true);
                }
                //            if(
                //                !this.edit 
                //                && this.multiselectable 
                //                && (!this.parentPropertyName || !!this.parentPropertyName.length)
                //                && (this.multiselectPropertyIdentifier && this.multiselectPropertyIdentifier.length)
                //            ){
                //                if(this.multiselectValues && this.multiselectValues.length){
                //                    this.collectionConfig.addFilter(this.multiselectPropertyIdentifier,this.multiselectValues,'IN');   
                //                }else{
                //                    this.collectionConfig.addFilter(this.multiselectPropertyIdentifier,'_','IN');
                //                }
                //            }
                if (_this.multiselectValues && _this.multiselectValues.length) {
                    //select all owned ids
                    angular.forEach(_this.multiselectValues.split(','), function (value) {
                        _this.selectionService.addSelection('ListingDisplay', value);
                    });
                }
                //set defaults if value is not specified
                //this.edit = this.edit || $location.edit
                _this.processObjectProperties = _this.processObjectProperties || '';
                _this.recordProcessButtonDisplayFlag = _this.recordProcessButtonDisplayFlag || true;
                _this.collectionConfig = _this.collectionConfig || _this.collectionData.collectionConfig;
                _this.norecordstext = _this.$slatwall.getRBKey('entity.' + _this.collectionObject + '.norecords');
                //Setup Sortability
                if (_this.sortProperty && _this.sortProperty.length) {
                }
                //Setup the admin meta info
                _this.administrativeCount = 0;
                //Detail
                if (_this.recordDetailAction && _this.recordDetailAction.length) {
                    _this.administrativeCount++;
                    _this.adminattributes = _this.getAdminAttributesByType('detail');
                }
                //Edit
                if (_this.recordEditAction && _this.recordEditAction.length) {
                    _this.administrativeCount++;
                    _this.adminattributes = _this.getAdminAttributesByType('edit');
                }
                //Delete
                if (_this.recordDeleteAction && _this.recordDeleteAction.length) {
                    _this.administrativeCount++;
                    _this.adminattributes = _this.getAdminAttributesByType('delete');
                }
                //Add
                if (_this.recordAddAction && _this.recordAddAction.length) {
                    _this.administrativeCount++;
                    _this.adminattributes = _this.getAdminAttributesByType('add');
                }
                //Process
                // if(this.recordProcessAction && this.recordProcessAction.length && this.recordProcessButtonDisplayFlag){
                //     this.administrativeCount++;
                //     this.tableattributes = this.utilityService.listAppend(this.tableattributes, 'data-processcontext="'+this.recordProcessContext+'"', " ");
                //     this.tableattributes = this.utilityService.listAppend(this.tableattributes, 'data-processentity="'+this.recordProcessEntity.metaData.className+'"', " ");
                //     this.tableattributes = this.utilityService.listAppend(this.tableattributes, 'data-processentityid="'+this.recordProcessEntity.$$getID+'"', " ");
                //     this.adminattributes = this.utilityService.listAppend(this.adminattributes, 'data-processaction="'+this.recordProcessAction+'"', " ");
                //     this.adminattributes = this.utilityService.listAppend(this.adminattributes, 'data-processcontext="'+this.recordProcessContext+'"', " ");
                //     this.adminattributes = this.utilityService.listAppend(this.adminattributes, 'data-processquerystring="'+this.recordProcessQueryString+'"', " ");
                //     this.adminattributes = this.utilityService.listAppend(this.adminattributes, 'data-processupdatetableid="'+this.recordProcessUpdateTableID+'"', " ");
                // }
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
                angular.forEach(_this.columns, function (column) {
                    //If this is a standard propertyIdentifier
                    if (column.propertyIdentifier) {
                        //Add to the all property identifiers
                        _this.allpropertyidentifiers = _this.utilityService.listAppend(_this.allpropertyidentifiers, column.propertyIdentifier);
                        //Check to see if we need to setup the dynamic filters, etc
                        //<cfif not len(column.search) || not len(column.sort) || not len(column.filter) || not len(column.range)>
                        if (!column.searchable || !!column.searchable.length || !column.sort || !column.sort.length) {
                            //Get the entity object to get property metaData
                            var thisEntityName = _this.$slatwall.getLastEntityNameInPropertyIdentifier(_this.exampleEntity.metaData.className, column.propertyIdentifier);
                            var thisPropertyName = _this.utilityService.listLast(column.propertyIdentifier, '.');
                            var thisPropertyMeta = _this.$slatwall.getPropertyByEntityNameAndPropertyName(thisEntityName, thisPropertyName);
                        }
                    }
                    else if (column.processObjectProperty) {
                        column.searchable = false;
                        column.sort = false;
                        /*
                        <cfset column.filter = false />
                        <cfset column.range = false />
                        */
                        _this.allprocessobjectproperties = _this.utilityService.listAppend(_this.allprocessobjectproperties, column.processObjectProperty);
                    }
                    if (column.tdclass) {
                        var tdclassArray = column.tdclass.split(' ');
                        if (tdclassArray.indexOf("primary") >= 0 && _this.expandable) {
                            _this.tableattributes = _this.utilityService.listAppend(_this.tableattributes, 'data-expandsortproperty=' + column.propertyIdentifier, " ");
                            column.sort = false;
                        }
                    }
                });
                //Setup a variable for the number of columns so that the none can have a proper colspan
                _this.columnCount = _this.columns.length;
                if (_this.selectable) {
                    _this.columnCount++;
                }
                if (_this.multiselectable) {
                    _this.columnCount++;
                }
                if (_this.sortable) {
                    _this.columnCount++;
                }
                if (_this.administrativeCount) {
                    _this.administrativeCount++;
                }
                //Setup table class
                _this.tableclass = _this.tableclass || '';
                _this.tableclass = _this.utilityService.listPrepend(_this.tableclass, 'table table-bordered table-hover', ' ');
            };
            this.setupColumns = function () {
                //assumes no alias formatting
                angular.forEach(_this.columns, function (column) {
                    var lastEntity = _this.$slatwall.getLastEntityNameInPropertyIdentifier(_this.collectionObject, column.propertyIdentifier);
                    var title = _this.$slatwall.getRBKey('entity.' + lastEntity.toLowerCase() + '.' + _this.utilityService.listLast(column.propertyIdentifier, '.'));
                    if (angular.isUndefined(column.isVisible)) {
                        column.isVisible = true;
                    }
                    _this.collectionConfig.addDisplayProperty(column.propertyIdentifier, title, column);
                });
                //if the passed in collection has columns perform some formatting
                if (_this.hasCollectionPromise) {
                    //assumes alias formatting from collectionConfig
                    angular.forEach(_this.collectionConfig.columns, function (column) {
                        var lastEntity = _this.$slatwall.getLastEntityNameInPropertyIdentifier(_this.collectionObject, _this.utilityService.listRest(column.propertyIdentifier, '.'));
                        column.title = column.title || _this.$slatwall.getRBKey('entity.' + lastEntity.toLowerCase() + '.' + _this.utilityService.listLast(column.propertyIdentifier, '.'));
                        if (angular.isUndefined(column.isVisible)) {
                            column.isVisible = true;
                        }
                    });
                }
            };
            this.updateMultiselectValues = function () {
                _this.multiselectValues = _this.selectionService.getSelections('ListingDisplay');
            };
            this.escapeRegExp = function (str) {
                return str.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1");
            };
            this.replaceAll = function (str, find, replace) {
                return str.replace(new RegExp(_this.escapeRegExp(find), 'g'), replace);
            };
            this.getPageRecordKey = function (propertyIdentifier) {
                if (propertyIdentifier) {
                    var propertyIdentifierWithoutAlias = '';
                    if (propertyIdentifier.indexOf('_') === 0) {
                        propertyIdentifierWithoutAlias = propertyIdentifier.substring(propertyIdentifier.indexOf('.') + 1, propertyIdentifier.length);
                    }
                    else {
                        propertyIdentifierWithoutAlias = propertyIdentifier;
                    }
                    return _this.replaceAll(propertyIdentifierWithoutAlias, '.', '_');
                }
                return '';
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
            this.$q = $q;
            this.$timeout = $timeout;
            this.$slatwall = $slatwall;
            this.partialsPath = partialsPath;
            this.utilityService = utilityService;
            this.$scope = $scope;
            this.$element = $element;
            this.collectionConfigService = collectionConfigService;
            this.paginationService = paginationService;
            this.selectionService = selectionService;
            this.observerService = observerService;
            this.paginator = paginationService.createPagination();
            this.hasCollectionPromise = false;
            if (angular.isUndefined(this.getChildCount)) {
                this.getChildCount = false;
            }
            if (!this.collection || !angular.isString(this.collection)) {
                this.hasCollectionPromise = true;
            }
            else {
                this.collectionObject = this.collection;
                this.collectionConfig = this.collectionConfigService.newCollectionConfig(this.collectionObject);
            }
            this.setupDefaultCollectionInfo();
            //if columns doesn't exist then make it
            if (!this.collectionConfig.columns) {
                this.collectionConfig.columns = [];
            }
            //if a collectionConfig was not passed in then we can run run swListingColumns
            //this is performed early to populate columns with swlistingcolumn info
            this.$transclude = $transclude;
            this.$transclude(this.$scope, function () { });
            this.setupColumns();
            this.exampleEntity = this.$slatwall.newEntity(this.collectionObject);
            this.collectionConfig.addDisplayProperty(this.exampleEntity.$$getIDName(), undefined, { isVisible: false });
            this.initData();
            this.$scope.$watch('swListingDisplay.collectionPromise', function (newValue, oldValue) {
                if (newValue) {
                    _this.$q.when(_this.collectionPromise).then(function (data) {
                        _this.collectionData = data;
                        _this.setupDefaultCollectionInfo();
                        _this.setupColumns();
                        _this.collectionData.pageRecords = _this.collectionData.pageRecords || _this.collectionData.records;
                        _this.paginator.setPageRecordsInfo(_this.collectionData);
                    });
                }
            });
            this.tableID = 'LD' + this.utilityService.createID();
            //if getCollection doesn't exist then create it
            if (angular.isUndefined(this.getCollection)) {
                this.getCollection = this.setupDefaultGetCollection();
            }
            this.paginator.getCollection = this.getCollection;
            //this.getCollection();
        }
        SWListingDisplayController.$inject = ['$scope', '$element', '$transclude', '$timeout', '$q', '$slatwall', 'partialsPath', 'utilityService', 'collectionConfigService', 'paginationService', 'selectionService', 'observerService'];
        return SWListingDisplayController;
    })();
    slatwalladmin.SWListingDisplayController = SWListingDisplayController;
    var SWListingDisplay = (function () {
        function SWListingDisplay(partialsPath) {
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
                getCollection: "&?",
                collectionPromise: "=",
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
                recordAddAction: "@",
                recordAddActionProperty: "@",
                recordAddQueryString: "@",
                recordAddModal: "=",
                recordAddDisabled: "=",
                recordProcessesConfig: "=",
                /* record processes config is an array of actions. Example:
                [
                   {
                       recordProcessAction:"@",
                       recordProcessActionProperty:"@",
                       recordProcessQueryString:"@",
                       recordProcessContext:"@",
                       recordProcessEntity:"=",
                       recordProcessEntityData:"=",
                       recordProcessUpdateTableID:"=",
                       recordProcessButtonDisplayFlag:"=",
                   }
                ]
                */
                /*Hierachy Expandable*/
                parentPropertyName: "@",
                //booleans
                expandable: "=",
                expandableOpenRoot: "=",
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
                exportAction: "@",
                getChildCount: "="
            };
            this.controller = SWListingDisplayController;
            this.controllerAs = "swListingDisplay";
            this.link = function (scope, element, attrs, controller, transclude) {
                scope.$on('$destroy', function () {
                    observerService.detachByID(scope.collection);
                });
                scope.$watch('swListingDisplay.collectionConfig', function (newValue, oldValue) {
                    console.log('newCollectionConifg');
                    console.log(newValue);
                });
            };
            this.partialsPath = partialsPath;
            this.templateUrl = this.partialsPath + 'listingdisplay.html';
        }
        SWListingDisplay.$inject = ['partialsPath'];
        return SWListingDisplay;
    })();
    slatwalladmin.SWListingDisplay = SWListingDisplay;
    angular.module('slatwalladmin').directive('swListingDisplay', ['partialsPath', function (partialsPath) { return new SWListingDisplay(partialsPath); }]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/common/swlistingdisplay.js.map