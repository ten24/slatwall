/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    var AccountHandler = (function () {
        function AccountHandler($http) {
            var _this = this;
            this.contentType = { 'Content-Type': 'application/x-www-form-urlencoded' };
            this.baseEndPoint = "/index.cfm/api/scope/";
            this.http = null;
            this.actionMethods = new Array();
            this.getContentType = function () {
                return _this.contentType;
            };
            this.getEndPoint = function () {
                return _this.baseEndPoint;
            };
            this.setEndPoint = function (endPoint) {
                _this.baseEndPoint = endPoint;
            };
            this.doAction = function (action, params) {
                if (_this.actionExists(action)) {
                    _this.http.post(_this.baseEndPoint + action, params, { headers: _this.contentType })
                        .success(function (response) {
                        this.responseHandler(response);
                    })
                        .error(function (response) {
                        this.responseHandler(response);
                    });
                }
            };
            this.getAllActionMethods = function () {
                return _this.actionMethods;
            };
            this.actionExists = function (action) {
                for (var method in _this.actionMethods) {
                    if (method.name = action) {
                        return true;
                    }
                }
                return false;
            };
            this.responseHandler = function () { }; //defer to the developer using this AccountHandler
            this.http = $http;
        }
        return AccountHandler;
    })();
    slatwalladmin.AccountHandler = AccountHandler;
    var swFormController = (function () {
        function swFormController() {
            //stub
        }
        return swFormController;
    })();
    slatwalladmin.swFormController = swFormController;
    var swForm = (function () {
        function swForm(formService, ProcessObject, AccountFactory, CartFactory, $compile, $templateCache, $timeout, $rootScope, partialsPath, $http) {
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
            /*public restrict = "E";
            public transclude = true;
            public controllerAs = "ctrl";
            public scope = {
                    object:"=?",
                    context:"@?",
                    name:"@?",
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
                  };*/
            //templateUrl = this.partialsPath + "formPartial.html";
            //replace = true;
            this.link = function (scope) { scope.context = scope.context || 'save'; };
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
        swForm.prototype.Get = function () {
            var _this = this;
            return {
                //this config needs to be rewritten as public fields on this class
                transclude: true,
                templateUrl: this.partialsPath + "formPartial.html",
                controllerAs: "ctrl",
                restrict: "E",
                replace: true,
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
                //needs to be refactored into standalone contorller class
                controller: function ($scope, $element, $attrs) {
                    /** only use if the developer has specified these features with isProcessForm */
                    if (!$attrs.processObject || $attrs.isProcessForm != "true") {
                        return false;
                    }
                    $scope.hiddenFields = $attrs.hiddenFields || [];
                    $scope.entityName = $attrs.entityName || "Account";
                    $scope.processObject = $attrs.processObject || "login";
                    $scope.action = $attrs.action;
                    $scope.actions = $attrs.actions || [];
                    $scope.$timeout = _this.$timeout;
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
                    $scope.$on('anchor', function (event, data) {
                        if (data.anchorType == "form" && data.scope !== undefined) {
                            $scope["formCtrl"] = data.scope;
                        }
                    });
                    /** set a listener for other success events and show hide this depending */
                    _this.$rootScope.$on("onSuccess", function (event, data) {
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
                    var processObj = _this.ProcessObject.GetInstance();
                    /** parse the response */
                    processObj = processObj.$get({ processObject: processObject, entityName: entityName }).success(
                    /** parse */
                    function (response) {
                        $scope.parseProcessObjectResponse(response);
                    }).error(function () {
                        throw ("Endpoint does not exist exception");
                    });
                    /** handles the process object structure */
                    $scope.parseProcessObjectResponse = function (response) {
                        processObj = response;
                        if (angular.isDefined(processObj.processObject) && processObj.processObject["PROPERTIES"]) {
                            processObj.processObject["meta"] = [];
                            for (var p in processObj.processObject["PROPERTIES"]) {
                                angular.forEach(processObj.processObject["entityMeta"], function (n) {
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
                    };
                    /** We use these for our models */
                    $scope.formData = {};
                    $scope.getFormData = function () {
                        var _this = this;
                        angular.forEach($scope["formCtrl"][$scope.processObject], function (val, key) {
                            /** Check for form elements that have a name that doesn't start with $ */
                            if (key.toString().indexOf('$') == -1) {
                                _this.formData[key] = val.$viewValue || val.$modelValue || val.$rawModelValue;
                            }
                        });
                        return $scope.formData || "";
                    };
                    /** Handle parsing through the server errors and injecting the error text for that field
                     *  If the form only has a submit, then simply call that function and set errors.
                     */
                    $scope.parseErrors = function (result) {
                        var _this = this;
                        if (angular.isDefined(result.errors) && result.errors.length != 0) {
                            angular.forEach(result.errors, function (val, key) {
                                if (angular.isDefined($scope["formCtrl"][$scope.processObject][key])) {
                                    var primaryElement = $element.find("[error-for='" + key + "']");
                                    _this.$timeout(function () {
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
                    $scope.setFactoryIterator = function (fn) {
                        var account = _this.AccountFactory.GetInstance();
                        var cart = _this.CartFactory.GetInstance();
                        var factories = [account, cart];
                        var factoryFound = false;
                        for (var factory in factories) {
                            if (!factoryFound) {
                                angular.forEach(factories[factory], function (val, key) {
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
                    $scope.iterateFactory = function (submitFunction) {
                        $scope.setFactoryIterator(submitFunction);
                        var factoryIterator = $scope.factoryIterator;
                        if (factoryIterator != undefined) {
                            var submitFn = factoryIterator[submitFunction];
                            submitFn({ params: $scope.toFormParams($scope.formData), formType: $scope.formType }, _this.$http).then(function (result) {
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
                    $scope.doAction = function (actionObject) {
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
                        _this.$rootScope.$emit("onStart", { "show": $scope.processObject, "hide": $attrs.onSuccess });
                    }
                    /** create the generic submit function */
                    $scope.submit = function () {
                        var action = $scope.action || $scope.actions;
                        $scope.clearErrors();
                        $scope.formData = $scope.getFormData() || "";
                        $scope.doAction(action);
                    };
                }
            };
        };
        swForm.$inject = ['formService', 'ProcessObject', 'AccountFactory', 'CartFactory',
            '$compile', '$templateCache', '$timeout', '$rootScope', 'partialsPath', '$http'];
        return swForm;
    })();
    slatwalladmin.swForm = swForm;
    angular.module('slatwalladmin').directive('swForm', ['formService', 'ProcessObject', 'AccountFactory', 'CartFactory',
        '$compile', '$templateCache', '$timeout', '$rootScope', 'partialsPath', '$http', function (formService, ProcessObject, AccountFactory, CartFactory, $compile, $templateCache, $timeout, $rootScope, partialsPath, $http) { return new swForm(formService, ProcessObject, AccountFactory, CartFactory, $compile, $templateCache, $timeout, $rootScope, partialsPath, $http); }]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../../directives/common/form/swform.js.map