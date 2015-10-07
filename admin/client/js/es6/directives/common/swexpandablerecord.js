/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class SWExpandableRecordController {
        constructor($scope, $element, $templateRequest, $compile, partialsPath, utilityService, $slatwall, collectionConfigService) {
            this.$scope = $scope;
            this.$element = $element;
            this.$templateRequest = $templateRequest;
            this.$compile = $compile;
            this.partialsPath = partialsPath;
            this.utilityService = utilityService;
            this.$slatwall = $slatwall;
            this.toggleChild = () => {
                this.childrenOpen = !this.childrenOpen;
                console.log('toggleChild');
                console.log(this.childrenOpen);
                if (!this.childrenLoaded) {
                    var childCollectionConfig = this.collectionConfigService.newCollectionConfig(this.entity.metaData.className);
                    var parentName = this.entity.metaData.hb_parentPropertyName;
                    var parentCFC = this.entity.metaData[parentName].cfc;
                    var parentIDName = this.$slatwall.getEntityExample(parentCFC).$$getIDName();
                    childCollectionConfig.clearFilterGroups();
                    childCollectionConfig.collection = this.entity;
                    childCollectionConfig.addFilter(parentName + '.' + parentIDName, this.id);
                    childCollectionConfig.setAllRecords(true);
                    childCollectionConfig.columns = this.collectionConfig.columns;
                    console.log(childCollectionConfig);
                    this.collectionPromise = childCollectionConfig.getEntity();
                    this.collectionPromise.then((data) => {
                        this.collectionData = data;
                        this.collectionData.pageRecords = this.collectionData.pageRecords || this.collectionData.records;
                        /* if(this.collectionData.pageRecords.length){
                             angular.forEach(this.collectionData.pageRecords,(pageRecord)=>{
                                 pageRecord.dataparentID = this.recordID;
                                 pageRecord.depth = this.recordDepth || 0;
                                 pageRecord.depth++;
                                 this.records.splice(this.recordIndex+1,0,pageRecord);
                             });
                         }*/
                        console.log('page records');
                        console.log(this.records);
                        console.log(this.recordIndex);
                        this.childrenLoaded = true;
                        this.init();
                    });
                }
                /*angular.forEach(this.records,(record)=>{
                   if(record.dataparentID === this.recordID){
                    record.dataIsVisible = false;
                   }
                });*/
                return this.collectionPromise;
            };
            this.init = () => {
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
    }
    SWExpandableRecordController.$inject = ['$scope', '$element', '$templateRequest', '$compile', 'partialsPath', 'utilityService', '$slatwall', 'collectionConfigService'];
    slatwalladmin.SWExpandableRecordController = SWExpandableRecordController;
    class SWExpandableRecord {
        constructor(partialsPath, utiltiyService, $slatwall) {
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
            this.link = (scope, element, attrs) => {
            };
        }
    }
    slatwalladmin.SWExpandableRecord = SWExpandableRecord;
    angular.module('slatwalladmin').directive('swExpandableRecord', [() => new SWExpandableRecord()]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/common/swexpandablerecord.js.map