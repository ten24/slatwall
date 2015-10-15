/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var SWProcessCallerController = (function () {
        function SWProcessCallerController($templateRequest, $compile, partialsPath, $scope, $element, $transclude, utilityService) {
            var _this = this;
            this.$templateRequest = $templateRequest;
            this.$compile = $compile;
            this.partialsPath = partialsPath;
            this.$scope = $scope;
            this.$element = $element;
            this.$transclude = $transclude;
            this.$templateRequest = $templateRequest;
            this.$compile = $compile;
            this.partialsPath = partialsPath;
            this.utilityService = utilityService;
            this.type = this.type || 'link';
            this.queryString = this.queryString || '';
            this.$scope = $scope;
            this.$element = $element;
            this.$transclude = this.$transclude;
            this.$templateRequest(this.partialsPath + "processcaller.html").then(function (html) {
                var template = angular.element(html);
                _this.$element.parent().append(template);
                $compile(template)(_this.$scope);
            });
        }
        SWProcessCallerController.$inject = ['$templateRequest', '$compile', 'partialsPath', '$scope', '$element', '$transclude', 'utilityService'];
        return SWProcessCallerController;
    })();
    slatwalladmin.SWProcessCallerController = SWProcessCallerController;
    var SWProcessCaller = (function () {
        function SWProcessCaller(partialsPath, utilityService) {
            this.partialsPath = partialsPath;
            this.utilityService = utilityService;
            this.restrict = 'E';
            this.scope = {};
            this.bindToController = {
                action: "@",
                entity: "@",
                processContext: "@",
                hideDisabled: "=",
                type: "@",
                queryString: "@",
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
            this.partialsPath = partialsPath;
            this.utilityService = utilityService;
        }
        SWProcessCaller.$inject = ['partialsPath', 'utilityService'];
        return SWProcessCaller;
    })();
    slatwalladmin.SWProcessCaller = SWProcessCaller;
    angular.module('slatwalladmin').directive('swProcessCaller', ['partialsPath', 'utilityService', function (partialsPath, utilityService) { return new SWProcessCaller(partialsPath, utilityService); }]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=swprocesscaller.js.map
