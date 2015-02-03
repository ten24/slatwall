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
		var name = propertyDisplay.property;
		var form = propertyDisplay.form.$$swFormInfo;
		var validations = propertyDisplay.object.validations.properties[propertyDisplay.property];
		var validationsForContext = [];
		
		//get the form context and the form name.
		var formContext = propertyDisplay.form.$$swFormInfo.context;
		var formName = propertyDisplay.form.$$swFormInfo.name;
		//get the validations for the current element.
		var propertyValidations = propertyDisplay.object.validations.properties[name];
		//check if the contexts match.
		if (angular.isObject(propertyValidations)){
			for (var prop in propertyValidations[0]){
				if (prop != "contexts"){
					spaceDelimitedList += (" swvalidation" + prop.toLowerCase() + "='" + propertyValidations[0][prop] + "'");
				}
		}
		console.log(spaceDelimitedList);
		}
		//loop over validations that are required and create the space delimited list
		console.log(validations);
		
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
		
		
		return spaceDelimitedList;
	}
	
	var getTemplate = function(propertyDisplay){
		var template = '';
		if(propertyDisplay.fieldType === 'text'){
			template = '<input type="text" class="form-control" '+
			'ng-model="propertyDisplay.object.data[propertyDisplay.property]" '+
		    'ng-disabled="!propertyDisplay.editable" '+ 
		    'ng-show="propertyDisplay.editing" '+
		    'name="'+propertyDisplay.property+'" ' +
		    getValidationDirectives(propertyDisplay)+
		    'id="swinput'+utilityService.createID(26)+'"'+
			' />';
		}
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