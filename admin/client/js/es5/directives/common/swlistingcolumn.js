/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var SWListingColumnController = (function () {
        function SWListingColumnController($scope, utilityService, $slatwall) {
            var _this = this;
            this.$scope = $scope;
            this.utilityService = utilityService;
            this.$slatwall = $slatwall;
            this.init = function () {
                _this.editable = _this.editable || false;
            };
            this.$scope = $scope;
            this.$slatwall = $slatwall;
            this.utilityService = utilityService;
            console.log('ListingColumn');
            console.log(this);
            // if(angular.isUndefined(this.$scope.$parent.$parent.swListingDisplay.columns)){
            //     this.$scope.$parent.$parent.swListingDisplay.columns = [];
            // }
            // if(!this.$scope.$parent.$parent.swListingDisplay.columns){
            //     this.$scope.$parent.$parent.swListingDisplay.columns = [];
            // }
            // this.$scope.$parent.$parent.swListingDisplay.columns.push(column);
            //need to perform init after promise completes
            this.init();
        }
        SWListingColumnController.$inject = ['$scope', 'utilityService', '$slatwall'];
        return SWListingColumnController;
    })();
    slatwalladmin.SWListingColumnController = SWListingColumnController;
    var SWListingColumn = (function () {
        function SWListingColumn() {
            this.restrict = 'EA';
            // public scope={}; 
            // public bindToController={
            //    propertyIdentifier:"@",
            //    processObjectProperty:"@",
            //    title:"@",
            //    tdclass:"@",
            //    search:"=",
            //    sort:"=",
            //    filter:"=",
            //    range:"=",
            //    editable:"=",
            //    buttonGroup:"="
            // };
            this.controller = SWListingColumnController;
            this.controllerAs = "swListingColumn";
            this.link = function (scope, element, attrs) {
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
        return SWListingColumn;
    })();
    slatwalladmin.SWListingColumn = SWListingColumn;
    angular.module('slatwalladmin').directive('swListingColumn', [function () { return new SWListingColumn(); }]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/common/swlistingcolumn.js.map