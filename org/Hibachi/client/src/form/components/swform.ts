/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

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
    public object:any;
    public events: any;
    public name: string;
    public onSuccess:string;
    public onError:string;
    public eventsObj = [];

    public isDirty:boolean;
    public context:string;
    public formCtrl;
    public formData = {};
    /**
     * This controller handles most of the logic for the swFormDirective when more complicated self inspection is needed.
     */
    // @ngInject
    constructor(public $scope, public $element, public $hibachi, public $http, public $timeout, public observerService, public $rootScope){
        /** only use if the developer has specified these features with isProcessForm */
        if(angular.isUndefined(this.isDirty)){
            this.isDirty = false;
        }

        if(angular.isString(this.object)){
            this.object = this.$hibachi['new'+this.object]();
            this.entityName = this.object.split('_')[0];
            this.context = this.object.split('_')[1];
        }else{
            this.entityName = this.object.metaData.className.split('_')[0];
            this.context = this.object.metaData.className.split('_')[1];    
        }

        this.isProcessForm = this.object.metaData.isProcessObject;

        if (this.isProcessForm) {
            //this.handleForm( this, $scope );

            this.entityName = this.name.split('_')[0];
            this.context = this.name.split('_')[1];

            /** Cart is an alias for an Order */
            if (this.entityName == "Order") {
                this.entityName = "Cart"
            };

            /** find the form scope */
            this.$scope.$on('anchor', (event, data) =>
            {

                if (data.anchorType == "form" && data.scope !== undefined) {
                    this.formCtrl = data.scope;
                }

            });

            /** make sure we have our data using new logic and $hibachi*/
            if (this.context == undefined || this.entityName == undefined) {
                throw ("ProcessObject Undefined Exception");
            }

            /* handle events
            */
            if (this.onSuccess){
                this.parseEventString(this.onSuccess, "onSuccess");
                observerService.attach(this.eventsHandler, "onSuccess");

            }else if(this.onError){
                this.parseEventString(this.onError, "onError");
                observerService.attach(this.eventsHandler, "onError");//stub
            }
        }

    }
    /** create the generic submit function */
    public submit = (action) =>
    {
        action = action || this.action;
        this.clearErrors();
        this.formData = this.getFormData() || "";
        this.doAction(action);
    }

    public doAction = (actionObject) =>
    {
        if (angular.isArray(actionObject)) {
            for (var submitFunction of actionObject) {
                this.iterateFactory(submitFunction);
            }
        } else if (angular.isString(actionObject)) {
            this.iterateFactory(actionObject);
        } else {
            throw ("Unknown type of action exception");
        }
    }
    // /** iterates through the factory submitting data */
    public iterateFactory = (submitFunction) =>
    {
        if (!submitFunction) {throw "Action not defined on form";}

            let submitFn = this.$rootScope.hibachiScope.doAction;
            this.formData = this.formData || {};
            //console.log("Calling Final Submit");
            submitFn(submitFunction, this.formData).then( (result) =>{
                if (this.$rootScope.hibachiScope.hasErrors) {
                    this.parseErrors(result.data);
                        //trigger an onError event
                    this.observerService.notify("onError", {"caller" : this.processObject, "events": this.events.events||""});
                } else {
                    //trigger a on success event
                    this.observerService.notify("onSuccess", {"caller":this.processObject, "events":this.events.events||""});
                }
            }, angular.noop);
            //console.log("Leaving iterateFactory.");
    }

    public parseEvents = (str, evntType)=> {

        if (str == undefined) return;
        let strTokens = str.split(","); //this gives the format [hide:this, show:Account_Logout, update:Account or Cart]
        let eventsObj = {
            "events": []
        }; //will hold events
        for (var token in strTokens){
            let t = strTokens[token].split(":")[0].toLowerCase().replace(' ', '');
            let u = strTokens[token].split(":")[1].toLowerCase().replace(' ', '');
            if (t == "show" || t == "hide" || t == "refresh" || t == "update"){
                if (u == "this") {u == this.processObject.toLowerCase();} //<--replaces the alias this with the name of this form.
                let event = {"name" : t, "value" : u};
                eventsObj.events.push(event);
            }
        }
        if (eventsObj.events.length){
            this.observerService.attach(this.eventsHandler, "onSuccess");
        }

        return eventsObj;
    }

     /** looks at the onSuccess, onError, and onLoading and parses the string into useful subcategories */
    public parseEventString = function(evntStr, evntType)
    {
        this.events = this.parseEvents(evntStr, evntType); //onSuccess : [hide:this, show:someOtherForm, refresh:Account]
    }

    /****
         * Handle parsing through the server errors and injecting the error text for that field
        * If the form only has a submit, then simply call that function and set errors.
        ***/
    public parseErrors = function(result)
    {
        //console.log("Resultant Errors: ", result);
        if (angular.isDefined(result.errors) && result.errors) {
            angular.forEach(result.errors, (val, key) => {
                //console.log("Parsing Rule: ", result.errors[key]);
                //console.log(this.object, key, this.object[key]);

                    //console.log("Yes, is defined...");
                    let primaryElement = this.$element.find("[error-for='" + key + "']");
                    //console.log("Primary Element: ", primaryElement);
                    this.$timeout(function() {
                        //console.log("Appending");
                        primaryElement.append("<span name='" + key + "Error'>" + result.errors[key] + "</span>");
                    }, 0);
                    //vm["formCtrl"][this.processObject][key].$setValidity(key, false);//set field invalid
                    //vm["formCtrl"][this.processObject][key].$setPristine(key, false);

            }, this);
        }
    };

    /** find and clear all errors on form */
    public clearErrors = () =>
    {
        /** clear all form errors on submit. */
        this.$timeout(()=>{
                let errorElements = this.$element.find("[error-for]");
                errorElements.empty();
                //vm["formCtrl"][this.processObject].$setPristine(true);
        },0);

    }

    public eventsHandler = (params) => {

        for (var e in params.events){
            if ( angular.isDefined(params.events[e].value) && params.events[e].value == this.processObject.toLowerCase()){
                if (params.events[e].name == "hide")    {this.hide(params.events[e].value)}
                if (params.events[e].name == "show")    {this.show(params.events[e].value)}
                if (params.events[e].name == "update")  {this.update(params.events[e].value)}
                if (params.events[e].name == "refresh") {this.refresh(params.events[e].value)};
            }

        }
    }
    /** hides this directive on event */
    public hide = (param) => {
        if (this.processObject.toLowerCase() == param){
            this.$element.hide();
        }
    }
    /** shows this directive on event */
    public show = (param) =>{
        if (this.processObject.toLowerCase() == param){
            this.$element.show();
        }
    }
    /** refreshes this directive on event */
    public refresh  = (params) =>{
       //stub
    }
    /** updates this directive on event */
    public update  = (params) =>{
       //stub
    }
    /** clears this directive on event */
    public clear  = (params) =>{
       //stub
    }

    /** returns all the data from the form by iterating the form elements */
    public getFormData = function()
    {
        //console.log("Form Data:", this.object);
        angular.forEach(this.object, (val, key) => {
            /** Check for form elements that have a name that doesn't start with $ */
            if (angular.isString(val)) {
                this.formData[key] = val;
                //console.log("Using Form Element: ", this.formData[key]);
            }

        });

        return this.formData || "";
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
