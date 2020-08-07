/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class Form implements ng.IFormController{
    [name: string]: any;
    public name:string;
    public object:any;
    public editing:boolean;
    public $pristine: boolean;
    public $dirty: boolean;
    public $valid: boolean;
    public $invalid: boolean;
    public $submitted: boolean;
    public $error: any;
    $addControl = (control: ng.INgModelController): void =>{}
    $removeControl = (control: ng.INgModelController): void =>{}
    $setValidity = (validationErrorKey: string, isValid: boolean, control: ng.INgModelController): void =>{}
    $setDirty = (): void =>{}
    $setPristine = (): void =>{}
    $commitViewValue = (): void =>{}
    $rollbackViewValue = (): void =>{}
    $setSubmitted = (): void =>{}
    $setUntouched = (): void =>{}
    //@ngInject
    constructor(
        name:string,
        object:any,
        editing:boolean
    ){
        this.name = name;
        this.object = object;
        this.editing = editing;
    }
}

class FormService{
    public static $inject = ['$log'];
    private _forms;
    private _pristinePropertyValue;

    constructor(
        private $log:ng.ILogService
    ){
        this.$log = $log;
        this._forms = {};
        this._pristinePropertyValue = {};

    }

    setPristinePropertyValue = (property:string,value:any):void =>{
        this._pristinePropertyValue[property] = value;
    }

    getPristinePropertyValue = (property:string):any =>{
        return this._pristinePropertyValue[property];
    }

    setForm = (form:Form):void =>{
        this._forms[form.name] = form;
    }

    getForm = (formName:string):Form =>{
        return this._forms[formName];
    }

    getForms = ():any =>{
        return this._forms;
    }

    getFormsByObjectName = (objectName:string):any =>{
        var forms = [];
        for(var f in this._forms){

            if(angular.isDefined(this._forms[f].$$swFormInfo.object) && this._forms[f].$$swFormInfo.object.metaData.className === objectName){
                forms.push(this._forms[f]);
            }
        }
        return forms;
    }

    createForm = (name:string,object:any,editing:boolean):Form =>{
        var _form = new Form(
            name,
            object,
            editing
        );
        this.setForm(_form);
        return _form;
    }

    resetForm = (form:Form):void =>{

        this.$log.debug('resetting form');
        this.$log.debug(form);

        for(var key in form){
            if(angular.isDefined(form[key])
                && typeof form[key].$setViewValue == 'function'
                && angular.isDefined(form[key].$viewValue)){
                this.$log.debug(form[key]);
                if(angular.isDefined(this.getPristinePropertyValue(key))){
                    form[key].$setViewValue(this.getPristinePropertyValue(key));
                }else{
                    form[key].$setViewValue('');
                }
                form[key].$setUntouched(true);
                form[key].$render();
                this.$log.debug(form[key]);
            }
        }

        form.$submitted = false;
        form.$setPristine();
        form.$setUntouched();
    }
}
export{
    FormService
}



