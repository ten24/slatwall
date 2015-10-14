/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var SWEntityActionBarController = (function () {
        function SWEntityActionBarController() {
            this.init = function () {
            };
            this.init();
        }
        return SWEntityActionBarController;
    })();
    slatwalladmin.SWEntityActionBarController = SWEntityActionBarController;
    var SWEntityActionBar = (function () {
        function SWEntityActionBar(partialsPath) {
            this.partialsPath = partialsPath;
            this.restrict = 'E';
            this.scope = {};
            this.transclude = true;
            this.bindToController = {
                /*Core settings*/
                type: "@",
                object: "=",
                pageTitle: "@",
                edit: "=",
                /*Action Callers (top buttons)*/
                showcancel: "=",
                showcreate: "=",
                showedit: "=",
                showdelete: "=",
                /*Basic Action Caller Overrides*/
                createModal: "=",
                createAction: "=",
                createQueryString: "=",
                backAction: "=",
                backQueryString: "=",
                cancelAction: "=",
                cancelQueryString: "=",
                deleteAction: "=",
                deleteQueryString: "=",
                /*Process Specific Values*/
                processAction: "=",
                processContext: "="
            };
            this.controller = SWEntityActionBarController;
            this.controllerAs = "swEntityActionBar";
            this.link = function (scope, element, attrs) {
            };
            this.templateUrl = partialsPath + 'entityactionbar.html';
        }
        return SWEntityActionBar;
    })();
    slatwalladmin.SWEntityActionBar = SWEntityActionBar;
    angular.module('slatwalladmin').directive('swEntityActionBar', ['partialsPath', function (partialsPath) { return new SWEntityActionBar(partialsPath); }]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/common/swentityactionbar.js.map