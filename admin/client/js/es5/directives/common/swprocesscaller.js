/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var SWProcessCallerController = (function () {
        function SWProcessCallerController($templateRequest, $compile, partialsPath, $scope, $element, $transclude) {
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
            this.$scope = $scope;
            this.$element = $element;
            this.$transclude = this.$transclude;
            this.type = this.type || 'link';
            this.$templateRequest(this.partialsPath + "processcaller.html").then(function (html) {
                var template = angular.element(html);
                _this.$element.parent().append(template);
                $compile(template)($scope);
            });
            // this.$transclude();
            // this.$transclude((transElem,transScope)=>{
            // 	$element.append(transElem);
            //     console.log('tranclude');
            //     console.log(transElem);
            //     console.log(transScope);
            // });
            console.log('init process caller controller');
            console.log(this);
        }
        SWProcessCallerController.$inject = ['$templateRequest', '$compile', 'partialsPath', '$scope', '$element', '$transclude'];
        return SWProcessCallerController;
    })();
    slatwalladmin.SWProcessCallerController = SWProcessCallerController;
    var SWProcessCaller = (function () {
        function SWProcessCaller() {
            this.restrict = 'E';
            this.scope = {};
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
        }
        return SWProcessCaller;
    })();
    slatwalladmin.SWProcessCaller = SWProcessCaller;
    angular.module('slatwalladmin').directive('swProcessCaller', [function () { return new SWProcessCaller(); }]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/common/swprocesscaller.js.map