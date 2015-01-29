/**
 * This validate directive will look at the current element, figure out the context (save, edit, delete) and 
 * validate based on that context as defined in the validation properties object.
 */
'use strict';
angular.module('slatwalladmin').directive('swInput',

['$log',
 '$compile', 
 function(
	$log, 
	$compile
) {
	var getValidationDirectives = funciton(propertyDisplay){
		var spaceDelemitedList = '';
		
		//loop over validations that are required and create the space delimited list
		
		return spaceDelimitedList;
	}
	
	var getTemplate = function(propertyDisplay){
		var template = '';
		if(propertyDisplay.fieldType === 'text'){
			template = '<input type="text" class="form-control" '+
			'ng-model="propertyDisplay.object.data[propertyDisplay.property]" '+
		    'ng-disabled="!propertyDisplay.editable" '+ 
		    'ng-show="propertyDisplay.editing" '+
		    'name="'+propertyDisplay.property+'" '+
		    getValidationDirectives(propertyDisplay)+
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