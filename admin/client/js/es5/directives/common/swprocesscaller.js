/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var SWProcessCallerController = (function () {
        function SWProcessCallerController() {
            this.type = this.type || 'link';
            console.log('init process caller controller');
            console.log(this);
        }
        return SWProcessCallerController;
    })();
    slatwalladmin.SWProcessCallerController = SWProcessCallerController;
    var SWProcessCaller = (function () {
        function SWProcessCaller(partialsPath) {
            this.partialsPath = partialsPath;
            this.restrict = 'E';
            this.scope = {};
            this.transclude = true;
            this.bindToController = {
                action: "@",
                entity: "@",
                processContext: "@",
                hideDisabled: "=",
                type: "@",
                querystring: "@",
                text: "@",
                title: "@",
                class: "@",
                icon: "=",
                iconOnly: "=",
                submit: "=",
                confirm: "=",
                disabled: "=",
                disabledText: "@",
                modal: "="
            };
            this.controller = SWProcessCallerController;
            this.controllerAs = "swProcessCaller";
            this.link = function (scope, element, attrs) {
            };
            this.templateUrl = partialsPath + 'processcaller.html';
        }
        return SWProcessCaller;
    })();
    slatwalladmin.SWProcessCaller = SWProcessCaller;
    angular.module('slatwalladmin').directive('swProcessCaller', ['partialsPath', function (partialsPath) { return new SWProcessCaller(partialsPath); }]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/common/swprocesscaller.js.map