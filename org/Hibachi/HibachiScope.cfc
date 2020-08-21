component output="false" accessors="true" extends="HibachiTransient" {
	
	property name="hibachiAuthenticationService" type="any";
	property name="hibachiValidationService" type="any";

	property name="account" type="any";
	property name="content" type="any";
	property name="session" type="any";
	property name="loggedInAsAdminFlag" type="boolean";
	property name="publicPopulateFlag" type="boolean";
	property name="workflowPopulateFlag" type="boolean";
	property name="persistSessionFlag" type="boolean";
	property name="sessionFoundNPSIDCookieFlag" type="boolean";
	property name="sessionFoundPSIDCookieFlag" type="boolean";
	property name="sessionFoundExtendedPSIDCookieFlag" type="boolean";
	property name="ormHasErrors" type="boolean" default="false";
	property name="rbLocale" type="string";
	property name="url" type="string";
	property name="calledActions" type="array";
	property name="failureActions" type="array";
	property name="successfulActions" type="array";
	property name="auditsToCommitStruct" type="struct";
	property name="modifiedEntities" type="array";
	property name="excludedModifiedEntityNames" type="array" hint="List of entities ignored by modifiedEntities during the current request";
	property name="isAWSInstance" type="boolean" default="0";
	property name="isECSInstance" type="boolean" default="0";
	property name="entityURLKeyType" type="string";
	property name="permissionGroupCacheKey" type="string";
	property name="entityQueueData" type="struct";

	public any function init() {
		setORMHasErrors( false );
		setRBLocale( "en_us" );
		setPublicPopulateFlag( false );
		setWorkflowPopulateFlag( false );
		setPersistSessionFlag( true );
		setSessionFoundNPSIDCookieFlag( false );
		setSessionFoundPSIDCookieFlag( false );
		setSessionFoundExtendedPSIDCookieFlag( false );
		setCalledActions( [] );
		setSuccessfulActions( [] );
		setFailureActions( [] );
		setAuditsToCommitStruct( {} );
		setModifiedEntities( [] );
		setExcludedModifiedEntityNames( [] );

		return super.init();
	}

	//get the users personal collection options
	public array function getCollectionOptions(){
		//if new account then you have no personal collections
		var collectionOptions = [];

		if(getAccount().getNewFlag()){
			return collectionOptions;
		}

		var collectionCollectionList = getService('HibachiCollectionService').getCollectionCollectionList();
		collectionCollectionList.setDisplayProperties('collectionName|name,collectionID|value');
		collectionCollectionList.addFilter('accountOwner.accountID',getAccount().getAccountID());
		return collectionCollectionList.getRecords();
	}

	public string function getPermissionGroupCacheKey(){
		if(!structKeyExists(variables,'permissionGroupCacheKey')){
			variables.permissionGroupCacheKey = "";

			if(
				!isNull(getAccount())
			){
				permissionGroupCacheKey = getAccount().getPermissionGroupCacheKey();

				variables.permissionGroupCacheKey = permissionGroupCacheKey;
			}
		}


		return variables.permissionGroupCacheKey;
	}


	public string function getEntityURLKeyType(string entityURLKey=""){
		if(!structKeyExists(variables,'entityURLKeyType')){
			//in priority of assumed use
			if(setting('globalURLKeyProduct') == arguments.entityURLKey){
				variables.entityURLKeyType='Product';
			}else if(setting('globalURLKeyProductType') == arguments.entityURLKey){
				variables.entityURLKeyType='ProductType';
			}else if(setting('globalURLKeyCategory') == arguments.entityURLKey){
				variables.entityURLKeyType='Category';
			}else if(setting('globalURLKeyBrand') == arguments.entityURLKey){
				variables.entityURLKeyType='Brand';
			}else if(setting('globalURLKeyAccount') == arguments.entityURLKey){
				variables.entityURLKeyType='Account';
			}else if(setting('globalURLKeyAddress') == arguments.entityURLKey){
				variables.entityURLKeyType='Address';
			}else if(setting('globalURLKeyAttribute') == arguments.entityURLKey){
				variables.entityURLKeyType='Attribute';
			}else{
				variables.entityURLKeyType="";
			}

		}
		return variables.entityURLKeyType;
	}

	public string function getServerInstanceIPAddress(){

		//Check if we already have a instanceIP assigned.
		if(hasApplicationValue("instanceIP")){
			return getApplicationValue("instanceIP");
		}
		//If we are not using aws, then assign the instance ip and return it.
		if (!getHibachiScope().getIsAwsInstance()){
			var ipAddress = createObject("java", "java.net.InetAddress").localhost.getHostAddress();
			setApplicationValue("instanceIP", ipAddress);
			return ipAddress;
		}

		//populate cache using AWS if available.
		// SET AWS Instance IP Address if one exists.
		httpService = new http();
		httpService.setTimeout(3);
		httpService.setMethod("get");
		httpService.setUrl("169.254.169.254/latest/meta-data/local-ipv4");
		result = httpService.send().getPrefix();

		if (result.fileContent != "Connection Timeout" and result.fileContent != "Connection Failure"){
			var ipAddress = result.filecontent;
		}

		//if result exists set cache to this and return it.
		if (!isNull(ipAddress) && len(ipAddress)){
			// GET AWS Instance IP, cache it and return it.
			setApplicationValue("instanceIP", ipAddress);
			return ipAddress;
		}

		return createObject("java", "java.net.InetAddress").localhost.getHostAddress();//returned but not cached.
	}

	public string function getServerInstancePort(){

		//Check if we already have a instancePort assigned.
		if(hasApplicationValue("instancePort")){
			return getApplicationValue("instancePort");
		}
		
		//If we are not using ecs, then assign the instance port and return it.
		if (!getHibachiScope().getIsECSInstance() || getHibachiScope().getApplicationValue('applicationEnvironment') == 'local'){
			var port = cgi.server_port;
			setApplicationValue("instancePort", port);
			return port;
		}

		// If ECS find and set port if available
		var env = createObject( "java", "java.lang.System" ).getENV();
		
		// if hostname (dockerid) not available return
		if(isNull(env['HOSTNAME']) || !len(env['HOSTNAME'])){
			var port = '';
			setApplicationValue("instancePort", port);
			return port;
		}
		
		try {
			httpService = new http();
			httpService.setTimeout(3);
			httpService.setMethod("get");
			httpService.setUrl("172.17.0.1:51678/v1/tasks?dockerid=#env['HOSTNAME']#");
			result = httpService.send().getPrefix();
	
			if (result.fileContent == "Connection Timeout" || result.fileContent == "Connection Failure"){
				var port = '';
				setApplicationValue("instancePort", port);
				return port;
			}
			
			var instanceMetadata = deserializeJSON(result.fileContent);
			if( structKeyExists(instanceMetadata, "containers") && structKeyExists(instanceMetadata["containers"][1], "ports")){
				var ports = instanceMetadata["containers"][1]["ports"];
				for(var port in ports) {
					if(port["ContainerPort"] == "80"){
						var port = port["HostPort"];
						setApplicationValue("instancePort", port);
						return port;
					}
				}
			}
		}catch(any e){
			writeLog(file="#variables.framework.applicationKey#", text="General Log - Unable to get port number for instance #server[variables.framework.applicationKey].serverInstanceKey#");
		}
		
		// if still no port then set to blank and exit
		var port = '';
		setApplicationValue("instancePort", port);
		return port;
	}

	public any function getHibachiAuthenticationService(){
		if(!structKeyExists(variables,'hibachiAuthenticationService')){
			variables.hibachiAuthenticationService = getService('hibachiAuthenticationService');
		}
		return variables.hibachiAuthenticationService;
	}

	public void function setHibachiAuthenticationService(required any hibachiAuthenticationService){
		variables.hibachiAuthenticationService = arguments.hibachiAuthenticationService;
	}

	// @hint facade method to check the application scope for a value
	public void function clearSessionValue(required any key) {
		if( structKeyExists(session, getHibachiInstanceApplicationScopeKey()) && structKeyExists(session[ getHibachiInstanceApplicationScopeKey() ], arguments.key)) {
			structDelete(session[ getHibachiInstanceApplicationScopeKey() ], arguments.key);
		}
	}

	// @hint facade method to check the session scope for a value
	public boolean function hasSessionValue(required any key) {
		param name="session" default="#structNew()#";
		if( structKeyExists(session, getHibachiInstanceApplicationScopeKey()) && structKeyExists(session[ getHibachiInstanceApplicationScopeKey() ], arguments.key)) {
			return true;
		}

		return false;
	}

	// @hint facade method to get values from the session scope
	public any function getSessionValue(required any key) {
		if( structKeyExists(session, getHibachiInstanceApplicationScopeKey()) && structKeyExists(session[ getHibachiInstanceApplicationScopeKey() ], arguments.key)) {
			return session[ getHibachiInstanceApplicationScopeKey() ][ arguments.key ];
		}

		throw("You have requested a value for '#arguments.key#' from the session that does not exist.");
	}

	// @hint facade method to set values in the session scope
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
	
	
	public boolean function hasCookieValue(required string key) {
		return StructKeyExists(COOKIE, arguments.key) && Len( Trim(COOKIE[arguments.key]) );
	}
	
	public string function getCookieValue(required string key) {
		if( this.hasCookieValue(arguments.key) ) { return COOKIE[arguments.key]; }
	}
	
	public void function setCookieValue(required string key, string value, any expires) {
		
		if(!IsNull(arguments.value) && Len(Trim(arguments.value))){
			
			var args = {
				name= arguments.key,  
				value= arguments.value
			};
			if(!IsNull(arguments.expires)){
				args.expires = arguments.expires;
			}
			
			//the Hibachi service will takecare of [sessionCookieSecure and sessionCookieDomain] based on the application settings
			this.getService('hibachiTagService').cfcookie(argumentCollection= args);
		
		} else {
			this.clearCookieValue(arguments.key);
		}
	}
	
	public void function clearCookieValue(required string key) {
		 StructDelete(COOKIE, arguments.key);
	}


	public string function renderJSObject() {
		var config = getService('HibachiSessionService').getConfig();
		var returnHTML = '';
		returnHTML &= '<script type="text/javascript" src="#getApplicationValue('baseURL')#/org/Hibachi/HibachiAssets/js/hibachi-scope.js"></script>';
		returnHTML &= '<script type="text/javascript">(function( $ ){$.#lcase(getApplicationValue('applicationKey'))# = new Hibachi(#serializeJSON(config)#);})( jQuery );</script>';
		return returnHTML;
	}

	public void function addModifiedEntity( required any entity ) {
		if(!arrayFindNoCase(getExcludedModifiedEntityNames(), arguments.entity.getClassName()) && !arguments.entity.getExcludeFromModifiedEntitiesFlag()){
			arrayAppend(getModifiedEntities(), arguments.entity);
		}
	}

	public void function clearModifiedEntities() {
		setModifiedEntities([]);
	}
	
	public void function addExcludedModifiedEntityName( required string entityName ) {
		if(!arrayFindNoCase(getExcludedModifiedEntityNames(), arguments.entityName)){
			arrayAppend(getExcludedModifiedEntityNames(), arguments.entityName);
		}
	}
	
	public void function removeExcludedModifiedEntityName( required string entityName ) {
		ArrayDeleteNoCase(getExcludedModifiedEntityNames(),arguments.entityName);
	}
	
	public void function clearExcludedModifiedEntityNames() {
		setIgnoredEntityNames([]);
	}

	public void function clearAuditsToCommitStruct() {
		setAuditsToCommitStruct({});
	}

	/** This checks if the user is logged in by checking whether or not the user has manually logged out or has timed out.
	 *  This method should return as it always has.
	 */
	public boolean function getLoggedInFlag() {
		return getSession().getLoggedInFlag();
	}

	/**
	 * Because we are not removing the account from the session, logged in flag needs to
	 * be checked before checking if they are an admin account.
	 */
	public boolean function getLoggedInAsAdminFlag() {
		if(!isNull(getSession()) &&
			getSession().getLoggedInFlag() &&
		   !isNull(getSession().getAccount()) &&
		   !isNull(getSession().getAccount().getAdminAccountFlag()) &&
			getSession().getAccount().getAdminAccountFlag()) {

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

	public string function getURLFromS3( required path ) {
		try{
			return getService("hibachiUtilityService").getSignedS3ObjectLink(
				bucketName=getHibachiScope().setting("globalS3Bucket"),
				keyName=replace(arguments.path,'s3://',''),
				awsAccessKeyId=getHibachiScope().setting("globalS3AccessKey"),
				awsSecretAccessKey=getHibachiScope().setting("globalS3SecretAccessKey"),
				minutesValid=15
			);
		}catch(any e){
			return '';
		}
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
	
	public void function clearActionResult( required string action ) {
		 arrayDeleteNoCase(getFailureActions(), arguments.action);
		 arrayDeleteNoCase(getSuccessfulActions(), arguments.action);
	}

	public void function addActionResult( required string action, required failure=false ) {
		clearActionResult(arguments.action);
		
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

	public void function flushORMSession(boolean runCalculatedPropertiesAgain=false){
		if(!getORMHasErrors()) {
			getDAO( "hibachiDAO" ).flushORMSession(argumentCollection=arguments);
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

	public string function generateCSRFToken(boolean forceNew=false,string tokenName='hibachiCSRFToken' ){  
		return getService("hibachiSessionService").generateCSRFToken(arguments.forceNew,arguments.tokenName);
	}

	public boolean function verifyCSRFToken(required string requestToken){
		return getService("hibachiSessionService").verifyCSRFToken(arguments.requestToken);
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
		param name="request.context" default="#structNew()#";
		param name="request.context['messages']" default="#arrayNew(1)#";
		arguments.message=getService('HibachiUtilityService').replaceStringTemplate(arguments.message,request.context);
		var messageStruct = {};
		messageStruct['message'] = arguments.message;
		messageStruct['messageType'] = arguments.messageType;
		arrayAppend(request.context['messages'], messageStruct);
	}

	// ========================== HELPER DELIGATION METHODS ===============================

	public string function hibachiHTMLEditFormat(string html=""){
		return getService('hibachiUtilityService').hibachiHTMLEditFormat(arguments.html);
	}

	// @hint helper function to return the RB Key from RB Factory in any component
	public string function rbKey(required string key, struct replaceStringData) {
		var keyValue = getService("hibachiRBService").getRBKey(arguments.key, getRBLocale());
		if(structKeyExists(arguments, "replaceStringData") && findNoCase("${", keyValue)) {
			keyValue = getService("hibachiUtilityService").replaceStringTemplate(keyValue, arguments.replaceStringData);
		}

		if(findNoCase('_missing',keyValue)){
			return listFirst(keyValue);
		}
		return keyValue;
	}

	public string function getRBKey(required string key, struct replaceStringData) {
		return rbKey(argumentcollection=arguments);
	}

	//convenience method for validate
	public any function validate(required any object, string context="", boolean setErrors=true) {
		return getService('hibachiValidationService').validate(argumentCollection=arguments); 
	}

	public boolean function authenticateAction( required string action,string processContext="" ) {
		return getHibachiAuthenticationService().authenticateActionByAccount( action=arguments.action, account=getAccount(), processContext=arguments.processContext );
	}

	public boolean function authenticateEntity( required string crudType, required string entityName ) {
		return getHibachiAuthenticationService().authenticateEntityCrudByAccount( crudType=arguments.crudType, entityName=arguments.entityName, account=getAccount() );
	}

	public boolean function authenticateEntityProperty( required string crudType, required string entityName, required string propertyName ) {
		return getHibachiAuthenticationService().authenticateEntityPropertyCrudByAccount( crudType=arguments.crudType, entityName=arguments.entityName, propertyName=arguments.propertyName, account=getAccount() );
	}

	public boolean function authenticateCollection(required string crudType, required any collection){
		return getHibachiAuthenticationService().authenticateCollectionCrudByAccount( crudType=arguments.crudType, collection=arguments.collection, account=getAccount() );
	}

	public boolean function authenticateCollectionPropertyIdentifier(required string crudType, required any collection, required string propertyIdentifier){
		return getHibachiAuthenticationService().authenticateCollectionPropertyIdentifierCrudByAccount( crudType=arguments.crudType, collection=arguments.collection, propertyIdentifier=arguments.propertyIdentifier, account=getAccount() );
	}
	

	public any function addEntityQueueData(required string baseID, required string baseObject, string processMethod='', struct entityQueueData={}, string integrationID=''){
		if(!structKeyExists(variables, "entityQueueData")) {
			variables.entityQueueData = {};
		}
		var dataString = "#arguments.baseObject#_#arguments.baseID#_#arguments.processMethod#_#serializeJSON(arguments.entityQueueData)#";
		
		if (structKeyExists(arguments, "integrationID") && len(arguments.integrationID)){
			dataString = dataString & "_#integrationID#"; 
		}
		
		arguments.entityQueueID = hash(dataString, 'MD5');
		arguments.entityQueueProcessingDateTime = now(); //this will be processed in this request.
		
		if(!structKeyExists(variables.entityQueueData, arguments.entityQueueID)){
			variables.entityQueueData[arguments.entityQueueID] = arguments;
			getService('HibachiEntityQueueService').insertEntityQueueItem(argumentCollection=arguments);
		}
	}
	
	public struct function getEntityQueueData(){
		if(!structKeyExists(variables, "entityQueueData")) {
			variables.entityQueueData = {};
		}
		return variables.entityQueueData;
		
	}
	
	public void function clearEntityQueueData(){
		var entityQueues = getEntityQueueData();
		var entityQueueIDsToBeDeleted = '';
		
		for(var entityQueue in entityQueues){
			entityQueueIDsToBeDeleted = listAppend(entityQueueIDsToBeDeleted, entityQueues[entityQueue]['entityQueueID']);
		}
		variables.entityQueueData = {};
		getService('HibachiEntityQueueService').deleteEntityQueueItems(entityQueueIDsToBeDeleted);
		
	}
	
	public void function deleteEntityQueue(entityQueueID){
		var entityQueues = getEntityQueueData();
		
		for(var entityQueue in entityQueues){
			if(entityQueues[entityQueue]['entityQueueID'] == arguments.entityQueueID){
				StructDelete(entityQueues, entityQueue);
				getService('HibachiEntityQueueService').deleteEntityQueueItems(arguments.entityQueueID);
				break;
			}
		}
		
	}
	
	public string function getServerInstanceKey(){
		return server[getApplicationKey()].serverInstanceKey;
	}

	public any function getServerInstance(){
		if(!structKeyExists(variables, 'serverInstance')){
			variables.serverInstance = getService('hibachiCacheService').getServerInstanceByServerInstanceKey(getServerInstanceKey());
		}
		return variables.serverInstance;
	}
	
	public any function setErrorExtraData(required struct data){
		if(!structKeyExists(request, "errorExtraData")){
			request.errorExtraData = {};
		}
		
		for( var item in arguments.data ){
			request.errorExtraData[item] = arguments.data[item];
		}
		
	}
	
}
