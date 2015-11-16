/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    /**
     * Form Controller handles the logic for this directive.
     */
    class SWFormController {
        constructor($scope, $element, $slatwall, AccountFactory, CartFactory, ProcessObject, $http, $timeout) {
            /** only use if the developer has specified these features with isProcessForm */
            this.$scope = $scope;
            this.$element = $element;
            this.$slatwall = $slatwall;
            this.AccountFactory = AccountFactory;
            this.CartFactory = CartFactory;
            this.ProcessObject = ProcessObject;
            this.$http = $http;
            this.$timeout = $timeout;
            this.isProcessForm = this.isProcessForm || "false";
            if (this.isProcessForm == "true") {
                console.log("Handling a process form");
                this.handleSelfInspection(this);
            }
        }
        /**
         * Iterates through the form elements and checks if the names of any of them match
         * the meta data that comes back from the processObject call. Supplies a generic submit
         * method that can be called by any subclasses that inject formCtrl. On submit,
         * this class will attach any errors to the correspnding form element.
         */
        handleSelfInspection(context) {
            /** local variables */
            let vm = context;
            vm.hiddenFields = this.hiddenFields || [];
            vm.entityName = this.entityName || "Account";
            vm.processObject = this.processObject;
            vm.action = this.action || "$login";
            vm.actions = this.actions || [];
            vm.$timeout = this.$timeout;
            /** parse the name */
            let entityName = this.processObject.split("_")[0];
            let processObject = this.processObject.split("_")[1];
            /** try to grab the meta data from the process entity in slatwall in a process exists
             *  otherwise, just use the service method to access it.
             */
            /*try {
                vm.processObjectMeta = $slatwall.newEntity( this.processObject );
            }catch( e ){
                vm.processObjectMeta = {"methodType" : "methodOnly"};
            }*/
            //console.log(vm.processObjectMeta);
            /** Cart is an alias for an Order */
            if (entityName == "Order") {
                entityName = "Cart";
            }
            ;
            /** find the form scope */
            this.$scope.$on('anchor', (event, data) => {
                if (data.anchorType == "form" && data.scope !== undefined) {
                    vm["formCtrl"] = data.scope;
                }
            });
            /** make sure we have our data */
            if (this.processObject == undefined || this.entityName == undefined) {
                throw ("ProcessObject Exception");
            }
            let processObj = this.ProcessObject.GetInstance();
            /** parse the response */
            processObj = processObj.$get({ processObject: this.processObject, entityName: this.entityName }).success(
            /** parse */
            function (response) {
                vm.parseProcessObjectResponse(response);
            }).error(function () {
                throw ("Endpoint does not exist exception");
            });
            /** handles the process object structure */
            vm.parseProcessObjectResponse = (response) => {
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
                    let processObjName = processObj.processObject["NAME"].split(".");
                    processObjName = processObjName[processObjName.length - 1];
                    processObj.processObject["NAME"] = processObjName;
                    return processObj.processObject;
                }
            };
            /** We use these for our models */
            vm.formData = {};
            /** returns all the data from the form by iterating the form elements */
            vm.getFormData = function () {
                angular.forEach(vm["formCtrl"][vm.processObject], (val, key) => {
                    /** Check for form elements that have a name that doesn't start with $ */
                    if (key.toString().indexOf('$') == -1) {
                        this.formData[key] = val.$viewValue || val.$modelValue || val.$rawModelValue;
                    }
                });
                return vm.formData || "";
            };
            /****
              * Handle parsing through the server errors and injecting the error text for that field
              * If the form only has a submit, then simply call that function and set errors.
              ***/
            vm.parseErrors = function (result) {
                if (angular.isDefined(result.errors) && result.errors.length != 0) {
                    angular.forEach(result.errors, (val, key) => {
                        if (angular.isDefined(vm["formCtrl"][vm.processObject][key])) {
                            let primaryElement = this.$element.find("[error-for='" + key + "']");
                            vm.$timeout(function () {
                                primaryElement.append("<span name='" + key + "Error'>" + result.errors[key] + "</span>");
                            }, 0);
                            vm["formCtrl"][vm.processObject][key].$setValidity(key, false); //set field invalid
                        }
                    }, this);
                }
            };
            /** find and clear all errors on form */
            vm.clearErrors = () => {
                let errorElements = this.$element.find("[error-for]");
                errorElements.empty();
            };
            /** sets the correct factory to use for submission */
            vm.setFactoryIterator = (fn) => {
                let account = this.AccountFactory.GetInstance();
                let cart = this.CartFactory.GetInstance();
                let factories = [account, cart];
                let factoryFound = false;
                for (var factory of factories) {
                    if (!factoryFound) {
                        angular.forEach(factory, (val, key) => {
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
            vm.toFormParams = (data) => {
                return data = $.param(data) || "";
            };
            /** iterates through the factory submitting data */
            vm.iterateFactory = (submitFunction) => {
                vm.setFactoryIterator(submitFunction);
                let factoryIterator = vm.factoryIterator;
                if (factoryIterator != undefined) {
                    let submitFn = factoryIterator[submitFunction];
                    submitFn({ params: vm.toFormParams(vm.formData), formType: vm.formType }).then(function (result) {
                        if (result.data.failureActions.length != 0) {
                            vm.parseErrors(result.data);
                        }
                        else {
                            console.log("Successfully Posted Form");
                        }
                    }, angular.noop);
                }
                else {
                    throw ("Action does not exist in Account or Cart: " + vm.action);
                }
            };
            /** does either a single or multiple actions */
            vm.doAction = (actionObject) => {
                if (angular.isArray(actionObject)) {
                    for (var submitFunction of actionObject) {
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
            vm.submit = () => {
                let action = vm.action || vm.actions;
                vm.clearErrors();
                vm.formData = vm.getFormData() || "";
                vm.doAction(action);
            };
            /** give children access to the process */
            vm.getProcessObject = () => {
                return vm.processEntity;
            };
        }
    }
    /**
     * This controller handles most of the logic for the swFormDirective when more complicated self inspection is needed.
     */
    SWFormController.$inject = ['$scope', '$element', '$slatwall', 'AccountFactory', 'CartFactory', 'ProcessObject', '$http', '$timeout'];
    slatwalladmin.SWFormController = SWFormController;
    class SWForm {
        constructor(partialsPath, $http, $timeout) {
            this.partialsPath = partialsPath;
            this.templateUrl = "";
            this.transclude = true;
            this.restrict = "E";
            this.replace = true;
            this.controller = SWFormController;
            this.controllerAs = "swFormController";
            this.scope = {};
            /**
             * Binds all of our variables to the controller so we can access using this
             */
            this.bindToController = {
                object: "=?",
                context: "@?",
                name: "@?",
                entityName: "@?",
                processObject: "@?",
                hiddenFields: "=?",
                action: "@?",
                actions: "@?",
                formClass: "@?",
                formData: "=?",
                onSuccess: "@?",
                hideUntil: "@?",
                isProcessForm: "@"
            };
            /**
             * Sets the context of this form
             */
            this.link = (scope, element, attrs, controller, transclude) => {
                scope.context = scope.context || 'save';
            };
            this.templateUrl = this.partialsPath + "formPartial.html";
        }
    }
    /**
     * Handles injecting the partials path into this class
     */
    SWForm.$inject = ['partialsPath', '$http', '$timeout'];
    slatwalladmin.SWForm = SWForm;
    /**
     * Handles registering the swForm directive with its module as well as injecting dependancies in a minification safe way.
     */
    angular.module('slatwalladmin').directive('swForm', ['partialsPath', '$http', (partialsPath, $http, $timeout) => new SWForm(partialsPath, $http, $timeout)]);
})(slatwalladmin || (slatwalladmin = {})); //<--end module

//# sourceMappingURL=../../../directives/common/form/swform.js.map