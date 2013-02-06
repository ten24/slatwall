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
					logHibachi("The Validation File: #coreValidationFile# is not a valid JSON object");
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
			param name="validation.contexts" default="#arrayNew(1)#";
			param name="validation.properties" default="#structNew()#";
			
			// Add any custom contexts
			if(structKeyExists(customValidation, "contexts")) {
				for(var c=1; c<=arrayLen(customValidation.contexts); c++) {
					if(!arrayFindNoCase(validation.contexts, customValidation.contexts[c])) {
						arrayAppend(validation.contexts, customValidation.contexts[c]);
					}
				}
			}
			
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
			for(var property in validationStruct.properties) {
				for(var r=1; r<=arrayLen(validationStruct.properties[property]); r++) {
					var rule = validationStruct.properties[property][r];
					if(!structKeyExists(rule, "contexts") || listFindNoCase(rule.contexts, arguments.context)) {
						if(!structKeyExists(contextValidations, property)) {
							contextValidations[ property ] = {};
						}
						for(var constraint in rule) {
							if(constraint != "contexts") {
								contextValidations[ property ][ constraint ] = rule[ constraint ];
							}
						}
					}
				}
			}
			variables.validationByContextStructs["#arguments.object.getClassName()#-#arguments.context#"] = contextValidations;
		}
		return variables.validationByContextStructs["#arguments.object.getClassName()#-#arguments.context#"];
	}
	
	public any function validate(required any object, string context="", boolean setErrors=true) {
		// Setup an error bean
		if(setErrors) {
			var errorBean = arguments.object.getHibachiErrors();
		} else {
			var errorBean = getTransient("hibachiErrors");
		}
		
		// Get the valdiations for this context
		var contextValidations = getValidationsByContext(object=arguments.object, context=arguments.context);
		for(var propertyName in contextValidations) {
			if(arguments.object.hasProperty( propertyName )) {
				for(var constraint in contextValidations[ propertyName ]) {
					if(!structKeyExists(variables, "validate_#constraint#")) {
						throw("You have an error in the #arguments.object.getClassName()#.json validation file.  You have a constraint defined in one of your rules as '#constraint#' and that is not a valid constraint");
					}
					var isValid = invokeMethod("validate_#constraint#", {object=arguments.object, propertyName=propertyName, constraintValue=contextValidations[ propertyName ][ constraint ]});	
					
					if(!isValid) {
						errorBean.addError(propertyName, rbKey('validate.#arguments.object.getClassName()#.#propertyName#.#constraint#'));
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
	
	public boolean function validate_required(required any object, required string propertyName, boolean constraintValue=true) {
		var value = arguments.object.invokeMethod("get#arguments.propertyName#");
		if(!isNull(value) && len(value)) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_dataType(required any object, required string propertyName, required any constraintValue) {
		var value = arguments.object.invokeMethod("get#arguments.propertyName#");
		
		if(listFindNoCase("any,array,binary,boolean,component,creditCard,date,time,email,eurodate,float,numeric,guid,integer,query,range,regex,regular_expression,ssn,social_security_number,string,telephone,url,uuid,usdate,zipcode",arguments.constraintValue)) {
			if(isNull(value) || isValid("email", value)) {
				return true;
			}
		} else {
			throw("The validation file: #arguments.object.getClassName()#.json has an incorrect dataType constraint value of '#arguments.constraintValue#' for one of it's properties.  Valid values are: any,array,binary,boolean,component,creditCard,date,time,email,eurodate,float,numeric,guid,integer,query,range,regex,regular_expression,ssn,social_security_number,string,telephone,url,uuid,usdate,zipcode");
		}
		
		return false;
	}
	
	public boolean function validate_minValue(required any object, required string propertyName, required numeric constraintValue) {
		var value = arguments.object.invokeMethod("get#arguments.propertyName#");
		if(isNull(propertyValue) || (isNumeric(propertyValue) && propertyValue >= arguments.constraintValue) ) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_maxValue(required any object, required string propertyName, required numeric constraintValue) {
		var propertyValue = arguments.object.invokeMethod("get#arguments.propertyName#");
		if(isNull(propertyValue) || (isNumeric(propertyValue) && propertyValue <= arguments.constraintValue) ) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_minLength(required any object, required string propertyName, required numeric constraintValue) {
		var propertyValue = arguments.object.invokeMethod("get#arguments.propertyName#");
		if(isNull(propertyValue) || (isSimpleValue(propertyValue) && len(propertyValue) >= arguments.constraintValue) ) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_maxLength(required any object, required string propertyName, required numeric constraintValue) {
		var propertyValue = arguments.object.invokeMethod("get#arguments.propertyName#");
		if(isNull(propertyValue) || (isSimpleValue(propertyValue) && len(propertyValue) <= arguments.constraintValue) ) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_minCollection(required any object, required string propertyName, required numeric constraintValue) {
		var propertyValue = arguments.object.invokeMethod("get#arguments.propertyName#");
		if(isNull(propertyValue) || (isArray(propertyValue) && arrayLen(propertyValue) >= arguments.constraintValue) || (isStruct(propertyValue) && structCount(propertyValue) >= arguments.constraintValue)) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_maxCollection(required any object, required string propertyName, required numeric constraintValue) {
		var propertyValue = arguments.object.invokeMethod("get#arguments.propertyName#");
		if(isNull(propertyValue) || (isArray(propertyValue) && arrayLen(propertyValue) <= arguments.constraintValue) || (isStruct(propertyValue) && structCount(propertyValue) <= arguments.constraintValue)) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_method(required any object, required string propertyName, required string constraintValue) {
		return arguments.object.invokeMethod(arguments.constraintValue);
	}
	
	public boolean function validate_lteProperty(required any object, required string propertyName, required string constraintValue) {
		var propertyValue = arguments.object.invokeMethod("get#arguments.propertyName#");
		var compairPropertyValue =  arguments.object.invokeMethod("get#arguments.constraintValue#");
		if(!isNull(propertyValue) && !isNull(compairPropertyValue) && propertyValue <= compairPropertyValue) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_ltProperty(required any object, required string propertyName, required string constraintValue) {
		var propertyValue = arguments.object.invokeMethod("get#arguments.propertyName#");
		var compairPropertyValue =  arguments.object.invokeMethod("get#arguments.constraintValue#");
		if(!isNull(propertyValue) && !isNull(compairPropertyValue) && propertyValue < compairPropertyValue) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_gteProperty(required any object, required string propertyName, required string constraintValue) {
		var propertyValue = arguments.object.invokeMethod("get#arguments.propertyName#");
		var compairPropertyValue =  arguments.object.invokeMethod("get#arguments.constraintValue#");
		if(!isNull(propertyValue) && !isNull(compairPropertyValue) && propertyValue >= compairPropertyValue) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_gtProperty(required any object, required string propertyName, required string constraintValue) {
		var propertyValue = arguments.object.invokeMethod("get#arguments.propertyName#");
		var compairPropertyValue =  arguments.object.invokeMethod("get#arguments.constraintValue#");
		if(!isNull(propertyValue) && !isNull(compairPropertyValue) && propertyValue > compairPropertyValue) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_eqProperty(required any object, required string propertyName, required string constraintValue) {
		var propertyValue = arguments.object.invokeMethod("get#arguments.propertyName#");
		var compairPropertyValue =  arguments.object.invokeMethod("get#arguments.constraintValue#");
		if(!isNull(propertyValue) && !isNull(compairPropertyValue) && propertyValue == compairPropertyValue) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_neqProperty(required any object, required string propertyName, required string constraintValue) {
		var propertyValue = arguments.object.invokeMethod("get#arguments.propertyName#");
		var compairPropertyValue =  arguments.object.invokeMethod("get#arguments.constraintValue#");
		if(!isNull(propertyValue) && !isNull(compairPropertyValue) && propertyValue != compairPropertyValue) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_inList(required any object, required string propertyName, required string constraintValue) {
		var propertyValue = arguments.object.invokeMethod("get#arguments.propertyName#");
		if(!isNull(propertyValue) && listFindNoCase(arguments.constraintValue, propertyValue)) {
			return true;
		}
		return false;
	}

}