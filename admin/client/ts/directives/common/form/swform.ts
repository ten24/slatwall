/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
module slatwalladmin {
    
    /** eliminated many of the unknown type errors in this class */
    export interface ViewModel {
        
        //************************** Fields
        hiddenFields: any,
        entityName:string,
        processObject:string,
        action:string,
        actionFn:Function,
        actions:any,
        $timeout:any,
        $scope:ng.IScope,
        pobject:string,
        postOnly:boolean,
        //************************** Functions
        getFormData:Function,
        parseErrors:Function,
        clearErrors:Function,
        setFactoryIterator:Function,
        doAction:Function,
        toFormParams:Function,
        iterateFactory:Function,
        factoryIterator:Function,
        parseProcessObjectResponse:Function,
        $http:ng.IHttpPromise<Function>,
        submit:Function,
        getProcessObject:Function,
        //************************** Objects
        formType:Object,
        formData:Object,
        processEntity:Object
        
    }
    
    /**
     * Form Controller handles the logic for this directive.
     */
    export class SWFormController {
        //************************** Fields
        isProcessForm:boolean|string;
        hiddenFields:string;
        entityName:string;
        action:string;
        actions:string;
        processObject:string;
        postOnly:boolean;
        pobject:string;
        
        /**
         * This controller handles most of the logic for the swFormDirective when more complicated self inspection is needed.
         */
        public static $inject = ['$scope', '$element', '$slatwall', 'AccountFactory', 'CartFactory', '$http', '$timeout'];
        constructor(public $scope, public $element, public $slatwall, public AccountFactory, public CartFactory, public $http, public $timeout){
            /** only use if the developer has specified these features with isProcessForm */
            
            this.isProcessForm = this.isProcessForm || "false";
            if (this.isProcessForm == "true") {
                this.handleSelfInspection( this );    
            }
        }
        
