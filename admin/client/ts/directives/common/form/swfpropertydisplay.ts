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
/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
module slatwalladmin {
	
	/** declare an interface so we don't get errors using vm */
	export interface IPropertyDisplayControllerViewModel {
		processObject:Object,
		valueObjectProperty:string,
		type:string,
		class:string,
		valueObject:string,
		fieldAttributes:string,
		label:string,
		name:string,
		optionValues:Array<string>,
		formCtrl:ng.IFormController | {},
		propertyDisplay:Object,
		object:{},
		editting:boolean,
		title:string,
		value:any,
		options:string,
		submit:Function
	}
	/**
     * Property Display Controller handles the logic for this directive.
     */
    export class SWFPropertyDisplayController {
		/** declare our fields so we don't get errors using this */
		public type;
		public class;
		public fieldAttributes;
		public valueObject;
		public label;
		public name;
		public options;
		public valueObjectProperty;
		public processObject;
		public optionValues;
		public formCtrl;
		public propertyDisplay;
		public object;
		public editting;
		public title;
		public value;
		public submit;
		
		/**
		 * Handles the logic for the frontend version of the property display.
		 */
		public static $inject = ['$scope'];
		constructor ( public $scope:ng.IScope ) {
			
			let vm:IPropertyDisplayControllerViewModel = this;
			vm.processObject = {};
			vm.valueObjectProperty 	= this.valueObjectProperty;
			vm.type                	= this.type || "text" ;
			vm.class			   	= this.class|| "formControl";
			vm.valueObject		  	= this.valueObject;
			vm.fieldAttributes     	= this.fieldAttributes || "";
			vm.label			    = this.label || "true";
			vm.name			    	= this.name || "unnamed";
			vm.options				= this.options;
			vm.optionValues        	= [];
			vm.formCtrl 			= {};
			
			/** in order to attach the correct controller to local vm, we need a watch to bind */
			this.$scope.$watch(() => { return this.$scope.frmController; }, (newValue, oldValue) => {
    			if (newValue !== undefined){
					vm.formCtrl = newValue;
				}
			});
				
			
			vm.propertyDisplay = {
				type: 	vm.type,
				name: 	vm.name,
				class: 	vm.class,
				valueObject: vm.valueObject,
				object: vm.object,
				label: 	vm.label,
				optionValues: vm.optionValues,
				edit: 	vm.editting,
				title: 	vm.title,
				value: 	vm.value 
			};
			
			/** handle options */	
			if (vm.options && angular.isString(vm.options)){
				let optionsArray = [];
				optionsArray = vm.options.toString().split(",");
				
				angular.forEach(optionsArray, function(o){
					let newOption = {
						name:"",
						value:""
					};
					newOption.name = o.name;
					newOption.value= o.value;
					vm.optionValues.push(newOption);
				}, vm);
			}
			    
			/** handle turning the options into an array of objects */
			vm.submit = function(){
				vm.formCtrl.submit();
			}
			
			/** handle setting the default value for the yes / no element  */
			if (this.type=="yesno" && (this.value && angular.isString(this.value))){
				vm.selected == this.value;
			}
			
		}
	}
	
	/**
	 * This class handles configuring formFields for use in process forms on the front end.
	 */
    export class SWFPropertyDisplay {
		public restrict = "E";
		public require = "?^swForm";
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
				options: "@?",
				fieldAttributes: "@?",
				object: "=",
				label:"@?",
				labelText: "@?",
				labelClass: "@?",
				errorText: "@?",
				errorClass: "@?",
				formTemplate: "@?"
		};
		public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes, formController:any, transcludeFn:ng.ITranscludeFunction) =>{
			scope.frmController = formController; 
		}
		/**
         * Handles injecting the partials path into this class
         */
        public static $inject   = [ '$log', '$templateCache', '$window', '$compile', 'partialsPath' ];
		constructor ( public $log, public $templateCache, public $window, public $compile, public partialsPath ) {
			this.templateUrl = partialsPath + 'swfpropertydisplaypartial.html';
		}
	}
/**
 * Handles registering the swForm directive with its module as well as injecting dependancies in a minification safe way.
 */
angular.module('slatwalladmin').directive('swfPropertyDisplay', ['$log', '$templateCache', '$window', '$compile', 'partialsPath', ($log, $templateChache, $window, $compile, partialsPath) => new SWFPropertyDisplay($log, $templateChache, $window, $compile, partialsPath)]);

}
	
