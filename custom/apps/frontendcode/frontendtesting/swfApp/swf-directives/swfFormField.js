/**
  
  
  		attr.type have the following options:
		
		checkbox			|	As a single checkbox this doesn't require any options, but it will create a hidden field for you so that the key gets submitted even when not checked.  The value of the checkbox will be 1
		checkboxgroup		|	Requires the valueOptions to be an array of simple value if name and value is same or array of structs with the format of {value="", name=""}
		file				|	No value can be passed in
		multiselect			|	Requires the valueOptions to be an array of simple value if name and value is same or array of structs with the format of {value="", name=""}
		password			|	No Value can be passed in
		radiogroup			|	Requires the valueOptions to be an array of simple value if name and value is same or array of structs with the format of {value="", name=""}
		select      		|	Requires the valueOptions to be an array of simple value if name and value is same or array of structs with the format of {value="", name=""}
		text				|	Simple Text Field
		textarea			|	Simple Textarea
		yesno				|	This is used by booleans and flags to create a radio group of Yes and No
		submit				|	submit button to post these properties back to the server.
		------------------------------------------------------------------------------------------------------
		
		
		attr.valueObject" type="any" default="" />
		attr.valueObjectProperty" type="string" default="" />
		
		General Settings that end up getting applied to the value object
		attr.type" type="string" default="text"
		attr.name" type="string" default="" 
		attr.class" type="string" default=""
		attr.value" type="any" default=""
		attr.valueOptions" type="array" default="#arrayNew(1)#"		<!--- Used for select, checkbox group, multiselect --->
		attr.fieldAttributes" type="string" default=""
		
 
 */

angular.module('slatwall')
.directive('swfFormField', [
'$log','$templateCache','$window',
	function($log, $templateCache, $window){ 
		return {
			restrict: 'E',
			scope:{
				type: "@?",
				name: "@?",
				class: "@?",
				value: "=?",
				valueObject: "=?",
				valueObjectProperty: "=?",
				options: "@?",
				fieldAttributes: "@?",
				doProcess: "@?"
			},
			transclude: true,
			templateUrl:'custom/apps/frontendcode/frontendtesting/swfApp/swf-directive-partials/swfFormFieldPartial.html',
			link: function(scope, element, attrs){
				/** set defaults */
				scope.valueObjectProperty = attrs.valueObjectProperty;
				scope.type = attrs.type || "text" ;
				console.log("Type", scope.type);
				scope.class				  = attrs.class|| "formControl";
				scope.valueObject		  = attrs.valueObject;
				scope.valueObjectProperty = attrs.valueObjectProperty;
				scope.fieldAttributes     = attrs.fieldAttributes || "";
				scope.doProcess	      	  = attrs.doProcess || "";
				scope.optionValues = [];
				
				/** if no default is set for  */
				
				/** handle turning the options into an array of objects */
				if (attrs.options && angular.isString(attrs.options)){
					console.log("is string")
					var optionsArray = [];
					optionsArray = attrs.options.toString().split(",");
					console.log(optionsArray);
					angular.forEach(optionsArray, function(o){
						var newOption = {};
						newOption.name = o;
						newOption.value= o;
						scope.optionValues.push(newOption);
						console.log("newOption=", newOption);
					}, scope);
					console.log("Option Values: ", scope.optionValues);	
				}
				
				/** handle setting the default value for the yes / no element  */
				if (attrs.type=="yesno" && (attrs.value && angular.isString(attrs.value))){
					scope.selected == attrs.value;
				}
				
				
			}
		};
	}
]);
	
