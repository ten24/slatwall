/**
 * This validate directive will look at the current element, figure out the context (save, edit, delete) and 
 * validate based on that context as defined in the validation properties object.
 */
'use strict';
angular.module('slatwalladmin').directive('swInput',

['$log',
 '$compile',
 'utilityService',
 function(
	$log, 
	$compile,
	utilityService
) {
	var getValidationDirectives = function(propertyDisplay){
		var spaceDelimitedList = '';
		var form = propertyDisplay.form.$$swFormInfo;
		var validations = propertyDisplay.object.validations.properties[propertyDisplay.property];
		var validationsForContext = [];
		
		//get all validations related to the form context;
		console.log(form);
		console.log(propertyDisplay);
		angular.forEach(validations,function(validation,key){
			if(utilityService.listFind(validation.contexts.toLowerCase(),form.context.toLowerCase()) !== -1){
				validationsForContext.push(validation);
			}
		});
		
		//now that we have all related validations for the specific form context that we are working with collection the directives we need
		//getValidationDirectiveByType();
		
		
		//loop over validations that are required and create the space delimited list
		console.log(validations);
		
		return spaceDelimitedList;
	}
	
	var getTemplate = function(propertyDisplay){
		var template = '';
		var validationDirectives = getValidationDirectives(propertyDisplay);
		
		if(propertyDisplay.fieldType === 'text'){
			template = '<input type="text" class="form-control" '+
			'ng-model="propertyDisplay.object.data[propertyDisplay.property]" '+
		    'ng-disabled="!propertyDisplay.editable" '+ 
		    'ng-show="propertyDisplay.editing" '+
		    'name="'+propertyDisplay.property+'" '+
		    'required="required" '+
		    validationDirectives+
		    'id="swinput'+utilityService.createID(26)+'"'+
			' />';
		}else if(propertyDisplay.fieldType === 'select'){
			
		}else if(propertyDisplay.fieldType === 'yesno'){
			
		}else if(propertyDisplay.fieldType === 'number'){
			
		}else if(propertyDisplay.fieldType === 'json'){
			
		}else if(propertyDisplay.fieldType === 'search-select'){
			
		}
		
//		<sw-form-field-text data-property-display="propertyDisplay" ng-switch-when="text"></sw-form-field-text>
//		<sw-form-field-select data-property-display="propertyDisplay" ng-switch-when="select"></sw-form-field-select>
//		<sw-form-field-radio data-property-display="propertyDisplay" ng-switch-when="yesno"></sw-form-field-radio>
//		<sw-form-field-number data-property-display="propertyDisplay" ng-switch-when="number"></sw-form-field-number>
//		<sw-form-field-json data-property-display="propertyDisplay" ng-switch-when="json"></sw-form-field-json>
//		<sw-form-field-search-select data-property-display="propertyDisplay" ng-switch-when="search-select"></sw-form-field-search-select>
		return template; 
	}
	
	return {
		require:'^form',
		scope:{
			propertyDisplay:"="
		},
		restrict : "E",
		//adding model and form controller
		link : function(scope, element, attr, formController) {
			//renders the template and compiles it
			element.html(getTemplate(scope.propertyDisplay));

	        $compile(element.contents())(scope);
		}
	}
} ]);