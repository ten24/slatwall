/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var SWActionCallerController = (function () {
        function SWActionCallerController(utilityService, $slatwall) {
            this.utilityService = utilityService;
            this.$slatwall = $slatwall;
            if (angular.isDefined(this.icon)) {
                this.icon = '<i class="glyphicon glyphicon-' + this.icon + '"></i>';
            }
            var firstFourLetters = this.utilityService.left(actionItem, 4);
            var firstSixLetters = this.utilityService.left(actionItem, 6);
            var actionItem = this.utilityService.listLast(this.action, '.');
            var minus4letters = this.utilityService.right(actionItem, 4);
            var minus6letters = this.utilityService.right(actionItem, 6);
            var actionItemEntityName = "";
            if (firstFourLetters === 'list' && actionItem.length)
                gt;
            4;
            {
                actionItemEntityName = minus4letters;
            }
            if (firstFourLetters === 'edit' && actionItem.length)
                gt;
            4;
            {
                actionItemEntityName = minus4letters;
            }
            if (firstFourLetters === 'save' && actionItem.length)
                gt;
            4;
            {
                actionItemEntityName = minus4letters;
            }
            if (firstSixLetters === 'create' && actionItem.length)
                gt;
            6;
            {
                actionItemEntityName = minus6letters;
            }
            if (firstSixLetters === 'detail' && actionItem.length)
                gt;
            6;
            {
                actionItemEntityName = minus6letters;
            }
            if (firstSixLetters === 'delete' && actionItem.length)
                gt;
            6;
            {
                actionItemEntityName = minus6letters;
            }
            //if text is blank or undefined
            if (angular.isUndefined(this.text) || (angular.isDefined(this.text) && this.text.length && angular.isUndefined(this.icon))) {
            }
            //if title is undefined then use text
            if (angular.isUndefined(this.title) || !this.title.length) {
                this.title = this.text;
            }
            //if item is disabled
            if (angular.isDefined(this.disabled) && this.disabled) {
                //and no disabled text specified
                if (angular.isUndefined(this.disabledtext) || !this.disabledtext.length) {
                    var disabledrbkey = this.action.replace('');
                    this.disabledtext = $slatwall.getRBKey();
                }
            }
        }
        return SWActionCallerController;
    })();
    slatwalladmin.SWActionCallerController = SWActionCallerController;
    var SWActionCaller = (function () {
        function SWActionCaller(partialsPath, utiltiyService, $slatwall) {
            this.partialsPath = partialsPath;
            this.utiltiyService = utiltiyService;
            this.$slatwall = $slatwall;
            this.restrict = 'E';
            this.scope = {};
            this.transclude = true;
            this.bindToController = {
                action: "@",
                text: "=",
                type: "=",
                queryString: "=",
                title: "=",
                class: "=",
                icon: "=",
                iconOnly: "=",
                name: "=",
                confirm: "=",
                confirmtext: "=",
                disabled: "=",
                disabledtext: "=",
                modal: "=",
                modalFullWidth: "=",
                id: "="
            };
            this.controller = SWActionCallerController;
            this.controllerAs = "swActionCaller";
            this.link = function (scope, element, attrs) {
            };
            this.templateUrl = partialsPath + 'actioncaller.html';
        }
        return SWActionCaller;
    })();
    slatwalladmin.SWActionCaller = SWActionCaller;
    angular.module('slatwalladmin').directive('swActionCaller', ['partialsPath', 'utilityService', '$slatwall', function (partialsPath, utilityService, $slatwall) { return new SWActionCaller(partialsPath, utilityService, $slatwall); }]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/common/swactioncaller.js.map