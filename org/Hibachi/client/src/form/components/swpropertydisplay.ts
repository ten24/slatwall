/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
import {MetaDataService} from "../../core/services/metadataservice";

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

    //swfproperty display properties

    public type;
	public class;
	public fieldAttributes;
	public valueObject;
	public label;
	public name;
	public options;
	public valueObjectProperty;
    public valueOptions;
	public processObject;
	public optionValues:Array<string> = [];
	public propertyDisplay;
    public edit:boolean;

	public value;
	public submit;
	public labelText;
	public labelClass;
	public errorText;
	public errorClass;
	public propertyIdentifier;
	public loader;

    public swForm;
    public selected;

    //@ngInject
    constructor(
        public $filter,
        public utilityService,
        public $injector,
        public metadataService:MetaDataService
    ){
        this.$filter = $filter;
        this.utilityService = utilityService;
        this.$injector = $injector;
        this.metadataService = metadataService;

    }

    public $onInit=()=>{

        var bindToControllerProps = this.$injector.get('swPropertyDisplayDirective')[0].bindToController;
        for(var i in bindToControllerProps){

			if(!this[i] && this.swForm && this.swForm[i]){
				this[i] = this.swForm[i];
			}
		}


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

        if(angular.isUndefined(this.noValidate)){
            this.noValidate = false;
        }

        if(angular.isUndefined(this.optionsArguments)){
            this.optionsArguments = {};
        }

        this.applyFilter = (model, filter)=> {
            try{
                return this.$filter(filter)(model)
            }catch (e){
                return model;
            }
        };

        this.property = this.property || this.propertyIdentifier;
        this.propertyIdentifier = this.propertyIdentifier || this.property;

        this.type = this.type || this.fieldType;
        this.fieldType = this.fieldType || this.type;

        this.edit = this.edit || this.editing;
        this.editing = this.editing || this.edit;

        //swfproperty logic
        if(angular.isUndefined(this.type) && this.object && this.object.metaData){
            this.type = this.metadataService.getPropertyFieldType(this.object,this.propertyIdentifier);
        }

        if(angular.isUndefined(this.hint) && this.object && this.object.metaData){
            this.hint = this.metadataService.getPropertyHintByObjectAndPropertyIdentifier(this.object,this.propertyIdentifier);
        }

        if(angular.isUndefined(this.title) && this.object && this.object.metaData){

            this.labelText = this.metadataService.getPropertyTitle(this.object,this.propertyIdentifier);

        }

        this.labelText = this.labelText || this.title;
        this.title = this.title || this.labelText;

		this.type                	= this.type || "text" ;
		this.class			   	= this.class|| "form-control";
		this.fieldAttributes     	= this.fieldAttributes || "";
		this.label			    = this.label || "true";
		this.labelText			= this.labelText || "";
		this.labelClass			= this.labelClass || "";
		this.name			    	= this.name || "unnamed";


		this.object				= this.object || this.swForm.object; //this is the process object

		/** handle options */
		if (this.options && angular.isString(this.options)){
			let optionsArray = [];
			optionsArray = this.options.toString().split(",");

			angular.forEach(optionsArray, (o)=>{
				let newOption:any = {
					name:"",
					value:""
				};

                newOption.name = o;
				newOption.value= o;

				this.optionValues.push(newOption);
			});
		}



        /** handle turning the options into an array of objects */
		/** handle setting the default value for the yes / no element  */
		if (this.type=="yesno" && (this.value && angular.isString(this.value))){
			this.selected == this.value;
		}

    };
}

class SWPropertyDisplay implements ng.IDirective{

    public static $inject = ['coreFormPartialsPath', 'hibachiPathBuilder'];
    public templateUrl:string;
    public require = {swForm:"?^swForm",form:"?^form"};
    public restrict = 'AE';
    public scope = {};

    public bindToController = {

        //swfproperty scope

        type: "@?",
        name: "@?",
        class: "@?",
        edit: "@?",
        valueObject: "=?",
        valueObjectProperty: "=?",
        propertyIdentifier: "@?",
        valueOptions: "=?",
        fieldAttributes: "@?",
        label:"@?",
        labelText: "@?",
        labelClass: "@?",
        errorText: "@?",
        errorClass: "@?",
        formTemplate: "@?",

        //swpropertyscope

        property:"@?",
        object:"=?",
        editable:"=?",
        editing:"=?",
        isHidden:"=?",
        title:"=?",
        hint:"@?",
        options:"=?",
        optionsArguments:"=?",
        eagerLoadOptions:"=?",
        isDirty:"=?",
        onChange:"=?",
        fieldType:"@?",
        noValidate:"=?",
        inputAttributes:"@?",
        optionValues:"=?",
        eventHandlers:"@?",
        context:"@?"
    };
    public controller=SWPropertyDisplayController;
    public controllerAs="swPropertyDisplay";

    public templateUrlPath = "propertydisplay.html";
    //@ngInject
    constructor(
        public coreFormPartialsPath,
        public hibachiPathBuilder,
        public swpropertyPartialPath

    ){

        this.templateUrl = this.hibachiPathBuilder.buildPartialsPath(this.coreFormPartialsPath) + swpropertyPartialPath;

    }


    public link:ng.IDirectiveLinkFn = (scope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes, formController: any) =>{
        scope.frmController = formController;
        scope.swfPropertyDisplay = scope.swPropertyDisplay;
    };


    public static Factory(swpropertyClass,swpropertyPartialPath?:string){
        var directive = (
            coreFormPartialsPath,
            hibachiPathBuilder
        )=>new swpropertyClass(
            coreFormPartialsPath,
            hibachiPathBuilder,
            swpropertyPartialPath
        );
        directive.$inject = [ 'coreFormPartialsPath', 'hibachiPathBuilder'];

        return directive;
    }
}
export{
    SWPropertyDisplay,
    SWPropertyDisplayController
}