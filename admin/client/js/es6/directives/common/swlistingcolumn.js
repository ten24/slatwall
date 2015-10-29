/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class SWListingColumnController {
        constructor() {
            this.init = () => {
                this.editable = this.editable || false;
            };
            this.init();
        }
    }
    slatwalladmin.SWListingColumnController = SWListingColumnController;
    class SWListingColumn {
        constructor(utilityService) {
            this.utilityService = utilityService;
            this.restrict = 'EA';
            this.scope = true;
            this.bindToController = {
                propertyIdentifier: "@",
                processObjectProperty: "@",
                title: "@",
                tdclass: "@",
                search: "=",
                sort: "=",
                filter: "=",
                range: "=",
                editable: "=",
                buttonGroup: "="
            };
            this.controller = SWListingColumnController;
            this.controllerAs = "swListingColumn";
            this.link = (scope, element, attrs) => {
                var column = {
                    propertyIdentifier: scope.swListingColumn.propertyIdentifier,
                    processObjectProperty: scope.swListingColumn.processObjectProperty,
                    title: scope.swListingColumn.title,
                    tdclass: scope.swListingColumn.tdclass,
                    search: scope.swListingColumn.search,
                    sort: scope.swListingColumn.sort,
                    filter: scope.swListingColumn.filter,
                    range: scope.swListingColumn.range,
                    editable: scope.swListingColumn.editable,
                    buttonGroup: scope.swListingColumn.buttonGroup
                };
                if (utilityService.ArrayFindByPropertyValue(scope.$parent.swListingDisplay.columns, 'propertyIdentifier', column.propertyIdentifier) === -1) {
                    scope.$parent.swListingDisplay.columns.push(column);
                }
            };
        }
    }
    SWListingColumn.$inject = ['utilityService'];
    slatwalladmin.SWListingColumn = SWListingColumn;
    angular.module('slatwalladmin').directive('swListingColumn', ['utilityService', (utilityService) => new SWListingColumn(utilityService)]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=swlistingcolumn.js.map
