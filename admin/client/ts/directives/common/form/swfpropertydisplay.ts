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
angular.module('slatwalladmin')
.directive('swfPropertyDisplay', ['$log','$templateCache','$window', '$compile', 'partialsPath',
	function($log, $templateCache, $window, $compile, partialsPath){ 
		return {
			restrict: 'E',
			require: '^?swForm',
			scope:{
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
			},
			transclude: true,
			templateUrl: partialsPath + 'swfpropertydisplaypartial.html',
			link: function(scope, element, attrs, formCtrl){
				scope.processObject = {};
				scope.valueObjectProperty = attrs.valueObjectProperty;
				scope.type                = attrs.type || "text" ;
				scope.class				  = attrs.class|| "formControl";
				scope.valueObject		  = attrs.valueObject;
				scope.fieldAttributes     = attrs.fieldAttributes || "";
				scope.label			      = attrs.label || "true";
				scope.optionValues        = [];
				scope.propertyDisplay = {
					type: scope.type,
					name: scope.name,
					class: scope.class,
					valueObject: scope.valueObject,
					object: scope.object,
					label: scope.label,
					optionValues: scope.optionValues,
					edit: scope.editting,
					title: scope.title,
					value: scope.value
				};
				
				if (attrs.options && angular.isString(attrs.options)){
					var optionsArray = [];
					optionsArray = attrs.options.toString().split(",");
					angular.forEach(optionsArray, function(o){
						var newOption = {};
						newOption.name = o;
						newOption.value= o;
						scope.optionValues.push(newOption);
					}, scope);
				}
			    scope.up = scope.$parent.$parent;//<--use observer
				/** handle turning the options into an array of objects */
                
                scope.submit = function(){
                	scope.up.submit(); //<--propagate up the chain 
                }
                
				/** handle setting the default value for the yes / no element  */
				if (attrs.type=="yesno" && (attrs.value && angular.isString(attrs.value))){
					scope.selected == attrs.value;
				}
			}
		}
	}
]);
	
