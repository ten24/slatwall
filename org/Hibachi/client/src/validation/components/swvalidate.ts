/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/**
 * This validate directive will look at the current element, figure out the context (save, edit, delete) and 
 * validate based on that context as defined in the validation properties object.
 */
// 'use strict';
// angular.module('slatwalladmin').directive('swValidate',

// [ '$log','$hibachi', function($log, $hibachi) {
class SWValidate{
	public static Factory(){
		var directive = ($log, $hibachi)=>new SWValidate($log, $hibachi);
		directive.$inject = ['$log', '$hibachi'];
		return directive;
	}
	constructor($log, $hibachi){
		return {
			
			restrict : "A",
			require : '^ngModel',
			link : function(scope, elem, attr, ngModel) {
				
				//Define our contexts and validation property enums.
				var ContextsEnum  = {
							SAVE: {name: "save", value: 0},
							DELETE: {name: "delete", value: 1},
							EDIT: {name: "edit", value: 2}
				};
				var ValidationPropertiesEnum = {
						REGEX: {name: "regex", value: 0},
						MIN_VALUE: {name: "minValue", value: 1},
						MAX_VALUE: {name: "maxValue", value: 2},
						EQ: {name: "eq", value: 3},
						NEQ: {name: "neq", value: 4},
						UNIQUE: {name: "unique", value: 5},
						LTE: {name: "lte", value: 6},
						GTE: {name: "gte", value: 7},
						MIN_LENGTH: {name: "minLength", value: 8},
						MAX_LENGTH: {name: "maxLength", value: 9},
						DATA_TYPE: {name: "dataType", value: 10},
						REQUIRED: {name: "required", value: 11}
				};
				
				
				scope.validationPropertiesEnum = ValidationPropertiesEnum;
				scope.contextsEnum = ContextsEnum;
				
				var myCurrentContext = scope.contextsEnum.SAVE; //We are only checking the save context right now.
				var contextNamesArray = getNamesFromObject(ContextsEnum); //Convert for higher order functions.
				var validationPropertiesArray = getNamesFromObject(ValidationPropertiesEnum);	 //Convert for higher order functions.
				var validationObject = scope.propertyDisplay.object.validations.properties;//Get the scope validation object.
				var errors = scope.propertyDisplay.errors;
				var errorMessages = [];
				var failFlag = 0;
				
				/**
				* Iterates over the validation object looking for the current elements validations, maps that to a validation function list
				* and calls those validate functions. When a validation fails, an error is set, the elements border turns red.
				*/
				function validate(name, context, elementValue) {
					var validationResults:any = {};
					validationResults = {"name": "name", "context": "context", "required": "required", "error": "none", "errorkey": "none"};
					
									for ( var key in validationObject) {
										// Look for the current attribute in the
										// validation parameters.
										if (key === name || key === name + "Flag") {
											
											// Now that we have found the current
											// validation parameters, iterate
											// through them looking for
											// the required parameters that match
											// the current page context (save,
											// delete, etc.)
											for ( var inner in validationObject[key]) {
												var required = validationObject[key][inner].required || "false"; // Get
																										// the
																										// required
																										// value
												
												var context = validationObject[key][inner].contexts || "none"; // Get
																										// the
																										// element
																										// context
												
												//Setup the validation results object to pass back to caller.
												validationResults = {"name": key, "context": context, "required": required, "error": "none", "errorkey": "none"};
												
												var elementValidationArr = map(
														checkHasValidationType,
														validationPropertiesArray,
														validationObject[key][inner]);
	
												
												
												//Iterate over the array and call the validate function if it has that property.
												for (var i = 0; i < elementValidationArr.length; i++) {
													
													if (elementValidationArr[i] == true) {
														
														if (validationPropertiesArray[i] === "regex" && elementValue !== ""){//If element is zero, need to check required 
															//Get the regex string to match and send to validation function.
															var re = validationObject[key][inner].regex;
															var result = validate_RegExp(elementValue, re);//true if pattern match, fail otherwise.
	
															if (result != true) {
																
																errorMessages
																		.push("Invalid input");
																validationResults.error = errorMessages[errorMessages.length - 1];
																validationResults.errorkey = "invalid-" + ValidationPropertiesEnum["REGEX"].name;
																validationResults.fail = true;
															}else{
																errorMessages
																.push("Valid input");
																validationResults.error = errorMessages[errorMessages.length - 1];
																validationResults.errorkey = "invalid-" + ValidationPropertiesEnum["REGEX"].name;
																validationResults.fail = false;
															}
														return validationResults;
														}
														if(validationPropertiesArray[i] === "minValue"){
															
															var validationMinValue = validationObject[key][inner].minValue;
															$log.debug(validationMinValue);
															var result = validate_MinValue(elementValue, validationMinValue);
															$log.debug("e>v" + result + " :" + elementValue, ":" + validationMinValue );
															if (result != true) {
																errorMessages
																		.push("Minimum value is: "
																				+ validationMinValue);
																validationResults.error = errorMessages[errorMessages.length - 1];
																validationResults.errorkey = "invalid-" + ValidationPropertiesEnum["MIN_VALUE"].name;
																validationResults.fail = true;
	
																}else{
																	validationResults.error = errorMessages[errorMessages.length - 1];
																	validationResults.errorkey = "invalid-" + ValidationPropertiesEnum["MIN_VALUE"].name;
																	validationResults.fail = false;
																}
															return validationResults;
														}
														if(validationPropertiesArray[i] === "maxValue"){
															var validationMaxValue = validationObject[key][inner].maxValue;
															var result = validate_MaxValue(elementValue, validationMaxValue);
															$log.debug("Max Value result is: " + result);
															if (result != true) {
																errorMessages
																		.push("Maximum value is: "
																				+ validationMaxValue);
																validationResults.error = errorMessages[errorMessages.length - 1];
																validationResults.errorkey = "invalid-" + ValidationPropertiesEnum["MAX_VALUE"].name;
																validationResults.fail = true;
															}
															return validationResults;
														}
														if(validationPropertiesArray[i] === "minLength"){
															var validationMinLength = validationObject[key][inner].minLength;
															var result = validate_MinLength(elementValue, validationMinLength);
															$log.debug("Min Length result is: " + result);
															if (result != true) {
																errorMessages
																		.push("Minimum length must be: "
																				+ validationMinLength);
																validationResults.error = errorMessages[errorMessages.length - 1];
																validationResults.errorkey = "invalid-" + ValidationPropertiesEnum["MIN_LENGTH"].name;
																validationResults.fail = true;
															}
															return validationResults;
														}
														if(validationPropertiesArray[i] === "maxLength"){
															var validationMaxLength = validationObject[key][inner].maxLength;
															var result = validate_MaxLength(elementValue, validationMaxLength);
															$log.debug("Max Length result is: " + result);
															if (result != true) {
																errorMessages
																		.push("Maximum length is: "
																				+ validationMaxLength);
																validationResults.error = errorMessages[errorMessages.length - 1];
																validationResults.errorkey = "invalid-" + ValidationPropertiesEnum["MAX_LENGTH"].name;
																validationResults.fail = true;
															}
															return validationResults;
														}
														if(validationPropertiesArray[i] === "eq"){
															var validationEq = validationObject[key][inner].eq;
															var result = validate_Eq(elementValue, validationEq);
															if (result != true) {
																errorMessages
																		.push("Must equal "
																				+ validationEq);
																validationResults.error = errorMessages[errorMessages.length - 1];
																validationResults.errorkey = "invalid-" + ValidationPropertiesEnum["EQ"].name;
																validationResults.fail = true;
															}
															return validationResults;
														}
														if(validationPropertiesArray[i] === "neq"){
															var validationNeq = validationObject[key][inner].neq;
															var result = validate_Neq(elementValue, validationNeq);
															if (result != true) {
																errorMessages
																		.push("Must not equal: "
																				+ validationNeq);
																validationResults.error = errorMessages[errorMessages.length - 1];
																validationResults.errorkey = "invalid-" + ValidationPropertiesEnum["NEQ"].name;
																validationResults.fail = true;
															}
															return validationResults;
														}
														if(validationPropertiesArray[i] === "lte"){
															var validationLte = validationObject[key][inner].lte;
															var result = validate_Lte(elementValue, validationLte);
															if (result != true) {
																errorMessages
																		.push("Must be less than "
																				+ validationLte);
																validationResults.error = errorMessages[errorMessages.length - 1];
																validationResults.errorkey = "invalid-" + ValidationPropertiesEnum["LTE"].name;
																validationResults.fail = true;
															}
															return validationResults;
														}
														if(validationPropertiesArray[i] === "gte"){
															var validationGte = validationObject[key][inner].gte;
															var result = validate_Gte(elementValue, validationGte);
															if (result != true) {
																errorMessages
																		.push("Must be greater than: "
																				+ validationGte);
																validationResults.error = errorMessages[errorMessages.length - 1];
																validationResults.errorkey = "invalid-" + ValidationPropertiesEnum["GTE"].name;
																validationResults.fail = true;
															}
															
															return validationResults;
														}
														if(validationPropertiesArray[i] === "required"){
															var validationRequire = validationObject[key][inner].require;
															var result = validate_Required(elementValue, validationRequire);
															if (result != true) {
																errorMessages
																		.push("Required");
																validationResults.error = errorMessages[errorMessages.length - 1];
																validationResults.errorkey = ValidationPropertiesEnum["REQUIRED"].name;
																validationResults.fail = true;
															}else{
																errorMessages
																.push("Required");
																validationResults.error = errorMessages[errorMessages.length - 1];
																validationResults.errorkey = ValidationPropertiesEnum["REQUIRED"].name;
																validationResults.fail = false;
															}
															
															return validationResults;
														}
													}
												}
											}
										} 
										}//<---end validate.			
	}
				/**
				* Function to map if we need a validation on this element.
				*/
				function checkHasValidationType(validationProp, validationType){
					if (validationProp[validationType] != undefined) {
						return true;
						}else{
							return false;
						}
				}
				
				/**
				* Iterates over the properties object finding which types of validation are needed.
				*/
				function map(func, array, obj) {
					var result = [];
					forEach(array, function (element) {
						result.push(func(obj, element));
					});
					return result;
				}
				
				/**
				* Array iteration helper. 
				*/
				function forEach(array, action) {
					for (var i = 0; i < array.length; i++)
						action(array[i]);
				}
				
				/**
				* Helper function to read all the names in our enums into an array that the higher order functions can use.
				*/
				function getNamesFromObject(obj){
					var result = [];
					for (var i in obj){
						var name = obj[i].name || "stub";
						result.push(name);
					}
					return result;
				}	
				
				/**
				* Tests the value for a RegExp match given by the pattern string. 
				* Validates true if pattern match, false otherwise.
				*/
				function validate_RegExp(value, pattern){
					var regex = new RegExp(pattern);
					if (regex.test(value)){
						return true;
					}
					return false;
				}
				
				/**
				* Validates true if userValue >= minValue (inclusive)
				*/
				function validate_MinValue(userValue, minValue){
					return (userValue >= minValue);
				}
				
				/**
				* Validates true if userValue <= maxValue (inclusive)
				*/
				function validate_MaxValue(userValue, maxValue){
					return (userValue <= maxValue) ? true : false;
				}
				
				/**
				* Validates true if length of the userValue >= minLength (inclusive)
				*/
				function validate_MinLength(userValue, minLength){
					return (userValue.length >= minLength) ? true : false;
				}
				
				/**
				* Validates true if length of the userValue <= maxLength (inclusive)
				*/
				function validate_MaxLength(userValue, maxLength){
					return (userValue.length <= maxLength) ? true : false;
				}
				
				/**
				* Validates true if the userValue == eqValue 
				*/
				function validate_Eq(userValue, eqValue){
					return (userValue == eqValue) ? true : false;
				}
				
				/**
				* Validates true if the userValue != neqValue 
				*/
				function validate_Neq(userValue, neqValue){
					return (userValue != neqValue) ? true : false;
				}
				
				/**
				* Validates true if the userValue < decisionValue (exclusive)
				*/
				function validate_Lte(userValue, decisionValue){
					return (userValue < decisionValue) ? true : false;
				}
				
				/**
				* Validates true if the userValue > decisionValue (exclusive)
				*/
				function validate_Gte(userValue, decisionValue){
					return (userValue > decisionValue) ? true : false;
				}
				
				/**
				* Validates true if the userValue === property
				*/
				function validate_EqProperty(userValue, property){
					return (userValue === property) ? true : false;
				}
				
				/**
				* Validates true if the given value is !NaN (Negate, Not a Number).
				*/
				function validate_IsNumeric(value){
					return !isNaN(value) ? true : false;
				}
				
				/**
				* Validates true if the given userValue is empty and the field is required. 
				*/
				function validate_Required(property, userValue){
					return (userValue == "" && property == true) ? true : false;		
				}
	
				/**
				* Handles the 'eager' validation on every key press.
				*/
				ngModel.$parsers.unshift(function(value) {
					var name = elem.context.name;//Get the element name for the validate function.
					var currentValue = elem.val(); //Get the current element value to check validations against.
					var val = validate(name, myCurrentContext, currentValue) || {};
					//Check if field is required.				
					$log.debug(scope);
					$log.debug(val);
					ngModel.$setValidity(val.errorkey, !val.fail);
					return true;
					
				});//<---end $parsers
				
				/**
				* This handles 'lazy' validation on blur.
				*/
				elem.bind('blur', function(e){		
					
				});
			}
		};
	}	
} 
export{
	SWValidate
}