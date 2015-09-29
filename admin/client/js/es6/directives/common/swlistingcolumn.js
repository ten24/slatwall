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
        constructor() {
            this.restrict = 'EA';
            // public scope={}; 
            //	   public bindToController={
            //           propertyIdentifier:"@",
            //           processObjectProperty:"@",
            //           title:"@",
            //           tdclass:"@",
            //           search:"=",
            //           sort:"=",
            //           filter:"=",
            //           range:"=",
            //           editable:"=",
            //           buttonGroup:"="
            //       };
            this.controller = SWListingColumnController;
            this.controllerAs = "swListingColumn";
            this.link = (scope, element, attrs) => {
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
        }
    }
    slatwalladmin.SWListingColumn = SWListingColumn;
    angular.module('slatwalladmin').directive('swListingColumn', [() => new SWListingColumn()]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/common/swlistingcolumn.js.map