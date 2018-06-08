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
    public errorClass:string;
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
    public inputAttributes:string;
    public eventListeners;
    public submitOnEnter;
    public parseObjectErrors:boolean = true;
    public sRedirectUrl;
    public fRedirectUrl;
    public completedActions:number = 0;
    /**
     * This controller handles most of the logic for the swFormDirective when more complicated self inspection is needed.
     */
    // @ngInject
    constructor(
        public $scope,
        public $element,
        public $hibachi,
        public $http,
        public $timeout,
        public observerService,
        public $rootScope,
        public entityService,
        public utilityService
    ){
        /** only use if the developer has specified these features with isProcessForm */
        this.$hibachi = $hibachi;
        this.utilityService = utilityService;
        if(angular.isUndefined(this.isDirty)){
            this.isDirty = false;
        }


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
            this.$timeout( ()=> {

                this.object = this.$hibachi['new'+this.object]();
            });
        }else{
            if(this.object && this.object.metaData){
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
        if(this.submitOnEnter){
            this.eventListeners = this.eventListeners || {};
            this.eventListeners.keyup = this.submitKeyCheck;
        }

        if(this.eventListeners){
            for(var key in this.eventListeners){
                this.observerService.attach(this.eventListeners[key], key)
            }
        }

    }

    public $onInit=()=>{
        if(this.object && this.parseObjectErrors){
            this.$timeout(()=>{
                this.parseErrors(this.object.errors)
            });
        }
    }

    public isObject=()=>{
        return (angular.isObject(this.object));
    }

    public submitKeyCheck = (event) => {
        if(event.form.$name == this.name &&
            event.event.keyCode == 13){
            this.submit(event.swForm.action);
        }
    }

    /** create the generic submit function */
    public submit = (actions) =>
    {   
        this.actions = actions || this.action;
        console.log('actions!', this.actions);
        this.clearErrors();
        this.formData = this.getFormData() || "";
        this.doActions(this.actions);
    }

    //array or comma delimited
    public doActions = (actions:string | string[]) =>
    {
        if (angular.isArray(actions)) {
            this.completedActions = 0;
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
        //

        let request = this.$rootScope.hibachiScope.doAction(action, this.formData)
        .then( (result) =>{
            if(!result) return;
            if(result.successfulActions.length){
                this.completedActions++;
            }
            if( (angular.isArray(this.actions) && this.completedActions === this.actions.length)
                ||
                (!angular.isArray(this.actions)) && result.successfulActions.length)
            {
                //if we have an array of actions and they're all complete, or if we have just one successful action
                if(this.sRedirectUrl){
                    this.$rootScope.slatwall.redirectExact(this.sRedirectUrl);
                }
            }
            this.object.forms[this.name].$setSubmitted(true);
            if (result.errors) {
                this.parseErrors(result.errors);
                if(this.fRedirectUrl){
                    this.$rootScope.slatwall.redirectExact(this.fRedirectUrl);
                }
            }
        });

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
                    this.$timeout(()=> {
                        
                        /**
                        if an error class has been attached to this form
                        by its children propertydisplay or errorDisplay, use it.
                        Otherwise, just add a generic 'error' class
                        to the error message **/
                        let errorClass = this.errorClass ? this.errorClass : "error";
                        
                        errors[key].forEach((error)=>{
                            primaryElement.append("<div class='" + errorClass + "' name='" + key + "Error'>" + error + "</div>");
                        })
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
        },0);

    }

    public eventsHandler = (params) => {
        //this will call any form specific functions such as hide,show,refresh,update or whatever else you later add
        for (var e in params.events){
            if ( angular.isDefined(params.events[e].value) && params.events[e].value == this.name.toLowerCase()){
                if(params.events[e].name && this[params.events[e].name]){
                    this[params.events[e].name](params.events[e].value);
                }
            }
        }
    }
    /** hides this directive on event */
    public hide = (param) => {
        if (this.name.toLowerCase() == param){
            this.$element.hide();
        }
    }
    /** shows this directive on event */
    public show = (param) =>{
        if (this.name.toLowerCase() == param){
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
        var iterable = this.formCtrl;
        angular.forEach(iterable, (val, key) => {
            if(typeof val === 'object' && val.hasOwnProperty('$modelValue')){
                if(this.object.forms[this.name][key].$viewValue){
                    this.object.forms[this.name][key].$setViewValue("");
                    this.object.forms[this.name][key].$render();
                }
            }else{
                val = "";
            }
        });
    }

    /** returns all the data from the form by iterating the form elements */
    public getFormData = ()=>
    {
        var iterable = this.formCtrl;

        angular.forEach(iterable, (val, key) => {
            if(typeof val === 'object' && val.hasOwnProperty('$modelValue')){
                 if(this.object.forms[this.name][key].$modelValue != undefined){
                    val = this.object.forms[this.name][key].$modelValue;
                }else if(this.object.forms[this.name][key].$viewValue != undefined){
                    val = this.object.forms[this.name][key].$viewValue;
                }else if(this.object.forms[this.name][key].$dirty){
                    val="";
                }
                /** Check for form elements that have a name that doesn't start with $ */
                if (angular.isString(val) || angular.isNumber(val) || typeof val == 'boolean') {
                    this.formData[key] = val;
                }
                if(val.$modelValue != undefined){
                    this.formData[key] = val.$modelValue;
                }else if(val.$viewValue != undefined){
                    this.formData[key] = val.$viewValue;
                }
            }
            else{
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
            hiddenFields: "=?",
            action: "@?",
            actions: "@?",
            formClass: "@?",
            formData: "=?",
            errorClass: '@?',
            object: "=?",
            onSuccess: "@?",
            onError: "@?",
            hideUntil: "@?",
            isDirty:"=?",
            inputAttributes:"@?",
            eventListeners:"=?",
            eventAnnouncers:"@",
            submitOnEnter:"@",
            parseObjectErrors:"@?",
            sRedirectUrl:"@?",
            fRedirectUrl:"@?"
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
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(this.coreFormPartialsPath) + "form.html";
    }
}
export{
    SWForm,
    SWFormController
}