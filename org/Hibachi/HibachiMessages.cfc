component output="false" accessors="true" extends="HibachiObject" {

	// @hint stores any validation errors for the entity
	property name="messages" type="struct";
	
	// @hint Constructor for error bean. Initializes the error bean.
	public function init() {
		variables.messages = structNew();
		return this;
	}
	
	// @hint Adds a new message to the messages structure.
	public void function addMessage(required string messageName, required string message) {
		if(!structKeyExists(variables.messages, arguments.messageName)) {
			variables.messages[arguments.messageName] = [];
		}
		arrayAppend(variables.messages[arguments.messageName], arguments.message);
	}
	
	// @hint Returns an array of error messages from the error structure.
	public array function getMessage(required string messageName) {
		if(hasMessage(messageName=arguments.messageName)){
			return variables.messages[arguments.messageName];
		}
		
		throw("The Message #arguments.messageName# doesn't Exist");
	}
	
	// @hint Returns true if the error exists within the error structure.
	public string function hasMessage(required string messageName) {
		return structKeyExists(variables.messages, arguments.messageName) ;
	}
	
	// @hint Returns true if there is at least one error.
	public boolean function hasMessages() {
		return !structIsEmpty(variables.messages) ;
	}
	
}