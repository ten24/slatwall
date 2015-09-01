/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var SWPaginationBarController = (function () {
        function SWPaginationBarController() {
        }
        return SWPaginationBarController;
    })();
    slatwalladmin.SWPaginationBarController = SWPaginationBarController;
    var SWPaginationBar = (function () {
        function SWPaginationBar($log, $timeout, partialsPath, paginationService) {
            this.$log = $log;
            this.$timeout = $timeout;
            this.partialsPath = partialsPath;
            this.paginationService = paginationService;
            this.restrict = 'E';
            this.scope = {};
            this.bindToController = {
                paginator: "="
            };
            this.controller = SWPaginationBarController;
            this.controllerAs = "swPaginationBar";
            this.link = function (scope, element, attrs) {
            };
            this.templateUrl = partialsPath + 'paginationbar.html';
        }
        return SWPaginationBar;
    })();
    slatwalladmin.SWPaginationBar = SWPaginationBar;
    angular.module('slatwalladmin').directive('swPaginationBar', ['$log', '$timeout', 'partialsPath', 'paginationService', function ($log, $timeout, partialsPath, paginationService) { return new SWPaginationBar($log, $timeout, partialsPath, paginationService); }]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/common/swpaginationbar.js.map