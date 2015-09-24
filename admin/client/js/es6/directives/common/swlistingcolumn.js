/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class SWListingColumnController {
        constructor($scope, utilityService, $slatwall) {
            this.$scope = $scope;
            this.utilityService = utilityService;
            this.$slatwall = $slatwall;
            this.init = () => {
                this.editable = this.editable || false;
            };
            this.$scope = $scope;
            this.$slatwall = $slatwall;
            this.utilityService = utilityService;
            this.init();
        }
    }
    SWListingColumnController.$inject = ['$scope', 'utilityService', '$slatwall'];
    slatwalladmin.SWListingColumnController = SWListingColumnController;
    class SWListingColumn {
        constructor() {
            this.restrict = 'EA';
            // public scope={}; 
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
                console.log('column scope');
                console.log(scope);
                var column = {
                    propertyIdentifier: scope.propertyIdentifier,
                    processObjectProperty: scope.processObjectProperty,
                    title: scope.title,
                    tdclass: scope.tdclass,
                    search: scope.search,
                    sort: scope.sort,
                    filter: scope.filter,
                    range: scope.range,
                    editable: scope.editable,
                    buttonGroup: scope.buttonGroup
                };
                scope.swListingDisplay.columns.push(column);
            };
            console.log('column cons');
        }
    }
    slatwalladmin.SWListingColumn = SWListingColumn;
    angular.module('slatwalladmin').directive('swListingColumn', [() => new SWListingColumn()]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/common/swlistingcolumn.js.map