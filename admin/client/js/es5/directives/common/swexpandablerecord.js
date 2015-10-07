/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var SWExpandableRecordController = (function () {
        function SWExpandableRecordController($scope, $element, $templateRequest, $compile, partialsPath, utilityService, $slatwall, collectionConfigService) {
            var _this = this;
            this.$scope = $scope;
            this.$element = $element;
            this.$templateRequest = $templateRequest;
            this.$compile = $compile;
            this.partialsPath = partialsPath;
            this.utilityService = utilityService;
            this.$slatwall = $slatwall;
            this.toggleChild = function () {
                _this.childrenOpen = !_this.childrenOpen;
                console.log('toggleChild');
                console.log(_this.childrenOpen);
                if (!_this.childrenLoaded) {
                    var childCollectionConfig = _this.collectionConfigService.newCollectionConfig(_this.entity.metaData.className);
                    var parentName = _this.entity.metaData.hb_parentPropertyName;
                    var parentCFC = _this.entity.metaData[parentName].cfc;
                    var parentIDName = _this.$slatwall.getEntityExample(parentCFC).$$getIDName();
                    childCollectionConfig.clearFilterGroups();
                    childCollectionConfig.collection = _this.entity;
                    childCollectionConfig.addFilter(parentName + '.' + parentIDName, _this.id);
                    childCollectionConfig.setAllRecords(true);
                    childCollectionConfig.columns = _this.collectionConfig.columns;
                    console.log(childCollectionConfig);
                    _this.collectionPromise = childCollectionConfig.getEntity();
                    _this.collectionPromise.then(function (data) {
                        _this.collectionData = data;
                        _this.collectionData.pageRecords = _this.collectionData.pageRecords || _this.collectionData.records;
                        /* if(this.collectionData.pageRecords.length){
                             angular.forEach(this.collectionData.pageRecords,(pageRecord)=>{
                                 pageRecord.dataparentID = this.recordID;
                                 pageRecord.depth = this.recordDepth || 0;
                                 pageRecord.depth++;
                                 this.records.splice(this.recordIndex+1,0,pageRecord);
                             });
                         }*/
                        console.log('page records');
                        console.log(_this.records);
                        console.log(_this.recordIndex);
                        _this.childrenLoaded = true;
                        _this.init();
                    });
                }
                /*angular.forEach(this.records,(record)=>{
                   if(record.dataparentID === this.recordID){
                    record.dataIsVisible = false;
                   }
                });*/
                return _this.collectionPromise;
            };
            this.init = function () {
            };
            this.$scope = $scope;
            this.$element = $element;
            this.$templateRequest = $templateRequest;
            this.$compile = $compile;
            this.partialsPath = partialsPath;
            this.$slatwall = $slatwall;
            this.utilityService = utilityService;
            this.collectionConfigService = collectionConfigService;
            this.tdElement = this.$element.parent();
            this.childrenLoaded = false;
            this.childrenOpen = false;
            this.record = this.records[this.recordIndex];
            this.recordID = this.record[this.entity.$$getIDName()];
            this.$element.bind('click', this.toggleChild);
            console.log('swExpandable');
        }
        SWExpandableRecordController.$inject = ['$scope', '$element', '$templateRequest', '$compile', 'partialsPath', 'utilityService', '$slatwall', 'collectionConfigService'];
        return SWExpandableRecordController;
    })();
    slatwalladmin.SWExpandableRecordController = SWExpandableRecordController;
    var SWExpandableRecord = (function () {
        function SWExpandableRecord(partialsPath, utiltiyService, $slatwall) {
            this.partialsPath = partialsPath;
            this.utiltiyService = utiltiyService;
            this.$slatwall = $slatwall;
            this.restrict = 'A';
            this.scope = {};
            this.bindToController = {
                //ID of parent record
                id: "=",
                entity: "=",
                collectionConfig: "=",
                recordIndex: "=",
                records: "=",
                recordDepth: "="
            };
            this.controller = SWExpandableRecordController;
            this.controllerAs = "swExpandableRecord";
            this.link = function (scope, element, attrs) {
            };
        }
        return SWExpandableRecord;
    })();
    slatwalladmin.SWExpandableRecord = SWExpandableRecord;
    angular.module('slatwalladmin').directive('swExpandableRecord', [function () { return new SWExpandableRecord(); }]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/common/swexpandablerecord.js.map