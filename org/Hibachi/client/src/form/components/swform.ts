/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


/** eliminated many of the unknown type errors in this class */
interface ViewModel {

        //************************** Fields
        hiddenFields: any,
        entityName:string,
        name:string,
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
        hibachiScope:{doAction:any, hasErrors:boolean},
        events:any,
        //************************** Events
        identity: Function,
        hide:Function,
        show:Function,
        refresh:Function,
        update:Function,
        clear:Function,
        broadcast:Function,
        parseEvents:Function,
        eventsHandler:Function
}

   /**
    * Form Controller handles the logic for this directive.
    */
    class SWFormController {

        //************************** Fields
        public isProcessForm:boolean|string;
        public hiddenFields:string;
        public entityName:string;
        public action:string;
        public actions:string;
        public processObject:string;
        public postOnly:boolean;
        public object:any;
        public events: any;
        public name: string;
        public onSuccess:string;
        public onError:string;
        public submit:Function;
        public isDirty:boolean;
        /**
         * This controller handles most of the logic for the swFormDirective when more complicated self inspection is needed.
         */
        // @ngInject
        constructor(public $scope, public $element, public $hibachi, public $http, public $timeout, public observerService, public $rootScope){
            /** only use if the developer has specified these features with isProcessForm */
            if(angular.isUndefined(this.isDirty)){
                this.isDirty = false;    
            } 
            this.isProcessForm = this.isProcessForm || "false";
            
            if (this.isProcessForm == "true") {
                this.handleForm( this, $scope );
            }
            
        }
    
   /**
    * Iterates through the form elements and checks if the names of any of them match
    * the meta data that comes back from the processObject call. Supplies a generic submit
    * method that can be called by any subclasses that inject formCtrl. On submit,
    * this class will attach any errors to the correspnding form element.
    */
    handleForm ( context, $scope ) {
        //console.log("Context", context);
        /** local variables */
        this.processObject = this.name || "";
        
        let vm: ViewModel       = context;
            vm.hiddenFields     = this.hiddenFields;
            vm.entityName       = this.entityName;
            vm.processObject    = this.processObject;
            vm.action           = this.action;
            vm.actions          = this.actions;
            vm.$timeout         = this.$timeout;
            vm.postOnly         = false;
            vm.hibachiScope     = this.$rootScope.hibachiScope;
            
            
            let observerService = this.observerService;
            /** parse the name */
            vm.entityName      = this.processObject.split("_")[0];
            let processObject   = this.processObject.split("_")[1];
            
            /** try to grab the meta data from the process entity in slatwall in a process exists
             *  otherwise, just use the service method to access it.
             */

            /** Cart is an alias for an Order */
            if (vm.entityName == "Order") {
                vm.entityName = "Cart"
            };

            /** find the form scope */
            this.$scope.$on('anchor', (event, data) =>
            {

                if (data.anchorType == "form" && data.scope !== undefined) {
                    vm["formCtrl"] = data.scope;
                }

            });

            /** make sure we have our data using new logic and $hibachi*/
            if (this.processObject == undefined || vm.entityName == undefined) {
                throw ("ProcessObject Undefined Exception");
            }

            if (angular.isDefined(this.object) && this.object.name) {
                vm.actionFn = this.object;
            }else{
                vm.postOnly = true;
            }

            /** We use these for our models */
            vm.formData = {};

            /** returns all the data from the form by iterating the form elements */
            vm.getFormData = function()
            {
                //console.log("Form Data:", this.object);
                angular.forEach(this.object, (val, key) => {
                    /** Check for form elements that have a name that doesn't start with $ */
                    if (angular.isString(val)) {
                        this.formData[key] = val;
                        //console.log("Using Form Element: ", this.formData[key]);
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
                //console.log("Resultant Errors: ", result);
                if (angular.isDefined(result.errors) && result.errors) {
                    angular.forEach(result.errors, (val, key) => {
                        //console.log("Parsing Rule: ", result.errors[key]);
                        //console.log(this.object, key, this.object[key]);
                        
                            //console.log("Yes, is defined...");
                            let primaryElement = this.$element.find("[error-for='" + key + "']");
                            //console.log("Primary Element: ", primaryElement);
                            vm.$timeout(function() {
                                //console.log("Appending");
                                primaryElement.append("<span name='" + key + "Error'>" + result.errors[key] + "</span>");
                            }, 0);
                            //vm["formCtrl"][vm.processObject][key].$setValidity(key, false);//set field invalid
                            //vm["formCtrl"][vm.processObject][key].$setPristine(key, false);
                        
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
               //stub
            }
            /** updates this directive on event */
            vm.update  = (params) =>{
               //stub
            }
            /** clears this directive on event */
            vm.clear  = (params) =>{
               //stub
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
                        if (u == "this") {u == vm.processObject.toLowerCase();} //<--replaces the alias this with the name of this form.
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
               /** clear all form errors on submit. */
                this.$timeout(()=>{
                     let errorElements = this.$element.find("[error-for]");
                     errorElements.empty();
                     //vm["formCtrl"][vm.processObject].$setPristine(true);
                },0);

            }

            /** iterates through the factory submitting data */
            vm.iterateFactory = (submitFunction) =>
            {
                if (!submitFunction) {throw "Action not defined on form";}
                    
                    let submitFn = vm.hibachiScope.doAction;
                    vm.formData = vm.formData || {};
                    //console.log("Calling Final Submit");
                    submitFn(submitFunction, vm.formData).then( (result) =>{
                        if (vm.hibachiScope.hasErrors) {
                            vm.parseErrors(result.data);
                             //trigger an onError event
                            observerService.notify("onError", {"caller" : this.processObject, "events": vm.events.events||""});
                        } else {
                            //trigger a on success event
                            observerService.notify("onSuccess", {"caller":this.processObject, "events":vm.events.events||""});
                        }
                    }, angular.noop);
                    //console.log("Leaving iterateFactory.");
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
            vm.submit = (Action) =>
            {
                
                let action = Action || this.action;
                vm.clearErrors();
                vm.formData = vm.getFormData() || "";
                vm.doAction(action);
            }
            
            this.submit =  vm.submit;
            /* give children access to the process
            */
            vm.getProcessObject = () =>
            {
                return vm.processEntity;
            }

            /* handle events
            */
            if (this.onSuccess){
                vm.parseEventString(this.onSuccess, "onSuccess");
                observerService.attach(vm.eventsHandler, "onSuccess");

            }else if(this.onError){
                vm.parseEventString(this.onError, "onError");
                observerService.attach(vm.eventsHandler, "onError");//stub
            }
        }
    }

class SWForm implements ng.IDirective {

    public templateUrl      = "";
    public transclude       = true;
    public restrict         = "E";
    public controller       = SWFormController;
    public controllerAs     = "swForm";
    public scope            = {};

   /**
    * Binds all of our variables to the controller so we can access using this
    */
    public bindToController = {
            name:"@?",
            context:"@?",
            entityName: "@?",
            processObject: "@?",
            hiddenFields: "=?",
            action: "@?",
            actions: "@?",
            formClass: "@?",
            formData: "=?",
            object: "=?",
            onSuccess: "@?",
            onError: "@?",
            hideUntil: "@?",
            isProcessForm: "@?",
            isDirty:"=?"
    };

    /**
        * Sets the context of this form
        */
    public link:ng.IDirectiveLinkFn = (scope, element: ng.IAugmentedJQuery,
        attrs:ng.IAttributes, controller) =>
    {
        scope.context = scope.context || 'save';
    }

    /**
     * Handles injecting the partials path into this class
     */
    public static Factory(){
        var directive = (
            coreFormPartialsPath,
            hibachiPathBuilder
        ) => new SWForm(
            coreFormPartialsPath,
            hibachiPathBuilder
        );
        directive.$inject = ['coreFormPartialsPath','hibachiPathBuilder'];
        return directive;
    }
    // @ngInject
    constructor( public coreFormPartialsPath, public hibachiPathBuilder) {
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(this.coreFormPartialsPath) + "formPartial.html";
    }
}
export{
    SWForm
}
