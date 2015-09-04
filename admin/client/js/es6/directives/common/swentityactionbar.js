/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class SWEntityActionBarController {
        constructor() {
        }
    }
    slatwalladmin.SWEntityActionBarController = SWEntityActionBarController;
    class SWEntityActionBar {
        constructor(partialsPath) {
            this.partialsPath = partialsPath;
            this.restrict = 'E';
            this.scope = {};
            this.bindToController = {
                /*Core settings*/
                type: "=",
                object: "=",
                pageTitle: "=",
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
            this.link = (scope, element, attrs) => {
            };
            this.templateUrl = partialsPath + 'entityactionbar.html';
        }
    }
    slatwalladmin.SWEntityActionBar = SWEntityActionBar;
    angular.module('slatwalladmin').directive('swEntityActionBar', ['partialsPath', (partialsPath) => new SWEntityActionBar(partialsPath)]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/common/swentityactionbar.js.map