        /**
         * Iterates through the form elements and checks if the names of any of them match
         * the meta data that comes back from the processObject call. Supplies a generic submit
         * method that can be called by any subclasses that inject formCtrl. On submit,
         * this class will attach any errors to the correspnding form element.
         */
        handleSelfInspection ( context ) {
            /** local variables */
        let vm: ViewModel       = context;
            vm.hiddenFields     = this.hiddenFields;
            vm.entityName       = this.entityName || "Account";
            vm.processObject    = this.processObject;
            vm.pobject          = this.pobject;
            vm.action           = this.action;
            vm.actions          = this.actions;
            vm.$timeout         = this.$timeout;
            vm.postOnly         = false;
            
            /** parse the name */
            let entityName      = this.processObject.split("_")[0];
            let processObject   = this.processObject.split("_")[1];
            
            /** try to grab the meta data from the process entity in slatwall in a process exists
             *  otherwise, just use the service method to access it.
             */
             
            /** Cart is an alias for an Order */
            if (entityName == "Order") { 
                entityName = "Cart" 
            };
            
            /** find the form scope */
            this.$scope.$on('anchor', (event, data) => 
                {
    
                    if (data.anchorType == "form" && data.scope !== undefined) {
                        vm["formCtrl"] = data.scope;
                    }
                    
                });
            
            /** make sure we have our data using new logic and $slatwall*/
            if (this.processObject == undefined || this.entityName == undefined) {
                throw ("Process-Object Exception");
            }
            
            try {
                vm.actionFn = this.$slatwall.newEntity(this.pobject);
            }catch (e){
                vm.postOnly = true;
            }
           
            if (angular.isDefined(vm.action)){
                console.log("New Response: ", vm.actionFn);
            }else{
                throw("Could not get access to action fn");
            }
            
            /** We use these for our models */
            vm.formData = {};
            
            /** returns all the data from the form by iterating the form elements (this needs to use the pobject */
            vm.getFormData = function() 
                {
                    angular.forEach(vm["formCtrl"][vm.processObject], (val, key) => {
                        /** Check for form elements that have a name that doesn't start with $ */
                        if (key.toString().indexOf('$') == -1) {
                            this.formData[key] = val.$viewValue || val.$modelValue || val.$rawModelValue;
                        }
                    });
    
                    return vm.formData || "";
                }

            /****
              * Handle parsing through the server errors and injecting the error text for that field
              * If the form only has a submit, then simply call that function and set errors.
              ***/
            vm.parseErrors = function(result) 
                {
                    if (angular.isDefined(result.errors) && result.errors.length != 0) {
                        angular.forEach(result.errors, (val, key) => {
                            if (angular.isDefined(vm["formCtrl"][vm.processObject][key])) {
                                let primaryElement = this.$element.find("[error-for='" + key + "']");
                                vm.$timeout(function() {
                                primaryElement.append("<span name='" + key + "Error'>" + result.errors[key] + "</span>");
                                }, 0);
                                vm["formCtrl"][vm.processObject][key].$setValidity(key, false);//set field invalid
                            }
                        }, this);
                    }
                };

            /** find and clear all errors on form */
            vm.clearErrors = () => 
                {
                    let errorElements = this.$element.find("[error-for]");
                    errorElements.empty();
                }

            /** sets the correct factory to use for submission */
            vm.setFactoryIterator = (fn) => 
                {
                    let account     = this.AccountFactory.GetInstance();
                    let cart        = this.CartFactory.GetInstance();
                    let factories   = [account, cart];
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
                            })
                        }
                    }
                }
            
            /** sets the type of the form to submit */
            vm.formType = { 'Content-Type': 'application/x-www-form-urlencoded' };
            
            vm.toFormParams = (data) => 
                {
                    return data = $.param(data) || "";
                }
            
            /** iterates through the factory submitting data */
            vm.iterateFactory = (submitFunction) => 
                {
                    vm.setFactoryIterator(submitFunction);
                    let factoryIterator = vm.factoryIterator;
    
                    if (factoryIterator != undefined) {
                        let submitFn = factoryIterator[submitFunction];
                        submitFn({ params: vm.toFormParams(vm.formData), formType: vm.formType }).then(function(result) {
                            if (result.data.failureActions.length != 0) {
                                vm.parseErrors(result.data);
                            } else {
                                console.log("Successfully Posted Form");
                            }
                        }, angular.noop);
                    } else {
                        throw ("Action does not exist in Account or Cart: " + vm.action);
                    }
                }

            /** does either a single or multiple actions */
            vm.doAction = (actionObject) => 
                {
                    if (angular.isArray(actionObject)) {
                        for (var submitFunction of actionObject) {
                            vm.iterateFactory(submitFunction);
                        }
                    } else if (angular.isString(actionObject)) {
                        vm.iterateFactory(actionObject);
                    } else {
                        throw ("Unknown type of action exception");
                    }
                }

            /** create the generic submit function */
            vm.submit = () => 
                {
                    let action = vm.action || vm.actions;
                    vm.clearErrors();
                    vm.formData = vm.getFormData() || "";
                    vm.doAction(action);
                }
            
            /** give children access to the process */
            vm.getProcessObject = () => 
                {
                    return vm.processEntity;
                }
        }
    }
    
    export class SWForm implements ng.IDirective {
        
		public templateUrl      = "";
        public transclude       = true;
        public restrict         = "E";
        public replace          = true;
        public controller       = SWFormController;
        public controllerAs     = "swFormController";
        public scope            = {
            object:"=",
            context:"@",
            name:"@"
        };
        
        /**
         * Binds all of our variables to the controller so we can access using this
         */
        public bindToController = {
                object: "=?", 
                context: "@?", 
                name: "@?", 
                entityName: "@?", 
                processObject: "@?",
                pobject:"@?",
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
        public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, 
            attrs:ng.IAttributes, controller, transclude) =>
        {
			scope.context = scope.context || 'save';
		}
        
        /**
         * Handles injecting the partials path into this class
         */
        public static $inject   = [ 'partialsPath', '$http', '$timeout'];
        constructor( public partialsPath , $http, $timeout) {
            this.templateUrl = this.partialsPath + "formPartial.html";
        }
    }
/**
 * Handles registering the swForm directive with its module as well as injecting dependancies in a minification safe way.
 */
angular.module('slatwalladmin').directive('swForm', ['partialsPath', '$http', (partialsPath, $http, $timeout) => new SWForm(partialsPath, $http, $timeout)]);

}//<--end module
	
