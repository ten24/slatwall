/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var SWListingColumnController = (function () {
        function SWListingColumnController(partialsPath, utilityService, $slatwall) {
            var _this = this;
            this.partialsPath = partialsPath;
            this.utilityService = utilityService;
            this.$slatwall = $slatwall;
            this.init = function () {
                _this.editable = _this.editable || false;
                // var column ={
                //     propertyIdentifier:this.proopertyIdentifier    
                // }
                // this.swListingDisplay.columns(column);
            };
            this.$slatwall = $slatwall;
            this.utilityService = utilityService;
            console.log('ListingColumn');
            console.log(this);
            //need to perform init after promise completes
            this.init();
        }
        SWListingColumnController.$inject = ['partialsPath', 'utilityService', '$slatwall'];
        return SWListingColumnController;
    })();
    slatwalladmin.SWListingColumnController = SWListingColumnController;
    var SWListingColumn = (function () {
        function SWListingColumn(partialsPath, utiltiyService, $slatwall, $scope) {
            this.partialsPath = partialsPath;
            this.utiltiyService = utiltiyService;
            this.$slatwall = $slatwall;
            this.$scope = $scope;
            this.restrict = 'EA';
            //public bindToController=true;
            // public scope = {
            //     propertyIdentifier:"@",
            //     processObjectProperty:"@",
            //     title:"@",
            //     tdclass:"@",
            //     search:"=",
            //     sort:"=",
            //     filter:"=",
            //     range:"=",
            //     editable:"=",
            //     buttonGroup:"="    
            // };
            this.scope = {};
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
            this.link = function (scope, element, attrs, swListingDisplay) {
                //this.swListingDisplay = swListingDisplay;
                // console.log('scopelistingcolumn');
                // console.log(scope);
                // console.log(this);
            };
            console.log('listing column constructor');
            console.log(this);
        }
        SWListingColumn.$inject = ['partialsPath', 'utilityService', '$slatwall'];
        return SWListingColumn;
    })();
    slatwalladmin.SWListingColumn = SWListingColumn;
    angular.module('slatwalladmin').directive('swListingColumn', ['partialsPath', 'utilityService', '$slatwall', function (partialsPath, utilityService, $slatwall) { return new SWListingColumn(partialsPath, utilityService, $slatwall); }]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/common/swlistingcolumn.js.map