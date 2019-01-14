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



import { Component, Input, OnInit } from '@angular/core';
import { UtilityService } from '../../core/services/utilityservice';
import { $Hibachi } from '../../core/services/hibachiservice';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';

@Component({
    selector    : 'sw-form-upgraded',
    templateUrl : '/org/Hibachi/client/src/form/components/form_upgraded.html'
})
export class SwForm implements OnInit {
    
    @Input() public object : any;
    @Input() public name : string; // Workflow.basic.html
    public value;
    public options;
    public selectType;
    public optionsArguments;
    public propertyIdentifier;
    form: FormGroup;
    public selectedRadioFormName;
    public selected;
    public radioOptions;
    
    
    constructor(
        private formBuilder: FormBuilder,
        private utilityService : UtilityService,
        private $hibachi : $Hibachi
    ) {
        
    }
    
    ngOnInit() {
        //this.value = this.utilityService.getPropertyValue(this.object,this.propertyIdentifier);
        this.value = this.utilityService.getPropertyValue(this.object,"workflowName");
        debugger;
        this.form = this.formBuilder.group({
            "workflowName": [this.value, Validators.required]
        });
        
        this.selectStrategy();
        this.yesnoStrategy();
    }

    public isObject=()=>{
        return (angular.isObject(this.object));
    }
    
    public selectStrategy = ()=>{
        //this is specific to the admin because it implies loading of options via api
        if(angular.isDefined(this.object.metaData) && angular.isDefined(this.object.metaData["workflowObject"]) && angular.isDefined(this.object.metaData["workflowObject"].fieldtype)){
            this.selectType = 'object';
        }else{
            this.selectType = 'string';
        }
        this.getOptions();
    }

    public getOptions = ()=>{
        this.propertyIdentifier = 'workflowObject';
        if(angular.isUndefined(this.options)){
            
            if(!this.optionsArguments || !this.optionsArguments.hasOwnProperty('propertyIdentifier')){
                this.optionsArguments={
                    'propertyIdentifier':this.propertyIdentifier
                };
            }

            var optionsPromise = this.$hibachi.getPropertyDisplayOptions(this.object.metaData.className,
                this.optionsArguments
            );
            optionsPromise.then((value)=>{
                this.options = value.data;
                
                if(this.selectType === 'object'
                ){

                    if(angular.isUndefined(this.object.data[this.propertyIdentifier])){
                        this.object.data[this.propertyIdentifier] = this.$hibachi['new'+this.object.metaData[this.propertyIdentifier].cfc]();
                    }

                    if(this.object.data[this.propertyIdentifier].$$getID() === ''){
                        this.object.data['selected'+this.propertyIdentifier] = this.options[0];
                        this.object.data[this.propertyIdentifier] = this.$hibachi['new'+this.object.metaData[this.propertyIdentifier].cfc]();
                        this.object.data[this.propertyIdentifier]['data'][this.object.data[this.propertyIdentifier].$$getIDName()] = this.options[0].value;
                    }else{
                        var found = false;
                        for(var i in this.options){
                            if(angular.isObject(this.options[i].value)){
                                if(this.options[i].value === this.object.data[this.propertyIdentifier]){
                                    this.object.data['selected'+this.propertyIdentifier] = this.options[i];
                                    this.object.data[this.propertyIdentifier] = this.options[i].value;
                                    found = true;
                                    break;
                                }
                            }else{
                                if(this.options[i].value === this.object.data[this.propertyIdentifier].$$getID()){
                                    this.object.data['selected'+this.propertyIdentifier] = this.options[i];
                                    this.object.data[this.propertyIdentifier]['data'][this.object.data[this.propertyIdentifier].$$getIDName()] = this.options[i].value;
                                    found = true;
                                    break;
                                }
                            }
                            if(!found){
                                this.object.data['selected'+this.propertyIdentifier] = this.options[0];
                            }
                        }

                    }
                } else if(this.selectType === 'string'){
                    if(this.object.data[this.propertyIdentifier] !== null){
                        for(var i in this.options){
                            if(this.options[i].value === this.object.data[this.propertyIdentifier]){
                                this.object.data['selected'+this.propertyIdentifier] = this.options[i];
                                this.object.data[this.propertyIdentifier] = this.options[i].value;
                                
                            }
                        }

                    } else{

                        this.object.data['selected'+this.propertyIdentifier] = this.options[0];
                        this.object.data[this.propertyIdentifier] = this.options[0].value;
                    }

                }

            });
        }
    }
    
    public yesnoStrategy = ()=>{
        //format value

        this.selectedRadioFormName = this.utilityService.createID(26);
//        this.object.data[this.propertyIdentifier] = (
//            this.object.data[this.propertyIdentifier]
//            && this.object.data[this.propertyIdentifier].length
//            && this.object.data[this.propertyIdentifier].toLowerCase().trim() === 'yes'
//        ) || this.object.data[this.propertyIdentifier] == 1 ? 1 : 0;

        
        this.object.data['activeFlag'] = (
            this.object.data['activeFlag']
            && this.object.data['activeFlag'].length
            && this.object.data['activeFlag'].toLowerCase().trim() === 'yes'
        ) || this.object.data['activeFlag'] == 1 ? 1 : 0;
        this.radioOptions = [
            {
                name:'Yes',
                value:1
            },
            {
                name:'No',
                value:0
            }
        ];

        if(angular.isDefined(this.object.data['activeFlag'])){

            for(var i in this.radioOptions){
                if(this.radioOptions[i].value === this.object.data['activeFlag']){
                    this.selected = this.radioOptions[i];
                    this.object.data['activeFlag'] = this.radioOptions[i].value;
                }
            }
        }else{
            this.selected = this.radioOptions[0];
            this.object.data['activeFlag'] = this.radioOptions[0].value;
        }

//        this.$timeout(()=>{
//            this.form[this.propertyIdentifier].$dirty = this.isDirty;
//        });
    }
    
}