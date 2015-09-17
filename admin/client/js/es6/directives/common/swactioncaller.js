/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class SWActionCallerController {
        constructor(partialsPath, utilityService, $slatwall) {
            this.partialsPath = partialsPath;
            this.utilityService = utilityService;
            this.$slatwall = $slatwall;
            this.init = () => {
                this.class = this.utilityService.replaceAll(this.utilityService.replaceAll(this.getAction(), ':', ''), '.', '') + ' ' + this.class;
                this.actionItem = this.getActionItem();
                this.actionItemEntityName = this.getActionItemEntityName();
                this.text = this.getText();
                if (this.getDisabled()) {
                    this.getDisabledText();
                }
                else if (this.getConfirm()) {
                    this.getConfirmText();
                }
                if (this.modalFullWidth && !this.getDisabled()) {
                    this.class = this.class + " modalload-fullwidth";
                }
                if (this.modal && !this.getDisabled() && !this.modalFullWidth) {
                    this.class = this.class + " modalload";
                }
                /*need authentication lookup by api to disable
                <cfif not attributes.hibachiScope.authenticateAction(action=attributes.action)>
                    <cfset attributes.class &= " disabled" />
                </cfif>
                */
            };
            this.getAction = () => {
                return this.action || '';
            };
            this.getActionItem = () => {
                return this.utilityService.listLast(this.getAction(), '.');
            };
            this.getActionItemEntityName = () => {
                var firstFourLetters = this.utilityService.left(this.actionItem, 4);
                var firstSixLetters = this.utilityService.left(this.actionItem, 6);
                var minus4letters = this.utilityService.right(this.actionItem, 4);
                var minus6letters = this.utilityService.right(this.actionItem, 6);
                var actionItemEntityName = "";
                if (firstFourLetters === 'list' && this.actionItem.length > 4) {
                    actionItemEntityName = minus4letters;
                }
                else if (firstFourLetters === 'edit' && this.actionItem.length > 4) {
                    actionItemEntityName = minus4letters;
                }
                else if (firstFourLetters === 'save' && this.actionItem.length > 4) {
                    actionItemEntityName = minus4letters;
                }
                else if (firstSixLetters === 'create' && this.actionItem.length > 6) {
                    actionItemEntityName = minus6letters;
                }
                else if (firstSixLetters === 'detail' && this.actionItem.length > 6) {
                    actionItemEntityName = minus6letters;
                }
                else if (firstSixLetters === 'delete' && this.actionItem.length > 6) {
                    actionItemEntityName = minus6letters;
                }
                return actionItemEntityName;
            };
            this.getTitle = () => {
                //if title is undefined then use text
                if (angular.isUndefined(this.title) || !this.title.length) {
                    this.title = this.getText();
                }
                return this.title;
            };
            this.getTextByRBKeyByAction = (actionItemType, plural = false) => {
                var navRBKey = this.$slatwall.getRBKey('admin.define.' + actionItemType + '_nav');
                var entityRBKey = '';
                var replaceKey = '';
                if (plural) {
                    entityRBKey = this.$slatwall.getRBKey('entity.' + this.actionItemEntityName + '_plural');
                    replaceKey = '${itemEntityNamePlural}';
                }
                else {
                    entityRBKey = this.$slatwall.getRBKey('entity.' + this.actionItemEntityName);
                    replaceKey = '${itemEntityName}';
                }
                return this.utilityService.replaceAll(navRBKey, replaceKey, entityRBKey);
            };
            this.getText = () => {
                //if we don't have text then make it up based on rbkeys
                if (angular.isUndefined(this.text) || (angular.isDefined(this.text) && !this.text.length)) {
                    this.text = this.$slatwall.getRBKey(this.utilityService.replaceAll(this.getAction(), ":", ".") + '_nav');
                    var minus8letters = this.utilityService.right(this.text, 8);
                    //if rbkey is still missing. then can we infer it
                    if (minus8letters === '_missing') {
                        var firstFourLetters = this.utilityService.left(this.actionItem, 4);
                        var firstSixLetters = this.utilityService.left(this.actionItem, 6);
                        var minus4letters = this.utilityService.right(this.actionItem, 4);
                        var minus6letters = this.utilityService.right(this.actionItem, 6);
                        if (firstFourLetters === 'list' && this.actionItem.length > 4) {
                            this.text = this.getTextByRBKeyByAction('list', true);
                        }
                        else if (firstFourLetters === 'edit' && this.actionItem.length > 4) {
                            this.text = this.getTextByRBKeyByAction('edit', false);
                        }
                        else if (firstFourLetters === 'save' && this.actionItem.length > 4) {
                            this.text = this.getTextByRBKeyByAction('save', false);
                        }
                        else if (firstSixLetters === 'create' && this.actionItem.length > 6) {
                            this.text = this.getTextByRBKeyByAction('create', false);
                        }
                        else if (firstSixLetters === 'detail' && this.actionItem.length > 6) {
                            this.text = this.getTextByRBKeyByAction('detail', false);
                        }
                        else if (firstSixLetters === 'delete' && this.actionItem.length > 6) {
                            this.text = this.getTextByRBKeyByAction('delete', false);
                        }
                    }
                    if (this.utilityService.right(this.text, 8)) {
                        this.text = this.$slatwall.getRBKey(this.utilityService.replaceAll(this.getAction(), ":", "."));
                    }
                }
                if (!this.title || (this.title && !this.title.length)) {
                    this.title = this.text;
                }
                return this.text;
            };
            this.getDisabled = () => {
                //if item is disabled
                if (angular.isDefined(this.disabled) && this.disabled) {
                    return true;
                }
                else {
                    return false;
                }
            };
            this.getDisabledText = () => {
                if (this.getDisabled()) {
                    //and no disabled text specified
                    if (angular.isUndefined(this.disabledtext) || !this.disabledtext.length) {
                        var disabledrbkey = this.utilityService.replaceAll(this.action, ':', '.') + '_disabled';
                        this.disabledtext = $slatwall.getRBKey(disabledrbkey);
                    }
                    //add disabled class
                    this.class += " s-btn-disabled";
                    this.confirm = false;
                    return this.disabledtext;
                }
                return "";
            };
            this.getConfirm = () => {
                if (angular.isDefined(this.confirm) && this.confirm) {
                    return true;
                }
                else {
                    return false;
                }
            };
            this.getConfirmText = () => {
                if (this.getConfirm()) {
                    if (angular.isUndefined(this.confirmtext) && this.confirmtext.length) {
                        var confirmrbkey = this.utilityService.replaceAll(this.action, ':', '.') + '_confirm';
                        this.confirmtext = $slatwall.getRBKey(confirmrbkey);
                    }
                    this.class += " alert-confirm";
                    return this.confirm;
                }
                return "";
            };
            this.$slatwall = $slatwall;
            this.utilityService = utilityService;
            //need to perform init after promise completes
            this.init();
        }
    }
    slatwalladmin.SWActionCallerController = SWActionCallerController;
    class SWActionCaller {
        constructor(partialsPath, utiltiyService, $slatwall) {
            this.partialsPath = partialsPath;
            this.utiltiyService = utiltiyService;
            this.$slatwall = $slatwall;
            this.restrict = 'E';
            this.scope = {};
            this.transclude = true;
            this.bindToController = {
                action: "@",
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
            this.link = (scope, element, attrs) => {
            };
            this.templateUrl = partialsPath + 'actioncaller.html';
        }
    }
    slatwalladmin.SWActionCaller = SWActionCaller;
    angular.module('slatwalladmin').directive('swActionCaller', ['partialsPath', 'utilityService', '$slatwall', (partialsPath, utilityService, $slatwall) => new SWActionCaller(partialsPath, utilityService, $slatwall)]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/common/swactioncaller.js.map