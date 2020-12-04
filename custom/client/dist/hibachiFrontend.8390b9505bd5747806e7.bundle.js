(window["webpackJsonp_name_"] = window["webpackJsonp_name_"] || []).push([["hibachiFrontend"],{

/***/ "+8fp":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWProcessCaller = void 0;
var processCallerTemplateString = __webpack_require__("yFMl");
var SWProcessCallerController = /** @class */ (function () {
    //@ngInject
    SWProcessCallerController.$inject = ["rbkeyService", "$compile", "$scope", "$element", "$transclude", "$templateRequest", "utilityService"];
    function SWProcessCallerController(rbkeyService, $compile, $scope, $element, $transclude, $templateRequest, utilityService) {
        var _this = this;
        this.rbkeyService = rbkeyService;
        this.$compile = $compile;
        this.$scope = $scope;
        this.$element = $element;
        this.$transclude = $transclude;
        this.$templateRequest = $templateRequest;
        this.utilityService = utilityService;
        this.type = this.type || 'link';
        this.queryString = this.queryString || '';
        this.$templateRequest('processCallerTemplateString').then(function (html) {
            var template = angular.element(html);
            _this.$element.parent().append(template);
            $compile(template)(_this.$scope);
        });
        if (angular.isDefined(this.titleRbKey)) {
            this.title = this.rbkeyService.getRBKey(this.titleRbKey);
        }
        if (angular.isUndefined(this.title) && angular.isDefined(this.processContext)) {
            var entityName = this.action.split('.')[1].replace('process', '');
            this.title = this.rbkeyService.getRBKey('entity.' + entityName + '.process.' + this.processContext);
        }
        if (angular.isUndefined(this.text)) {
            this.text = this.title;
        }
    }
    return SWProcessCallerController;
}());
var SWProcessCaller = /** @class */ (function () {
    // @ngInject;
    SWProcessCaller.$inject = ["$templateCache"];
    function SWProcessCaller($templateCache) {
        this.$templateCache = $templateCache;
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
            title: "@?",
            titleRbKey: "@?",
            'class': "@",
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
    }
    SWProcessCaller.Factory = function () {
        var _this = this;
        return /** @ngInject; */ ["$templateCache", function ($templateCache) {
            if (!$templateCache.get('processCallerTemplateString')) {
                $templateCache.put('processCallerTemplateString', processCallerTemplateString);
            }
            return new _this($templateCache);
        }];
    };
    return SWProcessCaller;
}());
exports.SWProcessCaller = SWProcessCaller;


/***/ }),

/***/ "+WG+":
/***/ (function(module, exports) {

module.exports = "<div class=\"s-tab-table\">\n    <div class=\"row s-tabs\">\n        <ul class=\"nav nav-tabs\" role=\"tablist\"> \n            <li role=\"presentation\" \n                ng-repeat=\"tab in swTabGroup.tabs track by $index\"\n                ng-class=\"{'active':tab.active}\" \n                ng-show=\"!tab.hide\">\n                <a ng-click=\"swTabGroup.switchTab(tab)\" role=\"tab\" data-toggle=\"tab\" aria-controls=\"{{tab.name}}\" aria-expanded=\"true\"><span ng-bind=\"tab.name\"></span></a>\n            </li> \n        </ul> \n    </div>\n    <div class=\"tab-content\">\n        <!-- Tab Content Here -->\n        <ng-transclude></ng-transclude>\n    </div> \n</div>";

/***/ }),

/***/ "+hUe":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWSelection = void 0;
var SWSelectionController = /** @class */ (function () {
    //@ngInject
    SWSelectionController.$inject = ["selectionService", "observerService"];
    function SWSelectionController(selectionService, observerService) {
        var _this = this;
        this.selectionService = selectionService;
        this.observerService = observerService;
        this.updateSelectValue = function (res) {
            if (_this.isRadio && (res.action == 'check')) {
                _this.toggleValue == _this.selection;
            }
            else if (res.action == 'clear') {
                _this.toggleValue = false;
            }
            else if (res.action == 'selectAll') {
                _this.toggleValue = true;
            }
            else if (res.selection == _this.selection) {
                _this.toggleValue = (res.action == 'check');
            }
        };
        this.toggleSelection = function (toggleValue, selectionid, selection) {
            if (_this.isRadio) {
                _this.selectionService.radioSelection(selectionid, selection);
                _this.toggleValue = selection;
            }
            else {
                if (toggleValue) {
                    _this.selectionService.addSelection(selectionid, selection);
                }
                else {
                    _this.selectionService.removeSelection(selectionid, selection);
                }
            }
        };
        if (angular.isUndefined(this.name)) {
            this.name = 'selection';
        }
        if (selectionService.isAllSelected(this.selectionid)) {
            this.toggleValue = !selectionService.hasSelection(this.selectionid, this.selection);
        }
        else {
            this.toggleValue = selectionService.hasSelection(this.selectionid, this.selection);
        }
        if (this.isRadio && this.toggleValue) {
            this.toggleValue = this.selection;
        }
        if (this.isRadio && this.toggleValue) {
            this.toggleValue = this.selection;
        }
        //attach observer so we know when a selection occurs
        observerService.attach(this.updateSelectValue, 'swSelectionToggleSelection' + this.selectionid);
        if (angular.isDefined(this.initSelected) && this.initSelected) {
            this.toggleValue = this.selection;
            this.toggleSelection(this.toggleValue, this.selectionid, this.selection);
        }
    }
    return SWSelectionController;
}());
var SWSelection = /** @class */ (function () {
    function SWSelection() {
        this.restrict = 'E';
        this.scope = {};
        this.bindToController = {
            selection: "=",
            selectionid: "@",
            id: "=",
            isRadio: "=",
            name: "@",
            disabled: "=",
            initSelected: "="
        };
        this.controller = SWSelectionController;
        this.controllerAs = 'swSelection';
        this.template = __webpack_require__("4IhF");
    }
    SWSelection.Factory = function () {
        var _this = this;
        return /** @ngInject; */ function () { return new _this(); };
    };
    return SWSelection;
}());
exports.SWSelection = SWSelection;


/***/ }),

/***/ "+t+j":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.FrontendController = void 0;
var FrontendController = /** @class */ (function () {
    function FrontendController($scope, $element, $log, $hibachi, collectionConfigService, selectionService) {
        this.$scope = $scope;
        this.$element = $element;
        this.$log = $log;
        this.$hibachi = $hibachi;
        this.collectionConfigService = collectionConfigService;
        this.selectionService = selectionService;
    }
    return FrontendController;
}());
exports.FrontendController = FrontendController;


/***/ }),

/***/ "/9HY":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWScrollTrigger = void 0;
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWScrollTrigger = /** @class */ (function () {
    // 	@ngInject;
    SWScrollTrigger.$inject = ["$rootScope", "$window", "$timeout"];
    function SWScrollTrigger($rootScope, $window, $timeout) {
        return {
            link: function (scope, elem, attrs) {
                var checkWhenEnabled, handler, scrollDistance, scrollEnabled;
                $window = angular.element($window);
                scrollDistance = 0;
                if (attrs.infiniteScrollDistance != null) {
                    scope
                        .$watch(attrs.infiniteScrollDistance, function (value) {
                        return scrollDistance = parseInt(value, 10);
                    });
                }
                scrollEnabled = true;
                checkWhenEnabled = false;
                if (attrs.infiniteScrollDisabled != null) {
                    scope
                        .$watch(attrs.infiniteScrollDisabled, function (value) {
                        scrollEnabled = !value;
                        if (scrollEnabled
                            && checkWhenEnabled) {
                            checkWhenEnabled = false;
                            return handler();
                        }
                    });
                }
                handler = function () {
                    var elementBottom, remaining, shouldScroll, windowBottom;
                    windowBottom = $window.height()
                        + $window.scrollTop();
                    elementBottom = elem.offset().top
                        + elem.height();
                    remaining = elementBottom
                        - windowBottom;
                    shouldScroll = remaining <= $window
                        .height()
                        * scrollDistance;
                    if (shouldScroll && scrollEnabled) {
                        if ($rootScope.$$phase) {
                            return scope
                                .$eval(attrs.infiniteScroll);
                        }
                        else {
                            return scope
                                .$apply(attrs.infiniteScroll);
                        }
                    }
                    else if (shouldScroll) {
                        return checkWhenEnabled = true;
                    }
                };
                $window.on('scroll', handler);
                scope.$on('$destroy', function () {
                    return $window.off('scroll', handler);
                });
                return $timeout((function () {
                    if (attrs.infiniteScrollImmediateCheck) {
                        if (scope
                            .$eval(attrs.infiniteScrollImmediateCheck)) {
                            return handler();
                        }
                    }
                    else {
                        return handler();
                    }
                }), 0);
            }
        };
    }
    SWScrollTrigger.Factory = function () {
        var directive = function ($rootScope, $window, $timeout) { return new SWScrollTrigger($rootScope, $window, $timeout); };
        directive.$inject = [
            '$rootScope',
            '$window',
            '$timeout'
        ];
        return directive;
    };
    return SWScrollTrigger;
}());
exports.SWScrollTrigger = SWScrollTrigger;


/***/ }),

/***/ "/Gm/":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.PublicRequest = void 0;
/// <reference path='../../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../typings/tsd.d.ts' />
var request_1 = __webpack_require__("92bl");
var PublicRequest = /** @class */ (function (_super) {
    __extends(PublicRequest, _super);
    function PublicRequest(url, data, method, headers, $injector, observerService) {
        if (headers === void 0) { headers = { 'Content-Type': "application/x-www-form-urlencoded" }; }
        var _this = _super.call(this, url, data, method, headers, $injector) || this;
        _this.observerService = observerService;
        _this.failureActions = [];
        _this.successfulActions = [];
        _this.messages = [];
        _this.hasSuccessfulAction = function () {
            return _this.successfulActions.length > 0;
        };
        _this.hasFailureAction = function () {
            return _this.failureActions.length > 0;
        };
        _this.observerService = observerService;
        _this.promise.then(function (result) {
            _this.successfulActions = result.successfulActions;
            for (var i in _this.successfulActions) {
                var successfulAction = _this.successfulActions[i];
                var data_1 = result.data ? result.data : result;
                _this.observerService.notify(successfulAction.split('.')[1] + 'Success', data_1);
            }
            _this.failureActions = result.failureActions;
            for (var i in _this.failureActions) {
                var failureAction = _this.failureActions[i];
                var data_2 = result.data ? result.data : result;
                _this.observerService.notify(failureAction.split('.')[1] + 'Failure', data_2);
            }
            _this.messages = result.messages;
        }).catch(function (response) {
        });
        return _this;
    }
    return PublicRequest;
}(request_1.Request));
exports.PublicRequest = PublicRequest;


/***/ }),

/***/ "/fWz":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.OrdinalFilter = void 0;
var OrdinalFilter = /** @class */ (function () {
    function OrdinalFilter() {
    }
    OrdinalFilter.Factory = function () {
        return function (input) {
            var suffixes = ['th', 'st', 'nd', 'rd'];
            var relevantDigits = (input < 30) ? input % 20 : input % 30;
            var suffix = (relevantDigits <= 3) ? suffixes[relevantDigits] : suffixes[0];
            return input + suffix;
        };
    };
    return OrdinalFilter;
}());
exports.OrdinalFilter = OrdinalFilter;


/***/ }),

/***/ "/i+c":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.OrderService = void 0;
var baseentityservice_1 = __webpack_require__("P6y0");
var OrderService = /** @class */ (function (_super) {
    __extends(OrderService, _super);
    //@ngInject
    OrderService.$inject = ["$injector", "$hibachi", "utilityService"];
    function OrderService($injector, $hibachi, utilityService) {
        var _this = _super.call(this, $injector, $hibachi, utilityService, 'Order') || this;
        _this.$injector = $injector;
        _this.$hibachi = $hibachi;
        _this.utilityService = utilityService;
        _this.newOrder_AddOrderPayment = function () {
            return _this.newProcessObject('Order_AddOrderPayment');
        };
        return _this;
    }
    return OrderService;
}(baseentityservice_1.BaseEntityService));
exports.OrderService = OrderService;


/***/ }),

/***/ "/pQj":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/**
 * <------------------------------------------------------------------------------------------------------------------------------------>
 *   This directive can be used to prompt the user with a confirmation dialog.
 *
 *   Example Usage 1:
 *   <a swconfirm
 *   						use-rb-key=true
 * 							yes-text="define.yes"
 * 							no-text="define.no"
 * 							confirm-text="define.confirm"
 * 							message-text="define.delete.message"
 * 							callback="someFunction()">
 *   </a>
 *   Alternate Version (No Rbkeys):
 *   <a swconfirm
 *   						use-rb-key=false
 * 							yes-text="Sure"
 * 							no-text="Not Sure!"
 * 							confirm-text="Sure"
 * 							message-text="Are you sure?"
 * 							callback="sure()">
 *   </a>
 *
 *   Note: Because the template is dynamic, the following keywords can not be used anywhere in the text for this modal as we interpolate
 *   those.
 *
 *   [yes] [no] [confirm] [message] [callback]
 *
 *   The above words in upper-case can be used - just not those words inside square brackets.
 *   Note: Your callback function on-confirm should return true;
 *<------------------------------------------------------------------------------------------------------------------------------------->
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWConfirm = void 0;
var SWConfirm = /** @class */ (function () {
    //@ngInject
    SWConfirm.$inject = ["$log", "$modal"];
    function SWConfirm($log, $modal) {
        var buildConfirmationModal = function (simple, useRbKey, confirmText, messageText, noText, yesText) {
            /* Keys */
            var confirmKey = "[confirm]";
            var messageKey = "[message]";
            var noKey = "[no]";
            var yesKey = "[yes]";
            var swRbKey = "sw-rbkey=";
            /* Values */
            var confirmVal = "<confirm>";
            var messageVal = "<message>";
            var noVal = "<no>";
            var yesVal = "<yes>";
            /* Parse Tags */
            var startTag = "\"'";
            var endTag = "'\"";
            var startParen = "'";
            var endParen = "'";
            var empty = "";
            /* Modal String */
            var parsedKeyString = "";
            var finishedString = "";
            //Figure out which version of this tag we are using
            var templateString = "<div>" +
                "<div class='modal-header'><a class='close' data-dismiss='modal' ng-click='cancel()'>×</a><h3 [confirm]><confirm></h3></div>" +
                "<div class='modal-body' [message]>" + "<message>" + "</div>" +
                "<div class='modal-footer'>" +
                "<button class='btn btn-sm btn-default btn-inverse' ng-click='cancel()' [no]><no></button>" +
                "<button class='btn btn-sm btn-default btn-primary' ng-click='fireCallback(callback)' [yes]><yes></button></div></div></div>";
            /* Use RbKeys or Not? */
            if (useRbKey === "true") {
                $log.debug("Using RbKey? " + useRbKey);
                /* Then decorate the template with the keys. */
                confirmText = swRbKey + startTag + confirmText + endTag;
                messageText = swRbKey + startTag + messageText + endTag;
                yesText = swRbKey + startTag + yesText + endTag;
                noText = swRbKey + startTag + noText + endTag;
                parsedKeyString = templateString.replace(confirmKey, confirmText)
                    .replace(messageKey, messageText)
                    .replace(noKey, noText)
                    .replace(yesKey, yesText);
                $log.debug(finishedString);
                finishedString = parsedKeyString.replace(confirmKey, empty)
                    .replace(messageVal, empty)
                    .replace(noVal, empty)
                    .replace(yesVal, empty);
                $log.debug(finishedString);
                return finishedString;
            }
            else {
                /* Then decorate the template without the keys. */
                $log.debug("Using RbKey? " + useRbKey);
                parsedKeyString = templateString.replace(confirmVal, confirmText)
                    .replace(messageVal, messageText)
                    .replace(noVal, noText)
                    .replace(yesVal, yesText);
                finishedString = parsedKeyString.replace(confirmKey, empty)
                    .replace(messageKey, empty)
                    .replace(noKey, empty)
                    .replace(yesKey, empty);
                $log.debug(finishedString);
                return finishedString;
            }
        };
        return {
            restrict: 'EA',
            scope: {
                callback: "&",
                entity: "="
            },
            link: function (scope, element, attr) {
                /* Grab the template and build the modal on click */
                $log.debug("Modal is: ");
                $log.debug($modal);
                element.bind('click', function () {
                    /* Default Values */
                    var useRbKey = attr.useRbKey || "false";
                    var simple = attr.simple || false;
                    var yesText = attr.yesText || "define.yes";
                    var noText = attr.noText || "define.no";
                    var confirmText = attr.confirmText || "define.delete";
                    var messageText = attr.messageText || "define.delete_message";
                    var templateString = buildConfirmationModal(simple, useRbKey, confirmText, messageText, noText, yesText);
                    var modalInstance = $modal.open({
                        template: templateString,
                        controller: 'confirmationController',
                        scope: scope
                    });
                    /**
                        * Handles the result - callback or dismissed
                        */
                    modalInstance.result.then(function (result) {
                        $log.debug("Result:" + result);
                        return true;
                    }, function () {
                        //There was an error
                    });
                }); //<--end bind
            }
        };
    }
    SWConfirm.Factory = function () {
        var directive = function ($log, $modal) { return new SWConfirm($log, $modal); };
        directive.$inject = ['$log', '$modal'];
        return directive;
    };
    return SWConfirm;
}());
exports.SWConfirm = SWConfirm;


/***/ }),

/***/ "/xF6":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWCurrencyFormatter = void 0;
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWCurrencyFormatter = /** @class */ (function () {
    // @ngInject;
    SWCurrencyFormatter.$inject = ["$filter", "$timeout"];
    function SWCurrencyFormatter($filter, $timeout) {
        var _this = this;
        this.$filter = $filter;
        this.$timeout = $timeout;
        this.restrict = "A";
        this.require = "ngModel";
        this.scope = {
            ngModel: '=',
            currencyCode: '@?',
            locale: '@?'
        };
        this.link = function ($scope, element, attrs, modelCtrl) {
            if (element[0].nodeName == 'INPUT') {
                $scope.locale = 'en-us';
            }
            modelCtrl.$parsers.push(function (data) {
                var currencyFilter = _this.$filter('swcurrency');
                if (_this._timeoutPromise) {
                    _this.$timeout.cancel(_this._timeoutPromise);
                }
                _this._timeoutPromise = _this.$timeout(function () {
                    modelCtrl.$setViewValue(currencyFilter(data, $scope.currencyCode, 2, false, $scope.locale));
                    modelCtrl.$render();
                }, 1500);
                return modelCtrl.$viewValue;
            });
            modelCtrl.$formatters.push(function (data) {
                var currencyFilter = _this.$filter('swcurrency');
                modelCtrl.$setViewValue(currencyFilter(data, $scope.currencyCode, 2, false, $scope.locale));
                modelCtrl.$render();
                return modelCtrl.$viewValue;
            });
        };
    }
    SWCurrencyFormatter.Factory = function () {
        var _this = this;
        return /** @ngInject; */ ["$filter", "$timeout", function ($filter, $timeout) { return new _this($filter, $timeout); }];
    };
    return SWCurrencyFormatter;
}());
exports.SWCurrencyFormatter = SWCurrencyFormatter;


/***/ }),

/***/ "0060":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path="../../../../../../node_modules/typescript/lib/lib.es6.d.ts" />
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var __assign = (this && this.__assign) || function () {
    __assign = Object.assign || function(t) {
        for (var s, i = 1, n = arguments.length; i < n; i++) {
            s = arguments[i];
            for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p))
                t[p] = s[p];
        }
        return t;
    };
    return __assign.apply(this, arguments);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.TypeaheadService = void 0;
var TypeaheadStore = __webpack_require__("Jw3Q");
var TypeaheadService = /** @class */ (function () {
    //@ngInject
    TypeaheadService.$inject = ["$timeout", "observerService"];
    function TypeaheadService($timeout, observerService) {
        var _this = this;
        this.$timeout = $timeout;
        this.observerService = observerService;
        this.typeaheadData = {};
        this.typeaheadPromises = {};
        //The state of the store
        this.typeaheadStates = {};
        this.state = {
            typeaheadInstances: this.typeaheadStates
        };
        /**
         * The reducer is responsible for modifying the state of the state object into a new state.
         */
        this.typeaheadStateReducer = function (state, action) {
            switch (action.type) {
                case 'TYPEAHEAD_QUERY':
                    //modify the state.
                    return __assign(__assign({}, state), { action: action });
                case 'TYPEAHEAD_USER_SELECTION':
                    //passthrough - no state change. anyone subscribed can handle this.
                    return __assign(__assign({}, state), { action: action });
                default:
                    return state;
            }
        };
        this.getTypeaheadSelectionUpdateEvent = function (key) {
            return "typeaheadSelectionUpdated" + key;
        };
        this.getTypeaheadClearSearchEvent = function (key) {
            return key + "clearSearch";
        };
        this.attachTypeaheadSelectionUpdateEvent = function (key, callback) {
            _this.observerService.attach(callback, _this.getTypeaheadSelectionUpdateEvent(key));
        };
        this.notifyTypeaheadSelectionUpdateEvent = function (key, data) {
            _this.observerService.notify(_this.getTypeaheadSelectionUpdateEvent(key), data);
        };
        this.notifyTypeaheadClearSearchEvent = function (key, data) {
            _this.observerService.notify(_this.getTypeaheadClearSearchEvent(key), data);
        };
        this.setTypeaheadState = function (key, state) {
            _this.typeaheadStates[key] = state;
        };
        this.getTypeaheadState = function (key) {
            return _this.typeaheadStates[key];
        };
        this.getTypeaheadPrimaryIDPropertyName = function (key) {
            return _this.getTypeaheadState(key).primaryIDPropertyName;
        };
        this.getIndexOfSelection = function (key, data) {
            for (var j = 0; j < _this.getData(key).length; j++) {
                if (angular.isDefined(data[_this.getTypeaheadPrimaryIDPropertyName(key)]) &&
                    data[_this.getTypeaheadPrimaryIDPropertyName(key)] == _this.getData(key)[j][_this.getTypeaheadPrimaryIDPropertyName(key)]) {
                    return j;
                }
                else if (_this.checkAgainstFallbackProperties(key, _this.getData(key)[j], data)) {
                    return j;
                }
            }
            return -1;
        };
        this.addSelection = function (key, data) {
            if (angular.isUndefined(_this.typeaheadData[key])) {
                _this.typeaheadData[key] = [];
            }
            _this.typeaheadData[key].push(data);
            _this.notifyTypeaheadSelectionUpdateEvent(key, data);
        };
        this.removeSelection = function (key, index, data) {
            if (angular.isUndefined(index) &&
                angular.isDefined(data)) {
                index = _this.getIndexOfSelection(key, data);
            }
            if (angular.isDefined(index) &&
                angular.isDefined(_this.typeaheadData[key]) &&
                index != -1) {
                _this.updateSelections(key);
                var removedItem = _this.typeaheadData[key].splice(index, 1)[0]; //this will always be an array of 1 element
                _this.notifyTypeaheadSelectionUpdateEvent(key, removedItem);
                return removedItem;
            }
        };
        this.initializeSelections = function (key, selectedCollectionConfig) {
            selectedCollectionConfig.setAllRecords(true);
            _this.typeaheadPromises[key] = selectedCollectionConfig.getEntity();
            _this.typeaheadPromises[key].then(function (data) {
                for (var j = 0; j < data.records.length; j++) {
                    _this.addSelection(key, data.records[j]);
                }
            }, function (reason) {
                throw ("typeaheadservice had trouble intializing selections for " + key + " because " + reason);
            });
        };
        this.updateSelections = function (key) {
            if (angular.isDefined(_this.getData(key)) && _this.getData(key).length) {
                for (var j = 0; j < _this.getTypeaheadState(key).results.length; j++) {
                    for (var i = 0; i < _this.getData(key).length; i++) {
                        if (_this.getData(key)[i][_this.getTypeaheadPrimaryIDPropertyName(key)] == _this.getTypeaheadState(key).results[j][_this.getTypeaheadPrimaryIDPropertyName(key)]) {
                            _this.markResultSelected(_this.getTypeaheadState(key).results[j], i);
                            break;
                        }
                        var found = _this.checkAgainstFallbackProperties(key, _this.getData(key)[i], _this.getTypeaheadState(key).results[j], i);
                        if (found) {
                            break;
                        }
                    }
                }
            }
        };
        this.markResultSelected = function (result, index) {
            result.selected = true;
            result.selectedIndex = index;
        };
        this.checkAgainstFallbackProperties = function (key, selection, result, selectionIndex) {
            var resultPrimaryID = result[_this.getTypeaheadPrimaryIDPropertyName(key)];
            //is there a singular property to compare against
            if (angular.isDefined(_this.getTypeaheadState(key).propertyToCompare) &&
                _this.getTypeaheadState(key).propertyToCompare.length) {
                if (angular.isDefined(selection[_this.getTypeaheadState(key).propertyToCompare]) &&
                    selection[_this.getTypeaheadState(key).propertyToCompare] == resultPrimaryID) {
                    if (angular.isDefined(selectionIndex)) {
                        _this.markResultSelected(result, selectionIndex);
                    }
                    return true;
                }
                if (angular.isDefined(selection[_this.getTypeaheadState(key).propertyToCompare]) &&
                    angular.isDefined(result[_this.getTypeaheadState(key).propertyToCompare]) &&
                    selection[_this.getTypeaheadState(key).propertyToCompare] == result[_this.getTypeaheadState(key).propertyToCompare]) {
                    if (angular.isDefined(selectionIndex)) {
                        _this.markResultSelected(result, selectionIndex);
                    }
                    return true;
                }
            }
            //check the defined fallback properties to see if theres a match
            if (_this.getTypeaheadState(key).fallbackPropertyArray.length > 0) {
                for (var j = 0; j < _this.getTypeaheadState(key).fallbackPropertyArray.length; j++) {
                    var property = _this.getTypeaheadState(key).fallbackPropertyArray[j];
                    if (angular.isDefined(selection[property])) {
                        if (selection[property] == resultPrimaryID) {
                            if (angular.isDefined(selectionIndex)) {
                                _this.markResultSelected(result, selectionIndex);
                            }
                            return true;
                        }
                        if (angular.isDefined(result[property]) &&
                            selection[property] == result[property]) {
                            if (angular.isDefined(selectionIndex)) {
                                _this.markResultSelected(result, selectionIndex);
                            }
                            return true;
                        }
                    }
                }
            }
            return false;
        };
        this.updateSelectionList = function (key) {
            var selectionIDArray = [];
            if (angular.isDefined(_this.getData(key))) {
                for (var j = 0; j < _this.getData(key).length; j++) {
                    var selection = _this.getData(key)[j];
                    var primaryID = selection[_this.getTypeaheadPrimaryIDPropertyName(key)];
                    if (angular.isDefined(primaryID)) {
                        selectionIDArray.push(primaryID);
                    }
                    else if (angular.isDefined(_this.getTypeaheadState(key).propertyToCompare) &&
                        angular.isDefined(selection[_this.getTypeaheadState(key).propertyToCompare])) {
                        selectionIDArray.push(selection[_this.getTypeaheadState(key).propertyToCompare]);
                    }
                    else if (angular.isDefined(_this.getTypeaheadState(key).fallbackPropertyArray)) {
                        var fallbackPropertyArray = _this.getTypeaheadState(key).fallbackPropertyArray;
                        for (var i = 0; i < fallbackPropertyArray.length; i++) {
                            var fallbackProperty = fallbackPropertyArray[i];
                            if (angular.isDefined(selection[fallbackProperty])) {
                                selectionIDArray.push(selection[fallbackProperty]);
                                break;
                            }
                        }
                    }
                }
            }
            return selectionIDArray.join(",");
        };
        this.getData = function (key) {
            if (key in _this.typeaheadPromises) {
                //wait until it's been intialized
                _this.typeaheadPromises[key].then().finally(function () {
                    return _this.typeaheadData[key] || [];
                });
                delete _this.typeaheadPromises[key];
            }
            else {
                return _this.typeaheadData[key] || [];
            }
        };
        //strips out dangerous directives that cause infinite compile errors 
        // - this probably belongs in a different service but is used for typeahead only at the moment
        this.stripTranscludedContent = function (transcludedContent) {
            for (var i = 0; i < transcludedContent.length; i++) {
                if (angular.isDefined(transcludedContent[i].localName) &&
                    transcludedContent[i].localName == 'ng-transclude') {
                    transcludedContent = transcludedContent.children();
                }
            }
            //prevent collection config from being recompiled
            for (var i = 0; i < transcludedContent.length; i++) {
                if (angular.isDefined(transcludedContent[i].localName) &&
                    transcludedContent[i].localName == 'sw-collection-config') {
                    transcludedContent.splice(i, 1);
                }
            }
            return transcludedContent;
        };
        this.typeaheadStore = new TypeaheadStore.IStore(this.state, this.typeaheadStateReducer); //.combineLatest(this.loggerEpic)
    }
    return TypeaheadService;
}());
exports.TypeaheadService = TypeaheadService;


/***/ }),

/***/ "0LCg":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWEntityActionBar = void 0;
var SWEntityActionBarController = /** @class */ (function () {
    //@ngInject
    SWEntityActionBarController.$inject = ["observerService", "rbkeyService"];
    function SWEntityActionBarController(observerService, rbkeyService) {
        var _this = this;
        this.observerService = observerService;
        this.rbkeyService = rbkeyService;
        this.$onInit = function () {
            if (_this.edit == null) {
                _this.edit = false;
            }
            if (_this.showDelete == null) {
                _this.showDelete = true;
            }
            if (angular.isDefined(_this.pageTitleRbKey)) {
                _this.pageTitle = _this.rbkeyService.getRBKey(_this.pageTitleRbKey);
            }
            if (_this.entityActionDetails != null) {
                _this.backAction = _this.entityActionDetails.backAction;
                _this.cancelAction = _this.entityActionDetails.cancelAction;
                _this.deleteAction = _this.entityActionDetails.deleteAction;
                _this.editAction = _this.entityActionDetails.editAction;
                _this.saveAction = _this.entityActionDetails.saveAction;
            }
            _this.cancelQueryString = _this.cancelQueryString || '';
            _this.deleteQueryString = _this.deleteQueryString || '';
            _this.editQueryString = _this.editQueryString || '';
            _this.saveQueryString = _this.saveQueryString || '';
            if (_this.baseQueryString != null) {
                _this.cancelQueryString = _this.baseQueryString + _this.cancelQueryString;
                _this.editQueryString = _this.baseQueryString + _this.editQueryString;
                _this.deleteQueryString = _this.baseQueryString + _this.deleteQueryString;
                _this.saveQueryString = _this.baseQueryString + _this.saveQueryString;
                if (_this.processCallers != null) {
                    for (var i = 0; i < _this.processCallers.length; i++) {
                        _this.processCallers[i].queryString = _this.getQueryStringForProcessCaller(_this.processCallers[i]);
                    }
                }
                if (_this.printProcessCallers) {
                    for (var i = 0; i < _this.printProcessCallers.length; i++) {
                        _this.printProcessCallers[i].queryString = _this.getQueryStringForProcessCaller(_this.printProcessCallers[i]);
                    }
                }
            }
            _this.swProcessCallers = _this.processCallers;
            _this.swPrintProcessCallers = _this.printProcessCallers;
            if (_this.editEvent != null) {
                _this.observerService.attach(_this.toggleEditMode, _this.editEvent);
            }
            if (_this.cancelEvent != null) {
                _this.observerService.attach(_this.toggleEditMode, _this.cancelEvent);
            }
            if (_this.saveEvent != null) {
                _this.observerService.attach(_this.toggleEditMode, _this.saveEvent);
            }
            _this.payload = {
                'edit': _this.edit
            };
            //there should only be one action bar on a page so no id
            _this.observerService.notify('swEntityActionBar', _this.payload);
        };
        this.getQueryStringForProcessCaller = function (processCaller) {
            if (processCaller.queryString != null) {
                return _this.baseQueryString + '&' + processCaller.queryString;
            }
            return _this.baseQueryString;
        };
        this.toggleEditMode = function () {
            _this.edit = !_this.edit;
            _this.payload = {
                'edit': _this.edit
            };
            _this.observerService.notify('swEntityActionBar', _this.payload);
        };
    }
    return SWEntityActionBarController;
}());
var SWEntityActionBar = /** @class */ (function () {
    function SWEntityActionBar() {
        this.restrict = 'E';
        this.transclude = true;
        this.scope = {};
        this.bindToController = {
            /*Core settings*/
            type: "@",
            object: "=",
            pageTitle: "@?",
            pageTitleRbKey: "@?",
            edit: "=",
            entityActionDetails: "<?",
            baseQueryString: "@?",
            messages: "<?",
            /*Action Callers (top buttons)*/
            showCancel: "=",
            showCreate: "=",
            showEdit: "=",
            showDelete: "=",
            /*Basic Action Caller Overrides*/
            createEvent: "@?",
            createModal: "=",
            createAction: "@",
            createQueryString: "@",
            backEvent: "@?",
            backAction: "@?",
            backQueryString: "@?",
            cancelEvent: "@?",
            cancelAction: "@?",
            cancelQueryString: "@?",
            deleteEvent: "@?",
            deleteAction: "@?",
            deleteQueryString: "@?",
            editEvent: "@?",
            editAction: "@?",
            editQueryString: "@?",
            saveEvent: "@?",
            saveAction: "@?",
            saveQueryString: "@?",
            /*Process Specific Values*/
            processEvent: "@?",
            processAction: "@?",
            processContext: "@?",
            processCallers: "<?",
            printProcessCallers: "<?"
        };
        this.controller = SWEntityActionBarController;
        this.controllerAs = "swEntityActionBar";
        this.template = __webpack_require__("8R05");
    }
    SWEntityActionBar.Factory = function () {
        var _this = this;
        return /** @ngInject; */ function () { return new _this(); };
    };
    return SWEntityActionBar;
}());
exports.SWEntityActionBar = SWEntityActionBar;


/***/ }),

/***/ "1WeJ":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.RbKeyService = void 0;
var RbKeyService = /** @class */ (function () {
    //@ngInject
    RbKeyService.$inject = ["$http", "$q", "appConfig", "resourceBundles"];
    function RbKeyService($http, $q, appConfig, resourceBundles) {
        var _this = this;
        this.$http = $http;
        this.$q = $q;
        this.appConfig = appConfig;
        this.resourceBundles = resourceBundles;
        this._resourceBundle = {};
        this._resourceBundleLastModified = '';
        this._loadingResourceBundle = false;
        this._loadedResourceBundle = false;
        this.getRBLoaded = function () {
            return _this._loadedResourceBundle;
        };
        this.rbKey = function (key, replaceStringData) {
            var keyValue = _this.getRBKey(key, _this.appConfig.rbLocale);
            /**
             * const templateString = "Hello ${this.name}!";
               const replaceStringData = {
                    name: "world"
                }
             *
             */
            if (replaceStringData) {
                //coppied from  https://github.com/mikemaccana/dynamic-template
                keyValue = keyValue.replace(/\${(.*?)}/g, function (_, g) { return replaceStringData[g]; });
            }
            return keyValue;
        };
        this.getRBKey = function (key, locale, checkedKeys, originalKey) {
            ////$log.debug('getRBKey');
            ////$log.debug('loading:'+this._loadingResourceBundle);
            ////$log.debug('loaded'+this._loadedResourceBundle);
            if (_this.resourceBundles) {
                key = key.toLowerCase();
                checkedKeys = checkedKeys || "";
                locale = locale || 'en_us';
                ////$log.debug('locale');
                ////$log.debug(locale);
                var keyListArray = key.split(',');
                ////$log.debug('keylistAray');
                ////$log.debug(keyListArray);
                if (keyListArray.length > 1) {
                    var keyValue = "";
                    for (var i = 0; i < keyListArray.length; i++) {
                        keyValue = _this.getRBKey(keyListArray[i], locale, keyValue);
                        //$log.debug('keyvalue:'+keyValue);
                        if (keyValue.slice(-8) != "_missing") {
                            break;
                        }
                    }
                    return keyValue;
                }
                if (_this.resourceBundles[locale]) {
                    var bundle = _this.resourceBundles[locale];
                    if (angular.isDefined(bundle) && angular.isDefined(bundle[key])) {
                        //$log.debug('rbkeyfound:'+bundle[key]);
                        return bundle[key];
                    }
                }
                var checkedKeysListArray = checkedKeys.split(',');
                checkedKeysListArray.push(key + '_' + locale + '_missing');
                checkedKeys = checkedKeysListArray.join(",");
                if (angular.isUndefined(originalKey)) {
                    originalKey = key;
                }
                //$log.debug('originalKey:'+key);
                //$log.debug(checkedKeysListArray);
                var localeListArray = locale.split('_');
                //$log.debug(localeListArray);
                if (localeListArray.length === 2) {
                    bundle = _this.resourceBundles[localeListArray[0]];
                    if (angular.isDefined(bundle) && angular.isDefined(bundle[key])) {
                        //$log.debug('rbkey found:'+bundle[key]);
                        return bundle[key];
                    }
                    checkedKeysListArray.push(key + '_' + localeListArray[0] + '_missing');
                    checkedKeys = checkedKeysListArray.join(",");
                }
                var keyDotListArray = key.split('.');
                if (keyDotListArray.length >= 3
                    && keyDotListArray[keyDotListArray.length - 2] === 'define') {
                    var newKey = key.replace(keyDotListArray[keyDotListArray.length - 3] + '.define', 'define');
                    //$log.debug('newkey1:'+newKey);
                    return _this.getRBKey(newKey, locale, checkedKeys, originalKey);
                }
                else if (keyDotListArray.length >= 2 && keyDotListArray[keyDotListArray.length - 2] !== 'define') {
                    var newKey = key.replace(keyDotListArray[keyDotListArray.length - 2] + '.', 'define.');
                    //$log.debug('newkey:'+newKey);
                    return _this.getRBKey(newKey, locale, checkedKeys, originalKey);
                }
                //$log.debug(localeListArray);
                if (localeListArray[0] !== "en") {
                    return _this.getRBKey(originalKey, 'en', checkedKeys);
                }
                return checkedKeys;
            }
            return '';
        };
        this.$q = $q;
        this.$http = $http;
        this.appConfig = appConfig;
        this.resourceBundles = resourceBundles;
    }
    return RbKeyService;
}());
exports.RbKeyService = RbKeyService;


/***/ }),

/***/ "1aRF":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWSaveAndFinish = exports.SWSaveAndFinishController = void 0;
var SWSaveAndFinishController = /** @class */ (function () {
    //@ngInject
    SWSaveAndFinishController.$inject = ["$hibachi", "dialogService", "alertService", "rbkeyService", "$log"];
    function SWSaveAndFinishController($hibachi, dialogService, alertService, rbkeyService, $log) {
        var _this = this;
        this.$hibachi = $hibachi;
        this.dialogService = dialogService;
        this.alertService = alertService;
        this.rbkeyService = rbkeyService;
        this.$log = $log;
        this.saving = false;
        this.initialSetup = function () {
            if (!angular.isDefined(_this.finish)) {
                _this.openNewDialog = false;
            }
            else {
                _this.openNewDialog = (_this.finish.toLowerCase() == 'true') ? false : true;
            }
            if (_this.openNewDialog) {
                _this.rbKey = 'admin.define.saveandnew';
            }
            else {
                _this.rbKey = 'admin.define.saveandfinish';
            }
        };
        this.save = function () {
            _this.saving = true;
            var savePromise = _this.entity.$$save();
            savePromise.then(function (data) {
                _this.dialogService.removeCurrentDialog();
                if (_this.openNewDialog && angular.isDefined(_this.partial)) {
                    _this.dialogService.addPageDialog(_this.partial);
                }
                else {
                    if (angular.isDefined(_this.redirectUrl)) {
                        window.location.href = _this.redirectUrl;
                    }
                    else if (angular.isDefined(_this.redirectAction)) {
                        if (angular.isUndefined(_this.redirectQueryString)) {
                            _this.redirectQueryString = "";
                        }
                        window.location.href = _this.$hibachi.buildUrl(_this.redirectAction, _this.redirectQueryString);
                    }
                    else {
                        _this.$log.debug("You did not specify a redirect for swSaveAndFinish");
                    }
                }
            }).catch(function (data) {
                if (angular.isDefined(_this.customErrorRbkey)) {
                    data = _this.rbkeyService.getRBKey(_this.customErrorRbkey);
                }
                if (angular.isString(data)) {
                    var alert = _this.alertService.newAlert();
                    alert.msg = data;
                    alert.type = "error";
                    alert.fade = true;
                    _this.alertService.addAlert(alert);
                }
                else {
                    _this.alertService.addAlerts(data);
                }
            }).finally(function () {
                _this.saving = false;
            });
        };
        if (!angular.isFunction(this.entity.$$save)) {
            throw ("Your entity does not have the $$save function.");
        }
        this.initialSetup();
    }
    return SWSaveAndFinishController;
}());
exports.SWSaveAndFinishController = SWSaveAndFinishController;
var SWSaveAndFinish = /** @class */ (function () {
    //@ngInject
    SWSaveAndFinish.$inject = ["hibachiPartialsPath", "hibachiPathBuilder"];
    function SWSaveAndFinish(hibachiPartialsPath, hibachiPathBuilder) {
        this.hibachiPartialsPath = hibachiPartialsPath;
        this.restrict = "EA";
        this.scope = {};
        this.controller = SWSaveAndFinishController;
        this.controllerAs = "swSaveAndFinish";
        this.bindToController = {
            entity: "=",
            redirectUrl: "@?",
            redirectAction: "@?",
            redirectQueryString: "@?",
            finish: "@?",
            partial: "@?",
            customErrorRbkey: "@?"
        };
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(hibachiPartialsPath) + "saveandfinish.html";
    }
    SWSaveAndFinish.Factory = function () {
        var directive = function (hibachiPartialsPath, hibachiPathBuilder) { return new SWSaveAndFinish(hibachiPartialsPath, hibachiPathBuilder); };
        directive.$inject = ["hibachiPartialsPath", "hibachiPathBuilder"];
        return directive;
    };
    return SWSaveAndFinish;
}());
exports.SWSaveAndFinish = SWSaveAndFinish;


/***/ }),

/***/ "1bHV":
/***/ (function(module, exports) {

module.exports = " <div sw-typeahead-search \n        data-collection-config=\"swTypeaheadInputField.typeaheadCollectionConfig\"\n        data-placeholder-rb-key=\"{{swTypeaheadInputField.placeholderRbKey}}\"\n        data-placeholder-text=\"{{swTypeaheadInputField.placeholderText}}\"\n        data-add-function=\"swTypeaheadInputField.addFunction\"\n        data-validate-required=\"swTypeaheadInputField.validateRequired\"\n        data-all-records=\"swTypeaheadInputField.allRecords\"\n        data-max-records=\"swTypeaheadInputField.maxRecords\"\n        data-property-to-show=\"swTypeaheadInputField.propertyToShow\"\n        data-search-text=\"swTypeaheadInputField.searchText\"\n        data-initial-entity-id=\"{{swTypeaheadInputField.initialEntityId}}\"\n        data-search-endpoint=\"{{swTypeaheadInputField.searchEndpoint}}\"\n        data-title-text=\"{{swTypeaheadInputField.titleText}}\"\n        data-typeahead-data-key=\"{{swTypeaheadInputField.typeaheadDataKey}}\"\n        >\n        <ng-transclude></ng-transclude>\n</div>\n<input type=\"hidden\" readonly style=\"display:none\" ng-model=\"swTypeaheadInputField.modelValue\" name=\"{{swTypeaheadInputField.fieldName}}\" value=\"{{swTypeaheadInputField.modelValue}}\">\n";

/***/ }),

/***/ "2KUm":
/***/ (function(module, exports) {

module.exports = "<span class=\"s-select-wrapper\">\n\t<select class=\"form-control\" ng-if=\"objectName && swOptions.object\"\n\t\t ng-model=\"swOptions.selectedOption\"\n\t\t ng-change=\"swOptions.selectOption(swOptions.selectedOption)\"\n\t\t ng-options=\"option[objectName.toLowerCase()+'Name']\n\t\t\t\t\t\t for option in swOptions.options\n\t\t\t\t\t\t track by option[swOptions.object.$$getIDName()]\n\t\t\t\t\t\t\"\n\t>\n\t\t<option ng-bind=\"'Select ' + objectName\"></option>\n\t</select>\n</span>";

/***/ }),

/***/ "2XT+":
/***/ (function(module, exports) {

module.exports = "<a data-toggle=\"modal\" href=\"#{{swModalLauncher.modalName}}\">\n    <div ng-transclude=\"button\"></div>\n</a>\n<div ng-transclude=\"staticButton\"></div>\n<sw-modal-window data-save-disabled=\"swModalLauncher.saveDisabled\">\n    <sw-modal-body>\n        <div ng-transclude=\"content\"></div>\n    </sw-modal-body>\n</sw-modal-window>\n";

/***/ }),

/***/ "2lxJ":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWList = void 0;
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWList = /** @class */ (function () {
    function SWList($log, coreEntityPartialsPath, hibachiPathBuilder) {
        return {
            restrict: 'E',
            templateUrl: hibachiPathBuilder.buildPartialsPath(coreEntityPartialsPath) + '/list.html',
            link: function (scope, element, attr) {
                $log.debug('slatwallList init');
                //scope.getCollection = function(){
                //
                //	var pageShow = 50;
                //	if(scope.pageShow !== 'Auto'){
                //		pageShow = scope.pageShow;
                //	}
                //	scope.entityName = scope.entityName.charAt(0).toUpperCase()+scope.entityName.slice(1);
                //	var collectionListingPromise = $hibachi.getEntity(scope.entityName, {currentPage:scope.currentPage, pageShow:pageShow, keywords:scope.keywords});
                //	collectionListingPromise.then(function(value){
                //		scope.collection = value;
                //		scope.collectionConfig = angular.fromJson(scope.collection.collectionConfig);
                //	});
                //};
                //scope.getCollection();
            }
        };
    }
    SWList.Factory = function () {
        var directive = function ($log, coreEntityPartialsPath, hibachiPathBuilder) { return new SWList($log, coreEntityPartialsPath, hibachiPathBuilder); };
        directive.$inject = [
            '$log',
            'coreEntityPartialsPath',
            'hibachiPathBuilder'
        ];
        return directive;
    };
    return SWList;
}());
exports.SWList = SWList;


/***/ }),

/***/ "2vwh":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.HibachiInterceptor = void 0;
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var HibachiInterceptor = /** @class */ (function () {
    //@ngInject
    HibachiInterceptor.$inject = ["$location", "$q", "$log", "$rootScope", "$window", "$injector", "localStorageService", "alertService", "appConfig", "dialogService", "utilityService", "hibachiPathBuilder", "observerService", "hibachiAuthenticationService"];
    function HibachiInterceptor($location, $q, $log, $rootScope, $window, $injector, localStorageService, alertService, appConfig, 
    // public token:string,
    dialogService, utilityService, hibachiPathBuilder, observerService, hibachiAuthenticationService) {
        var _this = this;
        this.$location = $location;
        this.$q = $q;
        this.$log = $log;
        this.$rootScope = $rootScope;
        this.$window = $window;
        this.$injector = $injector;
        this.localStorageService = localStorageService;
        this.alertService = alertService;
        this.appConfig = appConfig;
        this.dialogService = dialogService;
        this.utilityService = utilityService;
        this.hibachiPathBuilder = hibachiPathBuilder;
        this.observerService = observerService;
        this.hibachiAuthenticationService = hibachiAuthenticationService;
        this.urlParam = null;
        this.authHeader = 'Authorization';
        this.authPrefix = 'Bearer ';
        this.loginResponse = null;
        this.authPromise = null;
        this.preProcessDisplayedFlagMessage = "Pre Process Displayed Flag must be equal to 1";
        //   public getJWTDataFromToken = ():void =>{
        //     this.hibachiAuthenticationService.getJWTDataFromToken(this.token);
        // }
        this.request = function (config) {
            _this.$log.debug('request');
            //bypass interceptor rules when checking template cache
            if (config.url.charAt(0) !== '/') {
                return config;
            }
            if (config.method == 'GET' && config.url.indexOf('.html') >= 0 && config.url.indexOf('/') >= 0) {
                //all partials are bound to instantiation key
                config.url = config.url + '?instantiationKey=' + _this.appConfig.instantiationKey;
                return config;
            }
            config.cache = true;
            config.headers = config.headers || {};
            // if(this.token){
            // 	config.headers['Auth-Token'] = 'Bearer ' + this.token;
            //     this.getJWTDataFromToken();
            // }
            var queryParams = _this.utilityService.getQueryParamsFromUrl(config.url);
            if (config.method == 'GET' && (queryParams[_this.appConfig.action] && queryParams[_this.appConfig.action] === 'api:main.get')) {
                _this.$log.debug(config);
                config.method = 'POST';
                config.data = {};
                var data = {};
                if (angular.isDefined(config.params)) {
                    data = config.params;
                }
                var params = {};
                params.serializedJsonData = angular.toJson(data);
                params.context = "GET";
                config.data = $.param(params);
                delete config.params;
                config.headers['Content-Type'] = 'application/x-www-form-urlencoded';
            }
            else if ((queryParams[_this.appConfig.action] && queryParams[_this.appConfig.action].indexOf('api:main.get') !== -1)) {
                if (queryParams && !queryParams['context']) {
                    if (!config.data) {
                        config.data = {};
                    }
                    config.data.context = 'GET';
                }
            }
            return config;
        };
        this.requestError = function (rejection) {
            return _this.$q.reject(rejection);
        };
        this.response = function (response) {
            var _a;
            if ((_a = response === null || response === void 0 ? void 0 : response.data) === null || _a === void 0 ? void 0 : _a.messages) {
                //We have 1 'error' that we use to display preprocess forms that we don't want displaying.
                if (response.data.messages.length && response.data.messages[0].message && response.data.messages[0].message != _this.preProcessDisplayedFlagMessage) {
                    var alerts = _this.alertService.formatMessagesToAlerts(response.data.messages);
                    _this.alertService.addAlerts(alerts);
                }
            }
            return response;
        };
        this.responseError = function (rejection) {
            if (angular.isDefined(rejection.status) && rejection.status !== 404 && rejection.status !== 403 && rejection.status !== 499) {
                if (rejection.data && rejection.data.messages) {
                    var alerts = _this.alertService.formatMessagesToAlerts(rejection.data.messages);
                    _this.alertService.addAlerts(alerts);
                }
                else {
                    var message = {
                        msg: 'there was error retrieving data',
                        type: 'error'
                    };
                    _this.alertService.addAlert(message);
                }
            }
            if (rejection.status === 403 || rejection.status == 401) {
                _this.observerService.notify('Unauthorized');
            }
            if (rejection.status === 499) {
                // handle the case where the user is not authenticated
                if (rejection.data && rejection.data.messages) {
                    //var deferred = $q.defer();
                    var $http = _this.$injector.get('$http');
                    if (rejection.data.messages[0].message === 'timeout') {
                        //open dialog
                        _this.dialogService.addPageDialog(_this.hibachiPathBuilder.buildPartialsPath('preprocesslogin'), {});
                    }
                    else if (rejection.data.messages[0].message === 'invalid_token') {
                        //logic to resolve all 499s in a single login call
                        if (!_this.authPromise) {
                            return _this.authPromise = $http.get(_this.baseUrl + '?' + _this.appConfig.action + '=api:main.login').then(function (loginResponse) {
                                _this.loginResponse = loginResponse;
                                if (loginResponse.status === 200) {
                                    _this.hibachiAuthenticationService.token = loginResponse.data.token;
                                    rejection.config.headers = rejection.config.headers || {};
                                    // rejection.config.headers['Auth-Token'] = 'Bearer ' + loginResponse.data.token;
                                    // this.token = loginResponse.data.token;
                                    // this.getJWTDataFromToken();
                                    return $http(rejection.config).then(function (response) {
                                        return response;
                                    });
                                }
                            }, function (rejection) {
                                return rejection;
                            });
                        }
                        else {
                            return _this.authPromise.then(function () {
                                if (_this.loginResponse.status === 200) {
                                    rejection.config.headers = rejection.config.headers || {};
                                    // rejection.config.headers['Auth-Token'] = 'Bearer ' + this.loginResponse.data.token;
                                    // this.token=this.loginResponse.data.token;
                                    // this.getJWTDataFromToken();
                                    return $http(rejection.config).then(function (response) {
                                        return response;
                                    });
                                }
                            }, function (rejection) {
                                return rejection;
                            });
                        }
                    }
                }
            }
            return rejection;
        };
        this.$location = $location;
        this.$q = $q;
        this.$log = $log;
        this.$rootScope = $rootScope;
        this.$window = $window;
        this.$injector = $injector;
        this.localStorageService = localStorageService;
        this.alertService = alertService;
        this.appConfig = appConfig;
        // this.token = token;
        this.dialogService = dialogService;
        this.utilityService = utilityService;
        this.hibachiPathBuilder = hibachiPathBuilder;
        this.baseUrl = appConfig.baseURL;
        this.hibachiAuthenticationService = hibachiAuthenticationService;
    }
    HibachiInterceptor.Factory = function () {
        var eventHandler = function ($location, $q, $log, $rootScope, $window, $injector, localStorageService, alertService, appConfig, 
        // token:string,
        dialogService, utilityService, hibachiPathBuilder, observerService, hibachiAuthenticationService) { return new HibachiInterceptor($location, $q, $log, $rootScope, $window, $injector, localStorageService, alertService, appConfig, 
        // token,
        dialogService, utilityService, hibachiPathBuilder, observerService, hibachiAuthenticationService); };
        eventHandler.$inject = [
            '$location',
            '$q',
            '$log',
            '$rootScope',
            '$window',
            '$injector',
            'localStorageService',
            'alertService',
            'appConfig',
            // 'token',
            'dialogService',
            'utilityService',
            'hibachiPathBuilder',
            'observerService',
            'hibachiAuthenticationService'
        ];
        return eventHandler;
    };
    return HibachiInterceptor;
}());
exports.HibachiInterceptor = HibachiInterceptor;


/***/ }),

/***/ "3h5T":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWTypeaheadSearchLineItemController = exports.SWTypeaheadSearchLineItem = void 0;
var SWTypeaheadSearchLineItemController = /** @class */ (function () {
    function SWTypeaheadSearchLineItemController() {
    }
    return SWTypeaheadSearchLineItemController;
}());
exports.SWTypeaheadSearchLineItemController = SWTypeaheadSearchLineItemController;
var SWTypeaheadSearchLineItem = /** @class */ (function () {
    //@ngInject
    SWTypeaheadSearchLineItem.$inject = ["$compile"];
    function SWTypeaheadSearchLineItem($compile) {
        this.$compile = $compile;
        this.restrict = 'EA';
        this.scope = true;
        this.bindToController = {
            propertyIdentifier: "@",
            bindHtml: "=?",
            isSearchable: "@?",
        };
        this.controller = SWTypeaheadSearchLineItemController;
        this.controllerAs = "swTypeaheadSearchLineItem";
        this.compile = function (element, attrs, transclude) {
            return {
                pre: function (scope, element, attrs) {
                    var propertyIdentifier = scope.swTypeaheadSearchLineItem.propertyIdentifier;
                    if (!propertyIdentifier && scope.$parent.swTypeaheadMultiselect) {
                        propertyIdentifier = scope.$parent.swTypeaheadMultiselect.rightContentPropertyIdentifier;
                    }
                    var innerHTML = element[0].innerHTML;
                    element[0].innerHTML = '';
                    if (!scope.swTypeaheadSearchLineItem.bindHtml) {
                        var span = '<span ng-if="item.' + scope.swTypeaheadSearchLineItem.propertyIdentifier + '.toString().trim().length">' + ' ' + innerHTML + '</span> <span ng-bind="item.' + scope.swTypeaheadSearchLineItem.propertyIdentifier + '"></span>';
                    }
                    else {
                        var span = '<span ng-if="item.' + scope.swTypeaheadSearchLineItem.propertyIdentifier + '.toString().trim().length">' + ' ' + innerHTML + '</span> <span ng-bind-html="item.' + scope.swTypeaheadSearchLineItem.propertyIdentifier + '"></span>';
                    }
                    element.append(span);
                },
                post: function (scope, element, attrs) { }
            };
        };
    }
    SWTypeaheadSearchLineItem.Factory = function () {
        var directive = function ($compile) { return new SWTypeaheadSearchLineItem($compile); };
        directive.$inject = [
            '$compile'
        ];
        return directive;
    };
    return SWTypeaheadSearchLineItem;
}());
exports.SWTypeaheadSearchLineItem = SWTypeaheadSearchLineItem;


/***/ }),

/***/ "3tV0":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../typings/tsd.d.ts' />
var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.AccountAddress = void 0;
var baseentity_1 = __webpack_require__("L67B");
var AccountAddress = /** @class */ (function (_super) {
    __extends(AccountAddress, _super);
    function AccountAddress($injector) {
        var _this = _super.call(this, $injector) || this;
        _this.getSimpleRepresentation = function () {
            return (_this.accountAddressName || '') + ' - '
                + (_this.address.streetAddress || '')
                + (_this.address.street2Address.trim().length ? ' ' + _this.address.street2Address : '')
                + ' ' + (_this.address.city || '') + ','
                + ' ' + (_this.address.stateCode || '')
                + ' ' + (_this.address.postalCode || '')
                + ' ' + (_this.address.countryCode || '');
        };
        return _this;
    }
    return AccountAddress;
}(baseentity_1.BaseEntity));
exports.AccountAddress = AccountAddress;


/***/ }),

/***/ "4HDq":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.HibachiAuthenticationService = void 0;
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var HibachiAuthenticationService = /** @class */ (function () {
    //@ngInject
    HibachiAuthenticationService.$inject = ["$rootScope", "$q", "$window", "appConfig", "$injector", "utilityService"];
    function HibachiAuthenticationService($rootScope, $q, $window, appConfig, $injector, utilityService) {
        var _this = this;
        this.$rootScope = $rootScope;
        this.$q = $q;
        this.$window = $window;
        this.appConfig = appConfig;
        this.$injector = $injector;
        this.utilityService = utilityService;
        this.getJWTDataFromToken = function (str) {
            if (str !== "invalidToken") {
                // Going backwards: from bytestream, to percent-encoding, to original string.
                str = str.split('.')[1];
                var decodedString = decodeURIComponent(_this.$window.atob(str).split('').map(function (c) {
                    return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
                }).join(''));
                var jwtData = angular.fromJson(decodedString);
                var now = +new Date();
                var nowString = now.toString().substr(0, jwtData.exp.toString().length);
                now = +nowString;
            }
            else {
                var jwtData = {
                    role: 'public'
                };
                if (!_this.$rootScope.slatwall.account) {
                    _this.$rootScope.slatwall.account = {};
                }
                if (!_this.$rootScope.slatwall.role) {
                    _this.$rootScope.slatwall.role = jwtData.role;
                    _this.getRoleBasedData(jwtData);
                }
            }
            if (jwtData.issuer && jwtData.issuer == _this.$window.location.hostname && jwtData.exp > now) {
                if (!_this.$rootScope.slatwall.account) {
                    _this.$rootScope.slatwall.account = {};
                }
                _this.$rootScope.slatwall.account.accountID = jwtData.accountid;
                //important to check to prevent recursion between $http and hibachinterceptor
                if (!_this.$rootScope.slatwall.role) {
                    _this.$rootScope.slatwall.role = jwtData.role;
                    _this.getRoleBasedData(jwtData);
                    if (jwtData.permissionGroups) {
                        _this.$rootScope.slatwall.permissionGroups = jwtData.permissionGroups;
                    }
                }
            }
        };
        this.isSuperUser = function () {
            if (!_this.$rootScope.slatwall.authInfo) {
                //this.getJWTDataFromToken(this.token);
            }
            return _this.$rootScope.slatwall.role == 'superUser';
        };
        this.authenticateActionByAccount = function (action, processContext) {
            var authDetails = _this.getActionAuthenticationDetailsByAccount(action, processContext);
            return authDetails.authorizedFlag;
        };
        this.getActionAuthenticationDetailsByAccount = function (action, processContext) {
            var authDetails = {
                authorizedFlag: false,
                superUserAccessFlag: false,
                anyLoginAccessFlag: false,
                anyAdminAccessFlag: false,
                publicAccessFlag: false,
                entityPermissionAccessFlag: false,
                actionPermissionAccessFlag: false,
                forbidden: false,
                invalidToken: false,
                timeout: false
            };
            if (_this.isSuperUser()) {
                authDetails.authorizedFlag = true;
                authDetails.superUserAccessFlag = true;
                return authDetails;
            }
            var subsystemName = action.split(':')[0];
            var sectionName = action.split(':')[1].split('.')[0];
            if (action.split('.').length > 1) {
                var itemName = action.split('.')[1];
            }
            else {
                var itemName = 'default';
            }
            if ((_this.utilityService.left(itemName, 10) == 'preprocess' || _this.utilityService.left(itemName, 7) == 'process')
                && processContext
                && processContext.length) {
                itemName += '_processContext';
            }
            var actionPermissions = _this.getActionPermissionDetails();
            if (!actionPermissions) {
                return false;
            }
            // Check if the subsystem & section are defined, if not then return true because that means authentication was not turned on
            if (!actionPermissions[subsystemName]
                || !actionPermissions[subsystemName].hasSecureMethods
                || !actionPermissions[subsystemName].sections[sectionName]) {
                authDetails.authorizedFlag = true;
                authDetails.publicAccessFlag = true;
                return authDetails;
            }
            // Check if the action is public, if public no need to worry about security
            if (_this.utilityService.listFindNoCase(actionPermissions[subsystemName].sections[sectionName].publicMethods, itemName) != -1) {
                authDetails.authorizedFlag = true;
                authDetails.publicAccessFlag = true;
                return authDetails;
            }
            // All these potentials require the account to be logged in, and that it matches the hibachiScope
            if (_this.$rootScope.slatwall.account
                && _this.$rootScope.slatwall.account.accountID
                && _this.$rootScope.slatwall.account.accountID.length) {
                // Check if the action is anyLogin, if so and the user is logged in, then we can return true
                if (_this.utilityService.listFindNoCase(actionPermissions[subsystemName].sections[sectionName].anyLoginMethods, itemName) != -1) {
                    authDetails.authorizedFlag = true;
                    authDetails.anyLoginAccessFlag = true;
                    return authDetails;
                }
                // Look for the anyAdmin methods next to see if this is an anyAdmin method, and this user is some type of admin
                if (_this.utilityService.listFindNoCase(actionPermissions[subsystemName].sections[sectionName].anyAdminMethods, itemName) != -1) {
                    authDetails.authorizedFlag = true;
                    authDetails.anyAdminAccessFlag = true;
                    return authDetails;
                }
                // Check to see if this is a defined secure method, and if so we can test it against the account
                if (_this.utilityService.listFindNoCase(actionPermissions[subsystemName].sections[sectionName].secureMethods, itemName) != -1) {
                    var pgOK = false;
                    if (_this.$rootScope.slatwall.authInfo.permissionGroups) {
                        var accountPermissionGroups = _this.$rootScope.slatwall.authInfo.permissionGroups;
                        if (accountPermissionGroups) {
                            for (var p in accountPermissionGroups) {
                                pgOK = _this.authenticateSubsystemSectionItemActionByPermissionGroup(subsystemName, sectionName, itemName, accountPermissionGroups[p]);
                                if (pgOK) {
                                    break;
                                }
                            }
                        }
                    }
                    if (pgOK) {
                        authDetails.authorizedFlag = true;
                        authDetails.actionPermissionAccessFlag = true;
                    }
                    return authDetails;
                }
                //start line130
                // For process / preprocess strip out process context from item name		
                if (itemName.split('_').length > 1) {
                    itemName = itemName.split('_')[0];
                }
                // Check to see if the controller is an entity, and then verify against the entity itself
                if (_this.getActionPermissionDetails()[subsystemName].sections[sectionName].entityController) {
                    if (_this.utilityService.left(itemName, 6) == "create") {
                        authDetails.authorizedFlag = _this.authenticateEntityCrudByAccount("create", _this.utilityService.right(itemName, itemName.length - 6));
                    }
                    else if (_this.utilityService.left(itemName, 6) == "detail") {
                        authDetails.authorizedFlag = _this.authenticateEntityCrudByAccount("read", _this.utilityService.right(itemName, itemName.length - 6));
                    }
                    else if (_this.utilityService.left(itemName, 6) == "delete") {
                        authDetails.authorizedFlag = _this.authenticateEntityCrudByAccount("delete", _this.utilityService.right(itemName, itemName.length - 6));
                    }
                    else if (_this.utilityService.left(itemName, 4) == "edit") {
                        authDetails.authorizedFlag = _this.authenticateEntityCrudByAccount("update", _this.utilityService.right(itemName, itemName.length - 4));
                    }
                    else if (_this.utilityService.left(itemName, 4) == "list") {
                        authDetails.authorizedFlag = _this.authenticateEntityCrudByAccount("read", _this.utilityService.right(itemName, itemName.length - 4));
                    }
                    else if (_this.utilityService.left(itemName, 10) == "reportlist") {
                        authDetails.authorizedFlag = _this.authenticateEntityCrudByAccount("report", _this.utilityService.right(itemName, itemName.length - 10));
                    }
                    else if (_this.utilityService.left(itemName, 15) == "multiPreProcess") {
                        authDetails.authorizedFlag = _this.authenticateProcessByAccount(processContext, _this.utilityService.right(itemName, itemName.length - 15));
                    }
                    else if (_this.utilityService.left(itemName, 12) == "multiProcess") {
                        authDetails.authorizedFlag = _this.authenticateProcessByAccount(processContext, _this.utilityService.right(itemName, itemName.length - 12));
                    }
                    else if (_this.utilityService.left(itemName, 10) == "preProcess") {
                        authDetails.authorizedFlag = _this.authenticateProcessByAccount(processContext, _this.utilityService.right(itemName, itemName.length - 10));
                    }
                    else if (_this.utilityService.left(itemName, 7) == "process") {
                        authDetails.authorizedFlag = _this.authenticateProcessByAccount(processContext, _this.utilityService.right(itemName, itemName.length - 7));
                    }
                    else if (_this.utilityService.left(itemName, 4) == "save") {
                        authDetails.authorizedFlag = _this.authenticateEntityCrudByAccount("create", _this.utilityService.right(itemName, itemName.length - 4));
                        if (!authDetails.authorizedFlag) {
                            authDetails.authorizedFlag = _this.authenticateEntityCrudByAccount("update", _this.utilityService.right(itemName, itemName.length - 4));
                        }
                    }
                    if (authDetails.authorizedFlag) {
                        authDetails.entityPermissionAccessFlag = true;
                    }
                }
                //TODO: see if this applies on the client side and how
                // Check to see if the controller is for rest, and then verify against the entity itself
                /*if(this.getActionPermissionDetails()[ subsystemName ].sections[ sectionName ].restController){
                    //require a token to validate
                    if (StructKeyExists(arguments.restInfo, "context")){
                        var hasProcess = invokeMethod('new'&arguments.restInfo.entityName).hasProcessObject(arguments.restInfo.context);
                    }else{
                        var hasProcess = false;
                    }
                    if(hasProcess){
                        authDetails.authorizedFlag = true;
                    }else if(itemName == 'get'){
                        authDetails.authorizedFlag = authenticateEntityCrudByAccount(crudType="read",entityName=arguments.restInfo.entityName,account=arguments.account);
                    }else if(itemName == 'post'){
                        if(arguments.restInfo.context == 'get'){
                            authDetails.authorizedFlag = authenticateEntityCrudByAccount(crudType="read",entityName=arguments.restInfo.entityName,account=arguments.account);
                        }else if(arguments.restInfo.context == 'save'){
                            authDetails.authorizedFlag = authenticateEntityCrudByAccount(crudType="create", entityName=arguments.restInfo.entityName, account=arguments.account);
                            if(!authDetails.authorizedFlag) {
                                authDetails.authorizedFlag = authenticateEntityCrudByAccount(crudType="update", entityName=arguments.restInfo.entityName, account=arguments.account);
                            }
                        }else{
                            authDetails.authorizedFlag = authenticateEntityCrudByAccount(crudType=arguments.restInfo.context,entityName=arguments.restInfo.entityName,account=arguments.account);
                        }
                    }
                    if(authDetails.authorizedFlag) {
                        authDetails.entityPermissionAccessFlag = true;
                    }else{
                        authDetails.forbidden = true;
                    }
                        
                }*/
            }
            return authDetails;
        };
        this.authenticateProcessByAccount = function (processContext, entityName) {
            entityName = entityName.toLowerCase();
            processContext = processContext.toLowerCase();
            // Check if the user is a super admin, if true no need to worry about security
            if (_this.isSuperUser()) {
                return true;
            }
            // Loop over each permission group for this account, and ckeck if it has access
            if (_this.$rootScope.slatwall.authInfo.permissionGroups) {
                var accountPermissionGroups = _this.$rootScope.slatwall.authInfo.permissionGroups;
                for (var i in accountPermissionGroups) {
                    var pgOK = _this.authenticateProcessByPermissionGroup(processContext, entityName, accountPermissionGroups[i]);
                    if (pgOK) {
                        return true;
                    }
                }
            }
            return false;
        };
        this.authenticateEntityPropertyCrudByAccount = function (crudType, entityName, propertyName) {
            // Check if the user is a super admin, if true no need to worry about security
            if (_this.isSuperUser()) {
                return true;
            }
            // Loop over each permission group for this account, and ckeck if it has access
            var accountPermissionGroups = _this.$rootScope.slatwall.authInfo.permissionGroups;
            for (var i in accountPermissionGroups) {
                var pgOK = _this.authenticateEntityPropertyByPermissionGroup(crudType, entityName, propertyName, accountPermissionGroups[i]);
                if (pgOK) {
                    return true;
                }
            }
            // If for some reason not of the above were meet then just return false
            return false;
        };
        this.authenticateEntityCrudByAccount = function (crudType, entityName) {
            crudType = _this.utilityService.toCamelCase(crudType);
            entityName = entityName.toLowerCase();
            // Check if the user is a super admin, if true no need to worry about security
            if (_this.isSuperUser()) {
                return true;
            }
            // Loop over each permission group for this account, and ckeck if it has access
            if (_this.$rootScope.slatwall.authInfo.permissionGroups) {
                var accountPermissionGroups = _this.$rootScope.slatwall.authInfo.permissionGroups;
                for (var i in accountPermissionGroups) {
                    var pgOK = _this.authenticateEntityByPermissionGroup(crudType, entityName, accountPermissionGroups[i]);
                    if (pgOK) {
                        return true;
                    }
                }
            }
            // If for some reason not of the above were meet then just return false
            return false;
        };
        this.authenticateProcessByPermissionGroup = function (processContext, entityName, permissionGroup) {
            var permissions = permissionGroup;
            var permissionDetails = _this.getEntityPermissionDetails();
            entityName = entityName.toLowerCase();
            processContext = processContext.toLowerCase();
            if (!_this.authenticateEntityByPermissionGroup('Process', entityName, permissionGroup)) {
                return false;
            }
            //if nothing specific then all processes are ok
            if (!permissions.process.entities[entityName]) {
                return true;
            }
            //if we find perms then what are they?
            if (permissions.process.entities[entityName]
                && permissions.process.entities[entityName].context[processContext]) {
                return permissions.process.entities[entityName].context[processContext].allowProcessFlag;
            }
            return false;
        };
        this.authenticateEntityByPermissionGroup = function (crudType, entityName, permissionGroup) {
            // Pull the permissions detail struct out of the permission group
            var permissions = permissionGroup;
            var permissionDetails = _this.getEntityPermissionDetails();
            // Check for entity specific values
            if (permissions.entity.entities
                && permissions.entity.entities[entityName]
                && permissions.entity.entities[entityName]["permission"]
                && permissions.entity.entities[entityName].permission["allow" + crudType + "Flag"]) {
                if (permissions.entity.entities[entityName].permission["allow" + crudType + "Flag"]) {
                    return true;
                }
                else {
                    return false;
                }
            }
            // Check for an inherited permission
            if (permissionDetails[entityName]
                && permissionDetails[entityName]["inheritPermissionEntityName"]) {
                return _this.authenticateEntityByPermissionGroup(crudType, permissionDetails[entityName].inheritPermissionEntityName, permissionGroup);
            }
            // Check for generic permssion
            if (permissions.entity["permission"]
                && permissions.entity.permission["allow" + crudType + "Flag"]
                && permissions.entity.permission["allow" + crudType + "Flag"]) {
                return true;
            }
            return false;
        };
        this.authenticateEntityPropertyByPermissionGroup = function (crudType, entityName, propertyName, permissionGroup) {
            // Pull the permissions detail struct out of the permission group
            var permissions = permissionGroup;
            entityName = entityName.toLowerCase();
            propertyName = propertyName.toLowerCase();
            if (permissions.entity.entities
                && permissions.entity.entities[entityName]
                && propertyName == entityName + 'ID') {
                return true;
            }
            // Check first to see if this entity was defined
            if (permissions.entity.entities
                && permissions.entity.entities[entityName]
                && permissions.entity.entities[entityName].properties[propertyName]
                && permissions.entity.entities[entityName].properties[propertyName]['allow' + crudType + 'Flag']) {
                if (permissions.entity.entities
                    && permissions.entity.entities[entityName].properties[propertyName]['allow' + crudType + 'Flag']) {
                    return true;
                }
                else {
                    return false;
                }
            }
            // If there was an entity defined, and special property values have been defined then we need to return false
            if (permissions.entity.entities
                && permissions.entity.entities[entityName]
                && Object.keys(permissions.entity.entities[entityName].properties).length) {
                return false;
            }
            return _this.authenticateEntityByPermissionGroup(crudType, entityName, permissionGroup);
        };
        this.authenticateSubsystemSectionItemActionByPermissionGroup = function (subsystem, section, item, permissionGroup) {
            // Pull the permissions detail struct out of the permission group
            var permissions = permissionGroup;
            var actionSubsystem = permissions.action.subsystems[subsystem];
            if (actionSubsystem
                && actionSubsystem.sections[section]
                && actionSubsystem.sections[section].items[item]) {
                return actionSubsystem.sections[section].items[item].allowActionFlag
                    && actionSubsystem.sections[section].items[item].allowActionFlag;
            }
            return _this.authenticateSubsystemSectionActionByPermissionGroup(subsystem = subsystem, section = section, permissionGroup = permissionGroup);
        };
        this.authenticateSubsystemSectionActionByPermissionGroup = function (subsystem, section, permissionGroup) {
            // Pull the permissions detail struct out of the permission group
            var permissions = permissionGroup;
            if (permissions.action.subsystems[subsystem]
                && permissions.action.subsystems[subsystem].sections[section]
                && permissions.action.subsystems[subsystem].sections[section]["permission"]) {
                if (permissions.action.subsystems[subsystem].sections[section].permission.allowActionFlag
                    && permissions.action.subsystems[subsystem].sections[section].permission.allowActionFlag) {
                    return true;
                }
                else {
                    return false;
                }
            }
            return _this.authenticateSubsystemActionByPermissionGroup(subsystem = subsystem, permissionGroup = permissionGroup);
        };
        this.authenticateSubsystemActionByPermissionGroup = function (subsystem, permissionGroup) {
            // Pull the permissions detail struct out of the permission group
            var permissions = permissionGroup;
            if (permissions.action.subsystems[subsystem]
                && permissions.action.subsystems[subsystem]["permission"]) {
                if (permissions.action.subsystems[subsystem].permission.allowActionFlag
                    && permissions.action.subsystems[subsystem].permission.allowActionFlag) {
                    return true;
                }
                else {
                    return false;
                }
            }
            return false;
        };
        this.getActionPermissionDetails = function () {
            return _this.$rootScope.slatwall.authInfo.action;
        };
        this.getEntityPermissionDetails = function () {
            return _this.$rootScope.slatwall.authInfo.entity;
        };
        this.getUserRole = function () {
            return _this.$rootScope.slatwall.role;
        };
        this.getRoleBasedData = function (jwtData) {
            switch (jwtData.role) {
                case 'superUser':
                    //no data is required for this role and we can assume they have access to everything
                    break;
                case 'admin':
                    _this.getPublicRoleData();
                    _this.getPermissionGroupsData(jwtData.permissionGroups);
                    break;
                case 'public':
                    //only public data is required for this role and we can assume they have access to everything
                    _this.getPublicRoleData();
                    break;
            }
        };
        this.getPublicRoleData = function () {
            var entityPromise = _this.getEntityData();
            var actionPromise = _this.getActionData();
            var publicRoleDataPromises = [entityPromise, actionPromise];
            var qPromise = _this.$q.all(publicRoleDataPromises).then(function (data) {
                if (!_this.$rootScope.slatwall.authInfo) {
                    _this.$rootScope.slatwall.authInfo = {};
                }
                _this.$rootScope.slatwall.authInfo.entity = data[0];
                _this.$rootScope.slatwall.authInfo.action = data[1];
            }, function (error) {
                throw ('could not get public role data');
            });
            return qPromise;
        };
        this.getEntityData = function () {
            var $http = _this.$injector.get('$http');
            var deferred = _this.$q.defer();
            $http.get(_this.appConfig.baseURL + '/custom/system/permissions/entity.json')
                .success(function (response, status, headersGetter) {
                deferred.resolve(response);
            }).error(function (response, status) {
                deferred.reject(response);
            });
            return deferred.promise;
        };
        this.getActionData = function () {
            var deferred = _this.$q.defer();
            var $http = _this.$injector.get('$http');
            $http.get(_this.appConfig.baseURL + '/custom/system/permissions/action.json')
                .success(function (response, status, headersGetter) {
                deferred.resolve(response);
            }).error(function (response, status) {
                deferred.reject(response);
            });
            return deferred.promise;
        };
        this.getPermissionGroupsData = function (permissionGroupIDs) {
            var permissionGroupIDArray = permissionGroupIDs.split(',');
            var permissionGroupPromises = [];
            for (var i in permissionGroupIDArray) {
                var permissionGroupID = permissionGroupIDArray[i];
                var permissionGroupPromise = _this.getPermissionGroupData(permissionGroupID);
                permissionGroupPromises.push(permissionGroupPromise);
            }
            var qPromise = _this.$q.all(permissionGroupPromises).then(function (data) {
                if (!_this.$rootScope.slatwall.authInfo) {
                    _this.$rootScope.slatwall.authInfo = {};
                }
                for (var i in permissionGroupIDArray) {
                    var permissionGroupID = permissionGroupIDArray[i];
                    if (!_this.$rootScope.slatwall.authInfo['permissionGroups']) {
                        _this.$rootScope.slatwall.authInfo['permissionGroups'] = {};
                    }
                    _this.$rootScope.slatwall.authInfo['permissionGroups'][permissionGroupID] = data[i];
                }
            }, function (error) {
                throw ('could not get public role data');
            });
            return qPromise;
        };
        this.getPermissionGroupData = function (permissionGroupID) {
            var deferred = _this.$q.defer();
            var $http = _this.$injector.get('$http');
            $http.get(_this.appConfig.baseURL + '/custom/system/permissions/' + permissionGroupID + '.json')
                .success(function (response, status, headersGetter) {
                deferred.resolve(response);
            }).error(function (response, status) {
                deferred.reject(response);
            });
            return deferred.promise;
        };
    }
    return HibachiAuthenticationService;
}());
exports.HibachiAuthenticationService = HibachiAuthenticationService;


/***/ }),

/***/ "4IhF":
/***/ (function(module, exports) {

module.exports = "<div data-ng-class=\"swSelection.isRadio ? 'radio' : 's-checkbox'\"\n     data-ng-if=\"swSelection.id && swSelection.selectionid && swSelection.selection\"\n     style=\"margin:0;padding:0\">\n\t<input  type=\"{{swSelection.isRadio ? 'radio' : 'checkbox'}}\"\n            id=\"j-checkbox-{{swSelection.selectionid}}-{{swSelection.id}}\"\n\t\t\tdata-ng-attr-name=\"{{swSelection.name}}\"\n            data-ng-model=\"swSelection.toggleValue\"\n            data-ng-click=\"swSelection.toggleSelection(swSelection.toggleValue,swSelection.selectionid,swSelection.selection)\"\n            data-ng-value=\"swSelection.id\"\n            data-ng-disabled=\"swSelection.disabled\"\n\t\t\t/>\n    <label for=\"j-checkbox-{{swSelection.selectionid}}-{{swSelection.id}}\">\n\t</label>\n</div>";

/***/ }),

/***/ "4yaA":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.DateReporting = void 0;
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var DateReporting = /** @class */ (function () {
    function DateReporting() {
    }
    //@ngInject
    DateReporting.Factory = function ($filter) {
        return function (date, periodInterval) {
            var _a, _b;
            if (!((_b = (_a = date === null || date === void 0 ? void 0 : date.trim) === null || _a === void 0 ? void 0 : _a.call(date)) === null || _b === void 0 ? void 0 : _b.length)) {
                return '';
            }
            switch (periodInterval) {
                case 'hour':
                    var dateArray = date.split('-');
                    return 'Hour #' + dateArray[3] + ' of ' + dateArray[1] + '/' + dateArray[2] + '/' + dateArray[0];
                case 'day':
                    var dateArray = date.split('-');
                    return dateArray[1] + '/' + dateArray[2] + '/' + dateArray[0];
                case 'week':
                    var dateArray = date.split('-');
                    return 'Week #' + dateArray[1] + ' of ' + dateArray[0];
                case 'month':
                    var dateArray = date.split('-');
                    return dateArray[1] + '/' + dateArray[0];
                case 'year':
                    return date;
            }
        };
    };
    DateReporting.Factory.$inject = ["$filter"];
    return DateReporting;
}());
exports.DateReporting = DateReporting;


/***/ }),

/***/ "5ycg":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWCollectionColumnController = exports.SWCollectionColumn = void 0;
var SWCollectionColumnController = /** @class */ (function () {
    function SWCollectionColumnController() {
    }
    return SWCollectionColumnController;
}());
exports.SWCollectionColumnController = SWCollectionColumnController;
var SWCollectionColumn = /** @class */ (function () {
    //@ngInject
    SWCollectionColumn.$inject = ["scopeService", "utilityService"];
    function SWCollectionColumn(scopeService, utilityService) {
        var _this = this;
        this.scopeService = scopeService;
        this.utilityService = utilityService;
        this.restrict = 'EA';
        this.scope = true;
        this.bindToController = {
            propertyIdentifier: "@",
            fallbackPropertyIdentifiers: "@?",
            isVisible: "=?",
            isSearchable: "=?",
            isDeletable: "=?",
            isExportable: "=?",
            isKeywordColumn: "=?",
            isOnlyKeywordColumn: "=?",
            tdclass: "@?",
            hidden: "=?"
        };
        this.controller = SWCollectionColumn;
        this.controllerAs = "swCollectionColumn";
        this.template = "";
        this.link = function (scope, element, attrs) {
            if (angular.isUndefined(scope.swCollectionColumn.isKeywordColumn)) {
                scope.swCollectionColumn.isKeywordColumn = false;
            }
            if (angular.isUndefined(scope.swCollectionColumn.isOnlyKeywordColumn)) {
                scope.swCollectionColumn.isOnlyKeywordColumn = scope.swCollectionColumn.isKeywordColumn;
            }
            if (angular.isUndefined(scope.swCollectionColumn.isVisible)) {
                scope.swCollectionColumn.isVisible = true;
            }
            if (angular.isUndefined(scope.swCollectionColumn.isSearchable)) {
                scope.swCollectionColumn.isSearchable = false;
            }
            if (angular.isUndefined(scope.swCollectionColumn.isDeletable)) {
                scope.swCollectionColumn.isDeletable = false;
            }
            if (angular.isUndefined(scope.swCollectionColumn.isExportable)) {
                scope.swCollectionColumn.isExportable = true;
            }
            var column = {
                propertyIdentifier: scope.swCollectionColumn.propertyIdentifier,
                fallbackPropertyIdentifiers: scope.swCollectionColumn.fallbackPropertyIdentifiers,
                isVisible: scope.swCollectionColumn.isVisible,
                isSearchable: scope.swCollectionColumn.isSearchable,
                isDeletable: scope.swCollectionColumn.isDeletable,
                isExportable: scope.swCollectionColumn.isExportable,
                hidden: scope.swCollectionColumn.hidden,
                tdclass: scope.swCollectionColumn.tdclass,
                isKeywordColumn: scope.swCollectionColumn.isKeywordColumn,
                isOnlyKeywordColumn: scope.swCollectionColumn.isOnlyKeywordColumn
            };
            var currentScope = _this.scopeService.getRootParentScope(scope, "swCollectionConfig");
            if (angular.isDefined(currentScope.swCollectionConfig)) {
                //push directly here because we've already built the column object
                currentScope.swCollectionConfig.columns.push(column);
                currentScope.swCollectionConfig.columnsDeferred.resolve();
            }
            else {
                throw ("Could not find swCollectionConfig in the parent scope from swcollectioncolumn");
            }
        };
    }
    SWCollectionColumn.Factory = function () {
        var _this = this;
        return /** @ngInject; */ ["scopeService", "utilityService", function (scopeService, utilityService) {
            return new _this(scopeService, utilityService);
        }];
    };
    return SWCollectionColumn;
}());
exports.SWCollectionColumn = SWCollectionColumn;


/***/ }),

/***/ "6k0T":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWDetailTabs = void 0;
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWDetailTabs = /** @class */ (function () {
    function SWDetailTabs(coreEntityPartialsPath, hibachiPathBuilder) {
        return {
            restrict: 'E',
            templateUrl: hibachiPathBuilder.buildPartialsPath(coreEntityPartialsPath) + 'detailtabs.html',
            link: function (scope, element, attr) {
            }
        };
    }
    SWDetailTabs.Factory = function () {
        var directive = function (coreEntityPartialsPath, hibachiPathBuilder) { return new SWDetailTabs(coreEntityPartialsPath, hibachiPathBuilder); };
        directive.$inject = [
            'coreEntityPartialsPath',
            'hibachiPathBuilder'
        ];
        return directive;
    };
    return SWDetailTabs;
}());
exports.SWDetailTabs = SWDetailTabs;


/***/ }),

/***/ "6ppE":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWTabGroupController = exports.SWTabGroup = void 0;
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWTabGroupController = /** @class */ (function () {
    // @ngInject
    SWTabGroupController.$inject = ["utilityService", "rbkeyService", "observerService"];
    function SWTabGroupController(utilityService, rbkeyService, observerService) {
        var _this = this;
        this.utilityService = utilityService;
        this.rbkeyService = rbkeyService;
        this.observerService = observerService;
        this.hasActiveTab = false;
        this.initTab = function () {
            for (var i = 0; i < _this.tabs.length; i++) {
                if (!_this.tabs[i].hide) {
                    _this.tabs[i].active = true;
                    _this.tabs[i].loaded = true;
                    break;
                }
            }
        };
        this.reset = function () {
            var defaultSelected = false;
            for (var i = 0; i < _this.tabs.length; i++) {
                _this.tabs[i].loaded = false;
                if (!_this.tabs[i].hide && !defaultSelected) {
                    _this.switchTab(_this.tabs[i]);
                    defaultSelected = true;
                }
            }
        };
        this.switchToTab = function (tabName) {
            _this.switchTab(_this.getTabByName(tabName));
        };
        this.switchTab = function (tabToActivate) {
            _this.observerService.notify(_this.switchTabGroupEventName);
            if (_this.switchTabEventName) {
                _this.observerService.notify(_this.switchTabEventName, tabToActivate);
            }
            for (var i = 0; i < _this.tabs.length; i++) {
                _this.tabs[i].active = false;
            }
            tabToActivate.active = true;
            tabToActivate.loaded = true;
        };
        this.getTabByName = function (name) {
            for (var i = 0; i < _this.tabs.length; i++) {
                if (_this.tabs[i].name == name) {
                    return _this.tabs[i];
                }
            }
        };
        if (angular.isUndefined(this.tabs)) {
            this.tabs = [];
        }
        this.tabGroupID = "TG" + this.utilityService.createID(30);
        this.switchTabGroupEventName = "SwitchTabGroup" + this.tabGroupID;
        if (angular.isUndefined(this.initTabEventName)) {
            this.initTabEventName = "InitTabForTabGroup" + this.tabGroupID;
        }
        if (angular.isDefined(this.resetTabEventName)) {
            this.observerService.attach(this.reset, this.resetTabEventName);
        }
        if (angular.isDefined(this.switchToTabEventName)) {
            this.observerService.attach(this.switchToTab, this.switchToTabEventName);
        }
        this.observerService.attach(this.initTab, this.initTabEventName);
    }
    return SWTabGroupController;
}());
exports.SWTabGroupController = SWTabGroupController;
var SWTabGroup = /** @class */ (function () {
    function SWTabGroup() {
        this.transclude = true;
        this.restrict = "EA";
        this.scope = {};
        this.bindToController = {
            switchTabEventName: "@?",
            switchToTabEventName: "@?",
            initTabEventName: "@?",
            resetTabEventName: "@?"
        };
        this.controller = SWTabGroupController;
        this.controllerAs = "swTabGroup";
        this.template = __webpack_require__("+WG+");
    }
    SWTabGroup.Factory = function () {
        var _this = this;
        return /** @ngInject; */ function () { return new _this(); };
    };
    return SWTabGroup;
}());
exports.SWTabGroup = SWTabGroup;


/***/ }),

/***/ "774h":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/**********************************************************************************************
 **********************************************************************************************
 **********************************************************************************************
 **		___________________________________________
 ** 	Form Field - type have the following options (This is for the frontend so it can be modified):
 **
 **		checkbox			|	As a single checkbox this doesn't require any options, but it will create a hidden field for you so that the key gets submitted even when not checked.  The value of the checkbox will be 1
 **		checkboxgroup		|	Requires the valueOptions to be an array of simple value if name and value is same or array of structs with the format of {value="", name=""}
 **		file				|	No value can be passed in
 **		multiselect			|	Requires the valueOptions to be an array of simple value if name and value is same or array of structs with the format of {value="", name=""}
 **		password			|	No Value can be passed in
 **		radiogroup			|	Requires the valueOptions to be an array of simple value if name and value is same or array of structs with the format of {value="", name=""}
 **		select      		|	Requires the valueOptions to be an array of simple value if name and value is same or array of structs with the format of {value="", name=""}
 **		text				|	Simple Text Field
 **		textarea			|	Simple Textarea
 **		yesno				|	This is used by booleans and flags to create a radio group of Yes and No
 **		submit				|	submit button to post these properties back to the server.
 **		------------------------------------------------------------------------------------------------------
 **
 **		attr.valueObject" type="any" default="" />
 **		attr.valueObjectProperty" type="string" default="" />
 **
 **		General Settings that end up getting applied to the value object
 **		attr.type" type="string" default="text"
 **		attr.name" type="string" default=""
 **		attr.class" type="string" default=""
 **		attr.value" type="any" default=""
 **		attr.valueOptions" type="array" default="#arrayNew(1)#"		<!--- Used for select, checkbox group, multiselect --->
 **		attr.fieldAttributes" type="string" default=""
 **
 *********************************************************************************************
 *********************************************************************************************
 *********************************************************************************************
 */
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWFFormField = void 0;
/**
    * Property Display Controller handles the logic for this directive.
    */
var SWFFormFieldController = /** @class */ (function () {
    //@ngInject
    function SWFFormFieldController($scope, $element, $compile, utilityService) {
        this.$scope = $scope;
        this.$element = $element;
        this.$compile = $compile;
        this.utilityService = utilityService;
        this.utilityService = utilityService;
        this.$scope = $scope;
        this.$element = $element;
        this.$compile = $compile;
    }
    /**
        * Handles the logic for the frontend version of the property display.
        */
    SWFFormFieldController.$inject = ['$scope', '$element', '$compile', 'utilityService'];
    return SWFFormFieldController;
}());
/**
    * This class handles configuring formFields for use in process forms on the front end.
    */
var SWFFormField = /** @class */ (function () {
    function SWFFormField(coreFormPartialsPath, hibachiPathBuilder) {
        this.restrict = "E";
        this.require = { swfPropertyDisplayCtrl: "^?swfPropertyDisplay", form: "^?form" };
        this.controller = SWFFormFieldController;
        this.controllerAs = "swfFormField";
        this.scope = {};
        this.bindToController = {
            propertyDisplay: "=?",
            propertyIdentifier: "@?",
            name: "@?",
            class: "@?",
            errorClass: "@?",
            type: "@?"
        };
        this.link = function (scope, element, attrs, formController, transcludeFn) {
        };
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(coreFormPartialsPath) + 'swfformfield.html';
    }
    /**
        * Handles injecting the partials path into this class
        */
    SWFFormField.Factory = function () {
        var directive = function (coreFormPartialsPath, hibachiPathBuilder) { return new SWFFormField(coreFormPartialsPath, hibachiPathBuilder); };
        directive.$inject = [
            'coreFormPartialsPath',
            'hibachiPathBuilder'
        ];
        return directive;
    };
    return SWFFormField;
}());
exports.SWFFormField = SWFFormField;


/***/ }),

/***/ "7AdH":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.RequestService = void 0;
var adminrequest_1 = __webpack_require__("a1Ym");
var publicrequest_1 = __webpack_require__("/Gm/");
var RequestService = /** @class */ (function () {
    //@ngInject
    RequestService.$inject = ["$injector", "observerService"];
    function RequestService($injector, observerService) {
        var _this = this;
        this.$injector = $injector;
        this.observerService = observerService;
        this.newAdminRequest = function (url, data, method, headers, $injector, observerService) {
            if (method === void 0) { method = "post"; }
            if (headers === void 0) { headers = { 'Content-Type': "application/json" }; }
            if ($injector === void 0) { $injector = _this.$injector; }
            if (observerService === void 0) { observerService = _this.observerService; }
            return new adminrequest_1.AdminRequest(url, data, method, headers, $injector, observerService);
        };
        this.newPublicRequest = function (url, data, method, headers, $injector, observerService) {
            if (method === void 0) { method = "post"; }
            if (headers === void 0) { headers = { 'Content-Type': "application/x-www-form-urlencoded" }; }
            if ($injector === void 0) { $injector = _this.$injector; }
            if (observerService === void 0) { observerService = _this.observerService; }
            return new publicrequest_1.PublicRequest(url, data, method, headers, $injector, observerService);
        };
        this.$injector = $injector;
        this.observerService = observerService;
    }
    return RequestService;
}());
exports.RequestService = RequestService;


/***/ }),

/***/ "8EJg":
/***/ (function(module, exports) {

module.exports = "<div class=\"col-md-3 \">\n    <input type=\"hidden\" name=\"{{swOrderByControls.sortDefaultDirectionFieldName}}\" ng-value=\"swOrderByControls.sortCode\" />\n    <div class=\"s-select-wrapper s-titled-select-wrapper s-sort-by\"\n        data-ng-class=\"{'s-disabled':swOrderByControls.disabled || !swOrderByControls.edit}\"\n        >\n        <span>Sort By:</span>\n        <select class=\"form-control input-sm\"\n                name=\"{{swOrderByControls.sortPropertyFieldName}}\"\n                data-ng-model=\"swOrderByControls.selectedPropertyIdentifier\"\n                data-ng-change=\"swOrderByControls.updateSortOrderProperty()\"\n                data-ng-disabled=\"swOrderByControls.disabled || !swOrderByControls.edit\"\n                >\n\n            <option value=\"\" selected=\"\" sw-rbkey=\"'define.select'\"></option>\n\n            <option value=\"{{column.propertyIdentifier}}\" data-ng-show=\"column.isVisible\" data-ng-repeat=\"column in swOrderByControls.collectionConfig.columns track by $index\">\n                {{column.title}}\n            </option>\n        </select>\n    </div>\n\n    <div class=\"btn-group s-option-toggles\"\n        style=\"float: none; vertical-align: top;\"\n        role=\"group\"\n        aria-label=\"...\">\n        <button type=\"button\"\n                class=\"btn btn-default\"\n                data-ng-class=\"{'s-selected' : swOrderByControls.sortCode=='ASC'}\"\n                data-ng-click=\"swOrderByControls.sortAscending()\"\n                data-ng-disabled=\"!swOrderByControls.edit\"\n                data-toggle=\"popover\"\n                data-trigger=\"hover\"\n                data-placement=\"top\"\n                data-content=\"Ascending\"\n                >\n                <i class=\"fas fa-sort-alpha-up\" aria-hidden=\"true\"></i>\n        </button>\n        <button type=\"button\"\n                class=\"btn btn-default\"\n                data-ng-class=\"{'s-selected' : swOrderByControls.sortCode=='DESC'}\"\n                data-ng-click=\"swOrderByControls.sortDescending()\"\n                data-ng-disabled=\"!swOrderByControls.edit\"\n                data-toggle=\"popover\"\n                data-trigger=\"hover\"\n                data-placement=\"top\"\n                data-content=\"Descending\"\n                >\n                <i class=\"fas fa-sort-alpha-down\" aria-hidden=\"true\"></i>\n        </button>\n        <button type=\"button\"\n            class=\"btn btn-default\"\n            data-ng-class=\"{'s-selected' : swOrderByControls.sortCode=='MANUAL'}\"\n            data-ng-click=\"swOrderByControls.manualSort()\"\n            data-ng-disabled=\"!swOrderByControls.edit\"\n            data-toggle=\"popover\"\n            data-trigger=\"hover\"\n            data-placement=\"top\"\n            data-content=\"Manual\"\n            >\n            <i class=\"fa fa-bars\" aria-hidden=\"true\"></i>\n        </button>\n        <button ng-init=\"swOrderByControls.showToggleDisplayOptions=false\" class=\"btn btn-sm btn-default\" type=\"button\" ng-click=\"swOrderByControls.showToggleDisplayOptions=!swOrderByControls.showToggleDisplayOptions\">\n            <i class=\"fa fa-th\"></i>\n        </button>\n\n\n\n    </div>\n</div>\n\n<sw-listing-controls data-ng-if=\"swOrderByControls.swListingDisplay.collectionConfig != null\"\n    data-table-id=\"swOrderByControls.swListingDisplay.tableID\"\n    data-collection-config=\"swOrderByControls.swListingDisplay.collectionConfig\"\n    data-show-toggle-filters=\"false\"\n    data-display-options-closed=\"swOrderByControls.showToggleDisplayOptions\"\n    data-show-toggle-display-options=\"false\"\n    data-show-toggle-search=\"false\"\n    data-has-search=\"false\"\n    data-show-export=\"false\"\n    data-show-report=\"false\"\n    data-simple=\"false\"\n    data-ng-if=\"swOrderByControls.swListingDisplay.hasSearch !== false\">\n</sw-listing-controls>\n\n<!-- This probably won't end up being part of this directive -->\n";

/***/ }),

/***/ "8R05":
/***/ (function(module, exports) {

module.exports = "<div class=\"row s-body-nav\" ng-if=\"!swEntityActionBar.modal\">\n    <nav class=\"navbar navbar-default\" role=\"navigation\">\n      <div class=\"col-md-6 s-header-info\">\n\t\t\t<!-- Page Title -->\n\t\t\t<h1 class=\"actionbar-title\" ng-bind=\"swEntityActionBar.pageTitle\"></h1>\n\t\t</div>\n\n\t\t<div class=\"col-md-6\">\n\t\t\t<div class=\"btn-toolbar\" ng-if=\"swEntityActionBar.type === 'listing'\">\n\t\t\t\t<!-- ================ Listing =================== -->\n\t\t\t\t<ng-transclude></ng-transclude>\n\t\t\t</div>\n\t\t\t\t<!-- ================ Detail ===================== -->\n\t\t\t<div class=\"btn-toolbar\" ng-if=\"swEntityActionBar.type === 'detail'\">\n\t\t\t\t<div class=\"btn-group btn-group-sm\">\n\n\t\t\t\t\t<sw-action-caller data-title-rb-key=\"{{swEntityActionBar.backAction.replace(':','.')}}\"\n\t\t\t\t\t\t\t\t\t  data-event=\"{{swEntityActionBar.backEvent}}\"\n\t\t\t\t\t\t\t\t\t  data-action=\"{{swEntityActionBar.backAction}}\"\n\t\t\t\t\t\t\t\t\t  data-query-string=\"{{swEntityActionBar.backQueryString}}\"\n\t\t\t\t\t\t\t\t\t  data-class=\"btn btn-default\" \n\t\t\t\t\t\t\t\t\t  icon=\"arrow-left\">\n\t\t\t\t\t</sw-action-caller>\n\t\t\t\t\t\n\t\t\t\t\t<button ng-if=\"swEntityActionBar.processCallers.length > 0\"\n\t\t\t\t\t\t\tclass=\"btn dropdown-toggle btn-default\" \n\t\t\t\t\t\t\tdata-toggle=\"dropdown\" \n\t\t\t\t\t\t\taria-expanded=\"false\"\n\t\t\t\t\t\t\ttype=\"button\">\n\t\t\t\t\t\t<i class=\"icon-list-alt\"></i> Actions \n\t\t\t\t\t\t<span class=\"caret\"></span>\n\t\t\t\t\t</button>\n\t\t\t\t\t<ul class=\"dropdown-menu pull-right\" ng-if=\"swEntityActionBar.swProcessCallers\">\n\n\t\t\t\t\t\t<sw-process-caller ng-repeat=\"process in swEntityActionBar.swProcessCallers\"\n\t\t\t\t\t\t\t\t\t\t   data-action=\"{{process.action}}\"\n\t\t\t\t\t\t\t\t\t\t   data-modal=\"process.modal\"\n\t\t\t\t\t\t\t\t\t\t   data-process-context=\"{{process.processContext}}\"\n\t\t\t\t\t\t\t\t\t\t   data-query-string=\"{{process.queryString}}\"\n\t\t\t\t\t\t\t\t\t\t   data-type=\"list\">\n\t\t\t\t\n\t\t\t\t\t\t</sw-process-caller>\n\t\t\t\t\t</ul>\n\t\t\t\t</div>\t\n\t\t\t\t\n\t\t\t\t<!-- TODO: Print/Email Template Links -->\n\t\t\t\t<div class=\"btn-group btn-group-sm\">\n\t\t\t\t\t<div class=\"btn-group btn-group-sm\">\n\t\t\t\t\t\t<a class=\"btn dropdown-toggle btn-default\" data-toggle=\"dropdown\" href=\"#\" aria-expanded=\"false\"><i class=\"fa fa-envelope\"></i></a>\n\t\t\t\t\t\t<ul class=\"dropdown-menu pull-right\">\n\t\t\t\t\t\t\t<sw-process-caller ng-repeat=\"process in swEntityActionBar.swPrintProcessCallers\"\n\t\t\t\t\t\t\t\t\t\t   data-action=\"{{process.action}}\"\n\t\t\t\t\t\t\t\t\t\t   data-modal=\"process.modal\"\n\t\t\t\t\t\t\t\t\t\t   data-process-context=\"{{process.processContext}}\"\n\t\t\t\t\t\t\t\t\t\t   data-query-string=\"{{process.queryString}}\"\n\t\t\t\t\t\t\t\t\t\t   data-text=\"{{process.text}}\"\n\t\t\t\t\t\t\t\t\t\t   data-type=\"list\">\n\t\t\t\t\n\t\t\t\t\t\t</sw-process-caller>\n\t\t\t\t\t\t</ul>\n\t\t\t\t\t</div>\n\t\t\t\t</div>\n\t\t\t\t\n\t\t\t\t<div class=\"btn-group btn-group-sm\"></div>\n\t\t\t\t\n\t\t\t\t<div class=\"btn-group btn-group-sm\">\n\t\t\t\t\t\n\t\t\t\t\t<sw-action-caller data-display=\"!swEntityActionBar.edit\"\n\t\t\t\t\t\t\t\t\t  data-title-rb-key=\"define.edit\"\n\t\t\t\t\t\t\t\t\t  data-event=\"{{swEntityActionBar.editEvent}}\"\n\t\t\t\t\t\t\t\t\t  data-payload=\"swEntityActionBar.payload\"\n\t\t\t\t\t\t\t\t\t  data-action=\"{{swEntityActionBar.editAction}}\"\n\t\t\t\t\t\t\t\t\t  data-query-string=\"{{swEntityActionBar.editQueryString}}\"\n\t\t\t\t\t\t\t\t\t  data-class=\"btn btn-default\" \n\t\t\t\t\t\t\t\t\t  icon=\"pencil\">\n\t\t\t\t\t</sw-action-caller>\n\t\t\t\t\t\n\t\t\t\t\t<sw-action-caller data-display=\"swEntityActionBar.edit\"\n\t\t\t\t\t\t\t\t\t  data-title-rb-key=\"define.save\"\n\t\t\t\t\t\t\t\t\t  data-event=\"{{swEntityActionBar.saveEvent}}\"\n\t\t\t\t\t\t\t\t\t  data-payload=\"swEntityActionBar.payload\"\n\t\t\t\t\t\t\t\t\t  data-action=\"{{swEntityActionBar.saveAction}}\"\n\t\t\t\t\t\t\t\t\t  data-query-string=\"{{swEntityActionBar.saveQueryString}}\"\n\t\t\t\t\t\t\t\t\t  data-class=\"btn btn-success\" \n\t\t\t\t\t\t\t\t\t  icon=\"ok\">\n\t\t\t\t\t</sw-action-caller>\n\t\t\t\t\t\n\t\t\t\t\t<sw-action-caller data-display=\"swEntityActionBar.edit\"\n\t\t\t\t\t\t\t\t\t  data-title-rb-key=\"define.cancel\"\n\t\t\t\t\t\t\t\t\t  data-event=\"{{swEntityActionBar.cancelEvent}}\"\n\t\t\t\t\t\t\t\t\t  data-payload=\"swEntityActionBar.payload\"\n\t\t\t\t\t\t\t\t\t  data-action=\"{{swEntityActionBar.cancelAction}}\"\n\t\t\t\t\t\t\t\t\t  data-query-string=\"{{swEntityActionBar.cancelQueryString}}\"\n\t\t\t\t\t\t\t\t\t  data-class=\"btn btn-default\" \n\t\t\t\t\t\t\t\t\t  icon=\"remove\">\n\t\t\t\t\t</sw-action-caller>\n\t\t\t\t\t\n\t\t\t\t\t\n\t\t\t\t\t<sw-action-caller ng-if=\"swEntityActionBar.showDelete\"\n\t\t\t\t\t\t\t\t\t  data-title-rb-key=\"define.delete\"\n\t\t\t\t\t\t\t\t\t  data-event=\"{{swEntityActionBar.deleteEvent}}\"\n\t\t\t\t\t\t\t\t\t  data-payload=\"swEntityActionBar.payload\"\n\t\t\t\t\t\t\t\t\t  data-action=\"{{swEntityActionBar.deleteAction}}\"\n\t\t\t\t\t\t\t\t\t  data-query-string=\"{{swEntityActionBar.deleteQueryString}}\"\n\t\t\t\t\t\t\t\t\t  data-class=\"btn btn-default\" \n\t\t\t\t\t\t\t\t\t  icon=\"trash\">\n\t\t\t\t\t</sw-action-caller>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\n\t\t\t\t\t<!-- Detail: Email / Print \n\t\t\t\t\t<div class=\"btn-group btn-group-sm\">\n\t\t\t\t\t\t<cfif arrayLen(swEntityActionBar.object.getEmailTemplates()) || arrayLen(swEntityActionBar.object.getPrintTemplates())>\n\t\t\t\t\t\t\t<!-- Email \n\t\t\t\t\t\t\t<cfif arrayLen(swEntityActionBar.object.getEmailTemplates())>\n\t\t\t\t\t\t\t\t<div class=\"btn-group btn-group-sm\">\n\t\t\t\t\t\t\t\t\t<a class=\"btn dropdown-toggle btn-default\" data-toggle=\"dropdown\" href=\"##\"><i class=\"fa fa-envelope\"></i></a>\n\t\t\t\t\t\t\t\t\t<ul class=\"dropdown-menu pull-right\">\n\t\t\t\t\t\t\t\t\t\t<cfloop array=\"#swEntityActionBar.object.getEmailTemplates()#\" index=\"template\">\n\t\t\t\t\t\t\t\t\t\t\t<hb:HibachiProcessCaller action=\"admin:entity.preprocessemail\" entity=\"Email\" processContext=\"addToQueue\" queryString=\"emailTemplateID=#template.getEmailTemplateID()#&#swEntityActionBar.object.getPrimaryIDPropertyName()#=#swEntityActionBar.object.getPrimaryIDValue()#&redirectAction=#request.context.slatAction#\" text=\"#template.getEmailTemplateName()#\" modal=\"true\" modalfullwidth=\"true\" type=\"list\" />\n\t\t\t\t\t\t\t\t\t\t</cfloop>\n\t\t\t\t\t\t\t\t\t</ul>\n\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t</cfif>\n\t\t\t\t\t\t\t<!-- Print \n\t\t\t\t\t\t\t<cfif arrayLen(swEntityActionBar.object.getPrintTemplates())>\n\t\t\t\t\t\t\t\t<div class=\"btn-group btn-group-sm\">\n\t\t\t\t\t\t\t\t\t<a class=\"btn dropdown-toggle btn-default\" data-toggle=\"dropdown\" href=\"##\"><i class=\"fa fa-print\"></i></a>\n\t\t\t\t\t\t\t\t\t<ul class=\"dropdown-menu pull-right\">\n\t\t\t\t\t\t\t\t\t\t<cfloop array=\"#swEntityActionBar.object.getPrintTemplates()#\" index=\"template\">\n\t\t\t\t\t\t\t\t\t\t\t<hb:HibachiProcessCaller action=\"admin:entity.processprint\" entity=\"Print\" processContext=\"addToQueue\" queryString=\"printTemplateID=#template.getPrintTemplateID()#&printID=&#swEntityActionBar.object.getPrimaryIDPropertyName()#=#swEntityActionBar.object.getPrimaryIDValue()#&redirectAction=#request.context.slatAction#\" text=\"#template.getPrintTemplateName()#\" type=\"list\" />\n\t\t\t\t\t\t\t\t\t\t</cfloop>\n\t\t\t\t\t\t\t\t\t</ul>\n\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t</cfif>\n\t\t\t\t\t\t</cfif>\n\t\t\t\t\t</div>\n\t\t\t\t\t<!-- Detail: Print \n\n\t\t\t\t\t<!-- Detail: Additional Button Groups \n\t\t\t\t\t<cfif structKeyExists(thistag, \"buttonGroups\") && arrayLen(thistag.buttonGroups)>\n\t\t\t\t\t\t<cfloop array=\"#thisTag.buttonGroups#\" index=\"buttonGroup\">\n\t\t\t\t\t\t\t<cfif structKeyExists(buttonGroup, \"generatedContent\") && len(buttonGroup.generatedContent)>\n\t\t\t\t\t\t\t\t#buttonGroup.generatedContent#\n\t\t\t\t\t\t\t</cfif>\n\t\t\t\t\t\t</cfloop>\n\t\t\t\t\t</cfif>\n\n\t\t\t\t\t<!-- Detail: CRUD Buttons \n\t\t\t\t\t\n\t\t\t\t\t<div class=\"btn-group btn-group-sm\">\n\t\t\t\t\t\t<!-- Setup delete Details \n\t\t\t\t\t\t<cfset local.deleteErrors = swEntityActionBar.hibachiScope.getService(\"hibachiValidationService\").validate(object=swEntityActionBar.object, context=\"delete\", setErrors=false) />\n\t\t\t\t\t\t<cfset local.deleteDisabled = local.deleteErrors.hasErrors() />\n\t\t\t\t\t\t<cfset local.deleteDisabledText = local.deleteErrors.getAllErrorsHTML() />\n\n\t\t\t\t\t\t<cfif swEntityActionBar.edit>\n\t\t\t\t\t\t\t<!-- Delete \n\t\t\t\t\t\t\t<cfif not swEntityActionBar.object.isNew() and swEntityActionBar.showdelete>\n\t\t\t\t\t\t\t\t<cfset swEntityActionBar.deleteQueryString = listAppend(swEntityActionBar.deleteQueryString, \"#swEntityActionBar.object.getPrimaryIDPropertyName()#=#swEntityActionBar.object.getPrimaryIDValue()#\", \"&\") />\n\t\t\t\t\t\t\t\t<hb:HibachiActionCaller action=\"#swEntityActionBar.deleteAction#\" querystring=\"#swEntityActionBar.deleteQueryString#\" text=\"#swEntityActionBar.hibachiScope.rbKey('define.delete')#\" class=\"btn btn-default s-remove\" icon=\"trash icon-white\" confirm=\"true\" disabled=\"#local.deleteDisabled#\" disabledText=\"#local.deleteDisabledText#\">\n\t\t\t\t\t\t\t</cfif>\n\n\t\t\t\t\t\t\t<!-- Cancel \n\t\t\t\t\t\t\t<cfif !len(swEntityActionBar.cancelQueryString)>\n\t\t\t\t\t\t\t\t<!-- Setup default cancel query string \n\t\t\t\t\t\t\t\t<cfset swEntityActionBar.cancelQueryString = \"#swEntityActionBar.object.getPrimaryIDPropertyName()#=#swEntityActionBar.object.getPrimaryIDValue()#\" />\n\t\t\t\t\t\t\t</cfif>\n\t\t\t\t\t\t\t<hb:HibachiActionCaller action=\"#swEntityActionBar.cancelAction#\" querystring=\"#swEntityActionBar.cancelQueryString#\" text=\"#swEntityActionBar.hibachiScope.rbKey('define.cancel')#\" class=\"btn btn-default\" icon=\"remove icon-white\">\n\n\t\t\t\t\t\t\t<!-- Save \n\t\t\t\t\t\t\t<hb:HibachiActionCaller action=\"#request.context.entityActionDetails.saveAction#\" text=\"#swEntityActionBar.hibachiScope.rbKey('define.save')#\" class=\"btn btn-success\" type=\"button\" submit=\"true\" icon=\"ok icon-white\">\n\t\t\t\t\t\t<cfelse>\n\t\t\t\t\t\t\t<!-- Delete \n\t\t\t\t\t\t\t<cfif swEntityActionBar.showdelete>\n\t\t\t\t\t\t\t\t<cfset swEntityActionBar.deleteQueryString = listAppend(swEntityActionBar.deleteQueryString, \"#swEntityActionBar.object.getPrimaryIDPropertyName()#=#swEntityActionBar.object.getPrimaryIDValue()#\", \"&\") />\n\t\t\t\t\t\t\t\t<hb:HibachiActionCaller action=\"#swEntityActionBar.deleteAction#\" querystring=\"#swEntityActionBar.deleteQueryString#\" text=\"#swEntityActionBar.hibachiScope.rbKey('define.delete')#\" class=\"btn btn-default s-remove\" icon=\"trash icon-white\" confirm=\"true\" disabled=\"#local.deleteDisabled#\" disabledText=\"#local.deleteDisabledText#\">\n\t\t\t\t\t\t\t</cfif>\n\n\t\t\t\t\t\t\t<!-- Edit \n\t\t\t\t\t\t\t<cfif swEntityActionBar.showedit>\n\t\t\t\t\t\t\t\t<hb:HibachiActionCaller action=\"#request.context.entityActionDetails.editAction#\" querystring=\"#swEntityActionBar.object.getPrimaryIDPropertyName()#=#swEntityActionBar.object.getPrimaryIDValue()#\" text=\"#swEntityActionBar.hibachiScope.rbKey('define.edit')#\" class=\"btn btn-default\" icon=\"pencil icon-white\" submit=\"true\" disabled=\"#swEntityActionBar.object.isNotEditable()#\">\n\t\t\t\t\t\t\t</cfif>\n\t\t\t\t\t\t</cfif>\n\t\t\t\t\t</div>\n\t\t\t\t</div>\n\t\t\t\t\n\t\t\t\t<!-- ================= Process =================== \n\t\t\t\t<div ng-if=\"swEntityActionBar.type === 'preprocess'\">\n\n\t\t\t\t\t<cfif !len(swEntityActionBar.processContext) and structKeyExists(request.context, \"processContext\")>\n\t\t\t\t\t\t<cfset swEntityActionBar.processContext = request.context.processContext />\n\t\t\t\t\t</cfif>\n\t\t\t\t\t<cfif !len(swEntityActionBar.processAction) and structKeyExists(request.context.entityActionDetails, \"processAction\")>\n\t\t\t\t\t\t<cfset swEntityActionBar.processAction = request.context.entityActionDetails.processAction />\n\t\t\t\t\t</cfif>\n\t\t\t\t\t<div class=\"btn-group btn-group-sm\">\n\t\t\t\t\t\t<hb:HibachiActionCaller action=\"#swEntityActionBar.backAction#\" queryString=\"#swEntityActionBar.backQueryString#\" class=\"btn btn-default\" icon=\"arrow-left\">\n\t\t\t\t\t</div>\n\t\t\t\t\t<div class=\"btn-group btn-group-sm\">\n\t\t\t\t\t\t<button type=\"submit\" class=\"btn btn-primary\">#swEntityActionBar.hibachiScope.rbKey( \"entity.#swEntityActionBar.object.getClassName()#.process.#swEntityActionBar.processContext#\" )#</button>\n\t\t\t\t\t</div>\n\t\t\t\t</div>-->\n\t\t\t</div>\n\t\t</div>\n\t</nav>\n</div>\n\n<ng-transclude ng-if=\"swEntityActionBar.modal\"></ng-transclude>\n\n<div ng-repeat=\"message in swEntityActionBar.messages\"\n\t\t class=\"alert alert-{{message.messageType}} fade in\">\n\n\t\t <a class=\"close\" data-dismiss=\"alert\"><i class=\"fa fa-times\"></i></a>\n\n\t\t {{message.message}}\n</div>";

/***/ }),

/***/ "92bl":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.Request = void 0;
/// <reference path='../../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../typings/tsd.d.ts' />
var basetransient_1 = __webpack_require__("zLAs");
var Request = /** @class */ (function (_super) {
    __extends(Request, _super);
    function Request(url, data, method, headers, $injector) {
        var _this = _super.call(this, $injector) || this;
        _this.loading = true;
        _this.errors = {};
        _this.processResponse = function (response) {
            _this.loading = false;
            if (response === null || response === void 0 ? void 0 : response.errors) {
                _this.errors = response.errors;
            }
            if (response === null || response === void 0 ? void 0 : response.messages) {
                _this.messages = response.messages;
            }
        };
        //returns hibachiAction value from url and data;
        _this.getAction = function () {
            var config = _this.getAppConfig();
            //typically hibachiAction
            var actionName = config.action;
            var params = _this.utilityService.getQueryParamsFromUrl(_this.url);
            if (params[actionName]) {
                return params[actionName];
            }
            if (_this.data && _this.data[actionName]) {
                return _this.data[actionName];
            }
            if (_this.url.indexOf('api/scope/') > 0) {
                return _this.extractPublicAction(_this.url);
            }
        };
        _this.extractPublicAction = function (url) {
            //get in between api/scope and / or ? or end of word
            var regex = /api\/scope\/(.*?)(?=\/|\?|$)/;
            var arr = regex.exec(url);
            return arr[1];
        };
        _this.processSuccess = function (response) {
            _this.processResponse(response);
        };
        _this.processError = function (response) {
            _this.processResponse(response);
        };
        /** used to turn data into a correct format for the post */
        _this.toFormParams = function (data) {
            if (data) {
                return $.param(data);
            }
            else {
                return "";
            }
            //return data = this.serializeData(data) || "";
        };
        _this.serializeData = function (data) {
            // If this is not an object, defer to native stringification.
            if (!angular.isObject(data)) {
                return ((data == null) ? "" : data.toString());
            }
            var buffer = [];
            // Serialize each key in the object.
            for (var name in data) {
                if (!data.hasOwnProperty(name)) {
                    continue;
                }
                var value = data[name];
                buffer.push(encodeURIComponent(name) + "=" + encodeURIComponent((value == null) ? "" : value));
            }
            // Serialize the buffer and clean it up for transportation.
            var source = buffer.join("&").replace(/%20/g, "+");
            return (source);
        };
        _this.headers = headers;
        _this.$q = _this.getService('$q');
        _this.$http = _this.getService('$http');
        _this.$window = _this.getService('$window');
        _this.url = url;
        _this.data = data;
        _this.method = method;
        _this.utilityService = _this.getService('utilityService');
        if (!method) {
            if (data == undefined) {
                method = "get";
            }
            else {
                method = "post";
            }
        }
        var deferred = _this.$q.defer();
        if (method.toLowerCase() == "post") {
            if (_this.headers['Content-Type'] !== "application/json") {
                data = _this.toFormParams(data);
            }
            //post
            var promise = _this.$http({
                url: url, data: data, headers: _this.headers, method: 'post'
            })
                .success(function (result) {
                _this.processSuccess(result);
                deferred.resolve(result);
            }).error(function (response) {
                _this.processError(response);
                deferred.reject(response);
            });
            _this.promise = deferred.promise;
        }
        else {
            //get
            _this.$http({ url: url, method: 'get' })
                .success(function (result) {
                _this.processSuccess(result);
                deferred.resolve(result);
            }).error(function (reason) {
                _this.processError(reason);
                deferred.reject(reason);
            });
            _this.promise = deferred.promise;
        }
        return _this;
    }
    return Request;
}(basetransient_1.BaseTransient));
exports.Request = Request;


/***/ }),

/***/ "9QRl":
/***/ (function(module, exports) {

module.exports = "<ng-transclude></ng-transclude>";

/***/ }),

/***/ "9nh9":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.OrderPayment = void 0;
var OrderPayment = /** @class */ (function () {
    function OrderPayment() {
    }
    return OrderPayment;
}());
exports.OrderPayment = OrderPayment;


/***/ }),

/***/ "9zUE":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWFormFieldJson = void 0;
var SWFormFieldJsonController = /** @class */ (function () {
    //@ngInject
    SWFormFieldJsonController.$inject = ["formService"];
    function SWFormFieldJsonController(formService) {
        this.propertyDisplay.form.$dirty = this.propertyDisplay.isDirty;
    }
    return SWFormFieldJsonController;
}());
var SWFormFieldJson = /** @class */ (function () {
    function SWFormFieldJson(coreFormPartialsPath, hibachiPathBuilder) {
        this.restrict = 'E';
        this.require = "^form";
        this.scope = true;
        this.controller = SWFormFieldJsonController;
        this.bindToController = {
            propertyDisplay: "=?"
        };
        this.controllerAs = "ctrl";
        this.templateUrl = "";
        this.link = function (scope, element, attrs, formController) { };
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(coreFormPartialsPath) + "json.html";
    }
    SWFormFieldJson.Factory = function () {
        var directive = function (coreFormPartialsPath, hibachiPathBuilder) { return new SWFormFieldJson(coreFormPartialsPath, hibachiPathBuilder); };
        directive.$inject = [
            'coreFormPartialsPath',
            'hibachiPathBuilder'
        ];
        return directive;
    };
    return SWFormFieldJson;
}());
exports.SWFormFieldJson = SWFormFieldJson;


/***/ }),

/***/ "AOdl":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWNumbersOnly = void 0;
var SWNumbersOnly = /** @class */ (function () {
    function SWNumbersOnly() {
        this.restrict = "A";
        this.require = "ngModel";
        this.scope = {
            ngModel: '=',
            minNumber: '=?',
            maxNumber: '=?'
        };
        this.link = function ($scope, element, attrs, modelCtrl) {
            modelCtrl.$parsers.unshift(function (inputValue) {
                var modelValue = modelCtrl.$modelValue;
                if (inputValue != "" && !isNaN(Number(inputValue))) {
                    if (angular.isDefined($scope.minNumber)) {
                        if (Number(inputValue) >= $scope.minNumber || !angular.isDefined($scope.minNumber)) {
                            modelCtrl.$setValidity("minNumber", true);
                        }
                        else if (angular.isDefined($scope.minNumber)) {
                            modelCtrl.$setValidity("minNumber", false);
                        }
                    }
                    if (angular.isDefined($scope.maxNumber)) {
                        if (Number(inputValue) <= $scope.maxNumber || !angular.isDefined($scope.maxNumber)) {
                            modelCtrl.$setValidity("maxNumber", true);
                        }
                        else if (angular.isDefined($scope.maxNumber)) {
                            modelCtrl.$setValidity("maxNumber", false);
                        }
                    }
                    if (modelCtrl.$valid) {
                        modelValue = Number(inputValue);
                    }
                    else {
                        modelValue = $scope.minNumber;
                    }
                }
                return modelValue;
            });
        };
    }
    SWNumbersOnly.Factory = function () {
        var directive = function () { return new SWNumbersOnly(); };
        directive.$inject = [];
        return directive;
    };
    return SWNumbersOnly;
}());
exports.SWNumbersOnly = SWNumbersOnly;


/***/ }),

/***/ "Aj5l":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWValidationMinLength = void 0;
var SWValidationMinLength = /** @class */ (function () {
    function SWValidationMinLength($log, validationService) {
        return {
            restrict: "A",
            require: "^ngModel",
            link: function (scope, element, attributes, ngModel) {
                ngModel.$validators.swvalidationminlength =
                    function (modelValue, viewValue) {
                        var length = 0;
                        if (viewValue && viewValue.length) {
                            length = viewValue.length;
                        }
                        return validationService.validateMinLength(length || 0, attributes.swvalidationminlength);
                    };
            }
        };
    }
    SWValidationMinLength.Factory = function () {
        var directive = function ($log, validationService) { return new SWValidationMinLength($log, validationService); };
        directive.$inject = ['$log', 'validationService'];
        return directive;
    };
    return SWValidationMinLength;
}());
exports.SWValidationMinLength = SWValidationMinLength;


/***/ }),

/***/ "Al1n":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWColumnSorter = void 0;
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWColumnSorter = /** @class */ (function () {
    //@ngInject
    SWColumnSorter.$inject = ["observerService"];
    function SWColumnSorter(observerService) {
        var _this = this;
        this.observerService = observerService;
        this.template = __webpack_require__("G6jK");
        this.restrict = 'AE';
        this.scope = {
            column: "=",
        };
        this.link = function (scope, element, attrs) {
            var orderBy = {
                "propertyIdentifier": scope.column.propertyIdentifier,
            };
            scope.sortAsc = function () {
                orderBy.direction = 'Asc';
                _this.observerService.notify('sortByColumn', orderBy);
            };
            scope.sortDesc = function () {
                orderBy.direction = 'Desc';
                _this.observerService.notify('sortByColumn', orderBy);
            };
        };
    }
    SWColumnSorter.Factory = function () {
        var _this = this;
        return /** @ngInject; */ ["observerService", function (observerService) { return new _this(observerService); }];
    };
    return SWColumnSorter;
}());
exports.SWColumnSorter = SWColumnSorter;


/***/ }),

/***/ "Aozq":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var __assign = (this && this.__assign) || function () {
    __assign = Object.assign || function(t) {
        for (var s, i = 1, n = arguments.length; i < n; i++) {
            s = arguments[i];
            for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p))
                t[p] = s[p];
        }
        return t;
    };
    return __assign.apply(this, arguments);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ModalServiceProvider = exports.ModalService = exports.ConfigOptions = exports.angularModalModule = void 0;
var ConfigOptions = /** @class */ (function () {
    function ConfigOptions() {
        this.closeDelay = 0;
        //TODO: add more options here like, body-class
    }
    return ConfigOptions;
}());
exports.ConfigOptions = ConfigOptions;
var ModalServiceProvider = /** @class */ (function () {
    function ModalServiceProvider() {
        this._config = new ConfigOptions();
    }
    ModalServiceProvider.prototype.configureOptions = function (overrides) {
        this._config = __assign(__assign({}, this._config), overrides); //merge with overriding 
    };
    /** @ngInject */
    ModalServiceProvider.prototype.$get = function ($animate, $q, $http, $timeout, $compile, $document, $rootScope, $controller, $templateRequest) {
        return new ModalService($animate, $q, $http, $timeout, $compile, $document, $rootScope, $controller, $templateRequest, this._config);
    };
    ModalServiceProvider.prototype.$get.$inject = ["$animate", "$q", "$http", "$timeout", "$compile", "$document", "$rootScope", "$controller", "$templateRequest"];
    ;
    return ModalServiceProvider;
}());
exports.ModalServiceProvider = ModalServiceProvider;
var ModalService = /** @class */ (function () {
    function ModalService($animate, $q, $http, $timeout, $compile, $document, $rootScope, $controller, $templateRequest, configOptions) {
        var _this = this;
        this.$animate = $animate;
        this.$q = $q;
        this.$http = $http;
        this.$timeout = $timeout;
        this.$compile = $compile;
        this.$document = $document;
        this.$rootScope = $rootScope;
        this.$controller = $controller;
        this.$templateRequest = $templateRequest;
        this.configOptions = configOptions;
        //  Track open modals.
        this.openModals = [];
        //  Returns a promise which gets the template, either
        //  from the template parameter or via a request to the
        //  template url parameter.
        this.getTemplate = function (template, templateUrl) {
            var deferred = _this.$q.defer();
            if (template) {
                deferred.resolve(template);
            }
            else if (templateUrl) {
                _this.$templateRequest(templateUrl, true)
                    .then(function (template) { return deferred.resolve(template); })
                    .catch(function (e) { return deferred.reject(e); });
            }
            else {
                deferred.reject("No template or templateUrl has been specified.");
            }
            return deferred.promise;
        };
        /**
         * Adds an element to the DOM as the last child of its container
         * like append, but uses $animate to handle animations. Returns a
         * promise that is resolved once all animation is complete.
         *
        */
        this.appendChild = function (parent, child) {
            var children = parent.children();
            if (children.length > 0) {
                return _this.$animate.enter(child, parent, children[children.length - 1]);
            }
            return _this.$animate.enter(child, parent);
        };
        /**
         * Close all modals, providing the given result to the close promise.
        */
        this.closeModals = function (result, delay) {
            delay = delay || _this.configOptions.closeDelay;
            while (_this.openModals.length) {
                _this.openModals[0].close(result, delay);
                _this.openModals.splice(0, 1);
            }
        };
        /*
         *  Creates a controller with scope bindings
        */
        this.buildComponentController = function (options) {
            return ['$scope', 'close', function ($scope, close) {
                    $scope.close = close;
                    $scope.bindings = options.bindings;
                }];
        };
        /*
         *  Creates a component template
         *
         *  Input:
         *
         *    {
         *       component: 'myComponent',
         *       bindings: {
         *         name: 'Foo',
         *         phoneNumber: '123-456-7890'
         *       }
         *    }
         *
         *  Output:
         *
         *    '<my-component close="close" name="bindings.name" phone-number="bindings.phoneNumber"></my-component>'
        */
        this.buildComponentTemplate = function (options) {
            var kebabCase = function (camelCase) {
                return camelCase.replace(/([a-z0-9])([A-Z])/g, function (_m, c1, c2) {
                    return [c1, c2].join('-').toLowerCase();
                });
            };
            var makeBundingAttributes = function (bindings) {
                return Object.keys(bindings || {}).map(function (key) { return kebabCase(key) + "=\"bindings." + key + "\""; }).join(' ');
            };
            return "<" + kebabCase(options.component) + " close=\"close\" " + makeBundingAttributes(options.bindings) + " ></" + kebabCase(options.component) + ">";
        };
        this.setupComponentOptions = function (options) {
            options.controller = _this.buildComponentController(options);
            options.template = _this.buildComponentTemplate(options);
        };
        this.showModal = function (options) {
            if (options.component) {
                _this.setupComponentOptions(options);
            }
            //  Get the body of the document, we'll add the modal to this.
            // @ts-ignore
            var body = angular.element(_this.$document[0].body);
            //  Create a deferred we'll resolve when the modal is ready.
            var deferred = _this.$q.defer();
            //  Validate the input parameters.
            var controllerName = options.controller;
            if (!controllerName) {
                deferred.reject("No controller has been specified.");
                return deferred.promise;
            }
            //  Get the actual html of the template.
            _this.getTemplate(options.template, options.templateUrl)
                .then(function (template) {
                //  The main modal object we will build.
                var modal = {};
                //  Create a new scope for the modal.
                var modalScope = (options.scope || _this.$rootScope).$new();
                if (options.bindings) {
                    modalScope.bindings = options.bindings;
                }
                var rootScopeOnClose = null;
                var locationChangeSuccess = options.locationChangeSuccess;
                //  Allow locationChangeSuccess event registration to be configurable.
                //  True (default) = event registered with defaultCloseDelay
                //  # (greater than 0) = event registered with delay
                //  False = disabled
                if (locationChangeSuccess === false) {
                    rootScopeOnClose = angular.noop;
                }
                else if (angular.isNumber(locationChangeSuccess) && locationChangeSuccess >= 0) {
                    _this.$timeout(function () {
                        rootScopeOnClose = _this.$rootScope.$on('$locationChangeSuccess', inputs.close);
                    }, locationChangeSuccess);
                }
                else {
                    _this.$timeout(function () {
                        rootScopeOnClose = _this.$rootScope.$on('$locationChangeSuccess', inputs.close);
                    }, _this.configOptions.closeDelay);
                }
                //  Create the inputs object to the controller - this will include
                //  the scope, as well as all inputs provided.
                //  We will also create a deferred that is resolved with a provided
                //  close function. The controller can then call 'close(result)'.
                //  The controller can also provide a delay for closing - this is
                //  helpful if there are closing animations which must finish first.
                var closeDeferred = _this.$q.defer();
                var closedDeferred = _this.$q.defer();
                var hasAlreadyBeenClosed = false;
                var inputs = {
                    $scope: modalScope,
                    $element: null,
                    close: function (result, delay) {
                        if (hasAlreadyBeenClosed) {
                            return;
                        }
                        hasAlreadyBeenClosed = true;
                        delay = delay || _this.configOptions.closeDelay;
                        //  If we have a pre-close function, call it.
                        if (typeof options.preClose === 'function') {
                            options.preClose(modal, result, delay);
                        }
                        if (delay === undefined || delay === null) {
                            delay = 0;
                        }
                        _this.$timeout(function () { return cleanUpClose(result); }, delay);
                    }
                };
                //  If we have provided any inputs, pass them to the controller.
                if (options.inputs)
                    angular.extend(inputs, options.inputs);
                //  Compile then link the template element, building the actual element.
                //  Set the $element on the inputs so that it can be injected if required.
                var linkFn = _this.$compile(template);
                var modalElement = linkFn(modalScope);
                inputs.$element = modalElement;
                //  Create the controller, explicitly specifying the scope to use.
                var controllerObjBefore = modalScope[options.controllerAs];
                // https://github.com/angular/angular.js/blob/v1.6.10/src/ng/controller.js#L102
                // @ts-ignore 
                var modalController = _this.$controller(options.controller, inputs, true, options.controllerAs);
                if (options.controllerAs && controllerObjBefore) {
                    angular.extend(modalController, controllerObjBefore);
                }
                modalScope.close = inputs.close;
                //  Then, append the modal to the dom.
                var appendTarget = body; // append to body when no custom append element is specified
                if (angular.isString(options.appendElement)) {
                    // query the document for the first element that matches the selector
                    // and create an angular element out of it.
                    appendTarget = angular.element(_this.$document[0].querySelector(options.appendElement));
                }
                else if (options.appendElement) {
                    // append to custom append element
                    appendTarget = options.appendElement;
                }
                _this.appendChild(appendTarget, modalElement);
                // Finally, append any custom classes to the body
                if (options.bodyClass) {
                    body[0].classList.add(options.bodyClass);
                }
                //  Populate the modal object...
                modal.controller = modalController;
                modal.scope = modalScope;
                modal.element = modalElement;
                modal.close = closeDeferred.promise;
                modal.closed = closedDeferred.promise;
                // $onInit is part of the component lifecycle introduced in AngularJS 1.6.x
                // Because it may not be defined on all controllers,
                // we must check for it before attempting to invoke it.
                // https://docs.angularjs.org/guide/component#component-based-application-architecture
                if (angular.isFunction(modal.controller.$onInit)) {
                    modal.controller.$onInit();
                }
                //  ...which is passed to the caller via the promise.
                deferred.resolve(modal);
                // Clear previous input focus to avoid open multiple modals on enter
                // @ts-ignore
                document.activeElement.blur();
                //  We can track this modal in our open modals.
                _this.openModals.push({ modal: modal, close: inputs.close });
                var cleanUpClose = function (result) {
                    //  Resolve the 'close' promise.
                    closeDeferred.resolve(result);
                    //  Remove the custom class from the body
                    if (options.bodyClass) {
                        body[0].classList.remove(options.bodyClass);
                    }
                    //  Let angular remove the element and wait for animations to finish.
                    _this.$animate.leave(modalElement).then(function () {
                        // prevent error if modal is already destroyed
                        if (!modalElement) {
                            return;
                        }
                        //  Resolve the 'closed' promise.
                        closedDeferred.resolve(result);
                        //  We can now clean up the scope
                        modalScope.$destroy();
                        //  Remove the modal from the set of open modals.
                        for (var i = 0; i < _this.openModals.length; i++) {
                            if (_this.openModals[i].modal === modal) {
                                _this.openModals.splice(i, 1);
                                break;
                            }
                        }
                        //  Unless we null out all of these objects we seem to suffer
                        //  from memory leaks, if anyone can explain why then I'd
                        //  be very interested to know.
                        inputs.close = null;
                        deferred = null;
                        closeDeferred = null;
                        modal = null;
                        inputs = null;
                        modalElement = null;
                        modalScope = null;
                    });
                    // remove event watcher
                    rootScopeOnClose && rootScopeOnClose();
                };
            })
                .then(null, function (error) {
                deferred.reject(error);
            })
                .catch(deferred.reject);
            return deferred.promise;
        };
    }
    return ModalService;
}());
exports.ModalService = ModalService;
var angularModalModule = angular.module('angular.modal.module', [])
    .provider("ModalService", ModalServiceProvider);
exports.angularModalModule = angularModalModule;


/***/ }),

/***/ "BFGO":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.AccountAddress = exports.Sku = exports.OrderPayment = exports.OrderItem = exports.Cart = exports.Address = exports.Account = void 0;
var account_1 = __webpack_require__("Kpoy");
Object.defineProperty(exports, "Account", { enumerable: true, get: function () { return account_1.Account; } });
var address_1 = __webpack_require__("ebf+");
Object.defineProperty(exports, "Address", { enumerable: true, get: function () { return address_1.Address; } });
var cart_1 = __webpack_require__("d5NH");
Object.defineProperty(exports, "Cart", { enumerable: true, get: function () { return cart_1.Cart; } });
var orderitem_1 = __webpack_require__("odag");
Object.defineProperty(exports, "OrderItem", { enumerable: true, get: function () { return orderitem_1.OrderItem; } });
var orderpayment_1 = __webpack_require__("9nh9");
Object.defineProperty(exports, "OrderPayment", { enumerable: true, get: function () { return orderpayment_1.OrderPayment; } });
var sku_1 = __webpack_require__("gkWZ");
Object.defineProperty(exports, "Sku", { enumerable: true, get: function () { return sku_1.Sku; } });
var accountaddress_1 = __webpack_require__("3tV0");
Object.defineProperty(exports, "AccountAddress", { enumerable: true, get: function () { return accountaddress_1.AccountAddress; } });


/***/ }),

/***/ "BrcS":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.Alert = void 0;
//model
var Alert = /** @class */ (function () {
    function Alert(msg, type, fade, dismissable) {
        this.fade = false;
        this.dismissable = false;
        this.msg = msg;
        this.type = type;
        this.fade = fade;
        this.dismissable = dismissable;
    }
    return Alert;
}());
exports.Alert = Alert;


/***/ }),

/***/ "CamD":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.DraggableService = void 0;
var DraggableService = /** @class */ (function () {
    //@ngInject
    function DraggableService() {
        this.isDropAllowed = function (event) {
            //todo implement
            return true;
        };
        this.isMouseInFirstHalf = function (event, targetNode, relativeToParent, horizontal) {
            var mousePointer = horizontal ? (event.offsetX || event.layerX)
                : (event.offsetY || event.layerY);
            var targetSize = horizontal ? targetNode.offsetWidth : targetNode.offsetHeight;
            var targetPosition = horizontal ? targetNode.offsetLeft : targetNode.offsetTop;
            targetPosition = relativeToParent ? targetPosition : 0;
            return mousePointer < targetPosition + targetSize / 2;
        };
    }
    return DraggableService;
}());
exports.DraggableService = DraggableService;


/***/ }),

/***/ "Ci1q":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.DialogService = void 0;
var DialogService = /** @class */ (function () {
    function DialogService(hibachiPathBuilder) {
        var _this = this;
        this.hibachiPathBuilder = hibachiPathBuilder;
        this.get = function () {
            return _this._pageDialogs || [];
        };
        this.addPageDialog = function (name, params) {
            var newDialog = {
                'path': name + '.html',
                'params': params
            };
            _this._pageDialogs.push(newDialog);
        };
        this.removePageDialog = function (index) {
            _this._pageDialogs.splice(index, 1);
        };
        this.getPageDialogs = function () {
            return _this._pageDialogs;
        };
        this.removeCurrentDialog = function () {
            _this._pageDialogs.splice(_this._pageDialogs.length - 1, 1);
        };
        this.getCurrentDialog = function () {
            return _this._pageDialogs[_this._pageDialogs.length - 1];
        };
        this._pageDialogs = [];
        this.hibachiPathBuilder = hibachiPathBuilder;
    }
    DialogService.$inject = [
        'hibachiPathBuilder'
    ];
    return DialogService;
}());
exports.DialogService = DialogService;


/***/ }),

/***/ "DJjK":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/**
 * This validate directive will look at the current element, figure out the context (save, edit, delete) and
 * validate based on that context as defined in the validation properties object.
 */
// 'use strict';
// angular.module('slatwalladmin').directive('swValidate',
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWValidate = void 0;
// [ '$log','$hibachi', function($log, $hibachi) {
var SWValidate = /** @class */ (function () {
    function SWValidate($log, $hibachi) {
        return {
            restrict: "A",
            require: '^ngModel',
            link: function (scope, elem, attr, ngModel) {
                //Define our contexts and validation property enums.
                var ContextsEnum = {
                    SAVE: { name: "save", value: 0 },
                    DELETE: { name: "delete", value: 1 },
                    EDIT: { name: "edit", value: 2 }
                };
                var ValidationPropertiesEnum = {
                    REGEX: { name: "regex", value: 0 },
                    MIN_VALUE: { name: "minValue", value: 1 },
                    MAX_VALUE: { name: "maxValue", value: 2 },
                    EQ: { name: "eq", value: 3 },
                    NEQ: { name: "neq", value: 4 },
                    UNIQUE: { name: "unique", value: 5 },
                    LTE: { name: "lte", value: 6 },
                    GTE: { name: "gte", value: 7 },
                    MIN_LENGTH: { name: "minLength", value: 8 },
                    MAX_LENGTH: { name: "maxLength", value: 9 },
                    DATA_TYPE: { name: "dataType", value: 10 },
                    REQUIRED: { name: "required", value: 11 }
                };
                scope.validationPropertiesEnum = ValidationPropertiesEnum;
                scope.contextsEnum = ContextsEnum;
                var myCurrentContext = scope.contextsEnum.SAVE; //We are only checking the save context right now.
                var contextNamesArray = getNamesFromObject(ContextsEnum); //Convert for higher order functions.
                var validationPropertiesArray = getNamesFromObject(ValidationPropertiesEnum); //Convert for higher order functions.
                var validationObject = scope.propertyDisplay.object.validations.properties; //Get the scope validation object.
                var errors = scope.propertyDisplay.errors;
                var errorMessages = [];
                var failFlag = 0;
                /**
                * Iterates over the validation object looking for the current elements validations, maps that to a validation function list
                * and calls those validate functions. When a validation fails, an error is set, the elements border turns red.
                */
                function validate(name, context, elementValue) {
                    var validationResults = {};
                    validationResults = { "name": "name", "context": "context", "required": "required", "error": "none", "errorkey": "none" };
                    for (var key in validationObject) {
                        // Look for the current attribute in the
                        // validation parameters.
                        if (key === name || key === name + "Flag") {
                            // Now that we have found the current
                            // validation parameters, iterate
                            // through them looking for
                            // the required parameters that match
                            // the current page context (save,
                            // delete, etc.)
                            for (var inner in validationObject[key]) {
                                var required = validationObject[key][inner].required || "false"; // Get
                                // the
                                // required
                                // value
                                var context = validationObject[key][inner].contexts || "none"; // Get
                                // the
                                // element
                                // context
                                //Setup the validation results object to pass back to caller.
                                validationResults = { "name": key, "context": context, "required": required, "error": "none", "errorkey": "none" };
                                var elementValidationArr = map(checkHasValidationType, validationPropertiesArray, validationObject[key][inner]);
                                //Iterate over the array and call the validate function if it has that property.
                                for (var i = 0; i < elementValidationArr.length; i++) {
                                    if (elementValidationArr[i] == true) {
                                        if (validationPropertiesArray[i] === "regex" && elementValue !== "") { //If element is zero, need to check required 
                                            //Get the regex string to match and send to validation function.
                                            var re = validationObject[key][inner].regex;
                                            var result = validate_RegExp(elementValue, re); //true if pattern match, fail otherwise.
                                            if (result != true) {
                                                errorMessages
                                                    .push("Invalid input");
                                                validationResults.error = errorMessages[errorMessages.length - 1];
                                                validationResults.errorkey = "invalid-" + ValidationPropertiesEnum["REGEX"].name;
                                                validationResults.fail = true;
                                            }
                                            else {
                                                errorMessages
                                                    .push("Valid input");
                                                validationResults.error = errorMessages[errorMessages.length - 1];
                                                validationResults.errorkey = "invalid-" + ValidationPropertiesEnum["REGEX"].name;
                                                validationResults.fail = false;
                                            }
                                            return validationResults;
                                        }
                                        if (validationPropertiesArray[i] === "minValue") {
                                            var validationMinValue = validationObject[key][inner].minValue;
                                            $log.debug(validationMinValue);
                                            var result = validate_MinValue(elementValue, validationMinValue);
                                            $log.debug("e>v" + result + " :" + elementValue, ":" + validationMinValue);
                                            if (result != true) {
                                                errorMessages
                                                    .push("Minimum value is: "
                                                    + validationMinValue);
                                                validationResults.error = errorMessages[errorMessages.length - 1];
                                                validationResults.errorkey = "invalid-" + ValidationPropertiesEnum["MIN_VALUE"].name;
                                                validationResults.fail = true;
                                            }
                                            else {
                                                validationResults.error = errorMessages[errorMessages.length - 1];
                                                validationResults.errorkey = "invalid-" + ValidationPropertiesEnum["MIN_VALUE"].name;
                                                validationResults.fail = false;
                                            }
                                            return validationResults;
                                        }
                                        if (validationPropertiesArray[i] === "maxValue") {
                                            var validationMaxValue = validationObject[key][inner].maxValue;
                                            var result = validate_MaxValue(elementValue, validationMaxValue);
                                            $log.debug("Max Value result is: " + result);
                                            if (result != true) {
                                                errorMessages
                                                    .push("Maximum value is: "
                                                    + validationMaxValue);
                                                validationResults.error = errorMessages[errorMessages.length - 1];
                                                validationResults.errorkey = "invalid-" + ValidationPropertiesEnum["MAX_VALUE"].name;
                                                validationResults.fail = true;
                                            }
                                            return validationResults;
                                        }
                                        if (validationPropertiesArray[i] === "minLength") {
                                            var validationMinLength = validationObject[key][inner].minLength;
                                            var result = validate_MinLength(elementValue, validationMinLength);
                                            $log.debug("Min Length result is: " + result);
                                            if (result != true) {
                                                errorMessages
                                                    .push("Minimum length must be: "
                                                    + validationMinLength);
                                                validationResults.error = errorMessages[errorMessages.length - 1];
                                                validationResults.errorkey = "invalid-" + ValidationPropertiesEnum["MIN_LENGTH"].name;
                                                validationResults.fail = true;
                                            }
                                            return validationResults;
                                        }
                                        if (validationPropertiesArray[i] === "maxLength") {
                                            var validationMaxLength = validationObject[key][inner].maxLength;
                                            var result = validate_MaxLength(elementValue, validationMaxLength);
                                            $log.debug("Max Length result is: " + result);
                                            if (result != true) {
                                                errorMessages
                                                    .push("Maximum length is: "
                                                    + validationMaxLength);
                                                validationResults.error = errorMessages[errorMessages.length - 1];
                                                validationResults.errorkey = "invalid-" + ValidationPropertiesEnum["MAX_LENGTH"].name;
                                                validationResults.fail = true;
                                            }
                                            return validationResults;
                                        }
                                        if (validationPropertiesArray[i] === "eq") {
                                            var validationEq = validationObject[key][inner].eq;
                                            var result = validate_Eq(elementValue, validationEq);
                                            if (result != true) {
                                                errorMessages
                                                    .push("Must equal "
                                                    + validationEq);
                                                validationResults.error = errorMessages[errorMessages.length - 1];
                                                validationResults.errorkey = "invalid-" + ValidationPropertiesEnum["EQ"].name;
                                                validationResults.fail = true;
                                            }
                                            return validationResults;
                                        }
                                        if (validationPropertiesArray[i] === "neq") {
                                            var validationNeq = validationObject[key][inner].neq;
                                            var result = validate_Neq(elementValue, validationNeq);
                                            if (result != true) {
                                                errorMessages
                                                    .push("Must not equal: "
                                                    + validationNeq);
                                                validationResults.error = errorMessages[errorMessages.length - 1];
                                                validationResults.errorkey = "invalid-" + ValidationPropertiesEnum["NEQ"].name;
                                                validationResults.fail = true;
                                            }
                                            return validationResults;
                                        }
                                        if (validationPropertiesArray[i] === "lte") {
                                            var validationLte = validationObject[key][inner].lte;
                                            var result = validate_Lte(elementValue, validationLte);
                                            if (result != true) {
                                                errorMessages
                                                    .push("Must be less than "
                                                    + validationLte);
                                                validationResults.error = errorMessages[errorMessages.length - 1];
                                                validationResults.errorkey = "invalid-" + ValidationPropertiesEnum["LTE"].name;
                                                validationResults.fail = true;
                                            }
                                            return validationResults;
                                        }
                                        if (validationPropertiesArray[i] === "gte") {
                                            var validationGte = validationObject[key][inner].gte;
                                            var result = validate_Gte(elementValue, validationGte);
                                            if (result != true) {
                                                errorMessages
                                                    .push("Must be greater than: "
                                                    + validationGte);
                                                validationResults.error = errorMessages[errorMessages.length - 1];
                                                validationResults.errorkey = "invalid-" + ValidationPropertiesEnum["GTE"].name;
                                                validationResults.fail = true;
                                            }
                                            return validationResults;
                                        }
                                        if (validationPropertiesArray[i] === "required") {
                                            var validationRequire = validationObject[key][inner].require;
                                            var result = validate_Required(elementValue, validationRequire);
                                            if (result != true) {
                                                errorMessages
                                                    .push("Required");
                                                validationResults.error = errorMessages[errorMessages.length - 1];
                                                validationResults.errorkey = ValidationPropertiesEnum["REQUIRED"].name;
                                                validationResults.fail = true;
                                            }
                                            else {
                                                errorMessages
                                                    .push("Required");
                                                validationResults.error = errorMessages[errorMessages.length - 1];
                                                validationResults.errorkey = ValidationPropertiesEnum["REQUIRED"].name;
                                                validationResults.fail = false;
                                            }
                                            return validationResults;
                                        }
                                    }
                                }
                            }
                        }
                    } //<---end validate.			
                }
                /**
                * Function to map if we need a validation on this element.
                */
                function checkHasValidationType(validationProp, validationType) {
                    if (validationProp[validationType] != undefined) {
                        return true;
                    }
                    else {
                        return false;
                    }
                }
                /**
                * Iterates over the properties object finding which types of validation are needed.
                */
                function map(func, array, obj) {
                    var result = [];
                    forEach(array, function (element) {
                        result.push(func(obj, element));
                    });
                    return result;
                }
                /**
                * Array iteration helper.
                */
                function forEach(array, action) {
                    for (var i = 0; i < array.length; i++)
                        action(array[i]);
                }
                /**
                * Helper function to read all the names in our enums into an array that the higher order functions can use.
                */
                function getNamesFromObject(obj) {
                    var result = [];
                    for (var i in obj) {
                        var name = obj[i].name || "stub";
                        result.push(name);
                    }
                    return result;
                }
                /**
                * Tests the value for a RegExp match given by the pattern string.
                * Validates true if pattern match, false otherwise.
                */
                function validate_RegExp(value, pattern) {
                    var regex = new RegExp(pattern);
                    if (regex.test(value)) {
                        return true;
                    }
                    return false;
                }
                /**
                * Validates true if userValue >= minValue (inclusive)
                */
                function validate_MinValue(userValue, minValue) {
                    return (userValue >= minValue);
                }
                /**
                * Validates true if userValue <= maxValue (inclusive)
                */
                function validate_MaxValue(userValue, maxValue) {
                    return (userValue <= maxValue) ? true : false;
                }
                /**
                * Validates true if length of the userValue >= minLength (inclusive)
                */
                function validate_MinLength(userValue, minLength) {
                    return (userValue.length >= minLength) ? true : false;
                }
                /**
                * Validates true if length of the userValue <= maxLength (inclusive)
                */
                function validate_MaxLength(userValue, maxLength) {
                    return (userValue.length <= maxLength) ? true : false;
                }
                /**
                * Validates true if the userValue == eqValue
                */
                function validate_Eq(userValue, eqValue) {
                    return (userValue == eqValue) ? true : false;
                }
                /**
                * Validates true if the userValue != neqValue
                */
                function validate_Neq(userValue, neqValue) {
                    return (userValue != neqValue) ? true : false;
                }
                /**
                * Validates true if the userValue < decisionValue (exclusive)
                */
                function validate_Lte(userValue, decisionValue) {
                    return (userValue < decisionValue) ? true : false;
                }
                /**
                * Validates true if the userValue > decisionValue (exclusive)
                */
                function validate_Gte(userValue, decisionValue) {
                    return (userValue > decisionValue) ? true : false;
                }
                /**
                * Validates true if the userValue === property
                */
                function validate_EqProperty(userValue, property) {
                    return (userValue === property) ? true : false;
                }
                /**
                * Validates true if the given value is !NaN (Negate, Not a Number).
                */
                function validate_IsNumeric(value) {
                    return !isNaN(value) ? true : false;
                }
                /**
                * Validates true if the given userValue is empty and the field is required.
                */
                function validate_Required(property, userValue) {
                    return (userValue == "" && property == true) ? true : false;
                }
                /**
                * Handles the 'eager' validation on every key press.
                */
                ngModel.$parsers.unshift(function (value) {
                    var name = elem.context.name; //Get the element name for the validate function.
                    var currentValue = elem.val(); //Get the current element value to check validations against.
                    var val = validate(name, myCurrentContext, currentValue) || {};
                    //Check if field is required.				
                    $log.debug(scope);
                    $log.debug(val);
                    ngModel.$setValidity(val.errorkey, !val.fail);
                    return true;
                }); //<---end $parsers
                /**
                * This handles 'lazy' validation on blur.
                */
                elem.bind('blur', function (e) {
                });
            }
        };
    }
    SWValidate.Factory = function () {
        var directive = function ($log, $hibachi) { return new SWValidate($log, $hibachi); };
        directive.$inject = ['$log', '$hibachi'];
        return directive;
    };
    return SWValidate;
}());
exports.SWValidate = SWValidate;


/***/ }),

/***/ "Dac7":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.SkuService = void 0;
var baseentityservice_1 = __webpack_require__("P6y0");
var SkuService = /** @class */ (function (_super) {
    __extends(SkuService, _super);
    //@ngInject
    SkuService.$inject = ["$injector", "$hibachi", "utilityService"];
    function SkuService($injector, $hibachi, utilityService) {
        var _this = _super.call(this, $injector, $hibachi, utilityService, 'Sku') || this;
        _this.$injector = $injector;
        _this.$hibachi = $hibachi;
        _this.utilityService = utilityService;
        return _this;
    }
    return SkuService;
}(baseentityservice_1.BaseEntityService));
exports.SkuService = SkuService;


/***/ }),

/***/ "DxQu":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.Order_AddOrderPayment = void 0;
var order_addorderpayment_1 = __webpack_require__("zU/I");
Object.defineProperty(exports, "Order_AddOrderPayment", { enumerable: true, get: function () { return order_addorderpayment_1.Order_AddOrderPayment; } });


/***/ }),

/***/ "DyyJ":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWFormFieldFile = void 0;
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWFormFieldFileController = /** @class */ (function () {
    //@ngInject
    SWFormFieldFileController.$inject = ["formService"];
    function SWFormFieldFileController(formService) {
        this.formService = formService;
        if (this.propertyDisplay.isDirty == undefined)
            this.propertyDisplay.isDirty = false;
        this.propertyDisplay.form.$dirty = this.propertyDisplay.isDirty;
        //this.formService.setPristinePropertyValue(this.propertyDisplay.property,this.propertyDisplay.object.data[this.propertyDisplay.property]);
    }
    return SWFormFieldFileController;
}());
var SWFormFieldFile = /** @class */ (function () {
    function SWFormFieldFile(coreFormPartialsPath, hibachiPathBuilder) {
        this.restrict = 'E';
        this.require = "^form";
        this.controller = SWFormFieldFileController;
        this.controllerAs = "swFormFieldFile";
        this.scope = true;
        this.bindToController = {
            propertyDisplay: "="
        };
        //@ngInject
        this.link = function (scope, element, attr, formController) {
        };
        this.link.$inject = ["scope", "element", "attr", "formController"];
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(coreFormPartialsPath) + "file.html";
    }
    SWFormFieldFile.Factory = function () {
        var directive = function (coreFormPartialsPath, hibachiPathBuilder) { return new SWFormFieldFile(coreFormPartialsPath, hibachiPathBuilder); };
        directive.$inject = [
            'coreFormPartialsPath',
            'hibachiPathBuilder'
        ];
        return directive;
    };
    return SWFormFieldFile;
}());
exports.SWFormFieldFile = SWFormFieldFile;


/***/ }),

/***/ "Ebw0":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.DateFilter = void 0;
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var DateFilter = /** @class */ (function () {
    function DateFilter() {
    }
    //@ngInject
    DateFilter.Factory = function ($filter) {
        return function (date, dateString) {
            if (date.trim().length === 0) {
                return '';
            }
            return $filter('date')(new Date(date), dateString);
        };
    };
    DateFilter.Factory.$inject = ["$filter"];
    return DateFilter;
}());
exports.DateFilter = DateFilter;


/***/ }),

/***/ "EuNy":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWTypeaheadMultiselectController = exports.SWTypeaheadMultiselect = void 0;
var SWTypeaheadMultiselectController = /** @class */ (function () {
    // @ngInject
    SWTypeaheadMultiselectController.$inject = ["$scope", "$transclude", "$hibachi", "listingService", "typeaheadService", "utilityService", "collectionConfigService"];
    function SWTypeaheadMultiselectController($scope, $transclude, $hibachi, listingService, typeaheadService, utilityService, collectionConfigService) {
        var _this = this;
        this.$scope = $scope;
        this.$transclude = $transclude;
        this.$hibachi = $hibachi;
        this.listingService = listingService;
        this.typeaheadService = typeaheadService;
        this.utilityService = utilityService;
        this.collectionConfigService = collectionConfigService;
        this.addSelection = function (item) {
            if (!item) {
                return;
            }
            if (angular.isDefined(_this.prependPropertyName) && _this.prependPropertyName.length) {
                for (var property in item) {
                    item[_this.prependPropertyName + "_" + property] = item[property];
                }
            }
            if (_this.singleSelection) {
                _this.typeaheadService.notifyTypeaheadClearSearchEvent(_this.typeaheadDataKey);
            }
            if (_this.singleSelection && _this.getSelections().length) {
                _this.removeSelection(0);
            }
            _this.typeaheadService.addSelection(_this.typeaheadDataKey, item);
            if (_this.inListingDisplay) {
                _this.listingService.insertListingPageRecord(_this.listingId, item);
            }
        };
        this.removeSelection = function (index) {
            var itemRemoved = _this.typeaheadService.removeSelection(_this.typeaheadDataKey, index);
            if (_this.inListingDisplay) {
                _this.listingService.removeListingPageRecord(_this.listingId, itemRemoved);
            }
        };
        this.getSelections = function () {
            return _this.typeaheadService.getData(_this.typeaheadDataKey);
        };
        this.updateSelectionList = function () {
            _this.selectionList = _this.typeaheadService.updateSelectionList(_this.typeaheadDataKey);
        };
        if (angular.isUndefined(this.typeaheadDataKey)) {
            this.typeaheadDataKey = this.utilityService.createID(32);
        }
        if (angular.isUndefined(this.disabled)) {
            this.disabled = false;
        }
        if (angular.isUndefined(this.showSelections)) {
            this.showSelections = false;
        }
        if (angular.isUndefined(this.singleSelection)) {
            this.singleSelection = false;
        }
        if (angular.isUndefined(this.multiselectMode)) {
            this.multiselectMode = true;
        }
        if (angular.isUndefined(this.hasAddButtonFunction)) {
            this.hasAddButtonFunction = false;
        }
        if (angular.isUndefined(this.hasViewFunction)) {
            this.hasViewFunction = false;
        }
        if (angular.isDefined(this.selectedCollectionConfig)) {
            this.typeaheadService.initializeSelections(this.typeaheadDataKey, this.selectedCollectionConfig);
        }
        this.typeaheadService.attachTypeaheadSelectionUpdateEvent(this.typeaheadDataKey, this.updateSelectionList);
    }
    return SWTypeaheadMultiselectController;
}());
exports.SWTypeaheadMultiselectController = SWTypeaheadMultiselectController;
var SWTypeaheadMultiselect = /** @class */ (function () {
    // @ngInject
    SWTypeaheadMultiselect.$inject = ["$compile", "scopeService", "typeaheadService"];
    function SWTypeaheadMultiselect($compile, scopeService, typeaheadService) {
        var _this = this;
        this.$compile = $compile;
        this.scopeService = scopeService;
        this.typeaheadService = typeaheadService;
        this.transclude = true;
        this.restrict = "EA";
        this.scope = {};
        this.bindToController = {
            placeholderRbKey: "@",
            collectionConfig: "=?",
            selectedCollectionConfig: "=?",
            typeaheadDataKey: "@?",
            multiselectModeOn: "=?multiselectMode",
            singleSelection: "=?",
            showSelections: "=?",
            dataTarget: "=?",
            dataTargetIndex: "=?",
            addButtonFunction: "&?",
            viewFunction: "&?",
            inListingDisplay: "=?",
            listingId: "@?",
            propertyToCompare: "@?",
            fallbackPropertiesToCompare: "@?",
            rightContentPropertyIdentifier: "@?",
            selectionFieldName: "@?",
            disabled: "=?",
            prependPropertyName: "@?"
        };
        this.controller = SWTypeaheadMultiselectController;
        this.controllerAs = "swTypeaheadMultiselect";
        this.template = __webpack_require__("KNfs");
        this.compile = function (element, attrs, transclude) {
            return {
                pre: function ($scope, element, attrs) {
                    //because callbacks are defined even when they're not passed in, this needs to be communicated to the typeahead
                    if (angular.isDefined(attrs.addButtonFunction)) {
                        $scope.swTypeaheadMultiselect.hasAddButtonFunction = true;
                    }
                    else {
                        $scope.swTypeaheadMultiselect.hasAddButtonFunction = false;
                    }
                    if (angular.isDefined(attrs.viewFunction)) {
                        $scope.swTypeaheadMultiselect.viewFunction = true;
                    }
                    else {
                        $scope.swTypeaheadMultiselect.viewFunction = false;
                    }
                    if (angular.isUndefined($scope.swTypeaheadMultiselect.inListingDisplay)) {
                        $scope.swTypeaheadMultiselect.inListingDisplay = false;
                    }
                    if ($scope.swTypeaheadMultiselect.inListingDisplay && _this.scopeService.hasParentScope($scope, "swListingDisplay")) {
                        var listingDisplayScope = _this.scopeService.getRootParentScope($scope, "swListingDisplay")["swListingDisplay"];
                        $scope.swTypeaheadMultiselect.listingId = listingDisplayScope.tableID;
                        listingDisplayScope.typeaheadDataKey = $scope.swTypeaheadMultiselect.typeaheadDataKey;
                    }
                },
                post: function ($scope, element, attrs) {
                    var target = element.find(".s-selected-list");
                    var selectedItemTemplate = angular.element('<div class="alert s-selected-item" ng-repeat="item in swTypeaheadMultiselect.getSelections() track by $index">');
                    var closeButton = angular.element('<button ng-click="swTypeaheadMultiselect.removeSelection($index)" type="button" class="close"><span>×</span><span class="sr-only" sw-rbkey="&apos;define.close&apos;"></span></button>');
                    selectedItemTemplate.append(closeButton);
                    selectedItemTemplate.append(_this.typeaheadService.stripTranscludedContent(transclude($scope, function () { })));
                    target.append(_this.$compile(selectedItemTemplate)($scope));
                }
            };
        };
    }
    SWTypeaheadMultiselect.Factory = function () {
        var _this = this;
        return /** @ngInject; */ ["$compile", "scopeService", "typeaheadService", function ($compile, scopeService, typeaheadService) { return new _this($compile, scopeService, typeaheadService); }];
    };
    return SWTypeaheadMultiselect;
}());
exports.SWTypeaheadMultiselect = SWTypeaheadMultiselect;


/***/ }),

/***/ "Fnnc":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWValidationLte = void 0;
var SWValidationLte = /** @class */ (function () {
    function SWValidationLte(validationService) {
        return {
            restrict: "A",
            require: "^ngModel",
            link: function (scope, element, attributes, ngModel) {
                ngModel.$validators.swvalidationlte =
                    function (modelValue, viewValue) {
                        return validationService.validateLte(modelValue, attributes.swvalidationlte);
                    };
            }
        };
    }
    SWValidationLte.Factory = function () {
        var directive = function (validationService) { return new SWValidationLte(validationService); };
        directive.$inject = ['validationService'];
        return directive;
    };
    return SWValidationLte;
}());
exports.SWValidationLte = SWValidationLte;


/***/ }),

/***/ "FtFI":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.RouterController = void 0;
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var RouterController = /** @class */ (function () {
    //@ngInject
    RouterController.$inject = ["$scope", "$routeParams", "$location", "$log", "utilityService"];
    function RouterController($scope, $routeParams, $location, $log, utilityService) {
        $scope.$id = "routerController";
        $scope.partialRoute = '';
        $log.debug($routeParams);
        $log.debug($location);
        var path = $location.path();
        $scope.controllerType = path.split('/')[1];
        var type;
        if ($scope.controllerType === 'entity') {
            //remove all dashes
            $scope.entityName = utilityService.snakeToCapitalCase($routeParams.entityName);
            if (angular.isDefined($routeParams.entityID)) {
                $scope.entityID = $routeParams.entityID || '';
            }
        }
    }
    return RouterController;
}());
exports.RouterController = RouterController;


/***/ }),

/***/ "G6jK":
/***/ (function(module, exports) {

module.exports = "<div class=\"dropdown\">\n\t<a href=\"##\" ng-if=\"column.ormtype !== 'boolean' && column.persistent != false\" class=\"dropdown-toggle\" aria-haspopup=\"true\" aria-expanded=\"false\"><span sw-rbkey=\"column.propertyIdentifier.replace('_','entity.')\"></span> <i class=\"fa fa-sort\"></i></a>\n\t<span ng-if=\"column.ormtype === 'boolean' || column.persistent === false\" sw-rbkey=\"column.propertyIdentifier.replace('_','entity.')\"></span>\n\t<ul class=\"dropdown-menu nav scrollable\" ng-if=\"column.ormtype !== 'boolean' && column.persistent != false\">\n\t\t<li class=\"dropdown-header\">Sort</li>\n\t\t<li><a  ng-click=\"sortAsc()\"><i class=\"icon-arrow-down\"></i> Sort Ascending</a></li>\n\t\t<li><a  ng-click=\"sortDesc()\"><i class=\"icon-arrow-up\"></i> Sort Descending</a></li>\n\t\t<!--<li class=\"divider\"></li>\n\t\t\n\t\t<li class=\"dropdown-header\">Search</li>\n\t\t<li class=\"search-filter\"><input type=\"text\" class=\"listing-search form-control\" name=\"FK:productType.productTypeName\" value=\"\"> <i class=\"icon-search\"></i></li>-->\n\t</ul>\n</div> ";

/***/ }),

/***/ "GEAz":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWFormFieldController = exports.SWFormField = void 0;
var SWFormFieldController = /** @class */ (function () {
    //@ngInject
    SWFormFieldController.$inject = ["$injector", "$scope", "$timeout", "$log", "$hibachi", "observerService", "utilityService"];
    function SWFormFieldController($injector, $scope, $timeout, $log, $hibachi, observerService, utilityService) {
        var _this = this;
        this.$injector = $injector;
        this.$scope = $scope;
        this.$timeout = $timeout;
        this.$log = $log;
        this.$hibachi = $hibachi;
        this.observerService = observerService;
        this.utilityService = utilityService;
        this.formFieldChanged = function (option) {
            if (_this.fieldType === 'yesno') {
                _this.object.data[_this.propertyIdentifier] = option.value;
                _this.form[_this.propertyIdentifier].$dirty = true;
                _this.form['selected' + _this.object.metaData.className + _this.propertyIdentifier + _this.selectedRadioFormName].$dirty = false;
            }
            else if (_this.fieldType == 'checkbox') {
                _this.object.data[_this.propertyIdentifier] = option.value;
                _this.form[_this.propertyIdentifier].$dirty = true;
            }
            else if (_this.fieldType === 'select') {
                _this.$log.debug('formfieldchanged');
                _this.$log.debug(option);
                if (_this.selectType === 'object' && typeof _this.object.data[_this.propertyIdentifier].$$getIDName == "function") {
                    _this.object.data[_this.propertyIdentifier]['data'][_this.object.data[_this.propertyIdentifier].$$getIDName()] = option.value;
                    if (angular.isDefined(_this.form[_this.object.data[_this.propertyIdentifier].$$getIDName()])) {
                        _this.form[_this.object.data[_this.propertyIdentifier].$$getIDName()].$dirty = true;
                    }
                }
                else if (_this.selectType === 'string' && option && option.value != null) {
                    _this.object.data[_this.propertyIdentifier] = option.value;
                    _this.form[_this.propertyIdentifier].$dirty = true;
                }
                _this.observerService.notify(_this.object.metaData.className + _this.propertyIdentifier.charAt(0).toUpperCase() + _this.propertyIdentifier.slice(1) + 'OnChange', option);
            }
            else {
                _this.object.data[_this.propertyIdentifier] = option.value;
                _this.form[_this.propertyIdentifier].$dirty = true;
                _this.form['selected' + _this.object.metaData.className + _this.propertyIdentifier + _this.selectedRadioFormName].$dirty = false;
            }
        };
        this.$onInit = function () {
            var bindToControllerProps = _this.$injector.get('swFormFieldDirective')[0].bindToController;
            for (var i in bindToControllerProps) {
                if (!_this[i]) {
                    if (!_this[i] && _this.swPropertyDisplay && _this.swPropertyDisplay[i]) {
                        _this[i] = _this.swPropertyDisplay[i];
                    }
                    else if (!_this[i] && _this.swfPropertyDisplay && _this.swfPropertyDisplay[i]) {
                        _this[i] = _this.swfPropertyDisplay[i];
                    }
                    else if (!_this[i] && _this.swForm && _this.swForm[i]) {
                        _this[i] = _this.swForm[i];
                    }
                }
            }
            var tempObject = [];
            if (typeof (_this.optionValues) == "string") {
                var temp = _this.optionValues.split(',');
                for (var _i = 0, temp_1 = temp; _i < temp_1.length; _i++) {
                    var value = temp_1[_i];
                    tempObject.push({
                        "name": value,
                        "value": value
                    });
                }
                _this.optionValues = tempObject;
            }
            _this.edit = _this.edit || true;
            _this.fieldType = _this.fieldType || "text";
            if (_this.fieldType === 'yesno') {
                _this.yesnoStrategy();
            }
            if (_this.fieldType === 'select') {
                _this.selectStrategy();
            }
            if (_this.eventListeners) {
                for (var key in _this.eventListeners) {
                    _this.observerService.attach(_this.eventListeners[key], key);
                }
            }
        };
        this.selectStrategy = function () {
            //this is specific to the admin because it implies loading of options via api
            if (angular.isDefined(_this.object.metaData) && angular.isDefined(_this.object.metaData[_this.propertyIdentifier]) && angular.isDefined(_this.object.metaData[_this.propertyIdentifier].fieldtype)) {
                _this.selectType = 'object';
                _this.$log.debug('selectType:object');
            }
            else {
                _this.selectType = 'string';
                _this.$log.debug('selectType:string');
            }
            _this.getOptions();
        };
        this.getOptions = function () {
            if (angular.isUndefined(_this.options)) {
                if (!_this.optionsArguments || !_this.optionsArguments.hasOwnProperty('propertyIdentifier')) {
                    _this.optionsArguments = {
                        'propertyIdentifier': _this.propertyIdentifier
                    };
                }
                if (_this.object.$$getID().length) {
                    _this.optionsArguments.entityID = _this.object.$$getID();
                }
                var optionsPromise = _this.$hibachi.getPropertyDisplayOptions(_this.object.metaData.className, _this.optionsArguments);
                optionsPromise.then(function (value) {
                    _this.options = value.data;
                    if (_this.selectType === 'object') {
                        if (angular.isUndefined(_this.object.data[_this.propertyIdentifier])) {
                            _this.object.data[_this.propertyIdentifier] = _this.$hibachi['new' + _this.object.metaData[_this.propertyIdentifier].cfc]();
                        }
                        if (_this.object.data[_this.propertyIdentifier].$$getID() === '') {
                            _this.$log.debug('no ID');
                            _this.$log.debug(_this.object.data[_this.propertyIdentifier].$$getIDName());
                            _this.object.data['selected' + _this.propertyIdentifier] = _this.options[0];
                            _this.object.data[_this.propertyIdentifier] = _this.$hibachi['new' + _this.object.metaData[_this.propertyIdentifier].cfc]();
                            _this.object.data[_this.propertyIdentifier]['data'][_this.object.data[_this.propertyIdentifier].$$getIDName()] = _this.options[0].value;
                        }
                        else {
                            var found = false;
                            for (var i in _this.options) {
                                if (angular.isObject(_this.options[i].value)) {
                                    _this.$log.debug('isObject');
                                    _this.$log.debug(_this.object.data[_this.propertyIdentifier].$$getIDName());
                                    if (_this.options[i].value === _this.object.data[_this.propertyIdentifier]) {
                                        _this.object.data['selected' + _this.propertyIdentifier] = _this.options[i];
                                        _this.object.data[_this.propertyIdentifier] = _this.options[i].value;
                                        found = true;
                                        break;
                                    }
                                }
                                else {
                                    _this.$log.debug('notisObject');
                                    _this.$log.debug(_this.object.data[_this.propertyIdentifier].$$getIDName());
                                    if (_this.options[i].value === _this.object.data[_this.propertyIdentifier].$$getID()) {
                                        _this.object.data['selected' + _this.propertyIdentifier] = _this.options[i];
                                        _this.object.data[_this.propertyIdentifier]['data'][_this.object.data[_this.propertyIdentifier].$$getIDName()] = _this.options[i].value;
                                        found = true;
                                        break;
                                    }
                                }
                                if (!found) {
                                    _this.object.data['selected' + _this.propertyIdentifier] = _this.options[0];
                                }
                            }
                        }
                    }
                    else if (_this.selectType === 'string') {
                        if (_this.object.data[_this.propertyIdentifier] !== null) {
                            for (var i in _this.options) {
                                if (_this.options[i].value === _this.object.data[_this.propertyIdentifier]) {
                                    _this.object.data['selected' + _this.propertyIdentifier] = _this.options[i];
                                    _this.object.data[_this.propertyIdentifier] = _this.options[i].value;
                                }
                            }
                        }
                        else {
                            _this.object.data['selected' + _this.propertyIdentifier] = _this.options[0];
                            _this.object.data[_this.propertyIdentifier] = _this.options[0].value;
                        }
                    }
                });
            }
        };
        this.yesnoStrategy = function () {
            //format value
            _this.selectedRadioFormName = _this.utilityService.createID(26);
            _this.object.data[_this.propertyIdentifier] = (_this.object.data[_this.propertyIdentifier]
                && _this.object.data[_this.propertyIdentifier].length
                && _this.object.data[_this.propertyIdentifier].toLowerCase().trim() === 'yes') || _this.object.data[_this.propertyIdentifier] == 1 ? 1 : 0;
            _this.options = [
                {
                    name: 'Yes',
                    value: 1
                },
                {
                    name: 'No',
                    value: 0
                }
            ];
            if (angular.isDefined(_this.object.data[_this.propertyIdentifier])) {
                for (var i in _this.options) {
                    if (_this.options[i].value === _this.object.data[_this.propertyIdentifier]) {
                        _this.selected = _this.options[i];
                        _this.object.data[_this.propertyIdentifier] = _this.options[i].value;
                    }
                }
            }
            else {
                _this.selected = _this.options[0];
                _this.object.data[_this.propertyIdentifier] = _this.options[0].value;
            }
            _this.$timeout(function () {
                _this.form[_this.propertyIdentifier].$dirty = _this.isDirty;
            });
        };
        this.$injector = $injector;
        this.$scope = $scope;
        this.$timeout = $timeout;
        this.$log = $log;
        this.$hibachi = $hibachi;
        this.observerService = observerService;
        this.utilityService = utilityService;
    }
    return SWFormFieldController;
}());
exports.SWFormFieldController = SWFormFieldController;
var SWFormField = /** @class */ (function () {
    //@ngInject
    SWFormField.$inject = ["$log", "$templateCache", "$window", "$hibachi", "formService", "coreFormPartialsPath", "hibachiPathBuilder"];
    function SWFormField($log, $templateCache, $window, $hibachi, formService, coreFormPartialsPath, hibachiPathBuilder) {
        this.restrict = "EA";
        this.require = {
            swfPropertyDisplay: "^?swfPropertyDisplay",
            swPropertyDisplay: "^?swPropertyDisplay",
            form: "^?form",
            swForm: '^?swForm'
        };
        this.controller = SWFormFieldController;
        this.controllerAs = "swFormField";
        this.scope = {};
        this.bindToController = {
            propertyIdentifier: "@?", property: "@?",
            name: "@?",
            class: "@?",
            errorClass: "@?",
            fieldType: "@?", type: "@?",
            option: "=?",
            valueObject: "=?",
            object: "=?",
            label: "@?",
            labelText: "@?",
            labelClass: "@?",
            optionValues: "=?",
            edit: "=?",
            title: "@?",
            value: "=?",
            errorText: "@?",
            inListingDisplay: "=?",
            inputAttributes: "@?",
            options: "=?",
            optionsArguments: "=?",
            eagerLoadOptions: "=?",
            rawFileTarget: "@?",
            binaryFileTarget: "@?",
            isDirty: "=?",
            onChange: "=?",
            editable: "=?",
            eventListeners: "=?",
            context: "@?",
            eventAnnouncers: "@"
        };
        this.link = function (scope, element, attrs) {
        };
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(coreFormPartialsPath) + 'formfield.html';
    }
    SWFormField.Factory = function () {
        var directive = function ($log, $templateCache, $window, $hibachi, formService, coreFormPartialsPath, hibachiPathBuilder) { return new SWFormField($log, $templateCache, $window, $hibachi, formService, coreFormPartialsPath, hibachiPathBuilder); };
        directive.$inject = [
            '$log',
            '$templateCache',
            '$window',
            '$hibachi',
            'formService',
            'coreFormPartialsPath',
            'hibachiPathBuilder'
        ];
        return directive;
    };
    return SWFormField;
}());
exports.SWFormField = SWFormField;


/***/ }),

/***/ "GdTe":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWFormRegistrar = void 0;
var SWFormRegistrar = /** @class */ (function () {
    //@ngInject
    SWFormRegistrar.$inject = ["formService"];
    function SWFormRegistrar(formService) {
        return {
            restrict: 'E',
            require: ["^form", "^swForm"],
            scope: {
                object: "=?",
                context: "@?",
                name: "@?",
                isDirty: "=?"
            },
            link: function (scope, element, attrs, formController, transclude) {
                /*add form info at the form level*/
                scope.$watch(function () { return formController[0]; }, function () {
                    formController[1].formCtrl = formController[0];
                });
                formController[0].$$swFormInfo = {
                    object: scope.object,
                    context: scope.context || 'save',
                    name: scope.name
                };
                var makeRandomID = function makeid(count) {
                    var text = "";
                    var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
                    for (var i = 0; i < count; i++)
                        text += possible.charAt(Math.floor(Math.random() * possible.length));
                    return text;
                };
                if (scope.isDirty) {
                    formController[0].autoDirty = true;
                }
                scope.form = formController[0];
                /*register form with service*/
                formController[0].name = scope.name;
                formController[0].$setDirty();
                formService.setForm(formController[0]);
                /*register form at object level*/
                if (!angular.isDefined(scope.object.forms)) {
                    scope.object.forms = {};
                }
                scope.object.forms[scope.name] = formController[0];
            }
        };
    }
    SWFormRegistrar.Factory = function () {
        var directive = function (formService) { return new SWFormRegistrar(formService); };
        directive.$inject = [
            'formService'
        ];
        return directive;
    };
    return SWFormRegistrar;
}());
exports.SWFormRegistrar = SWFormRegistrar;
// 	angular.module('slatwalladmin').directive('swFormRegistrar',[ 'formService', 'partialsPath', (formService, partialsPath) => new swFormRegistrar(formService, partialsPath)]);
// }


/***/ }),

/***/ "HQNm":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var __spreadArrays = (this && this.__spreadArrays) || function () {
    for (var s = 0, i = 0, il = arguments.length; i < il; i++) s += arguments[i].length;
    for (var r = Array(s), k = 0, i = 0; i < il; i++)
        for (var a = arguments[i], j = 0, jl = a.length; j < jl; j++, k++)
            r[k] = a[j];
    return r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.PublicService = void 0;
var PublicService = /** @class */ (function () {
    ///index.cfm/api/scope/
    //@ngInject
    PublicService.$inject = ["$http", "$q", "$window", "$location", "$hibachi", "$injector", "$httpParamSerializer", "requestService", "accountService", "accountAddressService", "cartService", "orderService", "observerService", "appConfig", "$timeout", "hibachiAuthenticationService", "sessionStorageCache", "inMemoryCache"];
    function PublicService($http, $q, $window, $location, $hibachi, $injector, $httpParamSerializer, requestService, accountService, accountAddressService, cartService, orderService, observerService, appConfig, $timeout, hibachiAuthenticationService, sessionStorageCache, inMemoryCache) {
        var _this = this;
        this.$http = $http;
        this.$q = $q;
        this.$window = $window;
        this.$location = $location;
        this.$hibachi = $hibachi;
        this.$injector = $injector;
        this.$httpParamSerializer = $httpParamSerializer;
        this.requestService = requestService;
        this.accountService = accountService;
        this.accountAddressService = accountAddressService;
        this.cartService = cartService;
        this.orderService = orderService;
        this.observerService = observerService;
        this.appConfig = appConfig;
        this.$timeout = $timeout;
        this.hibachiAuthenticationService = hibachiAuthenticationService;
        this.sessionStorageCache = sessionStorageCache;
        this.inMemoryCache = inMemoryCache;
        this.requests = {};
        this.errors = {};
        this.baseActionPath = "";
        this.months = [{ name: '01 - JAN', value: 1 }, { name: '02 - FEB', value: 2 }, { name: '03 - MAR', value: 3 }, { name: '04 - APR', value: 4 }, { name: '05 - MAY', value: 5 }, { name: '06 - JUN', value: 6 }, { name: '07 - JUL', value: 7 }, { name: '08 - AUG', value: 8 }, { name: '09 - SEP', value: 9 }, { name: '10 - OCT', value: 10 }, { name: '11 - NOV', value: 11 }, { name: '12 - DEC', value: 12 }];
        this.years = [];
        this.shippingAddress = "";
        this.accountAddressEditFormIndex = [];
        this.showStoreSelector = [];
        this.showEmailSelector = [];
        this.imagePath = {};
        this.successfulActions = [];
        this.failureActions = [];
        // public hasErrors = ()=>{
        //     return this.errors.length;
        // }
        /**
         * Helper methods for getting errors from the cart
         */
        this.getErrors = function () {
            _this.errors = {};
            for (var key in _this.requests) {
                var request = _this.requests[key];
                if (Object.keys(request.errors).length) {
                    _this.errors[key] = request.errors;
                }
            }
            return _this.errors;
        };
        /** grab the valid expiration years for credit cards  */
        this.getExpirationYears = function () {
            var baseDate = new Date();
            var today = baseDate.getFullYear();
            var start = today;
            for (var i = 0; i <= 15; i++) {
                _this.years.push({
                    name: start + i,
                    value: start + i,
                });
            }
        };
        /** accessors for account */
        this.getAccount = function (refresh) {
            if (refresh === void 0) { refresh = false; }
            var urlBase = _this.baseActionPath + 'getAccount/';
            if (!_this.accountDataPromise || refresh) {
                _this.accountDataPromise = _this.getData(urlBase, "account", "");
            }
            return _this.accountDataPromise;
        };
        /** accessors for cart */
        this.getCart = function (refresh, param) {
            if (refresh === void 0) { refresh = false; }
            if (param === void 0) { param = ''; }
            var urlBase = _this.baseActionPath + 'getCart/';
            if (!_this.cartDataPromise || refresh) {
                _this.cartDataPromise = _this.getData(urlBase, "cart", param);
            }
            return _this.cartDataPromise;
        };
        /** accessors for countries */
        this.getCountries = function (refresh) {
            if (refresh === void 0) { refresh = false; }
            var urlBase = _this.baseActionPath + 'getCountries/';
            if (!_this.countryDataPromise || refresh) {
                _this.countryDataPromise = _this.getData(urlBase, "countries", "", "get");
            }
            return _this.countryDataPromise;
        };
        /** accessors for states */
        this.getStates = function (countryCode, address, refresh) {
            if (refresh === void 0) { refresh = false; }
            if (address && address.data) {
                countryCode = address.data.countrycode || address.countrycode;
            }
            if (typeof address === 'boolean' && !angular.isDefined(refresh)) {
                refresh = address;
            }
            if (!countryCode)
                countryCode = "US";
            var urlBase = _this.baseActionPath + 'getStateCodeOptionsByCountryCode/';
            if (!_this.getRequestByAction('getStateCodeOptionsByCountryCode') || !_this.getRequestByAction('getStateCodeOptionsByCountryCode').loading || refresh) {
                _this.stateDataPromise = _this.getData(urlBase, "states", "?countryCode=" + countryCode, "get");
                return _this.stateDataPromise;
            }
            return _this.stateDataPromise;
        };
        this.refreshAddressOptions = function (address) {
            _this.getStates(null, address);
        };
        this.getStateByStateCode = function (stateCode) {
            if (!angular.isDefined(_this.states) || !angular.isDefined(_this.states.stateCodeOptions) || !angular.isDefined(stateCode)) {
                return;
            }
            for (var state in _this.states.stateCodeOptions) {
                if (_this.states.stateCodeOptions[state].value == stateCode) {
                    return _this.states.stateCodeOptions[state];
                }
            }
        };
        this.getCountryByCountryCode = function (countryCode) {
            if (!angular.isDefined(_this.countries) || !angular.isDefined(_this.countries.countryCodeOptions)) {
                return;
            }
            if (!countryCode) {
                countryCode = 'US';
            }
            for (var country in _this.countries.countryCodeOptions) {
                if (_this.countries.countryCodeOptions[country].value == countryCode) {
                    return _this.countries.countryCodeOptions[country];
                }
            }
        };
        /** accessors for states */
        this.getAddressOptions = function (countryCode, address, refresh) {
            if (refresh === void 0) { refresh = false; }
            if (address && address.data) {
                countryCode = address.data.countrycode || address.countrycode;
            }
            if (!angular.isDefined(countryCode))
                countryCode = "US";
            if (typeof address === 'boolean' && !angular.isDefined(refresh)) {
                refresh = address;
            }
            var urlBase = _this.baseActionPath + 'getAddressOptionsByCountryCode/';
            if (!_this.getRequestByAction('getAddressOptionsByCountryCode') || !_this.getRequestByAction('getAddressOptionsByCountryCode').loading || refresh) {
                _this.addressOptionData = _this.getData(urlBase, "addressOptions", "?countryCode=" + countryCode, "get");
                return _this.addressOptionData;
            }
            return _this.addressOptionData;
        };
        /** accessors for states */
        this.getData = function (url, setter, param, method) {
            if (method === void 0) { method = 'post'; }
            var urlBase = url + param;
            var request = _this.requestService.newPublicRequest(urlBase, null, method);
            request.promise.then(function (result) {
                //don't need account and cart for anything other than account and cart calls.
                if (setter.indexOf('account') == -1) {
                    if (result['account']) {
                        delete result['account'];
                    }
                }
                if (setter.indexOf('cart') == -1) {
                    if (result['cart']) {
                        delete result['cart'];
                    }
                }
                if ((setter == 'cart' || setter == 'account') && _this[setter] && _this[setter].populate) {
                    //cart and account return cart and account info flat
                    _this[setter].populate(result[setter]);
                }
                else {
                    //other functions reutrn cart,account and then data
                    if (setter == 'states') {
                        _this[setter] = {};
                        _this.$timeout(function () {
                            _this[setter] = (result);
                        });
                    }
                    else {
                        _this[setter] = (result);
                    }
                }
            }).catch(function (reason) {
            });
            _this.requests[request.getAction()] = request;
            return request.promise;
        };
        /** sets the current shipping address */
        this.setShippingAddress = function (shippingAddress) {
            _this.shippingAddress = shippingAddress;
        };
        /** sets the current shipping address */
        this.setBillingAddress = function (billingAddress) {
            _this.billingAddress = billingAddress;
        };
        /** sets the current billing address */
        this.selectBillingAddress = function (key) {
            if (_this.orderPaymentObject && _this.orderPaymentObject.forms) {
                var address = _this.account.accountAddresses[key].address;
                address.accountAddressID = _this.account.accountAddresses[key].accountAddressID;
                for (var property in address) {
                    for (var form in _this.orderPaymentObject['forms']) {
                        form = _this.orderPaymentObject['forms'][form];
                        if (form['newOrderPayment.billingAddress.' + property] != undefined) {
                            form['newOrderPayment.billingAddress.' + property].$setViewValue(address[property]);
                        }
                    }
                }
                _this.orderPaymentObject.newOrderPayment.billingAddress = address;
            }
        };
        /** this is the generic method used to call all server side actions.
        *  @param action {string} the name of the action (method) to call in the public service.
        *  @param data   {object} the params as key value pairs to pass in the post request.
        *  @return a deferred promise that resolves server response or error. also includes updated account and cart.
        */
        this.doAction = function (action, data, method) {
            if (data === void 0) { data = {}; }
            if (method === void 0) { method = 'POST'; }
            ///Prevent sending the same request multiple times in parallel
            if (_this.getRequestByAction(action) && _this.loadingThisRequest(action, data, false)) {
                return _this.$q.when();
            }
            if (!action) {
                throw "Exception: Action is required";
            }
            var urlBase = _this.appConfig.baseURL;
            //check if the caller is defining a path to hit, otherwise use the public scope.
            if (action.indexOf(":") !== -1) {
                urlBase = urlBase + action; //any path
            }
            else {
                urlBase = _this.baseActionPath + action; //public path
            }
            if (_this.cmsSiteID) {
                data.cmsSiteID = _this.cmsSiteID;
            }
            if (method == 'POST' && data.returnJsonObjects == undefined) {
                data.returnJsonObjects = "cart,account";
            }
            if (method == 'GET' && Object.keys(data).length !== 0) {
                urlBase += (urlBase.indexOf('?') == -1) ? '?' : '&';
                urlBase += _this.$httpParamSerializer(data);
                data = null;
            }
            var request = _this.requestService.newPublicRequest(urlBase, data, method);
            request.promise.then(function (result) {
                _this.processAction(result, request);
            }).catch(function (reason) {
            });
            _this.requests[request.getAction()] = request;
            return request.promise;
        };
        this.uploadFile = function (action, data) {
            _this.$timeout(function () {
                _this.uploadingFile = true;
            });
            var url = _this.appConfig.baseURL + action;
            var formData = new FormData();
            formData.append("fileName", data.fileName);
            formData.append("uploadFile", data.uploadFile);
            var xhr = new XMLHttpRequest();
            xhr.open('POST', url, true);
            xhr.onload = function (result) {
                var response = JSON.parse(xhr.response);
                if (xhr.status === 200) {
                    _this.processAction(response, null);
                    _this.successfulActions = response.successfulActions;
                    _this.failureActions = response.failureActions;
                }
                _this.$timeout(function () {
                    _this.uploadingFile = false;
                });
            };
            xhr.send(formData);
        };
        this.processAction = function (response, request) {
            //Run any specific adjustments needed
            _this.runCheckoutAdjustments(response);
            //if the action that was called was successful, then success is true.
            if (request && request.hasSuccessfulAction()) {
                _this.successfulActions = [];
                for (var action in request.successfulActions) {
                    _this.successfulActions.push(request.successfulActions[action].split('.')[1]);
                    if (request.successfulActions[action].indexOf('public:cart.placeOrder') !== -1) {
                        _this.$window.location.href = _this.confirmationUrl;
                        return;
                    }
                    else if (request.successfulActions[action].indexOf('public:cart.finalizeCart') !== -1) {
                        _this.$window.location.href = _this.checkoutUrl;
                        return;
                    }
                    else if (request.successfulActions[action].indexOf('public:account.logout') !== -1) {
                        _this.account = _this.$hibachi.newAccount();
                    }
                }
            }
            if (request && request.hasFailureAction()) {
                _this.failureActions = [];
                for (var action in request.failureActions) {
                    _this.failureActions.push(request.failureActions[action].split('.')[1]);
                }
            }
            /** update the account and the cart */
            if (response.account) {
                _this.account.populate(response.account);
                _this.account.request = request;
            }
            if (response.cart) {
                _this.cart.populate(response.cart);
                _this.cart.request = request;
                _this.putIntoSessionCache("cachedCart", response.cart);
            }
            _this.errors = response.errors;
            if (response.messages) {
                _this.messages = response.messages;
            }
        };
        this.runCheckoutAdjustments = function (response) {
            _this.filterErrors(response);
            if (response.cart) {
                _this.removeInvalidOrderPayments(response.cart);
            }
        };
        this.getRequestByAction = function (action) {
            return _this.requests[action];
        };
        /**
         * Helper methods so that everything in account and cart can be accessed using getters.
         */
        this.userIsLoggedIn = function () {
            return _this.account.userIsLoggedIn();
        };
        this.getActivePaymentMethods = function () {
            var urlString = "/?" + _this.appConfig.action + "=admin:ajax.getActivePaymentMethods";
            var request = _this.requestService.newPublicRequest(urlString)
                .then(function (result) {
                if (angular.isDefined(result.data.paymentMethods)) {
                    _this.paymentMethods = result.data.paymentMethods;
                }
            });
            _this.requests[request.getAction()] = request;
        };
        this.filterErrors = function (response) {
            if (!response || !response.cart || !response.cart.errors)
                return;
            var cartErrors = response.cart.errors;
            if (cartErrors.addOrderPayment) {
                cartErrors.addOrderPayment = cartErrors.addOrderPayment.filter(function (error) { return error != 'billingAddress'; });
            }
        };
        /** Uses getRequestByAction() plus an identifier to distinguish between different functionality using the same route*/
        this.loadingThisRequest = function (action, conditions, strict) {
            var request = _this.getRequestByAction(action);
            if (!request || !request.loading)
                return false;
            for (var identifier in conditions) {
                if (!((conditions[identifier] === true && !strict) || request.data[identifier] == conditions[identifier])) {
                    return false;
                }
            }
            return true;
        };
        this.authenticateActionByAccount = function (action, processContext) {
            return _this.hibachiAuthenticationService.authenticateActionByAccount(action, processContext);
        };
        this.removeInvalidOrderPayments = function (cart) {
            if (angular.isDefined(cart.orderPayments)) {
                cart.orderPayments = cart.orderPayments.filter(function (payment) { return !payment.hasErrors; });
            }
        };
        /**
         * Given a payment method name, returns the id.
         */
        this.getPaymentMethodID = function (name) {
            for (var method in _this.paymentMethods) {
                if (_this.paymentMethods[method].paymentMethodName == name && _this.paymentMethods[method].activeFlag == "Yes ") {
                    return _this.paymentMethods[method].paymentMethodID;
                }
            }
        };
        /** Returns a boolean indicating whether or not the order has the named payment method.*/
        this.hasPaymentMethod = function (paymentMethodName) {
            for (var _i = 0, _a = _this.cart.orderPayments; _i < _a.length; _i++) {
                var payment = _a[_i];
                if (payment.paymentMethod.paymentMethodName === paymentMethodName)
                    return true;
            }
            return false;
        };
        this.hasCreditCardPaymentMethod = function () {
            return _this.hasPaymentMethod("Credit Card");
        };
        this.hasPaypalPaymentMethod = function () {
            return _this.hasPaymentMethod("PayPal Express");
        };
        this.hasGiftCardPaymentMethod = function () {
            return _this.hasPaymentMethod("Gift Card");
        };
        this.hasMoneyOrderPaymentMethod = function () {
            return _this.hasPaymentMethod("Money Order");
        };
        this.hasCashPaymentMethod = function () {
            return _this.hasPaymentMethod("Cash");
        };
        /** Returns a boolean indicating whether or not the order has the named fulfillment method.*/
        this.hasFulfillmentMethod = function (fulfillmentMethodName) {
            for (var _i = 0, _a = _this.cart.orderFulfillments; _i < _a.length; _i++) {
                var fulfillment = _a[_i];
                if (fulfillment.fulfillmentMethod.fulfillmentMethodName === fulfillmentMethodName)
                    return true;
            }
            return false;
        };
        this.hasShippingFulfillmentMethod = function () {
            return _this.hasFulfillmentMethod("Shipping");
        };
        this.hasEmailFulfillmentMethod = function () {
            return _this.hasFulfillmentMethod("Email");
        };
        this.hasPickupFulfillmentMethod = function () {
            return _this.hasFulfillmentMethod("Pickup");
        };
        this.getFulfillmentType = function (fulfillment) {
            return fulfillment.fulfillmentMethod.fulfillmentMethodType;
        };
        this.isShippingFulfillment = function (fulfillment) {
            return _this.getFulfillmentType(fulfillment) === 'shipping';
        };
        this.isEmailFulfillment = function (fulfillment) {
            return _this.getFulfillmentType(fulfillment) === 'email';
        };
        this.isPickupFulfillment = function (fulfillment) {
            return _this.getFulfillmentType(fulfillment) === 'pickup';
        };
        /** Returns true if the order fulfillment has a shipping address selected. */
        this.hasShippingAddress = function (fulfillmentIndex) {
            return (_this.cart.orderFulfillments[fulfillmentIndex] &&
                _this.isShippingFulfillment(_this.cart.orderFulfillments[fulfillmentIndex]) &&
                _this.cart.orderFulfillments[fulfillmentIndex].data.shippingAddress &&
                _this.cart.orderFulfillments[fulfillmentIndex].data.shippingAddress.addressID);
        };
        this.hasShippingMethodOptions = function (fulfillmentIndex) {
            var shippingMethodOptions = _this.cart.orderFulfillments[fulfillmentIndex].shippingMethodOptions;
            return shippingMethodOptions && shippingMethodOptions.length && (shippingMethodOptions.length > 1 || (shippingMethodOptions[0].value && shippingMethodOptions[0].value.length));
        };
        /** Returns true if the order fulfillment has a shipping address selected. */
        this.hasPickupLocation = function (fulfillmentIndex) {
            return (_this.cart.orderFulfillments[fulfillmentIndex] &&
                _this.isPickupFulfillment(_this.cart.orderFulfillments[fulfillmentIndex]) &&
                _this.cart.orderFulfillments[fulfillmentIndex].pickupLocation);
        };
        /** Returns true if the order requires a fulfillment */
        this.orderRequiresFulfillment = function () {
            return _this.cart.orderRequiresFulfillment();
        };
        /**
         *  Returns true if the order requires a account
         *  Either because the user is not logged in, or because they don't have one.
         *
         */
        this.orderRequiresAccount = function () {
            return _this.cart.orderRequiresAccount();
        };
        /** Returns true if the payment tab should be active */
        this.hasShippingAddressAndMethod = function () {
            return _this.cart.hasShippingAddressAndMethod();
        };
        /**
         * Returns true if the user has an account and is logged in.
         */
        this.hasAccount = function () {
            if (_this.account.accountID) {
                return true;
            }
            return false;
        };
        /** Redirects to the passed in URL
        */
        this.redirectExact = function (url) {
            _this.$window.location.href = url;
        };
        // /** Returns true if a property on an object is undefined or empty. */
        this.isUndefinedOrEmpty = function (object, property) {
            if (!angular.isDefined(object[property]) || object[property] == "") {
                return true;
            }
            return false;
        };
        /** A simple method to return the quantity sum of all orderitems in the cart. */
        this.getOrderItemQuantitySum = function () {
            var totalQuantity = 0;
            if (angular.isDefined(_this.cart)) {
                return _this.cart.getOrderItemQuantitySum();
            }
            return totalQuantity;
        };
        /** Returns the index of the state from the list of states */
        this.getSelectedStateIndexFromStateCode = function (stateCode, states) {
            for (var state in states) {
                if (states[state].value == stateCode) {
                    return state;
                }
            }
        };
        /** Selects shippingAddress*/
        this.selectShippingAccountAddress = function (accountAddressID, orderFulfillmentID) {
            _this.observerService.notify("shippingAddressSelected", { "accountAddressID": accountAddressID });
            var fulfillmentIndex = _this.cart.orderFulfillments.findIndex(function (fulfillment) { return fulfillment.orderFulfillmentID == orderFulfillmentID; });
            var oldAccountAddressID;
            if (_this.cart.orderFulfillments[fulfillmentIndex] && _this.cart.orderFulfillments[fulfillmentIndex].accountAddress) {
                oldAccountAddressID = _this.cart.orderFulfillments[fulfillmentIndex].accountAddress.accountAddressID;
            }
            _this.doAction('addShippingAddressUsingAccountAddress', { accountAddressID: accountAddressID, fulfillmentID: orderFulfillmentID, returnJsonObjects: 'cart' }).then(function (result) {
                if (result && result.failureActions && result.failureActions.length) {
                    _this.$timeout(function () {
                        if (oldAccountAddressID) {
                            _this.cart.orderFulfillments[fulfillmentIndex].accountAddress.accountAddressID = oldAccountAddressID;
                        }
                    });
                }
            });
        };
        /** Selects shippingAddress*/
        this.selectBillingAccountAddress = function (accountAddressID) {
            _this.doAction('addBillingAddressUsingAccountAddress', { accountAddressID: accountAddressID });
        };
        /**
         * Returns true if on a mobile device. This is important for placeholders.
         */
        this.isMobile = function () {
            if (_this.$window.innerWidth <= 800 && _this.$window.innerHeight <= 600) {
                return true;
            }
            return false;
        };
        /** returns true if the shipping method option passed in is the selected shipping method
        */
        this.isSelectedShippingMethod = function (option, fulfillmentIndex) {
            // DEPRECATED LOGIC
            if (typeof option === 'number' || typeof option === 'string') {
                var index = option, value = fulfillmentIndex;
                var orderFulfillment = void 0;
                for (var _i = 0, _a = _this.cart.orderFulfillments; _i < _a.length; _i++) {
                    var fulfillment = _a[_i];
                    if (_this.isShippingFulfillment(fulfillment)) {
                        orderFulfillment = fulfillment;
                    }
                }
                if (_this.cart.fulfillmentTotal &&
                    value == orderFulfillment.shippingMethod.shippingMethodID ||
                    orderFulfillment.shippingMethodOptions.length == 1) {
                    return true;
                }
                return false;
            }
            //NEW LOGIC
            return (_this.cart.orderFulfillments[fulfillmentIndex].data.shippingMethod &&
                _this.cart.orderFulfillments[fulfillmentIndex].data.shippingMethod.shippingMethodID == option.value) ||
                (_this.cart.orderFulfillments[fulfillmentIndex].data.shippingMethodOptions.length == 1);
        };
        /** Select a shipping method - temporarily changes the selected method on the front end while awaiting official change from server
        */
        this.selectShippingMethod = function (option, orderFulfillment) {
            var fulfillmentID = '';
            if (typeof orderFulfillment == 'string') {
                orderFulfillment = _this.cart.orderFulfillments[orderFulfillment];
            }
            var data = {
                'shippingMethodID': option.value,
                'fulfillmentID': orderFulfillment.orderFulfillmentID
            };
            _this.doAction('addShippingMethodUsingShippingMethodID', data);
            if (!orderFulfillment.data.shippingMethod) {
                orderFulfillment.data.shippingMethod = {};
            }
            orderFulfillment.data.shippingMethod.shippingMethodID = option.value;
        };
        /** Removes promotional code from order*/
        this.removePromoCode = function (code) {
            _this.doAction('removePromotionCode', { promotionCode: code });
        };
        this.deleteAccountAddress = function (accountAddressID) {
            _this.doAction('deleteAccountAddress', { accountAddressID: accountAddressID });
        };
        //gets the calcuated total minus the applied gift cards.
        this.getTotalMinusGiftCards = function () {
            var total = _this.getAppliedGiftCardTotals();
            return _this.cart.calculatedTotal - total;
        };
        /** Format saved payment method info for display in list*/
        this.formatPaymentMethod = function (paymentMethod) {
            return (paymentMethod.accountPaymentMethodName || paymentMethod.nameOnCreditCard) + ' - ' + paymentMethod.creditCardType + ' *' + paymentMethod.creditCardLastFour + ' exp. ' + ('0' + paymentMethod.expirationMonth).slice(-2) + '/' + paymentMethod.expirationYear.toString().slice(-2);
        };
        this.getOrderItemSkuIDs = function (cart) {
            return cart.orderItems.map(function (item) {
                return item.sku.skuID;
            }).join(',');
        };
        this.getResizedImageByProfileName = function (profileName, skuIDs) {
            _this.loading = true;
            if (profileName == undefined) {
                profileName = "medium";
            }
            _this.doAction('getResizedImageByProfileName', { profileName: profileName, skuIds: skuIDs }).then(function (result) {
                if (!angular.isDefined(_this.imagePath)) {
                    _this.imagePath = {};
                }
                if (result && result.resizedImagePaths) {
                    for (var skuID in result.resizedImagePaths) {
                        _this.imagePath[skuID] = result.resizedImagePaths[skuID];
                    }
                }
            });
        };
        /** Returns the amount total of giftcards added to this order.*/
        this.getPaymentTotals = function () {
            //
            var total = 0;
            for (var index in _this.cart.orderPayments) {
                total = total + Number(_this.cart.orderPayments[index]['amount'].toFixed(2));
            }
            return total;
        };
        /** Gets the calcuated total minus the applied gift cards. */
        this.getTotalMinusPayments = function () {
            var total = _this.getPaymentTotals();
            return _this.cart.calculatedTotal - total;
        };
        /** Boolean indicating whether the total balance has been accounted for by order payments.*/
        this.paymentsEqualTotalBalance = function () {
            return _this.getTotalMinusPayments() == 0;
        };
        /**View logic - Opens review panel if no more payments are due.*/
        this.checkIfFinalPayment = function () {
            if ((_this.getRequestByAction('addOrderPayment') && _this.getRequestByAction('addOrderPayment').hasSuccessfulAction() ||
                _this.getRequestByAction('addGiftCardOrderPayment') && _this.getRequestByAction('addGiftCardOrderPayment').hasSuccessfulAction()) && _this.paymentsEqualTotalBalance()) {
                _this.edit = 'review';
            }
        };
        this.getAddressEntity = function (address) {
            var addressEntity = _this.$hibachi.newAddress();
            if (address) {
                for (var key in address) {
                    if (address.hasOwnProperty(key)) {
                        addressEntity[key] = address[key];
                    }
                }
            }
            return addressEntity;
        };
        this.resetRequests = function (request) {
            delete _this.requests[request];
        };
        /** Returns true if the addresses match. */
        this.addressesMatch = function (address1, address2) {
            if (angular.isDefined(address1) && angular.isDefined(address2)) {
                if ((address1.streetAddress == address2.streetAddress &&
                    address1.street2Address == address2.street2Address &&
                    address1.city == address2.city &&
                    address1.postalCode == address2.postalCode &&
                    address1.stateCode == address2.stateCode &&
                    address1.countrycode == address2.countrycode)) {
                    return true;
                }
            }
            return false;
        };
        /**
       *  Returns true when the fulfillment body should be showing
       *  Show if we don't need an account but do need a fulfillment
       *
       */
        this.showFulfillmentTabBody = function () {
            if (!_this.hasAccount())
                return false;
            if ((_this.cart.orderRequirementsList.indexOf('account') == -1) &&
                (_this.cart.orderRequirementsList.indexOf('fulfillment') != -1) && !_this.edit ||
                (_this.edit == 'fulfillment')) {
                return true;
            }
            return false;
        };
        /**
         *  Returns true when the fulfillment body should be showing
         *  Show if we don't need an account,fulfillment, and don't have a payment - or
         *  we have a payment but are editting the payment AND nothing else is being edited
         *
         */
        this.showPaymentTabBody = function () {
            if (!_this.hasAccount())
                return false;
            if (((_this.cart.orderRequirementsList.indexOf('account') == -1) &&
                (_this.cart.orderRequirementsList.indexOf('fulfillment') == -1) &&
                (_this.cart.orderRequirementsList.indexOf('payment') != -1) && !_this.edit) ||
                ((_this.cart.orderRequirementsList.indexOf('account') == -1) &&
                    (_this.cart.orderRequirementsList.indexOf('fulfillment') == -1) &&
                    (_this.edit == 'payment'))) {
                return true;
            }
            return false;
        };
        /**
         *  Returns true if the review tab body should be showing.
         *  Show if we don't need an account,fulfillment,payment, but not if something else is being edited
         *
         */
        this.showReviewTabBody = function () {
            if (!_this.hasAccount())
                return false;
            if ((_this.cart.orderRequirementsList.indexOf('account') == -1) &&
                (_this.cart.orderRequirementsList.indexOf('fulfillment') == -1) &&
                (_this.cart.orderRequirementsList.indexOf('payment') == -1) &&
                ((!_this.edit) || (_this.edit == 'review'))) {
                return true;
            }
            return false;
        };
        /** Returns true if the fulfillment tab should be active */
        this.fulfillmentTabIsActive = function () {
            if (!_this.hasAccount())
                return false;
            if ((_this.edit == 'fulfillment') ||
                (!_this.edit && ((_this.cart.orderRequirementsList.indexOf('account') == -1) && _this.account.accountID) &&
                    (_this.cart.orderRequirementsList.indexOf('fulfillment') != -1))) {
                return true;
            }
            return false;
        };
        /** Returns true if the payment tab should be active */
        this.paymentTabIsActive = function () {
            if (!_this.hasAccount())
                return false;
            if ((_this.edit == 'payment') ||
                (!_this.edit &&
                    (_this.cart.orderRequirementsList.indexOf('account') == -1) && _this.account.accountID &&
                    (_this.cart.orderRequirementsList.indexOf('fulfillment') == -1) &&
                    (_this.cart.orderRequirementsList.indexOf('payment') != -1))) {
                return true;
            }
            return false;
        };
        this.isCreatingAccount = function () {
            return !_this.hasAccount() && _this.showCreateAccount;
        };
        this.isSigningIn = function () {
            return !_this.hasAccount() && !_this.showCreateAccount;
        };
        this.loginError = function () {
            if (_this.account.processObjects && _this.account.processObjects.login && _this.account.processObjects.login.hasErrors) {
                return _this.account.processObjects.login.errors.emailAddress['0'];
            }
            ;
        };
        this.createAccountError = function () {
            if (_this.account.processObjects && _this.account.processObjects.create && _this.account.processObjects.create.hasErrors) {
                return _this.account.processObjects.create.errors;
            }
        };
        this.forgotPasswordNotSubmitted = function () {
            return !_this.account.processObjects || (!_this.account.hasErrors && !_this.account.processObjects.forgotPassword);
        };
        this.forgotPasswordSubmitted = function () {
            return _this.account.processObjects && _this.account.processObjects.forgotPassword;
        };
        this.forgotPasswordHasNoErrors = function () {
            return _this.account.processObjects && _this.account.processObjects.forgotPassword && !_this.account.processObjects.forgotPassword.hasErrors;
        };
        this.forgotPasswordError = function () {
            if (_this.forgotPasswordSubmitted() && !_this.forgotPasswordHasNoErrors()) {
                return _this.account.processObjects.forgotPassword.errors.emailAddress['0'];
            }
        };
        /** Consolidate response errors on cart.errors.runPlaceOrderTransaction*/
        this.placeOrderFailure = function () {
            var errors = [];
            for (var key in _this.cart.errors) {
                var errArray = _this.cart.errors[key];
                errors = errors.concat(errArray);
            }
            _this.cart.errors.runPlaceOrderTransaction = errors;
            _this.edit = '';
        };
        /** Returns errors from placeOrder request*/
        this.placeOrderError = function () {
            if (_this.cart.hasErrors && _this.cart.errors.runPlaceOrderTransaction) {
                return _this.cart.errors.runPlaceOrderTransaction;
            }
        };
        /** Returns errors from addOrderPayment request. */
        this.addOrderPaymentError = function () {
            if (_this.cart.errors.addOrderPayment)
                return _this.cart.errors.addOrderPayment;
            if (_this.cart.errors.runPlaceOrderTransaction)
                return _this.cart.errors.runPlaceOrderTransaction;
            return angular.isDefined(_this.errors) ? _this.errors['ADDORDERPAYMENT'] : false;
        };
        /** Returns errors from addBillingAddress request. */
        this.addBillingAddressError = function () {
            if (_this.loadingThisRequest('addOrderPayment', {}, false))
                return false;
            if (_this.errors && _this.errors.copied)
                return _this.addBillingAddressErrors;
            _this.addBillingAddressErrors = _this.cart.errors.addBillingAddress || (angular.isDefined(_this.errors) ? _this.errors['addBillingAddress'] : false);
            if (!_this.billingAddressEditFormIndex && _this.errors && _this.hasFailureAction('addBillingAddress')) {
                var addressProperties = _this.$hibachi.newAddress().data;
                for (var property in _this.errors) {
                    if (addressProperties.hasOwnProperty(property)) {
                        _this.addBillingAddressErrors = _this.addBillingAddressErrors || [];
                        _this.errors[property].forEach(function (error) {
                            _this.addBillingAddressErrors.push(error);
                        });
                    }
                }
                _this.errors.copied = 1;
            }
            return _this.addBillingAddressErrors;
        };
        /** Returns errors from addGiftCard request. */
        this.giftCardError = function () {
            if (_this.cart.processObjects &&
                _this.cart.processObjects.addOrderPayment &&
                _this.cart.processObjects.addOrderPayment.errors &&
                _this.cart.processObjects.addOrderPayment.errors.giftCardID) {
                return _this.cart.processObjects.addOrderPayment.errors.giftCardID[0];
            }
        };
        this.editAccountAddress = function (key, fulfillmentIndex) {
            _this.clearShippingAddressErrors();
            _this.accountAddressEditFormIndex[fulfillmentIndex] = key;
            _this.editingAccountAddress = _this.getAddressEntity(_this.account.accountAddresses[key].address);
            _this.editingAccountAddress.accountAddressName = _this.account.accountAddresses[key].accountAddressName;
            _this.editingAccountAddress.accountAddressID = _this.account.accountAddresses[key].accountAddressID;
        };
        this.editBillingAddress = function (key, formName) {
            _this.clearMessages();
            _this.billingAddressEditFormIndex = key;
            _this.selectedBillingAddress = null;
            if (formName) {
                _this[formName + 'BillingAddress'] = _this.getAddressEntity(_this.account.accountAddresses[key].address);
                _this[formName + 'BillingAddress'].accountAddressName = _this.account.accountAddresses[key].accountAddressName;
                _this[formName + 'BillingAddress'].accountAddressID = _this.account.accountAddresses[key].accountAddressID;
            }
            else {
                _this.billingAddress = _this.getAddressEntity(_this.account.accountAddresses[key].address);
                _this.billingAddress.accountAddressName = _this.account.accountAddresses[key].accountAddressName;
                _this.billingAddress.accountAddressID = _this.account.accountAddresses[key].accountAddressID;
            }
        };
        this.clearShippingAddressErrors = function () {
            _this.clearMessages();
            _this.shippingAddressErrors = undefined;
        };
        this.clearMessages = function () {
            _this.successfulActions = [];
            _this.failureActions = [];
        };
        this.clearPaymentMethod = function () {
            _this.activePaymentMethod = null;
        };
        /**Hides shipping address form, clears shipping address errors*/
        this.hideAccountAddressForm = function (fulfillmentIndex) {
            _this.accountAddressEditFormIndex[fulfillmentIndex] = undefined;
        };
        this.hideBillingAddressForm = function () {
            if (_this.billingAddressEditFormIndex != undefined) {
                var index = _this.billingAddressEditFormIndex;
                if (_this.billingAddressEditFormIndex == 'new') {
                    index = _this.account.accountAddresses.length - 1;
                }
                _this.selectBillingAddress(index);
            }
            _this.billingAddressEditFormIndex = undefined;
            _this.billingAddress = {};
        };
        this.editingDifferentAccountAddress = function (fulfillmentIndex) {
            for (var index = 0; index < _this.cart.orderFulfillments.length; index++) {
                if (index !== fulfillmentIndex && _this.accountAddressEditFormIndex[index] != undefined) {
                    return true;
                }
            }
        };
        this.showEditAccountAddressForm = function (fulfillmentIndex) {
            return _this.accountAddressEditFormIndex[fulfillmentIndex] != undefined && _this.accountAddressEditFormIndex[fulfillmentIndex] != 'new';
        };
        this.showNewAccountAddressForm = function (fulfillmentIndex) {
            return _this.accountAddressEditFormIndex[fulfillmentIndex] == 'new';
        };
        this.showNewBillingAddressForm = function () {
            return !_this.useShippingAsBilling && _this.billingAddressEditFormIndex == 'new';
        };
        this.showEditBillingAddressForm = function () {
            return !_this.useShippingAsBilling && _this.billingAddressEditFormIndex != undefined && _this.billingAddressEditFormIndex != 'new';
        };
        /** Adds errors from response to cart errors.*/
        this.addBillingErrorsToCartErrors = function () {
            var cartErrors = _this.cart.errors;
            if (cartErrors.addOrderPayment) {
                var deleteIndex = cartErrors.addOrderPayment.indexOf('billingAddress');
                if (deleteIndex > -1) {
                    cartErrors.addOrderPayment.splice(deleteIndex, 1);
                }
                if (cartErrors.addOrderPayment.length == 0) {
                    cartErrors.addOrderPayment = null;
                }
            }
            cartErrors.addBillingAddress = [];
            for (var key in _this.errors) {
                _this.cart.errors.addBillingAddress = _this.cart.errors.addBillingAddress.concat(_this.errors[key]);
            }
        };
        this.accountAddressIsSelectedShippingAddress = function (key, fulfillmentIndex) {
            if (_this.account &&
                _this.account.accountAddresses &&
                _this.cart.orderFulfillments[fulfillmentIndex].shippingAddress &&
                !_this.cart.orderFulfillments[fulfillmentIndex].shippingAddress.hasErrors) {
                return _this.addressesMatch(_this.account.accountAddresses[key].address, _this.cart.orderFulfillments[fulfillmentIndex].shippingAddress);
            }
            return false;
        };
        this.accountAddressIsSelectedBillingAddress = function (key) {
            if (_this.account &&
                _this.account.accountAddresses &&
                _this.orderPaymentObject &&
                _this.orderPaymentObject.newOrderPayment &&
                _this.orderPaymentObject.newOrderPayment.billingAddress) {
                return _this.account.accountAddresses[key].accountAddressID == _this.orderPaymentObject.newOrderPayment.billingAddress.accountAddressID;
            }
            return false;
        };
        /** Returns true if order requires email fulfillment and email address has been chosen.*/
        this.hasEmailFulfillmentAddress = function (fulfillmentIndex) {
            return Boolean(_this.cart.orderFulfillments[fulfillmentIndex].emailAddress);
        };
        this.getEligiblePaymentMethodsForPaymentMethodType = function (paymentMethodType) {
            return _this.cart.eligiblePaymentMethodDetails.filter(function (paymentMethod) {
                return paymentMethod.paymentMethod.paymentMethodType == paymentMethodType;
            });
        };
        this.getEligibleCreditCardPaymentMethods = function () {
            return _this.getEligiblePaymentMethodsForPaymentMethodType('creditCard');
        };
        this.getPickupLocation = function (fulfillmentIndex) {
            if (!_this.cart.data.orderFulfillments[fulfillmentIndex])
                return;
            return _this.cart.data.orderFulfillments[fulfillmentIndex].pickupLocation;
        };
        this.getShippingAddress = function (fulfillmentIndex) {
            if (!_this.cart.data.orderFulfillments[fulfillmentIndex])
                return;
            return _this.cart.data.orderFulfillments[fulfillmentIndex].data.shippingAddress;
        };
        this.getEmailFulfillmentAddress = function (fulfillmentIndex) {
            if (!_this.cart.data.orderFulfillments[fulfillmentIndex])
                return;
            return _this.cart.data.orderFulfillments[fulfillmentIndex].emailAddress;
        };
        this.getPickupLocations = function () {
            var locations = [];
            _this.cart.orderFulfillments.forEach(function (fulfillment, index) {
                if (_this.getFulfillmentType(fulfillment) == 'pickup' && fulfillment.pickupLocation && fulfillment.pickupLocation.locationID) {
                    fulfillment.pickupLocation.fulfillmentIndex = index;
                    locations.push(fulfillment.pickupLocation);
                }
            });
            return locations;
        };
        this.getShippingAddresses = function () {
            var addresses = [];
            _this.cart.orderFulfillments.forEach(function (fulfillment, index) {
                if (_this.getFulfillmentType(fulfillment) == 'shipping' && fulfillment.data.shippingAddress && fulfillment.data.shippingAddress.addressID) {
                    fulfillment.data.shippingAddress.fulfillmentIndex = index;
                    addresses.push(fulfillment.data.shippingAddress);
                }
            });
            return addresses;
        };
        this.getEmailFulfillmentAddresses = function () {
            var addresses = [];
            _this.cart.orderFulfillments.forEach(function (fulfillment, index) {
                if (_this.getFulfillmentType(fulfillment) == 'email' && fulfillment.emailAddress) {
                    fulfillment.fulfillmentIndex = index;
                    addresses.push(fulfillment);
                }
            });
            return addresses;
        };
        /** Returns true if any action in comma-delimited list exists in this.successfulActions */
        this.hasSuccessfulAction = function (actionList) {
            for (var _i = 0, _a = actionList.split(','); _i < _a.length; _i++) {
                var action = _a[_i];
                if (_this.successfulActions.indexOf(action) > -1) {
                    return true;
                }
            }
            return false;
        };
        /** Returns true if any action in comma-delimited list exists in this.failureActions */
        this.hasFailureAction = function (actionList) {
            for (var _i = 0, _a = actionList.split(','); _i < _a.length; _i++) {
                var action = _a[_i];
                if (_this.failureActions.indexOf(action) > -1) {
                    return true;
                }
            }
            return false;
        };
        this.shippingUpdateSuccess = function () {
            return _this.hasSuccessfulAction('addShippingAddressUsingAccountAddress,addShippingAddress');
        };
        this.shippingMethodUpdateSuccess = function () {
            return _this.hasSuccessfulAction('addShippingMethodUsingShippingMethodID');
        };
        this.updatedBillingAddress = function () {
            return _this.hasSuccessfulAction('updateAddress') && !_this.hasSuccessfulAction('addShippingAddress');
        };
        this.addedBillingAddress = function () {
            return _this.hasSuccessfulAction('addNewAccountAddress') && !_this.hasSuccessfulAction('addShippingAddressUsingAccountAddress');
        };
        this.addedShippingAddress = function () {
            return _this.hasSuccessfulAction('addNewAccountAddress') && _this.hasSuccessfulAction('addShippingAddressUsingAccountAddress');
        };
        this.emailFulfillmentUpdateSuccess = function () {
            return _this.hasSuccessfulAction('addEmailFulfillmentAddress');
        };
        this.pickupLocationUpdateSuccess = function () {
            return _this.hasSuccessfulAction('addEmailFulfillmentAddress');
        };
        /** Returns true if selected pickup location has no name.*/
        this.namelessPickupLocation = function (fulfillmentIndex) {
            if (!_this.getPickupLocation(fulfillmentIndex))
                return false;
            return _this.getPickupLocation(fulfillmentIndex).primaryAddress != undefined && _this.getPickupLocation(fulfillmentIndex).locationName == undefined;
        };
        /** Returns true if no pickup location has been selected.*/
        this.noPickupLocation = function (fulfillmentIndex) {
            if (!_this.getPickupLocation(fulfillmentIndex))
                return true;
            return _this.getPickupLocation(fulfillmentIndex).primaryAddress == undefined && _this.getPickupLocation(fulfillmentIndex).locationName == undefined;
        };
        this.disableContinueToPayment = function () {
            return _this.cart.orderRequirementsList.indexOf('fulfillment') != -1;
        };
        this.hasAccountPaymentMethods = function () {
            return _this.account && _this.account.accountPaymentMethods && _this.account.accountPaymentMethods.length;
        };
        this.showBillingAccountAddresses = function () {
            return !_this.useShippingAsBilling && _this.billingAddressEditFormIndex == undefined;
        };
        this.hasNoCardInfo = function () {
            return !_this.newCardInfo || !_this.newCardInfo.nameOnCreditCard || !_this.newCardInfo.cardNumber || !_this.newCardInfo.cvv;
        };
        this.isGiftCardPayment = function (payment) {
            return payment.giftCard && payment.giftCard.giftCardCode;
        };
        this.isPurchaseOrderPayment = function (payment) {
            return payment.purchaseOrderNumber;
        };
        //Not particularly robust, needs to be modified for each project
        this.isCheckOrMoneyOrderPayment = function (payment) {
            return payment.paymentMethod.paymentMethodName == "Check or Money Order";
        };
        this.orderHasNoPayments = function () {
            var activePayments = _this.cart.orderPayments.filter(function (payment) { return payment.amount != 0; });
            return !activePayments.length;
        };
        this.hasProductNameAndNoSkuName = function (orderItem) {
            return !orderItem.sku.skuName && orderItem.sku.product && orderItem.sku.product.productName;
        };
        this.cartHasNoItems = function () {
            return !_this.getRequestByAction('getCart').loading && _this.hasAccount() && _this.cart && _this.cart.orderItems && !_this.cart.orderItems.length && !_this.loading && !_this.orderPlaced;
        };
        this.hasAccountAndCartItems = function () {
            return _this.hasAccount() && !_this.cartHasNoItems();
        };
        this.hideStoreSelector = function (fulfillmentIndex) {
            _this.showStoreSelector[fulfillmentIndex] = false;
        };
        this.hideEmailSelector = function (fulfillmentIndex) {
            _this.showEmailSelector[fulfillmentIndex] = false;
        };
        this.updateOrderItemQuantity = function (orderItemID, quantity) {
            if (quantity === void 0) { quantity = 1; }
            _this.doAction('updateOrderItemQuantity', { 'orderItem.orderItemID': orderItemID, 'orderItem.quantity': quantity });
        };
        this.getOrderAttributeValues = function (allowedAttributeSets) {
            var attributeValues = {};
            var orderAttributeModel = JSON.parse(localStorage.getItem('attributeMetaData'))["Order"];
            for (var attributeSetCode in orderAttributeModel) {
                var attributeSet = orderAttributeModel[attributeSetCode];
                if (allowedAttributeSets.indexOf(attributeSetCode) !== -1) {
                    for (var attributeCode in attributeSet.attributes) {
                        var attribute = attributeSet.attributes[attributeCode];
                        attributeValues[attribute.attributeCode] = {
                            attributeCode: attribute.attributeCode,
                            attributeName: attribute.attributeName,
                            attributeValue: _this.cart[attribute.attributeCode],
                            inputType: attribute.attributeInputType,
                            requiredFlag: attribute.requiredFlag
                        };
                    }
                }
            }
            return attributeValues;
        };
        this.binder = function (self, fn) {
            var args = [];
            for (var _i = 2; _i < arguments.length; _i++) {
                args[_i - 2] = arguments[_i];
            }
            return fn.bind.apply(fn, __spreadArrays([self], args));
        };
        /*********************************************************************************/
        /*******************                                    **************************/
        /*******************         DEPRECATED METHODS         **************************/
        /*******************                                    **************************/
        /*********************************************************************************/
        /** DEPRECATED
        */
        this.getSelectedShippingIndex = function (index, value) {
            for (var i = 0; i <= this.cart.orderFulfillments[this.cart.orderFulfillmentWithShippingMethodOptionsIndex].shippingMethodOptions.length; i++) {
                if (this.cart.fulfillmentTotal == this.cart.orderFulfillments[this.cart.orderFulfillmentWithShippingMethodOptionsIndex].shippingMethodOptions[i].totalCharge) {
                    return i;
                }
            }
        };
        /** simple validation just to ensure data is present and accounted for.
        */
        this.validateNewOrderPayment = function (newOrderPayment) {
            var newOrderPaymentErrors = {};
            if (_this.isUndefinedOrEmpty(newOrderPayment, 'newOrderPayment.billingAddress.streetAddress')) {
                newOrderPaymentErrors['streetAddress'] = 'Required *';
            }
            if (_this.isUndefinedOrEmpty(newOrderPayment, 'newOrderPayment.billingAddress.countrycode')) {
                newOrderPaymentErrors['countrycode'] = 'Required *';
            }
            if (_this.isUndefinedOrEmpty(newOrderPayment, 'newOrderPayment.billingAddress.statecode')) {
                if (_this.isUndefinedOrEmpty(newOrderPayment, 'newOrderPayment.billingAddress.locality')) {
                    newOrderPaymentErrors['statecode'] = 'Required *';
                }
            }
            if (_this.isUndefinedOrEmpty(newOrderPayment, 'newOrderPayment.billingAddress.city')) {
                if (_this.isUndefinedOrEmpty(newOrderPayment, 'newOrderPayment.billingAddress.city')) {
                    newOrderPaymentErrors['city'] = 'Required *';
                }
            }
            if (_this.isUndefinedOrEmpty(newOrderPayment, 'newOrderPayment.billingAddress.locality')) {
                if (_this.isUndefinedOrEmpty(newOrderPayment, 'newOrderPayment.billingAddress.statecode')) {
                    newOrderPaymentErrors['locality'] = 'Required *';
                }
            }
            if (_this.isUndefinedOrEmpty(newOrderPayment, 'newOrderPayment.billingAddress.postalcode')) {
                newOrderPaymentErrors['postalCode'] = 'Required *';
            }
            if (_this.isUndefinedOrEmpty(newOrderPayment, 'newOrderPayment.nameOnCreditCard')) {
                newOrderPaymentErrors['nameOnCreditCard'] = 'Required *';
            }
            if (_this.isUndefinedOrEmpty(newOrderPayment, 'newOrderPayment.expirationMonth')) {
                newOrderPaymentErrors['streetAddress'] = 'Required *';
            }
            if (_this.isUndefinedOrEmpty(newOrderPayment, 'newOrderPayment.expirationYear')) {
                newOrderPaymentErrors['expirationYear'] = 'Required *';
            }
            if (_this.isUndefinedOrEmpty(newOrderPayment, 'newOrderPayment.creditCardNumber')) {
                newOrderPaymentErrors['creditCardNumber'] = 'Required *';
            }
            if (_this.isUndefinedOrEmpty(newOrderPayment, 'newOrderPayment.securityCode')) {
                newOrderPaymentErrors['securityCode'] = 'Required *';
            }
            if (Object.keys(newOrderPaymentErrors).length) {
                //this.cart.orderPayments.hasErrors = true;
                //this.cart.orderPayments.errors = newOrderPaymentErrors;
            }
        };
        /** Allows an easy way to calling the service addOrderPayment.
        */
        this.addOrderPayment = function (formdata) {
            //reset the form errors.
            //Grab all the data
            var billingAddress = _this.newBillingAddress;
            var expirationMonth = formdata.month;
            var expirationYear = formdata.year;
            var country = formdata.country;
            var state = formdata.state;
            var accountFirst = _this.account.firstName;
            var accountLast = _this.account.lastName;
            var data = {};
            var processObject = _this.orderService.newOrder_AddOrderPayment();
            data = {
                'newOrderPayment.billingAddress.addressID': '',
                'newOrderPayment.billingAddress.streetAddress': billingAddress.streetAddress,
                'newOrderPayment.billingAddress.street2Address': billingAddress.street2Address,
                'newOrderPayment.nameOnCreditCard': billingAddress.nameOnCreditCard,
                'newOrderPayment.billingAddress.name': billingAddress.nameOnCreditCard,
                'newOrderPayment.expirationMonth': expirationMonth,
                'newOrderPayment.expirationYear': expirationYear,
                'newOrderPayment.billingAddress.countrycode': country || billingAddress.countrycode,
                'newOrderPayment.billingAddress.city': '' + billingAddress.city,
                'newOrderPayment.billingAddress.statecode': state || billingAddress.statecode,
                'newOrderPayment.billingAddress.locality': billingAddress.locality || '',
                'newOrderPayment.billingAddress.postalcode': billingAddress.postalcode,
                'newOrderPayment.securityCode': billingAddress.cvv,
                'newOrderPayment.creditCardNumber': billingAddress.cardNumber,
                'newOrderPayment.saveShippingAsBilling': (_this.saveShippingAsBilling == true),
            };
            //processObject.populate(data);
            //Make sure we have required fields for a newOrderPayment.
            _this.validateNewOrderPayment(data);
            if (_this.cart.orderPayments.hasErrors && Object.keys(_this.cart.orderPayments.errors).length) {
                return -1;
            }
            //Post the new order payment and set errors as needed.
            _this.doAction('addOrderPayment', data, 'post').then(function (result) {
                var serverData = result;
                if (serverData.cart.hasErrors || angular.isDefined(_this.cart.orderPayments[_this.cart.orderPayments.length - 1]['errors']) && !_this.cart.orderPayments[_this.cart.orderPayments.length - 1]['errors'].hasErrors) {
                    _this.cart.hasErrors = true;
                    _this.readyToPlaceOrder = true;
                    _this.edit = '';
                }
                else {
                    _this.editPayment = false;
                    _this.readyToPlaceOrder = true;
                    _this.edit = '';
                }
            });
        };
        /** Allows an easy way to calling the service addOrderPayment.
        */
        this.addGiftCardOrderPayments = function (redeemGiftCardToAccount) {
            //reset the form errors.
            _this.cart.hasErrors = false;
            _this.cart.orderPayments.errors = {};
            _this.cart.orderPayments.hasErrors = false;
            //Grab all the data
            var giftCards = _this.account.giftCards;
            var data = {};
            data = {
                'newOrderPayment.paymentMethod.paymentMethodID': '50d8cd61009931554764385482347f3a',
                'newOrderPayment.redeemGiftCardToAccount': redeemGiftCardToAccount,
            };
            //add the amounts from the gift cards
            for (var card in giftCards) {
                if (giftCards[card].applied == true) {
                    data['newOrderPayment.giftCardNumber'] = giftCards[card].giftCardCode;
                    if (giftCards[card].calculatedTotal < _this.cart.calculatedTotal) {
                        data['newOrderPayment.amount'] = giftCards[card].calculatedBalanceAmount; //will use once we have amount implemented.
                    }
                    else {
                        data['newOrderPayment.amount'] = _this.cart.calculatedTotal; //this is so it doesn't throw the 100% error
                    }
                    data['copyFromType'] = "";
                    //Post the new order payment and set errors as needed.
                    _this.$q.all([_this.doAction('addOrderPayment', data, 'post')]).then(function (result) {
                        var serverData;
                        if (angular.isDefined(result['0'])) {
                            serverData = result['0'].data;
                        }
                        if (serverData.cart.hasErrors || angular.isDefined(this.cart.orderPayments[this.cart.orderPayments.length - 1]['errors']) && !this.cart.orderPayments['' + (this.cart.orderPayments.length - 1)]['errors'].hasErrors) {
                            this.cart.hasErrors = true;
                            this.readyToPlaceOrder = true;
                            this.edit = '';
                        }
                        else {
                        }
                    });
                }
            }
        };
        /** Allows an easy way to calling the service addOrderPayment.
        */
        this.addOrderPaymentAndPlaceOrder = function (formdata) {
            //reset the form errors.
            _this.orderPlaced = false;
            //Grab all the data
            var billingAddress = _this.newBillingAddress;
            var expirationMonth = formdata.month;
            var expirationYear = formdata.year;
            var country = formdata.country;
            var state = formdata.state;
            var accountFirst = _this.account.firstName;
            var accountLast = _this.account.lastName;
            var data = {};
            data = {
                'orderid': _this.cart.orderID,
                'newOrderPayment.billingAddress.streetAddress': billingAddress.streetAddress,
                'newOrderPayment.billingAddress.street2Address': billingAddress.street2Address,
                'newOrderPayment.nameOnCreditCard': billingAddress.nameOnCard || accountFirst + ' ' + accountLast,
                'newOrderPayment.expirationMonth': expirationMonth,
                'newOrderPayment.expirationYear': expirationYear,
                'newOrderPayment.billingAddress.countrycode': country || billingAddress.countrycode,
                'newOrderPayment.billingAddress.city': '' + billingAddress.city,
                'newOrderPayment.billingAddress.statecode': state || billingAddress.statecode,
                'newOrderPayment.billingAddress.locality': billingAddress.locality || '',
                'newOrderPayment.billingAddress.postalcode': billingAddress.postalcode,
                'newOrderPayment.securityCode': billingAddress.cvv,
                'newOrderPayment.creditCardNumber': billingAddress.cardNumber,
                'newOrderPayment.saveShippingAsBilling': (_this.saveShippingAsBilling == true),
            };
            //Make sure we have required fields for a newOrderPayment.
            //this.validateNewOrderPayment( data );
            if (_this.cart.orderPayments.hasErrors && Object.keys(_this.cart.orderPayments.errors).length) {
                return -1;
            }
            //Post the new order payment and set errors as needed.
            _this.$q.all([_this.doAction('addOrderPayment,placeOrder', data, 'post')]).then(function (result) {
                var serverData;
                if (angular.isDefined(result['0'])) {
                    serverData = result['0'].data;
                }
                else {
                } //|| angular.isDefined(serverData.cart.orderPayments[serverData.cart.orderPayments.length-1]['errors']) && slatwall.cart.orderPayments[''+slatwall.cart.orderPayments.length-1]['errors'].hasErrors
                if (serverData.cart.hasErrors || (angular.isDefined(serverData.failureActions) && serverData.failureActions.length && serverData.failureActions[0] == "public:cart.addOrderPayment")) {
                    if (serverData.failureActions.length) {
                        for (var action in serverData.failureActions) {
                            //
                        }
                    }
                    this.edit = '';
                    return true;
                }
                else if (serverData.successfulActions.length) {
                    //
                    this.cart.hasErrors = false;
                    this.editPayment = false;
                    this.edit = '';
                    for (var action in serverData.successfulActions) {
                        //
                        if (serverData.successfulActions[action].indexOf("placeOrder") != -1) {
                            //if there are no errors then redirect.
                            this.orderPlaced = true;
                            this.redirectExact(this.confirmationUrl);
                        }
                    }
                }
                else {
                    this.edit = '';
                }
            });
        };
        //Applies a giftcard from the user account onto the payment.
        this.applyGiftCard = function (giftCardCode) {
            _this.finding = true;
            //find the code already on the account.
            var found = false;
            for (var giftCard in _this.account.giftCards) {
                if (_this.account.giftCards[giftCard].balanceAmount == 0) {
                    _this.account.giftCards[giftCard]['error'] = "The balance is $0.00 for this card.";
                    found = false;
                }
                if (_this.account.giftCards[giftCard].giftCardCode == giftCardCode) {
                    _this.account.giftCards[giftCard].applied = true;
                    found = true;
                }
            }
            if (found) {
                _this.finding = false;
                _this.addGiftCardOrderPayments(false);
            }
            else {
                _this.finding = false;
                _this.addGiftCardOrderPayments(true);
            }
        };
        //returns the amount total of giftcards added to this account.
        this.getAppliedGiftCardTotals = function () {
            //
            var total = 0;
            for (var payment in _this.cart.orderPayments) {
                if (_this.cart.orderPayments[payment].giftCardNumber != "") {
                    total = total + parseInt(_this.cart.orderPayments[payment]['amount']);
                }
            }
            return total;
        };
        this.setOrderConfirmationUrl = function () {
            if ('undefined' !== typeof hibachiConfig.orderConfirmationUrl) {
                _this.confirmationUrl = hibachiConfig.orderConfirmationUrl;
            }
            else {
                _this.confirmationUrl = "/order-confirmation";
            }
        };
        this.orderService = orderService;
        this.cartService = cartService;
        this.accountService = accountService;
        this.accountAddressService = accountAddressService;
        this.requestService = requestService;
        this.appConfig = appConfig;
        this.baseActionPath = this.appConfig.baseURL + "/index.cfm/api/scope/"; //default path
        this.checkoutUrl = "/checkout";
        this.$http = $http;
        this.$location = $location;
        this.$q = $q;
        this.$injector = $injector;
        this.getExpirationYears();
        this.$window = $window;
        this.$hibachi = $hibachi;
        this.cart = this.cartService.newCart();
        this.account = this.accountService.newAccount();
        this.observerService = observerService;
        this.$timeout = $timeout;
        this.hibachiAuthenticationService = hibachiAuthenticationService;
        this.setOrderConfirmationUrl();
    }
    PublicService.prototype.enforceCacheOwner = function (key) {
        var _a;
        var cacheOwner = ((_a = hibachiConfig.accountID) === null || _a === void 0 ? void 0 : _a.trim()) || "unknown";
        if (this.sessionStorageCache.get("cacheOwner") !== cacheOwner) {
            console.log("enforceCacheOwner: owner changed, \n\t\t\t\t setting new owner to: " + cacheOwner + " from: " + this.sessionStorageCache.get("cacheOwner") + ",\n\t\t\t\t and clearing cache for " + key + "\n\t\t\t    ");
            this.sessionStorageCache.remove(key);
            this.sessionStorageCache.put("cacheOwner", cacheOwner);
            return false;
        }
        return true;
    };
    PublicService.prototype.getFromSessionCache = function (key) {
        return this.enforceCacheOwner(key) ? this.sessionStorageCache.get(key) : undefined;
    };
    PublicService.prototype.putIntoSessionCache = function (key, value) {
        this.enforceCacheOwner(key);
        this.sessionStorageCache.put(key, value);
    };
    PublicService.prototype.removeFromSessionCache = function (key) {
        this.enforceCacheOwner(key);
        this.sessionStorageCache.remove(key);
    };
    PublicService.prototype.authenticateEntityProperty = function (crudType, entityName, propertyName) {
        return this.hibachiAuthenticationService.authenticateEntityPropertyCrudByAccount(crudType, entityName, propertyName);
    };
    PublicService.prototype.getOrderFulfillmentItemList = function (fulfillmentIndex) {
        return this.cart.orderFulfillments[fulfillmentIndex].orderFulfillmentItems.map(function (item) { return item.sku.skuName ? item.sku.skuName : item.sku.product.productName; }).join(', ');
    };
    //Use with bind, assigning 'this' as the temporary order item
    //a.k.a. slatwall.bind(tempOrderItem,slatwall.copyOrderItem,originalOrderItem);
    //gets you tempOrderItem.orderItem == originalOrderItem;
    PublicService.prototype.copyOrderItem = function (orderItem) {
        this.orderItem = { orderItemID: orderItem.orderItemID,
            quantity: orderItem.quantity };
        return this;
    };
    return PublicService;
}());
exports.PublicService = PublicService;


/***/ }),

/***/ "HivG":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWDetail = void 0;
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWDetail = /** @class */ (function () {
    function SWDetail($location, $log, $hibachi, coreEntityPartialsPath, hibachiPathBuilder) {
        return {
            restrict: 'E',
            templateUrl: hibachiPathBuilder.buildPartialsPath(coreEntityPartialsPath) + '/detail.html',
            link: function (scope, element, attr) {
                scope.$id = "slatwallDetailController";
                $log.debug('slatwallDetailController');
                /*Sets the view dirty on save*/
                scope.setDirty = function (entity) {
                    angular.forEach(entity.forms, function (form) {
                        form.$setSubmitted();
                    });
                };
                var setupMetaData = function () {
                    scope[scope.entityName.toLowerCase()] = scope.entity;
                    scope.entity.metaData.$$getDetailTabs().then(function (value) {
                        scope.detailTabs = value.data;
                        $log.debug('detailtabs');
                        $log.debug(scope.detailTabs);
                    });
                };
                var propertyCasedEntityName = scope.entityName.charAt(0).toUpperCase() + scope.entityName.slice(1);
                scope.tabPartialPath = hibachiPathBuilder.buildPartialsPath(coreEntityPartialsPath);
                scope.getEntity = function () {
                    if (scope.entityID === 'create') {
                        scope.createMode = true;
                        scope.entity = $hibachi['new' + propertyCasedEntityName]();
                        setupMetaData();
                    }
                    else {
                        scope.createMode = false;
                        var entityPromise = $hibachi['get' + propertyCasedEntityName]({ id: scope.entityID });
                        entityPromise.promise.then(function () {
                            scope.entity = entityPromise.value;
                            setupMetaData();
                        });
                    }
                };
                scope.getEntity();
                scope.deleteEntity = function () {
                    var deletePromise = scope.entity.$$delete();
                    deletePromise.then(function () {
                        $location.path('/entity/' + propertyCasedEntityName + '/');
                    });
                };
                scope.allTabsOpen = false;
            }
        };
    }
    SWDetail.Factory = function () {
        var directive = function ($location, $log, $hibachi, coreEntityPartialsPath, hibachiPathBuilder) { return new SWDetail($location, $log, $hibachi, coreEntityPartialsPath, hibachiPathBuilder); };
        directive.$inject = [
            '$location',
            '$log',
            '$hibachi',
            'coreEntityPartialsPath',
            'hibachiPathBuilder'
        ];
        return directive;
    };
    return SWDetail;
}());
exports.SWDetail = SWDetail;


/***/ }),

/***/ "I1i7":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.HistoryService = void 0;
var HistoryService = /** @class */ (function () {
    //@ngInject
    function HistoryService() {
        var _this = this;
        this.histories = {};
        this.recordHistory = function (key, data, overwrite) {
            if (overwrite === void 0) { overwrite = false; }
            if (angular.isUndefined(_this.histories[key]) || overwrite) {
                _this.histories[key] = [];
            }
            _this.histories[key].push(data);
        };
        this.hasHistory = function (key) {
            return angular.isDefined(_this.histories[key]);
        };
        this.getHistory = function (key) {
            if (angular.isDefined(_this.histories[key])) {
                return _this.histories[key];
            }
        };
        this.deleteHistory = function (key) {
            _this.histories[key] = [];
        };
    }
    return HistoryService;
}());
exports.HistoryService = HistoryService;


/***/ }),

/***/ "IhXr":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWValidationRegex = void 0;
var SWValidationRegex = /** @class */ (function () {
    function SWValidationRegex(validationService) {
        return {
            restrict: "A",
            require: "^ngModel",
            link: function (scope, element, attributes, ngModel) {
                ngModel.$validators.swvalidationregex =
                    function (modelValue) {
                        //Returns true if this user value (model value) does match the pattern
                        return validationService.validateRegex(modelValue, attributes.swvalidationregex);
                    };
            }
        };
    }
    SWValidationRegex.Factory = function () {
        var directive = function (validationService) { return new SWValidationRegex(validationService); };
        directive.$inject = ['validationService'];
        return directive;
    };
    return SWValidationRegex;
}());
exports.SWValidationRegex = SWValidationRegex;


/***/ }),

/***/ "J8kZ":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWDraggableContainer = void 0;
var SWDraggableContainerController = /** @class */ (function () {
    //@ngInject
    SWDraggableContainerController.$inject = ["draggableService"];
    function SWDraggableContainerController(draggableService) {
        this.draggableService = draggableService;
        if (angular.isUndefined(this.draggable)) {
            this.draggable = false;
        }
    }
    return SWDraggableContainerController;
}());
var SWDraggableContainer = /** @class */ (function () {
    //@ngInject
    SWDraggableContainer.$inject = ["$timeout", "corePartialsPath", "utilityService", "listingService", "observerService", "draggableService", "hibachiPathBuilder"];
    function SWDraggableContainer($timeout, corePartialsPath, utilityService, listingService, observerService, draggableService, hibachiPathBuilder) {
        var _this = this;
        this.$timeout = $timeout;
        this.corePartialsPath = corePartialsPath;
        this.utilityService = utilityService;
        this.listingService = listingService;
        this.observerService = observerService;
        this.draggableService = draggableService;
        this.hibachiPathBuilder = hibachiPathBuilder;
        this.restrict = 'EA';
        this.scope = {};
        this.bindToController = {
            draggable: "=?",
            draggableRecords: "=?",
            dropEventName: "@?",
            listingId: "@?"
        };
        this.controller = SWDraggableContainerController;
        this.controllerAs = "swDraggableContainer";
        this.link = function (scope, element, attrs) {
            scope.$watch('swDraggableContainer.draggable', function (newValue, oldValue) {
                angular.element(element).attr("draggable", newValue);
                var placeholderElement = angular.element("<tr class='s-placeholder'><td>placeholder</td><td>placeholder</td><td>placeholder</td><td>placeholder</td><td>placeholder</td><td></td></tr>"); //temporarirly hardcoding tds so it will show up
                var id = angular.element(element).attr("id");
                if (!id) {
                    id = _this.utilityService.createID(32);
                }
                var listNode = element[0];
                var placeholderNode = placeholderElement[0];
                placeholderElement.remove();
                if (newValue) {
                    element.on('drop', function (e) {
                        e = e.originalEvent || e;
                        e.preventDefault();
                        if (!_this.draggableService.isDropAllowed(e))
                            return true;
                        var record = e.dataTransfer.getData("application/json") || e.dataTransfer.getData("text/plain");
                        var parsedRecord = JSON.parse(record);
                        var index = Array.prototype.indexOf.call(listNode.children, placeholderNode);
                        if (index < parsedRecord.draggableStartKey) {
                            parsedRecord.draggableStartKey++;
                        }
                        _this.$timeout(function () {
                            scope.swDraggableContainer.draggableRecords.splice(index, 0, parsedRecord);
                            scope.swDraggableContainer.draggableRecords.splice(parsedRecord.draggableStartKey, 1);
                        }, 0);
                        if (angular.isDefined(scope.swDraggableContainer.listingId)) {
                            _this.listingService.notifyListingPageRecordsUpdate(scope.swDraggableContainer.listingId);
                        }
                        else if (angular.isDefined(scope.swDraggableContainer.dropEventName)) {
                            _this.observerService.notify(scope.swDraggableContainer.dropEventName);
                        }
                        placeholderElement.remove();
                        e.stopPropagation();
                        return false;
                    });
                    element.on('dragenter', function (e) {
                        e = e.originalEvent || e;
                        if (!_this.draggableService.isDropAllowed(e))
                            return true;
                        e.preventDefault();
                    });
                    element.on('dragleave', function (e) {
                        e = e.originalEvent || e;
                        if (e.pageX != 0 || e.pageY != 0) {
                            return false;
                        }
                        return false;
                    });
                    element.on('dragover', function (e) {
                        e = e.originalEvent || e;
                        e.stopPropagation();
                        if (placeholderNode.parentNode != listNode) {
                            element.append(placeholderElement);
                        }
                        if (e.target !== listNode) {
                            var listItemNode = e.target;
                            while (listItemNode.parentNode !== listNode && listItemNode.parentNode) {
                                listItemNode = listItemNode.parentNode;
                            }
                            if (listItemNode.parentNode === listNode && listItemNode !== placeholderNode) {
                                if (_this.draggableService.isMouseInFirstHalf(e, listItemNode)) {
                                    listNode.insertBefore(placeholderNode, listItemNode);
                                }
                                else {
                                    listNode.insertBefore(placeholderNode, listItemNode.nextSibling);
                                }
                            }
                        }
                        element.addClass("s-dragged-over");
                        return false;
                    });
                }
            });
        };
    }
    SWDraggableContainer.Factory = function () {
        var directive = function ($timeout, corePartialsPath, utilityService, listingService, observerService, draggableService, hibachiPathBuilder) { return new SWDraggableContainer($timeout, corePartialsPath, utilityService, listingService, observerService, draggableService, hibachiPathBuilder); };
        directive.$inject = [
            '$timeout',
            'corePartialsPath',
            'utilityService',
            'listingService',
            'observerService',
            'draggableService',
            'hibachiPathBuilder'
        ];
        return directive;
    };
    return SWDraggableContainer;
}());
exports.SWDraggableContainer = SWDraggableContainer;


/***/ }),

/***/ "JFp2":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.ExpandableService = void 0;
var ExpandableService = /** @class */ (function () {
    //@ngInject
    function ExpandableService() {
        var _this = this;
        this.recordStates = {};
        this.addRecord = function (recordID, state) {
            if (angular.isUndefined(state)) {
                state = { isLoaded: true };
            }
            _this.recordStates[recordID] = state;
        };
        this.updateState = function (recordID, state) {
            if (angular.isUndefined(_this.recordStates[recordID])) {
                _this.recordStates[recordID] = {};
            }
            for (var key in state) {
                _this.recordStates[recordID][key] = state[key];
            }
        };
        this.getState = function (recordID, key) {
            if (angular.isDefined(_this.recordStates[recordID]) && angular.isDefined(key)) {
                var dataToReturn = _this.recordStates[recordID][key];
            }
            else {
                var dataToReturn = _this.recordStates[recordID];
            }
            if (angular.isDefined(dataToReturn)) {
                return dataToReturn;
            }
            return false;
        };
    }
    return ExpandableService;
}());
exports.ExpandableService = ExpandableService;


/***/ }),

/***/ "JWr5":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.CacheService = void 0;
//TODO: remove, not in use
var CacheService = /** @class */ (function () {
    //@ngInject
    CacheService.$inject = ["localStorageService"];
    function CacheService(localStorageService) {
        var _this = this;
        this.localStorageService = localStorageService;
        this.cacheData = {};
        this.saveCacheData = function () {
            _this.localStorageService.setItem("cacheData", _this.cacheData);
        };
        this.hasKey = function (key) {
            if (angular.isDefined(_this.cacheData[key])) {
                return true;
            }
            return false;
        };
        this.dateExpired = function (key) {
            if (_this.cacheData[key].expiresTime == "forever") {
                return false;
            }
            return _this.cacheData[key].expiresTime < Date.now();
        };
        this.put = function (key, dataPromise, dataTarget, expiresTime) {
            if (expiresTime === void 0) { expiresTime = "forever"; }
            _this.cacheData[key] = {};
            _this.cacheData[key].expiresTime = expiresTime;
            _this.cacheData[key].dataPromise = dataPromise;
            _this.cacheData[key].dataTarget = dataTarget;
            dataPromise.then(function (response) {
                _this.localStorageService.setItem(key, response[dataTarget]);
            }, function (reason) {
                delete _this.cacheData[key];
            });
            _this.saveCacheData();
            return dataPromise;
        };
        this.reload = function (key, expiresTime) {
            if (expiresTime === void 0) { expiresTime = "forever"; }
            _this.cacheData[key].expiresTime = expiresTime;
            _this.cacheData[key].dataPromise.then(function (response) {
                _this.localStorageService.setItem(key, response[_this.cacheData[key].dataTarget]);
            }, function (reason) {
                delete _this.cacheData[key];
            });
            _this.saveCacheData();
            return _this.cacheData[key].dataPromise;
        };
        this.fetch = function (key) {
            if (_this.hasKey(key) && !_this.dateExpired(key)) {
                if (_this.localStorageService.hasItem(key)) {
                    return _this.localStorageService.getItem(key);
                }
                _this.put(key, _this.cacheData[key].dataPromise, _this.cacheData[key].dataTarget, _this.cacheData[key].expiresTime).finally(function () {
                    return _this.localStorageService.getItem(key);
                });
            }
        };
        this.fetchOrReload = function (key, expiresTime) {
            if (angular.isDefined(_this.fetch(key))) {
                return _this.fetch(key);
            }
            else {
                _this.reload(key, expiresTime).then(function (response) {
                    return _this.fetch(key);
                }, function (reason) {
                    //throw
                });
            }
        };
        if (localStorageService.hasItem("cacheData")) {
            this.cacheData = localStorageService.getItem("cacheData");
        }
    }
    return CacheService;
}());
exports.CacheService = CacheService;


/***/ }),

/***/ "Jw3Q":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.IStore = void 0;
var rxjs_1 = __webpack_require__("3X6L");
var IStore = /** @class */ (function () {
    //@ngInject
    IStore.$inject = ["initialState", "reducer", "middleware"];
    function IStore(initialState, reducer, middleware) {
        var _this = this;
        this.initialState = initialState;
        this.reducer = reducer;
        this.middleware = middleware;
        this.dispatch = function (action) { return _this.actionStream$.next((action)); };
        this.getInstance = function () {
            return _this.store$;
        };
        this.actionStream$ = new rxjs_1.Subject();
        this.store$ = this.actionStream$.startWith(initialState).scan(reducer);
        if (middleware) {
            this.store$;
        }
        return this;
    }
    return IStore;
}());
exports.IStore = IStore;


/***/ }),

/***/ "JytI":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWFormController = exports.SWForm = void 0;
/**
* Form Controller handles the logic for this directive.
*/
var SWFormController = /** @class */ (function () {
    /**
     * This controller handles most of the logic for the swFormDirective when more complicated self inspection is needed.
     */
    // @ngInject
    SWFormController.$inject = ["$scope", "$element", "$hibachi", "$http", "$timeout", "observerService", "$rootScope", "entityService", "utilityService"];
    function SWFormController($scope, $element, $hibachi, $http, $timeout, observerService, $rootScope, entityService, utilityService) {
        var _this = this;
        this.$scope = $scope;
        this.$element = $element;
        this.$hibachi = $hibachi;
        this.$http = $http;
        this.$timeout = $timeout;
        this.observerService = observerService;
        this.$rootScope = $rootScope;
        this.entityService = entityService;
        this.utilityService = utilityService;
        this.eventsObj = [];
        this.formData = {};
        this.parseObjectErrors = true;
        this.completedActions = 0;
        this.$onInit = function () {
            if (_this.object && _this.parseObjectErrors) {
                _this.$timeout(function () {
                    _this.parseErrors(_this.object.errors);
                });
            }
        };
        this.isObject = function () {
            return (angular.isObject(_this.object));
        };
        this.submitKeyCheck = function (event) {
            if (event.form.$name == _this.name &&
                event.event.keyCode == 13) {
                _this.submit(event.swForm.action);
            }
        };
        /** create the generic submit function */
        this.submit = function (actions) {
            _this.actions = actions || _this.action;
            console.log('actions!', _this.actions);
            _this.clearErrors();
            _this.formData = _this.getFormData() || "";
            _this.doActions(_this.actions);
        };
        //array or comma delimited
        this.doActions = function (actions) {
            if (angular.isArray(actions)) {
                _this.completedActions = 0;
                for (var _i = 0, _a = actions; _i < _a.length; _i++) {
                    var action = _a[_i];
                    _this.doAction(action);
                }
            }
            else if (angular.isString(actions)) {
                _this.doAction(actions);
            }
            else {
                throw ("Unknown type of action exception");
            }
        };
        // /** iterates through the factory submitting data */
        this.doAction = function (action) {
            if (!action) {
                throw "Action not defined on form";
            }
            _this.formData = _this.formData || {};
            //
            var request = _this.$rootScope.hibachiScope.doAction(action, _this.formData)
                .then(function (result) {
                if (!result)
                    return;
                if (result.successfulActions.length) {
                    _this.completedActions++;
                }
                if ((angular.isArray(_this.actions) && _this.completedActions === _this.actions.length)
                    ||
                        (!angular.isArray(_this.actions)) && result.successfulActions.length) {
                    //if we have an array of actions and they're all complete, or if we have just one successful action
                    if (_this.sRedirectUrl) {
                        _this.$rootScope.slatwall.redirectExact(_this.sRedirectUrl);
                    }
                }
                _this.object.forms[_this.name].$setSubmitted(true);
                if (result.errors) {
                    _this.parseErrors(result.errors);
                    if (_this.fRedirectUrl) {
                        _this.$rootScope.slatwall.redirectExact(_this.fRedirectUrl);
                    }
                }
            });
        };
        /****
             * Handle parsing through the server errors and injecting the error text for that field
            * If the form only has a submit, then simply call that function and set errors.
            ***/
        this.parseErrors = function (errors) {
            if (angular.isDefined(errors) && errors) {
                angular.forEach(errors, function (val, key) {
                    var primaryElement = _this.$element.find("[error-for='" + key + "']");
                    _this.$timeout(function () {
                        /**
                        if an error class has been attached to this form
                        by its children propertydisplay or errorDisplay, use it.
                        Otherwise, just add a generic 'error' class
                        to the error message **/
                        var errorClass = _this.errorClass ? _this.errorClass : "error";
                        errors[key].forEach(function (error) {
                            primaryElement.append("<div class='" + errorClass + "' name='" + key + "Error'>" + error + "</div>");
                        });
                    }, 0);
                }, _this);
            }
        };
        /** find and clear all errors on form */
        this.clearErrors = function () {
            /** clear all form errors on submit. */
            _this.$timeout(function () {
                var errorElements = _this.$element.find("[error-for]");
                errorElements.empty();
            }, 0);
        };
        this.eventsHandler = function (params) {
            //this will call any form specific functions such as hide,show,refresh,update or whatever else you later add
            for (var e in params.events) {
                if (angular.isDefined(params.events[e].value) && params.events[e].value == _this.name.toLowerCase()) {
                    if (params.events[e].name && _this[params.events[e].name]) {
                        _this[params.events[e].name](params.events[e].value);
                    }
                }
            }
        };
        /** hides this directive on event */
        this.hide = function (param) {
            if (_this.name.toLowerCase() == param) {
                _this.$element.hide();
            }
        };
        /** shows this directive on event */
        this.show = function (param) {
            if (_this.name.toLowerCase() == param) {
                _this.$element.show();
            }
        };
        /** refreshes this directive on event */
        this.refresh = function (params) {
            //stub
        };
        /** updates this directive on event */
        this.update = function (params) {
            //stub
        };
        /** clears this directive on event */
        this.clear = function (params) {
            var iterable = _this.formCtrl;
            angular.forEach(iterable, function (val, key) {
                if (typeof val === 'object' && val.hasOwnProperty('$modelValue')) {
                    if (_this.object.forms[_this.name][key].$viewValue) {
                        _this.object.forms[_this.name][key].$setViewValue("");
                        _this.object.forms[_this.name][key].$render();
                    }
                }
                else {
                    val = "";
                }
            });
        };
        /** returns all the data from the form by iterating the form elements */
        this.getFormData = function () {
            var iterable = _this.formCtrl;
            angular.forEach(iterable, function (val, key) {
                if (typeof val === 'object' && val.hasOwnProperty('$modelValue')) {
                    if (_this.object.forms[_this.name][key].$modelValue != undefined) {
                        val = _this.object.forms[_this.name][key].$modelValue;
                    }
                    else if (_this.object.forms[_this.name][key].$viewValue != undefined) {
                        val = _this.object.forms[_this.name][key].$viewValue;
                    }
                    else if (_this.object.forms[_this.name][key].$dirty) {
                        val = "";
                    }
                    /** Check for form elements that have a name that doesn't start with $ */
                    if (angular.isString(val) || angular.isNumber(val) || typeof val == 'boolean') {
                        _this.formData[key] = val;
                    }
                    if (val.$modelValue != undefined) {
                        _this.formData[key] = val.$modelValue;
                    }
                    else if (val.$viewValue != undefined) {
                        _this.formData[key] = val.$viewValue;
                    }
                }
                else {
                }
            });
            _this.formData['returnJsonObjects'] = _this.returnJsonObjects;
            return _this.formData || "";
        };
        /** only use if the developer has specified these features with isProcessForm */
        this.$hibachi = $hibachi;
        this.utilityService = utilityService;
        if (angular.isUndefined(this.isDirty)) {
            this.isDirty = false;
        }
        //object can be either an instance or a string that will become an instance
        if (angular.isString(this.object)) {
            var objectNameArray = this.object.split('_');
            this.entityName = objectNameArray[0];
            //if the object name array has two parts then we can infer that it is a process object
            if (objectNameArray.length > 1) {
                this.context = this.context || objectNameArray[1];
                this.isProcessForm = true;
            }
            else {
                this.context = this.context || 'save';
                this.isProcessForm = false;
            }
            //convert the string to an object
            this.$timeout(function () {
                _this.object = _this.$hibachi['new' + _this.object]();
            });
        }
        else {
            if (this.object && this.object.metaData) {
                this.isProcessForm = this.object.metaData.isProcessObject;
                this.entityName = this.object.metaData.className.split('_')[0];
                if (this.isProcessForm) {
                    this.context = this.context || this.object.metaData.className.split('_')[1];
                }
                else {
                    this.context = this.context || 'save';
                }
            }
        }
        //
        this.context = this.context || this.name;
        if (this.isProcessForm) {
            /** Cart is an alias for an Order */
            if (this.entityName == "Order") {
                this.entityName = "Cart";
            }
            ;
        }
        if (this.submitOnEnter) {
            this.eventListeners = this.eventListeners || {};
            this.eventListeners.keyup = this.submitKeyCheck;
        }
        if (this.eventListeners) {
            for (var key in this.eventListeners) {
                this.observerService.attach(this.eventListeners[key], key);
            }
        }
    }
    return SWFormController;
}());
exports.SWFormController = SWFormController;
var SWForm = /** @class */ (function () {
    // @ngInject
    SWForm.$inject = ["coreFormPartialsPath", "hibachiPathBuilder"];
    function SWForm(coreFormPartialsPath, hibachiPathBuilder) {
        this.coreFormPartialsPath = coreFormPartialsPath;
        this.hibachiPathBuilder = hibachiPathBuilder;
        this.templateUrl = "";
        this.transclude = true;
        this.restrict = "E";
        this.controller = SWFormController;
        this.controllerAs = "swForm";
        this.scope = {};
        /**
         * Binds all of our variables to the controller so we can access using this
         */
        this.bindToController = {
            name: "@?",
            context: "@?",
            entityName: "@?",
            hiddenFields: "=?",
            action: "@?",
            actions: "@?",
            returnJsonObjects: '@?',
            formClass: "@?",
            formData: "=?",
            errorClass: '@?',
            object: "=?",
            onSuccess: "@?",
            onError: "@?",
            hideUntil: "@?",
            isDirty: "=?",
            inputAttributes: "@?",
            eventListeners: "=?",
            eventAnnouncers: "@",
            submitOnEnter: "@",
            parseObjectErrors: "@?",
            sRedirectUrl: "@?",
            fRedirectUrl: "@?"
        };
        /**
            * Sets the context of this form
            */
        this.link = function (scope, element, attrs, controller) {
        };
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(this.coreFormPartialsPath) + "form.html";
    }
    /**
     * Handles injecting the partials path into this class
     */
    SWForm.Factory = function () {
        var directive = function (coreFormPartialsPath, hibachiPathBuilder) { return new SWForm(coreFormPartialsPath, hibachiPathBuilder); };
        directive.$inject = ['coreFormPartialsPath', 'hibachiPathBuilder'];
        return directive;
    };
    return SWForm;
}());
exports.SWForm = SWForm;


/***/ }),

/***/ "K5TR":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.Option = exports.SWFSelectController = exports.SWFSelect = void 0;
var Option = /** @class */ (function () {
    function Option(value, name) {
        this.value = value;
        this.name = value; // we default name to be the same as value.
        if (name) { // if name was passed in, let's use that instead.
            this.name = name;
        }
    }
    return Option;
}());
exports.Option = Option;
var SWFSelectController = /** @class */ (function () {
    // @ngInject
    SWFSelectController.$inject = ["$rootScope", "$scope", "observerService"];
    function SWFSelectController($rootScope, $scope, observerService) {
        var _this = this;
        this.$rootScope = $rootScope;
        this.$scope = $scope;
        this.observerService = observerService;
        this.refreshOptions = function () {
            _this.getOptions().then(function (options) {
                _this.options = options;
                _this.selectOption(_this.options[0]);
            });
        };
        this.getOptions = function () {
            return _this.$rootScope.hibachiScope.doAction(_this.optionsMethod).then(function (result) {
                var options = [];
                result[_this.payloadFieldName].map(function (option) {
                    if (option.value && option.name) { // if we have a struct with value and name, use that
                        options.push(new Option(option.value, option.name));
                        return;
                    }
                    // otherwise, it's a simple string, so let's use that
                    options.push(new Option(option));
                });
                return options;
            });
        };
        this.selectOption = function (option) {
            _this.selectedOption = option;
            _this.observerService.notify(_this.selectEventName, option);
        };
        this.refreshOptions();
        if (this.updateEventList) {
            var events = this.updateEventList.split(",");
            events.map(function (event) {
                _this.observerService.attach(_this.refreshOptions, event);
            });
        }
    }
    return SWFSelectController;
}());
exports.SWFSelectController = SWFSelectController;
var SWFSelect = /** @class */ (function () {
    // @ngInject
    function SWFSelect() {
        this.require = {
            ngModel: '?^ngModel'
        };
        this.priority = 1000;
        this.restrict = "A";
        this.scope = true;
        /**
         * Binds all of our variables to the controller so we can access using this
         */
        this.bindToController = {
            optionsMethod: "@",
            payloadFieldName: "@",
            selectEventName: "@",
            updateEventList: "@?",
        };
        this.controller = SWFSelectController;
        this.controllerAs = "swfSelect";
        /**
            * Sets the context of this form
            */
        this.link = function (scope, element, attrs, formController) {
        };
    }
    /**
     * Handles injecting the partials path into this class
     */
    SWFSelect.Factory = function () {
        var directive = function () { return new SWFSelect(); };
        directive.$inject = [];
        return directive;
    };
    return SWFSelect;
}());
exports.SWFSelect = SWFSelect;


/***/ }),

/***/ "KET/":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.$Hibachi = exports.HibachiService = void 0;
// interface ISlatwallRootScopeService extends ng.IRootScopeService{
//     loadedResourceBundle:boolean;
// 	loadingResourceBundle:boolean;
// } 
var HibachiService = /** @class */ (function () {
    //@ngInject
    HibachiService.$inject = ["$window", "$q", "$http", "$timeout", "$log", "$rootScope", "$location", "$anchorScroll", "$injector", "requestService", "utilityService", "formService", "rbkeyService", "appConfig", "_config", "_jsEntities", "_jsEntityInstances"];
    function HibachiService($window, $q, $http, $timeout, $log, $rootScope, $location, $anchorScroll, $injector, requestService, utilityService, formService, rbkeyService, appConfig, _config, _jsEntities, _jsEntityInstances) {
        var _this = this;
        this.$window = $window;
        this.$q = $q;
        this.$http = $http;
        this.$timeout = $timeout;
        this.$log = $log;
        this.$rootScope = $rootScope;
        this.$location = $location;
        this.$anchorScroll = $anchorScroll;
        this.$injector = $injector;
        this.requestService = requestService;
        this.utilityService = utilityService;
        this.formService = formService;
        this.rbkeyService = rbkeyService;
        this.appConfig = appConfig;
        this._config = _config;
        this._jsEntities = _jsEntities;
        this._jsEntityInstances = _jsEntityInstances;
        this._deferred = {};
        this._resourceBundle = {};
        this.usePublicRoutes = false;
        this.buildUrl = function (action, queryString) {
            //actionName example: slatAction. defined in FW1 and populated to config
            var actionName = _this.appConfig.action;
            var baseUrl = _this.appConfig.baseURL;
            queryString = queryString || '';
            if (angular.isDefined(queryString) && queryString.length) {
                if (queryString.indexOf('&') !== 0) {
                    queryString = '&' + queryString;
                }
            }
            return baseUrl + '?' + actionName + '=' + action + queryString;
        };
        this.getUrlWithActionPrefix = function () {
            return _this.appConfig.baseURL + '/index.cfm/?' + _this.appConfig.action + "=";
        };
        this.getJsEntities = function () {
            return _this._jsEntities;
        };
        this.setJsEntities = function (jsEntities) {
            _this._jsEntities = jsEntities;
        };
        this.getJsEntityInstances = function () {
            return _this._jsEntityInstances;
        };
        this.setJsEntityInstances = function (jsEntityInstances) {
            _this._jsEntityInstances = jsEntityInstances;
        };
        this.getEntityExample = function (entityName) {
            return _this._jsEntityInstances[entityName];
        };
        this.getEntityMetaData = function (entityName) {
            return _this._jsEntityInstances[entityName].metaData;
        };
        this.getPropertyByEntityNameAndPropertyName = function (entityName, propertyName) {
            return _this.getEntityMetaData(entityName)[propertyName];
        };
        this.getPrimaryIDPropertyNameByEntityName = function (entityName) {
            return _this.getEntityExample(entityName).$$getIDName();
        };
        this.getEntityHasPropertyByEntityName = function (entityName, propertyName) {
            return angular.isDefined(_this.getEntityMetaData(entityName)[propertyName]);
        };
        this.getBaseEntityAliasFromName = function (entityName) {
            return '_' + entityName;
        };
        this.getPropertyIsObjectByEntityNameAndPropertyIdentifier = function (entityName, propertyIdentifier) {
            var lastEntity = _this.getLastEntityNameInPropertyIdentifier(entityName, propertyIdentifier);
            var entityMetaData = _this.getEntityMetaData(lastEntity);
            return angular.isDefined(entityMetaData[_this.utilityService.listLast(propertyIdentifier, '.')].cfc);
        };
        this.getLastEntityNameInPropertyIdentifier = function (entityName, propertyIdentifier) {
            if (!entityName) {
                throw ('No entity name was supplied to getLastEntityNameInPropertyIdentifier in hibachi service.');
            }
            //strip alias if it exists and convert everything to be periods
            if (propertyIdentifier.charAt(0) === '_') {
                propertyIdentifier = _this.utilityService.listRest(propertyIdentifier.replace(/_/g, '.'), '.');
            }
            var propertyIdentifierArray = propertyIdentifier.split('.');
            if (propertyIdentifierArray[0] === entityName.toLowerCase()) {
                propertyIdentifierArray.shift();
            }
            if (propertyIdentifierArray.length > 1) {
                var propertiesStruct = _this.getEntityMetaData(entityName);
                var currentProperty = propertyIdentifierArray.shift();
                if (!propertiesStruct[currentProperty] ||
                    !propertiesStruct[currentProperty].cfc) {
                    throw ("The Property Identifier " + propertyIdentifier + " is invalid for the entity " + entityName);
                }
                var currentEntityName = propertiesStruct[currentProperty].cfc;
                var currentPropertyIdentifier = propertyIdentifierArray.join('.');
                return _this.getLastEntityNameInPropertyIdentifier(currentEntityName, currentPropertyIdentifier);
            }
            return entityName;
        };
        this.getLastPropertyNameInPropertyIdentifier = function (propertyIdentifier) {
            var propertyIdentifierParts = propertyIdentifier.split('.');
            return propertyIdentifierParts[propertyIdentifierParts.length - 1];
        };
        //helper method to inflate a new entity with data
        this.populateEntity = function (entityName, data) {
            var newEntity = _this.newEntity(entityName);
            angular.extend(newEntity.data, data);
            return newEntity;
        };
        //service method used to transform collection data to collection objects based on a collectionconfig
        this.populateCollection = function (collectionData, collectionConfig) {
            //create array to hold objects
            var entities = [];
            //loop over all collection data to create objects
            var hibachiService = _this;
            angular.forEach(collectionData, function (collectionItemData, key) {
                //create base Entity
                var entity = hibachiService['new' + collectionConfig.baseEntityName.replace(_this.appConfig.applicationKey, '')]();
                //populate entity with data based on the collectionConfig
                angular.forEach(collectionConfig.columns, function (column, key) {
                    //get objects base properties
                    var propertyIdentifier = column.propertyIdentifier.replace(collectionConfig.baseEntityAlias.toLowerCase(), '');
                    propertyIdentifier = _this.utilityService.replaceAll(propertyIdentifier, '_', '.');
                    if (propertyIdentifier.charAt(0) === '.') {
                        propertyIdentifier = propertyIdentifier.slice(1);
                    }
                    var propertyIdentifierArray = propertyIdentifier.split('.');
                    var propertyIdentifierKey = propertyIdentifier.replace(/\./g, '_');
                    var currentEntity = entity;
                    angular.forEach(propertyIdentifierArray, function (property, key) {
                        if (key === propertyIdentifierArray.length - 1) {
                            //if we are on the last item in the array
                            if (angular.isObject(collectionItemData[propertyIdentifierKey]) && currentEntity.metaData[property].fieldtype === 'many-to-one') {
                                var relatedEntity = hibachiService['new' + currentEntity.metaData[property].cfc]();
                                relatedEntity.$$init(collectionItemData[propertyIdentifierKey][0]);
                                currentEntity['$$set' + currentEntity.metaData[property].name.charAt(0).toUpperCase() + currentEntity.metaData[property].name.slice(1)](relatedEntity);
                            }
                            else if (angular.isArray(collectionItemData[propertyIdentifierKey]) && (currentEntity.metaData[property].fieldtype === 'one-to-many')) {
                                angular.forEach(collectionItemData[propertyIdentifierKey], function (arrayItem, key) {
                                    var relatedEntity = hibachiService['new' + currentEntity.metaData[property].cfc]();
                                    relatedEntity.$$init(arrayItem);
                                    currentEntity['$$add' + currentEntity.metaData[property].singularname.charAt(0).toUpperCase() + currentEntity.metaData[property].singularname.slice(1)](relatedEntity);
                                });
                            }
                            else {
                                currentEntity.data[property] = collectionItemData[propertyIdentifierKey];
                            }
                        }
                        else {
                            var propertyMetaData = currentEntity.metaData[property];
                            if (angular.isUndefined(currentEntity.data[property])) {
                                if (propertyMetaData.fieldtype === 'one-to-many') {
                                    relatedEntity = [];
                                }
                                else {
                                    relatedEntity = hibachiService['new' + propertyMetaData.cfc]();
                                }
                            }
                            else {
                                relatedEntity = currentEntity.data[property];
                            }
                            currentEntity['$$set' + propertyMetaData.name.charAt(0).toUpperCase() + propertyMetaData.name.slice(1)](relatedEntity);
                            currentEntity = relatedEntity;
                        }
                    });
                });
                entities.push(entity);
            });
            return entities;
        };
        /*basic entity getter where id is optional, returns a promise*/
        this.getDefer = function (deferKey) {
            return _this._deferred[deferKey];
        };
        this.cancelPromise = function (deferKey) {
            var deferred = _this.getDefer(deferKey);
            if (angular.isDefined(deferred)) {
                deferred.resolve({ messages: [{ messageType: 'error', message: 'User Cancelled' }] });
            }
        };
        this.newEntity = function (entityName) {
            if (entityName != undefined) {
                var entityServiceName = entityName.charAt(0).toLowerCase() + entityName.slice(1) + 'Service';
                if (_this.$injector.has(entityServiceName)) {
                    var entityService = _this.$injector.get(entityServiceName);
                    var functionObj = entityService['new' + entityName];
                    if (entityService['new' + entityName] != undefined && !!(functionObj && functionObj.constructor && functionObj.call && functionObj.apply)) {
                        return entityService['new' + entityName]();
                    }
                }
                return new _this._jsEntities[entityName];
            }
        };
        this.getEntityDefinition = function (entityName) {
            return _this._jsEntities[entityName];
        };
        /*basic entity getter where id is optional, returns a promise*/
        this.getEntity = function (entityName, options) {
            /*
            *
            * getEntity('Product', '12345-12345-12345-12345');
            * getEntity('Product', {keywords='Hello'});
            *
            */
            var apiSubsystemName = _this.appConfig.apiSubsystemName || "api";
            if (angular.isUndefined(options)) {
                options = {};
            }
            if (angular.isDefined(options.deferKey)) {
                _this.cancelPromise(options.deferKey);
            }
            var params = {};
            if (typeof options === 'string') {
                var urlString = _this.getUrlWithActionPrefix() + apiSubsystemName + ':' + 'main.get&entityName=' + entityName + '&entityID=' + options;
            }
            else {
                params['P:Current'] = options.currentPage || 1;
                params['P:Show'] = options.pageShow || 10;
                params.keywords = options.keywords || '';
                params.columnsConfig = options.columnsConfig || '';
                params.filterGroupsConfig = options.filterGroupsConfig || '';
                params.joinsConfig = options.joinsConfig || '';
                params.orderByConfig = options.orderByConfig || '';
                params.groupBysConfig = options.groupBysConfig || '';
                params.isDistinct = options.isDistinct || false;
                params.propertyIdentifiersList = options.propertyIdentifiersList || '';
                params.allRecords = options.allRecords || false;
                params.defaultColumns = options.defaultColumns || true;
                params.processContext = options.processContext || '';
                params.isReport = options.isReport || false;
                params.periodInterval = options.periodInterval || "";
                if (angular.isDefined(options.customEndpoint) && options.customEndpoint.length) {
                    var urlString = _this.getUrlWithActionPrefix() + options.customEndpoint;
                }
                else {
                    var urlString = _this.getUrlWithActionPrefix() + apiSubsystemName + ':' + 'main.get&entityName=' + entityName;
                }
                params.enableAveragesAndSums = options.enableAveragesAndSums || false;
                if (angular.isDefined(options.listingSearchConfig)) {
                    params.listingSearchConfig = options.listingSearchConfig;
                }
            }
            if (angular.isDefined(options.id)) {
                urlString += '&entityId=' + options.id;
            }
            var transformResponse = function (data) {
                if (angular.isString(data)) {
                    data = JSON.parse(data);
                }
                return data;
            };
            //check if we are using a service to transform the response
            if (angular.isDefined(options.transformResponse)) {
                transformResponse = function (data) {
                    var data = JSON.parse(data);
                    if (angular.isDefined(data.records)) {
                        data = options.transformResponse(data.records);
                    }
                    return data;
                };
            }
            var request = _this.requestService.newAdminRequest(urlString, params);
            if (options.deferKey) {
                _this._deferred[options.deferKey] = request;
            }
            return request.promise;
        };
        this.getResizedImageByProfileName = function (profileName, skuIDs) {
            var urlString = _this.getUrlWithActionPrefix() + 'api:main.getResizedImageByProfileName&context=getResizedImageByProfileName&profileName=' + profileName + '&skuIDs=' + skuIDs;
            var request = _this.requestService.newPublicRequest(urlString);
            return request.promise;
        };
        this.getEventOptions = function (entityName) {
            var urlString = _this.getUrlWithActionPrefix() + 'api:main.getEventOptionsByEntityName&entityName=' + entityName;
            var request = _this.requestService.newAdminRequest(urlString);
            return request.promise;
        };
        this.getProcessOptions = function (entityName) {
            var urlString = _this.getUrlWithActionPrefix() + 'api:main.getProcessMethodOptionsByEntityName&entityName=' + entityName;
            var request = _this.requestService.newAdminRequest(urlString);
            return request.promise;
        };
        this.checkUniqueOrNullValue = function (object, property, value) {
            var objectName = object.metaData.className;
            var objectID = object.$$getID();
            return _this.$http.get(_this.getUrlWithActionPrefix() + 'api:main.getValidationPropertyStatus&object=' + objectName + '&objectID=' + objectID + '&propertyidentifier=' + property +
                '&value=' + escape(value)).then(function (results) {
                return results.data.uniqueStatus;
            });
        };
        this.checkUniqueValue = function (object, property, value) {
            var objectName = object.metaData.className;
            var objectID = object.$$getID();
            return _this.$http.get(_this.getUrlWithActionPrefix() + 'api:main.getValidationPropertyStatus&object=' + objectName + '&objectID=' + objectID + '&propertyidentifier=' + property +
                '&value=' + escape(value)).then(function (results) {
                return results.data.uniqueStatus;
            });
        };
        this.getPropertyDisplayData = function (entityName, options) {
            var urlString = _this.getUrlWithActionPrefix() + 'api:main.getPropertyDisplayData&entityName=' + entityName;
            var params = {};
            params.propertyIdentifiersList = options.propertyIdentifiersList || '';
            var request = _this.requestService.newAdminRequest(urlString, params);
            return request.promise;
        };
        this.getPropertyDisplayOptions = function (entityName, options) {
            var urlString = _this.getUrlWithActionPrefix() + 'api:main.getPropertyDisplayOptions&entityName=' + entityName;
            var params = {};
            params.property = options.property || options.propertyIdentifier || '';
            params.entityID = options.entityID || '';
            if (angular.isDefined(options.argument1)) {
                params.argument1 = options.argument1;
            }
            var request = _this.requestService.newAdminRequest(urlString, params);
            return request.promise;
        };
        this.convertAliasToPropertyIdentifier = function (entityName, entityAlias, propertyIdentifierWithAlias) {
            //handle legacy alias that is in Account.firstName format instead of _account.firstName
            var slicedvalue = propertyIdentifierWithAlias.slice(0, entityAlias.length);
            if (slicedvalue == entityAlias) {
                propertyIdentifierWithAlias = propertyIdentifierWithAlias.slice(entityAlias.length);
                propertyIdentifierWithAlias = propertyIdentifierWithAlias.split('_').join('.');
                if (propertyIdentifierWithAlias.charAt(0) === '.') {
                    propertyIdentifierWithAlias = propertyIdentifierWithAlias.slice(1);
                }
            }
            return propertyIdentifierWithAlias;
        };
        this.hasToManyByEntityNameAndPropertyIdentifier = function (entityName, entityAlias, propertyIdentifier) {
            if (!propertyIdentifier) {
                return false;
            }
            if (entityAlias) {
                if (propertyIdentifier) {
                    propertyIdentifier = _this.convertAliasToPropertyIdentifier(entityName, entityAlias, propertyIdentifier);
                }
            }
            var propertyIdentifierArray = propertyIdentifier.split('.');
            if (propertyIdentifierArray.length >= 1) {
                var propertiesStruct = _this.getEntityMetaData(entityName);
                var currentProperty = propertyIdentifierArray.shift();
                if (propertiesStruct[currentProperty].fieldtype
                    && (propertiesStruct[currentProperty].fieldtype == 'one-to-many'
                        || propertiesStruct[currentProperty].fieldtype == 'many-to-many')) {
                    return true;
                }
                if (!propertiesStruct[currentProperty]) {
                    throw ("The Property Identifier " + propertyIdentifier + " is invalid for the entity " + entityName);
                }
                if (propertiesStruct[currentProperty].cfc) {
                    var currentEntityName = propertiesStruct[currentProperty].cfc;
                    var currentPropertyIdentifier = propertyIdentifierArray.join('.');
                    return _this.hasToManyByEntityNameAndPropertyIdentifier(currentEntityName, undefined, currentPropertyIdentifier);
                }
            }
            return false;
        };
        this.getPropertyTitle = function (propertyName, metaData) {
            var propertyMetaData = metaData[propertyName];
            if (angular.isDefined(propertyMetaData['hb_rbkey'])) {
                return metaData.$$getRBKey(propertyMetaData['hb_rbkey']);
            }
            else if (angular.isUndefined(propertyMetaData['persistent'])) {
                if (angular.isDefined(propertyMetaData['fieldtype'])
                    && angular.isDefined(propertyMetaData['cfc'])
                    && ["one-to-many", "many-to-many"].indexOf(propertyMetaData.fieldtype) > -1) {
                    return metaData.$$getRBKey("entity." + metaData.className.toLowerCase() + "." + propertyName + ',entity.' + propertyMetaData.cfc + '_plural');
                }
                else if (angular.isDefined(propertyMetaData.fieldtype)
                    && angular.isDefined(propertyMetaData.cfc)
                    && ["many-to-one"].indexOf(propertyMetaData.fieldtype) > -1) {
                    return metaData.$$getRBKey("entity." + metaData.className.toLowerCase() + '.' + propertyName.toLowerCase() + ',entity.' + propertyMetaData.cfc);
                }
                return metaData.$$getRBKey('entity.' + metaData.className.toLowerCase() + '.' + propertyName.toLowerCase());
            }
            else if (metaData.isProcessObject) {
                if (angular.isDefined(propertyMetaData.fieldtype)
                    && angular.isDefined(propertyMetaData.cfc)
                    && ["one-to-many", "many-to-many"].indexOf(propertyMetaData.fieldtype) > -1) {
                    return metaData.$$getRBKey('processObject.' + metaData.className.toLowerCase() + '.' + propertyName.toLowerCase() + ',entity.' + propertyMetaData.cfc.toLowerCase() + '_plural');
                }
                else if (angular.isDefined(propertyMetaData.fieldtype)
                    && angular.isDefined(propertyMetaData.cfc)) {
                    return metaData.$$getRBKey('processObject.' + metaData.className.toLowerCase() + '.' + propertyName.toLowerCase() + ',entity.' + propertyMetaData.cfc.toLowerCase());
                }
                return metaData.$$getRBKey('processObject.' + metaData.className.toLowerCase() + '.' + propertyName.toLowerCase());
            }
            return metaData.$$getRBKey('object.' + metaData.className.toLowerCase() + '.' + propertyName.toLowerCase());
        };
        //this cannot live in rbkeyService because it creates a circular dependency
        this.getRBKeyFromPropertyIdentifier = function (baseEntityName, propertyIdentifier) {
            //strip alias if it exists and convert everything to be periods
            if (propertyIdentifier.charAt(0) === '_') {
                propertyIdentifier = _this.utilityService.listRest(propertyIdentifier.replace(/_/g, '.'), '.');
            }
            //if we're dealing with collection response property identfier sku_skuCode
            if (propertyIdentifier.split('_').length > 0) {
                propertyIdentifier = propertyIdentifier.replace('_', '.');
            }
            var lastEntityName = _this.getLastEntityNameInPropertyIdentifier(baseEntityName, propertyIdentifier);
            var lastProperty = _this.getLastPropertyNameInPropertyIdentifier(propertyIdentifier);
            return 'entity.' + lastEntityName + '.' + lastProperty;
        };
        this.saveEntity = function (entityName, id, params, context) {
            var urlString = _this.getUrlWithActionPrefix() + 'api:main.post';
            if (angular.isDefined(entityName)) {
                params.entityName = entityName;
            }
            if (angular.isDefined(id)) {
                params.entityID = id;
            }
            if (angular.isDefined(context)) {
                params.context = context;
            }
            var request = _this.requestService.newAdminRequest(urlString, params);
            return request.promise;
        };
        this.savePersonalCollection = function (params) {
            var urlString = _this.getUrlWithActionPrefix() + 'api:main.savePersonalCollection';
            var request = _this.requestService.newAdminRequest(urlString, params);
            return request.promise;
        };
        this.getExistingCollectionsByBaseEntity = function (entityName) {
            var urlString = _this.getUrlWithActionPrefix() + 'api:main.getExistingCollectionsByBaseEntity&entityName=' + entityName;
            var request = _this.requestService.newAdminRequest(urlString);
            return request.promise;
        };
        this.getFilterPropertiesByBaseEntityName = function (entityName, includeNonPersistent) {
            if (includeNonPersistent === void 0) { includeNonPersistent = false; }
            var urlString = _this.getUrlWithActionPrefix() + 'api:main.getFilterPropertiesByBaseEntityName&EntityName=' + entityName + '&includeNonPersistent=' + includeNonPersistent;
            var request = _this.requestService.newAdminRequest(urlString);
            return request.promise;
        };
        this.login = function (emailAddress, password) {
            var urlString = _this.appConfig.baseURL + '/index.cfm/api/auth/login';
            var params = {
                emailAddress: emailAddress,
                password: password
            };
            var request = _this.requestService.newAdminRequest(urlString, params);
            return request.promise;
        };
        this.getResourceBundle = function (locale) {
            var locale = locale || _this.appConfig.rbLocale;
            if (_this._resourceBundle[locale]) {
                return _this._resourceBundle[locale];
            }
            var urlString = _this.getUrlWithActionPrefix() + 'api:main.getResourceBundle&instantiationKey=' + _this.appConfig.instantiationKey + '&locale=' + locale;
            var request = _this.requestService.newAdminRequest(urlString, null, 'GET');
            return request.promise;
        };
        this.getCurrencies = function () {
            if (_this.appConfig.currencies) {
                var deferredCurrency = _this.$q.defer();
                deferredCurrency.resolve({ 'data': _this.appConfig.currencies });
                return deferredCurrency.promise;
            }
            var urlString = _this.getUrlWithActionPrefix() + 'api:main.getCurrencies';
            urlString += '&instantiationKey=' + _this.appConfig.instantiationKey;
            var request = _this.requestService.newAdminRequest(urlString, null, 'GET');
            return request.promise;
        };
        this.getConfig = function () {
            return _this._config;
        };
        this.getConfigValue = function (key) {
            return _this._config[key];
        };
        this.setConfigValue = function (key, value) {
            _this._config[key] = value;
        };
        this.setConfig = function (config) {
            _this._config = config;
        };
        this.$injector = $injector;
        this.$window = $window;
        this.$q = $q;
        this.$http = $http;
        this.$timeout = $timeout;
        this.$log = $log;
        this.$rootScope = $rootScope;
        this.$location = $location;
        this.$anchorScroll = $anchorScroll;
        this.requestService = requestService;
        this.utilityService = utilityService;
        this.formService = formService;
        this.rbkeyService = rbkeyService;
        this.appConfig = appConfig;
        this._config = _config;
        this._jsEntities = _jsEntities;
        this._jsEntityInstances = _jsEntityInstances;
    }
    return HibachiService;
}());
exports.HibachiService = HibachiService;
var $Hibachi = /** @class */ (function () {
    //@ngInject
    $Hibachi.$inject = ["appConfig"];
    function $Hibachi(appConfig) {
        var _this = this;
        this._config = {};
        this.angular = angular;
        this.setJsEntities = function (jsEntities) {
            _this._jsEntities = jsEntities;
        };
        this.getConfig = function () {
            return _this._config;
        };
        this.getConfigValue = function (key) {
            return _this._config[key];
        };
        this.setConfigValue = function (key, value) {
            _this._config[key] = value;
        };
        this.setConfig = function (config) {
            _this._config = config;
        };
        this._config = appConfig;
        this.$get.$inject = [
            '$window',
            '$q',
            '$http',
            '$timeout',
            '$log',
            '$rootScope',
            '$location',
            '$anchorScroll',
            '$injector',
            'requestService',
            'utilityService',
            'formService',
            'rbkeyService',
            'appConfig'
        ];
    }
    $Hibachi.prototype.$get = function ($window, $q, $http, $timeout, $log, $rootScope, $location, $anchorScroll, $injector, requestService, utilityService, formService, rbkeyService, appConfig) {
        return new HibachiService($window, $q, $http, $timeout, $log, $rootScope, $location, $anchorScroll, $injector, requestService, utilityService, formService, rbkeyService, appConfig, this._config, this._jsEntities, this._jsEntityInstances);
    };
    return $Hibachi;
}());
exports.$Hibachi = $Hibachi;


/***/ }),

/***/ "KNfs":
/***/ (function(module, exports) {

module.exports = "<input ng-attr-name=\"{{swTypeaheadMultiselect.selectionFieldName}}\" type=\"hidden\" ng-value=\"swTypeaheadMultiselect.selectionList\" /> \n<div sw-typeahead-search \n        data-placeholder-rb-key=\"{{swTypeaheadMultiselect.placeholderRbKey}}\"\n        data-add-function=\"swTypeaheadMultiselect.addSelection\"\n        data-remove-function=\"swTypeaheadMultiselect.removeSelection\"\n        data-view-function=\"swTypeaheadMultiselect.viewFunction\"\n        data-add-button-function=\"swTypeaheadMultiselect.addButtonFunction\"\n        data-show-add-button=\"swTypeaheadMultiselect.hasAddButtonFunction\"\n        data-show-view-button=\"swTypeaheadMultiselect.hasViewFunction\"\n        data-validate-required=\"false\"\n        data-collection-config=\"swTypeaheadMultiselect.collectionConfig\"\n        data-multiselect-mode=\"swTypeaheadMultiselect.multiselectMode\"\n        data-typeahead-data-key=\"{{swTypeaheadMultiselect.typeaheadDataKey}}\"\n        data-property-to-compare=\"{{swTypeaheadMultiselect.propertyToCompare}}\"\n        data-fallback-properties-to-compare=\"{{swTypeaheadMultiselect.fallbackPropertiesToCompare}}\"\n        data-right-content-property-identifier=\"{{swTypeaheadMultiselect.rightContentPropertyIdentifier}}\"\n        data-disabled=\"swTypeaheadMultiselect.disabled\"\n        >\n        <ng-transclude></ng-transclude>\n</div>\n<div class=\"s-selected-list\" ng-show=\"swTypeaheadMultiselect.showSelections\">\n    <!-- Populated by directives link function -->\n</div>";

/***/ }),

/***/ "Kpoy":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../typings/tsd.d.ts' />
var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.Account = void 0;
var baseentity_1 = __webpack_require__("L67B");
var Account = /** @class */ (function (_super) {
    __extends(Account, _super);
    function Account($injector) {
        var _this = _super.call(this, $injector) || this;
        _this.giftCards = [];
        _this.userIsLoggedIn = function () {
            if (_this.accountID !== '') {
                return true;
            }
            return false;
        };
        return _this;
    }
    return Account;
}(baseentity_1.BaseEntity));
exports.Account = Account;


/***/ }),

/***/ "KswB":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWFSaveNotes = exports.SWFSaveNotesController = void 0;
var SWFSaveNotesController = /** @class */ (function () {
    //@ngInject
    SWFSaveNotesController.$inject = ["$rootScope"];
    function SWFSaveNotesController($rootScope) {
        var _this = this;
        this.save = function () {
            _this.swfForm.submitForm().then(function (result) {
                if (result.successfulActions && result.successfulActions.length) {
                    _this.swfNavigation.showTab('review');
                }
            });
        };
    }
    return SWFSaveNotesController;
}());
exports.SWFSaveNotesController = SWFSaveNotesController;
var SWFSaveNotes = /** @class */ (function () {
    //@ngInject
    SWFSaveNotes.$inject = ["$rootScope"];
    function SWFSaveNotes($rootScope) {
        return {
            controller: SWFSaveNotesController,
            controllerAs: "swfSaveNotes",
            bindToController: {},
            restrict: "A",
            require: {
                swfNavigation: '^swfNavigation',
                swfForm: '^swfForm'
            },
            link: function () {
            }
        };
    }
    SWFSaveNotes.Factory = function () {
        var directive = function ($rootScope) { return new SWFSaveNotes($rootScope); };
        directive.$inject = ['$rootScope'];
        return directive;
    };
    return SWFSaveNotes;
}());
exports.SWFSaveNotes = SWFSaveNotes;


/***/ }),

/***/ "L5wE":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.FormService = void 0;
var Form = /** @class */ (function () {
    //@ngInject
    Form.$inject = ["name", "object", "editing"];
    function Form(name, object, editing) {
        this.$addControl = function (control) { };
        this.$removeControl = function (control) { };
        this.$setValidity = function (validationErrorKey, isValid, control) { };
        this.$setDirty = function () { };
        this.$setPristine = function () { };
        this.$commitViewValue = function () { };
        this.$rollbackViewValue = function () { };
        this.$setSubmitted = function () { };
        this.$setUntouched = function () { };
        this.name = name;
        this.object = object;
        this.editing = editing;
    }
    return Form;
}());
var FormService = /** @class */ (function () {
    function FormService($log) {
        var _this = this;
        this.$log = $log;
        this.setPristinePropertyValue = function (property, value) {
            _this._pristinePropertyValue[property] = value;
        };
        this.getPristinePropertyValue = function (property) {
            return _this._pristinePropertyValue[property];
        };
        this.setForm = function (form) {
            _this._forms[form.name] = form;
        };
        this.getForm = function (formName) {
            return _this._forms[formName];
        };
        this.getForms = function () {
            return _this._forms;
        };
        this.getFormsByObjectName = function (objectName) {
            var forms = [];
            for (var f in _this._forms) {
                if (angular.isDefined(_this._forms[f].$$swFormInfo.object) && _this._forms[f].$$swFormInfo.object.metaData.className === objectName) {
                    forms.push(_this._forms[f]);
                }
            }
            return forms;
        };
        this.createForm = function (name, object, editing) {
            var _form = new Form(name, object, editing);
            _this.setForm(_form);
            return _form;
        };
        this.resetForm = function (form) {
            _this.$log.debug('resetting form');
            _this.$log.debug(form);
            for (var key in form) {
                if (angular.isDefined(form[key])
                    && typeof form[key].$setViewValue == 'function'
                    && angular.isDefined(form[key].$viewValue)) {
                    _this.$log.debug(form[key]);
                    if (angular.isDefined(_this.getPristinePropertyValue(key))) {
                        form[key].$setViewValue(_this.getPristinePropertyValue(key));
                    }
                    else {
                        form[key].$setViewValue('');
                    }
                    form[key].$setUntouched(true);
                    form[key].$render();
                    _this.$log.debug(form[key]);
                }
            }
            form.$submitted = false;
            form.$setPristine();
            form.$setUntouched();
        };
        this.$log = $log;
        this._forms = {};
        this._pristinePropertyValue = {};
    }
    FormService.$inject = ['$log'];
    return FormService;
}());
exports.FormService = FormService;


/***/ }),

/***/ "L67B":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../typings/tsd.d.ts' />
var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.BaseEntity = void 0;
var basetransient_1 = __webpack_require__("zLAs");
var BaseEntity = /** @class */ (function (_super) {
    __extends(BaseEntity, _super);
    function BaseEntity($injector) {
        return _super.call(this, $injector) || this;
    }
    return BaseEntity;
}(basetransient_1.BaseTransient));
exports.BaseEntity = BaseEntity;


/***/ }),

/***/ "L9gJ":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWValidationMaxValue = void 0;
var SWValidationMaxValue = /** @class */ (function () {
    function SWValidationMaxValue(validationService) {
        return {
            restrict: "A",
            require: "^ngModel",
            link: function (scope, element, attributes, ngModel) {
                ngModel.$validators.swvalidationmaxvalue =
                    function (modelValue, viewValue) {
                        if (viewValue == null) {
                            return true;
                        }
                        validationService.validateMaxValue(viewValue, attributes.swvalidationmaxvalue);
                    };
            }
        };
    }
    SWValidationMaxValue.Factory = function () {
        var directive = function (validationService) { return new SWValidationMaxValue(validationService); };
        directive.$inject = ['validationService'];
        return directive;
    };
    return SWValidationMaxValue;
}());
exports.SWValidationMaxValue = SWValidationMaxValue;


/***/ }),

/***/ "LX6P":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.hibachimodule = void 0;
/// <reference path='../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
var alert_module_1 = __webpack_require__("YsSz");
var dialog_module_1 = __webpack_require__("slRK");
var entity_module_1 = __webpack_require__("bAfl");
var pagination_module_1 = __webpack_require__("vqva");
var form_module_1 = __webpack_require__("OMJB");
var validation_module_1 = __webpack_require__("RaZC");
//directives
var swsaveandfinish_1 = __webpack_require__("1aRF");
var hibachimodule = angular.module('hibachi', [
    alert_module_1.alertmodule.name,
    entity_module_1.entitymodule.name,
    dialog_module_1.dialogmodule.name,
    pagination_module_1.paginationmodule.name,
    form_module_1.formmodule.name,
    validation_module_1.validationmodule.name,
])
    .run(['$rootScope', 'publicService', '$hibachi', 'localStorageService', 'isAdmin', function ($rootScope, publicService, $hibachi, localStorageService, isAdmin) {
        $rootScope.hibachiScope = publicService;
        $rootScope.hasAccount = publicService.hasAccount;
        if (localStorageService.hasItem('selectedPersonalCollection')) {
            $rootScope.hibachiScope.selectedPersonalCollection = angular.fromJson(localStorageService.getItem('selectedPersonalCollection'));
        }
    }])
    .constant('hibachiPartialsPath', 'hibachi/components/')
    .directive('swSaveAndFinish', swsaveandfinish_1.SWSaveAndFinish.Factory());
exports.hibachimodule = hibachimodule;


/***/ }),

/***/ "M5tv":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.CartService = void 0;
var baseentityservice_1 = __webpack_require__("P6y0");
var CartService = /** @class */ (function (_super) {
    __extends(CartService, _super);
    //@ngInject
    //@ngInject
    CartService.$inject = ["$injector", "$hibachi", "utilityService"];
    function CartService($injector, $hibachi, utilityService) {
        var _this = _super.call(this, $injector, $hibachi, utilityService, 'Order', 'Cart') || this;
        _this.$injector = $injector;
        _this.$hibachi = $hibachi;
        _this.utilityService = utilityService;
        return _this;
    }
    return CartService;
}(baseentityservice_1.BaseEntityService));
exports.CartService = CartService;


/***/ }),

/***/ "MC8M":
/***/ (function(module, exports) {

module.exports = "<div role=\"tabpanel\" \n     class=\"tab-pane\" \n     ng-class=\"{'active':tab.active}\" \n     id=\"j-basic\" \n     ng-show=\"!swTabContent.hide\" \n     ng-if=\"swTabContent.loaded && swTabContent.active\">\n    <ng-transclude></ng-transclude>\n</div> ";

/***/ }),

/***/ "MKx1":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWActionCallerDropdown = exports.SWActionCallerDropdownController = void 0;
var SWActionCallerDropdownController = /** @class */ (function () {
    // @ngInject;
    function SWActionCallerDropdownController() {
        this.title = this.title || '';
        this.icon = this.icon || 'plus';
        this.type = this.type || 'button';
        this.dropdownClass = this.dropdownClass || '';
        this.dropdownId = this.dropdownId || '';
        this.buttonClass = this.buttonClass || 'btn-primary';
    }
    return SWActionCallerDropdownController;
}());
exports.SWActionCallerDropdownController = SWActionCallerDropdownController;
var SWActionCallerDropdown = /** @class */ (function () {
    function SWActionCallerDropdown() {
        this.restrict = 'E';
        this.scope = {};
        this.transclude = true;
        this.bindToController = {
            title: "@",
            icon: "@",
            type: "=",
            dropdownClass: "@",
            dropdownId: "@",
            buttonClass: "@"
        };
        this.controller = SWActionCallerDropdownController;
        this.controllerAs = "swActionCallerDropdown";
        this.template = __webpack_require__("XzNW");
    }
    SWActionCallerDropdown.Factory = function () {
        var _this = this;
        return /** @ngInject; */ function () { return new _this(); };
    };
    return SWActionCallerDropdown;
}());
exports.SWActionCallerDropdown = SWActionCallerDropdown;


/***/ }),

/***/ "MVzf":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWValidationRequired = void 0;
var SWValidationRequired = /** @class */ (function () {
    //@ngInject
    SWValidationRequired.$inject = ["validationService"];
    function SWValidationRequired(validationService) {
        return {
            restrict: "A",
            require: "^ngModel",
            link: function (scope, element, attributes, ngModel) {
                ngModel.$validators.swvalidationrequired =
                    function (modelValue, viewValue) {
                        var value = modelValue || viewValue;
                        if (attributes.swvalidationrequired === "true") {
                            return validationService.validateRequired(value);
                        }
                        else {
                            return true;
                        }
                    };
            }
        };
    }
    SWValidationRequired.Factory = function () {
        var directive = function (validationService) { return new SWValidationRequired(validationService); };
        directive.$inject = ['validationService'];
        return directive;
    };
    return SWValidationRequired;
}());
exports.SWValidationRequired = SWValidationRequired;


/***/ }),

/***/ "NIcB":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.frontendmodule = void 0;
/// <reference path="../../typings/tsd.d.ts" />
/// <reference path="../../typings/hibachiTypescript.d.ts" />
//modules
var hibachi_module_1 = __webpack_require__("LX6P");
//controllers
var frontend_1 = __webpack_require__("+t+j");
//directives
var swfdirective_1 = __webpack_require__("a+Nj");
var swfcartitems_1 = __webpack_require__("nF2I");
var swfpromobox_1 = __webpack_require__("kGox");
var swfnavigation_1 = __webpack_require__("nFws");
var swfaddressform_1 = __webpack_require__("TjPs");
var swfsavenotes_1 = __webpack_require__("KswB");
var swfalert_1 = __webpack_require__("w+Sp");
//need to inject the public service into the rootscope for use in the directives.
//Also, we set the initial value for account and cart.
var frontendmodule = angular.module('frontend', [hibachi_module_1.hibachimodule.name])
    .config(['hibachiPathBuilder', function (hibachiPathBuilder) {
        /** set the baseURL */
        hibachiPathBuilder.setBaseURL('/');
        if (hibachiConfig && hibachiConfig.basePartialsPath) {
            hibachiPathBuilder.setBasePartialsPath(hibachiConfig.basePartialsPath);
        }
        else {
            hibachiPathBuilder.setBasePartialsPath('custom/client/src/');
        }
        /** Sets the custom public integration point */
        if (hibachiConfig && hibachiConfig.apiSubsystemName) {
            hibachiPathBuilder.setApiSubsystemName(hibachiConfig.apiSubsystemName);
        }
    }])
    .run(['$rootScope', '$hibachi', 'publicService', 'hibachiPathBuilder', 'entityService', '$window', function ($rootScope, $hibachi, publicService, hibachiPathBuilder, entityService, $window) {
        $rootScope.slatwall = $rootScope.hibachiScope;
        $rootScope.slatwall.getProcessObject = entityService.newProcessObject;
        $rootScope.slatwall.getEntity = entityService.newEntity;
        $rootScope.slatwall.$hibachi.appConfig.apiSubsystemName = hibachiPathBuilder.apiSubsystemName;
        if (hibachiConfig && hibachiConfig.cmsSiteID) {
            $rootScope.slatwall.cmsSiteID = hibachiConfig.cmsSiteID;
        }
    }])
    .constant('coreFrontEndPartialsPath', 'frontend/components/')
    //controllers
    .controller('frontendController', frontend_1.FrontendController)
    //directives
    .directive('swfDirective', swfdirective_1.SWFDirective.Factory())
    .directive('swfCartItems', swfcartitems_1.SWFCartItems.Factory())
    .directive('swfPromoBox', swfpromobox_1.SWFPromoBox.Factory())
    .directive('swfNavigation', swfnavigation_1.SWFNavigation.Factory())
    .directive('swfSaveNotes', swfsavenotes_1.SWFSaveNotes.Factory())
    .directive('swfAddressForm', swfaddressform_1.SWFAddressForm.Factory())
    .directive('swfAlert', swfalert_1.SWFAlert.Factory());
exports.frontendmodule = frontendmodule;


/***/ }),

/***/ "NO/y":
/***/ (function(module, exports) {

module.exports = "<!--\n<cfif swActionCaller.modal && not swActionCaller.disabled> data-toggle=\"modal\" data-target=\"##adminModal\"</cfif>\n-->\n<!-- Link Not Modal -->\n<a  ng-if=\"swActionCaller.display && !swActionCaller.modal && swActionCaller.type === 'link' && swActionCaller.actionAuthenticated\"\n\tng-attr-title=\"{{swActionCaller.title}}\" \n\tng-attr-class=\"{{swActionCaller.class}}\" \n\ttarget=\"_self\" \n\tng-href=\"{{swActionCaller.actionUrl}}\"\n\tdata-disabled=\"{{swActionCaller.disabledtext}}\"\n\tdata-confirm=\"{{swActionCaller.confirmtext}}\"\n\thref=\"##\"\n\t>\n\t<i ng-show=\"swActionCaller.icon && swActionCaller.icon.length\" class=\"glyphicon glyphicon-{{swActionCaller.icon}}\"></i> {{swActionCaller.text}}\n</a>\n\n<!-- Link Modal -->\n<a  ng-if=\"swActionCaller.display && swActionCaller.modal && swActionCaller.type === 'link' && swActionCaller.actionAuthenticated\"\n\tng-attr-title=\"{{swActionCaller.title}}\" \n\tng-attr-class=\"{{swActionCaller.class}} modalload\" \n\ttarget=\"_self\" \n\tng-href=\"{{swActionCaller.actionUrl}}\"\n\tdata-disabled=\"{{swActionCaller.disabledtext}}\"\n\tdata-toggle=\"modal\" \n\tdata-target=\"#adminModal\"\n\tdata-confirm=\"{{swActionCaller.confirmtext}}\"\n\thref=\"##\"\n\t>\n\t<i ng-show=\"swActionCaller.icon && swActionCaller.icon.length\" class=\"glyphicon glyphicon-{{swActionCaller.icon}}\"></i> {{swActionCaller.text}}\n</a>\n\n\n<a  ng-if=\"swActionCaller.display && swActionCaller.type === 'ajaxlink' && swActionCaller.actionAuthenticated\"\n\tng-attr-title=\"{{swActionCaller.title}}\" \n\tng-attr-class=\"{{swActionCaller.class}}\" \n\tdata-disabled=\"{{swActionCaller.disabledtext}}\"\n\tdata-confirm=\"{{swActionCaller.confirmtext}}\"\n\trole=\"button\"\n\tng-click=\"swActionCaller.submit()\"\n\t>\n\t<i ng-show=\"swActionCaller.icon && swActionCaller.icon.length\" class=\"glyphicon glyphicon-{{swActionCaller.icon}}\"></i> {{swActionCaller.text}}\n</a>\n\n<!--\n\t\t<cfif swActionCaller.modal && not swActionCaller.disabled> data-toggle=\"modal\" data-target=\"##adminModal\"</cfif>\n\t\t<cfif swActionCaller.disabled> data-disabled=\"#swActionCaller.disabledtext#\"<cfelseif swActionCaller.confirm> data-confirm=\"#swActionCaller.confirmtext#\"</cfif>\n\t\t-->\n<a ng-if=\"swActionCaller.display && !swActionCaller.displayConfirm && swActionCaller.type === 'event'\"\n\tng-attr-title=\"{{swActionCaller.title}}\"\n\tng-attr-class=\"{{swActionCaller.class}}\" \n\tng-click=\"swActionCaller.emit()\"\n\t>\n\t<i ng-show=\"swActionCaller.icon && swActionCaller.icon.length\" class=\"glyphicon glyphicon-{{swActionCaller.icon}}\"></i> {{swActionCaller.text}}\n</a>\n\n<a ng-if=\"swActionCaller.display && swActionCaller.displayConfirm && swActionCaller.type === 'event'\"\n\tng-attr-title=\"{{swActionCaller.title}}\"\n\tng-attr-class=\"{{swActionCaller.class}}\" \n\tsw-confirm\n\tdata-use-rb-key=true\n\tdata-yes-text=\"define.yes\"\n\tdata-no-text=\"define.no\"\n\tdata-confirm-text=\"define.confirm\"\n\tdata-message-text=\"define.delete.message\"\n\tdata-callback=\"swActionCaller.emit()\"\n\t>\n\t<i ng-show=\"swActionCaller.icon && swActionCaller.icon.length\" class=\"glyphicon glyphicon-{{swActionCaller.icon}}\"></i> {{swActionCaller.text}}\n</a>\n\n<!-- List Not Modal -->\n\n<li ng-if=\"swActionCaller.display && !swActionCaller.modal && swActionCaller.type === 'list' && swActionCaller.actionAuthenticated\">\n\t<a ng-attr-title=\"{{swActionCaller.title}}\" \n\t\tng-attr-class=\"{{swActionCaller.class}}\" \n\t\ttarget=\"_self\" \n\t\tng-href=\"{{swActionCaller.actionUrl}}\"\n\t\t>\n\t\t<i ng-show=\"swActionCaller.icon && swActionCaller.icon.length\" class=\"glyphicon glyphicon-{{swActionCaller.icon}}\"></i> {{swActionCaller.text}}\n\t</a>\n</li>\n\n<!-- List Modal -->\n<li ng-if=\"swActionCaller.display && swActionCaller.modal && swActionCaller.type === 'list' && swActionCaller.actionAuthenticated\">\n\t<a ng-attr-title=\"{{swActionCaller.title}}\" \n\t\tng-attr-class=\"{{swActionCaller.class}} modalload\" \n\t\ttarget=\"_self\"\n\t\tdata-toggle=\"modal\" \n\t\tdata-target=\"#adminModal\"\n\t\tng-href=\"{{swActionCaller.actionUrl}}\"\n\t\t>\n\t\t<i ng-show=\"swActionCaller.icon && swActionCaller.icon.length\" class=\"glyphicon glyphicon-{{swActionCaller.icon}}\"></i> {{swActionCaller.text}}\n\t</a>\n</li>\n\n\n<!--\n\t<cfif len(swActionCaller.name)> name=\"#swActionCaller.name#\" value=\"#swActionCaller.action#\"</cfif>\n\t<cfif swActionCaller.modal && not swActionCaller.disabled> data-toggle=\"modal\" data-target=\"##adminModal\"</cfif>\n\t<cfif swActionCaller.disabled> data-disabled=\"#swActionCaller.disabledtext#\"<cfelseif swActionCaller.confirm> data-confirm=\"#swActionCaller.confirmtext#\"</cfif><cfif swActionCaller.submit>type=\"submit\"</cfif><cfif len(swActionCaller.id)>id=\"#swActionCaller.id#\"</cfif>>\n\t-->\n<button ng-if=\"swActionCaller.display && swActionCaller.type ==='button' && swActionCaller.actionAuthenticated\" \n\tng-attr-class=\"{{swActionCaller.class}}\" \n\tng-attr-title=\"{{swActionCaller.title}}\"\n\tng-click=\"swActionCaller.submit()\"\n\tng-disabled=\"swActionCaller.disabled\"\n\t><i ng-show=\"swActionCaller.icon && swActionCaller.icon.length\" class=\"glyphicon glyphicon-{{swActionCaller.icon}}\"></i><span ng-bind=\"swActionCaller.text\"></span>\n</button>\n";

/***/ }),

/***/ "NPJD":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.LocalStorageService = void 0;
var LocalStorageService = /** @class */ (function () {
    //@ngInject
    LocalStorageService.$inject = ["$window"];
    function LocalStorageService($window) {
        var _this = this;
        this.$window = $window;
        this.removeItem = function (key) {
            try {
                _this.$window.localStorage.removeItem(key);
            }
            catch (e) {
                console.error(e);
            }
        };
        this.hasItem = function (key) {
            //try catch to handle safari in private mode which does not allow localstorage
            try {
                return (_this.$window.localStorage.getItem(key)
                    && _this.$window.localStorage.getItem(key) !== null
                    && _this.$window.localStorage.getItem(key) !== "undefined");
            }
            catch (e) {
                return false;
            }
        };
        this.getItem = function (key) {
            var value = _this.$window.localStorage.getItem(key);
            if (value.charAt(0) === '{' || value.charAt(0) === '[') {
                value = angular.fromJson(value);
            }
            return value;
        };
        this.setItem = function (key, data) {
            //try catch to handle safari in private mode which does not allow localstorage
            try {
                if (angular.isObject(data) || angular.isArray(data)) {
                    data = angular.toJson(data);
                }
                _this.$window.localStorage.setItem(key, data);
            }
            catch (e) {
            }
        };
        this.$window = $window;
    }
    return LocalStorageService;
}());
exports.LocalStorageService = LocalStorageService;


/***/ }),

/***/ "NaNU":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWTypeaheadRemoveSelectionController = exports.SWTypeaheadRemoveSelection = void 0;
var SWTypeaheadRemoveSelectionController = /** @class */ (function () {
    // @ngInject;
    SWTypeaheadRemoveSelectionController.$inject = ["$scope", "listingService", "scopeService", "typeaheadService", "utilityService"];
    function SWTypeaheadRemoveSelectionController($scope, listingService, scopeService, typeaheadService, utilityService) {
        var _this = this;
        this.$scope = $scope;
        this.listingService = listingService;
        this.scopeService = scopeService;
        this.typeaheadService = typeaheadService;
        this.utilityService = utilityService;
        this.updatePageRecord = function () {
            if (_this.scopeService.hasParentScope(_this.$scope, "pageRecord")) {
                var pageRecordScope = _this.scopeService.getRootParentScope(_this.$scope, "pageRecord")["pageRecord"];
                _this.pageRecord = pageRecordScope;
            }
        };
        this.removeSelection = function () {
            if (!_this.disabled) {
                _this.typeaheadService.removeSelection(_this.typeaheadDataKey, undefined, _this.pageRecord);
                _this.listingService.removeListingPageRecord(_this.listingId, _this.pageRecord);
            }
        };
        this.listingService.attachToListingPageRecordsUpdate(this.listingId, this.updatePageRecord, this.utilityService.createID(32));
        if (angular.isUndefined(this.disabled)) {
            this.disabled = false;
        }
    }
    return SWTypeaheadRemoveSelectionController;
}());
exports.SWTypeaheadRemoveSelectionController = SWTypeaheadRemoveSelectionController;
var SWTypeaheadRemoveSelection = /** @class */ (function () {
    // @ngInject
    SWTypeaheadRemoveSelection.$inject = ["scopeService"];
    function SWTypeaheadRemoveSelection(scopeService) {
        var _this = this;
        this.scopeService = scopeService;
        this.transclude = true;
        this.restrict = "EA";
        this.scope = {};
        this.bindToController = {
            typeaheadDataKey: "@?",
            index: "@?",
            disabled: "=?"
        };
        this.controller = SWTypeaheadRemoveSelectionController;
        this.controllerAs = "swTypeaheadRemoveSelection";
        this.template = __webpack_require__("XXsx");
        this.link = function (scope, element, attrs) {
            if (_this.scopeService.hasParentScope(scope, "swListingDisplay")) {
                var listingDisplayScope = _this.scopeService.getRootParentScope(scope, "swListingDisplay")["swListingDisplay"];
                scope.swTypeaheadRemoveSelection.typeaheadDataKey = listingDisplayScope.typeaheadDataKey;
                scope.swTypeaheadRemoveSelection.listingId = listingDisplayScope.tableID;
            }
            if (_this.scopeService.hasParentScope(scope, "pageRecord")) {
                var pageRecordScope = _this.scopeService.getRootParentScope(scope, "pageRecord")["pageRecord"];
                scope.swTypeaheadRemoveSelection.pageRecord = pageRecordScope;
            }
        };
    }
    SWTypeaheadRemoveSelection.Factory = function () {
        var _this = this;
        return /** @ngInject; */ ["scopeService", function (scopeService) { return new _this(scopeService); }];
    };
    return SWTypeaheadRemoveSelection;
}());
exports.SWTypeaheadRemoveSelection = SWTypeaheadRemoveSelection;


/***/ }),

/***/ "NfT/":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWVerifyAddressDialog = void 0;
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWVerifyAddressDialogController = /** @class */ (function () {
    //@ngInject
    SWVerifyAddressDialogController.$inject = ["$timeout", "$rootScope", "$http", "$hibachi", "collectionConfigService", "observerService"];
    function SWVerifyAddressDialogController($timeout, $rootScope, $http, $hibachi, collectionConfigService, observerService) {
        var _this = this;
        this.$timeout = $timeout;
        this.$rootScope = $rootScope;
        this.$http = $http;
        this.$hibachi = $hibachi;
        this.collectionConfigService = collectionConfigService;
        this.observerService = observerService;
        //init 
        this.init = function (data) {
            _this.accountAddressID = data['accountAddressID'] || data['accountAddress.accountAddressID'];
            if (!_this.accountAddressID) {
                return;
            }
            _this.verifyAddress({ accountAddressID: _this.accountAddressID }).then(function (response) {
                if (response.verifyAddress.suggestedAddress) {
                    _this.suggestedAddress = response.verifyAddress.suggestedAddress;
                }
                else {
                    _this.suggestedAddress = null;
                }
                if (!response.verifyAddress.success) {
                    _this.showModal();
                }
            });
        };
        this.showModal = function () {
            $('#VerifyAddressDialog').modal('show');
        };
        this.selectSuggestedAddress = function () {
            return _this.$rootScope.slatwall.doAction('addEditAccountAddress', _this.suggestedAddress);
        };
        //mocking call to integration. Important to inject the data's account address iD into the response object for tracking
        this.verifyAddress = function (data) {
            return _this.$rootScope.slatwall.doAction("verifyAddress", { accountAddressID: data.accountAddressID }).then(function (response) {
                if (response.verifyAddress.suggestedAddress) {
                    response.verifyAddress.suggestedAddress['accountAddressID'] = data.accountAddressID;
                }
                return response;
            });
        };
        this.cancel = function () {
            _this.$rootScope.slatwall.deleteAccountAddress(_this.accountAddressID);
            _this.suggestedAddress = null;
            _this.accountAddressID = null;
        };
        this.observerService.attach(this.init, "shippingAddressSelected");
        this.copy = "We Could Not Verify This Address. Please Select:";
    }
    return SWVerifyAddressDialogController;
}());
var SWVerifyAddressDialog = /** @class */ (function () {
    //@ngInject
    SWVerifyAddressDialog.$inject = ["$compile", "hibachiPathBuilder"];
    function SWVerifyAddressDialog($compile, hibachiPathBuilder) {
        this.restrict = 'E';
        this.scope = {};
        this.transclude = false;
        this.bindToController = {};
        this.controller = SWVerifyAddressDialogController;
        this.controllerAs = "SWVerifyAddressDialog";
        this.templatePath = "";
        this.templateUrl = "";
        this.link = function (scope, element, attrs) {
        };
        if (!hibachiConfig) {
            hibachiConfig = {};
        }
        if (!hibachiConfig.customPartialsPath) {
            hibachiConfig.customPartialsPath = '/Slatwall/custom/client/src/form/';
        }
        this.templatePath = hibachiConfig.customPartialsPath;
        this.templateUrl = hibachiConfig.customPartialsPath + 'swverifyaddressdialog.html';
        this.$compile = $compile;
    }
    SWVerifyAddressDialog.Factory = function () {
        var directive = function (corePartialsPath, hibachiPathBuilder) { return new SWVerifyAddressDialog(corePartialsPath, hibachiPathBuilder); };
        directive.$inject = ['$compile', 'hibachiPathBuilder'];
        return directive;
    };
    return SWVerifyAddressDialog;
}());
exports.SWVerifyAddressDialog = SWVerifyAddressDialog;


/***/ }),

/***/ "O3Mr":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.HibachiValidationService = void 0;
var HibachiValidationService = /** @class */ (function () {
    //@ngInject
    HibachiValidationService.$inject = ["$log"];
    function HibachiValidationService($log) {
        var _this = this;
        this.$log = $log;
        this.getObjectSaveLevel = function (entityInstance) {
            var objectLevel = entityInstance;
            var entityID = entityInstance.$$getID();
            angular.forEach(entityInstance.parents, function (parentObject) {
                if (angular.isDefined(entityInstance.data[parentObject.name]) && entityInstance.data[parentObject.name].$$getID() === '' && (angular.isUndefined(entityID) || !entityID.trim().length)) {
                    var parentEntityInstance = entityInstance.data[parentObject.name];
                    var parentEntityID = parentEntityInstance.$$getID();
                    if (parentEntityID === '' && parentEntityInstance.forms) {
                        objectLevel = _this.getObjectSaveLevel(parentEntityInstance);
                    }
                }
            });
            return objectLevel;
        };
        this.getModifiedDataByInstance = function (entityInstance) {
            var modifiedData = {};
            var objectSaveLevel = _this.getObjectSaveLevel(entityInstance);
            _this.$log.debug('objectSaveLevel : ' + objectSaveLevel);
            var valueStruct = _this.validateObject(objectSaveLevel);
            _this.$log.debug('validateObject data');
            _this.$log.debug(valueStruct.value);
            modifiedData = {
                objectLevel: objectSaveLevel,
                value: valueStruct.value,
                valid: valueStruct.valid
            };
            return modifiedData;
        };
        this.getValidationByPropertyAndContext = function (entityInstance, property, context) {
            var validations = _this.getValidationsByProperty(entityInstance, property);
            for (var i in validations) {
                var contexts = validations[i].contexts.split(',');
                for (var j in contexts) {
                    if (contexts[j] === context) {
                        return validations[i];
                    }
                }
            }
        };
        this.getValidationsByProperty = function (entityInstance, property) {
            return entityInstance.validations.properties[property];
        };
        this.validateObject = function (entityInstance) {
            var modifiedData = {};
            var valid = true;
            var forms = entityInstance.forms;
            _this.$log.debug('process base level data');
            for (var f in forms) {
                var form = forms[f];
                form.$setSubmitted(); //Sets the form to submitted for the validation errors to pop up.
                if (form.$dirty && form.$valid) {
                    for (var key in form) {
                        _this.$log.debug('key:' + key);
                        if (key.charAt(0) !== '$' && angular.isObject(form[key])) {
                            var inputField = form[key];
                            if (typeof inputField.$modelValue != 'undefined' && inputField.$modelValue !== '') {
                                inputField.$dirty = true;
                            }
                            if (angular.isDefined(inputField.$valid) && inputField.$valid === true && (inputField.$dirty === true || (form.autoDirty && form.autoDirty == true))) {
                                if (angular.isDefined(entityInstance.metaData[key])
                                    && angular.isDefined(entityInstance.metaData[key].hb_formfieldtype)
                                    && entityInstance.metaData[key].hb_formfieldtype === 'json') {
                                    modifiedData[key] = angular.toJson(inputField.$modelValue);
                                }
                                else {
                                    modifiedData[key] = inputField.$modelValue;
                                }
                            }
                        }
                    }
                }
                else {
                    if (!form.$valid) {
                        valid = false;
                    }
                }
            }
            modifiedData[entityInstance.$$getIDName()] = entityInstance.$$getID();
            _this.$log.debug(modifiedData);
            _this.$log.debug('process parent data');
            if (angular.isDefined(entityInstance.parents)) {
                for (var p in entityInstance.parents) {
                    var parentObject = entityInstance.parents[p];
                    var parentInstance = entityInstance.data[parentObject.name];
                    if (angular.isUndefined(modifiedData[parentObject.name])) {
                        modifiedData[parentObject.name] = {};
                    }
                    var forms = parentInstance.forms;
                    for (var f in forms) {
                        var form = forms[f];
                        form.$setSubmitted();
                        if (form.$dirty && form.$valid) {
                            for (var key in form) {
                                if (key.charAt(0) !== '$' && angular.isObject(form[key])) {
                                    var inputField = form[key];
                                    if (typeof inputField.$modelValue != 'undefined' && inputField.$modelValue !== '') {
                                        inputField.$dirty = true;
                                    }
                                    if (angular.isDefined(inputField) && angular.isDefined(inputField.$valid) && inputField.$valid === true && (inputField.$dirty === true || (form.autoDirty && form.autoDirty == true))) {
                                        if (angular.isDefined(parentInstance.metaData[key])
                                            && angular.isDefined(parentInstance.metaData[key].hb_formfieldtype)
                                            && parentInstance.metaData[key].hb_formfieldtype === 'json') {
                                            modifiedData[parentObject.name][key] = angular.toJson(inputField.$modelValue);
                                        }
                                        else {
                                            modifiedData[parentObject.name][key] = inputField.$modelValue;
                                        }
                                    }
                                }
                            }
                        }
                        else {
                            if (!form.$valid) {
                                valid = false;
                            }
                        }
                    }
                    modifiedData[parentObject.name][parentInstance.$$getIDName()] = parentInstance.$$getID();
                }
            }
            _this.$log.debug(modifiedData);
            _this.$log.debug('begin child data');
            var childrenData = _this.validateChildren(entityInstance);
            _this.$log.debug('child Data');
            _this.$log.debug(childrenData);
            angular.extend(modifiedData, childrenData);
            return {
                valid: valid,
                value: modifiedData
            };
        };
        this.validateChildren = function (entityInstance) {
            var data = {};
            if (angular.isDefined(entityInstance.children) && entityInstance.children.length) {
                data = _this.getDataFromChildren(entityInstance);
            }
            return data;
        };
        this.init = function (entityInstance, data) {
            for (var key in data) {
                if (key.charAt(0) !== '$' && angular.isDefined(entityInstance.metaData[key])) {
                    var propertyMetaData = entityInstance.metaData[key];
                    if (angular.isDefined(propertyMetaData) && angular.isDefined(propertyMetaData.hb_formfieldtype) && propertyMetaData.hb_formfieldtype === 'json') {
                        if (data[key].trim() !== '') {
                            entityInstance.data[key] = angular.fromJson(data[key]);
                        }
                    }
                    else {
                        entityInstance.data[key] = data[key];
                    }
                }
            }
        };
        this.processForm = function (form, entityInstance) {
            _this.$log.debug('begin process form');
            var data = {};
            form.$setSubmitted();
            for (var key in form) {
                if (key.charAt(0) !== '$' && angular.isObject(form[key])) {
                    var inputField = form[key];
                    if (inputField.$modelValue) {
                        inputField.$dirty = true;
                    }
                    if (angular.isDefined(inputField) && angular.isDefined(inputField) && inputField.$valid === true && (inputField.$dirty === true || (form.autoDirty && form.autoDirty == true))) {
                        if (angular.isDefined(entityInstance.metaData[key]) && angular.isDefined(entityInstance.metaData[key].hb_formfieldtype) && entityInstance.metaData[key].hb_formfieldtype === 'json') {
                            data[key] = angular.toJson(inputField.$modelValue);
                        }
                        else {
                            data[key] = inputField.$modelValue;
                        }
                    }
                }
            }
            data[entityInstance.$$getIDName()] = entityInstance.$$getID();
            _this.$log.debug('process form data');
            _this.$log.debug(data);
            return data;
        };
        this.processParent = function (entityInstance) {
            var data = {};
            if (entityInstance.$$getID() !== '') {
                data[entityInstance.$$getIDName()] = entityInstance.$$getID();
            }
            _this.$log.debug('processParent');
            _this.$log.debug(entityInstance);
            var forms = entityInstance.forms;
            for (var f in forms) {
                var form = forms[f];
                data = angular.extend(data, _this.processForm(form, entityInstance));
            }
            return data;
        };
        this.processChild = function (entityInstance, entityInstanceParent) {
            var data = {};
            var forms = entityInstance.forms;
            for (var f in forms) {
                var form = forms[f];
                angular.extend(data, _this.processForm(form, entityInstance));
            }
            if (angular.isDefined(entityInstance.children) && entityInstance.children.length) {
                var childData = _this.getDataFromChildren(entityInstance);
                angular.extend(data, childData);
            }
            if (angular.isDefined(entityInstance.parents) && entityInstance.parents.length) {
                var parentData = _this.getDataFromParents(entityInstance, entityInstanceParent);
                angular.extend(data, parentData);
            }
            return data;
        };
        this.getDataFromParents = function (entityInstance, entityInstanceParent) {
            var data = {};
            for (var c in entityInstance.parents) {
                var parentMetaData = entityInstance.parents[c];
                if (angular.isDefined(parentMetaData)) {
                    var parent = entityInstance.data[parentMetaData.name];
                    if (angular.isObject(parent) && entityInstanceParent !== parent && parent.$$getID() !== '') {
                        if (angular.isUndefined(data[parentMetaData.name])) {
                            data[parentMetaData.name] = {};
                        }
                        var parentData = _this.processParent(parent);
                        _this.$log.debug('parentData:' + parentMetaData.name);
                        _this.$log.debug(parentData);
                        angular.extend(data[parentMetaData.name], parentData);
                    }
                    else {
                    }
                }
            }
            ;
            return data;
        };
        this.getDataFromChildren = function (entityInstance) {
            var data = {};
            _this.$log.debug('childrenFound');
            _this.$log.debug(entityInstance.children);
            for (var c in entityInstance.children) {
                var childMetaData = entityInstance.children[c];
                var children = entityInstance.data[childMetaData.name];
                _this.$log.debug(childMetaData);
                _this.$log.debug(children);
                if (angular.isArray(entityInstance.data[childMetaData.name])) {
                    if (angular.isUndefined(data[childMetaData.name])) {
                        data[childMetaData.name] = [];
                    }
                    angular.forEach(entityInstance.data[childMetaData.name], function (child, key) {
                        _this.$log.debug('process child array item');
                        var childData = _this.processChild(child, entityInstance);
                        _this.$log.debug('process child return');
                        _this.$log.debug(childData);
                        data[childMetaData.name].push(childData);
                    });
                }
                else {
                    if (angular.isUndefined(data[childMetaData.name])) {
                        data[childMetaData.name] = {};
                    }
                    var child = entityInstance.data[childMetaData.name];
                    _this.$log.debug('begin process child');
                    var childData = _this.processChild(child, entityInstance);
                    _this.$log.debug('process child return');
                    _this.$log.debug(childData);
                    angular.extend(data, childData);
                }
            }
            _this.$log.debug('returning child data');
            _this.$log.debug(data);
            return data;
        };
        this.$log = $log;
    }
    return HibachiValidationService;
}());
exports.HibachiValidationService = HibachiValidationService;


/***/ }),

/***/ "OMJB":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.formmodule = void 0;
//module
var core_module_1 = __webpack_require__("pwA0");
//services
var fileservice_1 = __webpack_require__("ts6z");
//directives
//  components
//form
var swinput_1 = __webpack_require__("pGfp");
var swfformfield_1 = __webpack_require__("774h");
var swform_1 = __webpack_require__("JytI");
var swfform_1 = __webpack_require__("W1Ga");
var swfselect_1 = __webpack_require__("K5TR");
var swffileinput_1 = __webpack_require__("Oq9p");
var swformfield_1 = __webpack_require__("GEAz");
var swformfieldfile_1 = __webpack_require__("DyyJ");
var swformfieldjson_1 = __webpack_require__("9zUE");
var swformfieldsearchselect_1 = __webpack_require__("np4f");
var swformregistrar_1 = __webpack_require__("GdTe");
var swerrordisplay_1 = __webpack_require__("qOTf");
var swaddressform_1 = __webpack_require__("YkJ8");
var swisolatechildform_1 = __webpack_require__("jZyc");
var swpropertydisplay_1 = __webpack_require__("Y7Lf");
var swfpropertydisplay_1 = __webpack_require__("dIWv");
var swsimplepropertydisplay_1 = __webpack_require__("U1QT");
var swformsubscriber_1 = __webpack_require__("rHbG");
var swverifyaddressdialog_1 = __webpack_require__("NfT/");
var swcollectionconfigasproperty_1 = __webpack_require__("bAFN");
var formmodule = angular.module('hibachi.form', ['angularjs-datetime-picker', core_module_1.coremodule.name]).config(function () {
})
    .constant('coreFormPartialsPath', 'form/components/')
    .service('fileService', fileservice_1.FileService)
    //directives
    .directive('swInput', swinput_1.SWInput.Factory())
    .directive('swfFormField', swfformfield_1.SWFFormField.Factory())
    .directive('swForm', swform_1.SWForm.Factory())
    .directive('swfForm', swfform_1.SWFForm.Factory())
    .directive('swfSelect', swfselect_1.SWFSelect.Factory())
    .directive('swfFileInput', swffileinput_1.SWFFileInput.Factory())
    .directive('swFormField', swformfield_1.SWFormField.Factory())
    .directive('swFormFieldFile', swformfieldfile_1.SWFormFieldFile.Factory())
    .directive('swFormFieldJson', swformfieldjson_1.SWFormFieldJson.Factory())
    .directive('swFormFieldSearchSelect', swformfieldsearchselect_1.SWFormFieldSearchSelect.Factory())
    .directive('swFormRegistrar', swformregistrar_1.SWFormRegistrar.Factory())
    .directive('swfPropertyDisplay', swfpropertydisplay_1.SWFPropertyDisplay.Factory(swfpropertydisplay_1.SWFPropertyDisplay, "swfpropertydisplay.html"))
    .directive('swPropertyDisplay', swpropertydisplay_1.SWPropertyDisplay.Factory(swpropertydisplay_1.SWPropertyDisplay, "propertydisplay.html"))
    .directive('swSimplePropertyDisplay', swsimplepropertydisplay_1.SWSimplePropertyDisplay.Factory(swsimplepropertydisplay_1.SWSimplePropertyDisplay, "simplepropertydisplay.html"))
    .directive('swErrorDisplay', swerrordisplay_1.SWErrorDisplay.Factory())
    .directive('swIsolateChildForm', swisolatechildform_1.SWIsolateChildForm.Factory())
    .directive('swAddressForm', swaddressform_1.SWAddressForm.Factory())
    .directive('swCollectionConfigAsProperty', swcollectionconfigasproperty_1.SWCollectionConfigAsProperty.Factory())
    .directive('swVerifyAddressDialog', swverifyaddressdialog_1.SWVerifyAddressDialog.Factory())
    .directive('swFormSubscriber', swformsubscriber_1.SWFormSubscriber.Factory());
exports.formmodule = formmodule;


/***/ }),

/***/ "OUJS":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.AlertController = void 0;
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var AlertController = /** @class */ (function () {
    //@ngInject
    AlertController.$inject = ["$scope", "alertService"];
    function AlertController($scope, alertService) {
        $scope.$id = "alertController";
        $scope.alerts = alertService.getAlerts();
    }
    return AlertController;
}());
exports.AlertController = AlertController;


/***/ }),

/***/ "Oq9p":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWFFileInput = void 0;
var SWFFileInput = /** @class */ (function () {
    // @ngInject
    SWFFileInput.$inject = ["$parse"];
    function SWFFileInput($parse) {
        var _this = this;
        this.$parse = $parse;
        this.restrict = 'A';
        // @ngInject
        this.link = function (scope, element, attrs) {
            var model = _this.$parse(attrs.fileModel);
            element.bind('change', function () {
                scope.$apply(function () {
                    var firstElement = element[0];
                    if (firstElement.files != undefined) {
                        model.assign(scope, firstElement.files[0]);
                    }
                });
            });
        };
        this.link.$inject = ["scope", "element", "attrs"];
    }
    SWFFileInput.Factory = function () {
        var directive = function ($parse) { return new SWFFileInput($parse); };
        directive.$inject = [
            '$parse'
        ];
        return directive;
    };
    return SWFFileInput;
}());
exports.SWFFileInput = SWFFileInput;


/***/ }),

/***/ "P6y0":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.BaseEntityService = void 0;
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var baseobject_1 = __webpack_require__("nXj+");
var Entities = __webpack_require__("BFGO");
var Processes = __webpack_require__("DxQu");
var BaseEntityService = /** @class */ (function (_super) {
    __extends(BaseEntityService, _super);
    //@ngInject
    BaseEntityService.$inject = ["$injector", "$hibachi", "utilityService", "baseObjectName", "objectName"];
    function BaseEntityService($injector, $hibachi, utilityService, baseObjectName, objectName) {
        var _this = _super.call(this, $injector) || this;
        _this.$injector = $injector;
        _this.$hibachi = $hibachi;
        _this.utilityService = utilityService;
        _this.baseObjectName = baseObjectName;
        _this.objectName = objectName;
        _this.newEntity = function (baseObjectName, objectName) {
            if (!objectName) {
                objectName = baseObjectName;
            }
            return _this.newObject('Entity', baseObjectName, objectName);
        };
        _this.newProcessObject = function (baseObjectName, objectName) {
            if (!objectName) {
                objectName = baseObjectName;
            }
            return _this.newObject('Process', baseObjectName, objectName);
        };
        _this.newObject = function (type, baseObjectName, objectName) {
            if (!objectName) {
                objectName = baseObjectName;
            }
            var baseObject = _this.$hibachi.getEntityDefinition(baseObjectName);
            if (baseObject) {
                var Barrell = {};
                if (type === 'Entity') {
                    Barrell = Entities;
                }
                else if (type === 'Process') {
                    Barrell = Processes;
                }
                if (Barrell[objectName.toLowerCase()]) {
                    _this.utilityService.extend(Barrell[objectName.toLowerCase()], baseObject);
                    var entity = new Barrell[objectName.toLowerCase()](_this.$injector);
                }
                else {
                    var entity = new baseObject();
                    //throw('need to add '+ objectName+' class');
                }
                return entity;
            }
            else {
                return {};
            }
        };
        _this.utilityService = utilityService;
        _this.$hibachi = $hibachi;
        _this.$injector = $injector;
        //make case insensitive
        for (var key in Entities) {
            Entities[key.toLowerCase()] = Entities[key];
        }
        if (!_this.objectName) {
            _this.objectName = _this.baseObjectName;
        }
        _this['new' + _this.objectName] = function () {
            return _this.newEntity(_this.baseObjectName, _this.objectName);
        };
        return _this;
    }
    return BaseEntityService;
}(baseobject_1.BaseObject));
exports.BaseEntityService = BaseEntityService;


/***/ }),

/***/ "PBJm":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWCurrency = void 0;
var SWCurrency = /** @class */ (function () {
    function SWCurrency() {
    }
    //@ngInject
    SWCurrency.Factory = function ($sce, $log, $hibachi, $filter) {
        var data = null, serviceInvoked = false, locale = 'en-us';
        function realFilter(value, currencyCode, decimalPlace, returnStringFlag, localeOverride) {
            if (decimalPlace === void 0) { decimalPlace = 2; }
            if (returnStringFlag === void 0) { returnStringFlag = true; }
            var useLocale = locale;
            if (localeOverride) {
                useLocale = localeOverride;
            }
            if (isNaN(parseFloat(value))) {
                return returnStringFlag ? "--" : undefined;
            }
            if (typeof value == 'string') {
                //if the value is a string remove any commas and spaces
                value = value.replace(/[, ]+/g, "").trim();
            }
            try {
                var newValue = parseFloat(value).toLocaleString(useLocale, { minimumFractionDigits: 2, maximumFractionDigits: 2 });
                value = newValue;
            }
            catch (e) {
            }
            if (returnStringFlag) {
                var currencySymbol = "$";
                if (data != null && data[currencyCode] != null) {
                    currencySymbol = data[currencyCode].currencySymbol;
                }
                else {
                    $log.debug("Please provide a valid currencyCode, swcurrency defaults to $");
                }
                if (data != null && data[currencyCode] != null && data[currencyCode].formatMask != null && data[currencyCode].formatMask.trim().length) {
                    var formatMask = data[currencyCode].formatMask;
                    return formatMask.replace('$', currencySymbol).replace(/ /g, '\u00a0').replace('{9}', value);
                }
                else {
                    return currencySymbol + value;
                }
            }
            //if they don't want a string returned, again make sure any commas and spaces are removed
            if (typeof value == 'string') {
                value = value.replace(/[, ]+/g, "").trim();
            }
            return value;
        }
        var filterStub = function (value, currencyCode, decimalPlace, returnStringFlag, localeOverride) {
            if (returnStringFlag === void 0) { returnStringFlag = true; }
            if (data == null && returnStringFlag) {
                if (!serviceInvoked) {
                    serviceInvoked = true;
                    $hibachi.getCurrencies().then(function (currencies) {
                        data = currencies.data;
                        locale = $hibachi.getConfig().rbLocale.replace('_', '-');
                    });
                }
                return "--" + value;
            }
            else {
                return realFilter(value, currencyCode, decimalPlace, returnStringFlag, localeOverride);
            }
        };
        filterStub.$stateful = true;
        return filterStub;
    };
    SWCurrency.Factory.$inject = ["$sce", "$log", "$hibachi", "$filter"];
    return SWCurrency;
}());
exports.SWCurrency = SWCurrency;


/***/ }),

/***/ "POsI":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWValidationEq = void 0;
var SWValidationEq = /** @class */ (function () {
    //@ngInject
    SWValidationEq.$inject = ["validationService"];
    function SWValidationEq(validationService) {
        return {
            restrict: "A",
            require: "^ngModel",
            link: function (scope, element, attributes, ngModel) {
                ngModel.$validators.swvalidationeq =
                    function (modelValue, viewValue) {
                        return validationService.validateEq(modelValue, attributes.swvalidationeq);
                    }; //<--end function
            } //<--end link
        };
    }
    SWValidationEq.Factory = function () {
        var directive = function (validationService) { return new SWValidationEq(validationService); };
        directive.$inject = [
            'validationService'
        ];
        return directive;
    };
    return SWValidationEq;
}());
exports.SWValidationEq = SWValidationEq;


/***/ }),

/***/ "QJ37":
/***/ (function(module, exports) {

module.exports = "<!-- Change Image Modal -->\n<div class=\"modal\" id=\"{{swModalWindow.modalName}}\" tabindex=\"-1\" role=\"dialog\" aria-hidden=\"false\">\n    <div class=\"modal-dialog modal-lg\">\n        <div class=\"modal-content\">\n            <div class=\"modal-header\">\n                <a ng-if=\"swModalWindow.showExit\" class=\"close\" data-dismiss=\"modal\">×</a>\n                <!-- HEADER TITLE HERE -->\n                <h3><span ng-bind=\"swModalWindow.title\"></span></h3>\n            </div>\n            <div class=\"modal-body\">\n                    <!-- Transcluded Content Here -->\n                    <div ng-transclude=\"modalBody\"></div>\n            </div>\n            <div class=\"modal-footer\">\n                <a href=\"#\" \n                   ng-if=\"swModalWindow.hasCancelAction\"\n                   class=\"btn btn-default s-remove\"\n                   data-dismiss=\"modal\" \n                   ng-click=\"swModalWindow.cancelAction()()\">\n                   <span class=\"glyphicon glyphicon-remove icon-white\"></span> \n                   <span ng-bind=\"swModalWindow.cancelActionText\"></span>\n                </a>\n                <button ng-if=\"swModalWindow.hasSaveAction\"\n                        ng-disabled=\"swModalWindow.saveDisabled\"\n                        class=\"btn btn-success\" \n                        type=\"button\" \n                        data-dismiss=\"modal\" \n                        ng-click=\"swModalWindow.saveAction()()\">\n                    <i class=\"glyphicon glyphicon-ok icon-white\"></i> \n                    <span ng-bind=\"swModalWindow.saveActionText\"></span>\n                </button> \n            </div>\n        </div>\n    </div>\n</div>";

/***/ }),

/***/ "QYpj":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWValidationNumeric = void 0;
var SWValidationNumeric = /** @class */ (function () {
    function SWValidationNumeric(validationService) {
        return {
            restrict: "A",
            require: "^ngModel",
            link: function (scope, element, attributes, ngModel) {
                ngModel.$validators.swvalidationnumeric =
                    function (modelValue, viewValue) {
                        return validationService.validateNumeric(viewValue);
                    };
            }
        };
    }
    SWValidationNumeric.Factory = function () {
        var directive = function (validationService) { return new SWValidationNumeric(validationService); };
        directive.$inject = ['validationService'];
        return directive;
    };
    return SWValidationNumeric;
}());
exports.SWValidationNumeric = SWValidationNumeric;


/***/ }),

/***/ "QbBB":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/*services return promises which can be handled uniquely based on success or failure by the controller*/
var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.SelectionService = void 0;
var baseservice_1 = __webpack_require__("zg2S");
var SelectionService = /** @class */ (function (_super) {
    __extends(SelectionService, _super);
    //@ngInject
    SelectionService.$inject = ["observerService"];
    function SelectionService(observerService) {
        var _this = _super.call(this) || this;
        _this.observerService = observerService;
        _this._selection = {};
        /* add current selectionid to main selection object*/
        _this.createSelections = function (selectionid) {
            _this._selection[selectionid] = {
                allSelected: false,
                ids: []
            };
        };
        _this.radioSelection = function (selectionid, selection) {
            _this.createSelections(selectionid);
            _this._selection[selectionid].ids.push(selection);
            _this.observerService.notify('swSelectionToggleSelection' + selectionid, { action: 'check', selectionid: selectionid, selection: selection });
        };
        _this.addSelection = function (selectionid, selection) {
            /*if allSelected flag is true addSelection will remove selection*/
            if (_this.isAllSelected(selectionid)) {
                var index = _this._selection[selectionid].ids.indexOf(selection);
                if (index > -1) {
                    _this._selection[selectionid].ids.splice(index, 1);
                    _this.observerService.notify('swSelectionToggleSelection' + selectionid, { action: 'check', selectionid: selectionid, selection: selection });
                }
            }
            else if (!_this.hasSelection(selectionid, selection)) {
                _this._selection[selectionid].ids.push(selection);
                _this.observerService.notify('swSelectionToggleSelection' + selectionid, { action: 'check', selectionid: selectionid, selection: selection });
            }
            console.info(_this._selection[selectionid]);
        };
        _this.setSelection = function (selectionid, selections) {
            if (angular.isUndefined(_this._selection[selectionid])) {
                _this.createSelections(selectionid);
            }
            _this._selection[selectionid].ids = selections;
        };
        _this.removeSelection = function (selectionid, selection) {
            if (angular.isUndefined(_this._selection[selectionid])) {
                return;
            }
            if (!_this.isAllSelected(selectionid)) {
                var index = _this._selection[selectionid].ids.indexOf(selection);
                if (index > -1) {
                    _this._selection[selectionid].ids.splice(index, 1);
                    _this.observerService.notify('swSelectionToggleSelection' + selectionid, { action: 'uncheck', selectionid: selectionid, selection: selection });
                }
                /*if allSelected flag is true removeSelection will add selection*/
            }
            else if (!_this.hasSelection(selectionid, selection)) {
                _this._selection[selectionid].ids.push(selection);
                _this.observerService.notify('swSelectionToggleSelection' + selectionid, { action: 'uncheck', selectionid: selectionid, selection: selection });
            }
            console.info(_this._selection[selectionid]);
        };
        _this.hasSelection = function (selectionid, selection) {
            if (angular.isUndefined(_this._selection[selectionid])) {
                return false;
            }
            return _this._selection[selectionid].ids.indexOf(selection) > -1;
        };
        _this.getSelections = function (selectionid) {
            if (angular.isUndefined(_this._selection[selectionid])) {
                _this.createSelections(selectionid);
            }
            return _this._selection[selectionid].ids;
        };
        _this.getSelectionCount = function (selectionid) {
            if (angular.isUndefined(_this._selection[selectionid])) {
                _this.createSelections(selectionid);
            }
            return _this._selection[selectionid].ids.length;
        };
        _this.clearSelection = function (selectionid) {
            _this.createSelections(selectionid);
            _this.observerService.notify('swSelectionToggleSelection' + selectionid, { action: 'clear' });
            console.info(_this._selection[selectionid]);
        };
        _this.selectAll = function (selectionid) {
            _this._selection[selectionid] = {
                allSelected: true,
                ids: []
            };
            _this.observerService.notify('swSelectionToggleSelection' + selectionid, { action: 'selectAll' });
            console.info(_this._selection[selectionid]);
        };
        _this.isAllSelected = function (selectionid) {
            if (angular.isUndefined(_this._selection[selectionid])) {
                _this.createSelections(selectionid);
            }
            return _this._selection[selectionid].allSelected;
        };
        return _this;
    }
    return SelectionService;
}(baseservice_1.BaseService));
exports.SelectionService = SelectionService;


/***/ }),

/***/ "Qxcv":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWOptions = void 0;
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWOptions = /** @class */ (function () {
    // @ngInject;
    SWOptions.$inject = ["$log", "$hibachi", "observerService"];
    function SWOptions($log, $hibachi, observerService) {
        var _this = this;
        this.$log = $log;
        this.$hibachi = $hibachi;
        this.observerService = observerService;
        this.template = __webpack_require__("2KUm");
        this.restrict = 'AE';
        this.scope = {
            objectName: '@'
        };
        this.link = function (scope, element, attrs) {
            scope.swOptions = {};
            scope.swOptions.objectName = scope.objectName;
            //sets up drop down options via collections
            scope.getOptions = function () {
                scope.swOptions.object = _this.$hibachi['new' + scope.swOptions.objectName]();
                var columnsConfig = [
                    {
                        "propertyIdentifier": scope.swOptions.objectName.charAt(0).toLowerCase() + scope.swOptions.objectName.slice(1) + 'Name'
                    },
                    {
                        "propertyIdentifier": scope.swOptions.object.$$getIDName()
                    }
                ];
                _this.$hibachi.getEntity(scope.swOptions.objectName, {
                    allRecords: true,
                    columnsConfig: angular.toJson(columnsConfig)
                })
                    .then(function (value) {
                    scope.swOptions.options = value.records;
                    _this.observerService.notify('optionsLoaded');
                });
            };
            scope.getOptions();
            var selectOption = function (option) {
                if (option) {
                    scope.swOptions.selectOption(option);
                }
                else {
                    scope.swOptions.selectOption(scope.swOptions.options[0]);
                }
            };
            _this.observerService.attach(selectOption, 'selectOption', 'selectOption');
            //use by ng-change to record changes
            scope.swOptions.selectOption = function (selectedOption) {
                scope.swOptions.selectedOption = selectedOption;
                _this.observerService.notify('optionsChanged', selectedOption);
            };
        };
    }
    SWOptions.Factory = function () {
        var _this = this;
        return /** @ngInject; */ ["$log", "$hibachi", "observerService", function ($log, $hibachi, observerService) { return new _this($log, $hibachi, observerService); }];
    };
    return SWOptions;
}());
exports.SWOptions = SWOptions;


/***/ }),

/***/ "RaZC":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path="../../typings/tsd.d.ts" />
/// <reference path="../../typings/hibachiTypescript.d.ts" />
Object.defineProperty(exports, "__esModule", { value: true });
exports.validationmodule = void 0;
//components
var swvalidate_1 = __webpack_require__("DJjK");
var swvalidationminlength_1 = __webpack_require__("Aj5l");
var swvalidationdatatype_1 = __webpack_require__("iJDV");
var swvalidationeq_1 = __webpack_require__("POsI");
var swvalidationeqproperty_1 = __webpack_require__("cIHc");
var swvalidationgte_1 = __webpack_require__("XFvX");
var swvalidationlte_1 = __webpack_require__("Fnnc");
var swvalidationmaxlength_1 = __webpack_require__("cNVU");
var swvalidationmaxvalue_1 = __webpack_require__("L9gJ");
var swvalidationminvalue_1 = __webpack_require__("XAQP");
var swvalidationneq_1 = __webpack_require__("dDSC");
var swvalidationnumeric_1 = __webpack_require__("QYpj");
var swvalidationregex_1 = __webpack_require__("IhXr");
var swvalidationrequired_1 = __webpack_require__("MVzf");
var swvalidationunique_1 = __webpack_require__("Vfql");
var swvalidationuniqueornull_1 = __webpack_require__("SDsC");
//services
var validationservice_1 = __webpack_require__("f5BN");
var core_module_1 = __webpack_require__("pwA0");
var validationmodule = angular.module('hibachi.validation', [core_module_1.coremodule.name])
    .run([function () {
    }])
    //directives
    .directive('swValidate', swvalidate_1.SWValidate.Factory())
    .directive('swvalidationminlength', swvalidationminlength_1.SWValidationMinLength.Factory())
    .directive('swvalidationdatatype', swvalidationdatatype_1.SWValidationDataType.Factory())
    .directive('swvalidationeq', swvalidationeq_1.SWValidationEq.Factory())
    .directive("swvalidationgte", swvalidationgte_1.SWValidationGte.Factory())
    .directive("swvalidationlte", swvalidationlte_1.SWValidationLte.Factory())
    .directive('swvalidationmaxlength', swvalidationmaxlength_1.SWValidationMaxLength.Factory())
    .directive("swvalidationmaxvalue", swvalidationmaxvalue_1.SWValidationMaxValue.Factory())
    .directive("swvalidationminvalue", swvalidationminvalue_1.SWValidationMinValue.Factory())
    .directive("swvalidationneq", swvalidationneq_1.SWValidationNeq.Factory())
    .directive("swvalidationnumeric", swvalidationnumeric_1.SWValidationNumeric.Factory())
    .directive("swvalidationregex", swvalidationregex_1.SWValidationRegex.Factory())
    .directive("swvalidationrequired", swvalidationrequired_1.SWValidationRequired.Factory())
    .directive("swvalidationunique", swvalidationunique_1.SWValidationUnique.Factory())
    .directive("swvalidationuniqueornull", swvalidationuniqueornull_1.SWValidationUniqueOrNull.Factory())
    .directive("swvalidationeqproperty", swvalidationeqproperty_1.SWValidationEqProperty.Factory())
    //services
    .service("validationService", validationservice_1.ValidationService);
exports.validationmodule = validationmodule;


/***/ }),

/***/ "S2Ji":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWGravatarController = exports.SWGravatar = void 0;
var md5 = __webpack_require__("ssIG");
var SWGravatarController = /** @class */ (function () {
    // @ngInject
    function SWGravatarController() {
        this.gravatarURL = "http://www.gravatar.com/avatar/" + md5(this.emailAddress.toLowerCase().trim());
    }
    return SWGravatarController;
}());
exports.SWGravatarController = SWGravatarController;
var SWGravatar = /** @class */ (function () {
    // @ngInject;
    function SWGravatar() {
        this.template = "<img src='{{swGravatar.gravatarURL}}' />";
        this.transclude = false;
        this.restrict = "E";
        this.scope = {};
        this.bindToController = {
            emailAddress: "@"
        };
        this.controller = SWGravatarController;
        this.controllerAs = "swGravatar";
    }
    SWGravatar.Factory = function () {
        var directive = function () { return new SWGravatar(); };
        directive.$inject = [];
        return directive;
    };
    SWGravatar.$inject = ["$hibachi", "$timeout", "collectionConfigService", "corePartialsPath",
        'hibachiPathBuilder'];
    return SWGravatar;
}());
exports.SWGravatar = SWGravatar;


/***/ }),

/***/ "SCrc":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.PercentageFilter = void 0;
var PercentageFilter = /** @class */ (function () {
    function PercentageFilter() {
    }
    PercentageFilter.Factory = function () {
        return function (input, decimals, suffix) {
            decimals = angular.isNumber(decimals) ? decimals : 3;
            suffix = suffix || '%';
            if (isNaN(input)) {
                return '';
            }
            return Math.round(input * Math.pow(10, decimals + 2)) / Math.pow(10, decimals) + suffix;
        };
    };
    return PercentageFilter;
}());
exports.PercentageFilter = PercentageFilter;


/***/ }),

/***/ "SDsC":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWValidationUniqueOrNull = void 0;
var SWValidationUniqueOrNull = /** @class */ (function () {
    //@ngInject
    SWValidationUniqueOrNull.$inject = ["$http", "$q", "$hibachi", "$log", "validationService"];
    function SWValidationUniqueOrNull($http, $q, $hibachi, $log, validationService) {
        return {
            restrict: "A",
            require: "ngModel",
            link: function (scope, element, attributes, ngModel) {
                ngModel.$asyncValidators.swvalidationuniqueornull = function (modelValue, viewValue) {
                    var currentValue = modelValue || viewValue;
                    if (scope && scope.propertyDisplay && scope.propertyDisplay.property) {
                        var property = scope.propertyDisplay.property;
                        return validationService.validateUniqueOrNull(currentValue, scope.propertyDisplay.object, property);
                    }
                    else {
                        return $q.resolve(); //nothing to validate yet.
                    }
                };
            }
        };
    }
    SWValidationUniqueOrNull.Factory = function () {
        var directive = function ($http, $q, $hibachi, $log, validationService) { return new SWValidationUniqueOrNull($http, $q, $hibachi, $log, validationService); };
        directive.$inject = ['$http', '$q', '$hibachi', '$log', 'validationService'];
        return directive;
    };
    return SWValidationUniqueOrNull;
}());
exports.SWValidationUniqueOrNull = SWValidationUniqueOrNull;


/***/ }),

/***/ "SZP2":
/***/ (function(module, exports) {

module.exports = "<div\n\tclass=\"modal in using-modal-service\"\n\trole=\"dialog\"\n\tid=\"flexship-modal-payment-method{{ swAddressVerification.orderTemplate.orderTemplateID }}\"\n>\n\t<div class=\"modal-dialog modal-lg\">\n        <form name=\"updateAddress\">\n        \t<div class=\"modal-header\">\n        \t\t<button\n\t\t\t\t\ttype=\"button\"\n\t\t\t\t\tclass=\"close\"\n\t\t\t\t\tng-click=\"swAddressVerification.closeModal()\"\n\t\t\t\t\taria-label=\"Close\"\n\t\t\t\t>\n\t\t\t\t\t<i class=\"fas fa-times\"></i>\n\t\t\t\t</button>\n        \t</div>\n        \t<div class=\"modal-body\">\n\t\t\t\t<div class=\"modal-content\">\n\t\t\t\t\t<!-- Modal Close -->\n\t\t\t\t\t<div class=\"payment\">\n\t\t\t\t\t\t<h6 class=\"title-with-line mb-5\">\n\t\t\t\t\t\t\t{{ swAddressVerification.translations.suggestedAddress }}\n\t\t\t\t\t\t</h6>\n\t\t\t\t\t\t<div class=\"shipping-options\"> \n\t\t\t\t\t\t\t<p>{{ swAddressVerification.translations.addressMessage }}</p>\n\t\t\t\t\t\t\t<div\n\t\t\t\t\t\t\t\tclass=\"custom-radio form-group\"\n\t\t\t\t\t\t\t\tng-repeat=\"address in swAddressVerification.suggestedAddresses track by $index\"\n\t\t\t\t\t\t\t>\n\t\t\t\t\t\t\t\t<!--<h5>{{$index == 1 ? 'Suggested Address' : 'Entered Address'}}</h5>-->\n\t\t\t\t\t\t\t\t<input\n\t\t\t\t\t\t\t\t\ttype=\"radio\"\n\t\t\t\t\t\t\t\t\tname=\"saved_cards\"\n\t\t\t\t\t\t\t\t\tid=\"address{{$index}}\"\n\t\t\t\t\t\t\t\t\tvalue=\"{{$index}}\"\n\t\t\t\t\t\t\t\t\tng-model=\"swAddressVerification.selectedAddressIndex\"\n\t\t\t\t\t\t\t\t\tng-checked=\"swAddressVerification.selectedAddressIndex == $index\"\n\t\t\t\t\t\t\t\t/>\n\t\t\t\t\t\t\t\t<label for=\"address{{$index}}\" ng-click=\"swAddressVerification.selectedAddressIndex = $index\">\n\t\t\t\t\t\t\t\t\t{{address.streetAddress}}, {{address.city}}, {{(address.stateCode || address.locality) ? (address.stateCode || address.locality) + ',' : ''}} {{address.postalCode}}\n\t\t\t\t\t\t\t\t</label>\n\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t</div>\n\t\t\t\t\t</div>\n\t\t        </div>\n\t        </div>\n\t\t\t<div class=\"modal-footer\">\n\t\t\t\t<div class=\"footer\">\n\t\t\t\t\t<button\n\t\t\t\t\t\tclass=\"btn btn-block bg-primary\"\n\t\t\t\t\t\tng-class=\"{ loading: swAddressVerification.loading }\"\n\t\t\t\t\t\tng-disabled = \"swAddressVerification.loading || swAddressVerification.selectedAddressIndex == undefined\"\n\t\t\t\t\t\tsw-rbkey=\"'admin.define.okay'\"\n\t\t\t\t\t\tng-click=\"swAddressVerification.submit()\"\n\t\t\t\t\t>\n\t\t\t\t\t</button>\n\t\t\t\t</div>\n\t\t\t</div>\n        </form>\n\t</div>\n</div>\n";

/***/ }),

/***/ "SaEH":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.HibachiPathBuilder = void 0;
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/*services return promises which can be handled uniquely based on success or failure by the controller*/
var HibachiPathBuilder = /** @class */ (function () {
    //@ngInject
    function HibachiPathBuilder() {
        var _this = this;
        this.setBaseURL = function (baseURL) {
            _this.baseURL = baseURL;
        };
        this.setBasePartialsPath = function (basePartialsPath) {
            _this.basePartialsPath = basePartialsPath;
        };
        this.setApiSubsystemName = function (apiSubsystemName) {
            _this.apiSubsystemName = apiSubsystemName;
        };
        this.buildPartialsPath = function (componentsPath) {
            if (angular.isDefined(_this.baseURL) && angular.isDefined(_this.basePartialsPath)) {
                return (_this.baseURL + _this.basePartialsPath + componentsPath).replace("//", "/");
            }
            else {
                throw ('need to define baseURL and basePartialsPath in hibachiPathBuilder. Inject hibachiPathBuilder into module and configure it there');
            }
        };
    }
    return HibachiPathBuilder;
}());
exports.HibachiPathBuilder = HibachiPathBuilder;


/***/ }),

/***/ "Se2u":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.AlertService = void 0;
//import Alert = require('../model/alert');
var alert_1 = __webpack_require__("BrcS");
var AlertService = /** @class */ (function () {
    function AlertService($timeout, alerts) {
        var _this = this;
        this.$timeout = $timeout;
        this.alerts = alerts;
        this.newAlert = function () {
            return new alert_1.Alert();
        };
        this.get = function () {
            return _this.alerts || [];
        };
        this.addAlert = function (alert) {
            if (alert.msg) {
                _this.alerts.push(alert);
                _this.$timeout(function () {
                    if (!alert.dismissable) {
                        _this.removeAlert(alert);
                    }
                }, 3500);
            }
        };
        this.addAlerts = function (alerts) {
            angular.forEach(alerts, function (alert) {
                _this.addAlert(alert);
            });
        };
        this.removeAlert = function (alert) {
            var index = _this.alerts.indexOf(alert, 0);
            if (index != undefined) {
                _this.alerts.splice(index, 1);
            }
        };
        this.getAlerts = function () {
            return _this.alerts;
        };
        this.formatMessagesToAlerts = function (messages) {
            var alerts = [];
            if (messages && messages.length) {
                for (var message in messages) {
                    if (messages[message].messageType == "error" && messages[message].message == "Pre Process Displayed Flag must be equal to 1") {
                        //skip this type of message as its just used to display the modal.
                        continue;
                    }
                    var alert = new alert_1.Alert(messages[message].message, messages[message].messageType);
                    alerts.push(alert);
                    if (alert.type === 'success' || alert.type === 'error') {
                        _this.$timeout(function () {
                            alert.fade = true;
                        }, 4500);
                        alert.dismissable = false;
                    }
                    else {
                        alert.fade = false;
                        alert.dismissable = true;
                    }
                }
            }
            return alerts;
        };
        this.removeOldestAlert = function () {
            _this.alerts.splice(0, 1);
        };
        this.alerts = [];
    }
    AlertService.$inject = [
        '$timeout'
    ];
    return AlertService;
}());
exports.AlertService = AlertService;


/***/ }),

/***/ "Svpb":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.AccountService = void 0;
var baseentityservice_1 = __webpack_require__("P6y0");
var AccountService = /** @class */ (function (_super) {
    __extends(AccountService, _super);
    //@ngInject
    AccountService.$inject = ["$injector", "$hibachi", "utilityService"];
    function AccountService($injector, $hibachi, utilityService) {
        var _this = _super.call(this, $injector, $hibachi, utilityService, 'Account') || this;
        _this.$injector = $injector;
        _this.$hibachi = $hibachi;
        _this.utilityService = utilityService;
        return _this;
    }
    return AccountService;
}(baseentityservice_1.BaseEntityService));
exports.AccountService = AccountService;


/***/ }),

/***/ "TjPs":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWFAddressForm = exports.SWFAddressFormController = void 0;
var swfform_1 = __webpack_require__("W1Ga");
var SWFAddressFormController = /** @class */ (function (_super) {
    __extends(SWFAddressFormController, _super);
    function SWFAddressFormController($rootScope, $scope, $timeout, $hibachi, $element, validationService, hibachiValidationService, observerService) {
        var _this = _super.call(this, $rootScope, $scope, $timeout, $hibachi, $element, validationService, hibachiValidationService, observerService) || this;
        _this.$rootScope = $rootScope;
        _this.$scope = $scope;
        _this.$timeout = $timeout;
        _this.$hibachi = $hibachi;
        _this.$element = $element;
        _this.validationService = validationService;
        _this.hibachiValidationService = hibachiValidationService;
        _this.observerService = observerService;
        _this.submitAddressForm = function () {
            _this.submitForm().then(function (result) {
                if (result && result.successfulActions.length) {
                    _this.observerService.notify("shippingAddressSelected", { accountAddressID: result['newAccountAddressID'] });
                    _this.slatwall.editingAddress = null;
                    _this.$timeout(function () {
                        _this.ngModel.$setViewValue(null);
                        _this.ngModel.$commitViewValue();
                    });
                }
            });
        };
        _this.$rootScope = $rootScope;
        _this.slatwall = $rootScope.slatwall;
        $scope.$watch(angular.bind(_this, function () {
            return _this.form['countryCode'].$modelValue;
        }), function (newVal, oldVal) {
            if (!isNaN(newVal)) {
                _this.slatwall.getStates(newVal);
            }
        });
        $scope.$watch('slatwall.states.addressOptions', function () {
            if (_this.slatwall.states && _this.slatwall.states.addressOptions) {
                _this.addressOptions = _this.slatwall.states.addressOptions;
            }
        });
        return _this;
    }
    return SWFAddressFormController;
}(swfform_1.SWFFormController));
exports.SWFAddressFormController = SWFAddressFormController;
var SWFAddressForm = /** @class */ (function (_super) {
    __extends(SWFAddressForm, _super);
    //@ngInject
    function SWFAddressForm() {
        var _this = _super.call(this) || this;
        var swfForm = new swfform_1.SWFForm;
        swfForm.controller = SWFAddressFormController;
        swfForm.controllerAs = "swfAddressForm";
        swfForm.bindToController['formID'] = '@id';
        swfForm.bindToController['addressVariable'] = '@';
        return swfForm;
    }
    SWFAddressForm.Factory = function () {
        var directive = function () { return new SWFAddressForm(); };
        return directive;
    };
    return SWFAddressForm;
}(swfform_1.SWFForm));
exports.SWFAddressForm = SWFAddressForm;


/***/ }),

/***/ "TrJb":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWExpandableRecord = void 0;
var SWExpandableRecordController = /** @class */ (function () {
    //@ngInject
    SWExpandableRecordController.$inject = ["$timeout", "$hibachi", "utilityService", "collectionConfigService", "expandableService", "listingService", "observerService"];
    function SWExpandableRecordController($timeout, $hibachi, utilityService, collectionConfigService, expandableService, listingService, observerService) {
        var _this = this;
        this.$timeout = $timeout;
        this.$hibachi = $hibachi;
        this.utilityService = utilityService;
        this.collectionConfigService = collectionConfigService;
        this.expandableService = expandableService;
        this.listingService = listingService;
        this.observerService = observerService;
        this.childrenLoaded = false;
        this.childrenOpen = false;
        this.children = [];
        this.refreshChildren = function () {
            _this.getEntity();
        };
        this.setupChildCollectionConfig = function () {
            _this.childCollectionConfig = _this.collectionConfigService.newCollectionConfig(_this.entity.metaData.className);
            //set up parent
            var parentName = _this.entity.metaData.hb_parentPropertyName;
            var parentCFC = _this.entity.metaData[parentName].cfc;
            _this.parentIDName = _this.$hibachi.getEntityExample(parentCFC).$$getIDName();
            //set up child
            var childName = _this.entity.metaData.hb_childPropertyName;
            var childCFC = _this.entity.metaData[childName].cfc;
            var childIDName = _this.$hibachi.getEntityExample(childCFC).$$getIDName();
            _this.childCollectionConfig.clearFilterGroups();
            _this.childCollectionConfig.collection = _this.entity;
            _this.childCollectionConfig.addFilter(parentName + '.' + _this.parentIDName, _this.parentId);
            _this.childCollectionConfig.setAllRecords(true);
            angular.forEach(_this.collectionConfig.columns, function (column) {
                _this.childCollectionConfig.addColumn(column.propertyIdentifier, column.title, column);
            });
            angular.forEach(_this.collectionConfig.joins, function (join) {
                _this.childCollectionConfig.addJoin(join);
            });
            _this.childCollectionConfig.groupBys = _this.collectionConfig.groupBys;
        };
        this.getEntity = function () {
            _this.collectionPromise.then(function (data) {
                _this.collectionData = data;
                _this.collectionData.pageRecords = _this.collectionData.pageRecords || _this.collectionData.records;
                if (_this.collectionData.pageRecords.length) {
                    angular.forEach(_this.collectionData.pageRecords, function (pageRecord) {
                        _this.expandableService.addRecord(pageRecord[_this.parentIDName], true);
                        pageRecord.dataparentID = _this.recordID;
                        pageRecord.depth = _this.recordDepth || 0;
                        pageRecord.depth++;
                        //push the children into the listing display
                        _this.children.push(pageRecord);
                        _this.records.splice(_this.recordIndex + 1, 0, pageRecord);
                    });
                }
                _this.childrenLoaded = true;
            });
        };
        this.toggleChild = function () {
            _this.$timeout(function () {
                _this.childrenOpen = !_this.childrenOpen;
                _this.expandableService.updateState(_this.recordID, { isOpen: _this.childrenOpen });
                if (!_this.childrenLoaded) {
                    if (_this.childCollectionConfig == null) {
                        _this.setupChildCollectionConfig();
                    }
                    if (angular.isFunction(_this.childCollectionConfig.getEntity)) {
                        _this.collectionPromise = _this.childCollectionConfig.getEntity();
                    }
                    _this.getEntity();
                }
                angular.forEach(_this.children, function (child) {
                    child.dataIsVisible = _this.childrenOpen;
                    var entityPrimaryIDName = _this.entity.$$getIDName();
                    var idsToCheck = [];
                    idsToCheck.push(child[entityPrimaryIDName]);
                    _this.expandableService.updateState(child[entityPrimaryIDName], { isOpen: _this.childrenOpen });
                    //close all children of the child if we are closing
                    var childrenTraversed = false;
                    var recordLength = _this.records.length;
                    while (!childrenTraversed && idsToCheck.length > 0) {
                        var found = false;
                        var idToCheck = idsToCheck.pop();
                        for (var i = 0; i < recordLength; i++) {
                            var record = _this.records[i];
                            if (record['dataparentID'] == idToCheck) {
                                idsToCheck.push(record[entityPrimaryIDName]);
                                _this.expandableService.updateState(record[entityPrimaryIDName], { isOpen: _this.childrenOpen });
                                record.dataIsVisible = _this.childrenOpen;
                                found = true;
                            }
                        }
                        if (!found) {
                            childrenTraversed = true;
                        }
                    }
                });
            });
        };
        this.recordID = this.parentId; //this is what parent is initalized to in the listing display
        expandableService.addRecord(this.recordID);
        if (angular.isDefined(this.refreshChildrenEvent) && this.refreshChildrenEvent.length) {
            this.observerService.attach(this.refreshChildren, this.refreshChildrenEvent);
        }
    }
    return SWExpandableRecordController;
}());
var SWExpandableRecord = /** @class */ (function () {
    //@ngInject
    SWExpandableRecord.$inject = ["$compile", "$timeout", "utilityService", "expandableService"];
    function SWExpandableRecord($compile, $timeout, utilityService, expandableService) {
        var _this = this;
        this.$compile = $compile;
        this.$timeout = $timeout;
        this.utilityService = utilityService;
        this.expandableService = expandableService;
        this.restrict = 'EA';
        this.templateString = __webpack_require__("qp7O");
        this.scope = {};
        this.bindToController = {
            recordValue: "=",
            link: "@",
            expandable: "=?",
            parentId: "=",
            entity: "=",
            collectionConfig: "=?",
            childCollectionConfig: "<?",
            refreshChildrenEvent: "=?",
            listingId: "@?",
            records: "=",
            pageRecord: "=",
            recordIndex: "=",
            recordDepth: "=",
            childCount: "=",
            autoOpen: "=",
            multiselectIdPaths: "=",
            expandableRules: "="
        };
        this.controller = SWExpandableRecordController;
        this.controllerAs = "swExpandableRecord";
        this.link = function (scope, element, attrs) {
            if (scope.swExpandableRecord.expandable && scope.swExpandableRecord.childCount) {
                if (scope.swExpandableRecord.recordValue) {
                    var id = scope.swExpandableRecord.records[scope.swExpandableRecord.recordIndex][scope.swExpandableRecord.entity.$$getIDName()];
                    if (scope.swExpandableRecord.multiselectIdPaths && scope.swExpandableRecord.multiselectIdPaths.length) {
                        var multiselectIdPathsArray = scope.swExpandableRecord.multiselectIdPaths.split(',');
                        if (!scope.swExpandableRecord.childrenLoaded) {
                            angular.forEach(multiselectIdPathsArray, function (multiselectIdPath) {
                                var position = _this.utilityService.listFind(multiselectIdPath, id, '/');
                                var multiSelectIDs = multiselectIdPath.split('/');
                                var multiselectPathLength = multiSelectIDs.length;
                                if (position !== -1 && position < multiselectPathLength - 1 && !_this.expandableService.getState(id, "isOpen")) {
                                    _this.expandableService.updateState(id, { isOpen: true });
                                    scope.swExpandableRecord.toggleChild();
                                }
                            });
                        }
                    }
                }
                var template = angular.element(_this.templateString);
                //get autoopen reference to ensure only the root is autoopenable
                var autoOpen = angular.copy(scope.swExpandableRecord.autoOpen);
                scope.swExpandableRecord.autoOpen = false;
                template = _this.$compile(template)(scope);
                element.html(template);
                element.on('click', scope.swExpandableRecord.toggleChild);
                if (autoOpen) {
                    scope.swExpandableRecord.toggleChild();
                }
            }
        };
    }
    SWExpandableRecord.Factory = function () {
        var _this = this;
        return /** @ngInject; */ ["$compile", "$timeout", "utilityService", "expandableService", function ($compile, $timeout, utilityService, expandableService) {
            return new _this($compile, $timeout, utilityService, expandableService);
        }];
    };
    return SWExpandableRecord;
}());
exports.SWExpandableRecord = SWExpandableRecord;


/***/ }),

/***/ "U1QT":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWSimplePropertyDisplayController = exports.SWSimplePropertyDisplay = void 0;
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWSimplePropertyDisplayController = /** @class */ (function () {
    //@ngInject
    SWSimplePropertyDisplayController.$inject = ["$filter", "utilityService", "$injector", "observerService"];
    function SWSimplePropertyDisplayController($filter, utilityService, $injector, observerService) {
        var _this = this;
        this.$filter = $filter;
        this.utilityService = utilityService;
        this.$injector = $injector;
        this.observerService = observerService;
        this.formattedFlag = false;
        this.$onInit = function () {
            _this.value = _this.object[_this.property];
            // First, check if it was passed in via the object instead of the attribute.
            if (_this.object && _this.object.currencyCode && !_this.currencyCode) {
                _this.currencyCode = _this.object.currencyCode;
            }
            //sets a default if there is no value and we have one...
            if (!_this.value && _this.default) {
                _this.value = _this.default;
            }
            //sets a default width for the value 
            if (!_this.displayWidth) {
                _this.displayWidth = "110";
            }
            //attach the refresh listener.
            if (_this.refreshEvent) {
                _this.observerService.attach(_this.refresh, _this.refreshEvent);
            }
        };
        this.refresh = function (payload) {
            _this.object = payload;
            _this.value = _this.object[_this.property];
            _this.formattedFlag = true; //this tells the view to not apply the currency filter because its already applied...
        };
    }
    return SWSimplePropertyDisplayController;
}());
exports.SWSimplePropertyDisplayController = SWSimplePropertyDisplayController;
var SWSimplePropertyDisplay = /** @class */ (function () {
    //@ngInject
    function SWSimplePropertyDisplay($compile, scopeService, coreFormPartialsPath, hibachiPathBuilder, swpropertyPartialPath) {
        this.$compile = $compile;
        this.scopeService = scopeService;
        this.coreFormPartialsPath = coreFormPartialsPath;
        this.hibachiPathBuilder = hibachiPathBuilder;
        this.swpropertyPartialPath = swpropertyPartialPath;
        this.restrict = 'AE';
        this.scope = {};
        this.bindToController = {
            edit: "@?",
            property: "@?",
            title: "@?",
            object: "<?",
            displayType: "@?",
            currencyFlag: "@?",
            refreshEvent: "@?",
            displayWidth: "@?",
            currencyCode: "@?",
            default: "@?"
        };
        this.controller = SWSimplePropertyDisplayController;
        this.controllerAs = "swSimplePropertyDisplay";
        this.templateUrlPath = "simplepropertydisplay.html";
        this.link = function ($scope) { };
        this.templateUrl = this.hibachiPathBuilder.buildPartialsPath(this.coreFormPartialsPath) + swpropertyPartialPath;
    }
    SWSimplePropertyDisplay.Factory = function (swpropertyClass, swpropertyPartialPath) {
        var directive = function ($compile, scopeService, coreFormPartialsPath, hibachiPathBuilder) { return new swpropertyClass($compile, scopeService, coreFormPartialsPath, hibachiPathBuilder, 
        //not an inejctable don't add to $inject. This is in the form.module Factory implementation
        swpropertyPartialPath); };
        directive.$inject = ['$compile', 'scopeService', 'coreFormPartialsPath', 'hibachiPathBuilder'];
        return directive;
    };
    SWSimplePropertyDisplay.$inject = ['coreFormPartialsPath', 'hibachiPathBuilder'];
    return SWSimplePropertyDisplay;
}());
exports.SWSimplePropertyDisplay = SWSimplePropertyDisplay;


/***/ }),

/***/ "URW6":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWLoading = void 0;
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWLoading = /** @class */ (function () {
    function SWLoading() {
        this.template = __webpack_require__("ZT2N");
        this.restrict = 'A';
        this.transclude = true;
        this.scope = {
            swLoading: '='
        };
    }
    SWLoading.Factory = function () {
        var _this = this;
        return /** @ngInject; */ function () { return new _this(); };
    };
    return SWLoading;
}());
exports.SWLoading = SWLoading;


/***/ }),

/***/ "UoGw":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.GlobalSearchController = void 0;
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var GlobalSearchController = /** @class */ (function () {
    //@ngInject
    GlobalSearchController.$inject = ["$scope", "$log", "$window", "$timeout", "$hibachi", "rbkeyService"];
    function GlobalSearchController($scope, $log, $window, $timeout, $hibachi, rbkeyService) {
        $scope.keywords = '';
        $scope.searchResultsOpen = false;
        $scope.sidebarClass = 'sidebar';
        $scope.loading = false; //Set loading wheel to false
        $scope.resultsFound = true; // Set the results Found to true because no search has been done yet
        $scope.searchResults = {
            'product': {
                'title': 'Products',
                'resultNameFilter': function (data) {
                    return data['productName'];
                },
                'results': [],
                'id': function (data) {
                    return data['productID'];
                }
            },
            'order': {
                'title': rbkeyService.getRBKey('entity.order_plural'),
                'resultNameFilter': function (data) {
                    return data['orderNumber'];
                },
                'results': [],
                'id': function (data) {
                    return data['orderID'];
                }
            },
            'brand': {
                'title': rbkeyService.getRBKey('entity.brand_plural'),
                'resultNameFilter': function (data) {
                    return data['brandName'];
                },
                'results': [],
                'id': function (data) {
                    return data['brandID'];
                }
            },
            'account': {
                'title': 'Accounts',
                'resultNameFilter': function (data) {
                    return data['firstName'] + ' ' + data['lastName'];
                },
                'results': [],
                'id': function (data) {
                    return data['accountID'];
                }
            },
            'vendor': {
                'title': 'Vendors',
                'resultNameFilter': function (data) {
                    return data['vendorName'];
                },
                'results': [],
                'id': function (data) {
                    return data['vendorID'];
                }
            }
        };
        var _timeoutPromise;
        var _loadingCount = 0;
        $scope.updateSearchResults = function () {
            $scope.loading = true;
            $scope.showResults();
            if (_timeoutPromise) {
                $timeout.cancel(_timeoutPromise);
            }
            _timeoutPromise = $timeout(function () {
                // If no keywords, then set everything back to their defaults
                if ($scope.keywords === '') {
                    $scope.hideResults();
                    // Otherwise performe the search
                }
                else {
                    $scope.showResults();
                    // Set the loadingCount to the number of AJAX Calls we are about to do
                    _loadingCount = Object.keys($scope.searchResults).length;
                    for (var entityName in $scope.searchResults) {
                        (function (entityName) {
                            var searchPromise = $hibachi.getEntity(entityName, { keywords: $scope.keywords, pageShow: 4, deferkey: 'global-search-' + entityName });
                            searchPromise.then(function (data) {
                                // Clear out the old Results
                                $scope.searchResults[entityName].results = [];
                                $scope.searchResults[entityName].title = rbkeyService.getRBKey('entity.' + entityName.toLowerCase() + '_plural');
                                // push in the new results
                                for (var i in data.pageRecords) {
                                    $scope.searchResults[entityName].results.push({
                                        'name': $scope.searchResults[entityName].resultNameFilter(data.pageRecords[i]),
                                        'link': $hibachi.buildUrl('entity.detail' + entityName) + '&' + entityName + 'ID=' + $scope.searchResults[entityName].id(data.pageRecords[i]),
                                    });
                                }
                                // Increment Down The Loading Count
                                _loadingCount--;
                                // If the loadingCount drops to 0, then we can update scope
                                if (_loadingCount == 0) {
                                    $scope.loading = false;
                                    var _foundResults = false;
                                    for (var _thisEntityName in $scope.searchResults) {
                                        if ($scope.searchResults[_thisEntityName].results.length) {
                                            _foundResults = true;
                                            break;
                                        }
                                    }
                                    $scope.resultsFound = _foundResults;
                                }
                            });
                        })(entityName);
                    }
                }
            }, 500);
        };
        $scope.showResults = function () {
            $scope.searchResultsOpen = true;
            $scope.sidebarClass = 'sidebar s-search-width';
            $window.onclick = function (event) {
                var _targetClassOfSearch = event.target.parentElement.offsetParent.classList.contains('sidebar');
                if (!_targetClassOfSearch) {
                    $scope.hideResults();
                    $scope.$apply();
                }
            };
        };
        $scope.hideResults = function () {
            $scope.searchResultsOpen = false;
            $scope.sidebarClass = 'sidebar';
            $scope.search.$setPristine();
            $scope.keywords = "";
            $window.onclick = null;
            $scope.loading = false;
            $scope.resultsFound = true;
            for (var entityName in $scope.searchResults) {
                $scope.searchResults[entityName].results = [];
            }
        };
    }
    return GlobalSearchController;
}());
exports.GlobalSearchController = GlobalSearchController;


/***/ }),

/***/ "V4rq":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var __assign = (this && this.__assign) || function () {
    __assign = Object.assign || function(t) {
        for (var s, i = 1, n = arguments.length; i < n; i++) {
            s = arguments[i];
            for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p))
                t[p] = s[p];
        }
        return t;
    };
    return __assign.apply(this, arguments);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWPaginationBarController = exports.SWPaginationBar = void 0;
//import pagination = require('../services/paginationservice');
//var PaginationService = pagination.PaginationService;
//'use strict';
var SWPaginationBarController = /** @class */ (function () {
    //@ngInject
    SWPaginationBarController.$inject = ["paginationService", "observerService"];
    function SWPaginationBarController(paginationService, observerService) {
        var _this = this;
        this.paginationService = paginationService;
        this.observerService = observerService;
        this.$onInit = function () {
            _this.limitCountTotal = _this.swListingDisplay.collectionConfig.limitCountTotal; // fetch from config file
        };
        //Documentation: Toggle flag function to either show or turn off all records count fetch.
        this.toggleCountLimit = function (count) {
            if (_this.limitCountTotal > 0) {
                _this.limitCountTotal = 0;
            }
            else {
                _this.limitCountTotal = _this.swListingDisplay.collectionConfig.limitCountTotal; // fetch again from config file
            }
            _this.updateListingSearchConfig({
                limitCountTotal: _this.limitCountTotal
            });
        };
        if (angular.isUndefined(this.paginator)) {
            this.paginator = paginationService.createPagination();
        }
    }
    /* updateListingSearchConfig Should not be copied again here and must ideally be reused from sqlistingsearch.ts and extended above */
    SWPaginationBarController.prototype.updateListingSearchConfig = function (config) {
        var newListingSearchConfig = __assign(__assign({}, this.swListingDisplay.collectionConfig.listingSearchConfig), config);
        this.swListingDisplay.collectionConfig.listingSearchConfig = newListingSearchConfig;
        this.listingId = this.paginator.uuid;
        this.observerService.notifyById('swPaginationAction', this.listingId, { type: 'setCurrentPage', payload: 1 });
    };
    return SWPaginationBarController;
}());
exports.SWPaginationBarController = SWPaginationBarController;
var SWPaginationBar = /** @class */ (function () {
    function SWPaginationBar() {
        this.template = __webpack_require__("YMXA");
        this.restrict = 'E';
        this.scope = {};
        this.require = { swListingDisplay: "?^swListingDisplay", swListingControls: '?^swListingControls' };
        this.bindToController = {
            collectionConfig: "=",
            paginator: "=?",
            listingId: "@?",
            showToggleSearch: "=?",
        };
        this.controller = SWPaginationBarController;
        this.controllerAs = "swPaginationBar";
    }
    SWPaginationBar.Factory = function () {
        var _this = this;
        return /** @ngInject */ function () { return new _this(); };
    };
    return SWPaginationBar;
}());
exports.SWPaginationBar = SWPaginationBar;


/***/ }),

/***/ "VTDN":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWEntityActionBarButtonGroup = void 0;
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWEntityActionBarButtonGroupController = /** @class */ (function () {
    // @ngInject;
    function SWEntityActionBarButtonGroupController() {
    }
    return SWEntityActionBarButtonGroupController;
}());
var SWEntityActionBarButtonGroup = /** @class */ (function () {
    function SWEntityActionBarButtonGroup() {
        this.restrict = 'E';
        this.scope = {};
        this.transclude = true;
        this.bindToController = {};
        this.controller = SWEntityActionBarButtonGroupController;
        this.controllerAs = "swEntityActionBarButtonGroup";
        this.template = __webpack_require__("9QRl");
    }
    SWEntityActionBarButtonGroup.Factory = function () {
        var _this = this;
        return /** @ngInject; */ function () { return new _this(); };
    };
    return SWEntityActionBarButtonGroup;
}());
exports.SWEntityActionBarButtonGroup = SWEntityActionBarButtonGroup;


/***/ }),

/***/ "Vfql":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWValidationUnique = void 0;
var SWValidationUnique = /** @class */ (function () {
    //@ngInject
    SWValidationUnique.$inject = ["$http", "$q", "$hibachi", "$log", "validationService"];
    function SWValidationUnique($http, $q, $hibachi, $log, validationService) {
        return {
            restrict: "A",
            require: ["ngModel", "^?swFormField"],
            link: function (scope, element, attributes, controllers) {
                var ngModel = controllers[0];
                ngModel.$asyncValidators.swvalidationunique = function (modelValue, viewValue) {
                    var currentValue = modelValue || viewValue;
                    var property = controllers[1].property;
                    return validationService.validateUnique(currentValue, controllers[1].object, property);
                };
            }
        };
    }
    SWValidationUnique.Factory = function () {
        var directive = function ($http, $q, $hibachi, $log, validationService) { return new SWValidationUnique($http, $q, $hibachi, $log, validationService); };
        directive.$inject = ['$http', '$q', '$hibachi', '$log', 'validationService'];
        return directive;
    };
    return SWValidationUnique;
}());
exports.SWValidationUnique = SWValidationUnique;


/***/ }),

/***/ "Vhuo":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWDraggable = void 0;
var SWDraggableController = /** @class */ (function () {
    //@ngInject
    function SWDraggableController() {
        if (angular.isUndefined(this.draggable)) {
            this.draggable = false;
        }
    }
    return SWDraggableController;
}());
var SWDraggable = /** @class */ (function () {
    //@ngInject
    SWDraggable.$inject = ["corePartialsPath", "utilityService", "draggableService", "hibachiPathBuilder"];
    function SWDraggable(corePartialsPath, utilityService, draggableService, hibachiPathBuilder) {
        var _this = this;
        this.corePartialsPath = corePartialsPath;
        this.utilityService = utilityService;
        this.draggableService = draggableService;
        this.hibachiPathBuilder = hibachiPathBuilder;
        this.restrict = 'EA';
        this.scope = {};
        this.bindToController = {
            //all fields required
            draggable: "=",
            draggableRecord: "=",
            draggableKey: "="
        };
        this.controller = SWDraggableController;
        this.controllerAs = "swDraggable";
        this.link = function (scope, element, attrs) {
            scope.$watch('swDraggable.draggable', function (newValue, oldValue) {
                angular.element(element).attr("draggable", newValue);
                var id = angular.element(element).attr("id");
                if (!id) {
                    id = _this.utilityService.createID(32);
                }
                if (newValue) {
                    element.bind("dragstart", function (e) {
                        e = e.originalEvent || e;
                        e.stopPropagation();
                        if (!scope.swDraggable.draggable)
                            return false;
                        element.addClass("s-dragging");
                        scope.swDraggable.draggableRecord.draggableStartKey = scope.swDraggable.draggableKey;
                        e.dataTransfer.setData("application/json", angular.toJson(scope.swDraggable.draggableRecord));
                        e.dataTransfer.effectAllowed = "move";
                        e.dataTransfer.setDragImage(element[0], 0, 0);
                    });
                    element.bind("dragend", function (e) {
                        e = e.originalEvent || e;
                        e.stopPropagation();
                        element.removeClass("s-dragging");
                    });
                }
                else {
                    element.unbind("dragstart");
                    element.unbind("dragged");
                }
            });
        };
    }
    SWDraggable.Factory = function () {
        var directive = function (corePartialsPath, utilityService, draggableService, hibachiPathBuilder) { return new SWDraggable(corePartialsPath, utilityService, draggableService, hibachiPathBuilder); };
        directive.$inject = [
            'corePartialsPath',
            'utilityService',
            'draggableService',
            'hibachiPathBuilder'
        ];
        return directive;
    };
    return SWDraggable;
}());
exports.SWDraggable = SWDraggable;


/***/ }),

/***/ "W1Ga":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWFFormController = exports.SWFForm = void 0;
/**
* Form Controller handles the logic for this directive.
*/
var SWFFormController = /** @class */ (function () {
    // @ngInject
    SWFFormController.$inject = ["$rootScope", "$scope", "$timeout", "$hibachi", "$element", "validationService", "hibachiValidationService", "observerService"];
    function SWFFormController($rootScope, $scope, $timeout, $hibachi, $element, validationService, hibachiValidationService, observerService) {
        var _this = this;
        this.$rootScope = $rootScope;
        this.$scope = $scope;
        this.$timeout = $timeout;
        this.$hibachi = $hibachi;
        this.$element = $element;
        this.validationService = validationService;
        this.hibachiValidationService = hibachiValidationService;
        this.observerService = observerService;
        this.fileFlag = false;
        this.uploadProgressPercentage = 0;
        this.$onInit = function () {
        };
        this.resetMethod = function (newMethod) {
            _this.newMethod = newMethod;
        };
        this.getFormData = function () {
            var formData = {};
            for (var key in _this.form) {
                if (key.indexOf('$') == -1) {
                    formData[key] = _this.form[key].$modelValue || _this.form[key].$viewValue;
                }
            }
            formData['returnJsonObjects'] = _this.returnJsonObjects;
            return formData;
        };
        this.calculateFileUploadProgress = function (xhr) {
            xhr.upload.addEventListener("progress", function (event) {
                if (event.lengthComputable) {
                    _this.$timeout(function () {
                        var uploadProgressPercentage = event.loaded / event.total;
                        _this.uploadProgressPercentage = Math.floor(uploadProgressPercentage * 100);
                    });
                }
            }, false);
        };
        this.getFileFromFormData = function (formData) {
            var _a;
            //currently supports just one file input
            var file;
            for (var key in formData) {
                if (formData[key]["size"]) { //the size attribute indicates it's a file, this can be improved
                    file = (_a = {
                            "fileName": formData[key].name
                        },
                        _a[key] = formData[key],
                        _a["propertyName"] = key,
                        _a);
                }
            }
            return file;
        };
        this.submitForm = function () {
            var method = _this.newMethod ? _this.newMethod : _this.method;
            if (_this.form.$valid) {
                _this.loading = true;
                var formData = _this.getFormData();
                if (_this.preFormPost && !_this.preFormPost(formData)) {
                    _this.loading = false;
                    return new Promise(function (reject) { return []; });
                }
                if (_this.closeModal && _this.modalId) {
                    $("#" + _this.modalId).modal('toggle');
                }
                if (_this.fileFlag) {
                    var file = _this.getFileFromFormData(formData);
                    return _this.uploadFile(_this.method, file).then(function (result) {
                        return _this.processResult(result);
                    });
                }
                return _this.$rootScope.slatwall.doAction(method, formData).then(function (result) {
                    return _this.processResult(result);
                });
            }
            _this.form.$setSubmitted(true);
            return new Promise(function (resolve, reject) { return []; });
        };
        this.uploadFile = function (action, data) {
            return new Promise(function (resolve, reject) {
                var url = _this.$rootScope.slatwall.appConfig.baseURL;
                //check if the caller is defining a path to hit, otherwise use the public scope.
                if (action.indexOf(":") !== -1) {
                    url = url + action; //any path
                }
                else {
                    url = _this.$rootScope.slatwall.baseActionPath + action; //public path
                }
                var formData = new FormData();
                formData.append("fileName", data.fileName);
                formData.append(data.propertyName, data[data.propertyName]);
                formData.append("returnJsonObjects", "cart,account");
                var xhr = new XMLHttpRequest();
                xhr.open('POST', url, true);
                _this.calculateFileUploadProgress(xhr);
                xhr.onload = function (result) {
                    var response = JSON.parse(xhr.response);
                    if (xhr.status === 200) {
                        _this.$rootScope.slatwall.processAction(response, null);
                        _this.successfulActions = response.successfulActions;
                        _this.failureActions = response.failureActions;
                        resolve(response);
                    }
                    else {
                        reject(response);
                    }
                };
                xhr.send(formData);
            });
        };
        this.processResult = function (result) {
            if (!result)
                return result;
            _this.$timeout(function () {
                _this.loading = false;
                if (_this.afterSubmitEventName) {
                    _this.observerService.notify(_this.afterSubmitEventName);
                }
                _this.successfulActions = result.successfulActions;
                _this.failureActions = result.failureActions;
                _this.errors = result.errors;
                if (result.errors && Object.keys(result.errors).length) {
                    _this.errorToDisplay = result.errors[Object.keys(result.errors)[0]][0]; //getting first key in object and first error in array
                }
                if (result.successfulActions.length) {
                    //if we have an array of actions and they're all complete, or if we have just one successful action
                    if (_this.sRedirectUrl) {
                        _this.$rootScope.slatwall.redirectExact(_this.sRedirectUrl);
                    }
                    if (_this.sAction) {
                        _this.sAction(result);
                    }
                    _this.form.$setSubmitted(false);
                    _this.form.$setPristine(true);
                }
                if (result.errors) {
                    if (_this.fRedirectUrl) {
                        _this.$rootScope.slatwall.redirectExact(_this.fRedirectUrl);
                    }
                    if (_this.fAction) {
                        _this.fAction();
                    }
                }
            });
            return result;
        };
    }
    return SWFFormController;
}());
exports.SWFFormController = SWFFormController;
var SWFForm = /** @class */ (function () {
    // @ngInject
    function SWFForm() {
        this.require = {
            form: '?^form',
            ngModel: '?^ngModel'
        };
        this.priority = 1000;
        this.restrict = "A";
        //needs to have false scope to not interfere with form controller
        this.scope = true;
        /**
         * Binds all of our variables to the controller so we can access using this
         */
        this.bindToController = {
            method: "@?",
            returnJsonObjects: '@?',
            sRedirectUrl: "@?",
            fRedirectUrl: "@?",
            sAction: "=?",
            fAction: "=?",
            fileFlag: "@?",
            afterSubmitEventName: "@?",
            closeModal: "@?",
            preFormPost: "<?",
            modalId: "@?",
        };
        this.controller = SWFFormController;
        this.controllerAs = "swfForm";
        /**
            * Sets the context of this form
            */
        this.link = function (scope, element, attrs, formController) {
        };
    }
    /**
     * Handles injecting the partials path into this class
     */
    SWFForm.Factory = function () {
        var directive = function () { return new SWFForm(); };
        directive.$inject = [];
        return directive;
    };
    return SWFForm;
}());
exports.SWFForm = SWFForm;


/***/ }),

/***/ "WUjD":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWModalLauncherController = exports.SWModalLauncher = void 0;
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWModalLauncherController = /** @class */ (function () {
    // @ngInject
    SWModalLauncherController.$inject = ["observerService"];
    function SWModalLauncherController(observerService) {
        var _this = this;
        this.observerService = observerService;
        this.hasSaveAction = false;
        this.hasCancelAction = false;
        this.hasDeleteAction = false;
        this.launchModal = function () {
            //this.showModal is only for use with custom template
            _this.showModal = true;
            //trigger bootstrap event to show modal
            $("#" + _this.modalName).modal(_this.modalOptions);
        };
        this.saveCallback = function () {
            //the passed save action must return a promise
            if (_this.hasSaveAction) {
                var savePromise = _this.saveAction()();
            }
            savePromise.then(function (response) {
                //if the action was sucessful
                $("#" + _this.modalName).modal('hide');
            }, function (reason) {
                //if the action failed
            });
        };
        this.deleteCallback = function () {
            //the passed save action must return a promise
            if (_this.hasDeleteAction) {
                var deletePromise = _this.saveAction()();
            }
            deletePromise.then(function (response) {
                //if the action was sucessful
                $("#" + _this.modalName).modal('hide');
            }, function (reason) {
                //if the action failed
            });
        };
        this.cancelCallback = function () {
            if (_this.hasCancelAction) {
                _this.cancelAction()();
            }
        };
        this.hasSaveAction = typeof this.saveAction === 'function';
        this.hasDeleteAction = typeof this.deleteAction === 'function';
        if (angular.isUndefined(this.hasCancelAction)) {
            this.hasCancelAction = true;
        }
        if (angular.isUndefined(this.saveDisabled)) {
            this.saveDisabled = false;
        }
        if (angular.isUndefined(this.showExit)) {
            this.showExit = true;
        }
        if (angular.isUndefined(this.showModal)) {
            this.showModal = false;
        }
        if (angular.isUndefined(this.saveActionText)) {
            this.saveActionText = "Save";
        }
        if (angular.isUndefined(this.cancelActionText)) {
            this.cancelActionText = "Cancel";
        }
        if (angular.isUndefined(this.modalOptions)) {
            this.modalOptions = {};
        }
        if (angular.isDefined(this.launchEventName)) {
            this.observerService.attach(this.launchModal, this.launchEventName);
        }
    }
    return SWModalLauncherController;
}());
exports.SWModalLauncherController = SWModalLauncherController;
var SWModalLauncher = /** @class */ (function () {
    function SWModalLauncher() {
        this.transclude = {
            button: '?swModalButton',
            staticButton: '?swModalStaticButton',
            content: '?swModalContent'
        };
        this.restrict = "EA";
        this.scope = {};
        this.bindToController = {
            modalOptions: "<?",
            showModal: "=?",
            showExit: "=?",
            launchEventName: "@?",
            modalName: "@",
            title: "@",
            saveDisabled: "=?",
            saveAction: "&?",
            deleteAction: "&?",
            cancelAction: "&?",
            saveActionText: "@?",
            cancelActionText: "@?",
            hasCancelAction: "=?"
        };
        this.controller = SWModalLauncherController;
        this.controllerAs = "swModalLauncher";
        this.template = __webpack_require__("2XT+");
        this.compile = function (element, attrs, transclude) {
            return {
                pre: function ($scope, element, attrs) {
                    if (angular.isDefined(attrs.saveAction)) {
                        $scope.swModalLauncher.hasSaveAction = true;
                    }
                    if (angular.isDefined(attrs.deleteAction)) {
                        $scope.swModalLauncher.hasDeleteAction = true;
                    }
                    if (angular.isDefined(attrs.cancelAction)) {
                        $scope.swModalLauncher.hasCancelAction = true;
                    }
                },
                post: function ($scope, element, attrs) {
                }
            };
        };
    }
    SWModalLauncher.Factory = function () {
        var _this = this;
        return /** @ngInject; */ function () { return new _this(); };
    };
    return SWModalLauncher;
}());
exports.SWModalLauncher = SWModalLauncher;


/***/ }),

/***/ "XAQP":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWValidationMinValue = void 0;
var SWValidationMinValue = /** @class */ (function () {
    function SWValidationMinValue(validationService) {
        return {
            restrict: "A",
            require: "^ngModel",
            link: function (scope, element, attributes, ngModel) {
                ngModel.$validators.swvalidationminvalue =
                    function (modelValue, viewValue) {
                        if (viewValue == null) {
                            return true;
                        }
                        return validationService.validateMinValue(viewValue, attributes.swvalidationminvalue);
                    };
            }
        };
    }
    SWValidationMinValue.Factory = function () {
        var directive = function (validationService) { return new SWValidationMinValue(validationService); };
        directive.$inject = ['validationService'];
        return directive;
    };
    return SWValidationMinValue;
}());
exports.SWValidationMinValue = SWValidationMinValue;


/***/ }),

/***/ "XFvX":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWValidationGte = void 0;
var SWValidationGte = /** @class */ (function () {
    function SWValidationGte(validationService) {
        return {
            restrict: "A",
            require: "^ngModel",
            link: function (scope, element, attributes, ngModel) {
                ngModel.$validators.swvalidationGte =
                    function (modelValue, viewValue) {
                        return validationService.validateGte(modelValue, attributes.swvalidationGte);
                    }; //<--end function
            } //<--end link
        };
    }
    SWValidationGte.Factory = function () {
        var directive = function (validationService) { return new SWValidationGte(validationService); };
        directive.$inject = ['validationService'];
        return directive;
    };
    return SWValidationGte;
}());
exports.SWValidationGte = SWValidationGte;


/***/ }),

/***/ "XXsx":
/***/ (function(module, exports) {

module.exports = "<a ng-click=\"swTypeaheadRemoveSelection.removeSelection()\" \n   ng-disabled=\"swTypeaheadRemoveSelection.disabled\" \n   title=\"\" \n   class=\"btn btn-default btn-xs\" \n   target=\"_self\">\n    <i class=\"fa fa-times\"></i>\n</a>";

/***/ }),

/***/ "XzNW":
/***/ (function(module, exports) {

module.exports = "\n<div class=\"btn-group\" ng-if=\"swActionCallerDropdown.type === 'button'\">\n\t<button class=\"btn {{swActionCallerDropdown.buttonClass}} dropdown-toggle btn-primary\" data-toggle=\"dropdown\">\n\t\t<i class=\"fa fa-{{swActionCallerDropdown.icon}}\"></i> <span ng-bind=\"swActionCallerDropdown.title\"></span> <span class=\"caret\"></span>\n\t</button>\n\t<ul class=\"dropdown-menu {{swActionCallerDropdown.dropdownClass}}\" ng-id=\"{{swActionCallerDropdown.dropdownId}}\" ng-transclude>\n\t</ul>\n</div>\n\n<li class=\"dropdown\" ng-if=\"swActionCallerDropDown.type === 'nav'\">\n\t<a href=\"##\" class=\"dropdown-toggle\"><i class=\"fa fa-{{swActionCallerDropDown.icon}}\"></i> <span ng-bind=\"swActionCallerDropDown.title\"></span> </a>\n\t<ul class=\"dropdown-menu {{swActionCallerDropDown.dropdownClass}}\" ng-id=\"{{swActionCallerDropDown.dropdownId}}\" ng-transclude>\n\t</ul>\n</li>\n\n<li ng-if=\"swActionCallerDropDown.type === 'sidenav'\">\n\t<a href=\"##\"><i class=\"fa fa-{{swActionCallerDropDown.icon}}\"></i> <span ng-bind=\"swActionCallerDropDown.title\"></span> <span class=\"fa arrow\"></span></a>\n\t<ul ng-id=\"{{swActionCallerDropDown.dropdownId}}\" ng-transclude>\n\t</ul>\n</li>";

/***/ }),

/***/ "Y7Lf":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWPropertyDisplayController = exports.SWPropertyDisplay = void 0;
var SWPropertyDisplayController = /** @class */ (function () {
    //@ngInject
    SWPropertyDisplayController.$inject = ["$filter", "utilityService", "$injector", "metadataService", "observerService", "publicService", "listingService"];
    function SWPropertyDisplayController($filter, utilityService, $injector, metadataService, observerService, publicService, listingService) {
        var _this = this;
        this.$filter = $filter;
        this.utilityService = utilityService;
        this.$injector = $injector;
        this.metadataService = metadataService;
        this.observerService = observerService;
        this.publicService = publicService;
        this.listingService = listingService;
        this.saved = false;
        this.$onInit = function () {
            var bindToControllerProps = _this.$injector.get('swPropertyDisplayDirective')[0].bindToController;
            for (var i in bindToControllerProps) {
                if (!_this[i] && _this.swForm && _this.swForm[i]) {
                    _this[i] = _this.swForm[i];
                }
            }
            _this.errors = {};
            _this.edited = false;
            _this.edit = _this.edit || _this.editing;
            _this.editing = _this.editing || _this.edit;
            _this.errorName = _this.errorName || _this.name;
            _this.initialValue = _this.object[_this.property];
            _this.propertyDisplayID = _this.utilityService.createID(32);
            if (angular.isUndefined(_this.showSave)) {
                _this.showSave = true;
            }
            if (angular.isUndefined(_this.inListingDisplay)) {
                _this.inListingDisplay = false;
            }
            if (angular.isUndefined(_this.rowSaveEnabled)) {
                _this.rowSaveEnabled = _this.inListingDisplay;
            }
            if (angular.isDefined(_this.revertToValue) && angular.isUndefined(_this.showRevert)) {
                _this.showRevert = true;
            }
            if (angular.isDefined(_this.revertToValue) && angular.isUndefined(_this.revertText)) {
                _this.revertText = _this.revertToValue;
            }
            if (angular.isUndefined(_this.showRevert)) {
                _this.showRevert = false;
            }
            if (angular.isUndefined(_this.rawFileTarget)) {
                _this.rawFileTarget = _this.property;
            }
            if (angular.isUndefined(_this.editing)) {
                _this.editing = false;
            }
            if (angular.isUndefined(_this.editable)) {
                _this.editable = true;
            }
            if (angular.isUndefined(_this.isHidden)) {
                _this.isHidden = false;
            }
            if (angular.isUndefined(_this.noValidate)) {
                _this.noValidate = false;
            }
            if (angular.isUndefined(_this.inModal)) {
                _this.inModal = false;
            }
            if (angular.isUndefined(_this.optionsArguments)) {
                _this.optionsArguments = {};
            }
            if ((_this.fieldType !== 'hidden' &&
                angular.isUndefined(_this.inListingDisplay)) ||
                (angular.isDefined(_this.inListingDisplay) && !_this.inListingDisplay)) {
                _this.showLabel = true;
            }
            else {
                _this.showLabel = false;
            }
            if (angular.isDefined(_this.pageRecord) && angular.isUndefined(_this.pageRecord.edited)) {
                _this.pageRecord.edited = false;
            }
            _this.applyFilter = function (model, filter) {
                try {
                    return _this.$filter(filter)(model);
                }
                catch (e) {
                    return model;
                }
            };
            //swfproperty logic
            if (angular.isUndefined(_this.fieldType) && _this.object && _this.object.metaData) {
                _this.fieldType = _this.metadataService.getPropertyFieldType(_this.object, _this.propertyIdentifier);
            }
            if (angular.isUndefined(_this.title) && _this.object && _this.object.metaData) {
                _this.labelText = _this.metadataService.getPropertyTitle(_this.object, _this.propertyIdentifier);
            }
            _this.labelText = _this.labelText || _this.title;
            _this.title = _this.title || _this.labelText;
            _this.fieldType = _this.fieldType || "text";
            _this.class = _this.class || "form-control";
            _this.fieldAttributes = _this.fieldAttributes || "";
            _this.label = _this.label || "true";
            _this.labelText = _this.labelText || "";
            _this.labelClass = _this.labelClass || "";
            _this.name = _this.name || "unnamed";
            _this.value = _this.value || _this.initialValue;
            _this.object = _this.object || _this.swForm.object; //this is the process object
            /** handle options */
            if (_this.options && angular.isString(_this.options)) {
                var optionsArray = [];
                optionsArray = _this.options.toString().split(",");
                angular.forEach(optionsArray, function (o) {
                    var newOption = {
                        name: "",
                        value: ""
                    };
                    newOption.name = o;
                    newOption.value = o;
                    _this.optionValues.push(newOption);
                });
            }
            /** handle turning the options into an array of objects */
            /** handle setting the default value for the yes / no element  */
            if (_this.fieldType == "yesno" && (_this.value && angular.isString(_this.value))) {
                _this.selected == _this.value;
            }
            if (angular.isUndefined(_this.hint) && _this.object && _this.object.metaData) {
                _this.hint = _this.metadataService.getPropertyHintByObjectAndPropertyIdentifier(_this.object, _this.propertyIdentifier);
            }
            if ((_this.hasOnChangeCallback || _this.inListingDisplay || _this.onChangeEvent) &&
                (angular.isDefined(_this.swForm) && angular.isDefined(_this.name))) {
                _this.swInputOnChangeEvent = _this.swForm.name + _this.name + 'change';
                _this.observerService.attach(_this.onChange, _this.swInputOnChangeEvent);
            }
            if (_this.object && _this.propertyIdentifier) {
                _this.updateAuthInfo = true;
                // if(this.object.$$isPersisted()){
                //     this.updateAuthInfo = this.publicService.authenticateEntityProperty('Update',this.object.className,this.propertyIdentifier);
                // }else{
                //     this.updateAuthInfo = this.publicService.authenticateEntityProperty('Create',this.object.className,this.propertyIdentifier);
                // }
            }
        };
        this.onChange = function (result) {
            _this.edited = true;
            if (_this.saved) {
                _this.saved = false;
            }
            if (_this.hasOnChangeCallback) {
                _this.onChangeCallback(result);
            }
            if (_this.inListingDisplay && _this.rowSaveEnabled) {
                _this.listingService.markEdited(_this.listingID, _this.pageRecordIndex, _this.propertyDisplayID, _this.save);
            }
            if (angular.isDefined(_this.onChangeEvent)) {
                _this.observerService.notify(_this.onChangeEvent, result);
            }
        };
        this.clear = function () {
            if (_this.reverted) {
                _this.reverted = false;
                _this.showRevert = true;
            }
            _this.edited = false;
            _this.object.data[_this.property] = _this.initialValue;
            if (_this.inListingDisplay && _this.rowSaveEnabled) {
                _this.listingService.markUnedited(_this.listingID, _this.pageRecordIndex, _this.propertyDisplayID);
            }
        };
        this.revert = function () {
            _this.showRevert = false;
            _this.reverted = true;
            _this.object.data[_this.property] = _this.revertToValue;
            _this.onChange();
        };
        this.save = function () {
            _this.observerService.notify('updateBindings');
            //do this eagerly to hide save will reverse if theres an error
            _this.edited = false;
            _this.saved = true;
            if (!_this.inModal) {
                _this.object.$$save().then(function (response) {
                    if (_this.hasSaveCallback) {
                        _this.saveCallback(response);
                    }
                }, function (reason) {
                    _this.edited = true;
                    _this.saved = false;
                });
            }
            else if (_this.hasModalCallback) {
                _this.modalCallback();
            }
        };
    }
    return SWPropertyDisplayController;
}());
exports.SWPropertyDisplayController = SWPropertyDisplayController;
var SWPropertyDisplay = /** @class */ (function () {
    //@ngInject
    function SWPropertyDisplay($compile, scopeService, coreFormPartialsPath, hibachiPathBuilder, swpropertyPartialPath) {
        var _this = this;
        this.$compile = $compile;
        this.scopeService = scopeService;
        this.coreFormPartialsPath = coreFormPartialsPath;
        this.hibachiPathBuilder = hibachiPathBuilder;
        this.swpropertyPartialPath = swpropertyPartialPath;
        this.require = { swForm: "?^swForm", form: "?^form" };
        this.restrict = 'AE';
        this.scope = {};
        this.bindToController = {
            //swfproperty scope
            name: "@?",
            errorName: "@?",
            class: "@?",
            edit: "@?",
            valueObject: "=?",
            valueObjectProperty: "=?",
            propertyIdentifier: "@?",
            valueOptions: "=?",
            fieldAttributes: "@?",
            label: "@?",
            labelText: "@?",
            labelClass: "@?",
            errorText: "@?",
            errorClass: "@?",
            formTemplate: "@?",
            eventAnnouncers: "@",
            hideErrors: '=?',
            value: "@?",
            //swpropertyscope
            property: "@?",
            object: "=?",
            editable: "=?",
            editing: "=?",
            isHidden: "=?",
            title: "=?",
            hint: "@?",
            options: "=?",
            optionsArguments: "=?",
            eagerLoadOptions: "=?",
            isDirty: "=?",
            onChangeCallback: "&?onChange",
            onChangeEvent: "@?",
            saveCallback: "&?",
            fieldType: "@?",
            rawFileTarget: "@?",
            binaryFileTarget: "@?",
            noValidate: "=?",
            inListingDisplay: "=?",
            inModal: "=?",
            modalCallback: "&?",
            hasModalCallback: "=?",
            rowSaveEnabled: "=?",
            revertToValue: "=?",
            revertText: "@?",
            showRevert: "=?",
            showSave: "=?",
            placeholderText: "@",
            placeholderRbKey: "@",
            inputAttributes: "@?",
            optionValues: "=?",
            eventListeners: "=?",
            context: "@?"
        };
        this.controller = SWPropertyDisplayController;
        this.controllerAs = "swPropertyDisplay";
        this.templateUrlPath = "propertydisplay.html";
        this.link = function ($scope, element, attrs, formController) {
            $scope.frmController = formController;
            $scope.swfPropertyDisplay = $scope.swPropertyDisplay;
            if (angular.isDefined(attrs.onChange)) {
                $scope.swPropertyDisplay.hasOnChangeCallback = true;
            }
            else {
                $scope.swPropertyDisplay.hasOnChangeCallback = false;
            }
            if (angular.isDefined(attrs.saveCallback)) {
                $scope.swPropertyDisplay.hasSaveCallback = true;
            }
            else {
                $scope.swPropertyDisplay.hasSaveCallback = false;
            }
            if (angular.isDefined($scope.swPropertyDisplay.inListingDisplay) && $scope.swPropertyDisplay.inListingDisplay) {
                var currentScope = _this.scopeService.getRootParentScope($scope, "pageRecord");
                if (angular.isDefined(currentScope["pageRecord"])) {
                    $scope.swPropertyDisplay.pageRecord = currentScope["pageRecord"];
                }
                var currentScope = _this.scopeService.getRootParentScope($scope, "pageRecordKey");
                if (angular.isDefined(currentScope["pageRecordKey"])) {
                    $scope.swPropertyDisplay.pageRecordIndex = currentScope["pageRecordKey"];
                }
                var currentScope = _this.scopeService.getRootParentScope($scope, "swListingDisplay");
                if (angular.isDefined(currentScope["swListingDisplay"])) {
                    $scope.swPropertyDisplay.listingID = currentScope["swListingDisplay"].tableID;
                }
            }
            if (angular.isDefined($scope.swPropertyDisplay.inModal) && $scope.swPropertyDisplay.inModal) {
                var modalScope = _this.scopeService.getRootParentScope($scope, "swModalLauncher");
                $scope.swPropertyDisplay.modalName = modalScope.swModalLauncher.modalName;
                if (angular.isFunction(modalScope.swModalLauncher.launchModal)) {
                    $scope.swPropertyDisplay.modalCallback = modalScope.swModalLauncher.launchModal;
                    $scope.swPropertyDisplay.hasModalCallback = true;
                }
            }
        };
        this.templateUrl = this.hibachiPathBuilder.buildPartialsPath(this.coreFormPartialsPath) + swpropertyPartialPath;
    }
    SWPropertyDisplay.Factory = function (swpropertyClass, swpropertyPartialPath) {
        var directive = function ($compile, scopeService, coreFormPartialsPath, hibachiPathBuilder) { return new swpropertyClass($compile, scopeService, coreFormPartialsPath, hibachiPathBuilder, 
        //not an inejctable don't add to $inject. This is in the form.module Factory implementation
        swpropertyPartialPath); };
        directive.$inject = ['$compile', 'scopeService', 'coreFormPartialsPath', 'hibachiPathBuilder'];
        return directive;
    };
    SWPropertyDisplay.$inject = ['coreFormPartialsPath', 'hibachiPathBuilder'];
    return SWPropertyDisplay;
}());
exports.SWPropertyDisplay = SWPropertyDisplay;


/***/ }),

/***/ "YFSW":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.EntityRBKey = void 0;
var EntityRBKey = /** @class */ (function () {
    function EntityRBKey() {
    }
    //@ngInject
    EntityRBKey.Factory = function (rbkeyService) {
        return function (text) {
            if (angular.isDefined(text) && angular.isString(text)) {
                text = text.replace('_', '').toLowerCase();
                text = rbkeyService.getRBKey('entity.' + text);
            }
            return text;
        };
    };
    EntityRBKey.Factory.$inject = ["rbkeyService"];
    return EntityRBKey;
}());
exports.EntityRBKey = EntityRBKey;


/***/ }),

/***/ "YMXA":
/***/ (function(module, exports) {

module.exports = "<div class=\"row s-table-footer\" >\n\t<div class=\"col-xs-4\" span ng-show=\"swPaginationBar.paginator.pageShow !== 'Auto'\">\n\t\t<div class=\"dataTables_info\" id=\"example3_info\" ng-show=\"swPaginationBar.paginator.pageStart > 0\">\n\t\t\tShowing \n\t\t\t<b>\n\t\t\t\t<span ng-bind=\"swPaginationBar.paginator.pageStart\">\n\t\t\t\t\t<!-- records start -->\n\t\t\t\t</span>\n\t\t\tto <!--records end -->\n\t\t\t\t<!--a. Total Count of Records view - Retains previous functionality -->\n\t\t\t\t<span ng-if=\"swPaginationBar.paginator.limitCountTotal === 0\">\n\t\t\t\t\t<span ng-bind=\"swPaginationBar.paginator.pageStart + swPaginationBar.paginator.pageEnd - 1\"></span>\n\t\t\t\tof\n\t\t\t\t\t<span ng-bind=\"swPaginationBar.paginator.recordsCount\"></span>\n\t\t\t\t</span>\n\t\t\t</b> \n\t\t\t\t<!--b. Default view-->\n\t\t\t\t<span ng-if=\"swPaginationBar.paginator.limitCountTotal > 0\"> \n\t\t\t\t\t<span ng-if=\"swPaginationBar.paginator.pageEnd < swPaginationBar.paginator.selectedPageShowOption.display\" ng-bind=\"swPaginationBar.paginator.pageStart + swPaginationBar.paginator.recordsCount - 1\"></span> \n\t\t\t\t\t<span ng-if=\"swPaginationBar.paginator.pageEnd >= swPaginationBar.paginator.selectedPageShowOption.display\" ng-bind=\"swPaginationBar.paginator.pageEnd\"></span> \n\t\t\t\tof\n\t\t\t\t\t<!-- Display only 10 records by default and single left/right paging. -->\n\t\t\t\t\t<!-- For ex: Show exact number (ex: Showing 1 to 3 of 3 entries) if less than grid view count rows -->\n\t\t\t\t\t<span ng-if=\"swPaginationBar.paginator.pageEnd < swPaginationBar.paginator.selectedPageShowOption.display\" ng-bind=\"swPaginationBar.paginator.pageStart + swPaginationBar.paginator.recordsCount - 1\"></span> \n\t\t\t\t\t<!-- Display \"of many entries\" otherwise -->\n\t\t\t\t\t<span ng-if=\"swPaginationBar.paginator.pageEnd >= swPaginationBar.paginator.selectedPageShowOption.display\">many</span> \n\t\t\t\t</span>\n\t\t\tentries\n\t\t</div>\n\t</div>\n\t\n\t<div class=\"col-xs-8 s-table-footer-right\" > <!-- ng-if=\"swPaginationBar.paginator.recordsCount\" -->\n\t\t<ul class=\"list-inline list-unstyled\">\n\t\t    <li>\n\t\t        <form class=\"form-horizontal\">\n\t\t\n\t\t            <div class=\"form-group s-page-show\">\n\t\t                <label class=\"control-label col-xs-4\">View</label>\n\t\t                <div class=\"col-xs-5 s-no-padding-right\">\n\t\t                    <span class=\"s-select-wrapper\">\n\t\t                        <select size=\"1\" class=\"form-control input-sm\" name=\"pageShowOptions\" aria-controls=\"\" class=\"form-control\" \n\t\t                            ng-model=\"swPaginationBar.paginator.selectedPageShowOption\" \n\t\t                            ng-options=\"pageShowOption as pageShowOption.display for pageShowOption in swPaginationBar.paginator.pageShowOptions\"\n\t\t                            ng-change=\"swPaginationBar.paginator.pageShowOptionChanged(swPaginationBar.paginator.getSelectedPageShowOption())\">\n\t\t                        </select>\n\t\t                    </span>\n\t\t\t\t\t\t</div>\n\t\t                <div class=\"col-xs-3 s-no-padding-right\">\n\t\t\t\t\t\t\t<!-- Documentation: Optional toggle flag to fetch all records  ng-show=\"swPaginationBar.paginationService.showToggleDisplayOptions\" -->\n\t\t\t\t\t\t\t<span sw-tooltip class=\"col-xs-5 tool-tip-item\" data-text=\"Toggle Records Count\" data-position=\"right\">\n\t\t\t\t\t\t\t\t<button class=\"btn btn-sm btn-default\" type=\"button\" data-ng-click=\"swPaginationBar.toggleCountLimit(); $event.stopPropagation();\">\n\t\t\t\t\t\t\t\t\t<i class=\"fa fa-list\" ng-if=\"swPaginationBar.limitCountTotal > 0\"></i>\n\t\t\t\t\t\t\t\t\t<i class=\"fa fa-list-alt\" ng-if=\"swPaginationBar.limitCountTotal === 0\"></i>\n\t\t\t\t\t\t\t\t</button>\n\t\t\t\t\t\t\t</span>\n\t\t\t\t\t\t</div>\n\t\t            </div>\n\t\t        </form>\n\t\t    </li>\n\t\t\t<li > <!-- ng-if=\"swPaginationBar.paginator.recordsCount > swPaginationBar.paginator.pageShow\" -->\n\t\t\t\t<!-- \n\t\t\t\t\n\t\t\t\tThe check swPaginationBar.paginator.pageShowOptions.selectedPageShowOption.value below\n\t\t\t\t+++++always returns empty - so seems like the below check is redundant as it stands now. \n\t\t\t\tMay need to use .display? or pageshow\n\t\t\t\t----<span ng-bind=\"swPaginationBar.paginator.pageShow\"></span>====\n\t\t\t\t++++<span ng-bind=\"swPaginationBar.paginator.selectedPageShowOption.display\"></span>\n\t\t\t\t-->\n\t\t        <ul class=\"pagination pagination-sm\" ng-show=\"swPaginationBar.paginator.pageShowOptions.selectedPageShowOption.value !== 'Auto'\">\n\t\t            <li ng-class=\"{disabled:swPaginationBar.paginator.hasPrevious()}\">\n\t\t                <a href=\"javascript:void(0)\" ng-click=\"swPaginationBar.paginator.previousPage(); $event.stopPropagation();\" >&laquo;</a>\n\t\t            </li>\n\t\t\t\t\t<!-- For now, commenting this functionality on the html only. Since any search result beyond 250 isn't going to be navigable/UX friendly using these buttons, this may need to be removed in slatwall core merge. Encourage useers to further filter down search criteria instead.\n\t\t\t\t\t\n\t\t\t\t\t<li ng-show=\"swPaginationBar.paginator.showPreviousJump()\">\n\t\t                <a ng-click=\"swPaginationBar.paginator.setCurrentPage(1)\">1</a> <!-- FIRST PAGE --\n\t\t            </li>\n\t\t            <li ng-show=\"swPaginationBar.paginator.showPreviousJump()\" ng-click=\"swPaginationBar.paginator.previousJump()\">\n\t\t                <a href=\"#\">...</a> <!-- GO PREVIOUS PAGE BY 1 --\n\t\t\t\t\t</li>\n\t\t            <li ng-repeat=\"i in swPaginationBar.paginator.totalPagesArray\" ng-class=\"{active:swPaginationBar.paginator.getCurrentPage() === i}\" ng-click=\"swPaginationBar.paginator.setCurrentPage(i)\" ng-if=\"swPaginationBar.paginator.showPageNumber(i)\">\n\t\t                <a hreff=\"#\" ng-bind=\"i\"></a> <!--  ARRAY OF ALL PAGES - NOT VERY USEFUL WHEN ITS IN 10s --\n\t\t\t\t\t</li>\n\t\t            <li ng-show=\"swPaginationBar.paginator.showNextJump()\" ng-click=\"swPaginationBar.paginator.nextJump()\">\n\t\t                <a href=\"#\">...</a> <!--  GO NEXT PAGE BY 1 --\n\t\t            </li>\n\t\t            <li ng-show=\"swPaginationBar.paginator.showNextJump()\"> <!--  LAST PAGE --\n\t\t                <a href=\"#\" ng-click=\"swPaginationBar.paginator.setCurrentPage(swPaginationBar.paginator.getTotalPages())\" ng-bind=\"swPaginationBar.paginator.getTotalPages()\">\n\t\t\n\t\t                </a>\n\t\t            </li>\n\t\t\t\t\t-->\n\t\t            <li ng-class=\"{disabled:swPaginationBar.paginator.hasNext()}\">\n\t\t                <a href=\"javascript:void(0)\" ng-click=\"swPaginationBar.paginator.nextPage(); $event.stopPropagation();\">&raquo;</a>\n\t\t            </li>\n\t\t\n\t\t        </ul>\n\t\t    </li>\n\t\t\n\t\t    <!-- TODO: decide whether to implement this button or not at a later date\n\t\t\t  <li>\n\t\t\t\t<div class=\"btn-group\" class=\"navbar-left\">\n\t\t\t\t  <button type=\"button\" class=\"btn btn-sm btn-default\"><i class=\"fa fa-plus\"></i></button>\n\t\t\t\t</div>\n\t\t\t  </li> \n\t\t\t  -->\n\t\t</ul>\n\t</div>\n</div>\n";

/***/ }),

/***/ "YWup":
/***/ (function(module, exports) {

module.exports = "<span ng-mouseenter=\"swTooltip.show()\" ng-mouseleave=\"swTooltip.hide()\">\n<span ng-transclude></span>\n<div class=\"tooltip\" ng-class=\"{fade:swTooltip.showTooltip, in:swTooltip.showTooltip, {{swTooltip.position}}:swTooltip.showTooltip}\" ng-show=\"swTooltip.showTooltip\">\n    <div class=\"tooltip-arrow\"></div>    \n    <div class=\"tooltip-inner\"><span style=\"white-space: pre-wrap\" ng-bind=\"swTooltip.text\"></span></div>\n</div> \n</span>";

/***/ }),

/***/ "YkJ8":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWAddressForm = exports.SWAddressFormController = void 0;
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWAddressFormController = /** @class */ (function () {
    //@ngInject
    SWAddressFormController.$inject = ["$scope", "$log", "observerService", "$rootScope"];
    function SWAddressFormController($scope, $log, observerService, $rootScope) {
        var _this = this;
        this.$scope = $scope;
        this.$log = $log;
        this.observerService = observerService;
        this.$rootScope = $rootScope;
        this.showAddressBookSelect = false;
        this.showCountrySelect = true;
        this.showSubmitButton = true;
        this.showCloseButton = true;
        this.param = "?slataction=";
        this.showAlerts = "true";
        this.getAction = function () {
            if (!angular.isDefined(_this.action)) {
                _this.action = "addAddress";
            }
            if (_this.action.indexOf(":") != -1 && _this.action.indexOf(_this.param) == -1) {
                _this.action = _this.param + _this.action;
            }
            return _this.action;
        };
        this.hasField = function (field) {
            if (_this.fieldList.indexOf(field) != -1) {
                return true;
            }
            return false;
        };
        this.submitKeyCheck = function (event) {
            if (event.form.$name == _this.addressName &&
                event.event.keyCode == 13) {
                event.swForm.submit(event.swForm.action);
            }
        };
        //if exists, just name it slatwall.
        if (angular.isDefined(this.slatwallScope)) {
            this.slatwall = this.slatwallScope;
        }
        if (this.fieldList == undefined) {
            this.fieldList = "countryCode,name,company,streetAddress,street2Address,locality,city,stateCode,postalCode";
        }
        if (this.showAddressBookSelect == undefined) {
            this.showAddressBookSelect = false;
        }
        if (this.showCountrySelect == undefined) {
            this.showCountrySelect = true;
        }
        if (this.action == undefined) {
            this.showSubmitButton = false;
        }
        if ($rootScope.slatwall && !$scope.slatwall) {
            $scope.slatwall = $rootScope.slatwall;
        }
        var addressName = this.addressName;
        if (this.address) {
            this.address.getData = function () {
                var formData = _this.address || {};
                var form = _this.address.forms[addressName];
                for (var key_1 in form) {
                    var val = form[key_1];
                    if (typeof val === 'object' && val.hasOwnProperty('$modelValue')) {
                        if (val.$modelValue) {
                            val = val.$modelValue;
                        }
                        else if (val.$viewValue) {
                            val = val.$viewValue;
                        }
                        else {
                            val = "";
                        }
                        if (angular.isString(val)) {
                            formData[key_1] = val;
                        }
                        if (val.$modelValue) {
                            formData[key_1] = val.$modelValue;
                        }
                        else if (val.$viewValue) {
                            formData[key_1] = val.$viewValue;
                        }
                    }
                }
                return formData || "";
            };
        }
        if (!this.eventListeners) {
            this.eventListeners = {};
        }
        if (this.submitOnEnter) {
            this.eventListeners.keyup = this.submitKeyCheck;
        }
        if (this.eventListeners) {
            for (var key in this.eventListeners) {
                observerService.attach(this.eventListeners[key], key);
            }
        }
    }
    return SWAddressFormController;
}());
exports.SWAddressFormController = SWAddressFormController;
var SWAddressForm = /** @class */ (function () {
    // @ngInject
    SWAddressForm.$inject = ["coreFormPartialsPath", "hibachiPathBuilder"];
    function SWAddressForm(coreFormPartialsPath, hibachiPathBuilder) {
        var _this = this;
        this.coreFormPartialsPath = coreFormPartialsPath;
        this.hibachiPathBuilder = hibachiPathBuilder;
        this.transclude = true;
        this.controller = SWAddressFormController;
        this.controllerAs = 'SwAddressForm';
        this.bindToController = {
            action: '@',
            returnJsonObjects: '@?',
            actionText: '@',
            context: '@',
            customPartial: '@',
            slatwallScope: '=',
            address: "=",
            id: "@?",
            fieldNamePrefix: "@",
            fieldList: "@",
            fieldClass: "@",
            fulfillmentIndex: "@",
            tabIndex: "@",
            addressName: "@",
            showAddressBookSelect: "@",
            showCountrySelect: "@",
            showSubmitButton: "@",
            showCloseButton: "@",
            showAlerts: "@",
            eventListeners: "=?",
            submitOnEnter: "@",
            stateOptions: "=?"
        };
        this.scope = {};
        this.templateUrl = function (elem, attrs) {
            if (attrs.customPartial) {
                if (attrs.customPartial === "true") {
                    return hibachiConfig.customPartialsPath + "addressform.html";
                }
                else {
                    return hibachiConfig.customPartialsPath + attrs.customPartial;
                }
            }
            else {
                return _this.hibachiPathBuilder.buildPartialsPath(_this.coreFormPartialsPath) + "addressform.html";
            }
        };
    }
    /**
     * Handles injecting the partials path into this class
     */
    SWAddressForm.Factory = function () {
        var directive = function (coreFormPartialsPath, hibachiPathBuilder) { return new SWAddressForm(coreFormPartialsPath, hibachiPathBuilder); };
        directive.$inject = ['coreFormPartialsPath', 'hibachiPathBuilder'];
        return directive;
    };
    return SWAddressForm;
}());
exports.SWAddressForm = SWAddressForm;


/***/ }),

/***/ "YsSz":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.alertmodule = void 0;
/// <reference path='../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
//controllers
var alertcontroller_1 = __webpack_require__("OUJS");
//services
var alertservice_1 = __webpack_require__("Se2u");
var alertmodule = angular.module('hibachi.alert', [])
    //controllers
    .controller('alertController', alertcontroller_1.AlertController)
    //services
    .service('alertService', alertservice_1.AlertService);
exports.alertmodule = alertmodule;


/***/ }),

/***/ "ZI8f":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWRbKey = void 0;
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWRbKey = /** @class */ (function () {
    // 	@ngInject;
    SWRbKey.$inject = ["$hibachi", "observerService", "utilityService", "$rootScope", "$log", "rbkeyService"];
    function SWRbKey($hibachi, observerService, utilityService, $rootScope, $log, rbkeyService) {
        return {
            restrict: 'A',
            scope: {
                swRbkey: "="
            },
            link: function (scope, element, attrs) {
                var rbKeyValue = scope.swRbkey;
                var bindRBKey = function () {
                    if (angular.isDefined(rbKeyValue) && angular.isString(rbKeyValue)) {
                        element.text(rbkeyService.getRBKey(rbKeyValue, hibachiConfig.rbLocale));
                    }
                };
                bindRBKey();
            }
        };
    }
    SWRbKey.Factory = function () {
        var directive = function ($hibachi, observerService, utilityService, $rootScope, $log, rbkeyService) { return new SWRbKey($hibachi, observerService, utilityService, $rootScope, $log, rbkeyService); };
        directive.$inject = [
            '$hibachi',
            'observerService',
            'utilityService',
            '$rootScope',
            '$log',
            'rbkeyService'
        ];
        return directive;
    };
    return SWRbKey;
}());
exports.SWRbKey = SWRbKey;


/***/ }),

/***/ "ZT2N":
/***/ (function(module, exports) {

module.exports = "<ng-transclude ng-if=\"swLoading\" ></ng-transclude>\n<div class=\"s-loading-icon-fullwidth\">\n\t<i ng-show=\"!swLoading\" class=\"fa fa-refresh fa-spin\"></i>\n</div>";

/***/ }),

/***/ "ZbLJ":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.PageDialogController = void 0;
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var PageDialogController = /** @class */ (function () {
    //@ngInject
    PageDialogController.$inject = ["$scope", "$location", "$anchorScroll", "dialogService"];
    function PageDialogController($scope, $location, $anchorScroll, dialogService) {
        $scope.$id = 'pageDialogController';
        //get url param to retrieve collection listing
        $scope.pageDialogs = dialogService.getPageDialogs();
        $scope.scrollToTopOfDialog = function () {
            $location.hash('/#topOfPageDialog');
            $anchorScroll();
        };
        $scope.pageDialogStyle = { "z-index": 3000 };
    }
    return PageDialogController;
}());
exports.PageDialogController = PageDialogController;


/***/ }),

/***/ "Zcn6":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWTooltipController = exports.SWTooltip = void 0;
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWTooltipController = /** @class */ (function () {
    // @ngInject
    SWTooltipController.$inject = ["rbkeyService"];
    function SWTooltipController(rbkeyService) {
        var _this = this;
        this.rbkeyService = rbkeyService;
        this.showTooltip = false;
        this.show = function () {
            _this.showTooltip = true;
        };
        this.hide = function () {
            _this.showTooltip = false;
        };
        if (angular.isDefined(this.rbKey)) {
            this.text = rbkeyService.getRBKey(this.rbKey);
            this.text = this.text.replace(RegExp("\n", "g"), "\n");
        }
        if (angular.isUndefined(this.position)) {
            this.position = "top";
        }
    }
    return SWTooltipController;
}());
exports.SWTooltipController = SWTooltipController;
var SWTooltip = /** @class */ (function () {
    // @ngInject;
    SWTooltip.$inject = ["$document"];
    function SWTooltip($document) {
        this.$document = $document;
        this.transclude = true;
        this.restrict = "EA";
        this.scope = {};
        this.bindToController = {
            rbKey: "@?",
            text: "@?",
            position: "@?",
            showTooltip: "=?"
        };
        this.controller = SWTooltipController;
        this.controllerAs = "swTooltip";
        this.template = __webpack_require__("YWup");
        this.link = function (scope, element, attrs, controller, transclude) {
            var tooltip = element.find(".tooltip");
            var elementPosition = element.position();
            var tooltipStyle = tooltip[0].style;
            if (attrs && attrs.position) {
                switch (attrs.position.toLowerCase()) {
                    case 'top':
                        tooltipStyle.top = "0px";
                        tooltipStyle.left = "0px";
                        break;
                    case 'bottom':
                        //where the element is rendered to begin with
                        break;
                    case 'left':
                        tooltipStyle.top = (elementPosition.top + element[0].offsetHeight - 5) + "px";
                        tooltipStyle.left = (-1 * (elementPosition.left + element[0].offsetLeft - 5)) + "px";
                        element.find(".tooltip-inner")[0].style.maxWidth = "none";
                        break;
                    case 'right':
                        break;
                }
            }
        };
    }
    SWTooltip.Factory = function () {
        var _this = this;
        return /** @ngInject; */ ["$document", function ($document) { return new _this($document); }];
    };
    return SWTooltip;
}());
exports.SWTooltip = SWTooltip;


/***/ }),

/***/ "ZyaV":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWDirective = void 0;
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWDirective = /** @class */ (function () {
    //@ngInject
    SWDirective.$inject = ["$compile", "utilityService"];
    function SWDirective($compile, utilityService) {
        var _this = this;
        this.$compile = $compile;
        this.utilityService = utilityService;
        this.restrict = 'AE';
        //replace:true,
        this.scope = {
            variables: "=",
            directiveTemplate: "="
        };
        this.controllerAs = "swDirective";
        this.link = function (scope, element, attrs) {
            var tempVariables = {};
            angular.forEach(scope.variables, function (value, key) {
                if (key.toString().charAt(0) != "$" && value !== " ") {
                    tempVariables[_this.utilityService.keyToAttributeString(key)] = value;
                }
            });
            scope.variables = tempVariables;
            var template = '<' + scope.directiveTemplate + ' ';
            if (angular.isDefined(scope.variables)) {
                angular.forEach(scope.variables, function (value, key) {
                    if (!angular.isString(value) && !angular.isNumber(value)) {
                        template += ' ' + key + '="swDirective.' + 'variables.' + key + '" ';
                    }
                    else {
                        template += ' ' + key + '="' + value + '" ';
                    }
                });
            }
            template += '>';
            template += '</' + scope.directiveTemplate + '>';
            // Render the template.
            element.html(_this.$compile(template)(scope));
        };
    }
    SWDirective.Factory = function () {
        return /** @ngInject */ ["$compile", "utilityService", function ($compile, utilityService) { return new SWDirective($compile, utilityService); }];
    };
    return SWDirective;
}());
exports.SWDirective = SWDirective;


/***/ }),

/***/ "a+Nj":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWFDirective = exports.SWFDirectiveController = void 0;
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWFDirectiveController = /** @class */ (function () {
    //@ngInject
    SWFDirectiveController.$inject = ["$log", "$rootScope", "$scope"];
    function SWFDirectiveController($log, $rootScope, $scope) {
        this.$log = $log;
        this.$rootScope = $rootScope;
        this.$scope = $scope;
        this.$rootScope = $rootScope;
        this.hibachiScope = this.$rootScope.hibachiScope;
        $scope.slatwall = $rootScope.slatwall;
    }
    return SWFDirectiveController;
}());
exports.SWFDirectiveController = SWFDirectiveController;
var SWFDirective = /** @class */ (function () {
    // @ngInject
    SWFDirective.$inject = ["hibachiPathBuilder", "$compile"];
    function SWFDirective(hibachiPathBuilder, $compile) {
        var _this = this;
        this.restrict = 'E';
        this.bindToController = {
            variables: "=",
            directive: "=",
            templateUrl: "@"
        };
        this.controller = SWFDirectiveController;
        this.controllerAs = "SWFDirective";
        this.templatePath = "";
        this.url = "";
        /** allows you to build a directive without using another controller and directive config. */
        // @ngInject
        this.link = function (scope, element, attrs) {
            _this.scope = scope;
            _this.path = attrs.partialPath || _this.templatePath;
            //Developer specifies the path and name of a partial for creating a custom directive.
            if (attrs.partialName) {
                //returns the attrs.path or the default if not configured.
                var template = "<span ng-include = " + "'\"" + _this.path + attrs.partialName + ".html\"'";
                template += "></span>";
                element.html('').append(_this.$compile(template)(scope));
                //Recompile a directive either as attribute or element directive
            }
            else {
                //this.templateUrl = this.url;
                if (!attrs.type) {
                    attrs.type = "A";
                }
                if (attrs.type == "A" || !attrs.type) {
                    var template = '<span ' + attrs.directive + ' ';
                    if (angular.isDefined(_this.scope.variables)) {
                        angular.forEach(_this.scope.variables, function (value, key) {
                            if (!angular.isString(value) && !angular.isNumber(value)) {
                                template += ' ' + key + '="SWFDirective.' + 'variables.' + key + '" ';
                            }
                            else {
                                template += ' ' + key + '="' + value + '" ';
                            }
                        });
                    }
                    template += +'>';
                    template += '</span>';
                }
                else {
                    var template = '<' + attrs.directive + ' ';
                    if (_this.scope.variables) {
                        angular.forEach(_this.scope.variables, function (value, key) {
                            template += ' ' + key + '=' + value + ' ';
                        });
                    }
                    template += +'>';
                    template += '</' + attrs.directive + '>';
                }
                // Render the template.
                element.html('').append(_this.$compile(template)(scope));
                debugger;
            }
        };
        this.link.$inject = ["scope", "element", "attrs"];
        if (!hibachiConfig) {
            hibachiConfig = {};
        }
        if (!hibachiConfig.customPartialsPath) {
            hibachiConfig.customPartialsPath = 'custom/client/src/frontend/';
        }
        this.templatePath = hibachiConfig.customPartialsPath;
        this.url = hibachiConfig.customPartialsPath + 'swfdirectivepartial.html';
        this.$compile = $compile;
    }
    SWFDirective.Factory = function () {
        var directive = function (hibachiPathBuilder, $compile) { return new SWFDirective(hibachiPathBuilder, $compile); };
        directive.$inject = [
            'hibachiPathBuilder',
            '$compile'
        ];
        return directive;
    };
    return SWFDirective;
}());
exports.SWFDirective = SWFDirective;


/***/ }),

/***/ "a1Ym":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.AdminRequest = void 0;
/// <reference path='../../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../typings/tsd.d.ts' />
var request_1 = __webpack_require__("92bl");
var AdminRequest = /** @class */ (function (_super) {
    __extends(AdminRequest, _super);
    function AdminRequest(url, data, method, headers, $injector, observerService) {
        if (method === void 0) { method = "post"; }
        if (headers === void 0) { headers = { 'Content-Type': "application/json" }; }
        var _this = _super.call(this, url, data, method, headers, $injector) || this;
        _this.observerService = observerService;
        _this.observerService = observerService;
        _this.promise.then(function (result) {
            //identify that it is an object save
            if (url.indexOf('api:main.post') != -1 && data.entityName) {
                var eventNameBase = data.entityName + data.context.charAt(0).toUpperCase() + data.context.slice(1);
                if (result.errors) {
                    _this.observerService.notify(eventNameBase + 'Failure', result.data);
                }
                else {
                    _this.observerService.notify(eventNameBase + 'Success', result.data);
                }
            }
            _this.messages = result.messages;
        }).catch(function (response) {
        });
        return _this;
    }
    return AdminRequest;
}(request_1.Request));
exports.AdminRequest = AdminRequest;


/***/ }),

/***/ "arPg":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/**
 * @ngdoc service
 * @name sdt.models:ObserverService
 * @description
 * # ObserverService
 * Manages all events inside the application
 *
 */
var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.ObserverService = void 0;
var baseservice_1 = __webpack_require__("zg2S");
var ObserverService = /** @class */ (function (_super) {
    __extends(ObserverService, _super);
    //@ngInject
    ObserverService.$inject = ["$timeout", "historyService", "utilityService"];
    function ObserverService($timeout, historyService, utilityService) {
        var _this = 
        /**
         * @ngdoc property
         * @name ObserverService#observers
         * @propertyOf sdt.models:ObserverService
         * @description object to store all observers in
         * @returns {object} object
         */
        _super.call(this) || this;
        _this.$timeout = $timeout;
        _this.historyService = historyService;
        _this.utilityService = utilityService;
        /* Declare methods */
        /**
         * @ngdoc method
         * @name ObserverService#attach
         * @methodOf sdt.models:ObserverService
         * @param {function} callback the callback function to fire
         * @param {string} event name of the event
         * @param {string} id unique id for the object that is listening i.e. namespace
         * @description adds events listeners
         */
        _this.attach = function (callback, event, id) {
            if (!id) {
                id = _this.utilityService.createID();
            }
            event = (event === null || event === void 0 ? void 0 : event.toLowerCase()) || 'unknownevent';
            id = id === null || id === void 0 ? void 0 : id.toLowerCase();
            if (!_this.observers[event]) {
                _this.observers[event] = {};
            }
            if (!_this.observers[event][id])
                _this.observers[event][id] = [];
            _this.observers[event][id].push(callback);
        };
        /**
         * @ngdoc method
         * @name ObserverService#detachById
         * @methodOf sdt.models:ObserverService
         * @param {string} id unique id for the object that is listening i.e. namespace
         * @description removes all events for a specific id from the observers object
         */
        _this.detachById = function (id) {
            id = id.toLowerCase();
            for (var event in _this.observers) {
                _this.detachByEventAndId(event, id);
            }
        };
        /**
         * @ngdoc method
         * @name ObserverService#detachById
         * @methodOf sdt.models:ObserverService
         * @param {string} event name of the event
         * @description removes removes all the event from the observer object
         */
        _this.detachByEvent = function (event) {
            event = (event === null || event === void 0 ? void 0 : event.toLowerCase()) || 'unknownevent';
            if (event in _this.observers) {
                delete _this.observers[event];
            }
        };
        /**
         * @ngdoc method
         * @name ObserverService#detachByEventAndId
         * @methodOf sdt.models:ObserverService
         * @param {string} event name of the event
         * @param {string} id unique id for the object that is listening i.e. namespace
         * @description removes removes all callbacks for an id in a specific event from the observer object
         */
        _this.detachByEventAndId = function (event, id) {
            event = (event === null || event === void 0 ? void 0 : event.toLowerCase()) || 'unknownevent';
            id = id.toLowerCase();
            if (event in _this.observers) {
                if (id in _this.observers[event]) {
                    delete _this.observers[event][id];
                }
            }
        };
        /**
         * @ngdoc method
         * @name ObserverService#notify
         * @methodOf sdt.models:ObserverService
         * @param {string} event name of the event
         * @param {string|object|Array|number} parameters pass whatever your listener is expecting
         * @description notifies all observers of a specific event
         */
        _this.notify = function (event, parameters) {
            console.warn(event, parameters);
            event = (event === null || event === void 0 ? void 0 : event.toLowerCase()) || 'unknownevent';
            return _this.$timeout(function () {
                for (var id in _this.observers[event]) {
                    for (var _i = 0, _a = _this.observers[event][id]; _i < _a.length; _i++) {
                        var callback = _a[_i];
                        callback(parameters);
                    }
                }
            });
        };
        /**
         * @ngdoc method
         * @name ObserverService#notifyById
         * @methodOf sdt.models:ObserverService
         * @param {string} event name of the event
         * @param {string} eventId unique id for the object that is listening i.e. namespace
         * @param {string|object|Array|number} parameters pass whatever your listener is expecting
         * @description notifies observers of a specific event by id
         */
        _this.notifyById = function (event, eventId, parameters) {
            console.warn(event, eventId, parameters);
            event = (event === null || event === void 0 ? void 0 : event.toLowerCase()) || 'unknownevent';
            eventId = eventId.toLowerCase();
            return _this.$timeout(function () {
                for (var id in _this.observers[event]) {
                    if (id != eventId)
                        continue;
                    angular.forEach(_this.observers[event][id], function (callback) {
                        callback(parameters);
                    });
                }
            });
        };
        _this.notifyAndRecord = function (event, parameters) {
            return _this.notify(event, parameters).then(function () {
                _this.historyService.recordHistory(event, parameters, true);
            });
        };
        console.log('init obeserver');
        _this.observers = {};
        return _this;
    }
    return ObserverService;
}(baseservice_1.BaseService));
exports.ObserverService = ObserverService;


/***/ }),

/***/ "b0dy":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWTypeaheadSearchController = exports.SWTypeaheadSearch = void 0;
var SWTypeaheadSearchController = /** @class */ (function () {
    // @ngInject
    SWTypeaheadSearchController.$inject = ["$scope", "$q", "$transclude", "$hibachi", "$timeout", "utilityService", "observerService", "rbkeyService", "collectionConfigService", "typeaheadService", "$http", "requestService"];
    function SWTypeaheadSearchController($scope, $q, $transclude, $hibachi, $timeout, utilityService, observerService, rbkeyService, collectionConfigService, typeaheadService, $http, requestService) {
        var _this = this;
        this.$scope = $scope;
        this.$q = $q;
        this.$transclude = $transclude;
        this.$hibachi = $hibachi;
        this.$timeout = $timeout;
        this.utilityService = utilityService;
        this.observerService = observerService;
        this.rbkeyService = rbkeyService;
        this.collectionConfigService = collectionConfigService;
        this.typeaheadService = typeaheadService;
        this.$http = $http;
        this.requestService = requestService;
        this.results = [];
        this.columns = [];
        this.filters = [];
        this.searchableColumns = [];
        this.initialSearchableColumnsState = [];
        this.searchableColumnSelection = 'All';
        this.fallbackPropertyArray = [];
        this.clearSearch = function () {
            _this.searchText = "";
            _this.hideSearch = true;
            if (angular.isDefined(_this.addFunction)) {
                _this.addFunction()(undefined);
            }
        };
        this.toggleDropdown = function () {
            _this.dropdownOpen = !_this.dropdownOpen;
        };
        this.toggleOptions = function () {
            if (_this.hideSearch && (!_this.searchText || !_this.searchText.length)) {
                _this.search(_this.searchText, true);
            }
            _this.hideSearch = !_this.hideSearch;
        };
        /**
         * The actionCreator function for searching.
         */
        this.rSearch = function (search) {
            /**
             * Fire off an action that a search is happening.
             * Example action function. The dispatch takes a function, that sends data in a payload
             * to the reducer.
             */
            _this.typeaheadService.typeaheadStore.dispatch({
                "type": "TYPEAHEAD_QUERY",
                "payload": {
                    "searchText": search
                }
            });
        };
        this.search = function (search, allowEmptyKeyword) {
            if (search === void 0) { search = ''; }
            if (allowEmptyKeyword === void 0) { allowEmptyKeyword = false; }
            if (!search.length && !allowEmptyKeyword) {
                _this.closeThis();
                return;
            }
            _this.rSearch(search);
            if (_this._timeoutPromise) {
                _this.$timeout.cancel(_this._timeoutPromise);
                _this.loading = false;
            }
            _this.loading = true;
            _this.collectionConfig.setKeywords(search);
            if (angular.isDefined(_this.filterGroupsConfig)) {
                //allows for filtering on search text
                var filterConfig = _this.filterGroupsConfig.replace("replaceWithSearchString", search);
                filterConfig = filterConfig.trim();
                _this.collectionConfig.loadFilterGroups(JSON.parse(filterConfig));
            }
            _this._timeoutPromise = _this.$timeout(function () {
                var promise;
                if (_this.searchEndpoint) {
                    promise = _this.requestService.newPublicRequest('/' + _this.searchEndpoint, {
                        search: search,
                        options: _this.collectionConfig.getOptions(),
                        entityName: _this.collectionConfig.baseEntityName
                    }, 'post', {
                        'Content-Type': 'application/json'
                    }).promise;
                }
                else {
                    promise = _this.collectionConfig.getEntity();
                }
                promise.then(function (response) {
                    _this.results = response.pageRecords || response.records;
                    _this.updateSelections();
                }).finally(function () {
                    _this.resultsDeferred.resolve();
                    _this.hideSearch = (_this.results.length == 0);
                    _this.loading = false;
                });
            }, 500);
        };
        this.updateSelections = function () {
            _this.typeaheadService.updateSelections(_this.typeaheadDataKey);
        };
        this.updateCollectionConfigWithSearchableColumns = function () {
            var newColumns = _this.collectionConfig.columns
                .map(function (column) {
                //try to find that(column with same prop identifier) in our searchable columns
                var existingColumFromSearchableColumns = _this.searchableColumns.find(function (searchableColum) {
                    return column['propertyIdentifier'] === searchableColum['propertyIdentifier'];
                });
                if (existingColumFromSearchableColumns) {
                    return angular.copy(existingColumFromSearchableColumns);
                }
                return angular.copy(column);
            });
            _this.collectionConfig.loadColumns(newColumns);
        };
        this.updateSearchableProperties = function (column) {
            if (angular.isString(column) && column == 'all') {
                angular.copy(_this.initialSearchableColumnsState, _this.searchableColumns); //need to insure that these changes are actually on the collectionconfig
                _this.searchableColumnSelection = 'All';
            }
            else {
                angular.forEach(_this.searchableColumns, function (value, key) {
                    value.isSearchable = false;
                });
                column.isSearchable = true;
                _this.searchableColumnSelection = column.title;
            }
            _this.updateCollectionConfigWithSearchableColumns();
            _this.toggleDropdown();
            if (_this.searchText && _this.searchText.length) {
                _this.search(_this.searchText);
            }
        };
        this.addOrRemoveItem = function (item) {
            var remove = item.selected || false;
            if (!_this.hideSearch && !_this.multiselectMode) {
                _this.hideSearch = true;
            }
            if (!_this.multiselectMode) {
                if (angular.isDefined(_this.propertyToShow)) {
                    _this.searchText = item[_this.propertyToShow];
                }
                else if (angular.isDefined(_this.columns) &&
                    _this.columns.length &&
                    angular.isDefined(_this.columns[0].propertyIdentifier)) {
                    _this.searchText = item[_this.columns[0].propertyIdentifier];
                }
            }
            if (!remove && angular.isDefined(_this.addFunction)) {
                _this.observerService.notifyById('typeahead_add_item', _this.typeaheadDataKey, item);
                _this.addFunction()(item);
            }
            if (remove && angular.isDefined(_this.removeFunction)) {
                _this.observerService.notifyById('typeahead_remove_item', _this.typeaheadDataKey, item);
                _this.removeFunction()(item.selectedIndex);
                item.selected = false;
                item.selectedIndex = undefined;
            }
            _this.updateSelections();
        };
        this.addButtonItem = function () {
            if (!_this.hideSearch) {
                _this.hideSearch = true;
            }
            if (angular.isDefined(_this.addButtonFunction)) {
                _this.addButtonFunction()(_this.searchText);
            }
        };
        this.viewButtonClick = function () {
            _this.viewFunction()();
        };
        this.closeThis = function (clickOutsideArgs) {
            _this.hideSearch = true;
            if (angular.isDefined(clickOutsideArgs)) {
                for (var callBackAction in clickOutsideArgs.callBackActions) {
                    clickOutsideArgs.callBackActions[callBackAction]();
                }
            }
        };
        this.getSelections = function () {
            return _this.typeaheadService.getData(_this.typeaheadDataKey);
        };
        this.dropdownOpen = false;
        this.requestService = requestService;
        //populates all needed variables
        this.$transclude($scope, function () { });
        this.resultsDeferred = $q.defer();
        this.resultsPromise = this.resultsDeferred.promise;
        if (this.typeaheadDataKey == null ||
            this.typeaheadDataKey.trim().length === 0) {
            this.typeaheadDataKey = this.utilityService.createID(32);
        }
        if (angular.isUndefined(this.disabled)) {
            this.disabled = false;
        }
        if (angular.isUndefined(this.multiselectMode)) {
            this.multiselectMode = false;
        }
        if (angular.isUndefined(this.searchOnLoad)) {
            this.searchOnLoad = true;
        }
        if (angular.isUndefined(this.searchText) || this.searchText == null) {
            this.searchText = "";
        }
        else if (this.searchOnLoad) {
            this.search(this.searchText);
        }
        if (angular.isUndefined(this.validateRequired)) {
            this.validateRequired = false;
        }
        if (angular.isUndefined(this.hideSearch)) {
            this.hideSearch = true;
        }
        if (angular.isUndefined(this.collectionConfig)) {
            if (angular.isDefined(this.entity)) {
                this.collectionConfig = collectionConfigService.newCollectionConfig(this.entity);
            }
            else {
                throw ("You did not pass the correct collection config data to swTypeaheadSearch");
            }
        }
        if (angular.isDefined(this.collectionConfig)) {
            this.primaryIDPropertyName = $hibachi.getPrimaryIDPropertyNameByEntityName(this.collectionConfig.baseEntityName);
        }
        if (angular.isDefined(this.fallbackPropertiesToCompare) &&
            this.fallbackPropertiesToCompare.length) {
            this.fallbackPropertyArray = this.fallbackPropertiesToCompare.split(",");
        }
        if (angular.isDefined(this.placeholderRbKey)) {
            this.placeholderText = this.rbkeyService.getRBKey(this.placeholderRbKey);
        }
        else if (angular.isUndefined(this.placeholderText)) {
            this.placeholderText = this.rbkeyService.getRBKey('define.search');
        }
        //init timeoutPromise for link
        this._timeoutPromise = this.$timeout(function () { }, 500);
        if (angular.isDefined(this.propertiesToDisplay)) {
            this.collectionConfig.addDisplayProperty(this.propertiesToDisplay.split(","));
        }
        angular.forEach(this.columns, function (column) {
            _this.collectionConfig.addDisplayProperty(column.propertyIdentifier, '', column);
        });
        angular.forEach(this.filters, function (filter) {
            _this.collectionConfig.addFilter(filter.propertyIdentifier, filter.comparisonValue, filter.comparisonOperator, filter.logicalOperator, filter.hidden);
        });
        if (angular.isUndefined(this.allRecords)) {
            this.allRecords = this.collectionConfig.allRecords;
        }
        this.collectionConfig.setAllRecords(this.allRecords);
        if (angular.isUndefined(this.maxRecords)) {
            this.maxRecords = 10;
        }
        this.collectionConfig.setPageShow(this.maxRecords);
        if (angular.isDefined(this.initialEntityId) && this.initialEntityId.length) {
            this.initialEntityCollectionConfig = collectionConfigService.newCollectionConfig(this.collectionConfig.baseEntityName);
            this.initialEntityCollectionConfig.loadColumns(this.collectionConfig.columns);
            var primaryIDProperty = $hibachi.getPrimaryIDPropertyNameByEntityName(this.initialEntityCollectionConfig.baseEntityName);
            this.initialEntityCollectionConfig.addFilter(primaryIDProperty, this.initialEntityId, "=");
            var promise = this.initialEntityCollectionConfig.getEntity();
            promise.then(function (response) {
                _this.results = response.pageRecords;
                if (_this.results.length) {
                    _this.addOrRemoveItem(_this.results[0]);
                }
            });
        }
        angular.forEach(this.collectionConfig.columns, function (value, key) {
            if (value.isSearchable) {
                _this.searchableColumns.push(value);
            }
        });
        //need to insure that these changes are actually on the collectionconfig
        angular.copy(this.searchableColumns, this.initialSearchableColumnsState);
        this.typeaheadService.setTypeaheadState(this.typeaheadDataKey, this);
        this.observerService.attach(this.clearSearch, this.typeaheadDataKey + 'clearSearch');
        this.$http = $http;
    }
    return SWTypeaheadSearchController;
}());
exports.SWTypeaheadSearchController = SWTypeaheadSearchController;
var SWTypeaheadSearch = /** @class */ (function () {
    // @ngInject;
    SWTypeaheadSearch.$inject = ["$compile", "typeaheadService"];
    function SWTypeaheadSearch($compile, typeaheadService) {
        var _this = this;
        this.$compile = $compile;
        this.typeaheadService = typeaheadService;
        this.template = __webpack_require__("iUpN");
        this.transclude = true;
        this.restrict = "EA";
        this.scope = {};
        this.bindToController = {
            collectionConfig: "=?",
            entity: "@?",
            properties: "@?",
            propertiesToDisplay: "@?",
            filterGroupsConfig: "@?",
            placeholderText: "@?",
            placeholderRbKey: "@?",
            propertyToCompare: "@?",
            fallbackPropertiesToCompare: "@?",
            searchText: "=?",
            searchOnLoad: "=?",
            results: "=?",
            addFunction: "&?",
            removeFunction: "&?",
            addButtonFunction: "&?",
            viewFunction: "&?",
            showAddButton: "=?",
            showViewButton: "=?",
            validateRequired: "=?",
            uniqueResults: "<?",
            clickOutsideArguments: "=?",
            propertyToShow: "=?",
            hideSearch: "=?",
            allRecords: "=?",
            maxRecords: "=?",
            disabled: "=?",
            initialEntityId: "@",
            multiselectMode: "=?",
            typeaheadDataKey: "@?",
            rightContentPropertyIdentifier: "@?",
            searchEndpoint: "@?",
            allResultsEndpoint: "@?",
            titleText: '@?',
            urlBase: '@?',
            urlProperty: '@?'
        };
        this.controller = SWTypeaheadSearchController;
        this.controllerAs = "swTypeaheadSearch";
        this.compile = function (element, attrs, transclude) {
            return {
                pre: function ($scope, element, attrs) {
                    if (angular.isDefined(attrs.addButtonFunction) && angular.isUndefined(attrs.showAddButton)) {
                        $scope.swTypeaheadSearch.showAddButton = true;
                    }
                    else if (angular.isUndefined(attrs.showAddButton)) {
                        $scope.swTypeaheadSearch.showAddButton = false;
                    }
                    if (angular.isDefined(attrs.viewFunction) && angular.isUndefined(attrs.showViewButton)) {
                        $scope.swTypeaheadSearch.showViewButton = true;
                    }
                    else if (angular.isUndefined(attrs.showViewButton)) {
                        $scope.swTypeaheadSearch.showViewButton = false;
                    }
                },
                post: function ($scope, element, attrs) {
                    var target = element.find(".dropdown-menu");
                    var uniqueFilter = '';
                    if ($scope.swTypeaheadSearch.uniqueResults) {
                        uniqueFilter = " | unique:'" + _this.typeaheadService.getTypeaheadPrimaryIDPropertyName($scope.swTypeaheadSearch.typeaheadDataKey) + "'";
                    }
                    var listItemTemplateString = "\n                    <li ng-repeat=\"item in swTypeaheadSearch.results" + uniqueFilter + "\" class=\"dropdown-item\" ng-class=\"{'s-selected':item.selected}\"></li>\n                ";
                    var anchorTemplateString = "\n                    <a \n                ";
                    if (angular.isDefined($scope.swTypeaheadSearch.urlBase) &&
                        angular.isDefined($scope.swTypeaheadSearch.urlProperty)) {
                        anchorTemplateString += 'href="' + $scope.swTypeaheadSearch.urlBase + '{{item.' + $scope.swTypeaheadSearch.urlProperty + '}}">';
                    }
                    else {
                        anchorTemplateString += 'ng-click="swTypeaheadSearch.addOrRemoveItem(item)">';
                    }
                    if (angular.isDefined($scope.swTypeaheadSearch.rightContentPropertyIdentifier)) {
                        var rightContentTemplateString = "\n                        <span class=\"s-right-content\" ng-bind=\"item[swTypeaheadSearch.rightContentPropertyIdentifier]\"></span></a>\n                    ";
                    }
                    else {
                        var rightContentTemplateString = "</a>";
                    }
                    if (angular.isDefined($scope.swTypeaheadSearch.allResultsEndpoint)) {
                        var searchAllListItemTemplate = "\n                        <li class=\"dropdown-item see-all-results\" ng-if=\"swTypeaheadSearch.results.length == swTypeaheadSearch.maxRecords\"><a href=\"{{swTypeaheadSearch.allResultsEndpoint}}?keywords={{swTypeaheadSearch.searchText}}\">See All Results</a></li>\n                    ";
                    }
                    anchorTemplateString = anchorTemplateString + rightContentTemplateString;
                    var listItemTemplate = angular.element(listItemTemplateString);
                    var anchorTemplate = angular.element(anchorTemplateString);
                    anchorTemplate.append(_this.typeaheadService.stripTranscludedContent(transclude($scope, function () { })));
                    listItemTemplate.append(anchorTemplate);
                    $scope.swTypeaheadSearch.resultsPromise.then(function () {
                        target.append(_this.$compile(listItemTemplate)($scope));
                        if (searchAllListItemTemplate != null) {
                            target.append(_this.$compile(searchAllListItemTemplate)($scope));
                        }
                    });
                }
            };
        };
    }
    SWTypeaheadSearch.Factory = function () {
        var _this = this;
        return /** @ngIngect */ function ($compile, typeaheadService) { return new _this($compile, typeaheadService); };
    };
    return SWTypeaheadSearch;
}());
exports.SWTypeaheadSearch = SWTypeaheadSearch;


/***/ }),

/***/ "bAFN":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWCollectionConfigAsProperty = void 0;
//'use strict';
var SWCollectionConfigAsPropertyController = /** @class */ (function () {
    //@ngInject
    SWCollectionConfigAsPropertyController.$inject = ["collectionConfigService", "utilityService", "observerService"];
    function SWCollectionConfigAsPropertyController(collectionConfigService, utilityService, observerService) {
        var _this = this;
        this.collectionConfigService = collectionConfigService;
        this.utilityService = utilityService;
        this.observerService = observerService;
        this.handleConfigChange = function (data) {
            _this.inputValue = angular.toJson(data.collectionConfig);
        };
        this.tableID = this.utilityService.createID();
        this.observerService.attach(this.handleConfigChange, 'swPaginationUpdate', this.tableID);
        if (this.value) {
            this.entityCollectionConfig = this.collectionConfigService.loadJson(this.value);
            return;
        }
        this.entityCollectionConfig = this.collectionConfigService.newCollectionConfig(this.baseEntityName);
    }
    return SWCollectionConfigAsPropertyController;
}());
var SWCollectionConfigAsProperty = /** @class */ (function () {
    // @ngInject
    SWCollectionConfigAsProperty.$inject = ["coreFormPartialsPath", "hibachiPathBuilder"];
    function SWCollectionConfigAsProperty(coreFormPartialsPath, hibachiPathBuilder) {
        this.coreFormPartialsPath = coreFormPartialsPath;
        this.hibachiPathBuilder = hibachiPathBuilder;
        this.restrict = 'E';
        this.scope = {};
        this.bindToController = {
            baseEntityName: "=",
            propertyName: "=",
            value: "=?",
        };
        this.controller = SWCollectionConfigAsPropertyController;
        this.controllerAs = "swCollectionConfigAsProperty";
        this.link = function (scope, element, attrs) { };
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(this.coreFormPartialsPath) + "collectionconfigasproperty.html";
    }
    SWCollectionConfigAsProperty.Factory = function () {
        var directive = function (coreFormPartialsPath, hibachiPathBuilder) { return new SWCollectionConfigAsProperty(coreFormPartialsPath, hibachiPathBuilder); };
        directive.$inject = ['coreFormPartialsPath', 'hibachiPathBuilder'];
        return directive;
    };
    return SWCollectionConfigAsProperty;
}());
exports.SWCollectionConfigAsProperty = SWCollectionConfigAsProperty;


/***/ }),

/***/ "bAfl":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.entitymodule = void 0;
/// <reference path='../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
//services
// import {AccountService} from "./services/accountservice";
// import {CartService} from "./services/cartservice";
// import {UtilityService} from "./services/utilityservice";
// import {SelectionService} from "./services/selectionservice";
// import {ObserverService} from "./services/observerservice";
// import {FormService} from "./services/formservice";
// import {MetaDataService} from "./services/metadataservice";
//controllers
var otherwisecontroller_1 = __webpack_require__("mJ79");
var routercontroller_1 = __webpack_require__("FtFI");
//directives
var swdetailtabs_1 = __webpack_require__("6k0T");
var swdetail_1 = __webpack_require__("HivG");
var swlist_1 = __webpack_require__("2lxJ");
var core_module_1 = __webpack_require__("pwA0");
var entitymodule = angular.module('hibachi.entity', ['ngRoute', core_module_1.coremodule.name])
    .config(['$routeProvider', '$injector', '$locationProvider', 'appConfig', function ($routeProvider, $injector, $locationProvider, appConfig) {
        //detect if we are in hashbang mode
        var vars = {};
        var parts = window.location.href.replace(/[?&]+([^=&]+)#([^/]*)/gi, function (m, key, value) {
            vars[key] = value;
        });
        if (vars.ng) {
            $locationProvider.html5Mode(false).hashPrefix('!');
        }
        var snakeToCapitalCase = function (s) {
            return s.charAt(0).toUpperCase() + s.replace(/(\-\w)/g, function (m) { return m[1].toUpperCase(); }).slice(1);
        };
        $routeProvider.when('/entity/:entityName/', {
            template: function (params) {
                var entityDirectiveExists = $injector.has('sw' + snakeToCapitalCase(params.entityName) + 'ListDirective');
                if (entityDirectiveExists) {
                    return '<sw-' + params.entityName.toLowerCase() + '-list></sw-' + params.entityName.toLowerCase() + '-list>';
                }
                else {
                    return '<sw-list></sw-list>';
                }
            },
            controller: 'routerController'
        }).when('/entity/:entityName/:entityID', {
            template: function (params) {
                var entityDirectiveExists = $injector.has('sw' + snakeToCapitalCase(params.entityName) + 'DetailDirective');
                if (entityDirectiveExists) {
                    return '<sw-' + params.entityName.toLowerCase() + '-detail></sw-' + params.entityName.toLowerCase() + '-detail>';
                }
                else {
                    return '<sw-detail></sw-detail>';
                }
            },
            controller: 'routerController',
        });
        //        .otherwise({
        //         //controller:'otherwiseController'
        //         templateUrl: appConfig.baseURL + '/admin/client/js/partials/otherwise.html',
        //     });
    }])
    .constant('coreEntityPartialsPath', 'entity/components/')
    //services
    //controllers
    .controller('otherwiseController', otherwisecontroller_1.OtherWiseController)
    .controller('routerController', routercontroller_1.RouterController)
    //filters
    //directives
    .directive('swDetail', swdetail_1.SWDetail.Factory())
    .directive('swDetailTabs', swdetailtabs_1.SWDetailTabs.Factory())
    .directive('swList', swlist_1.SWList.Factory());
exports.entitymodule = entitymodule;


/***/ }),

/***/ "bQOH":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWUnique = void 0;
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWUnique = /** @class */ (function () {
    function SWUnique() {
    }
    //@ngInject
    SWUnique.Factory = function () {
        var filterStub;
        filterStub = function (items, filterOn) {
            if (filterOn === false) {
                return items;
            }
            if ((filterOn || angular.isUndefined(filterOn)) && angular.isArray(items)) {
                var hashCheck = {}, newItems = [];
                var extractValueToCompare = function (item) {
                    if (angular.isDefined(item) && item[filterOn] != null) {
                        return item[filterOn];
                    }
                    return item;
                };
                angular.forEach(items, function (item) {
                    var isDuplicate = false;
                    for (var i = 0; i < newItems.length; i++) {
                        if (extractValueToCompare(newItems[i]) == extractValueToCompare(item)) {
                            isDuplicate = true;
                            break;
                        }
                    }
                    if (!isDuplicate) {
                        newItems.push(item);
                    }
                });
            }
            return newItems;
        };
        //filterStub.$stateful = true;
        return filterStub;
    };
    return SWUnique;
}());
exports.SWUnique = SWUnique;


/***/ }),

/***/ "cAYs":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.HibachiServiceDecorator = void 0;
var HibachiServiceDecorator = /** @class */ (function () {
    //@ngInject
    HibachiServiceDecorator.$inject = ["$delegate", "$http", "$timeout", "$log", "$rootScope", "$location", "$anchorScroll", "$q", "utilityService", "formService", "rbkeyService", "appConfig", "observerService", "hibachiValidationService", "attributeMetaData"];
    function HibachiServiceDecorator($delegate, $http, $timeout, $log, $rootScope, $location, $anchorScroll, $q, utilityService, formService, rbkeyService, appConfig, observerService, hibachiValidationService, attributeMetaData) {
        var _deferred = {};
        var _config = appConfig;
        var _jsEntities = {};
        var _jsEntityInstances = {};
        var entities = appConfig.modelConfig.entities, validations = appConfig.modelConfig.validations, defaultValues = appConfig.modelConfig.defaultValues;
        angular.forEach(entities, function (entity) {
            if (attributeMetaData && attributeMetaData[entity.className]) {
                var relatedAttributes = attributeMetaData[entity.className];
                for (var attributeSetCode in relatedAttributes) {
                    var attributeSet = relatedAttributes[attributeSetCode];
                    for (var attributeCode in attributeSet.attributes) {
                        var attribute = attributeSet.attributes[attributeCode];
                        attribute.attributeSet = attributeSet;
                        attribute.isAttribute = true;
                        $.extend(entity[attributeCode], attribute);
                    }
                }
            }
            $delegate['get' + entity.className] = function (options) {
                var entityInstance = $delegate.newEntity(entity.className);
                var entityDataPromise = $delegate.getEntity(entity.className, options);
                entityDataPromise.then(function (response) {
                    if (angular.isDefined(response.processData)) {
                        entityInstance.$$init(response.data);
                        var processObjectInstance = $delegate['new' + entity.className + '_' + options.processContext.charAt(0).toUpperCase() + options.processContext.slice(1)]();
                        processObjectInstance.$$init(response.processData);
                        processObjectInstance.data[entity.className.charAt(0).toLowerCase() + entity.className.slice(1)] = entityInstance;
                        entityInstance.processObject = processObjectInstance;
                    }
                    else {
                        if (entityInstance.populate) {
                            entityInstance.populate(response);
                        }
                        else {
                            entityInstance.$$init(response);
                        }
                    }
                });
                return {
                    promise: entityDataPromise,
                    value: entityInstance
                };
            };
            $delegate['new' + entity.className] = function () {
                //if we have the service then get the new instance from that
                var entityName = entity.className;
                var serviceName = entityName.charAt(0).toLowerCase() + entityName.slice(1) + 'Service';
                if (angular.element(document.body).injector().has(serviceName)) {
                    var entityService = angular.element(document.body).injector().get(serviceName);
                    if (entityService['new' + entity.className]) {
                        return entityService['new' + entity.className]();
                    }
                }
                return $delegate.newEntity(entity.className);
            };
            entity.isProcessObject = entity.className.indexOf('_') >= 0;
            _jsEntities[entity.className] = function () {
                this.validations = validations[entity.className];
                this.metaData = entity;
                this.metaData.className = entity.className;
                if (relatedAttributes) {
                    this.attributeMetaData = relatedAttributes;
                }
                if (entity.hb_parentPropertyName) {
                    this.metaData.hb_parentPropertyName = entity.hb_parentPropertyName;
                }
                if (entity.hb_childPropertyName) {
                    this.metaData.hb_childPropertyName = entity.hb_childPropertyName;
                }
                this.metaData.$$getRBKey = function (rbKey, replaceStringData) {
                    return rbkeyService.rbKey(rbKey, replaceStringData);
                };
                this.metaData.$$getPropertyTitle = function (propertyName) {
                    return _getPropertyTitle(propertyName, this);
                };
                this.metaData.$$getPropertyHint = function (propertyName) {
                    return _getPropertyHint(propertyName, this);
                };
                this.metaData.$$getManyToManyName = function (singularname) {
                    var metaData = this;
                    for (var i in metaData) {
                        if (metaData[i].singularname === singularname) {
                            return metaData[i].name;
                        }
                    }
                };
                this.metaData.$$getPropertyFieldType = function (propertyName) {
                    return _getPropertyFieldType(propertyName, this);
                };
                this.metaData.$$getPropertyFormatType = function (propertyName) {
                    if (this[propertyName])
                        return _getPropertyFormatType(propertyName, this);
                };
                this.metaData.$$getDetailTabs = function () {
                    var deferred = $q.defer();
                    var urlString = _config.baseURL + '/index.cfm/?' + appConfig.action + '=api:main.getDetailTabs&entityName=' + this.className;
                    var detailTabs = [];
                    $http.get(urlString)
                        .success(function (data) {
                        deferred.resolve(data);
                    }).error(function (reason) {
                        deferred.reject(reason);
                    });
                    return deferred.promise;
                };
                this.$$getFormattedValue = function (propertyName, formatType) {
                    return _getFormattedValue(propertyName, formatType, this);
                };
                this.data = {};
                this.modifiedData = {};
                var jsEntity = this;
                if (entity.isProcessObject) {
                    (function (entity) {
                        _jsEntities[entity.className].prototype = {
                            $$getID: function () {
                                return '';
                            },
                            $$getIDName: function () {
                                var IDNameString = '';
                                return IDNameString;
                            }
                        };
                    })(entity);
                }
                angular.forEach(entity, function (property) {
                    if (angular.isObject(property) && angular.isDefined(property.name)) {
                        if (defaultValues && defaultValues[entity.className] && defaultValues[entity.className][property.name] != null) {
                            jsEntity.data[property.name] = angular.copy(defaultValues[entity.className][property.name]);
                        }
                        else {
                            jsEntity.data[property.name] = undefined;
                        }
                    }
                });
            };
            _jsEntities[entity.className].prototype = {
                $$getPropertyByName: function (propertyName) {
                    return this['$$get' + propertyName.charAt(0).toUpperCase() + propertyName.slice(1)]();
                },
                $$isPersisted: function () {
                    return this.$$getID() !== '';
                },
                $$init: function (data) {
                    _init(this, data);
                },
                $$save: function () {
                    return _save(this);
                },
                $$delete: function () {
                    return _delete(this);
                },
                $$getValidationsByProperty: function (property) {
                    return _getValidationsByProperty(this, property);
                },
                $$getValidationByPropertyAndContext: function (property, context) {
                    return _getValidationByPropertyAndContext(this, property, context);
                },
                $$getTitleByPropertyIdentifier: function (propertyIdentifier) {
                    if (propertyIdentifier.split('.').length > 1) {
                        var listFirst = utilityService.listFirst(propertyIdentifier, '.');
                        var relatedEntityName = this.metaData[listFirst].cfc;
                        var exampleEntity = $delegate.newEntity(relatedEntityName);
                        return exampleEntity.$$getTitleByPropertyIdentifier(propertyIdentifier.replace(listFirst, ''));
                    }
                    return this.metaData.$$getPropertyTitle(propertyIdentifier);
                },
                $$getMetaData: function (propertyName) {
                    if (propertyName === undefined) {
                        return this.metaData;
                    }
                    else {
                        if (angular.isDefined(this.metaData[propertyName].name) && angular.isUndefined(this.metaData[propertyName].nameCapitalCase)) {
                            this.metaData[propertyName].nameCapitalCase = this.metaData[propertyName].name.charAt(0).toUpperCase() + this.metaData[propertyName].name.slice(1);
                        }
                        if (angular.isDefined(this.metaData[propertyName].cfc) && angular.isUndefined(this.metaData[propertyName].cfcProperCase)) {
                            this.metaData[propertyName].cfcProperCase = this.metaData[propertyName].cfc.charAt(0).toLowerCase() + this.metaData[propertyName].cfc.slice(1);
                        }
                        return this.metaData[propertyName];
                    }
                }
            };
            angular.forEach(relatedAttributes, function (attributeSet) {
                angular.forEach(attributeSet.attributes, function (attribute) {
                    if (attribute && attribute.attributeCode) {
                        Object.defineProperty(_jsEntities[entity.className].prototype, attribute.attributeCode, {
                            configurable: true,
                            enumerable: false,
                            get: function () {
                                if (attribute != null && this.data[attribute.attributeCode] == null) {
                                    return undefined;
                                }
                                return this.data[attribute.attributeCode];
                            },
                            set: function (value) {
                                this.data[attribute.attributeCode] = value;
                            }
                        });
                    }
                });
            });
            angular.forEach(entity, function (property) {
                if (angular.isObject(property) && angular.isDefined(property.name)) {
                    //if(angular.isUndefined(property.persistent)){
                    if (angular.isDefined(property.fieldtype)) {
                        if (['many-to-one'].indexOf(property.fieldtype) >= 0) {
                            _jsEntities[entity.className].prototype['$$get' + property.name.charAt(0).toUpperCase() + property.name.slice(1)] = function () {
                                var thisEntityInstance = this;
                                if (angular.isDefined(this['$$get' + this.$$getIDName().charAt(0).toUpperCase() + this.$$getIDName().slice(1)]())) {
                                    var options = {
                                        columnsConfig: angular.toJson([
                                            {
                                                "propertyIdentifier": "_" + this.metaData.className.toLowerCase() + "_" + property.name
                                            }
                                        ]),
                                        joinsConfig: angular.toJson([
                                            {
                                                "associationName": property.name,
                                                "alias": "_" + this.metaData.className.toLowerCase() + "_" + property.name
                                            }
                                        ]),
                                        filterGroupsConfig: angular.toJson([{
                                                "filterGroup": [
                                                    {
                                                        "propertyIdentifier": "_" + this.metaData.className.toLowerCase() + "." + this.$$getIDName(),
                                                        "comparisonOperator": "=",
                                                        "value": this.$$getID()
                                                    }
                                                ]
                                            }]),
                                        allRecords: true
                                    };
                                    var collectionPromise = $delegate.getEntity(entity.className, options);
                                    collectionPromise.then(function (response) {
                                        for (var i in response.records) {
                                            var entityInstance = $delegate.newEntity(thisEntityInstance.metaData[property.name].cfc);
                                            //Removed the array index here at the end of local.property.name.
                                            if (angular.isArray(response.records[i][property.name])) {
                                                entityInstance.$$init(response.records[i][property.name][0]);
                                            }
                                            else {
                                                entityInstance.$$init(response.records[i][property.name]); //Shouldn't have the array index'
                                            }
                                            thisEntityInstance['$$set' + property.name.charAt(0).toUpperCase() + property.name.slice(1)](entityInstance);
                                        }
                                    });
                                    return collectionPromise;
                                }
                                return null;
                            };
                            _jsEntities[entity.className].prototype['$$set' + property.name.charAt(0).toUpperCase() + property.name.slice(1)] = function (entityInstance) {
                                var thisEntityInstance = this;
                                var metaData = this.metaData;
                                var manyToManyName = '';
                                //if entityInstance is not passed in, clear related object
                                if (angular.isUndefined(entityInstance)) {
                                    if (angular.isDefined(thisEntityInstance.data[property.name])) {
                                        delete thisEntityInstance.data[property.name];
                                    }
                                    if (!thisEntityInstance.parents) {
                                        return;
                                    }
                                    for (var i = 0; i <= thisEntityInstance.parents.length; i++) {
                                        if (angular.isDefined(thisEntityInstance.parents[i]) && thisEntityInstance.parents[i].name == property.name.charAt(0).toLowerCase() + property.name.slice(1)) {
                                            thisEntityInstance.parents.splice(i, 1);
                                        }
                                    }
                                    return;
                                }
                                if (property.name === 'parent' + this.metaData.className) {
                                    var childName = 'child' + this.metaData.className;
                                    manyToManyName = entityInstance.metaData.$$getManyToManyName(childName);
                                }
                                else if (entityInstance.metaData) {
                                    manyToManyName = entityInstance.metaData.$$getManyToManyName(metaData.className.charAt(0).toLowerCase() + metaData.className.slice(1));
                                }
                                // else{
                                //     manyToManyName = entityInstance.metaData.$$getManyToManyName(metaData.className.charAt(0).toLowerCase() + metaData.className.slice(1));
                                // }
                                if (angular.isUndefined(thisEntityInstance.parents)) {
                                    thisEntityInstance.parents = [];
                                }
                                thisEntityInstance.parents.push(thisEntityInstance.metaData[property.name]);
                                if (angular.isDefined(manyToManyName) && manyToManyName.length) {
                                    if (angular.isUndefined(entityInstance.children)) {
                                        entityInstance.children = [];
                                    }
                                    var child = entityInstance.metaData[manyToManyName];
                                    if (entityInstance.children.indexOf(child) === -1) {
                                        entityInstance.children.push(child);
                                    }
                                    if (angular.isUndefined(entityInstance.data[manyToManyName])) {
                                        entityInstance.data[manyToManyName] = [];
                                    }
                                    entityInstance.data[manyToManyName].push(thisEntityInstance);
                                }
                                thisEntityInstance.data[property.name] = entityInstance;
                            };
                            if (property.name !== 'data' && property.name !== 'validations') {
                                Object.defineProperty(_jsEntities[entity.className].prototype, property.name, {
                                    configurable: true,
                                    enumerable: false,
                                    get: function () {
                                        if (this.data[property.name] == null) {
                                            return undefined;
                                        }
                                        return this.data[property.name];
                                    },
                                    set: function (value) {
                                        this['$$set' + property.name.charAt(0).toUpperCase() + property.name.slice(1)](value);
                                    }
                                });
                            }
                        }
                        else if (['one-to-many', 'many-to-many'].indexOf(property.fieldtype) >= 0) {
                            if (!property.singularname) {
                                throw ('need to define a singularname for ' + property.fieldtype);
                            }
                            _jsEntities[entity.className].prototype['$$add' + property.singularname.charAt(0).toUpperCase() + property.singularname.slice(1)] = function (entityInstance) {
                                if (angular.isUndefined(entityInstance)) {
                                    var entityInstance = $delegate.newEntity(this.metaData[property.name].cfc);
                                }
                                var metaData = this.metaData;
                                if (metaData[property.name].fieldtype === 'one-to-many') {
                                    entityInstance.data[metaData[property.name].fkcolumn.slice(0, -2)] = this;
                                }
                                else if (metaData[property.name].fieldtype === 'many-to-many') {
                                    var manyToManyName = entityInstance.metaData.$$getManyToManyName(metaData.className.charAt(0).toLowerCase() + this.metaData.className.slice(1));
                                    if (angular.isUndefined(entityInstance.data[manyToManyName])) {
                                        entityInstance.data[manyToManyName] = [];
                                    }
                                    entityInstance.data[manyToManyName].push(this);
                                }
                                if (angular.isDefined(metaData[property.name])) {
                                    if (angular.isDefined(entityInstance.metaData[metaData[property.name].fkcolumn.slice(0, -2)])) {
                                        if (angular.isUndefined(entityInstance.parents)) {
                                            entityInstance.parents = [];
                                        }
                                        entityInstance.parents.push(entityInstance.metaData[metaData[property.name].fkcolumn.slice(0, -2)]);
                                    }
                                    if (angular.isUndefined(this.children)) {
                                        this.children = [];
                                    }
                                    var child = metaData[property.name];
                                    if (this.children.indexOf(child) === -1) {
                                        this.children.push(child);
                                    }
                                }
                                if (angular.isUndefined(this.data[property.name])) {
                                    this.data[property.name] = [];
                                }
                                this.data[property.name].push(entityInstance);
                                return entityInstance;
                            };
                            _jsEntities[entity.className].prototype['$$get' + property.name.charAt(0).toUpperCase() + property.name.slice(1)] = function () {
                                var thisEntityInstance = this;
                                if (angular.isDefined(this['$$get' + this.$$getIDName().charAt(0).toUpperCase() + this.$$getIDName().slice(1)])) {
                                    var options = {
                                        filterGroupsConfig: angular.toJson([{
                                                "filterGroup": [
                                                    {
                                                        "propertyIdentifier": "_" + property.cfc.toLowerCase() + "." + property.fkcolumn.replace('ID', '') + "." + this.$$getIDName(),
                                                        "comparisonOperator": "=",
                                                        "value": this.$$getID()
                                                    }
                                                ]
                                            }]),
                                        allRecords: true
                                    };
                                    var collectionPromise = $delegate.getEntity(property.cfc, options);
                                    collectionPromise.then(function (response) {
                                        var entityInstances = [];
                                        for (var i in response.records) {
                                            var entityInstance = thisEntityInstance['$$add' + property.singularname.charAt(0).toUpperCase() + property.singularname.slice(1)]();
                                            entityInstance.$$init(response.records[i]);
                                            if (angular.isUndefined(thisEntityInstance[property.name])) {
                                                thisEntityInstance[property.name] = [];
                                            }
                                            entityInstances.push(entityInstance);
                                        }
                                        thisEntityInstance.data[property.name] = entityInstances;
                                    });
                                    return collectionPromise;
                                }
                            };
                            Object.defineProperty(_jsEntities[entity.className].prototype, property.name, {
                                configurable: true,
                                enumerable: false,
                                get: function () {
                                    if (this.data[property.name] == null) {
                                        return undefined;
                                    }
                                    return this.data[property.name];
                                },
                                set: function (value) {
                                    this.data[property.name] = [];
                                    if (angular.isArray(value)) {
                                        for (var i = 0; i < value.length; i++) {
                                            var item = value[i];
                                            var entityInstance = $delegate.newEntity(this.metaData[property.name].cfc);
                                            entityInstance.$$init(item);
                                            this['$$add' + property.singularname.charAt(0).toUpperCase() + property.singularname.slice(1)](entityInstance);
                                        }
                                    }
                                    else {
                                        var entityInstance = $delegate.newEntity(this.metaData[property.name].cfc);
                                        entityInstance.$$init(value);
                                        this['$$add' + property.singularname.charAt(0).toUpperCase() + property.singularname.slice(1)](entityInstance);
                                    }
                                }
                            });
                        }
                        else {
                            if (['id'].indexOf(property.fieldtype) >= 0) {
                                _jsEntities[entity.className].prototype['$$getID'] = function () {
                                    //this should retreive id from the metadata
                                    return this.data[this.$$getIDName()];
                                };
                                _jsEntities[entity.className].prototype['$$getIDName'] = function () {
                                    var IDNameString = property.name;
                                    return IDNameString;
                                };
                            }
                            if (property.name !== 'data' && property.name !== 'validations') {
                                Object.defineProperty(_jsEntities[entity.className].prototype, property.name, {
                                    configurable: true,
                                    enumerable: false,
                                    get: function () {
                                        if (this.data[property.name] == null) {
                                            return undefined;
                                        }
                                        return this.data[property.name];
                                    },
                                    set: function (value) {
                                        this.data[property.name] = value;
                                    }
                                });
                            }
                            _jsEntities[entity.className].prototype['$$get' + property.name.charAt(0).toUpperCase() + property.name.slice(1)] = function () {
                                return this.data[property.name];
                            };
                        }
                    }
                    else {
                        if (property.name !== 'data' && property.name !== 'validations') {
                            Object.defineProperty(_jsEntities[entity.className].prototype, property.name, {
                                configurable: true,
                                enumerable: false,
                                get: function () {
                                    if (this.data[property.name] == null) {
                                        return undefined;
                                    }
                                    return this.data[property.name];
                                },
                                set: function (value) {
                                    this.data[property.name] = value;
                                }
                            });
                        }
                        _jsEntities[entity.className].prototype['$$get' + property.name.charAt(0).toUpperCase() + property.name.slice(1)] = function () {
                            return this.data[property.name];
                        };
                    }
                    //}
                }
            });
        });
        $delegate.setJsEntities(_jsEntities);
        angular.forEach(_jsEntities, function (jsEntity) {
            var jsEntityInstance = new jsEntity;
            _jsEntityInstances[jsEntityInstance.metaData.className] = jsEntityInstance;
        });
        $delegate.setJsEntityInstances(_jsEntityInstances);
        var _init = function (entityInstance, data) {
            hibachiValidationService.init(entityInstance, data);
        };
        var _getPropertyTitle = function (propertyName, metaData) {
            return $delegate.getPropertyTitle(propertyName, metaData);
        };
        var _getPropertyHint = function (propertyName, metaData) {
            var propertyMetaData = metaData[propertyName];
            var keyValue = '';
            if (angular.isDefined(propertyMetaData['hb_rbkey'])) {
                keyValue = metaData.$$getRBKey(propertyMetaData['hb_rbkey'] + '_hint');
            }
            else if (angular.isUndefined(propertyMetaData['persistent']) || (angular.isDefined(propertyMetaData['persistent']) && propertyMetaData['persistent'] === true)) {
                keyValue = metaData.$$getRBKey('entity.' + metaData.className.toLowerCase() + '.' + propertyName.toLowerCase() + '_hint');
            }
            else {
                keyValue = metaData.$$getRBKey('object.' + metaData.className.toLowerCase() + '.' + propertyName.toLowerCase());
            }
            if (keyValue.slice(-8) !== '_missing') {
                return keyValue;
            }
            return '';
        };
        var _getPropertyFieldType = function (propertyName, metaData) {
            var propertyMetaData = metaData[propertyName];
            if (angular.isDefined(propertyMetaData['hb_formfieldtype'])) {
                return propertyMetaData['hb_formfieldtype'];
            }
            if (angular.isUndefined(propertyMetaData.fieldtype) || propertyMetaData.fieldtype === 'column') {
                var dataType = "";
                if (angular.isDefined(propertyMetaData.ormtype)) {
                    dataType = propertyMetaData.ormtype;
                }
                else if (angular.isDefined(propertyMetaData.type)) {
                    dataType = propertyMetaData.type;
                }
                if (["boolean", "yes_no", "true_false"].indexOf(dataType) > -1) {
                    return "yesno";
                }
                else if (["date", "timestamp"].indexOf(dataType) > -1) {
                    return "dateTime";
                }
                else if ("array" === dataType) {
                    return "select";
                }
                else if ("struct" === dataType) {
                    return "checkboxgroup";
                }
                else if (propertyName.indexOf('password') > -1) {
                    return "password";
                }
            }
            else if (angular.isDefined(propertyMetaData.fieldtype) && propertyMetaData.fieldtype === 'many-to-one') {
                return 'select';
            }
            else if (angular.isDefined(propertyMetaData.fieldtype) && propertyMetaData.fieldtype === 'one-to-many') {
                return 'There is no property field type for one-to-many relationship properties, which means that you cannot get a fieldtype for ' + propertyName;
            }
            else if (angular.isDefined(propertyMetaData.fieldtype) && propertyMetaData.fieldtype === 'many-to-many') {
                return "listingMultiselect";
            }
            return "text";
        };
        var _getPropertyFormatType = function (propertyName, metaData) {
            if (!propertyName || !metaData) {
                return 'none';
            }
            var propertyMetaData = metaData[propertyName];
            if (propertyMetaData['hb_formattype']) {
                return propertyMetaData['hb_formattype'];
            }
            else if (angular.isUndefined(propertyMetaData.fieldtype) || propertyMetaData.fieldtype === 'column') {
                var dataType = "";
                if (angular.isDefined(propertyMetaData.ormtype)) {
                    dataType = propertyMetaData.ormtype;
                }
                else if (angular.isDefined(propertyMetaData.type)) {
                    dataType = propertyMetaData.type;
                }
                if (["boolean", "yes_no", "true_false"].indexOf(dataType) > -1) {
                    return "yesno";
                }
                else if (["date", "timestamp"].indexOf(dataType) > -1) {
                    return "dateTime";
                }
                else if (["big_decimal"].indexOf(dataType) > -1 && propertyName.slice(-6) === 'weight') {
                    return "weight";
                }
                else if (["big_decimal"].indexOf(dataType) > -1) {
                    return "currency";
                }
            }
            return 'none';
        };
        var _isSimpleValue = function (value) {
            return !!(angular.isString(value) || angular.isNumber(value)
                || angular.isDate(value) || value === false || value === true);
        };
        var _getFormattedValue = function (propertyName, formatType, entityInstance) {
            var value = entityInstance.$$getPropertyByName(propertyName);
            if (angular.isUndefined(formatType)) {
                formatType = entityInstance.metaData.$$getPropertyFormatType(propertyName);
            }
            if (formatType === "custom") {
                //to be implemented
                //return entityInstance['$$get'+propertyName+Formatted]();
            }
            else if (formatType === "rbkey") {
                if (angular.isDefined(value)) {
                    return entityInstance.$$getRBKey('entity.' + entityInstance.metaData.className.toLowerCase() + '.' + propertyName.toLowerCase() + '.' + value);
                }
                else {
                    return '';
                }
            }
            if (angular.isUndefined(value)) {
                var propertyMeta = entityInstance.metaData[propertyName];
                if (angular.isDefined(propertyMeta['hb_nullRBKey'])) {
                    return entityInstance.$$getRbKey(propertyMeta['hb_nullRBKey']);
                }
                return "";
            }
            else if (_isSimpleValue(value)) {
                var formatDetails = {};
                if (angular.isDefined(entityInstance.data['currencyCode'])) {
                    formatDetails.currencyCode = entityInstance.$$getCurrencyCode();
                }
                return utilityService.formatValue(value, formatType, formatDetails, entityInstance);
            }
        };
        var _delete = function (entityInstance) {
            var entityName = entityInstance.metaData.className;
            var entityID = entityInstance.$$getID();
            var context = 'delete';
            return $delegate.saveEntity(entityName, entityID, {}, context);
        };
        var _setValueByPropertyPath = function (obj, path, value) {
            var a = path.split('.');
            var context = obj;
            var selector;
            var myregexp = /([a-zA-Z]+)(\[(\d)\])+/; // matches:  item[0]
            var match = null;
            for (var i = 0; i < a.length - 1; i += 1) {
                match = myregexp.exec(a[i]);
                if (match !== null)
                    context = context[match[1]][match[3]];
                else
                    context = context[a[i]];
            }
            // check for ending item[xx] syntax
            match = myregexp.exec([a[a.length - 1]]);
            if (match !== null)
                context[match[1]][match[3]] = value;
            else
                context[a[a.length - 1]] = value;
        };
        var _getValueByPropertyPath = function (obj, path) {
            var paths = path.split('.'), current = obj, i;
            for (i = 0; i < paths.length; ++i) {
                if (current[paths[i]] == undefined) {
                    return undefined;
                }
                else {
                    current = current[paths[i]];
                }
            }
            return current;
        };
        var _addReturnedIDs = function (returnedIDs, entityInstance) {
            for (var key in returnedIDs) {
                if (angular.isArray(returnedIDs[key])) {
                    var arrayItems = returnedIDs[key];
                    var entityInstanceArray = entityInstance.data[key];
                    for (var i in arrayItems) {
                        var arrayItem = arrayItems[i];
                        var entityInstanceArrayItem = entityInstance.data[key][i];
                        _addReturnedIDs(arrayItem, entityInstanceArrayItem);
                    }
                }
                else if (angular.isObject(returnedIDs[key])) {
                    for (var k in returnedIDs[key]) {
                        _addReturnedIDs(returnedIDs[key][k], entityInstance.data[key][k]);
                    }
                }
                else {
                    entityInstance.data[key] = returnedIDs[key];
                }
            }
        };
        var _save = function (entityInstance) {
            var deferred = $q.defer();
            $timeout(function () {
                //$log.debug('save begin');
                //$log.debug(entityInstance);
                var entityID = entityInstance.$$getID();
                var modifiedData = _getModifiedData(entityInstance);
                //$log.debug('modifiedData complete');
                //$log.debug(modifiedData);
                //timeoutPromise.valid = modifiedData.valid;
                if (modifiedData.valid) {
                    var params = {};
                    params.serializedJsonData = utilityService.toJson(modifiedData.value);
                    //if we have a process object then the context is different from the standard save
                    var entityName = '';
                    var context = 'save';
                    if (entityInstance.metaData.isProcessObject === 1) {
                        var processStruct = modifiedData.objectLevel.metaData.className.split('_');
                        entityName = processStruct[0];
                        context = processStruct[1];
                    }
                    else {
                        entityName = modifiedData.objectLevel.metaData.className;
                    }
                    var savePromise = $delegate.saveEntity(entityName, entityID, params, context);
                    savePromise.then(function (response) {
                        var returnedIDs = response.data;
                        if ((angular.isDefined(response.SUCCESS) && response.SUCCESS === true)
                            || (angular.isDefined(response.success) && response.success === true)) {
                            if ($location.url() == '/entity/' + entityName + '/create' && response.data[modifiedData.objectLevel.$$getIDName()]) {
                                $location.path('/entity/' + entityName + '/' + response.data[modifiedData.objectLevel.$$getIDName()], false);
                            }
                            _addReturnedIDs(returnedIDs, modifiedData.objectLevel);
                            deferred.resolve(returnedIDs);
                            observerService.notify('saveSuccess', returnedIDs);
                            observerService.notify('saveSuccess' + entityName, returnedIDs);
                        }
                        else {
                            deferred.reject(angular.isDefined(response.messages) ? response.messages : response);
                            observerService.notify('saveFailed', response);
                            observerService.notify('saveFailed' + entityName, response);
                        }
                    }, function (reason) {
                        deferred.reject(reason);
                        observerService.notify('saveFailed', reason);
                        observerService.notify('saveFailed' + entityName, reason);
                    });
                }
                else {
                    //select first, visible, and enabled input with a class of ng-invalid
                    var target = $('input.ng-invalid:first:visible:enabled');
                    if (angular.isDefined(target)) {
                        target.focus();
                        var targetID = target.attr('id');
                        $anchorScroll();
                    }
                    deferred.reject('Input is invalid.');
                    observerService.notify('validationFailed');
                    observerService.notify('validationFailed' + entityName);
                }
            });
            //return timeoutPromise;
            return deferred.promise;
            /*

            */
        };
        var _getModifiedData = function (entityInstance) {
            var modifiedData = {};
            modifiedData = getModifiedDataByInstance(entityInstance);
            return modifiedData;
        };
        var getObjectSaveLevel = function (entityInstance) {
            return hibachiValidationService.getObjectSaveLevel(entityInstance);
        };
        var validateObject = function (entityInstance) {
            return hibachiValidationService.validateObject;
        };
        var validateChildren = function (entityInstance) {
            return hibachiValidationService.validateChildren(entityInstance);
        };
        var processChild = function (entityInstance, entityInstanceParent) {
            return hibachiValidationService.processChild(entityInstance, entityInstanceParent);
        };
        var processParent = function (entityInstance) {
            return hibachiValidationService.processParent(entityInstance);
        };
        var processForm = function (form, entityInstance) {
            return hibachiValidationService.processForm(form, entityInstance);
        };
        var getDataFromParents = function (entityInstance, entityInstanceParents) {
            return hibachiValidationService.getDataFromParents(entityInstance, entityInstanceParents);
        };
        var getDataFromChildren = function (entityInstance) {
            return hibachiValidationService.getDataFromChildren(entityInstance);
        };
        var getModifiedDataByInstance = function (entityInstance) {
            return hibachiValidationService.getModifiedDataByInstance(entityInstance);
        };
        var _getValidationsByProperty = function (entityInstance, property) {
            return hibachiValidationService.getValidationsByProperty(entityInstance, property);
        };
        var _getValidationByPropertyAndContext = function (entityInstance, property, context) {
            return hibachiValidationService.getValidationByPropertyAndContext(entityInstance, property, context);
        };
        return $delegate;
    }
    return HibachiServiceDecorator;
}());
exports.HibachiServiceDecorator = HibachiServiceDecorator;


/***/ }),

/***/ "cIHc":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/**
 * SWValidationEqProperty: Validates true if the user value == another field's value.
 * @usage <input type='text' swvalidationgte='nameOfAnotherInput' /> will validate false if the user enters
 * value other than 5.
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWValidationEqProperty = void 0;
var SWValidationEqPropertyController = /** @class */ (function () {
    function SWValidationEqPropertyController($rootScope, validationService, $scope) {
        var _this = this;
        this.$rootScope = $rootScope;
        this.validationService = validationService;
        this.$scope = $scope;
        this.$onChanges = function (changes) {
            if (_this.$scope.ngModel && _this.$scope.ngModel.$validators && changes.swvalidationeqproperty) {
                _this.$scope.ngModel.$validators.swvalidationeqproperty = function (modelValue, viewValue) {
                    var confirmValue;
                    if (changes.swvalidationeqproperty) {
                        confirmValue = changes.swvalidationeqproperty.currentValue;
                    }
                    return confirmValue === modelValue;
                };
            }
            if (_this.$scope.ngModel) {
                _this.$scope.ngModel.$validate();
            }
        };
    }
    return SWValidationEqPropertyController;
}());
var SWValidationEqProperty = /** @class */ (function () {
    //@ngInject
    SWValidationEqProperty.$inject = ["$rootScope", "validationService", "observerService"];
    function SWValidationEqProperty($rootScope, validationService, observerService) {
        return {
            controller: SWValidationEqPropertyController,
            controllerAs: "swValidationEqProperty",
            restrict: "A",
            require: "^ngModel",
            scope: {},
            bindToController: {
                swvalidationeqproperty: "<"
            },
            link: function (scope, element, attributes, ngModel) {
                scope.ngModel = ngModel;
            }
        };
    }
    SWValidationEqProperty.Factory = function () {
        var directive = function ($rootScope, validationService, observerService) { return new SWValidationEqProperty($rootScope, validationService, observerService); };
        directive.$inject = ['$rootScope', 'validationService', 'observerService'];
        return directive;
    };
    return SWValidationEqProperty;
}());
exports.SWValidationEqProperty = SWValidationEqProperty;


/***/ }),

/***/ "cNVU":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWValidationMaxLength = void 0;
var SWValidationMaxLength = /** @class */ (function () {
    function SWValidationMaxLength(validationService) {
        return {
            restrict: "A",
            require: "^ngModel",
            link: function (scope, element, attributes, ngModel) {
                ngModel.$validators.swvalidationmaxlength =
                    function (modelValue, viewValue) {
                        var length = 0;
                        if (viewValue && viewValue.length) {
                            length = viewValue.length;
                        }
                        return validationService.validateMaxLength(length || 0, attributes.swvalidationmaxlength);
                    };
            }
        };
    }
    SWValidationMaxLength.Factory = function () {
        var directive = function (validationService) { return new SWValidationMaxLength(validationService); };
        directive.$inject = ['validationService'];
        return directive;
    };
    return SWValidationMaxLength;
}());
exports.SWValidationMaxLength = SWValidationMaxLength;


/***/ }),

/***/ "cP5o":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWCollectionOrderBy = exports.SWCollectionOrderByController = void 0;
var SWCollectionOrderByController = /** @class */ (function () {
    // @ngInject;
    function SWCollectionOrderByController() {
    }
    return SWCollectionOrderByController;
}());
exports.SWCollectionOrderByController = SWCollectionOrderByController;
var SWCollectionOrderBy = /** @class */ (function () {
    //@ngInject
    SWCollectionOrderBy.$inject = ["scopeService"];
    function SWCollectionOrderBy(scopeService) {
        var _this = this;
        this.scopeService = scopeService;
        this.restrict = 'EA';
        this.scope = true;
        this.bindToController = {
            orderBy: "@"
        };
        this.controller = SWCollectionOrderByController;
        this.controllerAs = "SWCollectionOrderBy";
        this.template = "";
        this.link = function (scope, element, attrs) {
            var orderBy = scope.SWCollectionOrderBy.orderBy;
            var currentScope = _this.scopeService.getRootParentScope(scope, "swCollectionConfig");
            if (angular.isDefined(currentScope.swCollectionConfig)) {
                currentScope.swCollectionConfig.orderBys.push(orderBy);
                currentScope.swCollectionConfig.orderBysDeferred.resolve();
            }
            else {
                throw ("could not find swCollectionConfig in the parent scope from swcollectionorderby");
            }
        };
    }
    SWCollectionOrderBy.Factory = function () {
        var _this = this;
        return function (scopeService) { return new _this(scopeService); };
    };
    return SWCollectionOrderBy;
}());
exports.SWCollectionOrderBy = SWCollectionOrderBy;


/***/ }),

/***/ "clPF":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.MetaDataService = void 0;
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var MetaDataService = /** @class */ (function () {
    //@ngInject
    function MetaDataService($filter, $log) {
        var _this = this;
        this.$filter = $filter;
        this.$log = $log;
        this.getPropertyHintByObjectAndPropertyIdentifier = function (object, propertyIdentifier) {
            var hint = "";
            if (_this.hasPropertyByEntityNameAndPropertyIdentifier(object, propertyIdentifier)) {
                if (_this.isAttributePropertyByEntityAndPropertyIdentifier(object, propertyIdentifier)) {
                    hint = object.metaData && object.metaData[propertyIdentifier].attributeHint;
                }
                else {
                    hint = object.metaData.$$getPropertyHint(propertyIdentifier);
                }
            }
            return hint;
        };
        this.getPropertyTitle = function (object, propertyIdentifier) {
            var title = "";
            if (_this.hasPropertyByEntityNameAndPropertyIdentifier(object, propertyIdentifier)) {
                if (_this.isAttributePropertyByEntityAndPropertyIdentifier(object, propertyIdentifier)) {
                    title = object.metaData && object.metaData[propertyIdentifier].attributeName;
                }
                else {
                    title = object.metaData.$$getPropertyTitle(propertyIdentifier);
                }
            }
            return title;
        };
        this.getPropertyFieldType = function (object, propertyIdentifier) {
            var fieldType = "";
            if (_this.hasPropertyByEntityNameAndPropertyIdentifier(object, propertyIdentifier)) {
                if (_this.isAttributePropertyByEntityAndPropertyIdentifier(object, propertyIdentifier)) {
                    fieldType = object.metaData && object.metaData[propertyIdentifier].attributeInputType;
                }
                else {
                    fieldType = object.metaData.$$getPropertyFieldType(propertyIdentifier);
                }
            }
            return fieldType;
        };
        this.isAttributePropertyByEntityAndPropertyIdentifier = function (object, propertyIdentifier) {
            return object.metaData && object.metaData[propertyIdentifier] && object.metaData[propertyIdentifier].attributeCode == propertyIdentifier;
        };
        this.hasPropertyByEntityNameAndPropertyIdentifier = function (object, propertyIdentifier) {
            return object.metaData && object.metaData[propertyIdentifier];
        };
        this.getPropertiesList = function () {
            return _this._propertiesList;
        };
        this.getPropertiesListByBaseEntityAlias = function (baseEntityAlias) {
            return _this._propertiesList[baseEntityAlias];
        };
        this.setPropertiesList = function (value, key) {
            _this._propertiesList[key] = value;
        };
        this.formatPropertiesList = function (propertiesList, propertyIdentifier) {
            if (!propertiesList) {
                propertiesList = {};
            }
            if (!propertiesList.data) {
                propertiesList.data = [];
            }
            var simpleGroup = {
                $$group: 'simple',
            };
            propertiesList.data.push(simpleGroup);
            var drillDownGroup = {
                $$group: 'drilldown',
            };
            propertiesList.data.push(drillDownGroup);
            var compareCollections = {
                $$group: 'compareCollections',
            };
            propertiesList.data.push(compareCollections);
            var attributeCollections = {
                $$group: 'attribute',
            };
            propertiesList.data.push(attributeCollections);
            for (var i in propertiesList.data) {
                if (angular.isDefined(propertiesList.data[i].ormtype)) {
                    if (angular.isDefined(propertiesList.data[i].attributeID)) {
                        propertiesList.data[i].$$group = 'attribute';
                    }
                    else {
                        propertiesList.data[i].$$group = 'simple';
                    }
                }
                if (angular.isDefined(propertiesList.data[i].fieldtype)) {
                    if (propertiesList.data[i].fieldtype === 'id') {
                        propertiesList.data[i].$$group = 'simple';
                    }
                    if (propertiesList.data[i].fieldtype === 'many-to-one') {
                        propertiesList.data[i].$$group = 'drilldown';
                    }
                    if (propertiesList.data[i].fieldtype === 'many-to-many' || propertiesList.data[i].fieldtype === 'one-to-many') {
                        propertiesList.data[i].$$group = 'compareCollections';
                    }
                }
                var divider = '_';
                if (propertiesList.data[i].$$group == 'simple' || propertiesList.data[i].$$group == 'attribute') {
                    divider = '.';
                }
                propertiesList.data[i].propertyIdentifier = propertyIdentifier + divider + propertiesList.data[i].name;
            }
            //propertiesList.data = _orderBy(propertiesList.data,['displayPropertyIdentifier'],false);
            //--------------------------------Removes empty lines from dropdown.
            var temp = [];
            for (var i_1 = 0; i_1 <= propertiesList.data.length - 1; i_1++) {
                if (propertiesList.data[i_1].propertyIdentifier.indexOf(".undefined") != -1 || propertiesList.data[i_1].propertyIdentifier.indexOf("_undefined") != -1) {
                    _this.$log.debug("removing: " + propertiesList.data[i_1].displayPropertyIdentifier);
                    propertiesList.data[i_1].displayPropertyIdentifier = "hide";
                }
                else {
                    temp.push(propertiesList.data[i_1]);
                    _this.$log.debug(propertiesList.data[i_1]);
                }
            }
            temp.sort;
            propertiesList.data = temp;
            _this.$log.debug("----------------------PropertyList\n\n\n\n\n");
            propertiesList.data = _this._orderBy(propertiesList.data, ['propertyIdentifier'], false);
            //--------------------------------End remove empty lines.
        };
        this.orderBy = function (propertiesList, predicate, reverse) {
            return _this._orderBy(propertiesList, predicate, reverse);
        };
        this.$filter = $filter;
        this.$log = $log;
        this._propertiesList = {};
        this._orderBy = $filter('orderBy');
    }
    MetaDataService.$inject = [
        '$filter',
        '$log'
    ];
    return MetaDataService;
}());
exports.MetaDataService = MetaDataService;


/***/ }),

/***/ "d5NH":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../typings/tsd.d.ts' />
var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.Cart = void 0;
var baseentity_1 = __webpack_require__("L67B");
var Cart = /** @class */ (function (_super) {
    __extends(Cart, _super);
    //deprecated
    function Cart($injector) {
        var _this = _super.call(this, $injector) || this;
        _this.orderRequirementsList = "";
        _this.orderPayments = [];
        _this.orderItems = [];
        _this.orderFulfillments = [];
        _this.hasShippingAddressAndMethod = function () {
            if (_this.orderRequirementsList.indexOf('fulfillment') == -1) {
                return true;
            }
            return false;
        };
        _this.orderRequiresAccount = function () {
            if (_this.orderRequirementsList.indexOf('account') != -1 || !_this.account.accountID) {
                return true;
            }
            return false;
        };
        _this.getOrderItemQuantitySum = function () {
            var totalQuantity = 0;
            if (angular.isDefined(_this.orderItems)) {
                for (var orderItem in _this.orderItems) {
                    totalQuantity = totalQuantity + _this.orderItems[orderItem].quantity;
                }
                return totalQuantity;
            }
            return totalQuantity;
        };
        return _this;
    }
    return Cart;
}(baseentity_1.BaseEntity));
exports.Cart = Cart;


/***/ }),

/***/ "dDSC":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWValidationNeq = void 0;
var SWValidationNeq = /** @class */ (function () {
    function SWValidationNeq(validationService) {
        return {
            restrict: "A",
            require: "^ngModel",
            link: function (scope, element, attributes, ngModel) {
                ngModel.$validators.swvalidationneq =
                    function (modelValue) {
                        return validationService.validateNeq(modelValue, attributes.swvalidationneq);
                    };
            }
        };
    }
    SWValidationNeq.Factory = function () {
        var directive = function (validationService) { return new SWValidationNeq(validationService); };
        directive.$inject = ['validationService'];
        return directive;
    };
    return SWValidationNeq;
}());
exports.SWValidationNeq = SWValidationNeq;


/***/ }),

/***/ "dH0M":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWDatePicker = void 0;
var SWDatePicker = /** @class */ (function () {
    // @ngInject;
    function SWDatePicker() {
        this.restrict = 'A';
        this.require = 'ngModel';
        this.scope = {
            options: '<?',
            startDayOfTheMonth: '<?',
            endDayOfTheMonth: '<?',
            startDate: '=?',
            startDateString: '@?',
            endDate: '=?',
            endDateString: '@?',
        };
        this.link = function ($scope, element, attrs, modelCtrl) {
            if (!$scope.options) {
                $scope.options = {
                    autoclose: true,
                    format: 'mm/dd/yyyy',
                    setDate: new Date(),
                };
            }
            if (!$scope.startDayOfTheMonth) {
                $scope.startDayOfTheMonth = 1;
            }
            if (!$scope.endDayOfTheMonth) {
                $scope.endDayOfTheMonth = 31;
            }
            if ($scope.startDateString) {
                $scope.startDate = Date.parse($scope.startDateString).getTime();
            }
            if ($scope.endDateString) {
                $scope.endDate = Date.parse($scope.endDateString).getTime();
            }
            if (!$scope.startDate) {
                $scope.startDate = Date.now();
            }
            if (typeof $scope.startDate !== 'number') {
                $scope.startDate = $scope.startDate.getTime();
            }
            if ($scope.endDate && typeof $scope.endDate !== 'number') {
                $scope.endDate = $scope.endDate.getTime();
            }
            if (!$scope.endDate) {
                $scope.options.beforeShowDay = function (date) {
                    var dayOfMonth = date.getDate();
                    var dateToCompare = date;
                    if (typeof dateToCompare !== 'number') {
                        dateToCompare = dateToCompare.getTime();
                    }
                    return [
                        dayOfMonth >= $scope.startDayOfTheMonth &&
                            dayOfMonth <= $scope.endDayOfTheMonth &&
                            dateToCompare >= $scope.startDate,
                    ];
                };
            }
            else {
                $scope.options.beforeShowDay = function (date) {
                    var dayOfMonth = date.getDate();
                    var dateToCompare = date;
                    if (typeof dateToCompare !== 'number') {
                        dateToCompare = dateToCompare.getTime();
                    }
                    return [
                        dayOfMonth >= $scope.startDayOfTheMonth &&
                            dayOfMonth <= $scope.endDayOfTheMonth &&
                            dateToCompare >= $scope.startDate &&
                            dateToCompare < $scope.endDate,
                    ];
                };
            }
            $(element).datepicker($scope.options);
            console.log($scope);
        };
    }
    SWDatePicker.Factory = function () {
        return /** @ngInject; */ function () { return new SWDatePicker(); };
    };
    return SWDatePicker;
}());
exports.SWDatePicker = SWDatePicker;


/***/ }),

/***/ "dIWv":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWFPropertyDisplayController = exports.SWFPropertyDisplay = void 0;
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var swpropertydisplay_1 = __webpack_require__("Y7Lf");
var SWFPropertyDisplayController = /** @class */ (function (_super) {
    __extends(SWFPropertyDisplayController, _super);
    //@ngInject
    SWFPropertyDisplayController.$inject = ["$filter", "utilityService", "$injector", "metadataService", "observerService", "publicService"];
    function SWFPropertyDisplayController($filter, utilityService, $injector, metadataService, observerService, publicService) {
        var _this = _super.call(this, $filter, utilityService, $injector, metadataService, observerService, publicService) || this;
        _this.$filter = $filter;
        _this.utilityService = utilityService;
        _this.$injector = $injector;
        _this.metadataService = metadataService;
        _this.observerService = observerService;
        _this.publicService = publicService;
        _this.edit = true;
        return _this;
    }
    return SWFPropertyDisplayController;
}(swpropertydisplay_1.SWPropertyDisplayController));
exports.SWFPropertyDisplayController = SWFPropertyDisplayController;
var SWFPropertyDisplay = /** @class */ (function (_super) {
    __extends(SWFPropertyDisplay, _super);
    //@ngInject
    SWFPropertyDisplay.$inject = ["$compile", "scopeService", "coreFormPartialsPath", "hibachiPathBuilder", "swpropertyPartialPath"];
    function SWFPropertyDisplay($compile, scopeService, coreFormPartialsPath, hibachiPathBuilder, swpropertyPartialPath) {
        var _this = _super.call(this, $compile, scopeService, coreFormPartialsPath, hibachiPathBuilder, swpropertyPartialPath) || this;
        _this.$compile = $compile;
        _this.scopeService = scopeService;
        _this.coreFormPartialsPath = coreFormPartialsPath;
        _this.hibachiPathBuilder = hibachiPathBuilder;
        _this.swpropertyPartialPath = swpropertyPartialPath;
        _this.controller = SWFPropertyDisplayController;
        _this.controllerAs = "swfPropertyDisplay";
        _this.scope = {};
        _this.link = function (scope, element, attrs) {
        };
        return _this;
    }
    return SWFPropertyDisplay;
}(swpropertydisplay_1.SWPropertyDisplay));
exports.SWFPropertyDisplay = SWFPropertyDisplay;


/***/ }),

/***/ "ebf+":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../typings/tsd.d.ts' />
var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.Address = void 0;
var baseentity_1 = __webpack_require__("L67B");
var Address = /** @class */ (function (_super) {
    __extends(Address, _super);
    function Address($injector) {
        return _super.call(this, $injector) || this;
    }
    return Address;
}(baseentity_1.BaseEntity));
exports.Address = Address;


/***/ }),

/***/ "f5BN":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/*services return promises which can be handled uniquely based on success or failure by the controller*/
Object.defineProperty(exports, "__esModule", { value: true });
exports.ValidationService = void 0;
var ValidationService = /** @class */ (function () {
    //@ngInject
    ValidationService.$inject = ["$hibachi", "$q"];
    function ValidationService($hibachi, $q) {
        var _this = this;
        this.$hibachi = $hibachi;
        this.$q = $q;
        this.MY_EMAIL_REGEXP = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        this.validateUnique = function (value, object, property) {
            var deferred = _this.$q.defer();
            //First time the asyncValidators function is loaded the
            //key won't be set  so ensure that we have
            //key and propertyName before checking with the server
            if (object && property) {
                _this.$hibachi.checkUniqueValue(object, property, value)
                    .then(function (unique) {
                    if (unique) {
                        deferred.resolve(); //It's unique
                    }
                    else {
                        deferred.reject(); //Add unique to $errors
                    }
                });
            }
            else {
                deferred.resolve(); //Ensure promise is resolved if we hit this
            }
            return deferred.promise;
        };
        this.validateUniqueOrNull = function (value, object, property) {
            var deferred = _this.$q.defer();
            //First time the asyncValidators function is loaded the
            //key won't be set  so ensure that we have
            //key and propertyName before checking with the server
            if (object && property) {
                _this.$hibachi.checkUniqueOrNullValue(object, property, value)
                    .then(function (unique) {
                    if (unique) {
                        deferred.resolve(); //It's unique
                    }
                    else {
                        deferred.reject(); //Add unique to $errors
                    }
                });
            }
            else {
                deferred.resolve(); //Ensure promise is resolved if we hit this
            }
            return deferred.promise;
        };
        this.validateEmail = function (value) {
            return _this.validateDataType(value, 'email');
        };
        this.validateDataType = function (value, type) {
            if (value == null) {
                return true;
            } //let required validate this
            if (angular.isString(value) && type === "string") {
                return true;
            }
            if (angular.isNumber(parseInt(value)) && type === "numeric") {
                return true;
            }
            if (angular.isArray(value) && type === "array") {
                return true;
            }
            if (angular.isDate(value) && type === "date") {
                return true;
            }
            if (angular.isObject(value) && type === "object") {
                return true;
            }
            if (type === 'email') {
                return _this.MY_EMAIL_REGEXP.test(value);
            }
            if (angular.isUndefined(value && type === "undefined")) {
                return true;
            }
            return false;
        };
        this.validateEq = function (value, expectedValue) {
            return (value === expectedValue);
        };
        this.validateEqProperty = function (value, expectedValue) {
            return (value === expectedValue);
        };
        this.validateNeq = function (value, expectedValue) {
            return (value !== expectedValue);
        };
        this.validateGte = function (value, comparisonValue) {
            if (comparisonValue === void 0) { comparisonValue = 0; }
            if (angular.isString(value)) {
                value = parseInt(value);
            }
            if (angular.isString(comparisonValue)) {
                comparisonValue = parseInt(comparisonValue);
            }
            return (value >= comparisonValue);
        };
        this.validateLte = function (value, comparisonValue) {
            if (comparisonValue === void 0) { comparisonValue = 0; }
            if (angular.isString(value)) {
                value = parseInt(value);
            }
            if (angular.isString(comparisonValue)) {
                comparisonValue = parseInt(comparisonValue);
            }
            return (value <= comparisonValue);
        };
        this.validateMaxLength = function (value, comparisonValue) {
            if (comparisonValue === void 0) { comparisonValue = 0; }
            return _this.validateLte(value, comparisonValue);
        };
        this.validateMaxValue = function (value, comparisonValue) {
            if (comparisonValue === void 0) { comparisonValue = 0; }
            return _this.validateLte(value, comparisonValue);
        };
        this.validateMinLength = function (value, comparisonValue) {
            if (comparisonValue === void 0) { comparisonValue = 0; }
            return _this.validateGte(value, comparisonValue);
        };
        this.validateMinValue = function (value, comparisonValue) {
            if (comparisonValue === void 0) { comparisonValue = 0; }
            return _this.validateGte(value, comparisonValue);
        };
        this.validateNumeric = function (value) {
            return !isNaN(value);
        };
        this.validateRegex = function (value, pattern) {
            var regex = new RegExp(pattern);
            return regex.test(value);
        };
        this.validateRequired = function (value) {
            if (value) {
                return true;
            }
            else {
                return false;
            }
        };
        this.$hibachi = $hibachi;
        this.$q = $q;
    }
    return ValidationService;
}());
exports.ValidationService = ValidationService;


/***/ }),

/***/ "fBkV":
/***/ (function(module, exports) {

module.exports = "<!--//export batch action-->\n    <div id=\"j-export-link\" class=\"row collapse s-batch-options\">\n      <div class=\"col-md-12 s-add-filter\">\n\n        <!--- Edit Filter Box --->\n\n          <h4> Export:<i class=\"fa fa-times\" data-toggle=\"collapse\" data-target=\"#j-export-link\"></i></h4>\n          <div class=\"col-xs-12\">\n\n            <div class=\"row\">\n              <div class=\"col-xs-2\">\n                <div class=\"form-group form-group-sm\">\n                  <label class=\"col-sm-12 control-label s-no-paddings\" for=\"formGroupInputSmall\">Items To Export:</label>\n                  <div class=\"col-sm-12 s-no-paddings\">\n\n                    <div class=\"radio\">\n                      <input type=\"radio\" name=\"radio1\" id=\"radio7\" value=\"option2\" checked=\"checked\">\n                      <label for=\"radio7\">\n                          All\n                      </label>\n                    </div>\n                    <div class=\"radio\">\n                      <input type=\"radio\" name=\"radio1\" id=\"radio7\" value=\"option2\">\n                      <label for=\"radio7\">\n                          Visable\n                      </label>\n                    </div>\n                    <div class=\"radio\">\n                      <input type=\"radio\" name=\"radio1\" id=\"radio7\" value=\"option2\">\n                      <label for=\"radio7\">\n                          Selected\n                      </label>\n                    </div>\n                  </div>\n                  <div class=\"clearfix\"></div>\n                </div>\n              </div>\n              <div class=\"col-xs-7 s-criteria\">\n\n                <!--- Filter Criteria Start --->\n                <form action=\"index.html\" method=\"post\">\n                  <div class=\"s-filter-group-item\">\n\n                    <div class=\"s-options-group\">\n\n                      <div class=\"form-group\">\n                        <label class=\"col-xs-12\">Export Format:</label>\n                        <select class=\"form-control input-sm\">\n                          <option selected=\"selected\">Excel</option>\n                          <option>Text (CSV,Tab,...)</option>\n                        </select>\n                      </div>\n\n                      <!--- <div class=\"radio\">\n                        <input type=\"radio\" name=\"radio1\" id=\"radio7\" value=\"option2\">\n                        <label for=\"radio7\">\n                            Excel\n                        </label>\n                      </div> --->\n\n                      <div class=\"radio\">\n                        <input type=\"radio\" name=\"radio1\" id=\"radio7\" value=\"option2\">\n                        <label for=\"radio7\">\n                            Tab Delimited\n                        </label>\n                      </div>\n                      <div class=\"radio\">\n                        <input type=\"radio\" name=\"radio1\" id=\"radio9\" value=\"option2\">\n                        <label for=\"radio9\">\n                            Comma Delimited\n                        </label>\n                      </div>\n                      <div class=\"radio\">\n                        <input type=\"radio\" name=\"radio1\" id=\"radio6\" value=\"option3\" checked>\n                        <label for=\"radio6\">\n                            Custom Delimiter\n                        </label>\n                        <input style=\"display:block;\" type=\"text\" name=\"some_name\" value=\"\">\n                      </div>\n                    </div>\n\n                  </div>\n                </form>\n                <!--- //Filter Criteria End --->\n\n              </div>\n              <div class=\"col-xs-2\">\n                <div class=\"s-button-select-group\">\n                  <button type=\"button\" class=\"btn btn-sm s-btn-ten24\" style=\"width:100%;\">Export</button>\n                </div>\n              </div>\n            </div>\n          </div>\n\n\n        <!--- //Edit Filter Box --->\n      </div>\n    </div>\n<!--//export batch action-->";

/***/ }),

/***/ "fbXf":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWCollectionFilter = exports.SWCollectionFilterController = void 0;
var SWCollectionFilterController = /** @class */ (function () {
    // @ngInject;
    function SWCollectionFilterController() {
    }
    return SWCollectionFilterController;
}());
exports.SWCollectionFilterController = SWCollectionFilterController;
var SWCollectionFilter = /** @class */ (function () {
    //@ngInject
    SWCollectionFilter.$inject = ["scopeService", "utilityService"];
    function SWCollectionFilter(scopeService, utilityService) {
        var _this = this;
        this.scopeService = scopeService;
        this.utilityService = utilityService;
        this.restrict = 'EA';
        this.scope = true;
        this.bindToController = {
            propertyIdentifier: "@",
            comparisonOperator: "@?",
            comparisonValue: "@?",
            logicalOperator: "@?",
            hidden: "@?"
        };
        this.controller = SWCollectionFilterController;
        this.controllerAs = "SWCollectionFilter";
        this.template = "";
        this.link = function (scope, element, attrs) {
            var filter = {
                propertyIdentifier: scope.SWCollectionFilter.propertyIdentifier,
                comparisonOperator: scope.SWCollectionFilter.comparisonOperator,
                comparisonValue: scope.SWCollectionFilter.comparisonValue,
                logicalOperator: scope.SWCollectionFilter.logicalOperator,
                hidden: scope.SWCollectionFilter.hidden
            };
            var currentScope = _this.scopeService.getRootParentScope(scope, "swCollectionConfig");
            if (angular.isDefined(currentScope.swCollectionConfig)) {
                currentScope.swCollectionConfig.filters.push(filter);
                currentScope.swCollectionConfig.filtersDeferred.resolve();
            }
            else {
                throw ("could not find swCollectionConfig in the parent scope from swcollectionfilter");
            }
        };
    }
    SWCollectionFilter.Factory = function () {
        var _this = this;
        return /** @ngInject; */ ["scopeService", "utilityService", function (scopeService, utilityService) { return new _this(scopeService, utilityService); }];
    };
    return SWCollectionFilter;
}());
exports.SWCollectionFilter = SWCollectionFilter;


/***/ }),

/***/ "fsz1":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWTrim = void 0;
var SWTrim = /** @class */ (function () {
    function SWTrim() {
    }
    //@ngInject
    SWTrim.Factory = function (rbkeyService) {
        return function (text, max, wordwise, tail) {
            if (wordwise === void 0) { wordwise = true; }
            if (tail === void 0) { tail = "..."; }
            if (angular.isDefined(text) && angular.isString(text)) {
                if (!text)
                    return '';
                max = parseInt(max, 10);
                if (!max)
                    return text;
                if (text.length <= max)
                    return text;
                text = text.substr(0, max);
                if (wordwise) {
                    var lastSpace = text.lastIndexOf(' ');
                    if (lastSpace != -1) {
                        text = text.substr(0, lastSpace);
                    }
                }
                return text + tail;
            }
            return text;
        };
    };
    SWTrim.Factory.$inject = ["rbkeyService"];
    return SWTrim;
}());
exports.SWTrim = SWTrim;


/***/ }),

/***/ "gkWZ":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../typings/tsd.d.ts' />
var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.Sku = void 0;
var baseentity_1 = __webpack_require__("L67B");
var Sku = /** @class */ (function (_super) {
    __extends(Sku, _super);
    function Sku($injector) {
        var _this = _super.call(this, $injector) || this;
        _this.setNewQOH = function (value) {
            _this.newQOH = value;
        };
        _this.getNewQOH = function () {
            return _this.newQOH;
        };
        return _this;
    }
    return Sku;
}(baseentity_1.BaseEntity));
exports.Sku = Sku;


/***/ }),

/***/ "iJDV":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWValidationDataType = void 0;
var SWValidationDataType = /** @class */ (function () {
    //@ngInject
    SWValidationDataType.$inject = ["validationService"];
    function SWValidationDataType(validationService) {
        return {
            restrict: "A",
            require: "^ngModel",
            link: function (scope, element, attributes, ngModel) {
                var isValidFunction = function (modelValue) {
                    return validationService.validateDataType(modelValue, attributes.swvalidationdatatype);
                };
                ngModel.$validators.swvalidationdatatype = isValidFunction;
                ngModel.$validators['swvalidation' + attributes.swvalidationdatatype] = isValidFunction;
            }
        };
    }
    SWValidationDataType.Factory = function () {
        var directive = function (validationService) { return new SWValidationDataType(validationService); };
        directive.$inject = ['validationService'];
        return directive;
    };
    return SWValidationDataType;
}());
exports.SWValidationDataType = SWValidationDataType;


/***/ }),

/***/ "iUpN":
/***/ (function(module, exports) {

module.exports = "<div class=\"s-select-list-wrapper s-search\" sw-click-outside=\"swTypeaheadSearch.closeThis(swTypeaheadSearch.clickOutsideArguments)\" >\n        <div class=\"input-group\">\n             <div class=\"input-group-btn s-left\" ng-class=\"{'open':swTypeaheadSearch.dropdownOpen}\">\n                <button type=\"button\"\n                        class=\"btn btn-default\"\n                        data-ng-disabled=\"swTypeaheadSearch.disabled\"\n                        ng-click=\"swTypeaheadSearch.toggleDropdown()\"\n                        aria-expanded=\"true\">\n                        <span>{{swTypeaheadSearch.searchableColumnSelection}}</span> <i class=\"fa\" data-ng-class=\"(swTypeaheadSearch.dropdownOpen) ? 'fa-caret-up' : 'fa-caret-down'\" ></i>\n                </button>\n                <ul ng-if=\"swTypeaheadSearch.dropdownOpen\" class=\"dropdown-menu\" role=\"menu\">\n                    <li>\n                        <a ng-click=\"swTypeaheadSearch.updateSearchableProperties('all')\">\n                            <span sw-rbkey=\"'define.all'\"></span>\n                        </a>\n                    </li>\n                    <li ng-repeat=\"column in swTypeaheadSearch.searchableColumns\">\n                        <a ng-click=\"swTypeaheadSearch.updateSearchableProperties(column)\">{{column.title}}</a>\n                    </li>\n                </ul>\n            </div>\n            <div class=\"s-input-btn\" ng-class=\"{ 's-add' : swTypeaheadSearch.multiselectMode, 's-search' : !swTypeaheadSearch.multiselectMode}\">\n                <input  data-ng-if=\"swTypeaheadSearch.placeholderText\"\n                        id=\"searchinput\"\n                        placeholder=\"{{swTypeaheadSearch.placeholderText}}\"\n                        ng-model=\"swTypeaheadSearch.searchText\"\n                        ng-change=\"swTypeaheadSearch.search(swTypeaheadSearch.searchText)\"\n                        type=\"search\"\n                        title=\"{{swTypeaheadSearch.titleText}}\"\n                        class=\"form-control\"\n                        style=\"max-width:100%;\"\n                        autocomplete=\"off\"\n                        data-ng-required=\"swTypeaheadSearch.validateRequired\"\n                        data-ng-disabled=\"swTypeaheadSearch.disabled\"/>\n                </div>\n            <div class=\"input-group-btn\">\n                <button class=\"btn btn-default\" type='button' ng-click=\"swTypeaheadSearch.toggleOptions()\" data-ng-disabled=\"swTypeaheadSearch.disabled\" style=\"border-radius:0;height: 31px;\">\n                    <i class=\"fa\" data-ng-class=\"(swTypeaheadSearch.hideSearch) ? 'fa-caret-down': 'fa-caret-up'\" ></i>\n                </button>\n                <button class=\"btn btn-sm btn-primary\" type='button' ng-if=\"swTypeaheadSearch.showAddButton\" ng-click=\"swTypeaheadSearch.addButtonItem()\" data-ng-disabled=\"swTypeaheadSearch.disabled\">\n                    <i class=\"fa fa-plus\"></i>\n                </button>\n            </div>\n        </div>\n    <div class=\"dropdown s-search-results-wrapper\" ng-class=\"{'open btn-group':!swTypeaheadSearch.hideSearch}\">\n        <ul ng-show=\"swTypeaheadSearch.loading\" class=\"dropdown-menu\">\n            <li class=\"dropdown-item text-center\">\n                <i class=\"fa fa-spinner fa-spin\" style=\"font-size:24px\"></i>\n            </li>\n        </ul>\n        <ul ng-show=\"!swTypeaheadSearch.loading && !swTypeaheadSearch.hideSearch\" class=\"dropdown-menu\">\n         <!-- populated by the directives link function -->\n            <li ng-show=\"swTypeaheadSearch.loading\" class=\"dropdown-item text-center\">\n                <i class=\"fa fa-spinner fa-spin\" style=\"font-size:24px\"></i>\n            </li>\n         </ul>\n    </div>\n</div>";

/***/ }),

/***/ "jZ4P":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWAddressVerification = void 0;
var SWAddressVerificationController = /** @class */ (function () {
    //@ngInject
    SWAddressVerificationController.$inject = ["rbkeyService", "observerService", "$hibachi"];
    function SWAddressVerificationController(rbkeyService, observerService, $hibachi) {
        var _this = this;
        this.rbkeyService = rbkeyService;
        this.observerService = observerService;
        this.$hibachi = $hibachi;
        this.translations = {};
        this.makeTranslations = function () {
            _this.translations['suggestedAddress'] = _this.rbkeyService.rbKey('admin.define.suggestedAddress');
            _this.translations['cancel'] = _this.rbkeyService.rbKey('admin.define.cancel');
            _this.translations['addressMessage'] = _this.rbkeyService.rbKey('admin.define.addressChangeMessage');
        };
        this.submit = function () {
            if (_this.selectedAddressIndex == 0) {
                _this.close(null);
                return;
            }
            else {
                _this.loading = true;
                var data = _this.suggestedAddresses[_this.selectedAddressIndex];
                data.propertyIdentifiersList = _this.propertyIdentifiersList;
                _this.$hibachi.saveEntity('Address', data['addressID'], data, 'save')
                    .then(function (result) {
                    _this.loading = false;
                    _this.suggestedAddresses[0] = _this.suggestedAddresses[_this.selectedAddressIndex];
                    _this.close(null);
                    if (_this.sAction) {
                        _this.sAction(result.data);
                    }
                });
            }
        };
        this.closeModal = function () {
            _this.close(null);
        };
        this.makeTranslations();
    }
    return SWAddressVerificationController;
}());
var SWAddressVerification = /** @class */ (function () {
    function SWAddressVerification() {
        this.scope = {};
        this.bindToController = {
            suggestedAddresses: '<',
            close: '=',
            sAction: '=?',
            propertyIdentifiersList: '=?'
        };
        this.controller = SWAddressVerificationController;
        this.controllerAs = "swAddressVerification";
        this.template = __webpack_require__("SZP2");
    }
    SWAddressVerification.Factory = function () {
        var _this = this;
        return /** @ngInject; */ function () { return new _this(); };
    };
    return SWAddressVerification;
}());
exports.SWAddressVerification = SWAddressVerification;


/***/ }),

/***/ "jZyc":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWIsolateChildForm = void 0;
var SWIsolateChildFormController = /** @class */ (function () {
    // @ngInject
    function SWIsolateChildFormController() {
    }
    return SWIsolateChildFormController;
}());
var SWIsolateChildForm = /** @class */ (function () {
    // @ngInject
    SWIsolateChildForm.$inject = ["coreFormPartialsPath", "hibachiPathBuilder"];
    function SWIsolateChildForm(coreFormPartialsPath, hibachiPathBuilder) {
        this.coreFormPartialsPath = coreFormPartialsPath;
        this.hibachiPathBuilder = hibachiPathBuilder;
        this.restrict = "A";
        this.require = '?form';
        this.controller = SWIsolateChildFormController;
        this.controllerAs = "swIsolateChildForm";
        this.scope = {};
        /**
         * Binds all of our variables to the controller so we can access using this
         */
        this.bindToController = {};
        /**
        * Sets the context of this form
        */
        this.link = function (scope, element, attrs, formController) {
            if (!formController) {
                return;
            }
            var parentForm = formController.$$parentForm;
            if (!parentForm) {
                return;
            }
            parentForm.$removeControl(formController);
        };
    }
    /**
     * Handles injecting the partials path into this class
     */
    SWIsolateChildForm.Factory = function () {
        var directive = function (coreFormPartialsPath, hibachiPathBuilder) { return new SWIsolateChildForm(coreFormPartialsPath, hibachiPathBuilder); };
        directive.$inject = ['coreFormPartialsPath', 'hibachiPathBuilder'];
        return directive;
    };
    return SWIsolateChildForm;
}());
exports.SWIsolateChildForm = SWIsolateChildForm;


/***/ }),

/***/ "jlA9":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWOrderByControlsController = exports.SWOrderByControls = void 0;
var SWOrderByControlsController = /** @class */ (function () {
    // @ngInject
    SWOrderByControlsController.$inject = ["listingService", "observerService", "utilityService"];
    function SWOrderByControlsController(listingService, observerService, utilityService) {
        var _this = this;
        this.listingService = listingService;
        this.observerService = observerService;
        this.utilityService = utilityService;
        this.sortCode = "ASC";
        this.updateSortOrderProperty = function () {
            if (angular.isDefined(_this.selectedPropertyIdentifier)) {
                _this.propertyNotChosen = false;
            }
            else {
                _this.propertyNotChosen = true;
            }
            _this.updateOrderBy();
        };
        this.updateOrderBy = function () {
            if (angular.isDefined(_this.selectedPropertyIdentifier) && _this.selectedPropertyIdentifier.length > 0) {
                var propertyIdentifier = _this.selectedPropertyIdentifier;
            }
            switch (_this.sortCode) {
                case "ASC":
                    _this.disabled = false;
                    if (propertyIdentifier != null) {
                        if (angular.isDefined(_this.collectionConfig)) {
                            _this.collectionConfig.toggleOrderBy(propertyIdentifier, true, true); //single column mode true, format propIdentifier true
                        }
                        if (_this.inListingDisplay) {
                            _this.listingService.setSingleColumnOrderBy(_this.listingId, propertyIdentifier, "ASC");
                        }
                    }
                    if (_this.inListingDisplay)
                        _this.listingService.setManualSort(_this.listingId, false);
                    break;
                case "DESC":
                    _this.disabled = false;
                    if (propertyIdentifier != null) {
                        if (angular.isDefined(_this.collectionConfig)) {
                            _this.collectionConfig.toggleOrderBy(propertyIdentifier, true, true); //single column mode true, format propIdentifier true
                        }
                        if (_this.inListingDisplay) {
                            _this.listingService.setSingleColumnOrderBy(_this.listingId, propertyIdentifier, "DESC");
                        }
                        if (_this.inListingDisplay)
                            _this.listingService.setManualSort(_this.listingId, false);
                    }
                    break;
                case "MANUAL":
                    //flip listing
                    _this.disabled = true;
                    if (_this.inListingDisplay) {
                        //this.swListingDisplay.sortable = true;
                        _this.listingService.setManualSort(_this.listingId, true);
                    }
                    break;
            }
        };
        this.sortAscending = function () {
            _this.sortCode = 'ASC';
            _this.updateOrderBy();
        };
        this.sortDescending = function () {
            _this.sortCode = 'DESC';
            _this.updateOrderBy();
        };
        this.manualSort = function () {
            _this.sortCode = 'MANUAL';
            _this.updateOrderBy();
        };
        if (angular.isUndefined(this.edit)) {
            this.edit = true;
        }
        if (angular.isDefined(this.collectionConfig)) {
            this.columns = this.collectionConfig.columns;
        }
        if (angular.isDefined(this.initialSortDefaultDirection) && this.initialSortDefaultDirection.length > 0) {
            this.sortCode = this.initialSortDefaultDirection;
        }
        if (angular.isDefined(this.initialSortProperty) && this.initialSortProperty.length > 0) {
            this.selectedPropertyIdentifier = this.initialSortProperty;
        }
        this.id = this.utilityService.createID(32);
    }
    return SWOrderByControlsController;
}());
exports.SWOrderByControlsController = SWOrderByControlsController;
var SWOrderByControls = /** @class */ (function () {
    // @ngInject;
    SWOrderByControls.$inject = ["$compile", "scopeService", "listingService"];
    function SWOrderByControls($compile, scopeService, listingService) {
        var _this = this;
        this.$compile = $compile;
        this.scopeService = scopeService;
        this.listingService = listingService;
        this.transclude = true;
        this.restrict = "EA";
        this.scope = {};
        this.bindToController = {
            collectionConfig: "=?",
            selectedOrderByColumn: "=?",
            inListingDisplay: "=?",
            toggleCollectionConfig: "=?",
            initialSortProperty: "@?",
            initialSortDefaultDirection: "@?",
            sortPropertyFieldName: "@?",
            sortDefaultDirectionFieldName: "@?",
            edit: "=?"
        };
        this.require = { swListingDisplay: '?^swListingDisplay' };
        this.controller = SWOrderByControlsController;
        this.controllerAs = "swOrderByControls";
        this.template = __webpack_require__("8EJg");
        this.compile = function (element, attrs, transclude) {
            return {
                pre: function ($scope, element, attrs) {
                    if ($scope.swOrderByControls.inListingDisplay &&
                        _this.scopeService.hasParentScope($scope, "swListingDisplay")) {
                        var listingDisplayScope = _this.scopeService.getRootParentScope($scope, "swListingDisplay")["swListingDisplay"];
                        $scope.swOrderByControls.listingId = listingDisplayScope.tableID;
                        _this.listingService.attachToListingInitiated($scope.swOrderByControls.listingId, $scope.swOrderByControls.updateOrderBy);
                        if ($scope.swOrderByControls.collectionConfig == null &&
                            listingDisplayScope.collectionConfig != null) {
                            $scope.swOrderByControls.collectionConfig = listingDisplayScope.collectionConfig;
                        }
                    }
                },
                post: function ($scope, element, attrs) {
                }
            };
        };
    }
    SWOrderByControls.Factory = function () {
        var _this = this;
        return /** @ngInject; */ ["$compile", "scopeService", "listingService", function ($compile, scopeService, listingService) { return new _this($compile, scopeService, listingService); }];
    };
    return SWOrderByControls;
}());
exports.SWOrderByControls = SWOrderByControls;


/***/ }),

/***/ "kGox":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWFPromoBox = exports.SWFPromoBoxController = void 0;
var SWFPromoBoxController = /** @class */ (function () {
    function SWFPromoBoxController($rootScope, $timeout) {
        var _this = this;
        this.$rootScope = $rootScope;
        this.$timeout = $timeout;
        this.alertDisplaying = false;
        this.addPromotionCode = function (promoCode) {
            _this.addPromotionCodeIsLoading = true;
            var data = {
                'promotionCode': promoCode
            };
            _this.$rootScope.slatwall.doAction('addPromotionCode', data).then(function (result) {
                _this.addPromotionCodeIsLoading = false;
                _this.displayAlert();
            });
        };
        this.removePromotionCode = function (promoCode) {
            _this.removePromotionCodeIsLoading = true;
            var data = {
                'promotionCode': promoCode.promotionCode
            };
            _this.$rootScope.slatwall.doAction('removePromotionCode', data).then(function (result) {
                _this.removePromotionCodeIsLoading = false;
            });
        };
        this.$rootScope = $rootScope;
    }
    SWFPromoBoxController.prototype.displayAlert = function () {
        var _this = this;
        this.alertDisplaying = true;
        this.$timeout(function () {
            _this.alertDisplaying = false;
        }, 3000);
    };
    return SWFPromoBoxController;
}());
exports.SWFPromoBoxController = SWFPromoBoxController;
var SWFPromoBox = /** @class */ (function () {
    //@ngInject
    SWFPromoBox.$inject = ["$rootScope"];
    function SWFPromoBox($rootScope) {
        return {
            controller: SWFPromoBoxController,
            controllerAs: "swfPromoBox",
            restrict: "A",
            link: function (scope, element, attributes, ngModel) {
            }
        };
    }
    SWFPromoBox.Factory = function () {
        var directive = function ($rootScope) { return new SWFPromoBox($rootScope); };
        directive.$inject = ['$rootScope'];
        return directive;
    };
    return SWFPromoBox;
}());
exports.SWFPromoBox = SWFPromoBox;


/***/ }),

/***/ "kh/o":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWClickOutside = void 0;
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWClickOutside = /** @class */ (function () {
    //@ngInject
    SWClickOutside.$inject = ["$document", "$timeout", "utilityService"];
    function SWClickOutside($document, $timeout, utilityService) {
        var _this = this;
        this.$document = $document;
        this.$timeout = $timeout;
        this.utilityService = utilityService;
        this.restrict = 'A';
        this.scope = {
            swClickOutside: '&'
        };
        this.link = function (scope, elem, attr) {
            _this.$document.on('click', function (e) {
                if (!e || !e.target)
                    return;
                //check if our element already hidden
                if (angular.element(elem).hasClass("ng-hide")) {
                    return;
                }
                if (e.target !== elem && elem && elem[0] && !_this.utilityService.isDescendantElement(elem[0], e.target)) {
                    _this.$timeout(function () {
                        var _a;
                        (_a = scope === null || scope === void 0 ? void 0 : scope.swClickOutside) === null || _a === void 0 ? void 0 : _a.call(scope);
                    });
                }
            });
            scope.$on('$destroy', function () {
                elem = null;
                scope = null;
            });
        };
        this.$document = $document;
        this.$timeout = $timeout;
        this.utilityService = utilityService;
    }
    SWClickOutside.Factory = function () {
        var _this = this;
        return /** @ngInject; */ ["$document", "$timeout", "utilityService", function ($document, $timeout, utilityService) {
            return new _this($document, $timeout, utilityService);
        }];
    };
    return SWClickOutside;
}());
exports.SWClickOutside = SWClickOutside;


/***/ }),

/***/ "ksv2":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var __assign = (this && this.__assign) || function () {
    __assign = Object.assign || function(t) {
        for (var s, i = 1, n = arguments.length; i < n; i++) {
            s = arguments[i];
            for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p))
                t[p] = s[p];
        }
        return t;
    };
    return __assign.apply(this, arguments);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.cacheModule = void 0;
var cachefactory_1 = __webpack_require__("Pr70");
// relies on http://www.pseudobry.com/CacheFactory/latest/tutorial-basics.html
// there's an angular-js project, but it's not being maitainde since 2017 
cachefactory_1.utils.equals = angular.equals;
cachefactory_1.utils.isObject = angular.isObject;
cachefactory_1.utils.fromJson = angular.fromJson;
var CacheFactoryProvider = /** @class */ (function () {
    function CacheFactoryProvider() {
        this.config = {};
        this.config = cachefactory_1.defaults;
        this.config.storagePrefix = 'hb.caches.';
        this.config.capacity = Number.MAX_VALUE; // how many items per cache
        this.config.storageMode = 'localStorage'; // available options "memory"(default); "localStorage"; "sessionStorage"
        // making-default to never, we can override as needed
        // this.config.recycleFreq = 15*60*1000; // all caceh will be scaned every 1 minute for expired items
        this.config.maxAge = Number.MAX_VALUE; // number of milies after which the cache will be expired 
        this.config.deleteOnExpire = 'aggressive'; // available options "none", "passive", "aggressive"
        this.$get.$inject = ['$q'];
    }
    CacheFactoryProvider.prototype.override = function (overrides) {
        this.config = __assign(__assign({}, this.config), overrides); //merge with overriding 
    };
    CacheFactoryProvider.prototype.$get = function ($q) {
        cachefactory_1.utils.Promise = $q;
        var cacheFactory = new cachefactory_1.CacheFactory();
        Object.defineProperty(cacheFactory, 'defaults', {
            value: this.config
        });
        return cacheFactory;
    };
    ;
    return CacheFactoryProvider;
}());
var LocalStorageCacheProvider = /** @class */ (function () {
    function LocalStorageCacheProvider() {
        var _this = this;
        this.config = {
            'name': 'ls.default'
        };
        this.config.onExpire = function (key, value) {
            console.log("LocalStorage-cache " + _this.config.name + ", has expired for Key: " + key + ", Value: " + value);
        };
        this.$get.$inject = ['CacheFactory'];
    }
    LocalStorageCacheProvider.prototype.override = function (overrides) {
        this.config = __assign(__assign({}, this.config), overrides); //merge with overriding 
    };
    LocalStorageCacheProvider.prototype.$get = function (CacheFactory) {
        var cache;
        //check if cache-object is already created
        if (CacheFactory.exists(this.config.name)) {
            cache = CacheFactory.get(this.config.name);
        }
        else {
            // this will retain data if any from LocalStorege, and will create a cacheObject, 
            // this which will be availabe to inject into any service/controller/component
            cache = CacheFactory.createCache(this.config.name, this.config);
        }
        return cache;
    };
    ;
    return LocalStorageCacheProvider;
}());
var SessionStorageCacheProvider = /** @class */ (function () {
    function SessionStorageCacheProvider() {
        var _this = this;
        this.config = {
            'name': 'ss.default',
            'storageMode': 'sessionStorage',
            'recycleFreq': 5 * 1000,
            'maxAge': 15 * 60 * 1000,
        };
        this.config.onExpire = function (key, value) {
            console.log("SessionStorage-cache " + _this.config.name + ", has expired for Key: " + key + ", Value: " + value);
        };
        this.$get.$inject = ['CacheFactory'];
    }
    SessionStorageCacheProvider.prototype.override = function (overrides) {
        this.config = __assign(__assign({}, this.config), overrides); //merge with overriding 
    };
    SessionStorageCacheProvider.prototype.$get = function (CacheFactory) {
        var cache;
        //check if cache-object is already created
        if (CacheFactory.exists(this.config.name)) {
            cache = CacheFactory.get(this.config.name);
        }
        else {
            // this will retain data if any from Session-Storege, and will create a cacheObject, 
            // this which will be availabe to inject into any service/controller/component
            cache = CacheFactory.createCache(this.config.name, this.config);
        }
        return cache;
    };
    ;
    return SessionStorageCacheProvider;
}());
var MemoryCacheProvider = /** @class */ (function () {
    function MemoryCacheProvider() {
        var _this = this;
        this.config = {
            'name': 'mem.default',
            'storageMode': 'memory',
            'recycleFreq': 2 * 1000,
            'maxAge': 5 * 60 * 1000,
        };
        this.config.onExpire = function (key, value) {
            console.log("Memory-cache " + _this.config.name + ", has expired for Key: " + key + ", Value: " + value);
        };
        this.$get.$inject = ['CacheFactory'];
    }
    MemoryCacheProvider.prototype.override = function (overrides) {
        this.config = __assign(__assign({}, this.config), overrides); //merge with overriding 
    };
    MemoryCacheProvider.prototype.$get = function (CacheFactory) {
        var cache;
        //check if cache-object is already created
        if (CacheFactory.exists(this.config.name)) {
            cache = CacheFactory.get(this.config.name);
        }
        else {
            // this will create a In-Memory caceh-Object, 
            // this which will be availabe to inject into any service/controller/component
            cache = CacheFactory.createCache(this.config.name, this.config);
        }
        return cache;
    };
    ;
    return MemoryCacheProvider;
}());
/**
 * For uses/api-ref, see
 * http://www.pseudobry.com/CacheFactory/latest/Cache.html
 * http://www.pseudobry.com/CacheFactory/latest/CacheFactory.html
 *
*/
var cacheModule = angular.module('hibachi.cache', [])
    .provider("CacheFactory", CacheFactoryProvider)
    .provider('localStorageCache', LocalStorageCacheProvider)
    .provider('sessionStorageCache', SessionStorageCacheProvider)
    .provider('inMemoryCache', MemoryCacheProvider) //can use a better name, like currentPageCache
;
exports.cacheModule = cacheModule;


/***/ }),

/***/ "lP0P":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.UtilityService = void 0;
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/*services return promises which can be handled uniquely based on success or failure by the controller*/
var baseservice_1 = __webpack_require__("zg2S");
var UtilityService = /** @class */ (function (_super) {
    __extends(UtilityService, _super);
    //@ngInject
    UtilityService.$inject = ["$parse"];
    function UtilityService($parse) {
        var _this = _super.call(this) || this;
        _this.$parse = $parse;
        _this.structKeyExists = function (struct, key) {
            return key in struct;
        };
        _this.keyToAttributeString = function (key) {
            var attributeString = "data-";
            for (var i = 0; i < key.length; i++) {
                if (key.charAt(i) == "_") {
                    attributeString += "-";
                }
                else if (_this.isUpperCase(key.charAt(i))) {
                    //special case for ID and Acronyms because it doesn't follow naming conventions
                    if (i + 1 <= key.length && _this.isUpperCase(key.charAt(i + 1))) {
                        if (key.charAt(i) + key.charAt(i + 1) == "ID") {
                            attributeString += "-id";
                            i++; //skip ahead
                        }
                        else if (_this.isUpperCase(key.charAt(i + 1))) {
                            attributeString += "-";
                            //this handles acronyms IE QATS 
                            while (i + 1 <= key.length && _this.isUpperCase(key.charAt(i + 1))) {
                                attributeString += key.charAt(i).toLowerCase();
                                i++;
                            }
                        }
                    }
                    else {
                        attributeString += "-" + key.charAt(i).toLowerCase();
                    }
                }
                else {
                    attributeString += key.charAt(i);
                }
            }
            return attributeString;
        };
        _this.isUpperCase = function (character) {
            return character == character.toUpperCase();
        };
        _this.isLowerCase = function (character) {
            return character == character.toLowerCase();
        };
        _this.toCamelCase = function (s) {
            return s.toUpperCase().split("")[0] + s.toLowerCase().slice(1);
            ;
        };
        _this.snakeToCapitalCase = function (s) {
            return s.charAt(0).toUpperCase() + s.replace(/(\-\w)/g, function (m) { return m[1].toUpperCase(); }).slice(1);
        };
        _this.camelCaseToSnakeCase = function (s) {
            return s.replace(/([A-Z])/g, function ($1) { return "-" + $1.toLowerCase(); });
        };
        _this.replaceStringWithProperties = function (stringItem, context) {
            var properties = _this.getPropertiesFromString(stringItem);
            if (!properties)
                return;
            var data = [];
            angular.forEach(properties, function (property) {
                if (property.indexOf('.') != -1) {
                    property = property.replace('.', '_');
                }
                var parseFunction = _this.$parse(property);
                data.push(parseFunction(context));
            });
            return _this.replacePropertiesWithData(stringItem, data);
        };
        //used to do inheritance at runtime
        _this.extend = function (ChildClass, ParentClass) {
            ChildClass.prototype = new ParentClass();
            ChildClass.prototype.constructor = ChildClass;
        };
        _this.getQueryParamsFromUrl = function (url) {
            // This function is anonymous, is executed immediately and
            // the return value is assigned to QueryString!
            var query_string = {};
            if (url && url.split) {
                var spliturl = url.split('?');
                if (spliturl.length) {
                    url = spliturl[1];
                    if (url && url.split) {
                        var vars = url.split("&");
                        if (vars && vars.length) {
                            for (var i = 0; i < vars.length; i++) {
                                var pair = vars[i].split("=");
                                // If first entry with this name
                                if (typeof query_string[pair[0]] === "undefined") {
                                    query_string[pair[0]] = pair[1];
                                    // If second entry with this name
                                }
                                else if (typeof query_string[pair[0]] === "string") {
                                    var arr = [query_string[pair[0]], pair[1]];
                                    query_string[pair[0]] = arr;
                                    // If third or later entry with this name
                                }
                                else {
                                    query_string[pair[0]].push(pair[1]);
                                }
                            }
                        }
                    }
                }
            }
            return query_string;
        };
        _this.isAngularRoute = function () {
            return /[\?&]ng#!/.test(window.location.href);
        };
        _this.ArrayFindByPropertyValue = function (arr, property, value) {
            var currentIndex = -1;
            arr.forEach(function (arrItem, index) {
                if (arrItem[property] && arrItem[property] === value) {
                    currentIndex = index;
                }
            });
            return currentIndex;
        };
        _this.listLast = function (list, delimiter) {
            if (list === void 0) { list = ''; }
            if (delimiter === void 0) { delimiter = ','; }
            var listArray = list.split(delimiter);
            return listArray[listArray.length - 1];
        };
        _this.listRest = function (list, delimiter) {
            if (list === void 0) { list = ''; }
            if (delimiter === void 0) { delimiter = ","; }
            var listArray = list.split(delimiter);
            if (listArray.length) {
                listArray.splice(0, 1);
            }
            return listArray.join(delimiter);
        };
        _this.listFirst = function (list, delimiter) {
            if (list === void 0) { list = ''; }
            if (delimiter === void 0) { delimiter = ','; }
            var listArray = list.split(delimiter);
            return listArray[0];
        };
        _this.listPrepend = function (list, substring, delimiter) {
            if (list === void 0) { list = ''; }
            if (substring === void 0) { substring = ''; }
            if (delimiter === void 0) { delimiter = ','; }
            var listArray = list.split(delimiter);
            if (listArray.length) {
                return substring + delimiter + list;
            }
            else {
                return substring;
            }
        };
        _this.listAppend = function (list, substring, delimiter) {
            if (list === void 0) { list = ''; }
            if (substring === void 0) { substring = ''; }
            if (delimiter === void 0) { delimiter = ','; }
            var listArray = list.split(delimiter);
            if (list.trim() != '' && listArray.length) {
                return list + delimiter + substring;
            }
            else {
                return substring;
            }
        };
        _this.listAppendUnique = function (list, substring, delimiter) {
            if (list === void 0) { list = ''; }
            if (substring === void 0) { substring = ''; }
            if (delimiter === void 0) { delimiter = ','; }
            var listArray = list.split(delimiter);
            if (list.trim() != '' && listArray.length && listArray.indexOf(substring) == -1) {
                return list + delimiter + substring;
            }
            else {
                return substring;
            }
        };
        /**
         * Removes an element from a list.
         * str: The original list.
         * subStr: The element to remove.
         * returns the modified list.
         */
        _this.listRemove = function (str, substring) {
            var strArray = str.split(',');
            var index = strArray.indexOf(substring);
            if (index > -1) {
                strArray.splice(index, 1);
            }
            return strArray.join();
        };
        _this.formatValue = function (value, formatType, formatDetails, entityInstance) {
            if (angular.isUndefined(formatDetails)) {
                formatDetails = {};
            }
            var typeList = ["currency", "date", "datetime", "pixels", "percentage", "second", "time", "truefalse", "url", "weight", "yesno"];
            if (typeList.indexOf(formatType)) {
                _this['format_' + formatType](value, formatDetails, entityInstance);
            }
            return value;
        };
        _this.format_currency = function (value, formatDetails, entityInstance) {
            if (angular.isUndefined) {
                formatDetails = {};
            }
        };
        _this.format_date = function (value, formatDetails, entityInstance) {
            if (angular.isUndefined) {
                formatDetails = {};
            }
        };
        _this.format_datetime = function (value, formatDetails, entityInstance) {
            if (angular.isUndefined) {
                formatDetails = {};
            }
        };
        _this.format_pixels = function (value, formatDetails, entityInstance) {
            if (angular.isUndefined) {
                formatDetails = {};
            }
        };
        _this.format_yesno = function (value, formatDetails, entityInstance) {
            if (angular.isUndefined) {
                formatDetails = {};
            }
            if (Boolean(value) === true) {
                return entityInstance.metaData.$$getRBKey("define.yes");
            }
            else if (value === false || value.trim() === 'No' || value.trim === 'NO' || value.trim() === '0') {
                return entityInstance.metaData.$$getRBKey("define.no");
            }
        };
        _this.left = function (stringItem, count) {
            return stringItem.substring(0, count);
        };
        _this.right = function (stringItem, count) {
            return stringItem.substring(stringItem.length - count, stringItem.length);
        };
        //this.utilityService.mid(propertyIdentifier,1,propertyIdentifier.lastIndexOf('.'));
        _this.mid = function (stringItem, start, count) {
            var end = start + count;
            return stringItem.substring(start, end);
        };
        _this.getPropertiesFromString = function (stringItem) {
            if (!stringItem)
                return;
            var capture = false;
            var property = '';
            var results = [];
            for (var i = 0; i < stringItem.length; i++) {
                if (!capture && stringItem.substr(i, 2) == "${") {
                    property = '';
                    capture = true;
                    i = i + 1; //skip the ${
                }
                else if (capture && stringItem[i] != '}') {
                    property = property.concat(stringItem[i]);
                }
                else if (capture) {
                    results.push(property);
                    capture = false;
                }
            }
            return results;
        };
        _this.replacePropertiesWithData = function (stringItem, data) {
            var results = _this.getPropertiesFromString(stringItem);
            for (var i = 0; i < results.length; i++) {
                stringItem = stringItem.replace('${' + results[i] + '}', data[i]);
            }
            return stringItem;
        };
        _this.replaceAll = function (stringItem, find, replace) {
            return stringItem.replace(new RegExp(_this.escapeRegExp(find), 'g'), replace);
        };
        _this.escapeRegExp = function (stringItem) {
            return stringItem.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1");
        };
        _this.createID = function (count) {
            var count = count || 26;
            var text = "";
            var firstPossibleCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
            var nextPossibleCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
            var currentPossibleCharacters = "";
            for (var i = 0; i < count; i++) {
                if (i === 0) {
                    currentPossibleCharacters = firstPossibleCharacters;
                }
                else {
                    currentPossibleCharacters = nextPossibleCharacters;
                }
                text += currentPossibleCharacters.charAt(Math.floor(Math.random() * currentPossibleCharacters.length));
            }
            return text;
        };
        //list functions
        _this.arrayToList = function (array, delimiter) {
            if (delimiter != null) {
                return array.join(delimiter);
            }
            else {
                return array.join();
            }
        };
        _this.getPropertyValue = function (object, propertyIdentifier) {
            var keys = propertyIdentifier.split('.'), obj = object, keyPart;
            while ((keyPart = keys.shift()) && keys.length) {
                obj = obj[keyPart];
            }
            return obj[keyPart];
        };
        _this.setPropertyValue = function (object, propertyIdentifier, value) {
            var keys = propertyIdentifier.split('.'), obj = object, keyPart;
            while ((keyPart = keys.shift()) && keys.length) {
                if (!obj[keyPart]) {
                    obj[keyPart] = {};
                }
                obj = obj[keyPart];
            }
            obj[keyPart] = value;
        };
        _this.nvpToObject = function (NVPData) {
            var object = {};
            for (var key in NVPData) {
                var value = NVPData[key];
                var propertyIdentitifer = key.replace(/\_/g, '.');
                _this.setPropertyValue(object, propertyIdentitifer, value);
            }
            return object;
        };
        _this.isDescendantElement = function (parent, child) {
            var node = child.parentNode;
            while (node != null) {
                if (node == parent) {
                    return true;
                }
                node = node.parentNode;
            }
            return false;
        };
        //utility service toJson avoids circular references
        _this.toJson = function (obj) {
            var seen = [];
            return JSON.stringify(obj, function (key, val) {
                if (val != null && typeof val == "object") {
                    if (seen.indexOf(val) >= 0) {
                        return;
                    }
                    seen.push(val);
                }
                return val;
            });
        };
        _this.getCaseInsensitiveStructKey = function (obj, prop) {
            prop = (prop + "").toLowerCase();
            for (var p in obj) {
                if (obj.hasOwnProperty(p) && prop == (p + "").toLowerCase()) {
                    return p;
                    break;
                }
            }
        };
        _this.listFindNoCase = function (list, value, delimiter) {
            if (list === void 0) { list = ''; }
            if (value === void 0) { value = ''; }
            if (delimiter === void 0) { delimiter = ','; }
            list = list.toLowerCase();
            value = value.toLowerCase();
            return _this.listFind(list, value, delimiter);
        };
        _this.listFind = function (list, value, delimiter) {
            if (list === void 0) { list = ''; }
            if (value === void 0) { value = ''; }
            if (delimiter === void 0) { delimiter = ','; }
            var splitString = list.split(delimiter);
            var stringFound = -1;
            for (var i = 0; i < splitString.length; i++) {
                var stringPart = splitString[i];
                if (stringPart === value) {
                    stringFound = i;
                }
            }
            return stringFound;
        };
        _this.listLen = function (list, delimiter) {
            if (list === void 0) { list = ''; }
            if (delimiter === void 0) { delimiter = ','; }
            var splitString = list.split(delimiter);
            return splitString.length;
        };
        //This will enable you to sort by two separate keys in the order they are passed in
        _this.arraySorter = function (array, keysToSortBy) {
            var arrayOfTypes = [], returnArray = [], firstKey = keysToSortBy[0];
            if (angular.isDefined(keysToSortBy[1])) {
                var secondKey = keysToSortBy[1];
            }
            for (var itemIndex in array) {
                if (!(arrayOfTypes.indexOf(array[itemIndex][firstKey]) > -1)) {
                    arrayOfTypes.push(array[itemIndex][firstKey]);
                }
            }
            arrayOfTypes.sort(function (a, b) {
                if (a < b) {
                    return -1;
                }
                else if (a > b) {
                    return 1;
                }
                else {
                    return 0;
                }
            });
            for (var typeIndex in arrayOfTypes) {
                var tempArray = [];
                for (var itemIndex in array) {
                    if (array[itemIndex][firstKey] == arrayOfTypes[typeIndex]) {
                        tempArray.push(array[itemIndex]);
                    }
                }
                if (keysToSortBy[1] != null) {
                    tempArray.sort(function (a, b) {
                        if (a[secondKey] < b[secondKey]) {
                            return -1;
                        }
                        else if (a[secondKey] > b[secondKey]) {
                            return 1;
                        }
                        else {
                            return 0;
                        }
                    });
                }
                for (var finalIndex in tempArray) {
                    returnArray.push(tempArray[finalIndex]);
                }
            }
            return returnArray;
        };
        _this.minutesOfDay = function (m) {
            return m.getMinutes() + m.getHours() * 60;
        };
        return _this;
    }
    return UtilityService;
}(baseservice_1.BaseService));
exports.UtilityService = UtilityService;


/***/ }),

/***/ "mJ79":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.OtherWiseController = void 0;
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var OtherWiseController = /** @class */ (function () {
    //@ngInject
    OtherWiseController.$inject = ["$scope"];
    function OtherWiseController($scope) {
        $scope.$id = "otherwiseController";
    }
    return OtherWiseController;
}());
exports.OtherWiseController = OtherWiseController;


/***/ }),

/***/ "nF2I":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWFCartItems = exports.SWFCartItemsController = void 0;
var SWFCartItemsController = /** @class */ (function () {
    function SWFCartItemsController($rootScope, observerService) {
        var _this = this;
        this.$rootScope = $rootScope;
        this.observerService = observerService;
        this.getProductDescriptionAndTruncate = function (length) {
            if (length === void 0) { length = 4000; }
            return _this.stripHtml(_this.orderItem.sku.product.productDescription).substring(0, length);
        };
        this.stripHtml = function (html) {
            var tmp = document.createElement("DIV");
            tmp.innerHTML = html;
            return tmp.textContent || tmp.innerText || "";
        };
        this.updateOrderItemQuantity = function (newQuantity, child) {
            var orderItemID = child ? child.orderItemID : _this.orderItem.orderItemID;
            _this.updateOrderItemQuantityIsLoading = true;
            var data = {
                'orderItem.orderItemID': orderItemID,
                'orderItem.quantity': newQuantity,
                'returnJsonObjects': 'cart'
            };
            _this.$rootScope.slatwall.doAction('updateOrderItemQuantity', data)
                .then(function (result) {
                if (result.successfulActions.length) {
                    _this.observerService.notify('updatedCart', result.cart);
                }
                _this.updateOrderItemQuantityIsLoading = false;
            });
        };
        this.removeOrderItem = function (child) {
            var orderItemID = child ? child.orderItemID : _this.orderItem.orderItemID;
            _this.removeOrderItemIsLoading = true;
            var data = {
                'orderItemID': _this.orderItem.orderItemID,
                'returnJsonObjects': 'cart'
            };
            _this.$rootScope.slatwall.doAction('removeOrderItem', data)
                .then(function (result) {
                if (result.successfulActions.length) {
                    _this.observerService.notify('updatedCart', result.cart);
                }
                _this.removeOrderItemIsLoading = false;
            });
        };
        this.clearCartItems = function () {
            _this.$rootScope.slatwall.doAction('clearOrder', { 'returnJsonObjects': 'cart' });
        };
        this.loadingImages = true;
        this.$rootScope = $rootScope;
        this.$rootScope.slatwall.doAction('getResizedImageByProfileName', {
            profileName: 'small',
            skuIds: this.orderItem.sku.skuID,
            'returnJsonObjects': 'cart'
        })
            .then(function (result) {
            if (result) {
                _this.orderItem.sku.smallImagePath = result.resizedImagePaths[_this.orderItem.sku.skuID];
                _this.loadingImages = false;
            }
        });
    }
    return SWFCartItemsController;
}());
exports.SWFCartItemsController = SWFCartItemsController;
var SWFCartItems = /** @class */ (function () {
    //@ngInject
    SWFCartItems.$inject = ["$rootScope"];
    function SWFCartItems($rootScope) {
        return {
            controller: SWFCartItemsController,
            controllerAs: "swfCartItems",
            bindToController: {
                orderItem: "<"
            },
            restrict: "A",
            link: function (scope, element, attributes, ngModel) {
            }
        };
    }
    SWFCartItems.Factory = function () {
        var directive = function ($rootScope) { return new SWFCartItems($rootScope); };
        directive.$inject = ['$rootScope'];
        return directive;
    };
    return SWFCartItems;
}());
exports.SWFCartItems = SWFCartItems;


/***/ }),

/***/ "nFws":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWFNavigation = exports.SWFNavigationController = void 0;
var SWFNavigationController = /** @class */ (function () {
    function SWFNavigationController($rootScope, $scope, $timeout) {
        var _this = this;
        this.$rootScope = $rootScope;
        this.$scope = $scope;
        this.$timeout = $timeout;
        this.accountTabDisabled = false;
        this.fulfillmentTabDisabled = true;
        this.paymentTabDisabled = true;
        this.reviewTabDisabled = true;
        this.accountTabCompleted = false;
        this.fulfillmentTabCompleted = true;
        this.paymentTabCompleted = true;
        this.updateNavbar = function (orderRequirementsList, oldList) {
            console.log('updateSlabbar', orderRequirementsList);
            if (orderRequirementsList != undefined) {
                _this.accountTabDisabled = orderRequirementsList.indexOf('account') === -1;
                _this.accountTabCompleted = _this.accountTabDisabled;
                _this.fulfillmentTabDisabled = orderRequirementsList.indexOf('account') > -1;
                _this.fulfillmentTabCompleted = orderRequirementsList.indexOf('fulfillment') === -1;
                _this.paymentTabDisabled = _this.fulfillmentTabDisabled || orderRequirementsList.indexOf('fulfillment') > -1;
                _this.paymentTabCompleted = orderRequirementsList.indexOf('payment') === -1;
                _this.reviewTabDisabled = _this.paymentTabDisabled || orderRequirementsList.indexOf('payment') > -1;
            }
            if (!_this.slatwall.account.accountID) {
                _this.showTab('account');
            }
            else if (!oldList && orderRequirementsList) {
                _this.selectTab(_this.slatwall.account.accountID);
            }
            if (_this.manualDisable) {
                _this.updateDisabledTabs();
            }
        };
        this.selectTab = function (accountID) {
            var orderRequirementsList = _this.slatwall.cart.orderRequirementsList;
            console.log('selectSlab', orderRequirementsList);
            var activeTab = 'review';
            if (!accountID || orderRequirementsList == undefined) {
                activeTab = 'account';
            }
            else {
                var sections = ['account', 'fulfillment', 'payment'];
                for (var index = sections.length - 1; index >= 0; index--) {
                    var section = sections[index];
                    if (orderRequirementsList.includes(section)) {
                        activeTab = section;
                    }
                }
            }
            if (activeTab.length) {
                _this.showTab(activeTab);
            }
        };
        this.updateDisabledTabs = function () {
            if (_this.tabs && !_this.tabTargets) {
                _this.getTabTargets();
            }
            if (_this.tabTargets) {
                for (var key in _this.tabs) {
                    _this.updateDisabledTab(key);
                }
            }
        };
        this.updateDisabledTab = function (key) {
            if (!_this.tabs || !_this.tabs[key]) {
                return;
            }
            if (!_this.tabTargets || !_this.tabTargets[key]) {
                _this.getTabTarget(key);
            }
            if (_this[key + 'TabDisabled'] && _this.tabs[key].attr('href')) {
                _this.removeTarget(key);
            }
            else if (!_this[key + 'TabDisabled'] && !_this.tabs[key].attr('href')) {
                _this.restoreTarget(key);
            }
            else {
            }
        };
        this.getTabTargets = function () {
            _this.tabTargets = {
                account: _this.tabs.account.attr('href'),
                fulfillment: _this.tabs.fulfillment.attr('href'),
                payment: _this.tabs.payment.attr('href'),
                review: _this.tabs.review.attr('href')
            };
        };
        this.getTabTarget = function (key) {
            _this.tabTargets = _this.tabTargets || {};
            _this.tabTargets[key] = _this.tabs[key].attr('href');
        };
        this.removeTarget = function (key) {
            _this.tabs[key].attr('href', null);
        };
        this.restoreTarget = function (key) {
            _this.tabs[key].attr('href', _this.tabTargets[key]);
        };
        this.$rootScope = $rootScope;
        if (!this.actionType) {
            this.actionType = 'tab';
        }
        this.slatwall = $rootScope.slatwall;
        // $scope.$watch('tabs', ()=>{
        //     this.updateNavbar(this.slatwall.cart.orderRequirementsList);
        //     this.selectTab();
        // })
        $scope.$watch('slatwall.cart.orderRequirementsList', this.updateNavbar);
        $scope.$watch('slatwall.account.accountID', this.selectTab);
    }
    SWFNavigationController.prototype.showTab = function (tab) {
        var _this = this;
        this[tab + 'TabDisabled'] = false;
        if (this.manualDisable) {
            this.updateDisabledTab(tab);
        }
        this.$timeout(function () {
            var actionTarget;
            if (_this.actionType == 'collapse') {
                actionTarget = $(_this.tabTargets[tab]);
            }
            else {
                actionTarget = _this.tabs[tab];
            }
            actionTarget[_this.actionType]('show');
        });
    };
    return SWFNavigationController;
}());
exports.SWFNavigationController = SWFNavigationController;
var SWFNavigation = /** @class */ (function () {
    //@ngInject
    SWFNavigation.$inject = ["$rootScope"];
    function SWFNavigation($rootScope) {
        return {
            controller: SWFNavigationController,
            controllerAs: "swfNavigation",
            bindToController: {
                manualDisable: "=?",
                actionType: "@?"
            },
            restrict: "A",
            link: function (scope, element, attributes, controller) {
                var tabs = {
                    account: $('#account-tab'),
                    fulfillment: $('#fulfillment-tab'),
                    payment: $('#payment-tab'),
                    review: $('#review-tab')
                };
                controller.tabs = tabs;
            }
        };
    }
    SWFNavigation.Factory = function () {
        var directive = function ($rootScope) { return new SWFNavigation($rootScope); };
        directive.$inject = ['$rootScope'];
        return directive;
    };
    return SWFNavigation;
}());
exports.SWFNavigation = SWFNavigation;


/***/ }),

/***/ "nH03":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWCollectionConfigController = exports.SWCollectionConfig = void 0;
var SWCollectionConfigController = /** @class */ (function () {
    //@ngInject
    SWCollectionConfigController.$inject = ["$transclude", "$q", "collectionConfigService"];
    function SWCollectionConfigController($transclude, $q, collectionConfigService) {
        this.$transclude = $transclude;
        this.$q = $q;
        this.collectionConfigService = collectionConfigService;
        this.filters = [];
        this.columns = [];
        this.orderBys = [];
        this.keywordColumns = [];
        this.columnsDeferred = this.$q.defer();
        this.columnsPromise = this.columnsDeferred.promise;
        this.filtersDeferred = this.$q.defer();
        this.filtersPromise = this.filtersDeferred.promise;
        this.orderBysDeferred = this.$q.defer();
        this.orderBysPromise = this.columnsDeferred.promise;
    }
    return SWCollectionConfigController;
}());
exports.SWCollectionConfigController = SWCollectionConfigController;
var SWCollectionConfig = /** @class */ (function () {
    // @ngInject
    SWCollectionConfig.$inject = ["collectionConfigService", "listingService", "scopeService", "$q"];
    function SWCollectionConfig(collectionConfigService, listingService, scopeService, $q) {
        var _this = this;
        this.collectionConfigService = collectionConfigService;
        this.listingService = listingService;
        this.scopeService = scopeService;
        this.$q = $q;
        this.restrict = 'EA';
        this.scope = true;
        this.transclude = {
            columns: "?swCollectionColumns",
            filters: "?swCollectionFilters",
            orderBys: "?swCollectionOrderBys"
        };
        this.bindToController = {
            allRecords: "=?",
            collectionConfigProperty: "@?",
            distinct: "=?",
            entityName: "@",
            filterFlag: "=?",
            inListingDisplay: "=?",
            multiCollectionConfigProperty: "@?",
            pageShow: "@?",
            parentDirectiveControllerAsName: "@?",
            parentDeferredProperty: "@?"
        };
        this.controller = SWCollectionConfigController;
        this.controllerAs = "swCollectionConfig";
        this.template = " \n        <div ng-transclude=\"columns\"></div>\n        <div ng-transclude=\"filters\"></div>\n        <div ng-transclude=\"orderBys\"></div>\n    ";
        this.link = function (scope, element, attrs) {
            //some automatic configuration for listing display
            if (angular.isUndefined(scope.swCollectionConfig.inListingDisplay)) {
                scope.swCollectionConfig.inListingDisplay = false;
            }
            if (scope.swCollectionConfig.inListingDisplay) {
                scope.swCollectionConfig.parentDirectiveControllerAsName = "swListingDisplay";
                scope.swCollectionConfig.parentDeferredProperty = "singleCollectionDeferred";
            }
            if (angular.isUndefined(scope.swCollectionConfig.entityName)) {
                throw ("You must provide an entityname to swCollectionConfig");
            }
            if (angular.isUndefined(scope.swCollectionConfig.parentDirectiveControllerAsName) && !scope.swCollectionConfig.inListingDisplay) {
                throw ("You must provide the parent directives Controller-As Name to swCollectionConfig");
            }
            if (angular.isUndefined(scope.swCollectionConfig.collectionConfigProperty)) {
                scope.swCollectionConfig.collectionConfigProperty = "collectionConfig";
            }
            if (angular.isUndefined(scope.swCollectionConfig.allRecords)) {
                scope.swCollectionConfig.allRecords = false;
            }
            if (angular.isUndefined(scope.swCollectionConfig.pageShow)) {
                scope.swCollectionConfig.pageShow = 10;
            }
            if (angular.isUndefined(scope.swCollectionConfig.distinct)) {
                scope.swCollectionConfig.distinct = false;
            }
            if (angular.isUndefined(scope.swCollectionConfig.filterFlag)) {
                scope.swCollectionConfig.filterFlag = true; //assume there are filters
            }
            var allCollectionConfigPromises = [];
            var currentScope = scope;
            //we want to wait for all sibling scopes before pushing the collection config
            while (angular.isDefined(currentScope)) {
                if (angular.isDefined(currentScope.swCollectionConfig)) {
                    allCollectionConfigPromises.push(currentScope.swCollectionConfig.columnsPromise);
                    if (scope.swCollectionConfig.filterFlag) {
                        allCollectionConfigPromises.push(currentScope.swCollectionConfig.filtersPromise);
                    }
                }
                currentScope = currentScope.$$nextSibling;
                if (currentScope == null) {
                    break;
                }
            }
            var newCollectionConfig = _this.collectionConfigService.newCollectionConfig(scope.swCollectionConfig.entityName);
            newCollectionConfig.setAllRecords(scope.swCollectionConfig.allRecords);
            newCollectionConfig.setDistinct(scope.swCollectionConfig.distinct);
            newCollectionConfig.setPageShow(scope.swCollectionConfig.pageShow);
            var currentScope = _this.scopeService.getRootParentScope(scope, scope.swCollectionConfig.parentDirectiveControllerAsName);
            if (currentScope[scope.swCollectionConfig.parentDirectiveControllerAsName]) {
                var parentDirective = currentScope[scope.swCollectionConfig.parentDirectiveControllerAsName];
            }
            else {
                throw ("swCollectionConfig was unable to find a parent scope");
            }
            scope.swCollectionConfig.columnsPromise.then(function () {
                angular.forEach(scope.swCollectionConfig.columns, function (column) {
                    newCollectionConfig.addDisplayProperty(column.propertyIdentifier, '', column);
                });
            });
            scope.swCollectionConfig.filtersPromise.then(function () {
                angular.forEach(scope.swCollectionConfig.filters, function (filter) {
                    newCollectionConfig.addFilter(filter.propertyIdentifier, filter.comparisonValue, filter.comparisonOperator, filter.logicalOperator, filter.hidden);
                });
            });
            scope.swCollectionConfig.orderBysPromise.then(function () {
                angular.forEach(scope.swCollectionConfig.orderBys, function (orderBy) {
                    newCollectionConfig.addOrderBy(orderBy);
                });
            });
            _this.$q.all(allCollectionConfigPromises).then(function () {
                if (angular.isDefined(parentDirective)) {
                    if (angular.isDefined(scope.swCollectionConfig.multiCollectionConfigProperty)
                        && angular.isDefined(parentDirective[scope.swCollectionConfig.multiCollectionConfigProperty])) {
                        parentDirective[scope.swCollectionConfig.multiCollectionConfigProperty].push(newCollectionConfig);
                    }
                    else if (angular.isDefined(parentDirective[scope.swCollectionConfig.collectionConfigProperty])) {
                        parentDirective[scope.swCollectionConfig.collectionConfigProperty] = newCollectionConfig;
                    }
                    else {
                        throw ("swCollectionConfig could not locate a collection config property to bind it's collection to");
                    }
                    if (angular.isDefined(parentDirective[scope.swCollectionConfig.parentDeferredProperty])) {
                        parentDirective[scope.swCollectionConfig.parentDeferredProperty].resolve();
                    }
                    else {
                        //throw("SWCollectionConfig cannot resolve rule");
                    }
                }
            }, function (reason) {
                throw ("SWCollectionConfig is having some issues.");
            });
        };
    }
    SWCollectionConfig.Factory = function () {
        var _this = this;
        return /** @ngInject; */ ["collectionConfigService", "listingService", "scopeService", "$q", function (collectionConfigService, listingService, scopeService, $q) {
            return new _this(collectionConfigService, listingService, scopeService, $q);
        }];
    };
    return SWCollectionConfig;
}());
exports.SWCollectionConfig = SWCollectionConfig;


/***/ }),

/***/ "nXj+":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.BaseObject = void 0;
var BaseObject = /** @class */ (function () {
    //@ngInject
    BaseObject.$inject = ["$injector"];
    function BaseObject($injector) {
        var _this = this;
        this.getService = function (serviceName) {
            //return;
            if (_this.$injector.has(serviceName)) {
                //returns a generic service
                return _this.$injector.get(serviceName);
            }
        };
        this.getHibachiScope = function () {
            return _this.getService('publicService');
        };
        this.getAppConfig = function () {
            return _this.getService('appConfig');
        };
        this.$injector = $injector;
        var constructorString = this.constructor.toString();
        this.className = constructorString.match(/\w+/g)[1];
    }
    return BaseObject;
}());
exports.BaseObject = BaseObject;


/***/ }),

/***/ "np4f":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWFormFieldSearchSelect = void 0;
var SWFormFieldSearchSelect = /** @class */ (function () {
    function SWFormFieldSearchSelect($log, $hibachi, coreFormPartialsPath, hibachiPathBuilder) {
        return {
            templateUrl: hibachiPathBuilder.buildPartialsPath(coreFormPartialsPath) + 'search-select.html',
            require: "^form",
            restrict: 'E',
            scope: {
                propertyDisplay: "="
            },
            link: function (scope, element, attr, formController) {
                //set up selectionOptions
                scope.selectionOptions = {
                    value: [],
                    $$adding: false
                };
                //match in matches track by
                //function to set state of adding new item
                scope.setAdding = function (isAdding) {
                    scope.isAdding = isAdding;
                    scope.showAddBtn = false;
                };
                scope.selectedOption = {};
                scope.showAddBtn = false;
                var propertyMetaData = scope.propertyDisplay.object.$$getMetaData(scope.propertyDisplay.property);
                //create basic
                var object = $hibachi.newEntity(propertyMetaData.cfc);
                //				scope.propertyDisplay.template = '';
                //				//check for a template
                //				//rules are tiered: check if an override is specified at scope.template, check if the cfc name .html exists, use
                //				var templatePath = coreFormPartialsPath + 'formfields/searchselecttemplates/';
                //				if(angular.isUndefined(scope.propertyDisplay.template)){
                //					var templatePromise = $http.get(templatePath+propertyMetaData.cfcProperCase+'.html',function(){
                //						$log.debug('template');
                //						scope.propertyDisplay.template = templatePath+propertyMetaData.cfcProperCase+'.html';
                //					},function(){
                //						scope.propertyDisplay.template = templatePath+'index.html';
                //						$log.debug('template');
                //						$log.debug(scope.propertyDisplay.template);
                //					});
                //				}
                //set up query function for finding related object
                scope.cfcProperCase = propertyMetaData.cfcProperCase;
                scope.selectionOptions.getOptionsByKeyword = function (keyword) {
                    var filterGroupsConfig = '[' +
                        ' {  ' +
                        '"filterGroup":[  ' +
                        '{' +
                        ' "propertyIdentifier":"_' + scope.cfcProperCase.toLowerCase() + '.' + scope.cfcProperCase + 'Name",' +
                        ' "comparisonOperator":"like",' +
                        ' "ormtype":"string",' +
                        ' "value":"%' + keyword + '%"' +
                        '  }' +
                        ' ]' +
                        ' }' +
                        ']';
                    return $hibachi.getEntity(propertyMetaData.cfc, { filterGroupsConfig: filterGroupsConfig.trim() })
                        .then(function (value) {
                        $log.debug('typesByKeyword');
                        $log.debug(value);
                        scope.selectionOptions.value = value.pageRecords;
                        var myLength = keyword.length;
                        if (myLength > 0) {
                            scope.showAddBtn = true;
                        }
                        else {
                            scope.showAddBtn = false;
                        }
                        return scope.selectionOptions.value;
                    });
                };
                var propertyPromise = scope.propertyDisplay.object['$$get' + propertyMetaData.nameCapitalCase]();
                propertyPromise.then(function (data) {
                });
                //set up behavior when selecting an item
                scope.selectItem = function ($item, $model, $label) {
                    scope.$item = $item;
                    scope.$model = $model;
                    scope.$label = $label;
                    scope.showAddBtn = false; //turns off the add btn on select
                    //angular.extend(inflatedObject.data,$item);
                    object.$$init($item);
                    $log.debug('select item');
                    $log.debug(object);
                    scope.propertyDisplay.object['$$set' + propertyMetaData.nameCapitalCase](object);
                };
                //				if(angular.isUndefined(scope.propertyDipslay.object[scope.propertyDisplay.property])){
                //					$log.debug('getmeta');
                //					$log.debug(scope.propertyDisplay.object.metaData[scope.propertyDisplay.property]);
                //
                //					//scope.propertyDipslay.object['$$get'+]
                //				}
                //
                //				scope.propertyDisplay.object.data[scope.propertyDisplay.property].$dirty = true;
            }
        };
    }
    SWFormFieldSearchSelect.Factory = function () {
        var directive = function ($log, $hibachi, coreFormPartialsPath, hibachiPathBuilder) { return new SWFormFieldSearchSelect($log, $hibachi, coreFormPartialsPath, hibachiPathBuilder); };
        directive.$inject = [
            '$log',
            '$hibachi',
            'coreFormPartialsPath',
            'hibachiPathBuilder'
        ];
        return directive;
    };
    return SWFormFieldSearchSelect;
}());
exports.SWFormFieldSearchSelect = SWFormFieldSearchSelect;


/***/ }),

/***/ "odag":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.OrderItem = void 0;
/// <reference path='../../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../typings/tsd.d.ts' />
var baseentity_1 = __webpack_require__("L67B");
var OrderItem = /** @class */ (function (_super) {
    __extends(OrderItem, _super);
    function OrderItem($injector) {
        return _super.call(this, $injector) || this;
    }
    return OrderItem;
}(baseentity_1.BaseEntity));
exports.OrderItem = OrderItem;


/***/ }),

/***/ "oj0J":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.BaseBootStrapper = void 0;
/// <reference path='../typings/hibachiTypescript.d.ts' />
/// <reference path='../typings/tsd.d.ts' />
var core_module_1 = __webpack_require__("pwA0");
var md5 = __webpack_require__("ssIG");
//generic bootstrapper
var BaseBootStrapper = /** @class */ (function () {
    function BaseBootStrapper(myApplication) {
        var _this = this;
        this._resourceBundle = {};
        this.getBaseUrl = function () {
            var urlString = "";
            if (!hibachiConfig) {
                hibachiConfig = {};
            }
            if (!hibachiConfig.baseURL) {
                hibachiConfig.baseURL = '';
            }
            urlString += hibachiConfig.baseURL;
            if (hibachiConfig.baseURL.length && hibachiConfig.baseURL.charAt(hibachiConfig.baseURL.length - 1) != '/') {
                urlString += '/';
            }
            return urlString;
        };
        this.isPrivateMode = function () {
            return _this.$q(function (resolve, reject) {
                var on = function () {
                    _this.isPrivate = true; // is in private mode
                    resolvePromise();
                };
                var off = function () {
                    _this.isPrivate = false; // not private mode 
                    resolvePromise();
                };
                var resolvePromise = function () {
                    resolve(_this.isPrivate);
                };
                if (_this.isPrivate !== null) { //if already determined, (in some earlier call)
                    return resolvePromise();
                }
                var testLocalStorage = function () {
                    try {
                        if (localStorage.length) {
                            off();
                        }
                        else {
                            localStorage.setItem('x', '1');
                            localStorage.removeItem('x');
                            off();
                        }
                    }
                    catch (e) {
                        // Safari only enables cookie in private mode
                        // if cookie is disabled then all client side storage is disabled
                        // if all client side storage is disabled, then there is no point
                        // in using private mode
                        navigator.cookieEnabled ? on() : off();
                    }
                };
                // Chrome & Opera
                if (window.webkitRequestFileSystem) {
                    return void window.webkitRequestFileSystem(0, 0, off, on);
                }
                // Firefox
                if ('MozAppearance' in document.documentElement.style) {
                    var db = indexedDB.open('test');
                    db.onerror = on;
                    db.onsuccess = off;
                    return void 0;
                }
                // Safari
                if (/constructor/i.test(window.HTMLElement)) {
                    return testLocalStorage();
                }
                // IE10+ & Edge
                if (!window.indexedDB && (window.PointerEvent || window.MSPointerEvent)) {
                    return on();
                }
                // others
                return off();
            });
        };
        this.getInstantiationKey = function () {
            return _this.$q(function (resolve, reject) {
                if (_this.instantiationKey) {
                    resolve(_this.instantiationKey);
                }
                else if (hibachiConfig.instantiationKey) {
                    resolve(hibachiConfig.instantiationKey);
                }
                else {
                    _this.$http.get(_this.getBaseUrl() + '?' + hibachiConfig.action + '=api:main.getInstantiationKey')
                        .then(function (resp) {
                        _this.instantiationKey = resp.data.data.instantiationKey;
                        resolve(_this.instantiationKey);
                    });
                }
            });
        };
        this.getData = function (invalidCache) {
            var promises = {};
            invalidCache.forEach(function (cacheItem) {
                var camelCaseFunctionName = cacheItem.charAt(0).toUpperCase() + cacheItem.slice(1);
                promises[cacheItem] = _this['get' + camelCaseFunctionName + 'Data'](); // mind the syntax 8)
            });
            return _this.$q.all(promises);
        };
        this.getAttributeCacheKeyData = function () {
            var urlString = _this.getBaseUrl();
            return _this.$http
                .get(urlString + '?' + hibachiConfig.action + '=api:main.getAttributeModel')
                .then(function (resp) { return resp.data.data; })
                .then(function (data) {
                core_module_1.coremodule.constant('attributeMetaData', data);
                _this.attributeMetaData = data;
                return data;
            })
                .then(function (data) {
                return _this.$q(function (resolve, reject) {
                    _this.isPrivateMode().then(function (privateMode) {
                        if (!privateMode) {
                            var metadataSreing = JSON.stringify(data);
                            localStorage.setItem('attributeMetaData', metadataSreing);
                            localStorage.setItem('attributeChecksum', md5(metadataSreing));
                            // NOTE: at this point attributeChecksum == hibachiConfig.attributeCacheKey
                            // Keeps localStorage appConfig.attributeCacheKey consistent after attributeChecksum updates (even though it is not referenced apparently)
                            _this.appConfig['attributeCacheKey'] = localStorage.getItem('attributeChecksum').toUpperCase();
                            localStorage.setItem('appConfig', JSON.stringify(_this.appConfig));
                        }
                        resolve(data);
                    });
                });
            })
                .catch(function (e) {
                console.error(e);
            });
        };
        this.getInstantiationKeyData = function () {
            var urlString = _this.getBaseUrl();
            return _this.getInstantiationKey()
                .then(function (instantiationKey) {
                return _this.$http.get(urlString + '/custom/system/config.json?instantiationKey=' + instantiationKey);
            })
                .then(function (resp) { return resp.data.data; })
                .then(function (data) {
                return _this.$q(function (resolve, reject) {
                    _this.isPrivateMode().then(function (privateMode) {
                        if (!privateMode) {
                            localStorage.setItem('appConfig', JSON.stringify(data));
                        }
                        resolve(data);
                    });
                });
            })
                .then(function (appConfig) {
                // override config
                for (var config in hibachiConfig) {
                    appConfig[config] = hibachiConfig[config];
                }
                core_module_1.coremodule.constant('appConfig', appConfig);
                _this.appConfig = appConfig;
            })
                .then(function () { return _this.getResourceBundles(); })
                .catch(function (e) {
                console.error(e);
            });
        };
        this.getResourceBundle = function (locale) {
            var deferred = _this.$q.defer();
            var locale = locale || _this.appConfig.rbLocale;
            if (_this._resourceBundle[locale]) {
                return _this._resourceBundle[locale];
            }
            var urlString = _this.appConfig.baseURL + '/custom/system/resourceBundles/' + locale + '.json?instantiationKey=' + _this.appConfig.instantiationKey;
            _this.$http({ url: urlString, method: "GET" })
                .success(function (response, status, headersGetter) {
                _this._resourceBundle[locale] = response;
                deferred.resolve(response);
            })
                .error(function (response, status) {
                if (status === 404) {
                    _this._resourceBundle[locale] = {};
                    deferred.resolve(response);
                }
                else {
                    deferred.reject(response);
                }
            });
            return deferred.promise;
        };
        this.getResourceBundles = function () {
            var rbLocale = _this.appConfig.rbLocale || 'en';
            if (rbLocale == 'en_us') {
                rbLocale = 'en';
            }
            // we want to wait untill all of the bundles are downloaded, so creating an array of promisses
            var rbPromises = [];
            rbPromises.push(_this.getResourceBundle(rbLocale));
            // if the locale is like "es_mx", we also want to fetch bundle for 'es', as a fallback language
            var localeListArray = rbLocale.split('_');
            if (localeListArray.length === 2) {
                rbPromises.push(_this.getResourceBundle(localeListArray[0]));
            }
            // if the first part of the locale isn't "en", we also want to fetch bundle for 'en' as it's the fallback language
            if (localeListArray[0] !== 'en') {
                rbPromises.push(_this.getResourceBundle('en'));
            }
            /**
             * the language fallback order for locale es_mx will be like
             *
             *  >> the locale                               : 'es_mx'
             *      >>  the first language of the locale    : 'es'
             *          >> the default language             : 'en'
            */
            return _this.$q.all(rbPromises)
                .then(function (data) {
                core_module_1.coremodule.constant('resourceBundles', _this._resourceBundle);
            })
                .catch(function (e) {
                //can enter here due to 404
                core_module_1.coremodule.constant('resourceBundles', _this._resourceBundle);
                console.error(e);
            });
        };
        this.getAuthInfo = function () {
            return _this.$http
                .get(_this.appConfig.baseURL + '?' + _this.appConfig.action + '=api:main.login')
                .then(function (loginResponse) {
                if (loginResponse.status === 200) {
                    core_module_1.coremodule.value('token', loginResponse.data.token);
                }
                else {
                    throw loginResponse;
                }
            })
                .catch(function (e) {
                core_module_1.coremodule.value('token', 'invalidToken');
                console.error(e);
            });
        };
        this.myApplication = myApplication;
        this.appConfig = {
            instantiationKey: undefined
        };
        // Inspecting app config/model metadata in local storage (retreived from /custom/system/config.json)
        return angular.lazy(this.myApplication).resolve(['$http', '$q', function ($http, $q) {
                _this.$http = $http;
                _this.$q = $q;
                return _this.getInstantiationKey().then(function (instantiationKey) {
                    _this.instantiationKey = instantiationKey;
                    var invalidCache = [];
                    // NOTE: Return a promise so bootstrapping process will wait to continue executing 
                    // until after the last step of loading the resourceBundles
                    return _this.isPrivateMode().then(function (privateMode) {
                        if (!privateMode) {
                            return invalidCache;
                        }
                        throw ("Private mode"); // this gets catched() down the line and we reload everythign from the API, instead of using the cached-data
                    })
                        .then(function () {
                        // Inspecting attribute model metadata in local storage 
                        // (retreived from slatAction=api:main.getAttributeModel)
                        var hashedData = localStorage.getItem('attributeChecksum');
                        if (hibachiConfig.attributeCacheKey === (hashedData === null || hashedData === void 0 ? void 0 : hashedData.toUpperCase())) {
                            // attributeMetaData is valid and can be restored from local storage cache
                            core_module_1.coremodule.constant('attributeMetaData', JSON.parse(localStorage.getItem('attributeMetaData')));
                        }
                        else {
                            invalidCache.push('attributeCacheKey');
                        }
                    })
                        .then(function () {
                        if (localStorage.getItem('appConfig') != null) {
                            _this.appConfig = JSON.parse(localStorage.getItem('appConfig'));
                        }
                        if (_this.instantiationKey === _this.appConfig.instantiationKey) {
                            // appConfig instantiation key is valid,
                            // override config with whatever new received in hibachi-config
                            Object.assign(_this.appConfig, hibachiConfig);
                            core_module_1.coremodule.constant('appConfig', _this.appConfig);
                        }
                        else {
                            invalidCache.push('instantiationKey');
                        }
                    })
                        .catch(function (e) {
                        invalidCache.push('attributeCacheKey');
                        invalidCache.push('instantiationKey');
                        console.error(e);
                    })
                        .then(function () { return invalidCache.length ? _this.getData(invalidCache) : undefined; })
                        .then(function () { return _this.getResourceBundles(); })
                        .catch(function (e) {
                        console.error(e);
                    });
                });
            }]);
    }
    return BaseBootStrapper;
}());
exports.BaseBootStrapper = BaseBootStrapper;


/***/ }),

/***/ "p0U3":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.FilterService = void 0;
var FilterService = /** @class */ (function () {
    //@ngInject
    function FilterService() {
        this.filterMatch = function (valueToCompareAgainst, comparisonOperator, comparisonValue) {
            switch (comparisonOperator) {
                case "!=":
                    if (valueToCompareAgainst != comparisonValue) {
                        return true;
                    }
                    break;
                case ">":
                    if (valueToCompareAgainst > comparisonValue) {
                        return true;
                    }
                    break;
                case ">=":
                    if (valueToCompareAgainst >= comparisonValue) {
                        return true;
                    }
                    break;
                case "<":
                    if (valueToCompareAgainst < comparisonValue) {
                        return true;
                    }
                    break;
                case "<=":
                    if (valueToCompareAgainst <= comparisonValue) {
                        return true;
                    }
                    break;
                case "is":
                    if (valueToCompareAgainst == comparisonValue) {
                        return true;
                    }
                    break;
                case "is not":
                    if (valueToCompareAgainst != comparisonValue) {
                        return true;
                    }
                    break;
                default:
                    //= case
                    if (valueToCompareAgainst == comparisonValue) {
                        return true;
                    }
                    break;
            }
            return false;
        };
    }
    return FilterService;
}());
exports.FilterService = FilterService;


/***/ }),

/***/ "pCaf":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWActionCallerController = exports.SWActionCaller = void 0;
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var actionCallerTemplateString = __webpack_require__("NO/y");
var SWActionCallerController = /** @class */ (function () {
    //@ngInject
    SWActionCallerController.$inject = ["$rootScope", "$scope", "$element", "$templateRequest", "$compile", "$timeout", "corePartialsPath", "utilityService", "observerService", "$hibachi", "rbkeyService", "hibachiAuthenticationService"];
    function SWActionCallerController($rootScope, $scope, $element, $templateRequest, $compile, $timeout, corePartialsPath, utilityService, observerService, $hibachi, rbkeyService, hibachiAuthenticationService) {
        var _this = this;
        this.$rootScope = $rootScope;
        this.$scope = $scope;
        this.$element = $element;
        this.$templateRequest = $templateRequest;
        this.$compile = $compile;
        this.$timeout = $timeout;
        this.corePartialsPath = corePartialsPath;
        this.utilityService = utilityService;
        this.observerService = observerService;
        this.$hibachi = $hibachi;
        this.rbkeyService = rbkeyService;
        this.hibachiAuthenticationService = hibachiAuthenticationService;
        this.$onInit = function () {
            if (angular.isDefined(_this.action)) {
                _this.actionAuthenticated = true;
                // 			var unBind = this.$rootScope.$watch('slatwall.role',(newValue,oldValue)=>{
                // 				if(newValue){
                // 					this.actionAuthenticated=this.hibachiAuthenticationService.authenticateActionByAccount(this.action);
                // 					unBind();
                // 				}
                // 			});
            }
            //Check if is NOT a ngRouter
            if (angular.isUndefined(_this.isAngularRoute)) {
                _this.isAngularRoute = _this.utilityService.isAngularRoute();
            }
            if (_this.event != null && _this.event.length) {
                _this.type = 'event'; //no action url needed
            }
            else if (!_this.isAngularRoute) {
                _this.actionUrl = _this.$hibachi.buildUrl(_this.action, _this.queryString);
            }
            else {
                _this.actionUrl = '#!/entity/' + _this.action + '/' + _this.queryString.split('=')[1];
            }
            if (angular.isUndefined(_this.display)) {
                _this.display = true;
            }
            if (angular.isUndefined(_this.displayConfirm)) {
                _this.displayConfirm = false;
            }
            _this.type = _this.type || 'link';
            if (angular.isDefined(_this.titleRbKey)) {
                _this.title = _this.rbkeyService.getRBKey(_this.titleRbKey);
            }
            if (angular.isUndefined(_this.text)) {
                _this.text = _this.title;
            }
            if (_this.type == "button") {
                //handle submit.
                /** in order to attach the correct controller to local vm, we need a watch to bind */
                var unbindWatcher = _this.$scope.$watch(function () { return _this.formController; }, function (newValue, oldValue) {
                    if (newValue !== undefined) {
                        _this.formController = newValue;
                    }
                    unbindWatcher();
                });
            }
            if (_this.eventListeners) {
                for (var key in _this.eventListeners) {
                    var callback = _this.eventListeners[key];
                    // if you want to use an internal method passed into this directive as a string
                    if (typeof callback !== "function") {
                        callback = _this[_this.eventListeners[key]];
                    }
                    // in case you want to attach by id
                    if (_this.eventListenerId) {
                        _this.observerService.attach(callback, key, _this.eventListenerId);
                        _this.$scope.$on('$destroy', function () {
                            _this.observerService.detachById(_this.eventListenerId);
                        });
                        continue;
                    }
                    _this.observerService.attach(callback, key);
                }
            }
        };
        this.emit = function () {
            _this.observerService.notify(_this.event, _this.payload);
        };
        this.submit = function () {
            _this.$timeout(function () {
                if (!_this.form) {
                    _this.$scope.$root.slatwall.doAction(_this.action);
                }
                else if (_this.form.$valid) {
                    _this.formController.submit(_this.action);
                }
            });
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
            var navRBKey = _this.rbkeyService.getRBKey('admin.define.' + actionItemType + '_nav');
            var entityRBKey = '';
            var replaceKey = '';
            if (plural) {
                entityRBKey = _this.rbkeyService.getRBKey('entity.' + _this.actionItemEntityName + '_plural');
                replaceKey = '${itemEntityNamePlural}';
            }
            else {
                entityRBKey = _this.rbkeyService.getRBKey('entity.' + _this.actionItemEntityName);
                replaceKey = '${itemEntityName}';
            }
            return _this.utilityService.replaceAll(navRBKey, replaceKey, entityRBKey);
        };
        this.getText = function () {
            //if we don't have text then make it up based on rbkeys
            if (angular.isUndefined(_this.text) || (angular.isDefined(_this.text) && !_this.text.length)) {
                _this.text = _this.rbkeyService.getRBKey(_this.utilityService.replaceAll(_this.getAction(), ":", ".") + '_nav');
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
                    _this.text = _this.rbkeyService.getRBKey(_this.utilityService.replaceAll(_this.getAction(), ":", "."));
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
        this.setDisabled = function (disableFlag) {
            _this.disabled = disableFlag;
        };
        this.setDisplayTrue = function () {
            _this.display = true;
        };
        this.setDisplayFalse = function () {
            _this.display = false;
        };
        this.getDisabledText = function () {
            if (_this.getDisabled()) {
                //and no disabled text specified
                if (angular.isUndefined(_this.disabledtext) || !_this.disabledtext.length) {
                    var disabledrbkey = _this.utilityService.replaceAll(_this.action, ':', '.') + '_disabled';
                    _this.disabledtext = _this.rbkeyService.getRBKey(disabledrbkey);
                }
                //add disabled class
                _this.class += " btn-disabled";
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
                    _this.confirmtext = _this.rbkeyService.getRBKey(confirmrbkey);
                    /*<cfif right(attributes.confirmtext, "8") eq "_missing">
                        <cfset attributes.confirmtext = replace(attributes.hibachiScope.rbKey("admin.define.delete_confirm"),'${itemEntityName}', attributes.hibachiScope.rbKey('entity.#actionItemEntityName#'), "all") />
                    </cfif>*/
                }
                _this.class += " alert-confirm";
                return _this.confirm;
            }
            return "";
        };
        this.$templateRequest('actionCallerTemplateString').then(function (html) {
            var template = angular.element(html);
            _this.$element.parent().prepend(template);
            $compile(template)($scope);
            //need to perform init after promise completes
            //this.init();
        });
        this.authenticateActionByAccount = this.hibachiAuthenticationService.autheticateActionByAccount;
    }
    return SWActionCallerController;
}());
exports.SWActionCallerController = SWActionCallerController;
var SWActionCaller = /** @class */ (function () {
    // @ngInject;
    SWActionCaller.$inject = ["$templateCache"];
    function SWActionCaller($templateCache) {
        this.$templateCache = $templateCache;
        this.restrict = 'EA';
        this.scope = {};
        this.bindToController = {
            action: "@?",
            display: "<?",
            displayConfirm: "=?",
            event: "@?",
            payload: "=",
            text: "@",
            type: "@",
            queryString: "@",
            title: "@?",
            titleRbKey: "@?",
            'class': "@",
            icon: "@",
            iconOnly: "=",
            name: "@",
            confirm: "=",
            confirmtext: "@",
            disabled: "=",
            disabledtext: "@",
            modal: "=",
            modalFullWidth: "=",
            id: "@",
            isAngularRoute: "=?",
            eventListeners: '=?',
            eventListenerId: '@?'
        };
        this.require = { formController: "^?swForm", form: "^?form" };
        this.controller = SWActionCallerController;
        this.controllerAs = "swActionCaller";
        this.link = function (scope, element, attrs) {
            if (angular.isDefined(scope.swActionCaller.formController)) {
                scope.formController = scope.swActionCaller.formController;
            }
        };
    }
    SWActionCaller.Factory = function () {
        var _this = this;
        return /** @ngInject; */ ["$templateCache", function ($templateCache) {
            if (!$templateCache.get('actionCallerTemplateString')) {
                $templateCache.put('actionCallerTemplateString', actionCallerTemplateString);
            }
            return new _this($templateCache);
        }];
    };
    return SWActionCaller;
}());
exports.SWActionCaller = SWActionCaller;


/***/ }),

/***/ "pGfp":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWInput = void 0;
var SWInputController = /** @class */ (function () {
    //@ngInject
    SWInputController.$inject = ["$scope", "$log", "$hibachi", "$injector", "listingService", "utilityService", "rbkeyService", "observerService", "metadataService"];
    function SWInputController($scope, $log, $hibachi, $injector, listingService, utilityService, rbkeyService, observerService, metadataService) {
        var _this = this;
        this.$scope = $scope;
        this.$log = $log;
        this.$hibachi = $hibachi;
        this.$injector = $injector;
        this.listingService = listingService;
        this.utilityService = utilityService;
        this.rbkeyService = rbkeyService;
        this.observerService = observerService;
        this.metadataService = metadataService;
        this.eventAnnouncers = "";
        this.onSuccess = function () {
            _this.utilityService.setPropertyValue(_this.swForm.object, _this.propertyIdentifier, _this.value);
            if (_this.swPropertyDisplay) {
                _this.utilityService.setPropertyValue(_this.swPropertyDisplay.object, _this.propertyIdentifier, _this.value);
            }
            if (_this.swfPropertyDisplay) {
                _this.utilityService.setPropertyValue(_this.swfPropertyDisplay.object, _this.propertyIdentifier, _this.value);
                _this.swfPropertyDisplay.edit = false;
            }
            _this.utilityService.setPropertyValue(_this.swFormField.object, _this.propertyIdentifier, _this.value);
        };
        this.getValidationDirectives = function () {
            var spaceDelimitedList = '';
            var name = _this.propertyIdentifier;
            var form = _this.form;
            _this.$log.debug("Name is:" + name + " and form is: " + form);
            if (_this.metadataService.isAttributePropertyByEntityAndPropertyIdentifier(_this.object, _this.propertyIdentifier)) {
                _this.object.validations.properties[name] = [];
                if ((_this.object.metaData[_this.propertyIdentifier].requiredFlag && _this.object.metaData[_this.propertyIdentifier].requiredFlag == true) || typeof _this.object.metaData[_this.propertyIdentifier].requiredFlag === 'string' && _this.object.metaData[_this.propertyIdentifier].requiredFlag.trim().toLowerCase() == "yes") {
                    _this.object.validations.properties[name].push({
                        contexts: "save",
                        required: true
                    });
                }
                if (_this.object.metaData[_this.propertyIdentifier].validationRegex) {
                    _this.object.validations.properties[name].push({
                        contexts: "save", regex: _this.object.metaData[_this.propertyIdentifier].validationRegex
                    });
                }
            }
            if (angular.isUndefined(_this.object.validations)
                || angular.isUndefined(_this.object.validations.properties)
                || angular.isUndefined(_this.object.validations.properties[_this.propertyIdentifier])) {
                return '';
            }
            var validations = _this.object.validations.properties[_this.propertyIdentifier];
            _this.$log.debug("Validations: ", validations);
            _this.$log.debug(_this.form);
            var validationsForContext = [];
            //get the form context and the form name.
            var formContext = _this.swForm.context;
            var formName = _this.swForm.name;
            _this.$log.debug("Form context is: ");
            _this.$log.debug(formContext);
            _this.$log.debug("Form Name: ");
            _this.$log.debug(formName);
            //get the validations for the current element.
            var propertyValidations = _this.object.validations.properties[name];
            //check if the contexts match.
            if (angular.isObject(propertyValidations)) {
                //if this is a procesobject validation then the context is implied
                if (angular.isUndefined(propertyValidations[0].contexts) && _this.object.metaData.isProcessObject) {
                    propertyValidations[0].contexts = _this.object.metaData.className.split('_')[1];
                }
                if (propertyValidations[0].contexts.indexOf(formContext) > -1) {
                    _this.$log.debug("Matched");
                    for (var prop in propertyValidations[0]) {
                        if (prop != "contexts" && prop !== "conditions") {
                            spaceDelimitedList += (" swvalidation" + prop.toLowerCase() + "='" + propertyValidations[0][prop] + "'");
                        }
                    }
                }
                _this.$log.debug(spaceDelimitedList);
            }
            //loop over validations that are required and create the space delimited list
            _this.$log.debug(validations);
            //get all validations related to the form context;
            _this.$log.debug(form);
            angular.forEach(validations, function (validation, key) {
                if (validation.contexts && _this.utilityService.listFind(validation.contexts.toLowerCase(), _this.swForm.context.toLowerCase()) !== -1) {
                    _this.$log.debug("Validations for context");
                    _this.$log.debug(validation);
                    validationsForContext.push(validation);
                }
            });
            return spaceDelimitedList;
        };
        this.clear = function () {
            if (_this.reverted) {
                _this.reverted = false;
                _this.showRevert = true;
            }
            _this.edited = false;
            _this.value = _this.initialValue;
            if (_this.inListingDisplay && _this.rowSaveEnabled) {
                _this.listingService.markUnedited(_this.listingID, _this.pageRecordIndex, _this.propertyDisplayID);
            }
        };
        this.revert = function () {
            _this.showRevert = false;
            _this.reverted = true;
            _this.value = _this.revertToValue;
            _this.onEvent({}, "change");
        };
        this.onEvent = function (event, eventName) {
            var customEventName = _this.swForm.name + _this.name + eventName;
            var formEventName = _this.swForm.name + eventName;
            var data = {
                event: event,
                eventName: eventName,
                form: _this.form,
                swForm: _this.swForm,
                swInput: _this,
                inputElement: $('input').first()[0]
            };
            _this.observerService.notify(customEventName, data);
            _this.observerService.notify(formEventName, data);
            _this.observerService.notify(eventName, data);
        };
        this.getTemplate = function () {
            var template = '';
            var validations = '';
            var currencyTitle = '';
            var currencyFormatter = '';
            var style = "";
            if (!_this.class) {
                _this.class = "form-control";
            }
            if (!_this.noValidate) {
                validations = _this.getValidationDirectives();
            }
            if (_this.object && _this.object.metaData && _this.object.metaData.$$getPropertyFormatType(_this.propertyIdentifier) != undefined && _this.object.metaData.$$getPropertyFormatType(_this.propertyIdentifier) == "currency" && !_this.edit) {
                currencyFormatter = 'sw-currency-formatter ';
                if (angular.isDefined(_this.object.data.currencyCode)) {
                    currencyFormatter = currencyFormatter + 'data-currency-code="' + _this.object.data.currencyCode + '" ';
                    currencyTitle = '<span class="s-title">' + _this.object.data.currencyCode + '</span>';
                }
            }
            var appConfig = _this.$hibachi.getConfig();
            var placeholder = '';
            if (_this.object.metaData && _this.object.metaData[_this.propertyIdentifier] && _this.object.metaData[_this.propertyIdentifier].hb_nullrbkey) {
                placeholder = _this.rbkeyService.getRBKey(_this.object.metaData[_this.propertyIdentifier].hb_nullrbkey);
            }
            if (_this.fieldType.toLowerCase() === 'json') {
                style = style += 'display:none';
            }
            var acceptedFieldTypes = ['email', 'text', 'password', 'number', 'time', 'date', 'datetime', 'json', 'file'];
            if (acceptedFieldTypes.indexOf(_this.fieldType.toLowerCase()) >= 0) {
                var inputType = _this.fieldType.toLowerCase();
                if (_this.fieldType === 'time' || _this.fieldType === 'number') {
                    inputType = "text";
                }
                template = currencyTitle + '<input type="' + inputType + '" class="' + _this.class + '" ' +
                    'ng-model="swInput.value" ' +
                    'ng-disabled="swInput.editable === false" ' +
                    'ng-show="swInput.edit" ' +
                    "ng-class=\"{'form-control':swInput.inListingDisplay, 'input-xs':swInput.inListingDisplay}\"" +
                    'name="' + _this.propertyIdentifier + '" ' +
                    'placeholder="' + placeholder + '" ' +
                    validations + currencyFormatter +
                    'id="swinput' + _this.swForm.name + _this.name + '" ' +
                    'style="' + style + '"' +
                    _this.inputAttributes +
                    _this.eventAnnouncerTemplate;
            }
            var dateFieldTypes = ['date', 'datetime', 'time'];
            if (dateFieldTypes.indexOf(_this.fieldType.toLowerCase()) >= 0) {
                template = template + 'datetime-picker ';
            }
            if (_this.fieldType === 'time') {
                template = template + 'data-time-only="true" date-format="' + appConfig.timeFormat.replace('tt', 'a') + '" ng-blur="swInput.pushBindings()"';
            }
            if (_this.fieldType === 'date') {
                template = template + 'data-date-only="true" future-only date-format="' + appConfig.dateFormat + '" ';
            }
            if (template.length) {
                template = template + ' />';
            }
            var actionButtons = "\n\t\t\t<a class=\"s-remove-change\"\n\t\t\t\tdata-ng-click=\"swPropertyDisplay.clear()\"\n\t\t\t\tdata-ng-if=\"swInput.edited && swInput.edit\">\n\t\t\t\t\t<i class=\"fa fa-times\"></i>\n\t\t\t</a>\n\n\t\t\t<!-- Revert Button -->\n\t\t\t<button class=\"btn btn-xs btn-default s-revert-btn\"\n\t\t\t\t\tdata-ng-show=\"swInput.showRevert\"\n\t\t\t\t\tdata-ng-click=\"swInput.revert()\"\n\t\t\t\t\tdata-toggle=\"popover\"\n\t\t\t\t\tdata-trigger=\"hover\"\n\t\t\t\t\tdata-content=\"{{swInput.revertText}}\"\n\t\t\t\t\tdata-original-title=\"\"\n\t\t\t\t\ttitle=\"\">\n\t\t\t\t<i class=\"fa fa-refresh\"></i>\n\t\t\t</button>\n\t\t";
            return template + actionButtons;
        };
        this.pullBindings = function () {
            var bindToControllerProps = _this.$injector.get('swInputDirective')[0].bindToController;
            for (var i in bindToControllerProps) {
                if (!_this[i]) {
                    if (!_this[i] && _this.swFormField && _this.swFormField[i]) {
                        _this[i] = _this.swFormField[i];
                    }
                    else if (!_this[i] && _this.swPropertyDisplay && _this.swPropertyDisplay[i]) {
                        _this[i] = _this.swPropertyDisplay[i];
                    }
                    else if (!_this[i] && _this.swfPropertyDisplay && _this.swfPropertyDisplay[i]) {
                        _this[i] = _this.swfPropertyDisplay[i];
                    }
                    else if (!_this[i] && _this.swForm && _this.swForm[i]) {
                        _this[i] = _this.swForm[i];
                    }
                }
            }
            _this.edit = _this.edit || true;
            _this.fieldType = _this.fieldType || "text";
            _this.inputAttributes = _this.inputAttributes || "";
            _this.inputAttributes = _this.utilityService.replaceAll(_this.inputAttributes, "'", '"');
            _this.value = _this.utilityService.getPropertyValue(_this.object, _this.propertyIdentifier);
        };
        this.pushBindings = function () {
            _this.observerService.notify('updateBindings').then(function () { });
        };
        this.$onInit = function () {
            _this.pullBindings();
            _this.eventAnnouncersArray = _this.eventAnnouncers.split(',');
            _this.eventAnnouncerTemplate = "";
            for (var i in _this.eventAnnouncersArray) {
                var eventName = _this.eventAnnouncersArray[i];
                if (eventName.length) {
                    _this.eventAnnouncerTemplate += " ng-" + eventName + "=\"swInput.onEvent($event,'" + eventName + "')\"";
                }
            }
            if (_this.object && _this.object.metaData && _this.object.metaData.className != undefined) {
                _this.eventNameForObjectSuccess = _this.object.metaData.className.split('_')[0] + _this.context.charAt(0).toUpperCase() + _this.context.slice(1) + 'Success';
            }
            else {
                _this.eventNameForObjectSuccess = _this.context.charAt(0).toUpperCase() + _this.context.slice(1) + 'Success';
            }
            var eventNameForObjectSuccessID = _this.eventNameForObjectSuccess + _this.propertyIdentifier;
            var eventNameForUpdateBindings = 'updateBindings';
            if (_this.object && _this.object.metaData && _this.object.metaData.className != undefined) {
                var eventNameForUpdateBindingsID = _this.object.metaData.className.split('_')[0] + _this.propertyIdentifier + 'updateBindings';
            }
            else {
                var eventNameForUpdateBindingsID = _this.propertyIdentifier + 'updateBindings';
            }
            var eventNameForPullBindings = 'pullBindings';
            if (_this.object && _this.object.metaData && _this.object.metaData.className != undefined) {
                var eventNameForPullBindingsID = _this.object.metaData.className.split('_')[0] + _this.propertyIdentifier + 'pullBindings';
            }
            else {
                var eventNameForPullBindingsID = _this.propertyIdentifier + 'pullBindings';
            }
            //attach a successObserver
            if (_this.object) {
                //update bindings on save success
                _this.observerService.attach(_this.onSuccess, _this.eventNameForObjectSuccess, eventNameForObjectSuccessID);
                //update bindings manually
                _this.observerService.attach(_this.onSuccess, eventNameForUpdateBindings, eventNameForUpdateBindingsID);
                //pull bindings from higher binding level manually
                _this.observerService.attach(_this.pullBindings, eventNameForPullBindings, eventNameForPullBindingsID);
            }
            _this.$scope.$on("$destroy", function () {
                _this.observerService.detachById(eventNameForUpdateBindings);
                _this.observerService.detachById(eventNameForUpdateBindingsID);
            });
        };
    }
    return SWInputController;
}());
var SWInput = /** @class */ (function () {
    //@ngInject
    SWInput.$inject = ["$compile", "$timeout", "$parse", "fileService"];
    function SWInput($compile, $timeout, $parse, fileService) {
        var _this = this;
        this.$compile = $compile;
        this.$timeout = $timeout;
        this.$parse = $parse;
        this.fileService = fileService;
        this.restrict = "E";
        this.require = {
            swForm: "?^swForm",
            form: "?^form",
            swFormField: "?^swFormField",
            swPropertyDisplay: "?^swPropertyDisplay",
            swfPropertyDisplay: "?^swfPropertyDisplay"
        };
        this.scope = {};
        this.bindToController = {
            propertyIdentifier: "@?",
            name: "@?",
            class: "@?",
            errorClass: "@?",
            option: "=?",
            valueObject: "=?",
            object: "=?",
            label: "@?",
            labelText: "@?",
            labelClass: "@?",
            inListingDisplay: "=?",
            listingID: "=?",
            pageRecordIndex: "=?",
            propertyDisplayID: "=?",
            initialValue: "=?",
            optionValues: "=?",
            edit: "=?",
            title: "@?",
            value: "=?",
            errorText: "@?",
            fieldType: "@?",
            property: "@?",
            binaryFileTarget: "@?",
            rawFileTarget: "@?",
            reverted: "=?",
            revertToValue: "=?",
            showRevert: "=?",
            inputAttributes: "@?",
            type: "@?",
            eventAnnouncers: "@?",
            context: "@?"
        };
        this.controller = SWInputController;
        this.controllerAs = "swInput";
        this.link = function (scope, element, attr) {
            if (scope.swInput.type === 'file') {
                if (angular.isUndefined(scope.swInput.object.data[scope.swInput.rawFileTarget])) {
                    scope.swInput.object[scope.swInput.rawFileTarget] = "";
                    scope.swInput.object.data[scope.swInput.rawFileTarget] = "";
                }
                var model = _this.$parse("swInput.object.data[swInput.rawFileTarget]");
                var modelSetter = model.assign;
                element.bind("change", function (e) {
                    var fileToUpload = (e.srcElement || e.target).files[0];
                    scope.$apply(function () {
                        modelSetter(scope, fileToUpload);
                    }, function () {
                        throw ("swinput couldn't apply the file to scope");
                    });
                    _this.$timeout(function () {
                        _this.fileService.uploadFile(fileToUpload, scope.swInput.object, scope.swInput.binaryFileTarget)
                            .then(function (result) {
                            scope.swInput.object[scope.swInput.property] = fileToUpload;
                            scope.swInput.onEvent(e, "change");
                        }, function () {
                            //error	notify user
                        });
                    });
                });
            }
            //renders the template and compiles it
            element.html(scope.swInput.getTemplate());
            _this.$compile(element.contents())(scope);
        };
    }
    SWInput.Factory = function () {
        var directive = function ($compile, $timeout, $parse, fileService) { return new SWInput($compile, $timeout, $parse, fileService); };
        directive.$inject = [
            '$compile',
            '$timeout',
            '$parse',
            'fileService'
        ];
        return directive;
    };
    return SWInput;
}());
exports.SWInput = SWInput;


/***/ }),

/***/ "pwA0":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.RbKeyService = exports.UtilityService = exports.ObserverService = exports.RequestService = exports.PublicRequest = exports.PublicService = exports.coremodule = void 0;
var hibachiinterceptor_1 = __webpack_require__("2vwh");
//constant
var hibachipathbuilder_1 = __webpack_require__("SaEH");
var publicrequest_1 = __webpack_require__("/Gm/");
Object.defineProperty(exports, "PublicRequest", { enumerable: true, get: function () { return publicrequest_1.PublicRequest; } });
//services
var cacheservice_1 = __webpack_require__("JWr5");
var publicservice_1 = __webpack_require__("HQNm");
Object.defineProperty(exports, "PublicService", { enumerable: true, get: function () { return publicservice_1.PublicService; } });
var accountservice_1 = __webpack_require__("Svpb");
var accountaddressservice_1 = __webpack_require__("xSVC");
var cartservice_1 = __webpack_require__("M5tv");
var draggableservice_1 = __webpack_require__("CamD");
var utilityservice_1 = __webpack_require__("lP0P");
Object.defineProperty(exports, "UtilityService", { enumerable: true, get: function () { return utilityservice_1.UtilityService; } });
var selectionservice_1 = __webpack_require__("QbBB");
var observerservice_1 = __webpack_require__("arPg");
Object.defineProperty(exports, "ObserverService", { enumerable: true, get: function () { return observerservice_1.ObserverService; } });
var orderservice_1 = __webpack_require__("/i+c");
var orderpaymentservice_1 = __webpack_require__("qisz");
var formservice_1 = __webpack_require__("L5wE");
var filterservice_1 = __webpack_require__("p0U3");
var expandableservice_1 = __webpack_require__("JFp2");
var hibachiauthenticationservice_1 = __webpack_require__("4HDq");
var metadataservice_1 = __webpack_require__("clPF");
var rbkeyservice_1 = __webpack_require__("1WeJ");
Object.defineProperty(exports, "RbKeyService", { enumerable: true, get: function () { return rbkeyservice_1.RbKeyService; } });
var typeaheadservice_1 = __webpack_require__("0060");
var hibachiservice_1 = __webpack_require__("KET/");
var historyservice_1 = __webpack_require__("I1i7");
var localstorageservice_1 = __webpack_require__("NPJD");
var hibachiservicedecorator_1 = __webpack_require__("cAYs");
var hibachiscope_1 = __webpack_require__("tmHj");
var requestservice_1 = __webpack_require__("7AdH");
Object.defineProperty(exports, "RequestService", { enumerable: true, get: function () { return requestservice_1.RequestService; } });
var scopeservice_1 = __webpack_require__("yPmm");
var skuservice_1 = __webpack_require__("Dac7");
var hibachivalidationservice_1 = __webpack_require__("O3Mr");
var entityservice_1 = __webpack_require__("vvJr");
//controllers
var globalsearch_1 = __webpack_require__("UoGw");
//filters
var percentage_1 = __webpack_require__("SCrc");
var entityrbkey_1 = __webpack_require__("YFSW");
var swcurrency_1 = __webpack_require__("PBJm");
var swtrim_1 = __webpack_require__("fsz1");
var swunique_1 = __webpack_require__("bQOH");
var datefilter_1 = __webpack_require__("Ebw0");
var datereporting_1 = __webpack_require__("4yaA");
var ordinal_1 = __webpack_require__("/fWz");
//directives
//  components
var swactioncaller_1 = __webpack_require__("pCaf");
var swaddressverification_1 = __webpack_require__("jZ4P");
var swtypeaheadsearch_1 = __webpack_require__("b0dy");
var swtypeaheadinputfield_1 = __webpack_require__("uDRM");
var swtypeaheadmultiselect_1 = __webpack_require__("EuNy");
var swtypeaheadsearchlineitem_1 = __webpack_require__("3h5T");
var swtypeaheadremoveselection_1 = __webpack_require__("NaNU");
var swcollectionconfig_1 = __webpack_require__("nH03");
var swcollectionfilter_1 = __webpack_require__("fbXf");
var swcollectionorderby_1 = __webpack_require__("cP5o");
var swcollectioncolumn_1 = __webpack_require__("5ycg");
var swcurrencyformatter_1 = __webpack_require__("/xF6");
var swactioncallerdropdown_1 = __webpack_require__("MKx1");
var swcolumnsorter_1 = __webpack_require__("Al1n");
var swconfirm_1 = __webpack_require__("/pQj");
var swdatepicker_1 = __webpack_require__("dH0M");
var swdraggable_1 = __webpack_require__("Vhuo");
var swdraggablecontainer_1 = __webpack_require__("J8kZ");
var swentityactionbar_1 = __webpack_require__("0LCg");
var swentityactionbarbuttongroup_1 = __webpack_require__("VTDN");
var swexpandablerecord_1 = __webpack_require__("TrJb");
var swexpiringsessionnotifier_1 = __webpack_require__("q49o");
var swgravatar_1 = __webpack_require__("S2Ji");
var swlogin_1 = __webpack_require__("x4Rm");
var swmodallauncher_1 = __webpack_require__("WUjD");
var swmodalwindow_1 = __webpack_require__("zvf2");
var swnumbersonly_1 = __webpack_require__("AOdl");
var swloading_1 = __webpack_require__("URW6");
var swscrolltrigger_1 = __webpack_require__("/9HY");
var swtabgroup_1 = __webpack_require__("6ppE");
var swtabcontent_1 = __webpack_require__("v97U");
var swtooltip_1 = __webpack_require__("Zcn6");
var swrbkey_1 = __webpack_require__("ZI8f");
var swoptions_1 = __webpack_require__("Qxcv");
var swselection_1 = __webpack_require__("+hUe");
var swclickoutside_1 = __webpack_require__("kh/o");
var swdirective_1 = __webpack_require__("ZyaV");
var swexportaction_1 = __webpack_require__("vaCL");
var swhref_1 = __webpack_require__("uqgD");
var swprocesscaller_1 = __webpack_require__("+8fp");
var swsortable_1 = __webpack_require__("vVMi");
var sworderbycontrols_1 = __webpack_require__("jlA9");
var alert_module_1 = __webpack_require__("YsSz");
var dialog_module_1 = __webpack_require__("slRK");
var cache_module_1 = __webpack_require__("ksv2");
var modal_module_1 = __webpack_require__("Aozq");
var coremodule = angular.module('hibachi.core', [
    //Angular Modules
    'ngAnimate',
    'ngRoute',
    'ngSanitize',
    cache_module_1.cacheModule.name,
    alert_module_1.alertmodule.name,
    dialog_module_1.dialogmodule.name,
    //3rdParty modules
    'ui.bootstrap',
    modal_module_1.angularModalModule.name
])
    .config(['$compileProvider', '$httpProvider', '$logProvider',
    '$filterProvider', '$provide', 'hibachiPathBuilder',
    'appConfig', 'ModalServiceProvider', function ($compileProvider, $httpProvider, $logProvider, $filterProvider, $provide, hibachiPathBuilder, appConfig, ModalServiceProvider) {
        hibachiPathBuilder.setBaseURL(appConfig.baseURL);
        hibachiPathBuilder.setBasePartialsPath('/org/Hibachi/client/src/');
        if (true) {
            $logProvider.debugEnabled(true);
            $compileProvider.debugInfoEnabled(true);
        }
        else {}
        $filterProvider.register('likeFilter', function () {
            return function (text) {
                if (angular.isDefined(text) && angular.isString(text)) {
                    return text.replace(new RegExp('%', 'g'), '');
                }
            };
        });
        //This filter is used to shorten a string by removing the charecter count that is passed to it and ending it with "..."
        $filterProvider.register('truncate', function () {
            return function (input, chars, breakOnWord) {
                if (isNaN(chars))
                    return input;
                if (chars <= 0)
                    return '';
                if (input && input.length > chars) {
                    input = input.substring(0, chars);
                    if (!breakOnWord) {
                        var lastspace = input.lastIndexOf(' ');
                        //get last space
                        if (lastspace !== -1) {
                            input = input.substr(0, lastspace);
                        }
                    }
                    else {
                        while (input.charAt(input.length - 1) === ' ') {
                            input = input.substr(0, input.length - 1);
                        }
                    }
                    return input + '...';
                }
                return input;
            };
        });
        //This filter is used to shorten long string but unlike "truncate", it removes from the start of the string and prepends "..."
        $filterProvider.register('pretruncate', function () {
            return function (input, chars, breakOnWord) {
                if (isNaN(chars))
                    return input;
                if (chars <= 0)
                    return '';
                if (input && input.length > chars) {
                    input = input.slice('-' + chars);
                    //  input = input.substring(0, chars);
                    if (!breakOnWord) {
                        var lastspace = input.lastIndexOf(' ');
                        //get last space
                        if (lastspace !== -1) {
                            input = input.substr(0, lastspace);
                        }
                    }
                    else {
                        while (input.charAt(input.length - 1) === ' ') {
                            input = input.substr(0, input.length - 1);
                        }
                    }
                    return '...' + input;
                }
                return input;
            };
        });
        hibachiPathBuilder.setBaseURL(appConfig.baseURL);
        hibachiPathBuilder.setBasePartialsPath('/org/Hibachi/client/src/');
        // $provide.decorator('$hibachi',
        $httpProvider.interceptors.push('hibachiInterceptor');
        //Pulls seperate http requests into a single digest cycle.
        $httpProvider.useApplyAsync(true);
        // to set a default close delay on modals
        ModalServiceProvider.configureOptions({ closeDelay: 0 });
    }])
    .run(['$rootScope', '$hibachi', '$route', '$location', 'rbkeyService', function ($rootScope, $hibachi, $route, $location, rbkeyService) {
        $rootScope.buildUrl = $hibachi.buildUrl;
        $rootScope.rbKey = rbkeyService.rbKey;
        var original = $location.path;
        $location.path = function (path, reload) {
            if (reload === false) {
                var lastRoute = $route.current;
                var un = $rootScope.$on('$locationChangeSuccess', function () {
                    $route.current = lastRoute;
                    un();
                });
            }
            return original.apply($location, [path]);
        };
    }])
    .constant('hibachiPathBuilder', new hibachipathbuilder_1.HibachiPathBuilder())
    .constant('corePartialsPath', 'core/components/')
    .constant('isAdmin', false)
    //services
    .service('cacheService', cacheservice_1.CacheService)
    .service('publicService', publicservice_1.PublicService)
    .service('utilityService', utilityservice_1.UtilityService)
    .service('selectionService', selectionservice_1.SelectionService)
    .service('observerService', observerservice_1.ObserverService)
    .service('draggableService', draggableservice_1.DraggableService)
    .service('expandableService', expandableservice_1.ExpandableService)
    .service('filterService', filterservice_1.FilterService)
    .service('formService', formservice_1.FormService)
    .service('historyService', historyservice_1.HistoryService)
    .service('metadataService', metadataservice_1.MetaDataService)
    .service('rbkeyService', rbkeyservice_1.RbKeyService)
    .service('typeaheadService', typeaheadservice_1.TypeaheadService)
    .provider('$hibachi', hibachiservice_1.$Hibachi)
    .decorator('$hibachi', hibachiservicedecorator_1.HibachiServiceDecorator)
    .service('hibachiAuthenticationService', hibachiauthenticationservice_1.HibachiAuthenticationService)
    .service('hibachiInterceptor', hibachiinterceptor_1.HibachiInterceptor.Factory())
    .service('hibachiScope', hibachiscope_1.HibachiScope)
    .service('scopeService', scopeservice_1.ScopeService)
    .service('skuService', skuservice_1.SkuService)
    .service('localStorageService', localstorageservice_1.LocalStorageService)
    .service('requestService', requestservice_1.RequestService)
    .service('accountService', accountservice_1.AccountService)
    .service('accountAddressService', accountaddressservice_1.AccountAddressService)
    .service('orderService', orderservice_1.OrderService)
    .service('orderPaymentService', orderpaymentservice_1.OrderPaymentService)
    .service('cartService', cartservice_1.CartService)
    .service('hibachiValidationService', hibachivalidationservice_1.HibachiValidationService)
    .service('entityService', entityservice_1.EntityService)
    //controllers
    .controller('globalSearch', globalsearch_1.GlobalSearchController)
    //filters
    .filter('dateFilter', ['$filter', datefilter_1.DateFilter.Factory])
    .filter('swcurrency', ['$sce', '$log', '$hibachi', '$filter', swcurrency_1.SWCurrency.Factory])
    .filter('swdatereporting', ['$filter', datereporting_1.DateReporting.Factory])
    .filter('percentage', [percentage_1.PercentageFilter.Factory])
    .filter('trim', [swtrim_1.SWTrim.Factory])
    .filter('entityRBKey', ['rbkeyService', entityrbkey_1.EntityRBKey.Factory])
    .filter('swdate', ['$filter', datefilter_1.DateFilter.Factory])
    .filter('unique', [swunique_1.SWUnique.Factory])
    .filter('ordinal', ordinal_1.OrdinalFilter.Factory)
    //directives
    .directive('swCollectionConfig', swcollectionconfig_1.SWCollectionConfig.Factory())
    .directive('swCollectionColumn', swcollectioncolumn_1.SWCollectionColumn.Factory())
    .directive('swCollectionFilter', swcollectionfilter_1.SWCollectionFilter.Factory())
    .directive('swCollectionOrderBy', swcollectionorderby_1.SWCollectionOrderBy.Factory())
    .directive('swTypeaheadSearch', swtypeaheadsearch_1.SWTypeaheadSearch.Factory())
    .directive('swTypeaheadInputField', swtypeaheadinputfield_1.SWTypeaheadInputField.Factory())
    .directive('swTypeaheadMultiselect', swtypeaheadmultiselect_1.SWTypeaheadMultiselect.Factory())
    .directive('swTypeaheadSearchLineItem', swtypeaheadsearchlineitem_1.SWTypeaheadSearchLineItem.Factory())
    .directive('swTypeaheadRemoveSelection', swtypeaheadremoveselection_1.SWTypeaheadRemoveSelection.Factory())
    .directive('swActionCaller', swactioncaller_1.SWActionCaller.Factory())
    .directive('swActionCallerDropdown', swactioncallerdropdown_1.SWActionCallerDropdown.Factory())
    .directive('swAddressVerification', swaddressverification_1.SWAddressVerification.Factory())
    .directive('swColumnSorter', swcolumnsorter_1.SWColumnSorter.Factory())
    .directive('swConfirm', swconfirm_1.SWConfirm.Factory())
    .directive('swCurrencyFormatter', swcurrencyformatter_1.SWCurrencyFormatter.Factory())
    .directive('swDatePicker', swdatepicker_1.SWDatePicker.Factory())
    .directive('swEntityActionBar', swentityactionbar_1.SWEntityActionBar.Factory())
    .directive('swEntityActionBarButtonGroup', swentityactionbarbuttongroup_1.SWEntityActionBarButtonGroup.Factory())
    .directive('swExpandableRecord', swexpandablerecord_1.SWExpandableRecord.Factory())
    .directive('swExpiringSessionNotifier', swexpiringsessionnotifier_1.SWExpiringSessionNotifier.Factory())
    .directive('swGravatar', swgravatar_1.SWGravatar.Factory())
    .directive('swDraggable', swdraggable_1.SWDraggable.Factory())
    .directive('swDraggableContainer', swdraggablecontainer_1.SWDraggableContainer.Factory())
    .directive('swLogin', swlogin_1.SWLogin.Factory())
    .directive('swModalLauncher', swmodallauncher_1.SWModalLauncher.Factory())
    .directive('swModalWindow', swmodalwindow_1.SWModalWindow.Factory())
    .directive('swNumbersOnly', swnumbersonly_1.SWNumbersOnly.Factory())
    .directive('swLoading', swloading_1.SWLoading.Factory())
    .directive('swScrollTrigger', swscrolltrigger_1.SWScrollTrigger.Factory())
    .directive('swRbkey', swrbkey_1.SWRbKey.Factory())
    .directive('swOptions', swoptions_1.SWOptions.Factory())
    .directive('swSelection', swselection_1.SWSelection.Factory())
    .directive('swTabGroup', swtabgroup_1.SWTabGroup.Factory())
    .directive('swTabContent', swtabcontent_1.SWTabContent.Factory())
    .directive('swTooltip', swtooltip_1.SWTooltip.Factory())
    .directive('swClickOutside', swclickoutside_1.SWClickOutside.Factory())
    .directive('swDirective', swdirective_1.SWDirective.Factory())
    .directive('swExportAction', swexportaction_1.SWExportAction.Factory())
    .directive('swHref', swhref_1.SWHref.Factory())
    .directive('swProcessCaller', swprocesscaller_1.SWProcessCaller.Factory())
    .directive('swSortable', swsortable_1.SWSortable.Factory())
    .directive('swOrderByControls', sworderbycontrols_1.SWOrderByControls.Factory());
exports.coremodule = coremodule;


/***/ }),

/***/ "q49o":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWExpiringSessionNotifier = void 0;
var SWExpiringSessionNotifierController = /** @class */ (function () {
    //@ngInject
    SWExpiringSessionNotifierController.$inject = ["$timeout", "$http", "$hibachi", "localStorageService"];
    function SWExpiringSessionNotifierController($timeout, $http, $hibachi, localStorageService) {
        var _this = this;
        this.$timeout = $timeout;
        this.$http = $http;
        this.$hibachi = $hibachi;
        this.localStorageService = localStorageService;
        this.startTimeout = function () {
            _this.$timeout(function () {
                console.warn("Session Is About To Expire, 3 Minutes Left");
                //regardless of user input as long as they respond 
                var answer = confirm(_this.confirmText);
                _this.$http.get(_this.$hibachi.buildUrl('api:main.login')).then(function (response) {
                    if (response.status === 200) {
                        _this.localStorageService.setItem('token', response.data.token);
                        _this.startTimeout();
                    }
                    else {
                        alert('Unable To Login');
                        location.reload();
                    }
                }, function (rejection) {
                    throw ('Login Failed');
                });
            }, 720000);
        };
        console.warn("Expiring Session Notifier Constructed.");
        if (angular.isUndefined(this.confirmText)) {
            this.confirmText = 'Are you still there? You are about to be logged out.';
        }
        this.startTimeout();
    }
    return SWExpiringSessionNotifierController;
}());
var SWExpiringSessionNotifier = /** @class */ (function () {
    //@ngInject
    SWExpiringSessionNotifier.$inject = ["corePartialsPath", "hibachiPathBuilder"];
    function SWExpiringSessionNotifier(corePartialsPath, hibachiPathBuilder) {
        this.corePartialsPath = corePartialsPath;
        this.restrict = 'E';
        this.scope = {};
        this.transclude = false;
        this.bindToController = {
            confirmText: '@?'
        };
        this.controller = SWExpiringSessionNotifierController;
        this.controllerAs = "swExpiringSessionNotifier";
        this.link = function (scope, element, attrs) {
        };
        this.template = '';
    }
    SWExpiringSessionNotifier.Factory = function () {
        var directive = function (corePartialsPath, hibachiPathBuilder) { return new SWExpiringSessionNotifier(corePartialsPath, hibachiPathBuilder); };
        directive.$inject = ['corePartialsPath', 'hibachiPathBuilder'];
        return directive;
    };
    return SWExpiringSessionNotifier;
}());
exports.SWExpiringSessionNotifier = SWExpiringSessionNotifier;


/***/ }),

/***/ "qMWF":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path="../../../typings/tsd.d.ts" />
/// <reference path="../../../typings/hibachiTypescript.d.ts" />
/*collection service is used to maintain the state of the ui*/
Object.defineProperty(exports, "__esModule", { value: true });
exports.Pagination = exports.PaginationService = void 0;
var Pagination = /** @class */ (function () {
    //@ngInject
    Pagination.$inject = ["observerService", "uuid"];
    function Pagination(observerService, uuid) {
        var _this = this;
        this.observerService = observerService;
        this.uuid = uuid;
        this.pageShow = 10;
        this.currentPage = 1;
        this.pageStart = 0;
        this.pageEnd = 0;
        this.recordsCount = 0;
        this.limitCountTotal = 0; //To be used to update the actual fetchcount instead of default 10
        this.totalPages = 0;
        this.pageShowOptions = [
            { display: 10, value: 10 },
            { display: 20, value: 20 },
            { display: 50, value: 50 },
            { display: 250, value: 250 },
            { display: "Auto", value: "Auto" }
        ];
        this.autoScrollPage = 1;
        this.autoScrollDisabled = false;
        this.notifyById = true;
        this.getSelectedPageShowOption = function () {
            return _this.selectedPageShowOption;
        };
        this.pageShowOptionChanged = function (pageShowOption) {
            _this.setPageShow(pageShowOption.value);
            _this.currentPage = 1;
            _this.notify('swPaginationAction', { type: 'setPageShow', payload: _this.getPageShow() });
        };
        this.getTotalPages = function () {
            return _this.totalPages;
        };
        this.setTotalPages = function (totalPages) {
            _this.totalPages = totalPages;
        };
        this.getPageStart = function () {
            return _this.pageStart;
        };
        this.setPageStart = function (pageStart) {
            _this.pageStart = pageStart;
        };
        this.getPageEnd = function () {
            return _this.pageEnd;
        };
        this.setPageEnd = function (pageEnd) {
            _this.pageEnd = pageEnd;
        };
        this.getRecordsCount = function () {
            return _this.recordsCount;
        };
        this.setRecordsCount = function (recordsCount) {
            _this.recordsCount = recordsCount;
        };
        this.getLimitCountTotal = function () {
            return _this.limitCountTotal;
        };
        this.setLimitCountTotal = function (limitCountTotal) {
            _this.limitCountTotal = limitCountTotal;
        };
        this.getPageShowOptions = function () {
            return _this.pageShowOptions;
        };
        this.setPageShowOptions = function (pageShowOptions) {
            _this.pageShowOptions = pageShowOptions;
        };
        this.getPageShow = function () {
            return _this.pageShow;
        };
        this.setPageShow = function (pageShow) {
            _this.pageShow = pageShow;
        };
        this.getCurrentPage = function () {
            return _this.currentPage;
        };
        this.setCurrentPage = function (currentPage) {
            _this.currentPage = currentPage;
            //this.observerService.notifyById('swPaginationAction', this.uuid,{action:'pageChange', currentPage});
            _this.notify('swPaginationAction', { type: 'setCurrentPage', payload: _this.getCurrentPage() });
        };
        this.previousPage = function () {
            if (_this.getCurrentPage() == 1)
                return;
            _this.setCurrentPage(_this.getCurrentPage() - 1);
        };
        this.nextPage = function () {
            if (_this.getCurrentPage() < _this.getTotalPages()) {
                _this.setCurrentPage(_this.getCurrentPage() + 1);
                _this.notify('swPaginationAction', { type: 'nextPage', payload: _this.getCurrentPage() });
            }
        };
        this.hasPrevious = function () {
            //With no actual recordsCount, need to check if previous page exists even if there's no data on current page. This enables user to go back to previous page if no results exist on current page, unloess its the very first page
            return (_this.getPageStart() <= 1 && _this.getPageEnd() !== 0);
            //this.getPageStart() checks if this isnt the first page itself
            //this.getPageEnd() !== 0 tells us if a previous page exists even if the current page has no records 
        };
        this.hasNext = function () {
            //Same as above hasPrevious: Need to alter this to fetch anyways and then show appropriate message if no data exists on next fetch
            return (_this.getPageEnd() === _this.getRecordsCount());
        };
        this.showPreviousJump = function () {
            return (angular.isDefined(_this.getCurrentPage()) && _this.getCurrentPage() > 4 && _this.getTotalPages() > 6);
        };
        this.showNextJump = function () {
            return !!(_this.getCurrentPage() < _this.getTotalPages() - 3 && _this.getTotalPages() > 6);
        };
        this.previousJump = function () {
            _this.setCurrentPage(_this.currentPage - 3);
        };
        this.nextJump = function () {
            _this.setCurrentPage(_this.getCurrentPage() + 3);
        };
        this.showPageNumber = function (pageNumber) {
            if (_this.getCurrentPage() >= _this.getTotalPages() - 3) {
                if (pageNumber > _this.getTotalPages() - 6) {
                    return true;
                }
            }
            if (_this.getCurrentPage() <= 4) {
                if (pageNumber < 6 && pageNumber - _this.getCurrentPage() <= 2) { // 
                    return true;
                }
            }
            if (_this.getCurrentPage() >= 5) {
                var bottomRange = _this.getCurrentPage() - 2;
                var topRange = _this.getCurrentPage() + 2;
                if (pageNumber > bottomRange && pageNumber < topRange) {
                    return true;
                }
            }
            return false;
        };
        this.setPageRecordsInfo = function (collection) {
            //Documentation: Partial transfer of pagination control to front-end. Needs to be further rewritten
            var pageRecordsCount = collection.pageRecordsCount, //actual results obtained - defaults to limit 10 unless otherwise specified by pageRecordsShow
            pageRecordsShow = collection.pageRecordsShow, recordsCount = collection.recordsCount, //arbitary fetch of recordsCount to get total records in db
            pageRecordsEnd = collection.pageRecordsEnd, limitCountTotal = collection.limitCountTotal;
            _this.setLimitCountTotal(limitCountTotal);
            //Again, using the limitCountTotal to retain old functionality to work as before
            if (limitCountTotal === 0) {
                _this.setRecordsCount(recordsCount);
                _this.setPageEnd(pageRecordsCount);
            }
            else {
                if ((pageRecordsCount < recordsCount) && (pageRecordsCount < pageRecordsShow)) {
                    _this.setPageEnd(pageRecordsCount);
                }
                else {
                    _this.setPageEnd(pageRecordsEnd);
                }
                _this.setRecordsCount((pageRecordsCount < pageRecordsShow) ? pageRecordsCount : recordsCount);
            }
            if (_this.getRecordsCount() === 0) {
                _this.setPageStart(0);
            }
            else {
                _this.setPageStart(collection.pageRecordsStart);
            }
            _this.setTotalPages(collection.totalPages);
            _this.currentPage = collection.currentPage;
            _this.totalPagesArray = [];
            if (angular.isUndefined(_this.getCurrentPage()) || _this.getCurrentPage() < 5) {
                var start = 1;
                var end = (_this.getTotalPages() <= 10) ? _this.getTotalPages() + 1 : 10;
            }
            else {
                var start = (!_this.showNextJump()) ? _this.getTotalPages() - 4 : _this.getCurrentPage() - 3;
                var end = (_this.showNextJump()) ? _this.getCurrentPage() + 5 : _this.getTotalPages() + 1;
            }
            for (var i = start; i < end; i++) {
                _this.totalPagesArray.push(i);
            }
        };
        this.uuid = uuid;
        this.selectedPageShowOption = this.pageShowOptions[0];
        this.observerService.attach(this.setPageRecordsInfo, 'swPaginationUpdate', this.uuid);
    }
    Pagination.prototype.notify = function (event, parameters) {
        if (this.notifyById === true) {
            this.observerService.notifyById(event, this.uuid, parameters);
        }
        else {
            this.observerService.notify(event, parameters);
        }
    };
    return Pagination;
}());
exports.Pagination = Pagination;
var PaginationService = /** @class */ (function () {
    //@ngInject
    PaginationService.$inject = ["utilityService", "observerService"];
    function PaginationService(utilityService, observerService) {
        var _this = this;
        this.utilityService = utilityService;
        this.observerService = observerService;
        this.paginations = {};
        this.createPagination = function (id) {
            var uuid = _this.utilityService.createID(10);
            if (angular.isDefined(id)) {
                uuid = id;
            }
            _this.paginations[uuid] = new Pagination(_this.observerService, uuid);
            return _this.paginations[uuid];
        };
        this.getPagination = function (uuid) {
            if (!uuid)
                return;
            return _this.paginations[uuid];
        };
    }
    return PaginationService;
}());
exports.PaginationService = PaginationService;


/***/ }),

/***/ "qOTf":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWErrorDisplayController = exports.SWErrorDisplay = void 0;
var SWErrorDisplayController = /** @class */ (function () {
    //@ngInject
    SWErrorDisplayController.$inject = ["$injector"];
    function SWErrorDisplayController($injector) {
        this.$injector = $injector;
        this.$injector = $injector;
    }
    SWErrorDisplayController.prototype.$onInit = function () {
        /**
         if a css error class was passed to propertyDisplay, attach to form
         which will apply it to the dynamically generateddiv that contains
         the error message
        **/
        if (this.swfPropertyDisplay && this.swfPropertyDisplay.errorClass) {
            this.swForm.errorClass = this.swfPropertyDisplay.errorClass;
        }
        var bindToControllerProps = this.$injector.get('swErrorDisplayDirective')[0].bindToController;
        for (var i in bindToControllerProps) {
            if (!this[i] && i !== 'name') {
                if (!this[i] && this.swPropertyDisplay && this.swPropertyDisplay[i]) {
                    this[i] = this.swPropertyDisplay[i];
                }
                else if (!this[i] && this.swfPropertyDisplay && this.swfPropertyDisplay[i]) {
                    this[i] = this.swfPropertyDisplay[i];
                }
                else if (!this[i] && this.swForm && this.swForm[i]) {
                    this[i] = this.swForm[i];
                }
            }
        }
        this.property = this.property || this.propertyIdentifier;
        this.propertyIdentifier = this.propertyIdentifier || this.property;
        if (!this.name && this.property) {
            this.name = this.property;
        }
    };
    return SWErrorDisplayController;
}());
exports.SWErrorDisplayController = SWErrorDisplayController;
var SWErrorDisplay = /** @class */ (function () {
    // @ngInject
    SWErrorDisplay.$inject = ["coreFormPartialsPath", "hibachiPathBuilder"];
    function SWErrorDisplay(coreFormPartialsPath, hibachiPathBuilder) {
        this.coreFormPartialsPath = coreFormPartialsPath;
        this.hibachiPathBuilder = hibachiPathBuilder;
        this.require = {
            swForm: "^?swForm",
            form: "^?form",
            swPropertyDisplay: "^?swPropertyDisplay",
            swfPropertyDisplay: "^?swfPropertyDisplay"
        };
        this.restrict = "E";
        this.controller = SWErrorDisplayController;
        this.controllerAs = "swErrorDisplay";
        this.scope = {};
        this.bindToController = {
            form: "=?",
            name: "@?",
            property: "@?",
            propertyIdentifier: "@?",
            errorClass: "@?"
        };
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(this.coreFormPartialsPath) + "errordisplay.html";
    }
    SWErrorDisplay.Factory = function () {
        var directive = function (coreFormPartialsPath, hibachiPathBuilder) { return new SWErrorDisplay(coreFormPartialsPath, hibachiPathBuilder); };
        directive.$inject = [
            'coreFormPartialsPath',
            'hibachiPathBuilder'
        ];
        return directive;
    };
    return SWErrorDisplay;
}());
exports.SWErrorDisplay = SWErrorDisplay;


/***/ }),

/***/ "qisz":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.OrderPaymentService = void 0;
var baseentityservice_1 = __webpack_require__("P6y0");
var OrderPaymentService = /** @class */ (function (_super) {
    __extends(OrderPaymentService, _super);
    //@ngInject
    OrderPaymentService.$inject = ["$injector", "$hibachi", "utilityService"];
    function OrderPaymentService($injector, $hibachi, utilityService) {
        var _this = _super.call(this, $injector, $hibachi, utilityService, 'OrderPayment') || this;
        _this.$injector = $injector;
        _this.$hibachi = $hibachi;
        _this.utilityService = utilityService;
        return _this;
    }
    return OrderPaymentService;
}(baseentityservice_1.BaseEntityService));
exports.OrderPaymentService = OrderPaymentService;


/***/ }),

/***/ "qp7O":
/***/ (function(module, exports) {

module.exports = "<span style=\"margin-left:{{swExpandableRecord.recordDepth*40||0}}px;position:relative;padding-left: 12px;\">\n\t<i\n\t\tng-show=\"swExpandableRecord.collectionPromise.$$state.status !== 0\"\n\t\tclass=\"fa fa-caret-{{swExpandableRecord.childrenOpen ? 'down' : 'right'}} {{swExpandableRecord.edit ? '' : 'disabled'}} s-listing-arrow\"\n\t\t\n\t>\n\n\t</i>\n\t<i ng-show=\"swExpandableRecord.collectionPromise.$$state.status === 0\"\n\t\tclass=\"fa fa-refresh fa-spin s-loading-icon\"\n\t>\n\t</i>\n\t<a ng-if=\"swExpandableRecord.link\" ng-href=\"{{swExpandableRecord.link}}\" class=\"s-contents-page-title\">\n\t\t<span ng-bind=\"swExpandableRecord.recordValue\"></span>\n\t</a>\n\t<span ng-if=\"!swExpandableRecord.link\" ng-bind=\"swExpandableRecord.recordValue\"></span>\n</span>";

/***/ }),

/***/ "rHbG":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWFormSubscriber = void 0;
var SWFormSubscriberController = /** @class */ (function () {
    //@ngInject
    SWFormSubscriberController.$inject = ["$log", "$compile", "$hibachi", "utilityService", "rbkeyService", "$injector"];
    function SWFormSubscriberController($log, $compile, $hibachi, utilityService, rbkeyService, $injector) {
        var _this = this;
        this.$log = $log;
        this.$compile = $compile;
        this.$hibachi = $hibachi;
        this.utilityService = utilityService;
        this.rbkeyService = rbkeyService;
        this.$injector = $injector;
        this.$onInit = function () {
            var bindToControllerProps = _this.$injector.get('swFormSubscriberDirective')[0].bindToController;
            for (var i in bindToControllerProps) {
                if (!_this[i]) {
                    if (!_this[i] && _this.swForm && _this.swForm[i]) {
                        _this[i] = _this.swForm[i];
                    }
                }
            }
            _this.property = _this.property || _this.propertyIdentifier;
            _this.propertyIdentifier = _this.propertyIdentifier || _this.property;
            _this.type = _this.type || _this.fieldType;
            _this.fieldType = _this.fieldType || _this.type;
            _this.edit = _this.edit || _this.editing;
            _this.editing = _this.editing || _this.edit;
            _this.editing = _this.editing || true;
            _this.fieldType = _this.fieldType || "text";
            _this.inputAttributes = _this.inputAttributes || "";
        };
        this.utilityService = utilityService;
        this.$hibachi = $hibachi;
        this.rbkeyService = rbkeyService;
        this.$log = $log;
        this.$injector = $injector;
    }
    return SWFormSubscriberController;
}());
var SWFormSubscriber = /** @class */ (function () {
    //@ngInject
    function SWFormSubscriber() {
        this.restrict = "A";
        this.require = {
            swForm: "?^swForm",
            form: "?^form"
        };
        this.scope = {};
        this.bindToController = {
            propertyIdentifier: "@?",
            name: "@?",
            class: "@?",
            errorClass: "@?",
            option: "=?",
            valueObject: "=?",
            object: "=?",
            label: "@?",
            labelText: "@?",
            labelClass: "@?",
            optionValues: "=?",
            edit: "=?",
            title: "@?",
            value: "=?",
            errorText: "@?",
            fieldType: "@?",
            property: "@?",
            inputAttributes: "@?",
            type: "@?",
            editing: "=?"
        };
        this.controller = SWFormSubscriberController;
        this.controllerAs = "SWFormSubscriber";
        this.link = function (scope, element, attr) {
        };
    }
    SWFormSubscriber.Factory = function () {
        var directive = function () { return new SWFormSubscriber(); };
        directive.$inject = [];
        return directive;
    };
    return SWFormSubscriber;
}());
exports.SWFormSubscriber = SWFormSubscriber;


/***/ }),

/***/ "slRK":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.dialogmodule = void 0;
//services
var dialogservice_1 = __webpack_require__("Ci1q");
//controllers
var pagedialog_1 = __webpack_require__("ZbLJ");
var dialogmodule = angular.module('hibachi.dialog', []).config(function () {
})
    //services
    .service('dialogService', dialogservice_1.DialogService)
    //controllers
    .controller('pageDialog', pagedialog_1.PageDialogController)
    //filters
    //constants
    .constant('dialogPartials', 'dialog/components/');
exports.dialogmodule = dialogmodule;


/***/ }),

/***/ "tc0Z":
/***/ (function(module, exports) {

module.exports = "<section class=\"col-xs-12 s-bundle-content\" >\n    <div class=\"row s-bundle-header\" ng-if=\"SwLogin.account_login\">\n\t\t<div class=\"col-xs-6\">\n\t\t\t<sw-form name=\"form.account_login\"  object=\"SwLogin.account_login\" context=\"Login\">\n\t\t\t\t<sw-property-display object=\"SwLogin.account_login\" property=\"emailAddress\" editing=\"true\"></sw-property-display>\n\t\t\t\t<sw-property-display object=\"SwLogin.account_login\" property=\"password\" editing=\"true\"></sw-property-display>\n\t\t\t</sw-form>\n\t\t</div>\n    </div>\n</section>\n<footer>\n    <div class=\"navbar navbar-s-navbar-ten24 s-dialog-footer\">\n      <ul class=\"nav navbar-nav pull-right\">\n        <li ng-class=\"{'active s-loading': closeSaving === true, 'active': closeSaving === false}\">\n        \t<a  style=\"cursor:pointer;padding: 9px 12px;font-size: 16px;\"\n        \t\tng-click=\"SwLogin.login();\"\n        \t>Login</a>\n        </li>\n      </ul>\n    </div>\n</footer>";

/***/ }),

/***/ "tmHj":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.HibachiScope = void 0;
var HibachiScope = /** @class */ (function () {
    //@ngInject
    HibachiScope.$inject = ["appConfig"];
    function HibachiScope(appConfig) {
        var _this = this;
        this.loginDisplayed = false;
        this.isValidToken = true;
        this.setToken = function (token) {
            _this.token = token;
            var stringArray = token.split('.');
            try {
                _this.jwtInfo = angular.fromJson(window.atob(stringArray[0]).trim());
                _this.session = angular.fromJson(window.atob(stringArray[1]).trim());
            }
            catch (err) {
                _this.isValidToken = false;
            }
        };
        this.config = appConfig;
    }
    return HibachiScope;
}());
exports.HibachiScope = HibachiScope;


/***/ }),

/***/ "ts6z":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.FileService = void 0;
var FileService = /** @class */ (function () {
    //@ngInject
    FileService.$inject = ["$q", "observerService"];
    function FileService($q, observerService) {
        var _this = this;
        this.$q = $q;
        this.observerService = observerService;
        this.fileStates = {};
        this.imageExists = function (src) {
            var deferred = _this.$q.defer();
            var image = new Image();
            image.onerror = function () {
                deferred.reject();
            };
            image.onload = function () {
                deferred.resolve();
            };
            image.src = src;
            return deferred.promise;
        };
        this.uploadFile = function (file, object, property) {
            var deferred = _this.$q.defer();
            var promise = deferred.promise;
            var fileReader = new FileReader();
            fileReader.readAsDataURL(file);
            fileReader.onload = function (result) {
                object.data[property] = fileReader.result;
                deferred.resolve(fileReader.result);
            };
            fileReader.onerror = function (result) {
                deferred.reject();
                throw ("fileservice couldn't read the file");
            };
            return promise;
        };
    }
    return FileService;
}());
exports.FileService = FileService;


/***/ }),

/***/ "uDRM":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWTypeaheadInputFieldController = exports.SWTypeaheadInputField = void 0;
var SWTypeaheadInputFieldController = /** @class */ (function () {
    // @ngInject
    SWTypeaheadInputFieldController.$inject = ["$scope", "$transclude", "collectionConfigService", "typeaheadService", "$rootScope", "observerService"];
    function SWTypeaheadInputFieldController($scope, $transclude, collectionConfigService, typeaheadService, $rootScope, observerService) {
        var _this = this;
        this.$scope = $scope;
        this.$transclude = $transclude;
        this.collectionConfigService = collectionConfigService;
        this.typeaheadService = typeaheadService;
        this.$rootScope = $rootScope;
        this.observerService = observerService;
        this.columns = [];
        this.addFunction = function (value) {
            _this.typeaheadService.typeaheadStore.dispatch({
                "type": "TYPEAHEAD_USER_SELECTION",
                "payload": {
                    name: _this.fieldName || "",
                    data: value[_this.propertyToSave] || ""
                }
            });
            _this.modelValue = value[_this.propertyToSave];
            if (_this.action) {
                var data = {};
                if (_this.variables) {
                    data = _this.variables();
                }
                data['value'] = _this.modelValue;
                _this.$root.slatwall.doAction(_this.action, data);
            }
        };
        this.$root = $rootScope;
        if (angular.isUndefined(this.typeaheadCollectionConfig)) {
            if (angular.isDefined(this.entityName)) {
                this.typeaheadCollectionConfig = collectionConfigService.newCollectionConfig(this.entityName);
            }
            else {
                throw ("You did not pass the correct collection config data to swTypeaheadInputField");
            }
        }
        if (angular.isUndefined(this.validateRequired)) {
            this.validateRequired = false;
        }
        //get the collection config
        this.$transclude($scope, function () { });
        if (angular.isUndefined(this.propertyToSave)) {
            throw ("You must select a property to save for the input field directive");
        }
        if (angular.isDefined(this.propertiesToLoad)) {
            if (this.propertiesToSearch && this.propertiesToSearch.length) {
                var propertiesToLoad = this.propertiesToLoad.split(',');
                for (var _i = 0, propertiesToLoad_1 = propertiesToLoad; _i < propertiesToLoad_1.length; _i++) {
                    var propertyToLoad = propertiesToLoad_1[_i];
                    this.typeaheadCollectionConfig.addDisplayProperty(propertyToLoad, undefined, { isSearchable: this.propertiesToSearch.split(',').indexOf(propertyToLoad) > -1 });
                }
            }
            else {
                this.typeaheadCollectionConfig.addDisplayProperty(this.propertiesToLoad);
            }
        }
        angular.forEach(this.columns, function (column) {
            _this.typeaheadCollectionConfig.addDisplayProperty(column.propertyIdentifier, '', column);
        });
        angular.forEach(this.filters, function (filter) {
            _this.typeaheadCollectionConfig.addFilter(filter.propertyIdentifier, filter.comparisonValue, filter.comparisonOperator, filter.logicalOperator, filter.hidden);
        });
        if (angular.isDefined(this.initialEntityId) && this.initialEntityId.length) {
            this.modelValue = this.initialEntityId;
        }
        if (this.eventListeners) {
            for (var key in this.eventListeners) {
                observerService.attach(this.eventListeners[key], key);
            }
        }
    }
    return SWTypeaheadInputFieldController;
}());
exports.SWTypeaheadInputFieldController = SWTypeaheadInputFieldController;
var SWTypeaheadInputField = /** @class */ (function () {
    function SWTypeaheadInputField() {
        this.transclude = true;
        this.restrict = "EA";
        this.scope = {};
        this.bindToController = {
            fieldName: "@",
            entityName: "@",
            typeaheadCollectionConfig: "=?",
            filters: "=?",
            propertiesToLoad: "@?",
            propertiesToSearch: "@?",
            placeholderRbKey: "@?",
            propertyToShow: "@",
            propertyToSave: "@",
            initialEntityId: "@",
            allRecords: "=?",
            validateRequired: "=?",
            maxRecords: "@",
            action: "@",
            variables: '&?',
            eventListeners: '=?',
            placeholderText: '@?',
            searchEndpoint: '@?',
            titleText: '@?',
            typeaheadDataKey: '@?'
        };
        this.controller = SWTypeaheadInputFieldController;
        this.controllerAs = "swTypeaheadInputField";
        this.template = __webpack_require__("1bHV");
    }
    SWTypeaheadInputField.Factory = function () {
        var _this = this;
        return /** @ngInject; */ function () { return new _this(); };
    };
    return SWTypeaheadInputField;
}());
exports.SWTypeaheadInputField = SWTypeaheadInputField;


/***/ }),

/***/ "uqgD":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWHref = void 0;
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWHref = /** @class */ (function () {
    // 	@ngInject;
    function SWHref() {
        return {
            restrict: 'A',
            scope: {
                swHref: "@"
            },
            link: function (scope, element, attrs) {
                /*convert link to use hashbang*/
                var hrefValue = attrs.swHref;
                hrefValue = '?ng#!' + hrefValue;
                element.attr('href', hrefValue);
            }
        };
    }
    SWHref.Factory = function () {
        return function () { return new SWHref(); };
    };
    return SWHref;
}());
exports.SWHref = SWHref;


/***/ }),

/***/ "v97U":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWTabContentController = exports.SWTabContent = void 0;
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWTabContentController = /** @class */ (function () {
    // @ngInject
    SWTabContentController.$inject = ["$scope", "$q", "$transclude", "$hibachi", "$timeout", "utilityService", "rbkeyService", "collectionConfigService"];
    function SWTabContentController($scope, $q, $transclude, $hibachi, $timeout, utilityService, rbkeyService, collectionConfigService) {
        this.$scope = $scope;
        this.$q = $q;
        this.$transclude = $transclude;
        this.$hibachi = $hibachi;
        this.$timeout = $timeout;
        this.utilityService = utilityService;
        this.rbkeyService = rbkeyService;
        this.collectionConfigService = collectionConfigService;
        if (angular.isUndefined(this.active)) {
            this.active = false;
        }
        if (angular.isUndefined(this.loaded)) {
            this.loaded = false;
        }
        if (angular.isUndefined(this.hide)) {
            this.hide = false;
        }
        if (angular.isUndefined(this.id)) {
            this.id = utilityService.createID(16);
        }
        if (angular.isUndefined(this.name)) {
            this.name = this.id;
        }
        //make a tab service? 
    }
    return SWTabContentController;
}());
exports.SWTabContentController = SWTabContentController;
var SWTabContent = /** @class */ (function () {
    // @ngInject
    SWTabContent.$inject = ["$compile", "scopeService", "observerService"];
    function SWTabContent($compile, scopeService, observerService) {
        var _this = this;
        this.$compile = $compile;
        this.scopeService = scopeService;
        this.observerService = observerService;
        this.transclude = true;
        this.restrict = "EA";
        this.scope = {};
        this.bindToController = {
            active: "=?",
            loaded: "=?",
            hide: "=?",
            name: "@?"
        };
        this.controller = SWTabContentController;
        this.controllerAs = "swTabContent";
        this.template = __webpack_require__("MC8M");
        this.compile = function (element, attrs, transclude) {
            return {
                pre: function ($scope, element, attrs) {
                },
                post: function ($scope, element, attrs) {
                    var parentDirective = _this.scopeService.getRootParentScope($scope, "swTabGroup")["swTabGroup"];
                    if (angular.isDefined(parentDirective) && angular.isDefined(parentDirective.tabs)) {
                        parentDirective.tabs.push($scope.swTabContent);
                        _this.observerService.notify(parentDirective.initTabEventName);
                    }
                }
            };
        };
    }
    SWTabContent.Factory = function () {
        var _this = this;
        return /** @ngInject; */ ["$compile", "scopeService", "observerService", function ($compile, scopeService, observerService) { return new _this($compile, scopeService, observerService); }];
    };
    return SWTabContent;
}());
exports.SWTabContent = SWTabContent;


/***/ }),

/***/ "vVMi":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWSortable = void 0;
var SWSortable = /** @class */ (function () {
    // @ngInject;
    SWSortable.$inject = ["expression", "compiledElement"];
    function SWSortable(expression, compiledElement) {
        return function (linkElement) {
            var scope = this;
            linkElement.sortable({
                placeholder: "placeholder",
                opacity: 0.8,
                axis: "y",
                update: function (event, ui) {
                    // get model
                    var model = scope.$apply(expression);
                    // remember its length
                    var modelLength = model.length;
                    // rember html nodes
                    var items = [];
                    // loop through items in new order
                    linkElement.children().each(function (index) {
                        var item = $(this);
                        // get old item index
                        var oldIndex = parseInt(item.attr("sw:sortable-index"), 10);
                        // add item to the end of model
                        model.push(model[oldIndex]);
                        if (item.attr("sw:sortable-index")) {
                            // items in original order to restore dom
                            items[oldIndex] = item;
                            // and remove item from dom
                            item.detach();
                        }
                    });
                    model.splice(0, modelLength);
                    // restore original dom order, so angular does not get confused
                    linkElement.append.apply(linkElement, items);
                    // notify angular of the change
                    scope.$digest();
                }
            });
        };
    }
    SWSortable.Factory = function () {
        var directive = function (expression, compiledElement) { return new SWSortable(expression, compiledElement); };
        directive.$inject = ['expression', 'compiledElement'];
        return directive;
    };
    return SWSortable;
}());
exports.SWSortable = SWSortable;


/***/ }),

/***/ "vaCL":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWExportAction = void 0;
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWExportAction = /** @class */ (function () {
    function SWExportAction() {
        this.template = __webpack_require__("fBkV");
        this.restrict = 'A';
    }
    SWExportAction.Factory = function () {
        var _this = this;
        return /** @ngInject; */ function () { return new _this(); };
    };
    return SWExportAction;
}());
exports.SWExportAction = SWExportAction;


/***/ }),

/***/ "vqva":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.paginationmodule = void 0;
/// <reference path="../../typings/tsd.d.ts" />
/// <reference path="../../typings/hibachiTypescript.d.ts" />
//services
var paginationservice_1 = __webpack_require__("qMWF");
var swpaginationbar_1 = __webpack_require__("V4rq");
var core_module_1 = __webpack_require__("pwA0");
var paginationmodule = angular.module('hibachi.pagination', [core_module_1.coremodule.name])
    // .config(['$provide','baseURL',($provide,baseURL)=>{
    // 	$provide.constant('paginationPartials', baseURL+basePartialsPath+'pagination/components/');
    // }])
    .run([function () {
    }])
    //services
    .service('paginationService', paginationservice_1.PaginationService)
    .directive('swPaginationBar', swpaginationbar_1.SWPaginationBar.Factory())
    //constants
    .constant('partialsPath', 'pagination/components/');
exports.paginationmodule = paginationmodule;


/***/ }),

/***/ "vvI4":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../typings/tsd.d.ts' />
var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.BaseProcess = void 0;
var basetransient_1 = __webpack_require__("zLAs");
var BaseProcess = /** @class */ (function (_super) {
    __extends(BaseProcess, _super);
    function BaseProcess($injector) {
        return _super.call(this, $injector) || this;
    }
    return BaseProcess;
}(basetransient_1.BaseTransient));
exports.BaseProcess = BaseProcess;


/***/ }),

/***/ "vvJr":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.EntityService = void 0;
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var baseentityservice_1 = __webpack_require__("P6y0");
var EntityService = /** @class */ (function (_super) {
    __extends(EntityService, _super);
    //@ngInject
    EntityService.$inject = ["$injector", "$hibachi", "utilityService"];
    function EntityService($injector, $hibachi, utilityService) {
        var _this = _super.call(this, $injector, $hibachi, utilityService) || this;
        _this.$injector = $injector;
        _this.$hibachi = $hibachi;
        _this.utilityService = utilityService;
        return _this;
    }
    return EntityService;
}(baseentityservice_1.BaseEntityService));
exports.EntityService = EntityService;


/***/ }),

/***/ "w+Sp":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWFAlertController = exports.SWFAlert = void 0;
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWFAlertController = /** @class */ (function () {
    function SWFAlertController($rootScope, $timeout, $scope, observerService) {
        var _this = this;
        this.$rootScope = $rootScope;
        this.$timeout = $timeout;
        this.$scope = $scope;
        this.observerService = observerService;
        //@ngInject
        this.alertDisplaying = false;
        this.duration = 2;
        this.$onInit = function () {
            if (_this.displayOnInit) {
                _this.displayAlert();
            }
        };
        this.displayAlert = function () {
            _this.alertDisplaying = true;
            _this.$timeout(function () {
                _this.alertDisplaying = false;
            }, _this.duration * 1000);
        };
        this.$rootScope = $rootScope;
        this.observerService.attach(this.displayAlert, this.alertTrigger);
    }
    return SWFAlertController;
}());
exports.SWFAlertController = SWFAlertController;
var SWFAlert = /** @class */ (function () {
    //@ngInject
    SWFAlert.$inject = ["coreFrontEndPartialsPath", "hibachiPathBuilder"];
    function SWFAlert(coreFrontEndPartialsPath, hibachiPathBuilder) {
        this.coreFrontEndPartialsPath = coreFrontEndPartialsPath;
        this.hibachiPathBuilder = hibachiPathBuilder;
        this.restrict = 'EA';
        this.scope = {};
        this.bindToController = {
            alertTrigger: '@?',
            alertType: '@?',
            duration: '<?',
            message: '@?',
            displayOnInit: '<?'
        };
        this.controller = SWFAlertController;
        this.controllerAs = "swfAlert";
        this.templateUrl = "";
        this.url = "";
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(this.coreFrontEndPartialsPath) + "swfalert.html";
    }
    SWFAlert.Factory = function () {
        var directive = function (coreFrontEndPartialsPath, hibachiPathBuilder) { return new SWFAlert(coreFrontEndPartialsPath, hibachiPathBuilder); };
        directive.$inject = [
            'coreFrontEndPartialsPath',
            'hibachiPathBuilder'
        ];
        return directive;
    };
    return SWFAlert;
}());
exports.SWFAlert = SWFAlert;


/***/ }),

/***/ "x4Rm":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWLogin = void 0;
var SWLoginController = /** @class */ (function () {
    //@ngInject
    SWLoginController.$inject = ["$route", "$log", "$window", "corePartialsPath", "$hibachi", "dialogService", "hibachiScope"];
    function SWLoginController($route, $log, $window, corePartialsPath, $hibachi, dialogService, hibachiScope) {
        var _this = this;
        this.$route = $route;
        this.$log = $log;
        this.$window = $window;
        this.corePartialsPath = corePartialsPath;
        this.$hibachi = $hibachi;
        this.dialogService = dialogService;
        this.hibachiScope = hibachiScope;
        this.login = function () {
            var loginPromise = _this.$hibachi.login(_this.account_login.data.emailAddress, _this.account_login.data.password);
            loginPromise.then(function (loginResponse) {
                if (loginResponse && loginResponse.data && loginResponse.data.token) {
                    _this.$window.localStorage.setItem('token', loginResponse.data.token);
                    _this.hibachiScope.loginDisplayed = false;
                    _this.$route.reload();
                    _this.dialogService.removeCurrentDialog();
                }
            }, function (rejection) {
            });
        };
        this.$hibachi = $hibachi;
        this.$window = $window;
        this.$route = $route;
        this.hibachiScope = hibachiScope;
        this.account_login = $hibachi.newEntity('Account_Login');
    }
    return SWLoginController;
}());
var SWLogin = /** @class */ (function () {
    function SWLogin() {
        this.restrict = 'E';
        this.scope = {};
        this.bindToController = {};
        this.controller = SWLoginController;
        this.controllerAs = "SwLogin";
        this.template = __webpack_require__("tc0Z");
    }
    SWLogin.Factory = function () {
        var _this = this;
        return /** @ngInject; */ function () { return new _this(); };
    };
    return SWLogin;
}());
exports.SWLogin = SWLogin;


/***/ }),

/***/ "xSVC":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.AccountAddressService = void 0;
var baseentityservice_1 = __webpack_require__("P6y0");
var AccountAddressService = /** @class */ (function (_super) {
    __extends(AccountAddressService, _super);
    //@ngInject
    AccountAddressService.$inject = ["$injector", "$hibachi", "utilityService"];
    function AccountAddressService($injector, $hibachi, utilityService) {
        var _this = _super.call(this, $injector, $hibachi, utilityService, 'AccountAddress') || this;
        _this.$injector = $injector;
        _this.$hibachi = $hibachi;
        _this.utilityService = utilityService;
        return _this;
    }
    return AccountAddressService;
}(baseentityservice_1.BaseEntityService));
exports.AccountAddressService = AccountAddressService;


/***/ }),

/***/ "yFMl":
/***/ (function(module, exports) {

module.exports = "<!--\n\tTODO: figure out the context of entity as an object\n<cfif !isObject(attributes.entity) || (isObject(attributes.entity) && ( !attributes.disabled || !attributes.hideDisabled ) )>\n\t\t<hb:HibachiActionCaller attributecollection=\"#attributes#\" />\n\t</cfif>-->\n<sw-action-caller\n\t\n\tdata-type=\"{{swProcessCaller.type}}\"\n\tdata-action=\"{{swProcessCaller.action}}\"\n\tdata-text=\"{{swProcessCaller.text}}\"\n\tdata-query-string=\"{{swProcessCaller.queryString+'&processContext='+swProcessCaller.processContext}}\"\n\tdata-title=\"{{swProcessCaller.title}}\"\n\tdata-class=\"{{swProcessCaller.class}}\"\n\tdata-icon=\"{{swProcessCaller.icon}}\"\n\tdata-iconOnly=\"swProcessCaller.iconOnly\"\n\tdata-name=\"{{swProcessCaller.name}}\"\n\tdata-confirm=\"swProcessCaller.confirm\"\n\tdata-confirmtext=\"{{swProcessCaller.confirmtext}}\"\n\tdata-disabled=\"swProcessCaller.disabled\"\n\tdata-disabledtext=\"{{swProcessCaller.disabledtext}}\"\n\tdata-modal=\"swProcessCaller.modal\"\n\tdata-modal-full-width=\"swProcessCaller.modalFullWidth\"\n\tdata-id=\"{{swProcessCaller.id}}\"\n>\n</sw-action-caller>";

/***/ }),

/***/ "yPmm":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.ScopeService = void 0;
var ScopeService = /** @class */ (function () {
    //@ngInject
    function ScopeService() {
        var _this = this;
        this.getRootParentScope = function (scope, targetScopeName) {
            var currentScope = scope;
            while (currentScope != null && angular.isUndefined(currentScope[targetScopeName])) {
                if (angular.isDefined(currentScope.$parent)) {
                    currentScope = currentScope.$parent;
                }
                else {
                    break;
                }
            }
            if (currentScope != null && angular.isDefined(currentScope[targetScopeName])) {
                return currentScope;
            }
        };
        this.hasParentScope = function (scope, targetScopeName) {
            if (_this.getRootParentScope(scope, targetScopeName) != null) {
                return true;
            }
            return false;
        };
    }
    return ScopeService;
}());
exports.ScopeService = ScopeService;


/***/ }),

/***/ "zLAs":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../typings/tsd.d.ts' />
var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.BaseTransient = void 0;
var baseobject_1 = __webpack_require__("nXj+");
var BaseTransient = /** @class */ (function (_super) {
    __extends(BaseTransient, _super);
    function BaseTransient($injector) {
        var _this = _super.call(this, $injector) || this;
        _this.errors = {};
        _this.messages = {};
        _this.populate = function (response) {
            var data = response;
            if (response.data) {
                data = response.data;
            }
            data = _this.utilityService.nvpToObject(data);
            var _loop_1 = function () {
                var propertyIdentifier = key.replace(_this.className.toLowerCase() + '.', '');
                var propertyIdentifierArray = propertyIdentifier.split('.');
                var propertyIdentifierKey = propertyIdentifier.replace(/\./g, '_');
                var currentEntity = _this;
                angular.forEach(propertyIdentifierArray, function (property, propertyKey) {
                    if (currentEntity.metaData[property]) {
                        //if we are on the last item in the array
                        if (propertyKey === propertyIdentifierArray.length - 1) {
                            //if is json
                            //if(currentEntity.metaData[key]){
                            //if propertyidentifier
                            // }else{
                            if (angular.isObject(data[key]) && currentEntity.metaData[property].fieldtype && currentEntity.metaData[property].fieldtype === 'many-to-one') {
                                var relatedEntity = _this.entityService.newEntity(currentEntity.metaData[property].cfc);
                                if (relatedEntity.populate) {
                                    relatedEntity.populate(data[key]);
                                    currentEntity['$$set' + currentEntity.metaData[property].name.charAt(0).toUpperCase() + currentEntity.metaData[property].name.slice(1)](relatedEntity);
                                }
                                else {
                                    relatedEntity.$$init(data[key]);
                                    currentEntity['$$set' + currentEntity.metaData[property].name.charAt(0).toUpperCase() + currentEntity.metaData[property].name.slice(1)](relatedEntity);
                                }
                            }
                            else if (angular.isArray(data[propertyIdentifierKey]) && currentEntity.metaData[property].fieldtype && (currentEntity.metaData[property].fieldtype === 'one-to-many')) {
                                currentEntity[property] = [];
                                angular.forEach(data[key], function (arrayItem, propertyKey) {
                                    var relatedEntity = _this.entityService.newEntity(currentEntity.metaData[property].cfc);
                                    if (relatedEntity.populate) {
                                        relatedEntity.populate(arrayItem);
                                        var hasItem = false;
                                        for (var item in currentEntity[property]) {
                                            if (currentEntity[property][item].$$getID().length > 0 && currentEntity[property][item].$$getID() === relatedEntity.$$getID()) {
                                                hasItem = true;
                                                break;
                                            }
                                        }
                                        if (!hasItem) {
                                            currentEntity['$$add' + currentEntity.metaData[property].singularname.charAt(0).toUpperCase() + currentEntity.metaData[property].singularname.slice(1)](relatedEntity);
                                        }
                                    }
                                    else {
                                        relatedEntity.$$init(arrayItem);
                                        currentEntity['$$add' + currentEntity.metaData[property].singularname.charAt(0).toUpperCase() + currentEntity.metaData[property].singularname.slice(1)](relatedEntity);
                                    }
                                });
                            }
                            else {
                                currentEntity[property] = data[key];
                            }
                            //}
                        }
                        else {
                            var propertyMetaData = currentEntity.metaData[property];
                            if (angular.isUndefined(currentEntity.data[property]) || (currentEntity.data[property] && currentEntity.data[property] === null)) {
                                if (propertyMetaData.fieldtype === 'one-to-many') {
                                    relatedEntity = [];
                                }
                                else {
                                    relatedEntity = _this.$hibachi['new' + propertyMetaData.cfc]();
                                }
                            }
                            else {
                                relatedEntity = currentEntity.data[property];
                            }
                            currentEntity['$$set' + propertyMetaData.name.charAt(0).toUpperCase() + propertyMetaData.name.slice(1)](relatedEntity);
                            currentEntity = relatedEntity;
                        }
                    }
                    else {
                        _this[key] = data[key];
                    }
                });
            };
            for (var key in data) {
                _loop_1();
            }
            if (response.errors) {
                _this.errors = response.errors;
                _this.messages = response.messages;
            }
        };
        _this.addError = function (errorName, errorMessage) {
            if (!_this.errors[errorName]) {
                _this.errors[errorName] = [];
            }
            if (angular.isArray(errorMessage)) {
                _this.addErrorsByArray(errorName, errorMessage);
            }
            else if (angular.isObject(errorMessage)) {
                _this.addErrorsByObject(errorName, errorMessage);
            }
            else {
                _this.errors[errorName].push(errorMessage);
            }
        };
        _this.addErrorsByArray = function (errorName, errorMessages) {
            for (var i = 0; i < errorMessages.length; i++) {
                var message = errorMessages[i];
                _this.errors[errorName].push(message);
            }
        };
        _this.addErrorsByObject = function (errorName, errorMessage) {
            if (!_this.errors[errorName]) {
                _this.errors[errorName] = [];
            }
            for (var key in errorMessage) {
                for (var i = 0; i < errorMessage[key].length; i++) {
                    var message = errorMessage[i];
                    _this.errors[errorName].push(message);
                }
            }
        };
        _this.addErrors = function (errors) {
            for (var key in errors) {
                if (!_this.errors[key]) {
                    _this.errors[key] = [];
                }
                for (var message in errors[key]) {
                    _this.errors[key].push(message);
                }
            }
        };
        _this.getError = function (errorName) {
            return _this.getErrorByErrorName(errorName);
        };
        _this.getErrorByErrorName = function (errorName) {
            return _this.errors[errorName];
        };
        _this.hasError = function (errorName) {
            return _this.hasErrorByErrorName(errorName);
        };
        _this.hasErrorByErrorName = function (errorName) {
            return angular.isDefined(_this.errors[errorName]);
        };
        _this.hasErrors = function () {
            return Object.keys(_this.errors).length;
        };
        _this.hasSuccessfulAction = function (action) {
            return;
        };
        _this.$hibachi = _this.getService('$hibachi');
        _this.hibachiValidationService = _this.getService('hibachiValidationService');
        _this.utilityService = _this.getService('utilityService');
        _this.entityService = _this.getService('entityService');
        return _this;
    }
    return BaseTransient;
}(baseobject_1.BaseObject));
exports.BaseTransient = BaseTransient;


/***/ }),

/***/ "zU/I":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../typings/tsd.d.ts' />
var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.Order_AddOrderPayment = void 0;
var baseprocess_1 = __webpack_require__("vvI4");
var Order_AddOrderPayment = /** @class */ (function (_super) {
    __extends(Order_AddOrderPayment, _super);
    function Order_AddOrderPayment($injector) {
        var _this = _super.call(this, $injector) || this;
        _this.$injector = $injector;
        return _this;
    }
    return Order_AddOrderPayment;
}(baseprocess_1.BaseProcess));
exports.Order_AddOrderPayment = Order_AddOrderPayment;


/***/ }),

/***/ "zg2S":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.BaseService = void 0;
var BaseService = /** @class */ (function () {
    function BaseService() {
    }
    return BaseService;
}());
exports.BaseService = BaseService;


/***/ }),

/***/ "zvf2":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWModalWindowController = exports.SWModalWindow = void 0;
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWModalWindowController = /** @class */ (function () {
    // @ngInject
    function SWModalWindowController() {
        var _this = this;
        this.$onInit = function () {
            _this.modalName = _this.swModalLauncher.modalName;
            _this.title = _this.swModalLauncher.title;
            _this.showExit = _this.swModalLauncher.showExit;
            _this.hasSaveAction = _this.swModalLauncher.hasSaveAction;
            _this.hasCancelAction = _this.swModalLauncher.hasCancelAction;
            _this.saveAction = _this.swModalLauncher.saveAction;
            _this.cancelAction = _this.swModalLauncher.cancelAction;
            _this.saveActionText = _this.swModalLauncher.saveActionText;
            _this.cancelActionText = _this.swModalLauncher.cancelActionText;
            if (angular.isUndefined(_this.modalName)) {
                throw ("You did not pass a modal title to SWModalWindowController");
            }
        };
    }
    return SWModalWindowController;
}());
exports.SWModalWindowController = SWModalWindowController;
var SWModalWindow = /** @class */ (function () {
    // @ngInject
    SWModalWindow.$inject = ["$compile"];
    function SWModalWindow($compile) {
        this.$compile = $compile;
        this.transclude = {
            modalBody: "?swModalBody"
        };
        this.restrict = "EA";
        this.require = {
            swModalLauncher: "^^swModalLauncher"
        };
        this.scope = {};
        this.bindToController = {
            modalName: "@",
            title: "@",
            showExit: "=?",
            saveDisabled: "=?",
            hasSaveAction: "=?",
            saveAction: "&?",
            hasDeleteAction: "=?",
            deleteAction: "&?",
            hasCancelAction: "=?",
            cancelAction: "&?",
            saveActionText: "@",
            cancelActionText: "@"
        };
        this.controller = SWModalWindowController;
        this.controllerAs = "swModalWindow";
        this.template = __webpack_require__("QJ37");
    }
    SWModalWindow.Factory = function () {
        var _this = this;
        return /** @ngInject; */ ["$compile", function ($compile) { return new _this($compile); }];
    };
    return SWModalWindow;
}());
exports.SWModalWindow = SWModalWindow;


/***/ })

}]);
//# sourceMappingURL=hibachiFrontend.8390b9505bd5747806e7.bundle.js.map