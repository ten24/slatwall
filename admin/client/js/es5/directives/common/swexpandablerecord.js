/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var SWExpandableRecordController = (function () {
        //        public childrenLoaded = false;
        //        public childrenOpen = false;
        //        public record;
        //        public recordID;
        function SWExpandableRecordController(utilityService, $slatwall, collectionConfigService) {
            this.utilityService = utilityService;
            this.$slatwall = $slatwall;
            this.$slatwall = $slatwall;
            this.utilityService = utilityService;
            this.collectionConfigService = collectionConfigService;
            //            this.tdElement = this.$element.parent();
            //            this.record = this.records[this.recordIndex];
            //            this.recordID = this.record[this.entity.$$getIDName()];
            //            this.$element.bind('click', this.toggleChild);
        }
        SWExpandableRecordController.$inject = ['$scope', '$element', 'utilityService', '$slatwall', 'collectionConfigService'];
        return SWExpandableRecordController;
    })();
    slatwalladmin.SWExpandableRecordController = SWExpandableRecordController;
    var SWExpandableRecord = (function () {
        function SWExpandableRecord($compile) {
            this.$compile = $compile;
            this.restrict = 'EA';
            this.scope = {};
            this.bindToController = {
                id: "=",
                entity: "=",
                collectionConfig: "=",
                recordIndex: "=",
                records: "=",
                recordDepth: "=",
                expandable: "="
            };
            this.controller = SWExpandableRecordController;
            this.controllerAs = "swExpandableRecord";
            this.link = function (scope, element, attrs) {
                console.log('expandable');
                console.log(scope.expandable);
                if (scope.expandable) {
                    console.log('this');
                    var html = $compile('expandable')(scope);
                    console.log(html);
                    element.html(html);
                }
                else {
                    console.log('compile');
                    var html = $compile('notexpandable')(scope);
                    console.log(html);
                    element.html(html);
                }
            };
            this.$compile = $compile;
        }
        SWExpandableRecord.$inject = ['$compile'];
        return SWExpandableRecord;
    })();
    slatwalladmin.SWExpandableRecord = SWExpandableRecord;
    angular.module('slatwalladmin').directive('swExpandableRecord', ['$compile', function ($compile) { return new SWExpandableRecord($compile); }]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/common/swexpandablerecord.js.map