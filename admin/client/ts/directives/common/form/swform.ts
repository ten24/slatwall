/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
module slatwalladmin {

    interface IResponseHandler {
        parseResponse(response:{}):{};
        handleError();
        handleSuccess();
        displayErrors();
        displaySuccess();
    }
    
    interface IApiHandler {
        contentType: {};
        getContentType():{};
        baseEndPoint: string;
        getEndPoint(): string;
        setEndPoint(endPoint: string);
        actionMethods: Array<string>;
        http: ng.IHttpService;
        doAction(action:string, params:{}): void;
        getAllActionMethods():{};
        actionExists(action):boolean;
        responseHandler(errorHandler:IResponseHandler);
    }
    
    export class AccountHandler implements IApiHandler {
        contentType = {'Content-Type': 'application/x-www-form-urlencoded'};
        baseEndPoint = "/index.cfm/api/scope/";
        http = null;
        actionMethods = new Array();
        getContentType = () =>{
            return this.contentType;
        }
        getEndPoint = () =>{
            return this.baseEndPoint;
        }
        setEndPoint = (endPoint) =>{
            this.baseEndPoint = endPoint;
        }
        doAction = (action:string, params:{}) => {
            if (this.actionExists(action)){
                this.http.post(this.baseEndPoint + action, params, {headers: this.contentType} )
                .success(function(response){
                    this.responseHandler(response)   
                })
                .error(function(response){
                    this.responseHandler(response)   
                });
            }
        }
        getAllActionMethods = () =>{
            return this.actionMethods;
        }
        actionExists = (action) => {
            for (var method in this.actionMethods){
                if (method.name = action){
                    return true;
                }
            }
            return false;
        }
        responseHandler = () => {}; //defer to the developer using this AccountHandler
        constructor($http:ng.IHttpService){this.http = $http;}
    }
    export class swFormController {
        constructor(){
            //stub
        }
    }
    export class swForm implements ng.IDirective {
        public static $inject = ['formService', 'ProcessObject', 'AccountFactory', 'CartFactory',
            '$compile', '$templateCache', '$timeout', '$rootScope', 'partialsPath', '$http'];
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
        link = (scope) => { scope.context = scope.context || 'save'; };

