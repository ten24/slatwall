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
    public object:any;
    public events: any;
    public name: string;
    //onSuccessEvents
    public onSuccess:string;
    //onErrorEvents
    public onError:string;
    public eventsObj = [];
    public processObject:string;
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

        if(this.object && this.object.metaData){
            //object can be either an instance or a string that will become an instance
            if(angular.isString(this.object)){
                var objectNameArray = this.object.split('_');
                this.entityName = objectNameArray[0];
                //if the object name array has two parts then we can infer that it is a process object
                if(objectNameArray.length > 1){
                    this.context = this.context || objectNameArray[1];
                    this.isProcessForm = true;
                }else{
                    this.context = this.context || 'save';
                    this.isProcessForm = false;
                }
                //convert the string to an object
                this.object = this.$hibachi['new'+this.object]();
            }else{
                this.isProcessForm = this.object.metaData.isProcessObject;
                this.entityName = this.object.metaData.className.split('_')[0];
                if(this.isProcessForm){
                    this.context = this.context || this.object.metaData.className.split('_')[1];
                }else{
                    this.context = this.context || 'save';
                }
            }
        }

        //
        this.context = this.context || this.name;
        if (this.isProcessForm) {
            /** Cart is an alias for an Order */
            if (this.entityName == "Order") {
                this.entityName = "Cart"
            };
        }

        //  /** find the form scope */
        // this.$scope.$on('anchor', (event, data) =>
        // {
        //     if (data.anchorType == "form" && data.scope !== undefined) {
        //         this.formCtrl = data.scope;
        //     }
        // });

        /** make sure we have our data using new logic and $hibachi*/
//        if (this.context == undefined || this.entityName == undefined) {
//            throw ("ProcessObject Undefined Exception");
//        }
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
    /** create the generic submit function */
    public submit = (actions) =>
    {
        actions = actions || this.action;
        this.clearErrors();
        this.formData = this.getFormData() || "";
        this.doActions(actions);
    }

    //array or comma delimited
    public doActions = (actions:string | string[]) =>
    {
        if (angular.isArray(actions)) {
            for (var action of <string[]>actions) {
                this.doAction(action);
            }
        } else if (angular.isString(actions)) {
            this.doAction(<string>actions);
        } else {
            throw ("Unknown type of action exception");
        }
    }
    // /** iterates through the factory submitting data */
    public doAction = (action:string) =>
    {
        if (!action) {throw "Action not defined on form";}

        this.formData = this.formData || {};
        //console.log("Calling Final Submit");
        let request = this.$rootScope.hibachiScope.doAction(action, this.formData)
        .then( (result) =>{
            if (result.errors) {
                this.parseErrors(result.errors);
                    //trigger an onError event
                this.observerService.notify("onError", {"caller" : this.context, "events": this.events.events||""});
            } else {
                //trigger a on success event
                this.observerService.notify("onSuccess", {"caller":this.context, "events":this.events.events||""});
            }
        }, angular.noop);

    }

    public parseEvents = (str:string, evntType)=> {

        if (str == undefined) return;
        let strTokens = str.split(","); //this gives the format [hide:this, show:Account_Logout, update:Account or Cart, event:element]
        let eventsObj = {
            "events": []
        }; //will hold events
        for (var token in strTokens){
            let eventName = strTokens[token].split(":")[0].toLowerCase().replace(' ', '');
            let formName = strTokens[token].split(":")[1].toLowerCase().replace(' ', '');

            if (formName == "this") {formName == this.context.toLowerCase();} //<--replaces the alias this with the name of this form.
            let event = {"name" : eventName, "value" : formName};
            eventsObj.events.push(event);

        }
        if (eventsObj.events.length){
            this.observerService.attach(this.eventsHandler, "onSuccess");
        }

        return eventsObj;
    }

     /** looks at the onSuccess, onError, and onLoading and parses the string into useful subcategories */
    public parseEventString = (evntStr:string, evntType)=>
    {
        this.events = this.parseEvents(evntStr, evntType); //onSuccess : [hide:this, show:someOtherForm, refresh:Account]
        console.log('events:',this.events);
    }

    /****
         * Handle parsing through the server errors and injecting the error text for that field
        * If the form only has a submit, then simply call that function and set errors.
        ***/
    public parseErrors = (errors)=>
    {

        if (angular.isDefined(errors) && errors) {
            angular.forEach(errors, (val, key) => {
                    let primaryElement = this.$element.find("[error-for='" + key + "']");
                    this.$timeout(function() {
                        primaryElement.append("<span name='" + key + "Error'>" + errors[key] + "</span>");
                    }, 0);
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
                //vm["formCtrl"][this.context].$setPristine(true);
        },0);

    }

    public eventsHandler = (params) => {
        //this will call any form specific functions such as hide,show,refresh,update or whatever else you later add
        for (var e in params.events){
            if ( angular.isDefined(params.events[e].value) && params.events[e].value == this.context.toLowerCase()){
                if(params.events[e].name && this[params.events[e].name]){
                    this[params.events[e].name](params.events[e].value);
                }
            }
        }
    }
    /** hides this directive on event */
    public hide = (param) => {
        if (this.context.toLowerCase() == param){
            this.$element.hide();
        }
    }
    /** shows this directive on event */
    public show = (param) =>{
        if (this.context.toLowerCase() == param){
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
    public getFormData = ()=>
    {
        for(var key in this.formCtrl){
            if(key.charAt(0) !=='$' && key !== 'name'){
                let value = this.formCtrl[key].$viewValue;
                this.formData[key] = value;
            }
        }
        console.log('formdatahere',this.formData);

        return this.formData;
        // var iterable = this.object;
        // if(this.object.data){
        //     iterable = this.object.data;
        // }

        // angular.forEach(iterable, (val, key) => {
        //     /** Check for form elements that have a name that doesn't start with $ */
        //     if (angular.isString(val)) {
        //         this.formData[key] = val;
        //     }
        // });

        // return this.formData || "";
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
