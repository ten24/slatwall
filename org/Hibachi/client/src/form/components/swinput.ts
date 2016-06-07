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
            $hibachi,
			utilityService,
            rbkeyService,
			fileService,
			$parse,
			$timeout
		)=>new SWInput(
			$log,
			$compile,
            $hibachi,
			utilityService,
            rbkeyService,
			fileService,
			$parse,
			$timeout
		);
		directive.$inject = [
			'$log',
			'$compile',
            '$hibachi',
			'utilityService',
            'rbkeyService',
			'fileService',
			'$parse',
			'$timeout'
		];
		return directive
	}
	constructor(
		$log,
		$compile,
        $hibachi,
		utilityService,
        rbkeyService,
		fileService,
		$parse,
		$timeout
	){
		var getValidationDirectives = function(propertyDisplay){
			var spaceDelimitedList = '';
			var name = propertyDisplay.property;
			var form = propertyDisplay.form.$$swFormInfo;
			$log.debug("Name is:" + name + " and form is: " + form);
            if(angular.isUndefined(propertyDisplay.object.validations )
                || angular.isUndefined(propertyDisplay.object.validations.properties)
                || angular.isUndefined(propertyDisplay.object.validations.properties[propertyDisplay.property])){
                return '';
            }
			var validations = propertyDisplay.object.validations.properties[propertyDisplay.property];
			$log.debug("Validations: ", validations);
            $log.debug(propertyDisplay.form.$$swFormInfo);
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

            var appConfig = $hibachi.getConfig();
            console.log('propertyDisplay', propertyDisplay);

            var placeholder ='';
            if(angular.isDefined(propertyDisplay.object.metaData[propertyDisplay.property].hb_nullrbkey)){
                placeholder = rbkeyService.getRBKey(propertyDisplay.object.metaData[propertyDisplay.property].hb_nullrbkey);
            }
           
			if(propertyDisplay.fieldType === 'text'){
				template = '<input type="text" class="form-control" '+
				    'ng-model="propertyDisplay.object.data[propertyDisplay.property]" '+
                    'ng-disabled="!propertyDisplay.editable" '+
                    'ng-show="propertyDisplay.editing" '+
                    'name="'+propertyDisplay.property+'" ' +
                    'placeholder="'+placeholder+'" '+
                    validations + currency +
                    'id="swinput'+utilityService.createID(26)+'"'+
                    ' />';
			}else if(propertyDisplay.fieldType === 'password'){
				template = '<input type="password" class="form-control" '+
                    'ng-model="propertyDisplay.object.data[propertyDisplay.property]" '+
                    'ng-disabled="!propertyDisplay.editable" '+
                    'ng-show="propertyDisplay.editing" '+
                    'name="'+propertyDisplay.property+'" ' +
                    'placeholder="'+placeholder+'" '+
                    validations +
                    'id="swinput'+utilityService.createID(26)+'"'+
                    ' />';
			} else if(propertyDisplay.fieldType === 'number'){
                template = '<input type="number" class="form-control" '+
                    'ng-model="propertyDisplay.object.data[propertyDisplay.property]" '+
                    'ng-disabled="!propertyDisplay.editable" '+
                    'ng-show="propertyDisplay.editing" '+
                    'name="'+propertyDisplay.property+'" ' +
                    'placeholder="'+placeholder+'" '+
                    validations +
                    'id="swinput'+utilityService.createID(26)+'"'+
                    ' />';
            } else if(propertyDisplay.fieldType === 'time'){
                template = '<input type="text" class="form-control" '+
                    'datetime-picker data-time-only="true" date-format="'+appConfig.timeFormat.replace('tt','a')+'" '+
                    'ng-model="propertyDisplay.object.data[propertyDisplay.property]" '+
                    'ng-disabled="!propertyDisplay.editable" '+
                    'ng-show="propertyDisplay.editing" '+
                    'name="'+propertyDisplay.property+'" ' +
                    'placeholder="'+placeholder+'" '+
                    validations +
                    'id="swinput'+utilityService.createID(26)+'"'+
                    ' />';
            } else if(propertyDisplay.fieldType === 'date'){
                template = '<input type="text" class="form-control" '+
                    'datetime-picker data-date-only="true" future-only date-format="'+appConfig.dateFormat+'" '+
                    'ng-model="propertyDisplay.object.data[propertyDisplay.property]" '+
                    'ng-disabled="!propertyDisplay.editable" '+
                    'ng-show="propertyDisplay.editing" '+
                    'name="'+propertyDisplay.property+'" ' +
                    'placeholder="'+placeholder+'" '+
                    validations +
                    'id="swinput'+utilityService.createID(26)+'"'+
                    ' />';
            } else if(propertyDisplay.fieldType === 'dateTime'){
                template = '<input type="text" class="form-control" '+
                    'datetime-picker '+ // date-format="MMM DD, YYYY hh:mm"
                    'ng-model="propertyDisplay.object.data[propertyDisplay.property]" '+
                    'ng-disabled="!propertyDisplay.editable" '+
                    'ng-show="propertyDisplay.editing" '+
                    'name="'+propertyDisplay.property+'" ' +
                    'placeholder="'+placeholder+'" '+
                    validations +
                    'id="swinput'+utilityService.createID(26)+'"'+
                    ' />';
            } else if(propertyDisplay.fieldType === 'file'){
				template = '<input type="file"' +
           				    'ng-model="propertyDisplay.object.data[swFormFieldFile.propertyDisplay.property]"' +
  		   					'ng-disabled="!propertyDisplay.editable"' +
  		   					'ng-show="propertyDisplay.editing"' +
  		   					'on-change="propertyDisplay.onChange"' + 
  		   					'name="propertyDisplay.property"' +
           					'class="form-control" />';
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
				//special file logic
				if(scope.propertyDisplay && scope.propertyDisplay.fieldType === 'file'){
					 var model = $parse("propertyDisplay.object.data[propertyDisplay.rawFileTarget]"); 
					 var modelSetter = model.assign;
					 element.bind("change", (e)=>{
						var fileToUpload = (e.srcElement || e.target).files[0];
						//console.log("rawFile",fileToUpload);
						scope.$apply(()=>{
							modelSetter(scope, fileToUpload);
						});
						$timeout(()=>{
							fileService.uploadFile(fileToUpload, scope.propertyDisplay.object, scope.propertyDisplay.binaryFileTarget).then(
								()=>{
									scope.propertyDisplay.object[scope.propertyDisplay.property] = fileToUpload;
								},
								()=>{
									//error	notify user
								});
						});
						
					 });
				}
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
