component output="false" accessors="true" extends="HibachiObject" {

	// @hint stores any validation errors for the entity
	property name="errors" type="struct";

	// @hint Constructor for error bean. Initializes the error bean.
	public function init() {
		variables.errors = structNew();
		
		return this;
	}
	
	// @hint Adds a new error to the error structure.
	public void function addError(required string errorName, required any errorMessage) {
		if(!structKeyExists(variables.errors, arguments.errorName)) {
			variables.errors[arguments.errorName] = [];
		}
		if(isSimpleValue(arguments.errorMessage)) {
			arrayAppend(variables.errors[arguments.errorName], arguments.errorMessage);	
		} else if (isArray(arguments.errorMessage)) {
			for(var message in arguments.errorMessage) {
				arrayAppend(variables.errors[arguments.errorName], message);
			}
		} else if (isStruct(arguments.errorMessage)) {
			for(var key in arguments.errorMessage) {
				for(var message in arguments.errorMessage[key]) {
					arrayAppend(variables.errors[arguments.errorName], message);	
				}
			}
		}
	}
	
	public void function addErrors(required struct errors) {
		for(var key in arguments.errors) {
			if(!structKeyExists(variables.errors, key)) {
				variables.errors[key] = [];
			}
			for(var message in arguments.errors[key]) {
				arrayAppend(variables.errors[key], message);	
			}
		}
	}
	
	// @hint Returns an array of error messages from the error structure.
	public array function getError(required string errorName) {
		if(hasError(errorName=arguments.errorName)){
			return variables.errors[arguments.name];
		}
		
		throw("The Error #arguments.errorName# doesn't Exist");
	}
	
	// @hint Returns true if the error exists within the error structure.
	public string function hasError(required string errorName) {
		return structKeyExists(variables.errors, arguments.errorName) ;
	}
	
	// @hint Returns true if there is at least one error.
	public boolean function hasErrors() {
		return !structIsEmpty(variables.errors) ;
	}
	
	// @hint helper method that returns all error messages as <p> html tags
	public string function getAllErrorsHTML() {
		var returnString = "";
		
		for(var errorName in getErrors()) {
			for(var i=1; i<=arrayLen(getErrors()[errorName]); i++) {
				returnString &= "<p class='error'>" & getErrors()[errorName][i] & "</p>";
			}
		}
		
		return returnString;
	}
}