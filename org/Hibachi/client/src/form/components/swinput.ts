/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/**
 * This validate directive will look at the current element, figure out the context (save, edit, delete) and
 * validate based on that context as defined in the validation properties object.
 */
class SWInput{
	public static Factory(){
		var directive = (
			$log,
			$compile,
			utilityService
		)=>new SWInput(
			$log,
			$compile,
			utilityService
		);
		directive.$inject = [
			'$log',
			'$compile',
			'utilityService'
		];
		return directive
	}
	constructor(
		$log,
		$compile,
		utilityService
	){
		var getValidationDirectives = function(propertyDisplay){
			var spaceDelimitedList = '';
			var name = propertyDisplay.property;
			var form = propertyDisplay.form.$$swFormInfo;
			$log.debug("Name is:" + name + " and form is: " + form);
			var validations = propertyDisplay.object.validations.properties[propertyDisplay.property];
			$log.debug("Validations: ", validations);
            $log.debug(propertyDisplay.form.$$swFormInfo)
			var validationsForContext = [];

			//get the form context and the form name.
			var formContext = propertyDisplay.form.$$swFormInfo.context;
			var formName = propertyDisplay.form.$$swFormInfo.name;
			$log.debug("Form context is: ");
			$log.debug(formContext);
			$log.debug("Form Name: ");
			$log.debug(formName);
			//get the validations for the current element.
			var propertyValidations = propertyDisplay.object.validations.properties[name];
			/*
			* Investigating why number inputs are not working.
			* */
			//check if the contexts match.
			if (angular.isObject(propertyValidations)){
				//if this is a procesobject validation then the context is implied
				if(angular.isUndefined(propertyValidations[0].contexts) && propertyDisplay.object.metaData.isProcessObject){
					propertyValidations[0].contexts = propertyDisplay.object.metaData.className.split('_')[1];
				}

				if (propertyValidations[0].contexts === formContext){
					$log.debug("Matched");
					for (var prop in propertyValidations[0]){
							if (prop != "contexts" && prop !== "conditions"){

								spaceDelimitedList += (" swvalidation" + prop.toLowerCase() + "='" + propertyValidations[0][prop] + "'");

							}
					}
				}
			$log.debug(spaceDelimitedList);
			}
			//loop over validations that are required and create the space delimited list
			$log.debug(validations);

			//get all validations related to the form context;
			$log.debug(form);
			$log.debug(propertyDisplay);
			angular.forEach(validations,function(validation,key){
				if(utilityService.listFind(validation.contexts.toLowerCase(),form.context.toLowerCase()) !== -1){
					$log.debug("Validations for context");
					$log.debug(validation);
					validationsForContext.push(validation);
				}
			});

			//now that we have all related validations for the specific form context that we are working with collection the directives we need
			//getValidationDirectiveByType();


			return spaceDelimitedList;
		};

		var getTemplate = function(propertyDisplay){
			var template = '';
			var validations = '';
            var currency = '';
			if(!propertyDisplay.noValidate){
				validations = getValidationDirectives(propertyDisplay);
			}
            if(propertyDisplay.object.metaData.$$getPropertyFormatType(propertyDisplay.property) == "currency"){
                currency = 'sw-currency-formatter ';
                if(angular.isDefined(propertyDisplay.object.data.currencyCode)){
                    currency = currency + 'data-currency-code="' + propertyDisplay.object.data.currencyCode + '" ';
                }
            }
           
			if(propertyDisplay.fieldType === 'text'){
				template = '<input type="text" class="form-control" '+
				'ng-model="propertyDisplay.object.data[propertyDisplay.property]" '+
				'ng-disabled="!propertyDisplay.editable" '+
				'ng-show="propertyDisplay.editing" '+
				'name="'+propertyDisplay.property+'" ' +
				validations + currency +
				'id="swinput'+utilityService.createID(26)+'"'+
				' />';
			}else if(propertyDisplay.fieldType === 'password'){
				template = '<input type="password" class="form-control" '+
				'ng-model="propertyDisplay.object.data[propertyDisplay.property]" '+
				'ng-disabled="!propertyDisplay.editable" '+
				'ng-show="propertyDisplay.editing" '+
				'name="'+propertyDisplay.property+'" ' +
				validations +
				'id="swinput'+utilityService.createID(26)+'"'+
				' />';
			} else if(propertyDisplay.fieldType === 'number'){
                template = '<input type="number" class="form-control" '+
				'ng-model="propertyDisplay.object.data[propertyDisplay.property]" '+
				'ng-disabled="!propertyDisplay.editable" '+
				'ng-show="propertyDisplay.editing" '+
				'name="'+propertyDisplay.property+'" ' +
				validations +
				'id="swinput'+utilityService.createID(26)+'"'+
				' />';
            }

			return template;
		};

		return {
			require:'^form',
			scope:{
				propertyDisplay:"=",
                type:"@?"
			},
			restrict : "E",
			//adding model and form controller
			link : function(scope, element, attr, formController) {
				//renders the template and compiles it
				element.html(getTemplate(scope.propertyDisplay));
				$compile(element.contents())(scope);
			}
		};
	}
}
export{
	SWInput
}
