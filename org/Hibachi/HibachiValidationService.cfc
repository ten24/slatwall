	component output="false" accessors="true" extends="HibachiService" {
	
	variables.validationStructs = {};
	variables.validationByContextStructs = {};
	
	public struct function getValidationStruct(required any object) {
		if(!structKeyExists(variables.validationStructs, arguments.object.getClassName())) {
			
			// Get CORE Validations
			var coreValidationFile = expandPath('/#getApplicationValue('applicationKey')#/model/validation/#arguments.object.getClassName()#.json'); 
			var validation = {};
			if(fileExists( coreValidationFile )) {
				var rawCoreJSON = fileRead( coreValidationFile );
				if(isJSON( rawCoreJSON )) {
					validation = deserializeJSON( rawCoreJSON );
				} else {
					throw("The Validation File: #coreValidationFile# is not a valid JSON object");
				}
			}
			
			// Get Custom Validations
			var customValidationFile = expandPath('/#getApplicationValue('applicationKey')#/custom/model/validation/#arguments.object.getClassName()#.json');
			var customValidation = {};
			if(fileExists( customValidationFile )) {
				var rawCustomJSON = fileRead( customValidationFile );
				if(isJSON( rawCustomJSON )) {
					customValidation = deserializeJSON( rawCustomJSON );
				} else {
					logHibachi("The Validation File: #customValidationFile# is not a valid JSON object");
				}
			}
			
			// Make sure that the validation struct has contexts & properties
			param name="validation.properties" default="#structNew()#";
			
			// Add any additional rules
			if(structKeyExists(customValidation, "properties")) {
				for(var key in customValidation.properties) {
					if(!structKeyExists(validation.properties, key)) {
						validation.properties[ key ] = customValidation.properties[ key ];
					} else {
						for(var r=1; r<=arrayLen(customValidation.properties[ key ]); r++) {
							arrayAppend(validation.properties[ key ],customValidation.properties[ key ][r]);	
						}
					}
				}
			}
			
			variables.validationStructs[ arguments.object.getClassName() ] = validation;
		}
		
		return variables.validationStructs[ arguments.object.getClassName() ];
	}
	
	public struct function getValidationsByContext(required any object, string context="") {
		
		if(!structKeyExists(variables.validationByContextStructs, "#arguments.object.getClassName()#-#arguments.context#")) {
			
			var contextValidations = {};
			var validationStruct = getValidationStruct(object=arguments.object);
			
			// Loop over each proeprty in the validation struct looking for rule structures
			for(var property in validationStruct.properties) {
				
				// For each array full of rules for the property, loop over them and check for the context
				for(var r=1; r<=arrayLen(validationStruct.properties[property]); r++) {
					
					var rule = validationStruct.properties[property][r];
					
					// Verify that either context doesn't exist, or that the context passed in is in the list of contexts for this rule
					if(!structKeyExists(rule, "contexts") || listFindNoCase(rule.contexts, arguments.context)) {
						
						if(!structKeyExists(contextValidations, property)) {
							contextValidations[ property ] = [];
						}
						
						for(var constraint in rule) {
							if(constraint != "contexts" && constraint != "conditions") {
								var constraintDetails = {
									constraintType=constraint,
									constraintValue=rule[ constraint ]
								};
								if(structKeyExists(rule, "conditions")) {
									constraintDetails.conditions = rule.conditions;
								}
								arrayAppend(contextValidations[ property ], constraintDetails);
							}
						}
					}
				}
			}
			variables.validationByContextStructs["#arguments.object.getClassName()#-#arguments.context#"] = contextValidations;
		}
		return variables.validationByContextStructs["#arguments.object.getClassName()#-#arguments.context#"];
	}
	
	public boolean function getConditionsMeetFlag( required any object, required string conditions) {
		
		var validationStruct = getValidationStruct(object=arguments.object);
		var conditionsArray = listToArray(arguments.conditions);
		
		// Loop over each condition to check if it is true
		for(var x=1; x<=arrayLen(conditionsArray); x++) {
			
			var conditionName = conditionsArray[x];
			
			// Make sure that the condition is defined in the meta data
			if(structKeyExists(validationStruct, "conditions") && structKeyExists(validationStruct.conditions, conditionName)) {
				
				var allConditionConstraintsMeet = true;
				
				// Loop over each propertyIdentifier for this condition
				for(var conditionPropertyIdentifier in validationStruct.conditions[ conditionName ]) {
					
					// Loop over each constraint for the property identifier to validate the constraint
					for(var constraint in validationStruct.conditions[ conditionName ][ conditionPropertyIdentifier ]) {
						if(structKeyExists(variables, "validate_#constraint#") && !invokeMethod("validate_#constraint#", {object=arguments.object, propertyIdentifier=conditionPropertyIdentifier, constraintValue=validationStruct.conditions[ conditionName ][ conditionPropertyIdentifier ][ constraint ]})) {
							allConditionConstraintsMeet = false;	
						}
					}
				}
				
				// If all constraints of this condition are meet, then we no that one condition is meet for this rule.
				if( allConditionConstraintsMeet ) {
					return true;
				}
			}
		}
		
		return false;
	}
	
	public any function getPopulatedPropertyValidationContext(required any object, required string propertyName, string originalContext="") {
		
		var validationStruct = getValidationStruct(object=arguments.object);
		
		if(structKeyExists(validationStruct, "populatedPropertyValidation") && structKeyExists(validationStruct.populatedPropertyValidation, arguments.propertyName)) {
			for(var v=1; v <= arrayLen(validationStruct.populatedPropertyValidation[arguments.propertyName]); v++) {
				var conditionsMeet = true;
				if(structKeyExists(validationStruct.populatedPropertyValidation[arguments.propertyName][v], "conditions")) {
					conditionsMeet = getConditionsMeetFlag(object=arguments.object, conditions=validationStruct.populatedPropertyValidation[arguments.propertyName][v].conditions);
				}
				if(conditionsMeet) {
					return validationStruct.populatedPropertyValidation[arguments.propertyName][v].validate;
				}
			}

		}
		
		return arguments.originalContext;
	}
	
	public any function validate(required any object, string context="", boolean setErrors=true) {
		// Setup an error bean
		if(setErrors) {
			var errorBean = arguments.object.getHibachiErrors();
		} else {
			var errorBean = getTransient("hibachiErrors");
		}
		
		// If the context was 'false' then we don't do any validation
		if(!isBoolean(arguments.context) || arguments.context) {
			
			// Get the valdiations for this context
			var contextValidations = getValidationsByContext(object=arguments.object, context=arguments.context);
			
			// Loop over each property in the validations for this context
			for(var propertyIdentifier in contextValidations) {
				
				// First make sure that the proerty exists
				if(arguments.object.hasProperty( propertyIdentifier )) {
					
					// Loop over each of the constraints for this given property
					for(var c=1; c<=arrayLen(contextValidations[ propertyIdentifier ]); c++) {
						
						// Check that one of the conditions were meet if there were conditions for this constraint
						var conditionMeet = true;
						if(structKeyExists(contextValidations[ propertyIdentifier ][c], "conditions")) {
							conditionMeet = getConditionsMeetFlag( object=arguments.object, conditions=contextValidations[ propertyIdentifier ][ c ].conditions );
						}
						
						// Now if a condition was meet we can actually test the individual validation rule
						if(conditionMeet) {
							validateConstraint(object=arguments.object, propertyIdentifier=propertyIdentifier, constraintDetails=contextValidations[ propertyIdentifier ][c], errorBean=errorBean, context=arguments.context);	
						}
					}	
				}
			}
		}
		
		// If the setErrors was true, then we can set this error
		if(setErrors) {
			arguments.object.setHibachiErrors( errorBean );
		}
		
		return errorBean;
	}
	
	
	public any function validateConstraint(required any object, required string propertyIdentifier, required struct constraintDetails, required any errorBean, required string context) {
		if(!structKeyExists(variables, "validate_#arguments.constraintDetails.constraintType#")) {
			throw("You have an error in the #arguments.object.getClassName()#.json validation file.  You have a constraint defined for '#arguments.propertyIdentifier#' that is called '#arguments.constraintDetails.constraintType#' which is not a valid constraint type");
		}
		
		var isValid = invokeMethod("validate_#arguments.constraintDetails.constraintType#", {object=arguments.object, propertyIdentifier=arguments.propertyIdentifier, constraintValue=arguments.constraintDetails.constraintValue});	
					
		if(!isValid) {
			var thisPropertyName = listLast(arguments.propertyIdentifier, '.');
			
			var replaceTemplateStruct = {};
			replaceTemplateStruct.propertyName = arguments.object.getPropertyTitle(thisPropertyName);
			if(arguments.object.isPersistent()) {
				var thisClassName = getLastEntityNameInPropertyIdentifier( arguments.object.getClassName(), arguments.propertyIdentifier);
				replaceTemplateStruct.className = getHibachiScope().rbKey('entity.#thisClassName#');
			} else {
				var thisClassName = arguments.object.getClassName();
				replaceTemplateStruct.className = getHibachiScope().rbKey('processObject.#thisClassName#');
			}
			replaceTemplateStruct.constraintValue = arguments.constraintDetails.constraintValue;
			
			if(arguments.constraintDetails.constraintType eq "method") {
				var errorMessage = getHibachiScope().rbKey('validate.#arguments.context#.#thisClassName#.#thisPropertyName#.#arguments.constraintDetails.constraintValue#');
				errorMessage = getHibachiUtilityService().replaceStringTemplate(errorMessage, replaceTemplateStruct);
				arguments.errorBean.addError(arguments.propertyIdentifier, errorMessage);
			} else if (arguments.constraintDetails.constraintType eq "dataType") {
				var errorMessage = getHibachiScope().rbKey('validate.#arguments.context#.#thisClassName#.#thisPropertyName#.#arguments.constraintDetails.constraintType#.#arguments.constraintDetails.constraintValue#');
				errorMessage = getHibachiUtilityService().replaceStringTemplate(errorMessage, replaceTemplateStruct);
				arguments.errorBean.addError(arguments.propertyIdentifier, errorMessage);
			} else {
				var errorMessage = getHibachiScope().rbKey('validate.#arguments.context#.#thisClassName#.#thisPropertyName#.#arguments.constraintDetails.constraintType#');
				errorMessage = getHibachiUtilityService().replaceStringTemplate(errorMessage, replaceTemplateStruct);
				arguments.errorBean.addError(arguments.propertyIdentifier, errorMessage);
			}
		}
	}
	
	
	// ================================== VALIDATION CONSTRAINT LOGIC ===========================================
	
	public boolean function validate_required(required any object, required string propertyIdentifier, boolean constraintValue=true) {
		var propertyValue = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier ).invokeMethod("get#listLast(arguments.propertyIdentifier,'.')#");
		if(!isNull(propertyValue) && (isObject(propertyValue) || (isArray(propertyValue) && arrayLen(propertyValue)) || (isStruct(propertyValue) && structCount(propertyValue)) || (isSimpleValue(propertyValue) && len(trim(propertyValue))))) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_null(required any object, required string propertyIdentifier, boolean constraintValue) {
		var propertyObject = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier );
		if(!isNull(propertyObject)) {
			var propertyValue = propertyObject.invokeMethod("get#listLast(arguments.propertyIdentifier,'.')#");	
		}
		if(isNull(propertyValue) && arguments.constraintValue) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_dataType(required any object, required string propertyIdentifier, required any constraintValue) {
		var propertyObject = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier );
		if(!isNull(propertyObject)) {
			var propertyValue = propertyObject.invokeMethod("get#listLast(arguments.propertyIdentifier,'.')#");	
		}
		
		// Standard Validation DataTypes
		if(listFindNoCase("any,array,binary,boolean,component,date,time,email,eurodate,float,numeric,guid,integer,query,range,regex,regular_expression,ssn,social_security_number,string,telephone,url,uuid,usdate,zipcode",arguments.constraintValue)) {
			if(isNull(propertyValue) || isValid(arguments.constraintValue, propertyValue)) {
				return true;
			}
			
		// Custom CreditCardNumber DataTypes
		} else if(listFindNoCase("creditCard,creditCardNumber",arguments.constraintValue)) {
			if(isNull(propertyValue)) {
				return true;
			}
			if(len(propertyValue) && isNumeric(propertyValue)) {
				var nDigits = len(propertyValue);
				var parity = nDigits MOD 2;
				var digit = "";
				var sum = 0;
				
				for(var i=0; i <= nDigits - 1; i=i+1) {
					digit = mid(propertyValue, i+1, 1);
					if ((i MOD 2) == parity) {
						digit = digit * 2;
						if (digit > 9) {
							digit = digit - 9;
						}
					}
					sum = sum + digit;
				}
				if (Not sum MOD 10){
					return true;
				}
			}
			return false;
		} else {
			throw("The validation file: #arguments.object.getClassName()#.json has an incorrect dataType constraint value of '#arguments.constraintValue#' for one of it's properties.  Valid values are: any,array,binary,boolean,component,creditCard,date,time,email,eurodate,float,numeric,guid,integer,query,range,regex,regular_expression,ssn,social_security_number,string,telephone,url,uuid,usdate,zipcode");
		}
		
		return false;
	}
	
	public boolean function validate_minValue(required any object, required string propertyIdentifier, required numeric constraintValue) {
		var propertyObject = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier );
		if(!isNull(propertyObject)) {
			var propertyValue = propertyObject.invokeMethod("get#listLast(arguments.propertyIdentifier,'.')#");	
		}
		if(isNull(propertyValue) || (isNumeric(propertyValue) && propertyValue >= arguments.constraintValue) ) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_maxValue(required any object, required string propertyIdentifier, required numeric constraintValue) {
		var propertyObject = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier );
		if(!isNull(propertyObject)) {
			var propertyValue = propertyObject.invokeMethod("get#listLast(arguments.propertyIdentifier,'.')#");	
		}
		if(isNull(propertyValue) || (isNumeric(propertyValue) && propertyValue <= arguments.constraintValue) ) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_minLength(required any object, required string propertyIdentifier, required numeric constraintValue) {
		var propertyObject = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier );
		if(!isNull(propertyObject)) {
			var propertyValue = propertyObject.invokeMethod("get#listLast(arguments.propertyIdentifier,'.')#");	
		}
		if(isNull(propertyValue) || (isSimpleValue(propertyValue) && len(trim(propertyValue)) >= arguments.constraintValue) ) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_maxLength(required any object, required string propertyIdentifier, required numeric constraintValue) {
		var propertyObject = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier );
		if(!isNull(propertyObject)) {
			var propertyValue = propertyObject.invokeMethod("get#listLast(arguments.propertyIdentifier,'.')#");	
		}
		if(isNull(propertyValue) || (isSimpleValue(propertyValue) && len(trim(propertyValue)) <= arguments.constraintValue) ) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_minCollection(required any object, required string propertyIdentifier, required numeric constraintValue) {
		var propertyObject = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier );
		if(!isNull(propertyObject)) {
			var propertyValue = propertyObject.invokeMethod("get#listLast(arguments.propertyIdentifier,'.')#");	
		}
		if(isNull(propertyValue) || (isArray(propertyValue) && arrayLen(propertyValue) >= arguments.constraintValue) || (isStruct(propertyValue) && structCount(propertyValue) >= arguments.constraintValue)) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_maxCollection(required any object, required string propertyIdentifier, required numeric constraintValue) {
		var propertyObject = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier );
		if(!isNull(propertyObject)) {
			var propertyValue = propertyObject.invokeMethod("get#listLast(arguments.propertyIdentifier,'.')#");	
		}
		if(isNull(propertyValue) || (isArray(propertyValue) && arrayLen(propertyValue) <= arguments.constraintValue) || (isStruct(propertyValue) && structCount(propertyValue) <= arguments.constraintValue)) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_minList(required any object, required string propertyIdentifier, required numeric constraintValue) {
		var propertyObject = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier );
		if(!isNull(propertyObject)) {
			var propertyValue = propertyObject.invokeMethod("get#listLast(arguments.propertyIdentifier,'.')#");	
		}
		if((!isNull(propertyValue) && isSimpleValue(propertyValue) && listLen(propertyValue) >= arguments.constraintValue) || (isNull(propertyValue) && arguments.constraintValue == 0)) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_maxList(required any object, required string propertyIdentifier, required numeric constraintValue) {
		var propertyObject = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier );
		if(!isNull(propertyObject)) {
			var propertyValue = propertyObject.invokeMethod("get#listLast(arguments.propertyIdentifier,'.')#");	
		}
		if((!isNull(propertyValue) && isSimpleValue(propertyValue) && listLen(propertyValue) <= arguments.constraintValue) || (isNull(propertyValue) && arguments.constraintValue == 0)) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_method(required any object, required string propertyIdentifier, required string constraintValue) {
		return arguments.object.invokeMethod(arguments.constraintValue);
	}
	
	public boolean function validate_lte(required any object, required string propertyIdentifier, required string constraintValue) {
		var propertyObject = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier );
		if(!isNull(propertyObject)) {
			var propertyValue = propertyObject.invokeMethod("get#listLast(arguments.propertyIdentifier,'.')#");	
		}
		if(!isNull(propertyValue) && propertyValue <= arguments.constraintValue) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_lt(required any object, required string propertyIdentifier, required string constraintValue) {
		var propertyObject = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier );
		if(!isNull(propertyObject)) {
			var propertyValue = propertyObject.invokeMethod("get#listLast(arguments.propertyIdentifier,'.')#");	
		}
		if(!isNull(propertyValue) && propertyValue < arguments.constraintValue) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_gte(required any object, required string propertyIdentifier, required string constraintValue) {
		var propertyObject = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier );
		if(!isNull(propertyObject)) {
			var propertyValue = propertyObject.invokeMethod("get#listLast(arguments.propertyIdentifier,'.')#");	
		}
		if(!isNull(propertyValue) && propertyValue >= arguments.constraintValue) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_gt(required any object, required string propertyIdentifier, required string constraintValue) {
		var propertyObject = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier );
		if(!isNull(propertyObject)) {
			var propertyValue = propertyObject.invokeMethod("get#listLast(arguments.propertyIdentifier,'.')#");	
		}
		if(!isNull(propertyValue) && propertyValue > arguments.constraintValue) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_gtNow(required any object, required string propertyIdentifier, required string constraintValue) {
		var propertyObject = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier );
		if(!isNull(propertyObject)) {
			var propertyValue = propertyObject.invokeMethod("get#listLast(arguments.propertyIdentifier,'.')#");	
		}
		if(!isNull(propertyValue) && dateCompare(propertyValue, now()) eq 1) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_ltNow(required any object, required string propertyIdentifier, required string constraintValue) {
		var propertyObject = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier );
		if(!isNull(propertyObject)) {
			var propertyValue = propertyObject.invokeMethod("get#listLast(arguments.propertyIdentifier,'.')#");	
		}
		if(!isNull(propertyValue) && dateCompare(propertyValue, now()) eq -1) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_eq(required any object, required string propertyIdentifier, required string constraintValue) {
		var propertyObject = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier );
		if(!isNull(propertyObject)) {
			var propertyValue = propertyObject.invokeMethod("get#listLast(arguments.propertyIdentifier,'.')#");	
		}
		if(!isNull(propertyValue) && !isNull(propertyValue) && propertyValue == arguments.constraintValue) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_neq(required any object, required string propertyIdentifier, required string constraintValue) {
		var propertyObject = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier );
		if(!isNull(propertyObject)) {
			var propertyValue = propertyObject.invokeMethod("get#listLast(arguments.propertyIdentifier,'.')#");	
		}
		if(!isNull(propertyValue) && propertyValue != arguments.constraintValue) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_lteProperty(required any object, required string propertyIdentifier, required string constraintValue) {
		var propertyObject = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier );
		if(!isNull(propertyObject)) {
			var propertyValue = propertyObject.invokeMethod("get#listLast(arguments.propertyIdentifier,'.')#");	
		}
		var comparePropertyObject = arguments.object.getLastObjectByPropertyIdentifier( arguments.constraintValue );
		if(!isNull(comparePropertyObject)) {
			var comparePropertyValue = comparePropertyObject.invokeMethod("get#listLast(arguments.constraintValue,'.')#");	
		}
		if(!isNull(propertyValue) && !isNull(comparePropertyValue) && propertyValue <= comparePropertyValue) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_ltProperty(required any object, required string propertyIdentifier, required string constraintValue) {
		var propertyObject = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier );
		if(!isNull(propertyObject)) {
			var propertyValue = propertyObject.invokeMethod("get#listLast(arguments.propertyIdentifier,'.')#");	
		}
		var comparePropertyObject = arguments.object.getLastObjectByPropertyIdentifier( arguments.constraintValue );
		if(!isNull(comparePropertyObject)) {
			var comparePropertyValue = comparePropertyObject.invokeMethod("get#listLast(arguments.constraintValue,'.')#");	
		}
		if(!isNull(propertyValue) && !isNull(comparePropertyValue) && propertyValue < comparePropertyValue) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_gteProperty(required any object, required string propertyIdentifier, required string constraintValue) {
		var propertyObject = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier );
		if(!isNull(propertyObject)) {
			var propertyValue = propertyObject.invokeMethod("get#listLast(arguments.propertyIdentifier,'.')#");	
		}
		var comparePropertyObject = arguments.object.getLastObjectByPropertyIdentifier( arguments.constraintValue );
		if(!isNull(comparePropertyObject)) {
			var comparePropertyValue = comparePropertyObject.invokeMethod("get#listLast(arguments.constraintValue,'.')#");	
		}
		if(!isNull(propertyValue) && !isNull(comparePropertyValue) && propertyValue >= comparePropertyValue) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_gtProperty(required any object, required string propertyIdentifier, required string constraintValue) {
		var propertyObject = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier );
		if(!isNull(propertyObject)) {
			var propertyValue = propertyObject.invokeMethod("get#listLast(arguments.propertyIdentifier,'.')#");	
		}
		var comparePropertyObject = arguments.object.getLastObjectByPropertyIdentifier( arguments.constraintValue );
		if(!isNull(comparePropertyObject)) {
			var comparePropertyValue = comparePropertyObject.invokeMethod("get#listLast(arguments.constraintValue,'.')#");	
		}
		if(!isNull(propertyValue) && !isNull(comparePropertyValue) && propertyValue > comparePropertyValue) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_eqProperty(required any object, required string propertyIdentifier, required string constraintValue) {
		var propertyObject = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier );
		if(!isNull(propertyObject)) {
			var propertyValue = propertyObject.invokeMethod("get#listLast(arguments.propertyIdentifier,'.')#");	
		}
		var comparePropertyObject = arguments.object.getLastObjectByPropertyIdentifier( arguments.constraintValue );
		if(!isNull(comparePropertyObject)) {
			var comparePropertyValue = comparePropertyObject.invokeMethod("get#listLast(arguments.constraintValue,'.')#");	
		}
		if((isNull(propertyValue) && isNull(comparePropertyValue)) || (!isNull(propertyValue) && !isNull(comparePropertyValue) && propertyValue == comparePropertyValue)) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_neqProperty(required any object, required string propertyIdentifier, required string constraintValue) {
		var propertyObject = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier );
		if(!isNull(propertyObject)) {
			var propertyValue = propertyObject.invokeMethod("get#listLast(arguments.propertyIdentifier,'.')#");	
		}
		var comparePropertyObject = arguments.object.getLastObjectByPropertyIdentifier( arguments.constraintValue );
		if(!isNull(comparePropertyObject)) {
			var comparePropertyValue = comparePropertyObject.invokeMethod("get#listLast(arguments.constraintValue,'.')#");	
		}
		if(!isNull(propertyValue) && !isNull(comparePropertyValue) && propertyValue != comparePropertyValue) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_gtDateTimeProperty(required any object, required string propertyIdentifier, required string constraintValue) {
		var propertyObject = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier );
		if(!isNull(propertyObject)) {
			var propertyValue = propertyObject.invokeMethod("get#listLast(arguments.propertyIdentifier,'.')#");	
		}
		var comparePropertyObject = arguments.object.getLastObjectByPropertyIdentifier( arguments.constraintValue );
		if(!isNull(comparePropertyObject)) {
			var comparePropertyValue = comparePropertyObject.invokeMethod("get#listLast(arguments.constraintValue,'.')#");	
		}
		if(!isNull(propertyValue) && !isNull(comparePropertyValue) && (dateCompare(propertyValue, comparePropertyValue,"n")==1)) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_ltDateTimeProperty(required any object, required string propertyIdentifier, required string constraintValue) {
		var propertyObject = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier );
		if(!isNull(propertyObject)) {
			var propertyValue = propertyObject.invokeMethod("get#listLast(arguments.propertyIdentifier,'.')#");	
		}
		var comparePropertyObject = arguments.object.getLastObjectByPropertyIdentifier( arguments.constraintValue );
		if(!isNull(comparePropertyObject)) {
			var comparePropertyValue = comparePropertyObject.invokeMethod("get#listLast(arguments.constraintValue,'.')#");	
		}
		if(!isNull(propertyValue) && !isNull(comparePropertyValue) && (dateCompare(propertyValue, comparePropertyValue)==-1)) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_inList(required any object, required string propertyIdentifier, required string constraintValue) {
		var propertyObject = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier );
		if(!isNull(propertyObject)) {
			var propertyValue = propertyObject.invokeMethod("get#listLast(arguments.propertyIdentifier,'.')#");	
		}
		if(!isNull(propertyValue) && listFindNoCase(arguments.constraintValue, propertyValue)) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_unique(required any object, required string propertyIdentifier, boolean constraintValue=true) {
		var propertyObject = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier );
		return getHibachiDAO().isUniqueProperty(propertyName=listLast(arguments.propertyIdentifier,'.'), entity=propertyObject);
	}
	
	public boolean function validate_uniqueOrNull(required any object, required string propertyIdentifier, boolean constraintValue=true) {
		var propertyObject = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier );
		if(!isNull(propertyObject)) {
			var propertyValue = propertyObject.invokeMethod("get#listLast(arguments.propertyIdentifier,'.')#");	
		}
		if(isNull(propertyValue)) {
			return true;
		}
		return getHibachiDAO().isUniqueProperty(propertyName=listLast(arguments.propertyIdentifier,'.'), entity=uniqueObject);
	}
	
	public boolean function validate_regex(required any object, required string propertyIdentifier, required string constraintValue) {
		var propertyObject = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier );
		if(!isNull(propertyObject)) {
			var propertyValue = propertyObject.invokeMethod("get#listLast(arguments.propertyIdentifier,'.')#");	
		}
		if(isNull(propertyValue) || isValid("regex", propertyValue, arguments.constraintValue)) {
			return true;
		}
		return false;
	}

}
