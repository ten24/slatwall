component output="false" accessors="true" extends="HibachiTransient" {

	property name="account" type="any";
	property name="session" type="any";
	
	property name="loggedInFlag" type="boolean";
	property name="loggedInAsAdminFlag" type="boolean";
	property name="publicPopulateFlag" type="boolean";
	property name="persistSessionFlag" type="boolean";
	property name="auditsToCommitStruct" type="struct";
	property name="calledActions" type="array";
	property name="failureActions" type="array";
	property name="successfulActions" type="array";
	property name="ormHasErrors" type="boolean" default="false";
	property name="rbLocale";
	property name="url" type="string";
	
	public any function init() {
		setCalledActions( [] );
		setSuccessfulActions( [] );
		setFailureActions( [] );
		setORMHasErrors( false );
		setRBLocale( "en_us" );
		setPublicPopulateFlag( false );
		setPersistSessionFlag( true );
		
		return super.init();
	}
	
	public string function renderJSObject() {
		var config = {};
		config[ 'baseURL' ] = getApplicationValue('baseURL');
		config[ 'action' ] = getApplicationValue('action');
		config[ 'dateFormat' ] = 'mmm dd, yyyy';
		config[ 'timeFormat' ] = 'hh:mm tt';
		
		var returnHTML = '';
		returnHTML &= '<script type="text/javascript" src="#getApplicationValue('baseURL')#/org/Hibachi/HibachiAssets/js/hibachi-scope.js"></script>';
		returnHTML &= '<script type="text/javascript">(function( $ ){$.#lcase(getApplicationValue('applicationKey'))# = new Hibachi(#serializeJSON(config)#);})( jQuery );</script>';
		return returnHTML;
	}
	
	public struct function getAuditsToCommitStruct() {
		if(!structKeyExists(variables, "auditsToCommitStruct")) {
			variables.auditsToCommitStruct = {};
		}
		return variables.auditsToCommitStruct;
	}
	
	public void function clearAuditsToCommitStruct() {
		variables.auditsToCommitStruct = {};
	}
	
	public boolean function getLoggedInFlag() {
		if(!getSession().getAccount().getNewFlag()) {
			return true;
		}
		return false;
	}
	
	public boolean function getLoggedInAsAdminFlag() {
		if(getAccount().getAdminAccountFlag()) {
			return true;
		}
		return false;
	}
	
	public string function getURL() {
		if(!structKeyExists(variables, "url")) {
			variables.url = getPageContext().getRequest().GetRequestUrl().toString();
			if( len( CGI.QUERY_STRING ) ) {
				variables.url &= "?#CGI.QUERY_STRING#";
			}
		}
		return variables.url;
	}
	
	// ==================== GENERAL API METHODS ===============================
	
	// Action Methods ===
	public string function doAction( required string action ) {
		arrayAppend(getCalledActions(), arguments.action);
		return getApplicationValue('application').doAction( arguments.action );
	}
	
	public boolean function hasSuccessfulAction( required string action ) {
		return arrayFindNoCase(getSuccessfulActions(), arguments.action) > 0;
	}
	
	public boolean function hasFailureAction( required string action ) {
		return arrayFindNoCase(getFailureActions(), arguments.action) > 0;
	}
	
	public void function addActionResult( required string action, required failure=false ) {
		if(arguments.failure) {
			arrayAppend(getFailureActions(), arguments.action);
		} else {
			arrayAppend(getSuccessfulActions(), arguments.action);
		}
	}
	
	// Simple API Methods ===
	public any function newEntity(required string entityName) {
		var entityService = getService( "hibachiService" ).getServiceByEntityName( arguments.entityName );
		
		return entityService.invokeMethod("new#arguments.entityName#");
	}
	
	public any function getEntity(required string entityName, any entityID="", boolean isReturnNewOnNotFound=false) {
		var entityService = getService( "hibachiService" ).getServiceByEntityName( arguments.entityName );
		
		return entityService.invokeMethod("get#arguments.entityName#", {1=arguments.entityID, 2=arguments.isReturnNewOnNotFound});
	}
	
	public any function saveEntity(required any entity, struct data={}) {
		var entityService = getService( "hibachiService" ).getServiceByEntityName( arguments.entity.getClassName() );
		
		return entityService.invokeMethod("save#arguments.entity.getClassName()#", {1=arguments.entity, 2=arguments.data});
	}
	
	public any function deleteEntity(required any entity) {
		var entityService = getService( "hibachiService" ).getServiceByEntityName( arguments.entity.getClassName() );
		
		return entityService.invokeMethod("delete#arguments.entity.getClassName()#", {1=arguments.entity});
	}
	
	public any function getSmartList(required string entityName, struct data={}) {
		var entityService = getService( "hibachiService" ).getServiceByEntityName( arguments.entityName );
		
		return entityService.invokeMethod("get#arguments.entityName#SmartList", {1=arguments.data});
	}
	
	public void function flushORMSession(){
		if(!getORMHasErrors()) {
			getDAO( "hibachiDAO" ).flushORMSession();
		}
	}
	
	// ==================== SESSION / ACCOUNT SETUP ===========================
	
	public any function getSession() {
		if(!structKeyExists(variables, "session")) {
			getService("hibachiSessionService").setPropperSession();
		}
		return variables.session;
	}
	
	public any function getAccount() {
		return getSession().getAccount();
	}
	
	// ==================== REQUEST CACHING METHODS ===========================
	
	public boolean function hasValue(required string key) {
		return structKeyExists(variables, arguments.key);
	}

	public any function getValue(required string key) {
		if(hasValue( arguments.key )) {
			return variables[ arguments.key ]; 
		}
		
		throw("You have requested '#arguments.key#' as a value in the #getApplicationValue('applicationKey')# scope, however that value has not been set in the request.  In the futuer you should check for it's existance with hasValue().");
	}
	
	public void function setValue(required string key, required any value) {
		variables[ arguments.key ] = arguments.value;
	}
	
	
	// ==================== RENDERING HELPERS ================================
	
	public void function showMessageKey(required any messageKey) {
		var messageType = listLast(messageKey, "_");
		var message = rbKey(arguments.messageKey);
		
		if(right(message, 8) == "_missing") {
			if(left(listLast(arguments.messageKey, "."), 4) == "save") {
				var entityName = listFirst(right(listLast(arguments.messageKey, "."), len(listLast(arguments.messageKey, "."))-4), "_");
				message = rbKey("admin.define.save_#messageType#");
				message = replace(message, "${itemEntityName}", rbKey("entity.#entityName#") );
			} else if (left(listLast(arguments.messageKey, "."), 6) == "delete") {
				var entityName = listFirst(right(listLast(arguments.messageKey, "."), len(listLast(arguments.messageKey, "."))-6), "_");
				message = rbKey("admin.define.delete_#messageType#");
				message = replace(message, "${itemEntityName}", rbKey("entity.#entityName#") );
			} else if (left(listLast(arguments.messageKey, "."), 7) == "process") {
				var entityName = listFirst(right(listLast(arguments.messageKey, "."), len(listLast(arguments.messageKey, "."))-7), "_");
				message = rbKey("admin.define.process_#messageType#");
				message = replace(message, "${itemEntityName}", rbKey("entity.#entityName#") );
			}
		}
		
		showMessage(message=message, messageType=messageType);
	}
	
	public void function showMessage(string message="", string messageType="info") {
		param name="request.context.messages" default="#arrayNew(1)#";
		
		arrayAppend(request.context.messages, arguments);
	}
	
	// ========================== HELPER DELIGATION METHODS ===============================
	
	// @hint helper function to return the RB Key from RB Factory in any component
	public string function rbKey(required string key, struct replaceStringData) {
		var keyValue = getService("hibachiRBService").getRBKey(arguments.key, getRBLocale());
		if(structKeyExists(arguments, "replaceStringData") && findNoCase("${", keyValue)) {
			keyValue = getService("hibachiUtilityService").replaceStringTemplate(keyValue, arguments.replaceStringData);
		}
		return keyValue;
	}
	
	public boolean function authenticateAction( required string action ) {
		return getService("hibachiAuthenticationService").authenticateActionByAccount( action=arguments.action, account=getAccount() );
	}

	public boolean function authenticateEntity( required string crudType, required string entityName ) {
		return getService("hibachiAuthenticationService").authenticateEntityCrudByAccount( crudType=arguments.crudType, entityName=arguments.entityName, account=getAccount() );
	}
	
	public boolean function authenticateEntityProperty( required string crudType, required string entityName, required string propertyName ) {
		return getService("hibachiAuthenticationService").authenticateEntityPropertyCrudByAccount( crudType=arguments.crudType, entityName=arguments.entityName, propertyName=arguments.propertyName, account=getAccount() );
	}
}
