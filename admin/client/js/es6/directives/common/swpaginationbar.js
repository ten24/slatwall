/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class SWPaginationBar {
        constructor($log, $timeout, partialsPath, paginationService) {
            this.$log = $log;
            this.$timeout = $timeout;
            this.partialsPath = partialsPath;
            this.paginationService = paginationService;
            this.restrict = 'E';
            this.scope = {
                paginator: "="
            };
            this.link = (scope, element, attrs) => {
            };
            this.templateUrl = partialsPath + 'paginationbar.html';
        }
    }
    slatwalladmin.SWPaginationBar = SWPaginationBar;
    angular.module('slatwalladmin').directive('swPaginationBar', ['$log', '$timeout', 'partialsPath', 'paginationService', ($log, $timeout, partialsPath, paginationService) => new SWPaginationBar($log, $timeout, partialsPath, paginationService)]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/common/swpaginationbar.js.map