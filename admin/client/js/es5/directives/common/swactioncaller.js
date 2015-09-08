/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var SWActionCallerController = (function () {
        function SWActionCallerController(utilityService, $slatwall) {
            //if text is blank or undefined
            //if(angular.isUndefined(this.text) || (angular.isDefined(this.text) && this.text.length && angular.isUndefined(this.icon))){
            //get rbkey for type
            /*
            <cfset attributes.text = attributes.hibachiScope.rbKey("#Replace(attributes.action, ":", ".", "all")#_nav") />
            
            <cfif right(attributes.text, 8) eq "_missing" >
                
                <cfif left(actionItem, 4) eq "list" and len(actionItem) gt 4>
                    <cfset attributes.text = replace(attributes.hibachiScope.rbKey('admin.define.list_nav'), "${itemEntityNamePlural}", attributes.hibachiScope.rbKey('entity.#actionItemEntityName#_plural'), "all") />
                <cfelseif left(actionItem, 4) eq "edit" and len(actionItem) gt 4>
                    <cfset attributes.text = replace(attributes.hibachiScope.rbKey('admin.define.edit_nav'), "${itemEntityName}", attributes.hibachiScope.rbKey('entity.#actionItemEntityName#'), "all") />
                <cfelseif left(actionItem, 4) eq "save" and len(actionItem) gt 4>
                    <cfset attributes.text = replace(attributes.hibachiScope.rbKey('admin.define.save_nav'), "${itemEntityName}", attributes.hibachiScope.rbKey('entity.#actionItemEntityName#'), "all") />
                <cfelseif left(actionItem, 6) eq "create" and len(actionItem) gt 6>
                    <cfset attributes.text = replace(attributes.hibachiScope.rbKey('admin.define.create_nav'), "${itemEntityName}", attributes.hibachiScope.rbKey('entity.#actionItemEntityName#'), "all") />
                <cfelseif left(actionItem, 6) eq "detail" and len(actionItem) gt 6>
                    <cfset attributes.text = replace(attributes.hibachiScope.rbKey('admin.define.detail_nav'), "${itemEntityName}", attributes.hibachiScope.rbKey('entity.#actionItemEntityName#'), "all") />
                <cfelseif left(actionItem, 6) eq "delete" and len(actionItem) gt 6>
                    <cfset attributes.text = replace(attributes.hibachiScope.rbKey('admin.define.delete_nav'), "${itemEntityName}", attributes.hibachiScope.rbKey('entity.#actionItemEntityName#'), "all") />
                </cfif>
            
            </cfif>
            
            <cfif right(attributes.text, 8) eq "_missing" >
                <cfset attributes.text = attributes.hibachiScope.rbKey("#Replace(attributes.action, ":", ".", "all")#") />
            </cfif>*/
            //}
            var _this = this;
            this.utilityService = utilityService;
            this.$slatwall = $slatwall;
            this.getAction = function () {
                return _this.action || '';
            };
            this.getActionItem = function () {
                return _this.utilityService.listLast(_this.getAction(), '.');
            };
            this.getActionItemEntityName = function () {
                var firstFourLetters = _this.utilityService.left(_this.getActionItem(), 4);
                var firstSixLetters = _this.utilityService.left(_this.getActionItem(), 6);
                var minus4letters = _this.utilityService.right(_this.getActionItem(), 4);
                var minus6letters = _this.utilityService.right(_this.getActionItem(), 6);
                var actionItemEntityName = "";
                if (firstFourLetters === 'list' && _this.getActionItem().length > 4) {
                    actionItemEntityName = minus4letters;
                }
                else if (firstFourLetters === 'edit' && _this.getActionItem().length > 4) {
                    actionItemEntityName = minus4letters;
                }
                else if (firstFourLetters === 'save' && _this.getActionItem().length > 4) {
                    actionItemEntityName = minus4letters;
                }
                else if (firstSixLetters === 'create' && _this.getActionItem().length > 6) {
                    actionItemEntityName = minus6letters;
                }
                else if (firstSixLetters === 'detail' && _this.getActionItem().length > 6) {
                    actionItemEntityName = minus6letters;
                }
                else if (firstSixLetters === 'delete' && _this.getActionItem().length > 6) {
                    actionItemEntityName = minus6letters;
                }
                return actionItemEntityName;
            };
            this.getTitle = function () {
                //if title is undefined then use text
                if (angular.isUndefined(_this.title) || !_this.title.length) {
                    _this.title = _this.text;
                }
                return _this.title;
            };
            this.getTextByRBKeyByAction = function (actionItemType, plural) {
                if (plural === void 0) { plural = false; }
                var navRBKey = _this.$slatwall.getRBKey('admin.define.' + actionItemType + '_nav');
                if (plural) {
                    var entityRbKey = _this.$slatwall('entity.' + _this.getActionItemEntityName() + '_plural');
                    var replaceKey = '${itemEntityNamePlural}';
                }
                else {
                    var entityRbKey = _this.$slatwall('entity.' + _this.getActionItemEntityName());
                    var replaceKey = '${itemEntityName}';
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
                        var firstFourLetters = _this.utilityService.left(_this.getActionItem(), 4);
                        var firstSixLetters = _this.utilityService.left(_this.getActionItem(), 6);
                        var minus4letters = _this.utilityService.right(_this.getActionItem(), 4);
                        var minus6letters = _this.utilityService.right(_this.getActionItem(), 6);
                        if (firstFourLetters === 'list' && _this.getActionItem().length > 4) {
                            _this.text = _this.getTextByRBKeyByAction('list', true);
                        }
                        else if (firstFourLetters === 'edit' && _this.getActionItem().length > 4) {
                            var navRBKey = _this.$slatwall.getRBKey('admin.define.edit_nav');
                            var entityRbKey = _this.$slatwall('entity.' + _this.getActionItemEntityName());
                            _this.text = _this.utilityService.replaceAll(navRBKey, '${itemEntityName}', entityRBKey);
                        }
                        else if (firstFourLetters === 'save' && _this.getActionItem().length > 4) {
                            var navRBKey = _this.$slatwall.getRBKey('admin.define.save_nav');
                            var entityRbKey = _this.$slatwall('entity.' + _this.getActionItemEntityName());
                            _this.text = _this.utilityService.replaceAll(navRBKey, '${itemEntityName}', entityRBKey);
                        }
                        else if (firstSixLetters === 'create' && _this.getActionItem().length > 6) {
                            var navRBKey = _this.$slatwall.getRBKey('admin.define.create_nav');
                            var entityRbKey = _this.$slatwall('entity.' + _this.getActionItemEntityName());
                            _this.text = _this.utilityService.replaceAll(navRBKey, '${itemEntityName}', entityRBKey);
                        }
                        else if (firstSixLetters === 'detail' && _this.getActionItem().length > 6) {
                            actionItemEntityName = minus6letters;
                        }
                        else if (firstSixLetters === 'delete' && _this.getActionItem().length > 6) {
                            actionItemEntityName = minus6letters;
                        }
                    }
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
            /*
            <cfif attributes.modal && not attributes.disabled && not attributes.modalFullWidth >
                <cfset attributes.class &= " modalload" />
            </cfif>
            
            <cfif not attributes.hibachiScope.authenticateAction(action=attributes.action)>
                <cfset attributes.class &= " disabled" />
            </cfif>
            */
            /*
            <cfif attributes.hibachiScope.authenticateAction(action=attributes.action) || (attributes.type eq "link" && attributes.iconOnly)>
                <cfif attributes.type eq "link">
                    <cfoutput><a title="#attributes.title#" class="#attributes.class#" target="_self" href="#attributes.hibachiScope.buildURL(action=attributes.action,querystring=attributes.querystring)#"<cfif attributes.modal && not attributes.disabled> data-toggle="modal" data-target="##adminModal"</cfif><cfif attributes.disabled> data-disabled="#attributes.disabledtext#"<cfelseif attributes.confirm> data-confirm="#attributes.confirmtext#"</cfif><cfif len(attributes.id)>id="#attributes.id#"</cfif>>#attributes.icon##attributes.text#</a></cfoutput>
                <cfelseif attributes.type eq "list">
                    <cfoutput><li><a title="#attributes.title#" class="#attributes.class#" target="_self" href="#attributes.hibachiScope.buildURL(action=attributes.action,querystring=attributes.querystring)#"<cfif attributes.modal && not attributes.disabled> data-toggle="modal" data-target="##adminModal"</cfif><cfif attributes.disabled> data-disabled="#attributes.disabledtext#"<cfelseif attributes.confirm> data-confirm="#attributes.confirmtext#"</cfif><cfif len(attributes.id)>id="#attributes.id#"</cfif>>#attributes.icon##attributes.text#</a></li></cfoutput>
                <cfelseif attributes.type eq "button">
                    <cfoutput><button class="#attributes.class#" title="#attributes.title#"<cfif len(attributes.name)> name="#attributes.name#" value="#attributes.action#"</cfif><cfif attributes.modal && not attributes.disabled> data-toggle="modal" data-target="##adminModal"</cfif><cfif attributes.disabled> data-disabled="#attributes.disabledtext#"<cfelseif attributes.confirm> data-confirm="#attributes.confirmtext#"</cfif><cfif attributes.submit>type="submit"</cfif><cfif len(attributes.id)>id="#attributes.id#"</cfif>>#attributes.icon##attributes.text#</button></cfoutput>
                <cfelseif attributes.type eq "submit">
                    <cfoutput>This action caller type has been discontinued</cfoutput>
                </cfif>
            </cfif>
            */
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
            this.templateUrl = partialsPath + 'actioncaller.html';
        }
        return SWActionCaller;
    })();
    slatwalladmin.SWActionCaller = SWActionCaller;
    angular.module('slatwalladmin').directive('swActionCaller', ['partialsPath', 'utilityService', '$slatwall', function (partialsPath, utilityService, $slatwall) { return new SWActionCaller(partialsPath, utilityService, $slatwall); }]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/common/swactioncaller.js.map