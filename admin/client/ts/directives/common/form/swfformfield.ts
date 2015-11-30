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
/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
module slatwalladmin {
	
	/** declare an interface so we don't get errors using vm */
	export interface IFormFieldControllerVM{
		propertyDisplay:Object
	}
	
	/**
     * Property Display Controller handles the logic for this directive.
     */
    export class SWFFormFieldController {
		/** declare our fields so we don't get errors using this */
		public propertyDisplay;

		/**
		 * Handles the logic for the frontend version of the property display.
		 */
		public static $inject = ['$scope'];
		constructor ( public $scope:ng.IScope ) {
			
			let vm:IFormFieldControllerVM = this;
			vm.propertyDisplay = this.propertyDisplay;
			console.log("Found new property display being injected into this formfield: ", this.propertyDisplay);
		}
	}
	
	/**
	 * This class handles configuring formFields for use in process forms on the front end.
	 */
    export class SWFFormField {
		public restrict = "E";
		public require = "^swfPropertyDisplay";
		public controller = SWFFormFieldController;
		public controllerAs = "swfFormField";
		public scope = true;
		public bindToController = {
				propertyDisplay : "=?"
		};
		public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes, formController:any, transcludeFn:ng.ITranscludeFunction) =>{
			
		}
		/**
         * Handles injecting the partials path into this class
         */
        public static $inject   = [ '$log', '$templateCache', '$window', '$compile', 'partialsPath' ];
		constructor ( public $log, public $templateCache, public $window, public $compile, public partialsPath ) {
			this.templateUrl = partialsPath + 'swfformfieldpartial.html';
		}
	}
	
/**
 * Handles registering the directive with its module as well as injecting dependancies in a minification safe way.
 */
angular.module('slatwalladmin').directive('swfFormField', ['$log', '$templateCache', '$window', '$compile', 'partialsPath', ($log, $templateChache, $window, $compile, partialsPath) => new SWFFormField($log, $templateChache, $window, $compile, partialsPath)]);

}
	