        constructor(public formService, public ProcessObject, public AccountFactory, public CartFactory, public $compile, public $templateCache, public $timeout, public $rootScope, public partialsPath, public $http) {
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

        Get(): any {
            return {
                //this config needs to be rewritten as public fields on this class
                transclude: true,
                templateUrl: this.partialsPath + "formPartial.html",
                controllerAs: "ctrl",
                restrict: "E",
                replace: true,
                scope: {//needs to bindToController
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
                controller: ($scope, $element, $attrs) => { 
                   
                    /** only use if the developer has specified these features with isProcessForm */
                    if (!$attrs.processObject || $attrs.isProcessForm != "true") { return false }

                    $scope.hiddenFields = $attrs.hiddenFields || [];
                    $scope.entityName = $attrs.entityName || "Account";
                    $scope.processObject = $attrs.processObject || "login";
                    $scope.action = $attrs.action;
                    $scope.actions = $attrs.actions || [];
                    $scope.$timeout = this.$timeout;
                    
                    /** parse the name */
                    var entityName = $attrs.processObject.split("_")[0];
                    if (entityName == "Order") { entityName = "Cart" };
                    var processObject = $attrs.processObject.split("_")[1];
                    
                    /** check if this form should be hidden until another form submits successfully */
                    $scope.hideUntilHandler = function() {
                        if ($attrs.hideUntil != undefined) {
                            var e = $element;
                            e.hide();
                        }
                    } ()
                    
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
                        } else if (data.show == $scope.processObject) {
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
                        function(response) {
                            $scope.parseProcessObjectResponse(response);
                        }
                    ).error(function() {
                        throw ("Endpoint does not exist exception");
                    });
                    
                    /** handles the process object structure */
                    $scope.parseProcessObjectResponse = (response) => {
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
                    }
                    
                    /** We use these for our models */
                    $scope.formData = {};
                    $scope.getFormData = function() {
                        angular.forEach($scope["formCtrl"][$scope.processObject], (val, key) => {
                            /** Check for form elements that have a name that doesn't start with $ */
                            if (key.toString().indexOf('$') == -1) {
                                this.formData[key] = val.$viewValue || val.$modelValue || val.$rawModelValue;
                            }
                        });

                        return $scope.formData || "";
                    }
                    
                    /** Handle parsing through the server errors and injecting the error text for that field
                     *  If the form only has a submit, then simply call that function and set errors.
                     */
                    $scope.parseErrors = function(result) {
                        if (angular.isDefined(result.errors) && result.errors.length != 0) {
                            angular.forEach(result.errors, (val, key) => {
                                if (angular.isDefined($scope["formCtrl"][$scope.processObject][key])) {
                                    var primaryElement = $element.find("[error-for='" + key + "']");
                                    this.$timeout(function() {
                                        primaryElement.append("<span name='" + key + "Error'>" + result.errors[key] + "</span>");
                                    }, 0);
                                    $scope["formCtrl"][$scope.processObject][key].$setValidity(key, false);//set field invalid
                                }
                            }, this);
                        }
                    };
                    
                    /** find and clear all errors on form */
                    $scope.clearErrors = function() {
                        var errorElements = $element.find("[error-for]");
                        errorElements.empty();
                    }
                    
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
                                })
                            }
                        }
                    }
                    $scope.formType = { 'Content-Type': 'application/x-www-form-urlencoded' };
                    $scope.toFormParams = function(data) {
                        return data = $.param(data) || "";
                    }
                    /** iterates through the factory submitting data */
                    $scope.iterateFactory = (submitFunction) => {
                        $scope.setFactoryIterator(submitFunction);
                        var factoryIterator = $scope.factoryIterator;

                        if (factoryIterator != undefined) {
                            var submitFn = factoryIterator[submitFunction];
                            submitFn({ params: $scope.toFormParams($scope.formData), formType: $scope.formType }, this.$http).then(function(result) {
                                if (result.data.failureActions.length != 0) {
                                    $scope.parseErrors(result.data);
                                } else {
                                    console.log("Successfully Posted Form");
                                }
                            }, angular.noop);
                        } else {
                            throw ("Action does not exist in Account or Cart: " + $scope.action);
                        }
                    }
                    
                    /** does either a single or multiple actions */
                    $scope.doAction = (actionObject) => {
                        if (angular.isArray(actionObject)) {
                            for (var submitFunction in actionObject) {
                                $scope.iterateFactory(actionObject[submitFunction]);
                            }
                        } else if (angular.isString(actionObject)) {
                            $scope.iterateFactory(actionObject);
                        } else {
                            throw ("Unknown type of action exception");
                        }
                    }
                    
                    /** search dom hiding any forms listed in a onSuccess method on startup */
                    if ($attrs.onSuccess != undefined) {
                        this.$rootScope.$emit("onStart", { "show": $scope.processObject, "hide": $attrs.onSuccess });
                    }
                    
                    /** create the generic submit function */
                    $scope.submit = function() {
                        var action = $scope.action || $scope.actions;
                        $scope.clearErrors();
                        $scope.formData = $scope.getFormData() || "";
                        $scope.doAction(action);
                    }
                }
            }
        }
    }
    angular.module('slatwalladmin').directive('swForm', ['formService', 'ProcessObject', 'AccountFactory', 'CartFactory',
        '$compile', '$templateCache', '$timeout', '$rootScope', 'partialsPath', '$http', (formService, ProcessObject, AccountFactory, CartFactory, $compile, $templateCache, $timeout, $rootScope, partialsPath, $http) => new swForm(formService, ProcessObject, AccountFactory, CartFactory, $compile, $templateCache, $timeout, $rootScope, partialsPath, $http)]);
}

	
