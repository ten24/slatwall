/**********************************************************************************************
 **********************************************************************************************
 **********************************************************************************************
 **		___________________________________________
 ** 	Form Field - type have the following options (This is for the frontend so it can be modified):
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
interface IFormFieldControllerVM{
	propertyDisplay:Object,
    name:string,
    class:string,
    errorClass:string,
    type:string,
    object:Object,
    propertyIdentifier
}

/**
	* Property Display Controller handles the logic for this directive.
	*/
class SWFFormFieldController {
	/** declare our fields so we don't get errors using this */
	public propertyDisplay;
    private name;
   private class;
   private errorClass;
   private type;
   private object;
   private propertyIdentifier;
    public swfPropertyDisplayCtrl;


	/**
		* Handles the logic for the frontend version of the property display.
		*/
	public static $inject = ['$scope','$element','$compile','utilityService'];
	//@ngInject
	constructor ( public $scope:ng.IScope, public $element, public $compile,public utilityService ) {
		this.utilityService = utilityService;
		this.$scope = $scope;
		this.$element = $element;
		this.$compile = $compile;
	}

	// public $onInit=()=>{

	// 	var isObject = false;
	// 	if (!this.propertyDisplay){

	// 		this.propertyDisplay =  this.swfPropertyDisplayCtrl.propertyDisplay;
    //     }

	// 	this.object = this.object || this.propertyDisplay.object;

	//  	if(this.object.metaData){

	// 		isObject = true;
	// 		this.object = this.object.data;
	// 	}



	// 	if(this.propertyDisplay.object.metaData){
	// 		var validationDirectives = this.getValidationDirectives(this.propertyDisplay);


	// 		var unbindWatch = this.$scope.$watch(()=>{
	// 			return angular.element(this.$element).find(':input:first').length
	// 		}
	// 		,(newValue,oldValue)=>{

	// 			if(newValue > 0){
	// 				for(var key in validationDirectives){
	// 					angular.element(this.$element).find(':input:first').attr(key,validationDirectives[key]);
	// 				}
	// 				this.$element.html(this.$compile(this.$element.html())(this.$scope));
	// 				unbindWatch();
	// 			}
	// 		});
	// 	}
	// }


	// public getValidationDirectives = (propertyDisplay,context?)=>{
	// 	var validationsInfo = {};
	// 	var name = propertyDisplay.property;
	// 	propertyDisplay.property = propertyDisplay.propertyIdentifier;

	// 	if(!context){

	// 		if(propertyDisplay.object.metaData.className.split('_').length > 1){
	// 			context = propertyDisplay.object.metaData.className.split('_')[1];
	// 		}else{
	// 			context= "save";
	// 		}

	// 	}

	// 	if(angular.isUndefined(propertyDisplay.object.validations )
	// 		|| angular.isUndefined(propertyDisplay.object.validations.properties)
	// 		|| angular.isUndefined(propertyDisplay.object.validations.properties[propertyDisplay.property])){
	// 		return '';
	// 	}

	// 	var validations = propertyDisplay.object.validations.properties[propertyDisplay.property];
	// 	var validationsForContext = [];

	// 	//get the validations for the current element.
	// 	var propertyValidations = propertyDisplay.object.validations.properties[propertyDisplay.property];
	// 	/*
	// 	* Investigating why number inputs are not working.
	// 	* */
	// 	//check if the contexts match.

	// 	if (angular.isObject(propertyValidations)){
	// 		//if this is a procesobject validation then the context is implied
	// 		if(angular.isUndefined(propertyValidations[0].contexts) && propertyDisplay.object.metaData.isProcessObject){
	// 			propertyValidations[0].contexts = propertyDisplay.object.metaData.className.split('_')[1];
	// 		}

	// 		if (propertyValidations[0].contexts === context){

	// 			for (var prop in propertyValidations[0]){
	// 				if (prop != "contexts" && prop !== "conditions"){
	// 					validationsInfo["swvalidation" + prop.toLowerCase()] = propertyValidations[0][prop];
	// 					//spaceDelimitedList += (" swvalidation" + prop.toLowerCase() + "='" + propertyValidations[0][prop] + "'");
	// 				}
	// 			}
	// 		}
	// 	}



	// 	return validationsInfo;
	// };
}

/**
	* This class handles configuring formFields for use in process forms on the front end.
	*/
class SWFFormField {
	public restrict = "E";
	public require = {swfPropertyDisplayCtrl:"^?swfPropertyDisplay",form:"^?form"};
	public controller = SWFFormFieldController;
	public templateUrl;
	public controllerAs = "swfFormField";
	public scope = {};
	public bindToController = {
			propertyDisplay : "=?",
            propertyIdentifier: "@?",
            name : "@?",
            class: "@?",
            errorClass: "@?",
            type: "@?"
	};
	public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes, formController:any, transcludeFn:ng.ITranscludeFunction) =>{

	}



	/**
		* Handles injecting the partials path into this class
		*/
	public static Factory(){
		var directive = (
		 	coreFormPartialsPath,
				hibachiPathBuilder
		)=>new SWFFormField(
			coreFormPartialsPath,
			hibachiPathBuilder
		);
		directive.$inject = [
			'coreFormPartialsPath',
			'hibachiPathBuilder'
		];
		return directive;
	}
	constructor (
		coreFormPartialsPath,
		hibachiPathBuilder
	) {
		this.templateUrl = hibachiPathBuilder.buildPartialsPath(coreFormPartialsPath)+ 'swfformfield.html';
	}
}

export{
	SWFFormField
}


