component accessors="true" output="false" persistent="false" {

	property name="hibachiInstanceApplicationScopeKey" type="string" persistent="false";
	property name="currentMonth" persistent="false";
	property name="currentYear" persistent="false";
	property name="currentYearAbbreviated" persistent="false";

	// Constructor Metod
	public any function init( ) {
		getThisMetaData();
		return this;
	}
	
	public any function getApplicationKey(){
		return getBeanFactory().getBean('applicationKey');
	}
	
	// @help Public method to determine if this is a persistent object (an entity)
	public any function isPersistent() {
		var metaData = getThisMetaData();
		if(structKeyExists(metaData, "persistent") && metaData.persistent) {
			return true;
		}
		return false;
	}
	
	public string function getRemoteAddress(){
		var clientIP = cgi.remote_addr;
		var clientHeaders = GetHttpRequestData().headers;
		if(structKeyExists(clientHeaders,"X-Forwarded-For")){
			clientIP = listRemoveDuplicates( ReplaceNoCase( clientHeaders["X-Forwarded-For"] , ' ', '', 'all') );
		}
		return clientIP;
	}

	//convenience date functions for collections filters
	public numeric function getCurrentMonth(){
		return month(now());
	} 

	public numeric function getCurrentYear(){
		return year(now());
	} 

	public numeric function getCurrentYearAbbreviated(){
		return right(getCurrentYear(), 2); 
	}  	
	//end convenience date functions for collections filters
	
	// @help Public method to determine if this is a processObject.  This is overridden in the HibachiProcess.cfc
	public any function isProcessObject() {
		return false;
	}
	
	// ========================== START: FRAMEWORK ACCESS ===========================================
	
	// @hint gets a bean out of whatever the fw1 bean factory is
	public any function getBeanFactory() {
		return application[ getApplicationValue('applicationKey') ].factory;		
	}
	
	public any function getCustom(){
		return this;
	}
	
	// @hint gets a bean out of whatever the fw1 bean factory is
	public any function getBean(required string beanName, struct constructorArgs = { }) {
		return getBeanFactory().getBean( argumentCollection=arguments);
	}
	
	// @hint has a bean out of whatever the fw1 bean factory is
	public any function hasBean(required string beanName) {
		return getBeanFactory().containsBean( arguments.beanName );
	}
	// @hint sets bean factory, this probably should not ever be invoked outside of  initialization. Application.cfc should take care of this.
	public void function setBeanFactory(required any beanFactory) {
		application[ getApplicationValue('applicationKey') ].factory = arguments.beanFactory;
	}

	// @hint whether or not we have a bean
	public boolean function hasService(required string serviceName){
		return hasBean(arguments.serviceName);
	} 
	
	// @hint returns an application scope cached version of the service
	public any function getService(required string serviceName) {
		return getBean(arguments.serviceName) ;
	}
	
	// @hint returns an application scope cached version of the service
	public any function getDAO(required string daoName) {
		return getBean(arguments.daoName);
	}
	
	// @hint returns a new transient bean
	public any function getTransient(required string transientName, struct constructorArgs = { } ) {
		return getBean(arguments.transientName, arguments.constructorArgs);
	}
	
	// @hint returns an application specfic virtual filesystem
	public any function getVirtualFileSystemPath() {
		var vfsDirectory = "ram:///" & getHibachiInstanceApplicationScopeKey();
		if(!directoryExists( vfsDirectory )) {
			directoryCreate( vfsDirectory );
		}

		return vfsDirectory;
	}
	
	// @hint return the correct tempDirectory for the application for uploads, ect
	public string function getHibachiTempDirectory() {
		return getTempDirectory();
	} 
	
	// @hint helper function for returning the hibachiScope from the request scope
	public any function getHibachiScope() {
		return request[ "#getApplicationValue("applicationKey")#Scope" ];
	}
	
	// @hint helper function to get the applications baseURL
	public string function getBaseURL() {
		return getApplicationValue("baseURL");
	}
	
	public string function getURLFromPath( required any path ) {
		// Convert path to use /
		arguments.path = replace(arguments.path, '\','/','all');
		
		// Get the correct URL Root Path
		var urlRootPath = replace(expandPath('/'), '\','/','all');
		
		// Remove the URLRootPath from the rest of the path
		return replaceNoCase(arguments.path, urlRootPath, '/');
	}
	
	// ==========================  END: FRAMEWORK ACCESS ============================================
	// =========================== START: UTILITY METHODS ===========================================
	
	// @hint public method to return a a default value, if the value passed in is null
	public any function nullReplace(any value, required any defaultValue) {
		if(!structKeyExists(arguments, "value")) {
			return arguments.defaultValue;
		}
		return arguments.value;
	}
	
	
	// @help Public Method that allows you to get a serialized JSON struct of all the simple values in the variables scope.  This is very useful for compairing objects before and after a populate
	public string function getSimpleValuesSerialized() {
		var data = {};
		for(var key in variables) {
			if( key != "hibachiInstanceApplicationScopeKey" && structKeyExists(variables, key) && isSimpleValue(variables[key]) ) {
				data[key] = variables[key];
			}
		}
		return serializeJSON(data);
	}
		
	// @help Public Method to invoke any method in the object, If the method is not defined it calls onMissingMethod
	public any function invokeMethod(required string methodName, struct methodArguments={}) {
		if(structKeyExists(this, arguments.methodName)) {
			var theMethod = this[ arguments.methodName ];
			return theMethod(argumentCollection = arguments.methodArguments);
		}
		if(structKeyExists(this, "onMissingMethod")) {
			return this.onMissingMethod(missingMethodName=arguments.methodName, missingMethodArguments=arguments.methodArguments);	
		}
		throw("You have attempted to call the method #arguments.methodName# which does not exist in #getClassFullName()#");
	}
	
	// @help Public method to get everything in the variables scope, good for debugging purposes
	public any function getVariables() {
		return variables;
	}
	
	// @help Public method to get the class name of an object
	public any function getClassName() {
		return listLast(getClassFullname(), "."); 
	}
	
	// @help Public method to get the fully qualified dot notation class name
	public any function getClassFullname() {
		return getThisMetaData().fullname;
	}
	
	public string function createHibachiUUID() {
		return replace(lcase(createUUID()), '-', '', 'all');
	}
	
	//Dump & Die, shortcut
	public any function dd(required any data, numeric top = 2){
		writeDump(var="#arguments.data#", top=arguments.top, abort=true);
	}
	
	// ===========================  END:  UTILITY METHODS ===========================================
	// ==================== START: INTERNALLY CACHED META VALUES ====================================
	
	// @help Public method that caches locally the meta data of this object
	public any function getThisMetaData(){
		if(!structKeyExists(variables, "thisMetaData")) {
			variables.thisMetaData = getMetaData( this );
		}
		return variables.thisMetaData;
	}
	
	// ====================  END: INTERNALLY CACHED META VALUES =====================================
	// ========================= START: DELIGATION HELPERS ==========================================
	
	
	public string function encryptValue(string value) {
		return getService("hibachiUtilityService").encryptValue(argumentcollection=arguments);
	}
	
	public string function decryptValue(string value) {
		return getService("hibachiUtilityService").decryptValue(argumentcollection=arguments);
	}
	
	public string function getIdentityHashCode() {
		return getService("hibachiUtilityService").getIdentityHashCode(this);
	}
	
	public void function logHibachi(required string message, boolean generalLog=false){
		getService("hibachiUtilityService").logMessage(argumentCollection=arguments);		
	}
	
	public void function traceHibachi(required string message, boolean generalLog=true){
		arguments.logType = 'Trace';
		getService("hibachiUtilityService").logMessage(argumentCollection=arguments);		
	}
	
	public void function logHibachiException(required any exception){
		getService("hibachiUtilityService").logException(exception=arguments.exception);		
	}
	
	public string function rbKey(required string key) {
		return getHibachiScope().rbKey(argumentCollection=arguments);
	}
	
	public string function hibachiHTMLEditFormat(required any html=""){
		return getHibachiScope().hibachiHTMLEditFormat(arguments.html);
	}
	
	public string function buildURL() {
		return getApplicationValue("application").buildURL(argumentcollection=arguments);
	}
	
	public any function formatValue( required string value, required string formatType, struct formatDetails={} ) {
		return getService("hibachiUtilityService").formatValue(argumentcollection=arguments);
	} 
	
	
    public boolean function hibachiIsEmpty( any input, boolean noTrim=false ){

        if( isNull(arguments.input) ){
            return true;
        }

        if( isSimpleValue(arguments.input) ){
           return arguments.noTrim ? len( arguments.input ) == 0 : len( trim(arguments.input) ) == 0;
        }

        if( IsStruct(arguments.input) ){
            return StructIsEmpty(arguments.input);
        }

        if( IsArray(arguments.input) ){
            return ArrayIsEmpty(arguments.input);
        }

        if( IsQuery(arguments.input) ){
            return arguments.input.recordCount == 0;
        }

        // isObject | not-NULL | boolean
        return false;
    }
    
    public boolean function hibachiIsStructEmpty( any input, boolean noTrim=false ){

        if( isNull(arguments.input) ){
            return true;
        }

        if( this.hibachiIsEmpty(argumentCollection=arguments) ){
            return true;
        }
        
        for(var key in arguments.input){
            var foundNonEmpty = isStruct(arguments.input[ key ]) 
                                ? !this.hibachiIsStructEmpty(arguments.input[ key ], arguments.noTrim) 
                                : !this.hibachiIsEmpty(arguments.input[ key ], arguments.noTrim);

            if(foundNonEmpty){
                return false;
            }
        }

        return true;
    }
	
	// =========================  END:  DELIGATION HELPERS ==========================================
	// ========================= START: APPLICATION VAUES ===========================================
	
	// @hint setups an application scope value that will always be consistent
	public any function getHibachiInstanceApplicationScopeKey() {
		if(!structKeyExists(variables, "hibachiInstanceApplicationScopeKey") || isNull(variables.hibachiInstanceApplicationScopeKey)) {
			var metaData = getThisMetaData();
			
			do {
				var filePath = metaData.path;
				metaData = metaData.extends;
			} while( structKeyExists(metaData, "extends") );
			
			filePath = lcase(getDirectoryFromPath(replace(filePath,"\","/","all")));
			var appKey = hash(filePath);
			
			variables.hibachiInstanceApplicationScopeKey = appKey;	
		}
		
		return variables.hibachiInstanceApplicationScopeKey;
	}
	
	// @hint facade method to check the application scope for a value
	public boolean function hasApplicationValue(required any key) {
		if( structKeyExists(application, getHibachiInstanceApplicationScopeKey()) && structKeyExists(application[ getHibachiInstanceApplicationScopeKey() ], arguments.key)) {
			return true;
		}
		
		return false;
	}
	
	public void function clearApplicationValueByPrefix(required any prefix){
		if( structKeyExists(application, getHibachiInstanceApplicationScopeKey())) {
			for(var key in application[ getHibachiInstanceApplicationScopeKey() ]){
				if(
					len(arguments.prefix) < len(key)
					&& arguments.prefix == left(key,len(prefix))
				){
					clearApplicationValue(key);
				}
			}
		}
	}
	
	// @hint facade method to check the application scope for a value
	public void function clearApplicationValue(required any key) {
		if( structKeyExists(application, getHibachiInstanceApplicationScopeKey()) && structKeyExists(application[ getHibachiInstanceApplicationScopeKey() ], arguments.key)) {
			structDelete(application[ getHibachiInstanceApplicationScopeKey() ], arguments.key);
		}
	}
	
	// @hint facade method to get values from the application scope
	public any function getApplicationValue(required any key) {
		if( structKeyExists(application, getHibachiInstanceApplicationScopeKey()) && structKeyExists(application[ getHibachiInstanceApplicationScopeKey() ], arguments.key)) {
			return application[ getHibachiInstanceApplicationScopeKey() ][ arguments.key ];
		}
		
		throw("You have requested a value for '#getHibachiInstanceApplicationScopeKey()#' '#arguments.key#' from the core hibachi application that is not setup.  This may be because the verifyApplicationSetup() method has not been called yet");
	}
	
	// @hint facade method to set values in the application scope 
	public void function setApplicationValue(required any key, required any value) {
		lock name="application_#getHibachiInstanceApplicationScopeKey()#_#arguments.key#" timeout="10" {
			if(!structKeyExists(application, getHibachiInstanceApplicationScopeKey())) {
				application[ getHibachiInstanceApplicationScopeKey() ] = {};
				application[ getHibachiInstanceApplicationScopeKey() ].initialized = false;
			}
			application[ getHibachiInstanceApplicationScopeKey() ][ arguments.key ] = arguments.value;
			if(isSimpleValue(arguments.value) && hasApplicationValue("applicationKey") && !findNoCase("password", arguments.key) && !findNoCase("username", arguments.key) && len(arguments.value) < 100) {
				writeLog(file="#getApplicationValue('applicationKey')#", text="General Log - Application Value '#arguments.key#' set as: #arguments.value#");
			}
		}
	}
	
	// @hint facade method to check the session scope for a value
	public void function clearSessionValue(required any key) {
		getHibachiScope().clearSessionValue(arguments.key);
	}
	
	// @hint facade method to check the session scope for a value
	public boolean function hasSessionValue(required any key) {
		return getHibachiScope().hasSessionValue(arguments.key);
	}
	
	// @hint facade method to get values from the session scope
	public any function getSessionValue(required any key) {
		return getHibachiScope().getSessionValue(arguments.key);
	}
	
	// @hint facade method to set values in the session scope 
	public void function setSessionValue(required any key, required any value) {
		getHibachiScope().setSessionValue(arguments.key,arguments.value);
	}
	
	public void function clearVariablesKey(required string key){
		structDelete(variables,arguments.key);
	}

	// ========================= END: APPLICATION VAUES ===========================================
}
