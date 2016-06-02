/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWPropertyDisplayController {
    private applyFilter;
    private setupFormController;
    public errors;
    public editing:boolean;
    public editable:boolean;
    public isHidden:boolean;
    public fieldType;
    public object;
    public property;
    public title;
    public hint;
    public optionsArguments;
    public eagerLoadOptions:boolean;
    public noValidate:boolean;
    public form;
    

    //@ngInject
    constructor(
        public $filter
    ){
        this.errors = {};

        if(angular.isUndefined(this.editing)){
            this.editing = false;
        }
        if(angular.isUndefined(this.editable)){
            this.editable = true;
        }
        if(angular.isUndefined(this.isHidden)){
            this.isHidden = false;
        }
        if(angular.isUndefined(this.eagerLoadOptions)){
            this.eagerLoadOptions = true;
        }
        if(angular.isUndefined(this.noValidate)){
            this.noValidate = false;
        }

        if(angular.isUndefined(this.optionsArguments)){
            this.optionsArguments = {};
        }

        this.applyFilter = function(model, filter) {
            try{
                return $filter(filter)(model)
            }catch (e){
                return model;
            }
        };
    }

    public $onInit=()=>{
        if(!angular.isDefined(this.object)){
            this.object = this.form.$$swFormInfo.object;
        }
        if(angular.isUndefined(this.object) || angular.isUndefined(this.object.metaData)){
            throw("swPropertyDisplayController must be passed an object which is a jsentities instance");
        }
        
        if(angular.isUndefined(this.fieldType)){
            this.fieldType = this.object.metaData.$$getPropertyFieldType(this.property);
        }

        if(angular.isUndefined(this.hint)){
            this.hint = this.object.metaData.$$getPropertyHint(this.property);
        }

        if(angular.isUndefined(this.title)){
            this.title = this.object.metaData.$$getPropertyTitle(this.property);
        }
    };
}

class SWPropertyDisplay implements ng.IDirective{

    public static $inject = ['coreFormPartialsPath', 'hibachiPathBuilder'];
    public templateUrl;
    public require = {form:'^form'};
    public restrict = 'AE';
    public scope = {};

    public bindToController = {
        property:"@",
        object:"=?",
        options:"=?",
        editable:"=?",
        editing:"=?",
        isHidden:"=?",
        title:"=?",
        hint:"@?",
        optionsArguments:"=?",
        eagerLoadOptions:"=?",
        isDirty:"=?",
        onChange:"=?",
        fieldType:"@?",
        noValidate:"=?"
    };
    public controller=SWPropertyDisplayController;
    public controllerAs="swPropertyDisplay";

    constructor(
        public coreFormPartialsPath,
        public hibachiPathBuilder
    ){
        
        console.warn(this);
        this.templateUrl = this.hibachiPathBuilder.buildPartialsPath(this.coreFormPartialsPath) + "propertydisplay.html";
    }
    
    
    public link:ng.IDirectiveLinkFn = ($scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes, formController: any) =>{
    };

    public static Factory(){
        var directive = (
            coreFormPartialsPath,
            hibachiPathBuilder
        )=>new SWPropertyDisplay(
            coreFormPartialsPath,
            hibachiPathBuilder
        );
        directive.$inject = [ 'coreFormPartialsPath', 'hibachiPathBuilder'];

        return directive;
    }
}
export{
    SWPropertyDisplay
}