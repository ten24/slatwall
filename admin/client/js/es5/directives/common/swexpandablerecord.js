/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    var SWExpandableRecordController = (function () {
        function SWExpandableRecordController($timeout, utilityService, $slatwall, collectionConfigService) {
            var _this = this;
            this.$timeout = $timeout;
            this.utilityService = utilityService;
            this.$slatwall = $slatwall;
            this.collectionConfigService = collectionConfigService;
            this.childrenLoaded = false;
            this.childrenOpen = false;
            this.children = [];
            this.toggleChild = function () {
                _this.$timeout(function () {
                    _this.childrenOpen = !_this.childrenOpen;
                    if (!_this.childrenLoaded) {
                        var childCollectionConfig = _this.collectionConfigService.newCollectionConfig(_this.entity.metaData.className);
                        //set up parent
                        var parentName = _this.entity.metaData.hb_parentPropertyName;
                        var parentCFC = _this.entity.metaData[parentName].cfc;
                        var parentIDName = _this.$slatwall.getEntityExample(parentCFC).$$getIDName();
                        //set up child
                        var childName = _this.entity.metaData.hb_childPropertyName;
                        var childCFC = _this.entity.metaData[childName].cfc;
                        var childIDName = _this.$slatwall.getEntityExample(childCFC).$$getIDName();
                        childCollectionConfig.clearFilterGroups();
                        childCollectionConfig.collection = _this.entity;
                        childCollectionConfig.addFilter(parentName + '.' + parentIDName, _this.parentId);
                        childCollectionConfig.setAllRecords(true);
                        angular.forEach(_this.collectionConfig.columns, function (column) {
                            childCollectionConfig.addColumn(column.propertyIdentifier, column.tilte, column);
                        });
                        angular.forEach(_this.collectionConfig.joins, function (join) {
                            childCollectionConfig.addJoin(join);
                        });
                        childCollectionConfig.groupBys = _this.collectionConfig.groupBys;
                        _this.collectionPromise = childCollectionConfig.getEntity();
                        _this.collectionPromise.then(function (data) {
                            _this.collectionData = data;
                            _this.collectionData.pageRecords = _this.collectionData.pageRecords || _this.collectionData.records;
                            if (_this.collectionData.pageRecords.length) {
                                angular.forEach(_this.collectionData.pageRecords, function (pageRecord) {
                                    pageRecord.dataparentID = _this.recordID;
                                    pageRecord.depth = _this.recordDepth || 0;
                                    pageRecord.depth++;
                                    _this.children.push(pageRecord);
                                    _this.records.splice(_this.recordIndex + 1, 0, pageRecord);
                                });
                            }
                            _this.childrenLoaded = true;
                        });
                    }
                    angular.forEach(_this.children, function (child) {
                        child.dataIsVisible = _this.childrenOpen;
                    });
                });
            };
            this.$timeout = $timeout;
            this.$slatwall = $slatwall;
            this.utilityService = utilityService;
            this.collectionConfigService = collectionConfigService;
        }
        SWExpandableRecordController.$inject = ['$timeout', 'utilityService', '$slatwall', 'collectionConfigService'];
        return SWExpandableRecordController;
    })();
    slatwalladmin.SWExpandableRecordController = SWExpandableRecordController;
    var SWExpandableRecord = (function () {
        function SWExpandableRecord($compile, $templateRequest, $timeout, partialsPath, utilityService) {
            var _this = this;
            this.$compile = $compile;
            this.$templateRequest = $templateRequest;
            this.$timeout = $timeout;
            this.partialsPath = partialsPath;
            this.utilityService = utilityService;
            this.restrict = 'EA';
            this.scope = {};
            this.bindToController = {
                recordValue: "=",
                link: "@",
                expandable: "=",
                parentId: "=",
                entity: "=",
                collectionConfig: "=",
                records: "=",
                recordIndex: "=",
                recordDepth: "=",
                childCount: "=",
                autoOpen: "=",
                multiselectIdPaths: "="
            };
            this.controller = SWExpandableRecordController;
            this.controllerAs = "swExpandableRecord";
            this.link = function (scope, element, attrs) {
                if (scope.swExpandableRecord.expandable && scope.swExpandableRecord.childCount) {
                    if (scope.swExpandableRecord.recordValue) {
                        var id = scope.swExpandableRecord.records[scope.swExpandableRecord.recordIndex][scope.swExpandableRecord.entity.$$getIDName()];
                        if (scope.swExpandableRecord.multiselectIdPaths && scope.swExpandableRecord.multiselectIdPaths.length) {
                            var multiselectIdPathsArray = scope.swExpandableRecord.multiselectIdPaths.split(',');
                            angular.forEach(multiselectIdPathsArray, function (multiselectIdPath) {
                                var position = _this.utilityService.listFind(multiselectIdPath, id, '/');
                                var multiselectPathLength = multiselectIdPath.split('/').length;
                                if (position !== -1 && position < multiselectPathLength - 1) {
                                    scope.swExpandableRecord.toggleChild();
                                }
                            });
                        }
                    }
                    $templateRequest(partialsPath + "expandablerecord.html").then(function (html) {
                        var template = angular.element(html);
                        //get autoopen reference to ensure only the root is autoopenable
                        var autoOpen = angular.copy(scope.swExpandableRecord.autoOpen);
                        scope.swExpandableRecord.autoOpen = false;
                        template = $compile(template)(scope);
                        element.html(template);
                        element.on('click', scope.swExpandableRecord.toggleChild);
                        if (autoOpen) {
                            scope.swExpandableRecord.toggleChild();
                        }
                    });
                }
            };
            this.$compile = $compile;
            this.$templateRequest = $templateRequest;
            this.partialsPath = partialsPath;
            this.$timeout = $timeout;
            this.utilityService = utilityService;
        }
        SWExpandableRecord.$inject = ['$compile', '$templateRequest', '$timeout', 'partialsPath', 'utilityService'];
        return SWExpandableRecord;
    })();
    slatwalladmin.SWExpandableRecord = SWExpandableRecord;
    angular.module('slatwalladmin').directive('swExpandableRecord', ['$compile', '$templateRequest', '$timeout', 'partialsPath', 'utilityService', function ($compile, $templateRequest, $timeout, partialsPath, utilityService) { return new SWExpandableRecord($compile, $templateRequest, $timeout, partialsPath, utilityService); }]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/common/swexpandablerecord.js.map