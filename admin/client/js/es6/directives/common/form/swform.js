/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    class swFormController {
        constructor(formService, ProcessObject, AccountFactory, CartFactory, $compile, $templateCache, $timeout, $rootScope, partialsPath, $http, $attrs, $element, $scope) {
            this.formService = formService;
            this.ProcessObject = ProcessObject;
            this.AccountFactory = AccountFactory;
            this.CartFactory = CartFactory;
            this.$compile = $compile;
            this.$templateCache = $templateCache;
            this.$timeout = $timeout;
            this.$rootScope = $rootScope;
            this.partialsPath = partialsPath;
            this.$http = $http;
            this.$attrs = $attrs;
            this.$element = $element;
            this.$scope = $scope;
            this.formService = formService;
            this.ProcessObject = ProcessObject;
            this.AccountFactory = AccountFactory;
            this.CartFactory = CartFactory;
            this.$compile = $compile;
            this.$templateCache = $templateCache;
            this.$timeout = $timeout;
            this.$rootScope = $rootScope;
            this.partialsPath = partialsPath;
            this.$http = $http;
            this.$attrs = $attrs;
            this.$element = $element;
            this.$scope = $scope;
            this.init();
        }
        init() {
            /** only use if the developer has specified these features with isProcessForm */
            if (this.$attrs.processObject && this.$attrs.isProcessForm == "true") {
                this.$scope.hiddenFields = this.$attrs.hiddenFields || [];
                this.$scope.entityName = this.$attrs.entityName || "Account";
                this.$scope.processObject = this.$attrs.processObject || "login";
                this.$scope.action = this.$attrs.action;
                this.$scope.actions = this.$attrs.actions || [];
                this.$scope.$timeout = this.$timeout;
                /** parse the name */
                var entityName = this.$attrs.processObject.split("_")[0];
                if (entityName == "Order") {
                    entityName = "Cart";
                }
                ;
                var processObject = this.$attrs.processObject.split("_")[1];
                /** check if this form should be hidden until another form submits successfully */
                this.$scope.hideUntilHandler = function () {
                    if (this.$attrs.hideUntil != undefined) {
                        var e = this.$element;
                        e.hide();
                    }
                }();
                /** find the form scope */
                this.$scope.$on('anchor', (event, data) => {
                    if (data.anchorType == "form" && data.scope !== undefined) {
                        this.$scope["formCtrl"] = data.scope;
                    }
                });
                /** set a listener for other success events and show hide this depending */
                this.$rootScope.$on("onSuccess", (event, data) => {
                    if (data.hide == this.$scope.processObject) {
                        this.$element.hide();
                    }
                    else if (data.show == this.$scope.processObject) {
                        this.$element.show();
                    }
                });
                /** make sure we have our data */
                if (processObject == undefined || entityName == undefined) {
                    throw ("ProcessObject Nameing Exception");
                }
                var processObj = this.ProcessObject.GetInstance();
                /** parse the response */
                processObj = processObj.$get({ processObject: processObject, entityName: entityName }).success(
                /** parse */
                function (response) {
                    processObj = response;
                    if (angular.isDefined(processObj.processObject) && processObj.processObject["PROPERTIES"]) {
                        processObj.processObject["meta"] = [];
                        for (var p in processObj.processObject["PROPERTIES"]) {
                            angular.forEach(processObj.processObject["entityMeta"], (n) => {
                                if (n["NAME"] == processObj.processObject["PROPERTIES"][p]["NAME"]) {
                                    processObj.processObject["meta"].push(n);
                                }
                            });
                        }
                        var processObjName = processObj.processObject["NAME"].split(".");
                        processObjName = processObjName[processObjName.length - 1];
                        processObj.processObject["NAME"] = processObjName;
                        return processObj.processObject;
                    }
                }).error(function () {
                    throw ("Endpoint does not exist exception");
                });
                /** We use these for our models */
                this.$scope.formData = {};
                this.$scope.getFormData = function () {
                    angular.forEach(this.$scope["formCtrl"][this.$scope.processObject], (val, key) => {
                        /** Check for form elements that have a name that doesn't start with $ */
                        if (key.toString().indexOf('$') == -1) {
                            this.formData[key] = val.$viewValue || val.$modelValue || val.$rawModelValue;
                        }
                    });
                    return this.$scope.formData || "";
                };
                /** Handle parsing through the server errors and injecting the error text for that field
                    *  If the form only has a submit, then simply call that function and set errors.
                    */
                this.$scope.parseErrors = function (result) {
                    if (angular.isDefined(result.errors) && result.errors.length != 0) {
                        angular.forEach(result.errors, (val, key) => {
                            if (angular.isDefined(this.$scope["formCtrl"][this.$scope.processObject][key])) {
                                var primaryElement = this.$element.find("[error-for='" + key + "']");
                                this.$timeout(function () {
                                    primaryElement.append("<span name='" + key + "Error'>" + result.errors[key] + "</span>");
                                }, 0);
                                this.$scope["formCtrl"][this.$scope.processObject][key].$setValidity(key, false); //set field invalid
                            }
                        }, this);
                    }
                };
                /** find and clear all errors on form */
                this.$scope.clearErrors = function () {
                    var errorElements = this.$element.find("[error-for]");
                    errorElements.empty();
                };
                /** sets the correct factory to use for submission */
                this.$scope.setFactoryIterator = (fn) => {
                    var account = this.AccountFactory.GetInstance();
                    var cart = this.CartFactory.GetInstance();
                    var factories = [account, cart];
                    var factoryFound = false;
                    for (var factory in factories) {
                        if (!factoryFound) {
                            angular.forEach(factories[factory], (val, key) => {
                                if (!factoryFound) {
                                    if (key == fn) {
                                        this.$scope.factoryIterator = factories[factory];
                                        factoryFound = true;
                                    }
                                }
                            });
                        }
                    }
                };
                this.$scope.formType = { 'Content-Type': 'application/x-www-form-urlencoded' };
                this.$scope.toFormParams = function (data) {
                    return data = $.param(data) || "";
                };
                /** iterates through the factory submitting data */
                this.$scope.iterateFactory = (submitFunction) => {
                    this.$scope.setFactoryIterator(submitFunction);
                    var factoryIterator = this.$scope.factoryIterator;
                    if (factoryIterator != undefined) {
                        var submitFn = factoryIterator[submitFunction];
                        submitFn({ params: this.$scope.toFormParams(this.$scope.formData), formType: this.$scope.formType }, this.$http).then(function (result) {
                            if (result.data.failureActions.length != 0) {
                                this.$scope.parseErrors(result.data);
                            }
                            else {
                                console.log("Successfully Posted Form");
                            }
                        }, angular.noop);
                    }
                    else {
                        throw ("Action does not exist in Account or Cart: " + this.$scope.action);
                    }
                };
                /** does either a single or multiple actions */
                this.$scope.doAction = (actionObject) => {
                    if (angular.isArray(actionObject)) {
                        for (var submitFunction in actionObject) {
                            this.$scope.iterateFactory(actionObject[submitFunction]);
                        }
                    }
                    else if (angular.isString(actionObject)) {
                        this.$scope.iterateFactory(actionObject);
                    }
                    else {
                        throw ("Unknown type of action exception");
                    }
                };
                /** search dom hiding any forms listed in a onSuccess method on startup */
                if (this.$attrs.onSuccess != undefined) {
                    this.$rootScope.$emit("onStart", { "show": this.$scope.processObject, "hide": this.$attrs.onSuccess });
                }
                /** create the generic submit function */
                this.$scope.submit = function () {
                    var action = this.$scope.action || this.$scope.actions;
                    this.$scope.clearErrors();
                    this.$scope.formData = this.$scope.getFormData() || "";
                    this.$scope.doAction(action);
                };
            }
        }
    }
    swFormController.$inject = ['formService', 'ProcessObject', 'AccountFactory', 'CartFactory',
        '$compile', '$templateCache', '$timeout', '$rootScope', 'partialsPath', '$http'];
    slatwalladmin.swFormController = swFormController;
    class swForm {
        constructor(formService, ProcessObject, AccountFactory, CartFactory, $compile, $templateCache, $timeout, $rootScope, partialsPath, $http) {
            this.formService = formService;
            this.ProcessObject = ProcessObject;
            this.AccountFactory = AccountFactory;
            this.CartFactory = CartFactory;
            this.$compile = $compile;
            this.$templateCache = $templateCache;
            this.$timeout = $timeout;
            this.$rootScope = $rootScope;
            this.partialsPath = partialsPath;
            this.$http = $http;
            this.restrict = "E";
            this.transclude = true;
            this.controllerAs = "ctrl";
            //public controller: () => new swFormController(formService, ProcessObject, AccountFactory, CartFactory, $compile, $templateCache, $timeout, $rootScope, partialsPath, $http, $attrs, $element, $scope);
            this.scope = {
                object: "=?",
                context: "@?",
                name: "@?",
                entityName: "@?",
                processObject: "@?",
                hiddenFields: "=?",
                action: "&?",
                actions: "@?",
                formClass: "@?",
                formData: "=?",
                onSuccess: "@?",
                hideUntil: "@?",
                isProcessForm: "@"
            };
            this.templateUrl = this.partialsPath + "formPartial.html";
            this.replace = true;
            this.link = (scope) => { scope.context = scope.context || 'save'; };
            this.formService = formService;
            this.ProcessObject = ProcessObject;
            this.AccountFactory = AccountFactory;
            this.CartFactory = CartFactory;
            this.$compile = $compile;
            this.$templateCache = $templateCache;
            this.$timeout = $timeout;
            this.$rootScope = $rootScope;
            this.partialsPath = partialsPath;
            this.$http = $http;
            return this.Get();
        }
        Get() {
            return {
                transclude: true,
                templateUrl: this.partialsPath + "formPartial.html",
                controllerAs: "ctrl",
                restrict: "E",
                replace: true,
                //controller: swFormController,
                scope: {
                    object: "=?",
                    context: "@?",
                    name: "@?",
                    entityName: "@?",
                    processObject: "@?",
                    hiddenFields: "=?",
                    action: "&?",
                    actions: "@?",
                    formClass: "@?",
                    formData: "=?",
                    onSuccess: "@?",
                    hideUntil: "@?",
                    isProcessForm: "@"
                },
                controller: ($scope, $element, $attrs) => {
                    /** only use if the developer has specified these features with isProcessForm */
                    if ($attrs.processObject && $attrs.isProcessForm == "true") {
                        $scope.hiddenFields = $attrs.hiddenFields || [];
                        $scope.entityName = $attrs.entityName || "Account";
                        $scope.processObject = $attrs.processObject || "login";
                        $scope.action = $attrs.action;
                        $scope.actions = $attrs.actions || [];
                        $scope.$timeout = this.$timeout;
                        /** parse the name */
                        var entityName = $attrs.processObject.split("_")[0];
                        if (entityName == "Order") {
                            entityName = "Cart";
                        }
                        ;
                        var processObject = $attrs.processObject.split("_")[1];
                        /** check if this form should be hidden until another form submits successfully */
                        $scope.hideUntilHandler = function () {
                            if ($attrs.hideUntil != undefined) {
                                var e = $element;
                                e.hide();
                            }
                        }();
                        /** find the form scope */
                        $scope.$on('anchor', (event, data) => {
                            if (data.anchorType == "form" && data.scope !== undefined) {
                                $scope["formCtrl"] = data.scope;
                            }
                        });
                        /** set a listener for other success events and show hide this depending */
                        this.$rootScope.$on("onSuccess", (event, data) => {
                            if (data.hide == $scope.processObject) {
                                $element.hide();
                            }
                            else if (data.show == $scope.processObject) {
                                $element.show();
                            }
                        });
                        /** make sure we have our data */
                        if (processObject == undefined || entityName == undefined) {
                            throw ("ProcessObject Nameing Exception");
                        }
                        var processObj = this.ProcessObject.GetInstance();
                        /** parse the response */
                        processObj = processObj.$get({ processObject: processObject, entityName: entityName }).success(
                        /** parse */
                        function (response) {
                            processObj = response;
                            if (angular.isDefined(processObj.processObject) && processObj.processObject["PROPERTIES"]) {
                                processObj.processObject["meta"] = [];
                                for (var p in processObj.processObject["PROPERTIES"]) {
                                    angular.forEach(processObj.processObject["entityMeta"], (n) => {
                                        if (n["NAME"] == processObj.processObject["PROPERTIES"][p]["NAME"]) {
                                            processObj.processObject["meta"].push(n);
                                        }
                                    });
                                }
                                var processObjName = processObj.processObject["NAME"].split(".");
                                processObjName = processObjName[processObjName.length - 1];
                                processObj.processObject["NAME"] = processObjName;
                                return processObj.processObject;
                            }
                        }).error(function () {
                            throw ("Endpoint does not exist exception");
                        });
                        /** We use these for our models */
                        $scope.formData = {};
                        $scope.getFormData = function () {
                            angular.forEach($scope["formCtrl"][$scope.processObject], (val, key) => {
                                /** Check for form elements that have a name that doesn't start with $ */
                                if (key.toString().indexOf('$') == -1) {
                                    this.formData[key] = val.$viewValue || val.$modelValue || val.$rawModelValue;
                                }
                            });
                            return $scope.formData || "";
                        };
                        /** Handle parsing through the server errors and injecting the error text for that field
                         *  If the form only has a submit, then simply call that function and set errors.
                         */
                        $scope.parseErrors = function (result) {
                            if (angular.isDefined(result.errors) && result.errors.length != 0) {
                                angular.forEach(result.errors, (val, key) => {
                                    if (angular.isDefined($scope["formCtrl"][$scope.processObject][key])) {
                                        var primaryElement = $element.find("[error-for='" + key + "']");
                                        this.$timeout(function () {
                                            primaryElement.append("<span name='" + key + "Error'>" + result.errors[key] + "</span>");
                                        }, 0);
                                        $scope["formCtrl"][$scope.processObject][key].$setValidity(key, false); //set field invalid
                                    }
                                }, this);
                            }
                        };
                        /** find and clear all errors on form */
                        $scope.clearErrors = function () {
                            var errorElements = $element.find("[error-for]");
                            errorElements.empty();
                        };
                        /** sets the correct factory to use for submission */
                        $scope.setFactoryIterator = (fn) => {
                            var account = this.AccountFactory.GetInstance();
                            var cart = this.CartFactory.GetInstance();
                            var factories = [account, cart];
                            var factoryFound = false;
                            for (var factory in factories) {
                                if (!factoryFound) {
                                    angular.forEach(factories[factory], (val, key) => {
                                        if (!factoryFound) {
                                            if (key == fn) {
                                                $scope.factoryIterator = factories[factory];
                                                factoryFound = true;
                                            }
                                        }
                                    });
                                }
                            }
                        };
                        $scope.formType = { 'Content-Type': 'application/x-www-form-urlencoded' };
                        $scope.toFormParams = function (data) {
                            return data = $.param(data) || "";
                        };
                        /** iterates through the factory submitting data */
                        $scope.iterateFactory = (submitFunction) => {
                            $scope.setFactoryIterator(submitFunction);
                            var factoryIterator = $scope.factoryIterator;
                            if (factoryIterator != undefined) {
                                var submitFn = factoryIterator[submitFunction];
                                submitFn({ params: $scope.toFormParams($scope.formData), formType: $scope.formType }, this.$http).then(function (result) {
                                    if (result.data.failureActions.length != 0) {
                                        $scope.parseErrors(result.data);
                                    }
                                    else {
                                        console.log("Successfully Posted Form");
                                    }
                                }, angular.noop);
                            }
                            else {
                                throw ("Action does not exist in Account or Cart: " + $scope.action);
                            }
                        };
                        /** does either a single or multiple actions */
                        $scope.doAction = (actionObject) => {
                            if (angular.isArray(actionObject)) {
                                for (var submitFunction in actionObject) {
                                    $scope.iterateFactory(actionObject[submitFunction]);
                                }
                            }
                            else if (angular.isString(actionObject)) {
                                $scope.iterateFactory(actionObject);
                            }
                            else {
                                throw ("Unknown type of action exception");
                            }
                        };
                        /** search dom hiding any forms listed in a onSuccess method on startup */
                        if ($attrs.onSuccess != undefined) {
                            this.$rootScope.$emit("onStart", { "show": $scope.processObject, "hide": $attrs.onSuccess });
                        }
                        /** create the generic submit function */
                        $scope.submit = function () {
                            var action = $scope.action || $scope.actions;
                            $scope.clearErrors();
                            $scope.formData = $scope.getFormData() || "";
                            $scope.doAction(action);
                        };
                    }
                }
            };
        }
    }
    swForm.$inject = ['formService', 'ProcessObject', 'AccountFactory', 'CartFactory',
        '$compile', '$templateCache', '$timeout', '$rootScope', 'partialsPath', '$http', '$attrs', '$element', '$scope'];
    slatwalladmin.swForm = swForm;
    angular.module('slatwalladmin').directive('swForm', ['formService', 'ProcessObject', 'AccountFactory', 'CartFactory',
        '$compile', '$templateCache', '$timeout', '$rootScope', 'partialsPath', '$http', (formService, ProcessObject, AccountFactory, CartFactory, $compile, $templateCache, $timeout, $rootScope, partialsPath, $http) => new swForm(formService, ProcessObject, AccountFactory, CartFactory, $compile, $templateCache, $timeout, $rootScope, partialsPath, $http)]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../../directives/common/form/swform.js.map