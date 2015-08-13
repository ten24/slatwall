/// <reference path='../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../client/typings/tsd.d.ts' />
module slatwalladmin{
    export class Form implements ng.IFormController{
        constructor(
            public name:string,
            public object:any,
            public editing:boolean
        ){
            this.name = name;
            this.object = object;
            this.editing = editing;
        }    
    }
    
    export class FormService implements BaseService{
        public static $inject = ['$log'];
        constructor(
            private $log:ng.ILogService
        ){
            this._forms = {};
            this._pristinePropertyValue = {};
            
        }
        
        setPristinePropertyValue = (property:string,value:any):void =>{
            this._pristinePropertyValue[property] = value;
        }
        
        getPristinePropertyValue = (property:string):any =>{
            return this._pristinePropertyValue[property];
        }
        
        clearForm = (form:Form):void =>{
            $log.debug('clear form');
            $log.debug(form);
            for(var key in form){
                if(key.charAt(0) !== '$'){
                    $log.debug(form[key]);
                }
            }
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
            for(var key in form){
                if(key.charAt(0) !== '$'){
                    if(angular.isDefined(this.getPristinePropertyValue(key))){
                        form[key].$setViewValue(this.getPristinePropertyValue(key));
                    }else{
                        form[key].$setViewValue('');
                    }
                    form[key].$render();
                    
                }
            }
            form.$submitted = false;
            form.$setPristine();
        }
    }  
    angular.module('slatwalladmin')
    .service('formService',FormService); 
}
