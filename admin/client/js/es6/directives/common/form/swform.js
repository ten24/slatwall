/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    /**
     * Form Controller handles the logic for this directive.
     */
    class SWFormController {
        constructor($scope, $element, $slatwall) {
            this.$scope = $scope;
            this.$element = $element;
            this.$slatwall = $slatwall;
            /** only use if the developer has specified these features with isProcessForm */
            //if (!$attrs.processObject || $attrs.isProcessForm != "true") { return false }
            console.log("Calling Init Method");
            this.init();
        }
        init() {
            let $scope = this;
            console.log("View this and scope", this, $scope);
            $scope.hiddenFields = $attrs.hiddenFields || [];
            $scope.entityName = $attrs.entityName || "Account";
            $scope.processObject = $attrs.processObject || "login";
            $scope.action = $attrs.action;
            $scope.actions = $attrs.actions || [];
            $scope.$timeout = this.$timeout;
            /** parse the name */
            let entityName = $attrs.processObject.split("_")[0];
            if (entityName == "Order") {
                entityName = "Cart";
            }
            ;
            let processObject = $attrs.processObject.split("_")[1];
            /** check if this form should be hidden until another form submits successfully */
            $scope.hideUntilHandler = function () {
                if ($attrs.hideUntil != undefined) {
                    let e = $element;
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
            //slatwall.newEntity(processObject)
            var processObj = this.ProcessObject.GetInstance();
            /** parse the response */
            processObj = processObj.$get({ processObject: processObject, entityName: entityName }).success(
            /** parse */
            function (response) {
                $scope.parseProcessObjectResponse(response);
            }).error(function () {
                throw ("Endpoint does not exist exception");
            });
            /** handles the process object structure */
            $scope.parseProcessObjectResponse = (response) => {
                processObj = response;
                if (angular.isDefined(processObj.processObject) && processObj.processObject["PROPERTIES"]) {
                    processObj.processObject["meta"] = [];
                    for (var p of processObj.processObject["PROPERTIES"]) {
                        angular.forEach(processObj.processObject["entityMeta"], (n) => {
                            if (n["NAME"] == p["NAME"]) {
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
                            let primaryElement = $element.find("[error-for='" + key + "']");
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
                let errorElements = $element.find("[error-for]");
                errorElements.empty();
            };
            /** sets the correct factory to use for submission */
            $scope.setFactoryIterator = (fn) => {
                let account = this.AccountFactory.GetInstance();
                let cart = this.CartFactory.GetInstance();
                let factories = [account, cart];
                let factoryFound = false;
                for (var factory of factories) {
                    if (!factoryFound) {
                        angular.forEach(factory, (val, key) => {
                            if (!factoryFound) {
                                if (key == fn) {
                                    $scope.factoryIterator = factory;
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
                    for (var submitFunction of actionObject) {
                        $scope.iterateFactory(submitFunction);
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
                let action = $scope.action || $scope.actions;
                $scope.clearErrors();
                $scope.formData = $scope.getFormData() || "";
                $scope.doAction(action);
            };
        }
    }
    SWFormController.$inject = ['$scope', '$element', '$slatwall'];
    slatwalladmin.SWFormController = SWFormController; //<--end class controller
    class SWForm {
        constructor(partialsPath) {
            this.partialsPath = partialsPath;
            this.templateUrl = "";
            this.transclude = true;
            this.restrict = "E";
            this.replace = true;
            this.controller = SWFormController;
            this.controllerAs = "swFormController";
            this.scope = {};
            this.bindToController = {
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
            this.link = (scope, element, attrs, controller, transclude) => {
                scope.context = scope.context || 'save';
            };
            this.templateUrl = this.partialsPath + "formPartial.html";
        }
    }
    /**
     *
     */
    SWForm.$inject = ['partialsPath'];
    slatwalladmin.SWForm = SWForm;
    /**
     * Handles registering the swForm directive with its module as well as injecting dependancies in a minification safe way.
     */
    angular.module('slatwalladmin').directive('swForm', ['partialsPath', (partialsPath) => new SWForm(partialsPath)]);
})(slatwalladmin || (slatwalladmin = {})); //<--end module

//# sourceMappingURL=../../../directives/common/form/swform.js.map