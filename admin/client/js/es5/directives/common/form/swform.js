/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    /**
     * Form Controller handles the logic for this directive.
     */
    var SWFormController = (function () {
        function SWFormController($scope, $element, $slatwall, AccountFactory, CartFactory, $http, $timeout, observerService) {
            this.$scope = $scope;
            this.$element = $element;
            this.$slatwall = $slatwall;
            this.AccountFactory = AccountFactory;
            this.CartFactory = CartFactory;
            this.$http = $http;
            this.$timeout = $timeout;
            this.observerService = observerService;
            /** only use if the developer has specified these features with isProcessForm */
            this.isProcessForm = this.isProcessForm || "false";
            if (this.isProcessForm == "true") {
                this.handleSelfInspection(this);
            }
        }
        /**
         * Iterates through the form elements and checks if the names of any of them match
         * the meta data that comes back from the processObject call. Supplies a generic submit
         * method that can be called by any subclasses that inject formCtrl. On submit,
         * this class will attach any errors to the correspnding form element.
         */
        SWFormController.prototype.handleSelfInspection = function (context) {
            var _this = this;
            /** local variables */
            this.processObject = this.object || "";
            var vm = context;
            vm.hiddenFields = this.hiddenFields;
            vm.entityName = this.entityName || "Account";
            vm.processObject = this.processObject;
            vm.action = this.action;
            vm.actions = this.actions;
            vm.$timeout = this.$timeout;
            vm.postOnly = false;
            var observerService = this.observerService;
            /** parse the name */
            var entityName = this.processObject.split("_")[0];
            var processObject = this.processObject.split("_")[1];
            /** try to grab the meta data from the process entity in slatwall in a process exists
             *  otherwise, just use the service method to access it.
             */
            /** Cart is an alias for an Order */
            if (entityName == "Order") {
                entityName = "Cart";
            }
            ;
            /** find the form scope */
            this.$scope.$on('anchor', function (event, data) {
                if (data.anchorType == "form" && data.scope !== undefined) {
                    vm["formCtrl"] = data.scope;
                }
            });
            /** make sure we have our data using new logic and $slatwall*/
            if (this.processObject == undefined || this.entityName == undefined) {
                throw ("ProcessObject Undefined Exception");
            }
            try {
                vm.actionFn = this.$slatwall.newEntity(vm.processObject);
            }
            catch (e) {
                vm.postOnly = true;
            }
            /** We use these for our models */
            vm.formData = {};
            /** returns all the data from the form by iterating the form elements */
            vm.getFormData = function () {
                var _this = this;
                angular.forEach(vm["formCtrl"][vm.processObject], function (val, key) {
                    /** Check for form elements that have a name that doesn't start with $ */
                    if (key.toString().indexOf('$') == -1) {
                        _this.formData[key] = val.$viewValue || val.$modelValue || val.$rawModelValue;
                    }
                });
                return vm.formData || "";
            };
            /****
              * Handle parsing through the server errors and injecting the error text for that field
              * If the form only has a submit, then simply call that function and set errors.
              ***/
            vm.parseErrors = function (result) {
                var _this = this;
                if (angular.isDefined(result.errors) && result.errors.length != 0) {
                    angular.forEach(result.errors, function (val, key) {
                        if (angular.isDefined(vm["formCtrl"][vm.processObject][key])) {
                            var primaryElement = _this.$element.find("[error-for='" + key + "']");
                            vm.$timeout(function () {
                                primaryElement.append("<span name='" + key + "Error'>" + result.errors[key] + "</span>");
                            }, 0);
                            vm["formCtrl"][vm.processObject][key].$setValidity(key, false); //set field invalid
                        }
                    }, this);
                }
            };
            vm.eventsObj = [];
            /** looks at the onSuccess, onError, and onLoading and parses the string into useful subcategories */
            vm.parseEventString = function (evntStr, evntType) {
                vm.events = vm.parseEvents(evntStr, evntType); //onSuccess : [hide:this, show:someOtherForm, refresh:Account]
            };
            vm.eventsHandler = function (params) {
                for (var e in params.events) {
                    if (angular.isDefined(params.events[e].value) && params.events[e].value == vm.processObject.toLowerCase()) {
                        if (params.events[e].name == "hide") {
                            vm.hide(params.events[e].value);
                        }
                        if (params.events[e].name == "show") {
                            vm.show(params.events[e].value);
                        }
                        if (params.events[e].name == "update") {
                            vm.update(params.events[e].value);
                        }
                        if (params.events[e].name == "refresh") {
                            vm.refresh(params.events[e].value);
                        }
                        ;
                    }
                }
            };
            /** hides this directive on event */
            vm.hide = function (param) {
                if (vm.processObject.toLowerCase() == param) {
                    _this.$element.hide();
                }
            };
            /** shows this directive on event */
            vm.show = function (param) {
                if (vm.processObject.toLowerCase() == param) {
                    _this.$element.show();
                }
            };
            /** refreshes this directive on event */
            vm.refresh = function (params) {
                //stub
            };
            /** updates this directive on event */
            vm.update = function (params) {
                //stub
            };
            vm.parseEvents = function (str, evntType) {
                if (str == undefined)
                    return;
                var strTokens = str.split(","); //this gives the format [hide:this, show:Account_Logout, update:Account or Cart]
                var eventsObj = {
                    "events": []
                }; //will hold events
                for (var token in strTokens) {
                    var t = strTokens[token].split(":")[0].toLowerCase().replace(' ', '');
                    var u = strTokens[token].split(":")[1].toLowerCase().replace(' ', '');
                    if (t == "show" || t == "hide" || t == "refresh" || t == "update") {
                        if (u == "this") {
                            u == vm.processObject.toLowerCase();
                        } //<--replaces the alias this with the name of this form.
                        var event_1 = { "name": t, "value": u };
                        eventsObj.events.push(event_1);
                    }
                }
                if (eventsObj.events.length) {
                    observerService.attach(vm.eventsHandler, "onSuccess");
                }
                return eventsObj;
            };
            /** find and clear all errors on form */
            vm.clearErrors = function () {
                var errorElements = _this.$element.find("[error-for]");
                errorElements.empty();
            };
            /** sets the correct factory to use for submission */
            vm.setFactoryIterator = function (fn) {
                var account = _this.AccountFactory.GetInstance();
                var cart = _this.CartFactory.GetInstance();
                var factories = [account, cart];
                var factoryFound = false;
                for (var _i = 0; _i < factories.length; _i++) {
                    var factory = factories[_i];
                    if (!factoryFound) {
                        angular.forEach(factory, function (val, key) {
                            if (!factoryFound) {
                                if (key == fn) {
                                    vm.factoryIterator = factory;
                                    factoryFound = true;
                                }
                            }
                        });
                    }
                }
            };
            /** sets the type of the form to submit */
            vm.formType = { 'Content-Type': 'application/x-www-form-urlencoded' };
            vm.toFormParams = function (data) {
                return data = $.param(data) || "";
            };
            /** iterates through the factory submitting data */
            vm.iterateFactory = function (submitFunction) {
                vm.setFactoryIterator(submitFunction);
                var factoryIterator = vm.factoryIterator;
                if (factoryIterator != undefined) {
                    var submitFn = factoryIterator[submitFunction];
                    vm.formData = vm.formData || {};
                    submitFn({ params: vm.toFormParams(vm.formData), formType: vm.formType }).then(function (result) {
                        if (result.data && result.data.failureActions && result.data.failureActions.length != 0) {
                            vm.parseErrors(result.data);
                            observerService.notify("onError", { "caller": _this.processObject, "events": vm.events.events });
                        }
                        else {
                            observerService.notify("onSuccess", { "caller": _this.processObject, "events": vm.events.events });
                        }
                    }, angular.noop);
                }
                else {
                    throw ("Action does not exist in Account or Cart Exception  *" + vm.action);
                }
            };
            /** does either a single or multiple actions */
            vm.doAction = function (actionObject) {
                if (angular.isArray(actionObject)) {
                    for (var _i = 0; _i < actionObject.length; _i++) {
                        var submitFunction = actionObject[_i];
                        vm.iterateFactory(submitFunction);
                    }
                }
                else if (angular.isString(actionObject)) {
                    vm.iterateFactory(actionObject);
                }
                else {
                    throw ("Unknown type of action exception");
                }
            };
            /** create the generic submit function */
            vm.submit = function (Action) {
                var action = Action; //vm.action || vm.actions;
                vm.clearErrors();
                vm.formData = vm.getFormData() || "";
                vm.doAction(action);
            };
            /* give children access to the process
            */
            vm.getProcessObject = function () {
                return vm.processEntity;
            };
            /* handle events
            */
            if (this.onSuccess != undefined) {
                vm.parseEventString(this.onSuccess, "onSuccess");
                observerService.attach(vm.eventsHandler, "onSuccess");
            }
            else if (this.onError != undefined) {
                vm.parseEventString(this.onError, "onError");
            }
        };
        /**
         * This controller handles most of the logic for the swFormDirective when more complicated self inspection is needed.
         */
        SWFormController.$inject = ['$scope', '$element', '$slatwall', 'AccountFactory', 'CartFactory', '$http', '$timeout', 'observerService'];
        return SWFormController;
    })();
    slatwalladmin.SWFormController = SWFormController;
    var SWForm = (function () {
        function SWForm(partialsPath, $http, $timeout, observerService) {
            this.partialsPath = partialsPath;
            this.templateUrl = "";
            this.transclude = true;
            this.restrict = "E";
            this.replace = true;
            this.controller = SWFormController;
            this.controllerAs = "swFormController";
            this.scope = {
                object: "=",
                context: "@",
                name: "@"
            };
            /**
             * Binds all of our variables to the controller so we can access using this
             */
            this.bindToController = {
                entityName: "@?",
                processObject: "@?",
                hiddenFields: "=?",
                action: "@?",
                actions: "@?",
                formClass: "@?",
                formData: "=?",
                object: "@?",
                onSuccess: "@?",
                onError: "@?",
                hideUntil: "@?",
                isProcessForm: "@"
            };
            /**
             * Sets the context of this form
             */
            this.link = function (scope, element, attrs, controller, transclude) {
                scope.context = scope.context || 'save';
            };
            this.templateUrl = this.partialsPath + "formPartial.html";
        }
        /**
         * Handles injecting the partials path into this class
         */
        SWForm.$inject = ['partialsPath', '$http', '$timeout', 'observerService'];
        return SWForm;
    })();
    slatwalladmin.SWForm = SWForm;
    /**
     * Handles registering the swForm directive with its module as well as injecting dependancies in a minification safe way.
     */
    angular.module('slatwalladmin').directive('swForm', ['partialsPath', '$http', 'observerService', function (partialsPath, $http, $timeout, observerService) { return new SWForm(partialsPath, $http, $timeout, observerService); }]);
})(slatwalladmin || (slatwalladmin = {})); //<--end module

//# sourceMappingURL=../../../directives/common/form/swform.js.map