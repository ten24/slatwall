component output="false" accessors="true" extends="HibachiTransient" {

	property name="account" type="any";
	property name="session" type="any";
	
	property name="loggedInFlag" type="boolean";
	property name="loggedInAsAdminFlag" type="boolean";
	property name="publicPopulateFlag" type="boolean";
	property name="persistSessionFlag" type="boolean";
	property name="sessionFoundNPSIDCookieFlag" type="boolean";
	property name="sessionFoundPSIDCookieFlag" type="boolean";
	
	property name="ormHasErrors" type="boolean" default="false";
	property name="rbLocale";
	property name="url" type="string";
	
	property name="calledActions" type="array";
	property name="failureActions" type="array";
	property name="successfulActions" type="array";
	
	property name="auditsToCommitStruct" type="struct";
	property name="modifiedEntities" type="array";
	
	public any function init() {
		setORMHasErrors( false );
		setRBLocale( "en_us" );
		setPublicPopulateFlag( false );
		setPersistSessionFlag( true );
		setSessionFoundNPSIDCookieFlag( false );
		setSessionFoundPSIDCookieFlag( false );
		
		setCalledActions( [] );
		setSuccessfulActions( [] );
		setFailureActions( [] );
		
		setAuditsToCommitStruct( {} );
		setModifiedEntities( [] );
		
		
		return super.init();
	}
	
	// @hint facade method to check the application scope for a value
	public boolean function hasSessionValue(required any key) {
		param name="session" default="#structNew()#";
		if( structKeyExists(session, getHibachiInstanceApplicationScopeKey()) && structKeyExists(session[ getHibachiInstanceApplicationScopeKey() ], arguments.key)) {
			return true;
		}
		
		return false;
	}
	
	// @hint facade method to get values from the application scope
	public any function getSessionValue(required any key) {
		if( structKeyExists(session, getHibachiInstanceApplicationScopeKey()) && structKeyExists(session[ getHibachiInstanceApplicationScopeKey() ], arguments.key)) {
			return session[ getHibachiInstanceApplicationScopeKey() ][ arguments.key ];
		}
		
		throw("You have requested a value for '#arguments.key#' from the core application that is not setup.  This may be because the verifyApplicationSetup() method has not been called yet")
	}
	
	// @hint facade method to set values in the application scope 
	public void function setSessionValue(required any key, required any value) {
		var sessionKey = "";
		if(structKeyExists(COOKIE, "JSESSIONID")) {
			sessionKey = COOKIE.JSESSIONID;
		} else if (structKeyExists(COOKIE, "CFTOKEN")) {
			sessionKey = COOKIE.CFTOKEN;
		} else if (structKeyExists(COOKIE, "CFID")) {
			sessionKey = COOKIE.CFID;
		}
		lock name="#sessionKey#_#getHibachiInstanceApplicationScopeKey()#_#arguments.key#" timeout="10" {
			if(!structKeyExists(session, getHibachiInstanceApplicationScopeKey())) {
				session[ getHibachiInstanceApplicationScopeKey() ] = {};
			}
			session[ getHibachiInstanceApplicationScopeKey() ][ arguments.key ] = arguments.value;
		}
	}
	
	public string function renderJSObject() {
		var config = getService('HibachiSessionService').getConfig();
		var returnHTML = '';
		returnHTML &= '<script type="text/javascript" src="#getApplicationValue('baseURL')#/org/Hibachi/HibachiAssets/js/hibachi-scope.js"></script>';
		returnHTML &= '<script type="text/javascript">(function( $ ){$.#lcase(getApplicationValue('applicationKey'))# = new Hibachi(#serializeJSON(config)#);})( jQuery );</script>';
		return returnHTML;
	}
	
	public void function addModifiedEntity( required any entity ) {
		arrayAppend(getModifiedEntities(), arguments.entity);
	}
	
	public void function clearModifiedEntities() {
		setModifiedEntities([]);
	}
	
	public void function clearAuditsToCommitStruct() {
		setAuditsToCommitStruct({});
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
	public string function doAction( required string action, struct data={} ) {
		arrayAppend(getCalledActions(), arguments.action);
		return getApplicationValue('application').doAction( arguments.action, arguments.data );
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
			getService("hibachiSessionService").setProperSession();
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
		param name="request.context['messages']" default="#arrayNew(1)#";
		arguments.message=getService('HibachiUtilityService').replaceStringTemplate(arguments.message,request.context);
		var messageStruct = {};
		messageStruct['message'] = arguments.message;
		messageStruct['messageType'] = arguments.messageType;
		arrayAppend(request.context['messages'], messageStruct);
	}
	
	// ========================== HELPER DELIGATION METHODS ===============================
	
	public string function hibachiHTMLEditFormat(required string html){
		return getService('hibachiUtilityService').hibachiHTMLEditFormat(arguments.html);
	}
	
	// @hint helper function to return the RB Key from RB Factory in any component
	public string function rbKey(required string key, struct replaceStringData) {
		var keyValue = getService("hibachiRBService").getRBKey(arguments.key, getRBLocale());
		if(structKeyExists(arguments, "replaceStringData") && findNoCase("${", keyValue)) {
			keyValue = getService("hibachiUtilityService").replaceStringTemplate(keyValue, arguments.replaceStringData);
		}
		return keyValue;
	}
	
	public string function getRBKey(required string key, struct replaceStringData) {
		return rbKey(argumentcollection=arguments);
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
	
	public boolean function authenticateCollection(required string crudType, required any collection){
		return getService("hibachiAuthenticationService").authenticateCollectionCrudByAccount( crudType=arguments.crudType, collection=arguments.collection, account=getAccount() );
	}
	
	public boolean function authenticateCollectionPropertyIdentifier(required string crudType, required any collection, required string propertyIdentifier){
		return getService("hibachiAuthenticationService").authenticateCollectionPropertyIdentifierCrudByAccount( crudType=arguments.crudType, collection=arguments.collection, propertyIdentifier=arguments.propertyIdentifier, account=getAccount() );
	}
}
