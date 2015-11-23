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
        postOnly:boolean,
        eventsObj:Array<Object>,
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
        $http:ng.IHttpService,
        submit:Function,
        getProcessObject:Function,
        parseEventString: Function,
        splitIntoEvents: Function,
        splitIntoActors: Function,
        //************************** Objects
        formType:Object,
        formData:Object,
        processEntity:Object,
        //************************** Events
        identity: Function,
        hide:Function,
        show:Function,
        refresh:Function,
        update:Function,
        broadcast:Function,
        parseEvents:Function,
        eventsHandler:Function
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
        
        /**
         * This controller handles most of the logic for the swFormDirective when more complicated self inspection is needed.
         */
        public static $inject = ['$scope', '$element', '$slatwall', 'AccountFactory', 'CartFactory', '$http', '$timeout', 'observerService'];
        constructor(public $scope, public $element, public $slatwall, public AccountFactory, public CartFactory, public $http, public $timeout, public observerService){
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
            vm.action           = this.action;
            vm.actions          = this.actions;
            vm.$timeout         = this.$timeout;
            vm.postOnly         = false;
            
            let observerService = this.observerService;
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
                throw ("ProcessObject Undefined Exception");
            }
            
            try {
                vm.actionFn = this.$slatwall.newEntity(vm.processObject);
            }catch (e){
                vm.postOnly = true;
            }
            
            /** We use these for our models */
            vm.formData = {};
            
            /** returns all the data from the form by iterating the form elements */
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
            
            vm.eventsObj = [];
            /** looks at the onSuccess, onError, and onLoading and parses the string into useful subcategories */
            vm.parseEventString = function(evntStr, evntType) 
            {
                vm.events = vm.parseEvents(evntStr, evntType); //onSuccess : [hide:this, show:someOtherForm, refresh:Account]
            }
            
            vm.eventsHandler = (params) => {
                
                for (var e in params.events){
                    if ( angular.isDefined(params.events[e].value) && params.events[e].value == vm.processObject.toLowerCase()){
                        if (params.events[e].name == "hide")    {vm.hide(params.events[e].value)}
                        if (params.events[e].name == "show")    {vm.show(params.events[e].value)}
                        if (params.events[e].name == "update")  {vm.update(params.events[e].value)}
                        if (params.events[e].name == "refresh") {vm.refresh(params.events[e].value)};
                    }
                    
                } 
            }
            /** hides this directive on event */
            vm.hide = (param) => {
                if (vm.processObject.toLowerCase() == param){
                    this.$element.hide();    
                }
            }
            /** shows this directive on event */
            vm.show = (param) =>{
                if (vm.processObject.toLowerCase() == param){
                    this.$element.show();    
                }
            }
            /** refreshes this directive on event */
            vm.refresh  = (params) =>{
                   
               console.log("Refreshing this: ", vm.processObject, params);
            }
            /** updates this directive on event */
            vm.update  = (params) =>{
               console.log("Updating this: ", vm.processObject, params); 
            }
            
            vm.parseEvents = function(str, evntType) {
                
                if (str == undefined) return;
                let strTokens = str.split(","); //this gives the format [hide:this, show:Account_Logout, update:Account or Cart]
                let eventsObj = {
                    "events": []
                }; //will hold events
                for (var token in strTokens){
                    let t = strTokens[token].split(":")[0].toLowerCase().replace(' ', '');
                    let u = strTokens[token].split(":")[1].toLowerCase().replace(' ', '');
                    if (t == "show" || t == "hide" || t == "refresh" || t == "update"){
                        if (u == "this") {u == vm.processObject.toLowerCase(); console.log("changing")} //<--replaces the alias this with the name of this form.
                        let event = {"name" : t, "value" : u};
                        eventsObj.events.push(event);
                    }
                }
                if (eventsObj.events.length){
                    observerService.attach(vm.eventsHandler, "onSuccess");
                }
                
                return eventsObj;
            }
            
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
                    vm.formData = vm.formData || {};
                    submitFn({ params: vm.toFormParams(vm.formData), formType: vm.formType }).then( (result) =>{
                        if (result.data && result.data.failureActions && result.data.failureActions.length != 0) {
                            vm.parseErrors(result.data);
                            observerService.notify("onError", {"caller" : this.processObject, "events":vm.events.events});
                            //trigger an onError event
                        } else {
                            console.log("Successfully Posted Form");
                            observerService.notify("onSuccess", {"caller":this.processObject, "events":vm.events.events});
                            //trigger a on success event
                        }
                    }, angular.noop);
                } else {
                    throw ("Action does not exist in Account or Cart Exception  *" + vm.action);
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
            
            /* give children access to the process  
            */
            vm.getProcessObject = () => 
            {
                return vm.processEntity;
            } 
            
            /* handle events
            */
            if (this.onSuccess != undefined){
                vm.parseEventString(this.onSuccess, "onSuccess");
                observerService.attach(vm.eventsHandler, "onSuccess");
                
            }else if(this.onError != undefined){
                vm.parseEventString(this.onError, "onError");
                //observerService.attach(vm.eventsHandler, "onError");
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
                hiddenFields: "=?", 
                action: "@?", 
                actions: "@?", 
                formClass: "@?", 
                formData: "=?",
                onSuccess: "@?", 
                onError: "@?",
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
        public static $inject   = [ 'partialsPath', '$http', '$timeout', 'observerService'];
        constructor( public partialsPath , $http, $timeout, observerService) {
            this.templateUrl = this.partialsPath + "formPartial.html";
        }
    }
/**
 * Handles registering the swForm directive with its module as well as injecting dependancies in a minification safe way.
 */
angular.module('slatwalladmin').directive('swForm', ['partialsPath', '$http', 'observerService', (partialsPath, $http, $timeout, observerService) => new SWForm(partialsPath, $http, $timeout, observerService)]);

}//<--end module
	
