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

	/**
		* Handles the logic for the frontend version of the property display.
		*/
	public static $inject = ['$scope'];
	constructor ( public $scope:ng.IScope ) {
		let vm:any = this;
        
        if (this.propertyDisplay){
            vm.propertyDisplay = this.propertyDisplay;   
        }else{
            vm.propertyDisplay =  {
                name: vm.name,
                class: vm.class,
                errorClass: vm.errorClass,
                type: vm.type,
                object: vm.object,
                propertyIdentifier: vm.propertyIdentifier 
            };
            //console.log("Built a property display");
        }
		
	}
}

/**
	* This class handles configuring formFields for use in process forms on the front end.
	*/
class SWFFormField {
	public restrict = "E";
	public require = "^?swfPropertyDisplay";
	public controller = SWFFormFieldController;
	public templateUrl;
	public controllerAs = "swfFormField";
	public scope = true;
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


