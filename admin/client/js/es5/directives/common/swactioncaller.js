/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var SWActionCallerController = (function () {
        function SWActionCallerController($scope, $element, $templateRequest, $compile, partialsPath, utilityService, $slatwall) {
            var _this = this;
            this.$scope = $scope;
            this.$element = $element;
            this.$templateRequest = $templateRequest;
            this.$compile = $compile;
            this.partialsPath = partialsPath;
            this.utilityService = utilityService;
            this.$slatwall = $slatwall;
            this.init = function () {
                _this.type = _this.type || 'link';
                _this.actionClick = _this.actionClick || "";
                console.log("OnClick", _this.actionclick);
            };
            this.getAction = function () {
                return _this.action || '';
            };
            this.getActionItem = function () {
                return _this.utilityService.listLast(_this.getAction(), '.');
            };
            this.getActionItemEntityName = function () {
                var firstFourLetters = _this.utilityService.left(_this.actionItem, 4);
                var firstSixLetters = _this.utilityService.left(_this.actionItem, 6);
                var minus4letters = _this.utilityService.right(_this.actionItem, 4);
                var minus6letters = _this.utilityService.right(_this.actionItem, 6);
                var actionItemEntityName = "";
                if (firstFourLetters === 'list' && _this.actionItem.length > 4) {
                    actionItemEntityName = minus4letters;
                }
                else if (firstFourLetters === 'edit' && _this.actionItem.length > 4) {
                    actionItemEntityName = minus4letters;
                }
                else if (firstFourLetters === 'save' && _this.actionItem.length > 4) {
                    actionItemEntityName = minus4letters;
                }
                else if (firstSixLetters === 'create' && _this.actionItem.length > 6) {
                    actionItemEntityName = minus6letters;
                }
                else if (firstSixLetters === 'detail' && _this.actionItem.length > 6) {
                    actionItemEntityName = minus6letters;
                }
                else if (firstSixLetters === 'delete' && _this.actionItem.length > 6) {
                    actionItemEntityName = minus6letters;
                }
                return actionItemEntityName;
            };
            this.getTitle = function () {
                //if title is undefined then use text
                if (angular.isUndefined(_this.title) || !_this.title.length) {
                    _this.title = _this.getText();
                }
                return _this.title;
            };
            this.getTextByRBKeyByAction = function (actionItemType, plural) {
                if (plural === void 0) { plural = false; }
                var navRBKey = _this.$slatwall.getRBKey('admin.define.' + actionItemType + '_nav');
                var entityRBKey = '';
                var replaceKey = '';
                if (plural) {
                    entityRBKey = _this.$slatwall.getRBKey('entity.' + _this.actionItemEntityName + '_plural');
                    replaceKey = '${itemEntityNamePlural}';
                }
                else {
                    entityRBKey = _this.$slatwall.getRBKey('entity.' + _this.actionItemEntityName);
                    replaceKey = '${itemEntityName}';
                }
                return _this.utilityService.replaceAll(navRBKey, replaceKey, entityRBKey);
            };
            this.getText = function () {
                //if we don't have text then make it up based on rbkeys
                if (angular.isUndefined(_this.text) || (angular.isDefined(_this.text) && !_this.text.length)) {
                    _this.text = _this.$slatwall.getRBKey(_this.utilityService.replaceAll(_this.getAction(), ":", ".") + '_nav');
                    var minus8letters = _this.utilityService.right(_this.text, 8);
                    //if rbkey is still missing. then can we infer it
                    if (minus8letters === '_missing') {
                        var firstFourLetters = _this.utilityService.left(_this.actionItem, 4);
                        var firstSixLetters = _this.utilityService.left(_this.actionItem, 6);
                        var minus4letters = _this.utilityService.right(_this.actionItem, 4);
                        var minus6letters = _this.utilityService.right(_this.actionItem, 6);
                        if (firstFourLetters === 'list' && _this.actionItem.length > 4) {
                            _this.text = _this.getTextByRBKeyByAction('list', true);
                        }
                        else if (firstFourLetters === 'edit' && _this.actionItem.length > 4) {
                            _this.text = _this.getTextByRBKeyByAction('edit', false);
                        }
                        else if (firstFourLetters === 'save' && _this.actionItem.length > 4) {
                            _this.text = _this.getTextByRBKeyByAction('save', false);
                        }
                        else if (firstSixLetters === 'create' && _this.actionItem.length > 6) {
                            _this.text = _this.getTextByRBKeyByAction('create', false);
                        }
                        else if (firstSixLetters === 'detail' && _this.actionItem.length > 6) {
                            _this.text = _this.getTextByRBKeyByAction('detail', false);
                        }
                        else if (firstSixLetters === 'delete' && _this.actionItem.length > 6) {
                            _this.text = _this.getTextByRBKeyByAction('delete', false);
                        }
                    }
                    if (_this.utilityService.right(_this.text, 8)) {
                        _this.text = _this.$slatwall.getRBKey(_this.utilityService.replaceAll(_this.getAction(), ":", "."));
                    }
                }
                if (!_this.title || (_this.title && !_this.title.length)) {
                    _this.title = _this.text;
                }
                return _this.text;
            };
            this.getDisabled = function () {
                //if item is disabled
                if (angular.isDefined(_this.disabled) && _this.disabled) {
                    return true;
                }
                else {
                    return false;
                }
            };
            this.getDisabledText = function () {
                if (_this.getDisabled()) {
                    //and no disabled text specified
                    if (angular.isUndefined(_this.disabledtext) || !_this.disabledtext.length) {
                        var disabledrbkey = _this.utilityService.replaceAll(_this.action, ':', '.') + '_disabled';
                        _this.disabledtext = $slatwall.getRBKey(disabledrbkey);
                    }
                    //add disabled class
                    _this.class += " s-btn-disabled";
                    _this.confirm = false;
                    return _this.disabledtext;
                }
                return "";
            };
            this.getConfirm = function () {
                if (angular.isDefined(_this.confirm) && _this.confirm) {
                    return true;
                }
                else {
                    return false;
                }
            };
            this.getConfirmText = function () {
                if (_this.getConfirm()) {
                    if (angular.isUndefined(_this.confirmtext) && _this.confirmtext.length) {
                        var confirmrbkey = _this.utilityService.replaceAll(_this.action, ':', '.') + '_confirm';
                        _this.confirmtext = $slatwall.getRBKey(confirmrbkey);
                    }
                    _this.class += " alert-confirm";
                    return _this.confirm;
                }
                return "";
            };
            this.$scope = $scope;
            this.$element = $element;
            this.$templateRequest = $templateRequest;
            this.$compile = $compile;
            this.partialsPath = partialsPath;
            this.$slatwall = $slatwall;
            this.utilityService = utilityService;
            this.$templateRequest(this.partialsPath + "actioncaller.html").then(function (html) {
                var template = angular.element(html);
                _this.$element.parent().append(template);
                $compile(template)($scope);
                //need to perform init after promise completes
                _this.init();
            });
        }
        SWActionCallerController.$inject = ['$scope', '$element', '$templateRequest', '$compile', 'partialsPath', 'utilityService', '$slatwall'];
        return SWActionCallerController;
    })();
    slatwalladmin.SWActionCallerController = SWActionCallerController;
    var SWActionCaller = (function () {
        function SWActionCaller(partialsPath, utiltiyService, $slatwall) {
            this.partialsPath = partialsPath;
            this.utiltiyService = utiltiyService;
            this.$slatwall = $slatwall;
            this.restrict = 'EA';
            this.scope = {};
            this.bindToController = {
                action: "@",
                actionClick: "&?",
                text: "@",
                type: "@",
                queryString: "@",
                title: "@",
                class: "@",
                icon: "@",
                iconOnly: "=",
                name: "@",
                confirm: "=",
                confirmtext: "@",
                disabled: "=",
                disabledtext: "@",
                modal: "=",
                modalFullWidth: "=",
                id: "@"
            };
            this.controller = SWActionCallerController;
            this.controllerAs = "swActionCaller";
            this.link = function (scope, element, attrs) {
            };
        }
        return SWActionCaller;
    })();
    slatwalladmin.SWActionCaller = SWActionCaller;
    angular.module('slatwalladmin').directive('swActionCaller', [function () { return new SWActionCaller(); }]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/common/swactioncaller.js.map