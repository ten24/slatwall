/**********************************************************************************************
 **********************************************************************************************
 **********************************************************************************************
 **		Property Display (This one is specifically for the frontend so that it can be modified)
 **		isHidden
 **		requiredFlag
 **		title
 **		hint
 **		editting
 **		object
 **		class
 **		___________________________________________
 ** 	attr.type have the following options:
 **
 **		checkbox			|	As a single checkbox this doesn't require any options, but it will create a hidden field for you so that the key gets submitted even when not checked.  The value of the checkbox will be 1
 **		checkboxgroup		|	Requires the valueOptions to be an array of simple value if name and value is same or array of structs with the format of {value="", name=""}
 **		file				|	No value can be passed in
 **		multiselect			|	Requires the valueOptions to be an array of simple value if name and value is same or array of structs with the format of {value="", name=""}
 **		password			|	No Value can be passed in
 **		radiogroup			|	Requires the valueOptions to be an array of simple value if name and value is same or array of structs with the format of {value="", name=""}
 **		select      		|	Requires the valueOptions to be an array of simple value if name and value is same or array of structs with the format of {value="", name=""}
 **		text				|	Simple Text Field
 **		textarea			|	Simple Textarea
 **		yesno				|	This is used by booleans and flags to create a radio group of Yes and No
 **		submit				|	submit button to post these properties back to the server.
 **		------------------------------------------------------------------------------------------------------
 **
 **		attr.valueObject" type="any" default="" />
 **		attr.valueObjectProperty" type="string" default="" />
 **
 **		General Settings that end up getting applied to the value object
 **		attr.type" type="string" default="text"
 **		attr.name" type="string" default=""
 **		attr.class" type="string" default=""
 **		attr.value" type="any" default=""
 **		attr.valueOptions" type="array" default="#arrayNew(1)#"		<!--- Used for select, checkbox group, multiselect --->
 **		attr.fieldAttributes" type="string" default=""
 **
 *********************************************************************************************
 *********************************************************************************************
 *********************************************************************************************
 */
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

/** declare an interface so we don't get errors using vm */
interface IPropertyDisplayControllerViewModel {
	valueObjectProperty:string,
	type:string,
	class:string,
	valueObject: string | {},
	fieldAttributes:string,
	label:string,
	name:string,
	optionValues:Array<string>,
	propertyDisplay:Object,
	object:{},
	editting:boolean,
	title:string,
	value:any,
	options:string,
	submit:Function,
	labelText:string,
	labelClass:string,
	errorClass:string,
	errorText:string,
	propertyIdentifier:string,
	loader:boolean,
	noValidate:boolean,
	selected:any
}
/**
	* Property Display Controller handles the logic for this directive.
	*/
class SWFPropertyDisplayController {
	/** declare our fields so we don't get errors using this */
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
	public object;
	public editting;
	public title;
	public value;
	public submit;
	public labelText;
	public labelClass;
	public errorText;
	public errorClass;
	public propertyIdentifier;
	public loader;
	public noValidate;
    public swForm;
    public selected;
	/**
		* Handles the logic for the frontend version of the property display.
		*/
	//@ngInject
	constructor ( public $scope ) {
		this.$scope = $scope;
	}

	public $onInit=()=>{
		console.log('oniint');
		this.type                	= this.type || "text" ;
		this.class			   	= this.class|| "formControl";
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

			angular.forEach(optionsArray, function(o){
				let newOption:any = {
					name:"",
					value:""
				};

                newOption.name = o;
				newOption.value= o;

				this.optionValues.push(newOption);
			}, this);
		}

        if (angular.isDefined(this.valueOptions) && angular.isObject(this.valueOptions)){

            this.optionValues = [];
            angular.forEach(this.valueOptions, function(o){
				let newOption:any = {
					name:"",
					value:""
				};

                if(angular.isDefined(o.name) && angular.isDefined(o.value)){
                    newOption.name = o.name;
                    newOption.value= o.value;
                    this.optionValues.push(newOption);
                }
            });
        }

		/** handle turning the options into an array of objects */
		/** handle setting the default value for the yes / no element  */
		if (this.type=="yesno" && (this.value && angular.isString(this.value))){
			this.selected == this.value;
		}

		this.propertyDisplay = {
			type: 	this.type,
			name: 	this.name,
			class: 	this.class,
			loader: this.loader,
			errorClass: this.errorClass,
			option: this.options,
			valueObject: this.valueObject,
			object: this.object,
			label: 	this.label,
			labelText: this.labelText,
			labelClass: this.labelClass,
			optionValues: this.optionValues,
			propertyIdentifier:this.propertyIdentifier,
			edit: 	this.editting,
			title: 	this.title,
			value: 	this.value || "",
			errorText: this.errorText,
		};
        //console.log("Property Display", this.propertyDisplay);
	}
}

/**
	* This class handles configuring formFields for use in process forms on the front end.
	*/
class SWFPropertyDisplay {
	public restrict = "E";
	public require = {swForm:"?^swForm",form:"?^form"};
	public transclude = true;
	public templateUrl = "";
	public controller = SWFPropertyDisplayController;
	public controllerAs = "swfPropertyDisplayController";
	public scope = {};
	public bindToController = {
			type: "@?",
			name: "@?",
			class: "@?",
			edit: "@?",
			title: "@?",
			hint: "@?",
			valueObject: "=?",
			valueObjectProperty: "=?",
            propertyIdentifier: "@?",
			options: "@?",
            valueOptions: "=?",
			fieldAttributes: "@?",
			object: "=?",
			label:"@?",
			labelText: "@?",
			labelClass: "@?",
			errorText: "@?",
			errorClass: "@?",
			formTemplate: "@?"
	};
	public link:ng.IDirectiveLinkFn = (scope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes, formController:any, transcludeFn:ng.ITranscludeFunction) =>{
		scope.frmController = formController;
	}
	public static Factory(){
		var directive = (
			coreFormPartialsPath,hibachiPathBuilder
		)=>new SWFPropertyDisplay(coreFormPartialsPath,hibachiPathBuilder);
		directive.$inject = ['coreFormPartialsPath','hibachiPathBuilder'];
		return directive;
	}
	//@ngInject
	constructor (coreFormPartialsPath,hibachiPathBuilder ) {
		this.templateUrl = hibachiPathBuilder.buildPartialsPath(coreFormPartialsPath) + 'swfpropertydisplaypartial.html';
	}
}
export{
	SWFPropertyDisplay
}


