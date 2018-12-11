component extends="framework.one" {
	
	// ======= START: ENVIRONMENT CONFIGURATION =======

	// =============== configApplication

	// Defaults
	this.name = "hibachi" & hash(getCurrentTemplatePath());
	this.sessionManagement = true;
	this.datasource = {};
	this.datasource.name = "hibachi";
	this.datasource.username = "";
	this.datasource.password = "";

	// Allow For Application Config
	try{include "../../config/configApplication.cfm";}catch(any e){}
	// Allow For Instance Config
	try{include "../../custom/config/configApplication.cfm";}catch(any e){}
	
	// Allow For DevOps Config
	try{include "../../../configApplication.cfm";}catch(any e){} 
	try{include "../../../../configApplication.cfm";}catch(any e){} 

	// =============== configFramework

	// Defaults

	// FW1 Setup
	variables.framework=structNew();
	variables.framework.applicationKey = 'Hibachi';
	variables.framework.action = 'action';
	variables.framework.baseURL = replaceNoCase(replace(replaceNoCase( getDirectoryFromPath(getCurrentTemplatePath()) , expandPath('/'), '/' ), '\', '/', 'all'),'/org/Hibachi/','');
	variables.framework.base = variables.framework.baseURL;
	variables.framework.basecfc = variables.framework.baseURL;
	variables.framework.usingSubsystems = true;
	variables.framework.defaultSubsystem = 'admin';
	variables.framework.defaultSection = 'main';
	variables.framework.defaultItem = 'default';
	variables.framework.subsystemDelimiter = ':';
	variables.framework.siteWideLayoutSubsystem = 'common';
	variables.framework.home = 'admin:main.default';
	variables.framework.error = 'admin:error.default';
	variables.framework.reload = 'reload';
	variables.framework.password = 'true';
	variables.framework.reloadApplicationOnEveryRequest = false;
	variables.framework.generateSES = false;
	variables.framework.SESOmitIndex = false;
	variables.framework.suppressImplicitService = true;
	//variables.framework.suppressServiceQueue = false; // false restores the FW/1 2.2 behavior
	//variables.framework.enableGlobalRC = true; // true restores the FW/1 2.2 behavior
	variables.framework.unhandledExtensions = 'cfc';
	variables.framework.unhandledPaths = '/flex2gateway';
	variables.framework.unhandledErrorCaught = false;
	variables.framework.preserveKeyURLKey = 'fw1pk';
	variables.framework.maxNumContextsPreserved = 10;
	variables.framework.cacheFileExists = false;
	variables.framework.trace = false;
	variables.framework.diEngine='none';
	variables.framework.diOverrideAllowed=true;
	variables.framework.isAwsInstance=false;

	/* TODO: add solution to api routing for Rest api*/
	variables.framework.routes = [
		//api routes

		 { "$GET/api/scope/$" = "/api:public/get/" }
		,{ "$GET/api/scope/:context/$" = "/api:public/get/context/:context"}
		,{ "$POST/api/scope/:context/$" = "/api:public/post/context/:context"}

		,{ "$POST/api/auth/login/$" = "/api:main/login"}
		,{ "$GET/api/auth/login/$" = "/api:main/login"}

		,{ "$POST/api/log/$" = "/api:main/log"}

		,{ "$GET/api/$" = "/api:main/get/" }
		,{ "$GET/api/:entityName/$" = "/api:main/get/entityName/:entityName"}
		,{ "$GET/api/:entityName/:entityID/$" = "/api:main/get/entityName/:entityName/entityID/:entityID"}

		,{ "$POST/api/$" = "/api:main/post/" }
		,{ "$POST/api/:entityName/:entityID/$" = "/api:main/post/entityName/:entityName/entityID/:entityID"}

	];

	// Hibachi Setup
	variables.framework.hibachi = {};
	variables.framework.hibachi.authenticationSubsystems = "admin,public,api";
	variables.framework.hibachi.beanFactoryOmitDirectoryAliases = true;
	variables.framework.hibachi.debugFlag = false;
	variables.framework.hibachi.updateDestinationContentExclustionList = '/.git,/apps,/integrationServices,/custom,/WEB-INF,/.project,/setting.xml,/.htaccess,/web.config,/.settings,/.gitignore';
	variables.framework.hibachi.gzipJavascript = true;
	variables.framework.hibachi.errorDisplayFlag = false;
	variables.framework.hibachi.errorNotifyEmailAddresses = '';
	variables.framework.hibachi.fullUpdateKey = "update";
	variables.framework.hibachi.fullUpdatePassword = "true";
	variables.framework.hibachi.runDbDataKey = 'runDbData';
	variables.framework.hibachi.loginSubsystems = "admin,public";
	variables.framework.hibachi.loginDefaultSubsystem = 'admin';
	variables.framework.hibachi.loginDefaultSection = 'main';
	variables.framework.hibachi.loginDefaultItem = 'login';
	variables.framework.hibachi.useCachingEngineFlag = false;
	variables.framework.hibachi.isApplicationStart = false;

	variables.framework.hibachi.noaccessDefaultSubsystem = 'admin';
	variables.framework.hibachi.noaccessDefaultSection = 'main';
	variables.framework.hibachi.noaccessDefaultItem = 'noaccess';
	variables.framework.hibachi.sessionCookieDomain = "";
	variables.framework.hibachi.lineBreakStyle = SERVER.OS.NAME;
	variables.framework.hibachi.disableFullUpdateOnServerStartup = false;
	variables.framework.hibachi.skipDbData = false;
	variables.framework.hibachi.useServerInstanceCacheControl=true;
	variables.framework.hibachi.availableEnvironments = ['local','development','production'];
	
	// Allow For Application Config
	try{include "../../config/configFramework.cfm";}catch(any e){}
	// Allow For Instance Config
	try{include "../../custom/config/configFramework.cfm";}catch(any e){}
	
	// Allow For DevOps Config
	try{include "../../../configFramework.cfm";}catch(any e){} 
	try{include "../../../../configFramework.cfm";}catch(any e){} 
	
	if(structKeyExists(url, variables.framework.hibachi.runDbDataKey)){
		variables.framework.hibachi.skipDbData = false;
	}

	public string function getEnvironment() {
		for(var i = 1; i <= arrayLen(variables.framework.hibachi.availableEnvironments); i++){
			if( structKeyExists(variables.framework.hibachi, '#variables.framework.hibachi.availableEnvironments[i]#UrlPattern')){
				var currentEnvironmentUrlPattern = variables.framework.hibachi['#variables.framework.hibachi.availableEnvironments[i]#UrlPattern'];
				if(len(currentEnvironmentUrlPattern) && REFindNoCase(currentEnvironmentUrlPattern,cgi.server_name)){
					return  variables.framework.hibachi.availableEnvironments[i];
				}
			}
		}
		return 'production';
	}
	

	// =============== configMappings

	// Defaults
	this.mappings[ "/#variables.framework.applicationKey#" ] = replace(replace(getDirectoryFromPath(getCurrentTemplatePath()),"\","/","all"), "/org/Hibachi/", "");
	this.mappings[ '/framework' ] = replace(getDirectoryFromPath(getCurrentTemplatePath()),"\","/","all") & '/framework';

	// Allow For Application Config
	try{include "../../config/configMappings.cfm";}catch(any e){}
	// Allow For Instance Config
	try{include "../../custom/config/configMappings.cfm";}catch(any e){}
	
	
	// Allow For DevOps Config
	try{include "../../../configMapping.cfm";}catch(any e){} 
	try{include "../../../../configMapping.cfm";}catch(any e){} 
	
		// ==================== START: SYSTEM GENERATED MIGRATION ======================
	if(
		!fileExists("#this.mappings[ '/#variables.framework.applicationKey#' ]#/custom/system/systemGeneratedMigration.txt.cfm") 
	
	){
		migrateGeneratedFilesToSystem();
	}


	// =============== configCustomTags

	// Allow For Application Config
	try{include "../../config/configCustomTags.cfm";}catch(any e){}
	// Allow For Instance Config
	try{include "../../custom/config/configCustomTags.cfm";}catch(any e){}

	// set the custom tag mapping
	if(structKeyExists(this, "customTagPathsArray") && isArray(this.customTagPathsArray) && arrayLen(this.customTagPathsArray)) {
		this.customTagPaths = arrayToList(this.customTagPathsArray);
	}

	// =============== configORM

	// Defaults
	this.ormenabled = true;
	this.ormsettings = {};
	this.ormsettings.cfclocation = [ "/#variables.framework.applicationKey#/model/entity" ];
	this.ormSettings.dbcreate = "update";
	this.ormSettings.flushAtRequestEnd = false;
	this.ormsettings.eventhandling = true;
	this.ormSettings.automanageSession = false;
	this.ormSettings.savemapping = false;
	this.ormSettings.skipCFCwitherror = false;
	this.ormSettings.useDBforMapping = false;
	this.ormSettings.autogenmap = true;
	this.ormSettings.logsql = false;

	// Allow For Application Config
	try{include "../../config/configORM.cfm";}catch(any e){}
	// Allow For Instance Config
	try{include "../../custom/config/configORM.cfm";}catch(any e){}
	
	
	// Allow For DevOps Config
	try{include "../../../configORM.cfm";}catch(any e){} 
	try{include "../../../../configORM.cfm";}catch(any e){}
	


	// ==================== END: SYSTEM GENERATED MIGRATION ======================

	// ==================== START: PRE UPDATE SCRIPTS ======================
	if(
		!variables.framework.hibachi.skipDbData
		&&(
			!fileExists("#this.mappings[ '/#variables.framework.applicationKey#' ]#/custom/system/lastFullUpdate.txt.cfm") 
			|| !fileExists("#this.mappings[ '/#variables.framework.applicationKey#' ]#/custom/system/preUpdatesRun.txt.cfm") 
			|| (structKeyExists(url, variables.framework.hibachi.fullUpdateKey) && url[ variables.framework.hibachi.fullUpdateKey ] == variables.framework.hibachi.fullUpdatePassword)
		)
	){
	
		

		this.ormSettings.secondaryCacheEnabled = false;

		variables.preupdate = {};

		if(!fileExists("#this.mappings[ '/#variables.framework.applicationKey#' ]#/custom/system/preUpdatesRun.txt.cfm")) {
			fileWrite("#this.mappings[ '/#variables.framework.applicationKey#' ]#/custom/system/preUpdatesRun.txt.cfm", "");
		}

		variables.preupdate.preUpdatesRun = fileRead("#this.mappings[ '/#variables.framework.applicationKey#' ]#/custom/system/preUpdatesRun.txt.cfm");



		// Loop over and run any pre-update files
		variables.preupdate.preUpdateFiles = directoryList("#this.mappings[ '/#variables.framework.applicationKey#' ]#/config/scripts/preupdate");

		for(variables.preupdate.preUpdateFullFilename in variables.preupdate.preUpdateFiles) {
			variables.preupdate.thisFilename = listLast(variables.preupdate.preUpdateFullFilename, "/\");
			if(!listFindNoCase(variables.preupdate.preUpdatesRun, variables.preupdate.thisFilename)) {
				include "../../config/scripts/preupdate/#variables.preupdate.thisFilename#";
				variables.preupdate.preUpdatesRun = listAppend(variables.preupdate.preUpdatesRun, variables.preupdate.thisFilename);
			}
		}

		fileWrite("#this.mappings[ '/#variables.framework.applicationKey#' ]#/custom/system/preUpdatesRun.txt.cfm", variables.preupdate.preUpdatesRun);
	}
	// ==================== END: PRE UPDATE SCRIPTS ======================
	// =======  END: ENVIRONMENT CONFIGURATION  =======
	
	public void function setupApplication() {
		
	}
    public void function setupEnvironment( env ) {

    }

    public void function setupSession() {

    }

    public void function setupSubsystem( module ) {

    }
    
    public void function migrateGeneratedFilesToSystem(){
    	var systemDirectoryPath = "#this.mappings[ '/#variables.framework.applicationKey#' ]#/custom/system";;
		
		var customConfigPath = "#this.mappings[ '/#variables.framework.applicationKey#' ]#/custom/config";
		var customConfigDirectory = directoryList(customConfigPath,false,'path','*.txt.cfm','asc');
		for(var generatedFilePath in customConfigDirectory){
			fileCopy(generatedFilePath,systemDirectoryPath);
		}
		fileWrite("#this.mappings[ '/#variables.framework.applicationKey#' ]#" & '/custom/system/systemGeneratedMigration.txt.cfm', now());
    }
    
    public void function createHibachiScope(){
		if(!structKeyExists(request, "#variables.framework.applicationKey#Scope")) {
            if(fileExists(expandPath('/#variables.framework.applicationKey#') & "/custom/model/transient/HibachiScope.cfc")) {
                request["#variables.framework.applicationKey#Scope"] = createObject("component", "#variables.framework.applicationKey#.custom.model.transient.HibachiScope").init();
            } else {
                request["#variables.framework.applicationKey#Scope"] = createObject("component", "#variables.framework.applicationKey#.model.transient.HibachiScope").init();
            }
        }
	}
	public string function getBaseURL() {
		if(len(variables.framework.baseURL) && variables.framework.baseURL == '/Slatwall'){
			return variables.framework.baseURL&'/';
		}
        return variables.framework.baseURL;
    }

	public any function bootstrap() {
		
		setupRequestDefaults();
 		createHibachiScope();
		setupGlobalRequest(noredirect=true);
		// Announce the applicatoinRequest event
		getHibachiScope().getService("hibachiEventService").announceEvent(eventName="onApplicationBootstrapRequestStart");

		return getHibachiScope();
	}

	public any function reloadApplication() {
		setupApplicationWrapper();
		createHibachiScope();
		lock name="application_#getHibachiInstanceApplicationScopeKey()#_initialized" timeout="20" {
			if( !structKeyExists(application, getHibachiInstanceApplicationScopeKey()) ) {
				application[ getHibachiInstanceApplicationScopeKey() ] = {};
			}
			application[ getHibachiInstanceApplicationScopeKey() ].initialized = false;
		}
	}

	public void function onApplicationStart(){
		variables.framework.hibachi.isApplicationStart = true;
		super.onApplicationStart();
	}

	public void function setupGlobalRequest(boolean noredirect=false) {
		createHibachiScope();
		
		var httpRequestData = GetHttpRequestData();
        getHibachiScope().setIsAwsInstance(variables.framework.isAwsInstance);
		// Verify that the application is setup
		verifyApplicationSetup(noredirect=arguments.noredirect);

			if(!variables.framework.hibachi.isApplicationStart && variables.framework.hibachi.useServerInstanceCacheControl){
			if(getHibachiScope().getService('hibachiCacheService').isServerInstanceCacheExpired(getHibachiScope().getServerInstanceIPAddress())){
				verifyApplicationSetup(reloadByServerInstance=true);
			}else{
				//RELOAD JUST THE SETTINGS
				if(getHibachiScope().getService('hibachiCacheService').isServerInstanceSettingsCacheExpired(getHibachiScope().getServerInstanceIPAddress())){
						getBeanFactory().getBean('hibachiCacheService').resetCachedKeyByPrefix('setting',true);
					var serverInstance = getBeanFactory().getBean('hibachiCacheService').getServerInstanceByServerInstanceIPAddress(getHibachiScope().getServerInstanceIPAddress(),true);
					serverInstance.setSettingsExpired(false);
						getBeanFactory().getBean('hibachiCacheService').saveServerInstance(serverInstance);
				}
			}
		}
		
		// Verify that the session is setup
		getHibachiScope().getService("hibachiSessionService").setProperSession();
		
		// CSRF / Duplicate Request Handling
		if(structKeyExists(request, "context")){
			getHibachiScope().getService("hibachiSessionService").verifyCSRF(request.context, this); 
		}	

		var AuthToken = "";
		if(structKeyExists(GetHttpRequestData().Headers,'Auth-Token')){
			AuthToken = GetHttpRequestData().Headers['Auth-Token'];
		}

		// If there is no account on the session, then we can look for an Access-Key, Access-Key-Secret, to setup that account for this one request.
		if(
			structKeyExists(httpRequestData, "headers") &&
			structKeyExists(httpRequestData.headers, "Access-Key") &&
			len(httpRequestData.headers["Access-Key"]) &&
			structKeyExists(httpRequestData.headers, "Access-Key-Secret") &&
			len(httpRequestData.headers["Access-Key-Secret"])) {

			var accessKey 		= httpRequestData.headers["Access-Key"];
			var accessKeySecret = httpRequestData.headers["Access-Key-Secret"];

			// Attempt to find an account by accessKey & accessKeySecret and set a default JWT if found.
			var accessKeyAccount = getHibachiScope().getService("AccountService").getAccountByAccessKeyAndSecret( accessKey=accessKey, accessKeySecret=accessKeySecret );

			// If an account was found, then set that account in the session for this request.  This should not persist
			if (!isNull(accessKeyAccount)){
				getHibachiScope().getSession().setAccount( accessKeyAccount );
				AuthToken = 'Bearer '& getHibachiScope().getService('HibachiJWTService').createToken();
			}
		}

		//check if we have the authorization header
		if(len(AuthToken)){

			var authorizationHeader = AuthToken;
			var prefix = 'Bearer ';
			//get token by stripping prefix
			var token = right(authorizationHeader,len(authorizationHeader) - len(prefix));
			var jwt = getHibachiScope().getService('HibachiJWTService').getJwtByToken(token);

			if(jwt.verify()){

				var jwtAccount = getHibachiScope().getService('accountService').getAccountByAccountID(jwt.getPayload().accountid);
				if(!isNull(jwtAccount)){
					jwtAccount.setJwtToken(jwt);
					getHibachiScope().getSession().setAccount( jwtAccount );
				}
			}

		}

		// Call the onEveryRequest() Method for the parent Application.cfc
		onEveryRequest();
		if(structKeyExists(request,'context')){
			getHibachiScope().getService("HibachiEventService").announceEvent(eventName="setupGlobalRequestComplete");
		}
	}

	public void function setupRequest() {

		if(!structKeyExists(request, "#variables.framework.applicationKey#Scope")) {
            if(fileExists(expandPath('/#variables.framework.applicationKey#') & "/custom/model/transient/HibachiScope.cfc")) {
                request["#variables.framework.applicationKey#Scope"] = createObject("component", "#variables.framework.applicationKey#.custom.model.transient.HibachiScope").init();
            } else {
                request["#variables.framework.applicationKey#Scope"] = createObject("component", "#variables.framework.applicationKey#.model.transient.HibachiScope").init();
            }
        }
		var status = 200;
		setupGlobalRequest();
		
		var httpRequestData = getHTTPRequestData();
		
		//Echo origin for OPTIONS preflight
		if( variables.framework.preflightOptions &&
        	request._fw1.cgiRequestMethod == "OPTIONS" &&
			structKeyExists(httpRequestData.headers,'Origin')
			){
			variables.framework.optionsAccessControl.origin = httpRequestData.headers['Origin'];
		}

		//Set an account before checking auth in case the user is trying to login via the REST API
		/* Handle JSON requests */
		var hasJsonData = false;
		request.context["jsonRequest"] = false;
		if(structKeyExists(httpRequestData.headers, "content-type") && httpRequestData.headers["content-type"] == "application/json") {
			//Automagically deserialize the JSON data if we can
			if ( StructKeyExists(httpRequestData, "content") ){
				//Decode from binary.
				try {
					var jsonString = "";
					if (isBinary(httpRequestData.content)){
						jsonString = charsetEncode( httpRequestData.content, "utf-8" );
					}else{
						jsonString = httpRequestData.content;
					}
					if (isJSON(jsonString)){
						var deserializedJson = deserializeJson(jsonString);
						request.context["deserializedJSONData"] = deserializedJson;
						hasJsonData = true;
						request.context["jsonRequest"] = true;
					}
				}catch(any e){
					//Could't deserialize the JSON data, should throw an error
				}
			}
		}else if(structKeyExists(request.context, 'serializedJSONData') && isSimpleValue(request.context.serializedJSONData) && isJSON(request.context.serializedJSONData)) {
			request.context["deserializedJsonData"] = deserializeJSON(request.context.serializedJSONData);
			hasJsonData = true;
		}

		/* Figure out if this is a public request */
		request.context["url"] = getHibachiScope().getURL();
		if (FindNoCase("/api/scope", request.context["url"]) ){
			//this is a request to the public controller
			request.context["usePublicAPI"] = true;
		}else{
			request.context["usePublicAPI"] = false;
		}

		application[ "#variables.framework.applicationKey#Bootstrap" ] = this.bootstrap;

		var restInfo = {};
		//prepare restinfo
		if(listFirst( request.context[ getAction() ], ":" ) == 'api'){
			var method = listLast( request.context[ getAction() ], "." );
			restInfo.method = method;
			if(structKeyExists(request,'context') && structKeyExists(request.context,'entityName')){
				restInfo.entityName = request.context.entityName;
			}
			if(structKeyExists(request,'context') && structKeyExists(request.context,'context')){
				restInfo.context = request.context.context;
			}
		}

		var authenticationArguments = {
			action=request.context[ getAction() ] ,
			account=getHibachiScope().getAccount(),
			restInfo=restInfo
		};
		if(structKeyExists(request,'context') && structKeyExists(request.context,'processContext')){
			authenticationArguments.processContext = lCase(request.context.processContext);
		}
		var authorizationDetails = getHibachiScope().getService("hibachiAuthenticationService").getActionAuthenticationDetailsByAccount(argumentCollection = authenticationArguments);
		
		// Get the hibachiConfig out of the application scope in case any changes were made to it
		var hibachiConfig = getHibachiScope().getApplicationValue("hibachiConfig");
		// Verify Authentication before anything happens

		if(
			!authorizationDetails.authorizedFlag
		) {
			// Get the hibachiConfig out of the application scope in case any changes were made to it
			var hibachiConfig = getHibachiScope().getApplicationValue("hibachiConfig");

			// setup the success redirect URL as this current page
			request.context.sRedirectURL = getHibachiScope().getURL();

			// make sure there are no reload keys in the redirectURL
			request.context.sRedirectURL = replace(request.context.sRedirectURL, "#variables.framework.reload#=#variables.framework.password#", "");
			request.context.sRedirectURL = replace(request.context.sRedirectURL, "#variables.framework.hibachi.fullUpdateKey#=#variables.framework.hibachi.fullUpdatePassword#", "");
			request.context.sRedirectURL = replace(request.context.sRedirectURL, "&&&", "&", "all");
			request.context.sRedirectURL = replace(request.context.sRedirectURL, "&&", "&", "all");
			if(right(request.context.sRedirectURL, 1) == "?" || right(request.context.sRedirectURL, 1) == "&") {
				request.context.sRedirectURL = left(request.context.sRedirectURL, len(request.context.sRedirectURL) - 1);
			}

			//Route the user to the noaccess page if they are already logged in
			if( getHibachiScope().getLoggedInFlag() ) {
				redirect(action="#getSubsystem(request.context[ getAction() ])#:#hibachiConfig.noaccessDefaultSection#.#hibachiConfig.noaccessDefaultItem#", preserve="swprid,sRedirectURL,entityName");
			} else {
					// If the current subsystem is a 'login' subsystem, then we can use the current subsystem
				if(find("ajaxsubmit=1", request.context.sRedirectURL)!=0 || find("modal=1", request.context.sRedirectURL)!=0 ){
					var context = getPageContext();
					status = 403;
					context.getResponse().setStatus(status, "#getSubsystem(request.context[ getAction() ])#:#hibachiConfig.loginDefaultSection#.#hibachiConfig.loginDefaultItem#");
					abort;
				} else if(listFindNoCase(hibachiConfig.loginSubsystems, getSubsystem(request.context[ getAction() ]))) {
					redirect(action="#getSubsystem(request.context[ getAction() ])#:#hibachiConfig.loginDefaultSection#.#hibachiConfig.loginDefaultItem#", preserve="swprid,sRedirectURL");
				} else {
					redirect(action="#hibachiConfig.loginDefaultSubsystem#:#hibachiConfig.loginDefaultSection#.#hibachiConfig.loginDefaultItem#", preserve="swprid,sRedirectURL");
				}
			}

		} else if(authorizationDetails.authorizedFlag && authorizationDetails.publicAccessFlag) {
			getHibachiScope().setPublicPopulateFlag( true );
		}

		//detect if we are on an angular hashbang page
		if(structKeyExists(url,'ng')){
		}else if(getSubsystem(request.context[ getAction() ]) == 'api'){
			var apiController = getController(getSection(),getSubSystem());
			var publicMethods = "";
			if(structKeyExists(apiController,'publicMethods')){
				publicMethods = apiController.publicMethods;
			}
			var context = getPageContext();
			if(!structKeyExists(request.context,'messages')){
				request.context.messages = [];
			}

			//if the api method is not a public method then check if we are still authorized to use it
			if(!listFindNoCase(publicMethods,getItem())){
				var message = {};
				if(structKeyExists(authorizationDetails,'forbidden') && authorizationDetails.forbidden == true){
					status = 403;
					context.getResponse().setStatus(status, "#getSubsystem(request.context[ getAction() ])#:#hibachiConfig.loginDefaultSection#.#hibachiConfig.loginDefaultItem#");
					message['message'] = 'forbidden';
				}else if(structKeyExists(authorizationDetails,'timeout') && authorizationDetails.timeout == true){
					status = getHibachiScope().getService("hibachiAuthenticationService").getInvalidCredentialsStatusCode();
					context.getResponse().setStatus(status, "#getSubsystem(request.context[ getAction() ])#:#hibachiConfig.loginDefaultSection#.#hibachiConfig.loginDefaultItem#");
					message['message'] = 'timeout';
				}else if(structKeyExists(authorizationDetails,'invalidToken') && authorizationDetails.invalidToken == true){
					status = getHibachiScope().getService("hibachiAuthenticationService").getInvalidCredentialsStatusCode();
					context.getResponse().setStatus(status, "#getSubsystem(request.context[ getAction() ])#:#hibachiConfig.loginDefaultSection#.#hibachiConfig.loginDefaultItem#");
					message['message'] = 'invalid_token';
				}
				//did we get an error? if so stop!
				if(status != 200){
					var message['messageType'] = 'error';
					arrayAppend(request.context.messages,message);
					renderApiResponse();
				}

			}
		}

		// Setup structured Data if a request context exists meaning that a full action was called
		getHibachiScope().getService("hibachiUtilityService").buildFormCollections(request.context);

		// Setup a $ in the request context, and the hibachiScope shortcut
		request.context.fw = getHibachiScope().getApplicationValue("application");
		request.context.$ = {};
		request.context.$.Hibachi = getHibachiScope();
		request.context.$[ variables.framework.applicationKey ] = getHibachiScope();
		request.context.pagetitle = request.context.$[ variables.framework.applicationKey ].rbKey( request.context[ getAction() ] );
		request.context.edit = false;

		param name="request.context.ajaxRequest" default="false";
		param name="request.context.returnJSONObjects" default="";
		param name="request.context.returnJSONKeyLCase" default="false";
		param name="request.context.messages" default="#arrayNew(1)#";

		request.context.ajaxResponse = {};

		if(structKeyExists(httpRequestData.headers, "X-Hibachi-AJAX") && isBoolean(httpRequestData.headers["X-Hibachi-AJAX"]) && httpRequestData.headers["X-Hibachi-AJAX"]) {
			request.context.ajaxRequest = true;
		}

		// Check to see if any message keys were passed via the URL
		if(structKeyExists(request.context, "messageKeys")) {
			var messageKeys = listToArray(request.context.messageKeys);
			for(var i=1; i<=arrayLen(messageKeys); i++) {
				getHibachiScope().showMessageKey( messageKeys[i] );
			}
		}

		// Call the onInternalRequest() Method for the parent Application.cfc
		onInternalRequest();

		// Announce the applicatoinRequestStart event
		getHibachiScope().getService("hibachiEventService").announceEvent(eventName="onApplicationRequestStart");
	}

	public boolean function hasReloadKey(){

		return (
			structKeyExists(url, variables.framework.reload)
			&& url[variables.framework.reload] == variables.framework.password
		) || !hasBeanFactory();
	}

	public void function verifyApplicationSetup(reloadByServerInstance=false,noredirect=false) {
		createHibachiScope();
		if(
			(
				hasReloadKey()
			) || reloadByServerInstance
		) {
			getHibachiScope().setApplicationValue("initialized", false);
		}

		// Check to see if out application stuff is initialized
		if(!getHibachiScope().hasApplicationValue("initialized") || !getHibachiScope().getApplicationValue("initialized")) {
			// If not, lock the application until this is finished
			lock scope="Application" timeout="2400"  {

				// Set the request timeout to 2400
				createObject("#variables.framework.applicationKey#.org.Hibachi.HibachiTagService").cfsetting(requesttimeout=2400);

				// Check again so that the qued requests don't back up
				if(!getHibachiScope().hasApplicationValue("initialized") || !getHibachiScope().getApplicationValue("initialized")) {

					// Setup the app init data
					var applicationInitData = {};
					applicationInitData["initialized"] = 				false;
					applicationInitData["instantiationKey"] =			createUUID();
					applicationInitData["application"] = 				this;
					applicationInitData["applicationKey"] = 			variables.framework.applicationKey;
					applicationInitData["applicationEnvironment"] = 	getEnvironment();
					applicationInitData["applicationRootMappingPath"] = this.mappings[ "/#variables.framework.applicationKey#" ];
					applicationInitData["applicationReloadKey"] = 		variables.framework.reload;
					applicationInitData["applicationReloadPassword"] =	variables.framework.password;
					applicationInitData["updateDestinationContentExclustionList"] = variables.framework.hibachi.updateDestinationContentExclustionList;
					applicationInitData["applicationUpdateKey"] = 		variables.framework.hibachi.fullUpdateKey;
					applicationInitData["applicationUpdatePassword"] =	variables.framework.hibachi.fullUpdatePassword;
					applicationInitData["debugFlag"] =					variables.framework.hibachi.debugFlag;
					applicationInitData["gzipJavascript"] = 			variables.framework.hibachi.gzipJavascript;
					applicationInitData["errorDisplayFlag"] =			variables.framework.hibachi.errorDisplayFlag;
					applicationInitData["errorNotifyEmailAddresses"] =	variables.framework.hibachi.errorNotifyEmailAddresses;
					applicationInitData["baseURL"] = 					variables.framework.baseURL;
					applicationInitData["action"] = 					variables.framework.action;
					applicationInitData["hibachiConfig"] =				variables.framework.hibachi;
					applicationInitData["lineBreakStyle"] =				variables.framework.hibachi.lineBreakStyle;
					applicationInitData["skipDbData"] = 				variables.framework.hibachi.skipDbData;
					// Log the setup start with values
					writeLog(file="#variables.framework.applicationKey#", text="General Log - Application setup started.");
					for(var key in applicationInitData) {
						if(isSimpleValue(applicationInitData[key])) {
							writeLog(file="#variables.framework.applicationKey#", text="General Log - Application Init '#key#' as: #applicationInitData[key]#");
						}
					}

					// Application Setup Started
					if(!structKeyExists(application,getHibachiInstanceApplicationScopeKey())){
						application[ getHibachiInstanceApplicationScopeKey() ] = applicationInitData;
					}else{
						for(var key in applicationInitData){
							application[getHibachiInstanceApplicationScopeKey()][key]=applicationInitData[key];
						}
					}
					
					writeLog(file="#variables.framework.applicationKey#", text="General Log - Application cache cleared, and init values set.");

					//Add application name to ckfinder
					fileWrite(expandPath('/#variables.framework.applicationKey#') & '/org/Hibachi/ckfinder/core/connector/cfm/configApplication.cfm', '<cfset this.name="#this.name#" />');

					// =================== Required Application Setup ===================
					// The FW1 Application had not previously been loaded so we are going to call onApplicationStart()
					if(!structKeyExists(application, variables.framework.applicationKey)) {
						writeLog(file="#variables.framework.applicationKey#", text="General Log - onApplicationStart() was called");

						writeLog(file="#variables.framework.applicationKey#", text="General Log - onApplicationStart() finished");
					}
					// ================ END: Required Application Setup ==================

					//========================= IOC SETUP ====================================
					
					// NOTE: ioc config omitDirectoryAliases does affect reload performance, when it is false it takes 2x longer to execute beanFactory.load()
					
					// Discover Hibachi beans
					// Need to have omitDirectoryAliases=true, the beanFactory's info will be used to compile list of class names and comparisons
					var hibachiBF = new framework.hibachiaop("/#variables.framework.applicationKey#/org/Hibachi", {
						constants={
							'applicationKey'=variables.framework.applicationKey,
							'hibachiInstanceApplicationScopeKey'=getHibachiInstanceApplicationScopeKey()
						},
						recurse=false,
						exclude=[
							"Hibachi.cfc","HibachiObject.cfc","HibachiTransient.cfc","HibachiProcess.cfc","HibachiEntity.cfc"
							,"HibachiEventHandler.cfc","HibachiController.cfc","HibachiControllerEntity.cfc","HibachiControllerREST.cfc"
						],
						singletonPattern="(Service|DAO)$",
						omitDirectoryAliases = variables.framework.hibachi.beanFactoryOmitDirectoryAliases
					});
					
					// Setup the core bean factory
					var coreBF = new framework.hibachiaop("/#variables.framework.applicationKey#/model", {
						transients=["entity", "process", "transient", "report"],
						transientPattern="Bean$",
						omitDirectoryAliases = variables.framework.hibachi.beanFactoryOmitDirectoryAliases
					});
					
					// Manually declare any Hibachi beans that are missing from the coreBF factory as a fallback
					// NOTE: We cannot rely on coreBF.setParent(hibachiBF) to inject to proper dependency because of ambiguity with overridden class names in various locations Slatwall.org.Hibachi, Slatwall.model, Slatwall.custom.model, Slatwall.integrationServices.{integrationPackage}.model
					var hibachiBeanInfo = hibachiBF.getBeanInfo().beanInfo;
					var hibachiFallbackBeanNameList = '';
					for (var beanName in hibachiBeanInfo) {
						if (beanName != "beanFactory") {
							
							// NOTE: Canonicalize beanName using CFC, without ioc.config.omitDirectorAliases=true, we'll get false negatives testing conditions and end up creating beans that shouldn't be created
							if (structKeyExists(hibachiBeanInfo[beanName], "cfc")) {
								
								// Canonicalized using cfc class name instead of beanName because beanName might be unique but just represent an alias (eg. "{className}Hibachi") for an identical cfc. Prevents cfc from being declared twice with different beanName alias
								var canonicalizedBeanName = listLast(hibachiBeanInfo[beanName].cfc, '.');
								
								// Check if beanName needs to be explicitly declared
								if (!coreBF.containsBean(canonicalizedBeanName)) {
									
									// Adding bean to core bean factory using canonicalized class name
									coreBF.declareBean(canonicalizedBeanName, hibachiBeanInfo[beanName].cfc, hibachiBeanInfo[beanName].isSingleton);
									hibachiFallbackBeanNameList = listAppend(hibachiFallbackBeanNameList, canonicalizedBeanName);
								}
							} else if (structKeyExists(hibachiBeanInfo[beanName], "value")) {
								// Adding bean by instantiated value
								coreBF.addBean(beanName, hibachiBeanInfo[beanName].value);
							}
						}
					}
					
					// writeLog(file="#variables.framework.applicationKey#", text="General Log - Bean Factory declared 'Hibachi' fallback beans for: #replace(listSort(hibachiFallbackBeanNameList, 'textnocase'), ',', ', ', 'all')#");
					
					// Setup the custom bean factory
					if(directoryExists("#getHibachiScope().getApplicationValue("applicationRootMappingPath")#/custom/model")) {
						var customBF = new framework.hibachiaop("/#variables.framework.applicationKey#/custom/model", {
							transients=["process", "transient", "report"],
							exclude=["entity"],
							omitDirectoryAliases = variables.framework.hibachi.beanFactoryOmitDirectoryAliases
						});
						
						// All beans in customBF overwrite or added to bean declarations in coreBF
						var customBeanInfo = customBF.getBeanInfo().beanInfo;
						var customBeanNameList = '';
						for (var beanName in customBeanInfo) {
							if (beanName != "beanFactory") {
								
								// NOTE: Canonicalize beanName using CFC, without ioc.config.omitDirectorAliases=true, we'll get false negatives testing conditions and end up creating beans that shouldn't be created
								if (structKeyExists(customBeanInfo[beanName], "cfc")) {
									
									// Canonicalized using cfc class name instead of beanName because beanName might be unique but just represent an alias (eg. "{className}Hibachi") for an identical cfc. Prevents cfc from being declared twice with different beanName alias
									var canonicalizedBeanName = listLast(customBeanInfo[beanName].cfc, '.');
										
									// Adding bean to core bean factory using canonicalized class name
									coreBF.declareBean(canonicalizedBeanName, customBeanInfo[beanName].cfc, customBeanInfo[beanName].isSingleton);
									customBeanNameList = listAppend(customBeanNameList, canonicalizedBeanName);
								} else if (structKeyExists(hibachiBeanInfo[beanName], "value")) {
									// Adding bean by instantiated value
									coreBF.addBean(beanName, customBeanInfo[beanName].value);
								}
							}
						}
						
						// writeLog(file="#variables.framework.applicationKey#", text="General Log - Bean Factory declared 'Custom' beans: #replace(listSort(customBeanNameList, 'textnocase'), ',', ', ', 'all')#");
						
					}
					
					setBeanFactory(coreBF);
					
					writeLog(file="#variables.framework.applicationKey#", text="General Log - Bean Factory Set");

					//========================= END: IOC SETUP ===============================
					
					// Call the onFirstRequest() Method for the parent Application.cfc
					onFirstRequest();
					// Manually forces all beans to reload and attempt injections. Modifying this should be done carefully and somewhat fragile. 
					// All bean factory flattening and aggregation has occured from Hibachi, Core, Custom., Integrations. This avoids potential missing bean errors after custom and integrationService setup
					// Performance worsens if setting the ioc.cfc config omitDirectoryAliases = false. Negatively impacts execution time of the load() method by 2x longer
					// NOTE: For more details about the quirk, view notes about the load() method in the org/hibachi/framework/hibachiaop.cfc
					getBeanFactory().load();
					onBeanFactoryLoadComplete();
					
					//==================== START: EVENT HANDLER SETUP ========================
					

					//===================== END: EVENT HANDLER SETUP =========================

					// ============================ FULL UPDATE =============================== (this is only run when updating, or explicitly calling it by passing update=true as a url key)
					var updated = false;
					var runFullUpdate = !variables.framework.hibachi.disableFullUpdateOnServerStartup
						&& (
							!structKeyExists(server,'runFullUpdate')
							|| (structKeyExists(server,'runFullUpdate') && server.runFullUpdate
						)
					);
					if(
						!fileExists(expandPath('/#variables.framework.applicationKey#/custom/system') & '/lastFullUpdate.txt.cfm')
						|| (
							structKeyExists(url, variables.framework.hibachi.fullUpdateKey)
							&& url[ variables.framework.hibachi.fullUpdateKey ] == variables.framework.hibachi.fullUpdatePassword
						)
						|| runFullUpdate
					){
						writeLog(file="#variables.framework.applicationKey#", text="General Log - Full Update Initiated");
						server.runFullUpdate = false;
						//Update custom properties

						var success = getHibachiScope().getService('updateService').updateEntitiesWithCustomProperties();
						getHibachiScope().getService("hibachiEventService").announceEvent(eventName="afterUpdateEntitiesWithCustomProperties");
						if (success){
							writeLog(file="Slatwall", text="General Log - Attempting to update entities with custom properties.");
						}else{
							writeLog(file="Slatwall", text="General Log - Error updating entities with custom properties");
						}
						// Reload ORM
						writeLog(file="#variables.framework.applicationKey#", text="General Log - ORMReload() started");
						getHibachiScope().clearApplicationValueByPrefix('class');
						ormReload();
						writeLog(file="#variables.framework.applicationKey#", text="General Log - ORMReload() was successful");
						
						// we have to migrate attribute data to custom properties now, if we have some that haven't been migrated yet
						
						getHibachiScope().getService('updateService').migrateAttributeValuesToCustomProperties();

						onUpdateRequest();

						// Write File
						fileWrite(expandPath('/#variables.framework.applicationKey#') & '/custom/system/lastFullUpdate.txt.cfm', now());
						updated = true;
						// Announce the applicationFullUpdate event
						getHibachiScope().getService("hibachiEventService").announceEvent("onApplicationFullUpdate");
					}
					// ========================== END: FULL UPDATE ==============================

					// Call the onFirstRequestPostUpdate() Method for the parent Application.cfc
					onFirstRequestPostUpdate();

					//==================== START: JSON BUILD SETUP ========================

					getBeanFactory().getBean('HibachiJsonService').createJson();

					//===================== END: JSON BUILD SETUP =========================

					//==================== START: UPDATE SERVER INSTANCE CACHE STATUS ========================

					//only run the update if it wasn't initiated by serverside cache being expired
					if(!variables.framework.hibachi.isApplicationStart){
					if(!arguments.reloadByServerInstance){
						getBeanFactory().getBean('hibachiCacheService').updateServerInstanceCache(getHibachiScope().getServerInstanceIPAddress());
					}else{
						var serverInstance = getBeanFactory().getBean('hibachiCacheService').getServerInstanceByServerInstanceIPAddress(getHibachiScope().getServerInstanceIPAddress(),true);
						serverInstance.setServerInstanceExpired(false);
							getBeanFactory().getBean('hibachiCacheService').saveServerInstance(serverInstance);
							getHibachiScope().flushORMSession();
						}						
					}

					//==================== END: UPDATE SERVER INSTANCE CACHE STATUS ========================

					// Application Setup Ended
					getHibachiScope().setApplicationValue("initialized", true);
					writeLog(file="#variables.framework.applicationKey#", text="General Log - Application Setup Complete");

					// Announce the applicationSetup event
					getHibachiScope().getService("hibachiEventService").announceEvent("onApplicationSetup");
					if(!arguments.noredirect && updated && structKeyExists(request, "action")){

						redirect(action=request.action,queryString='updated=true');
					}
				}
			}
		}
	}

	public void function populateAPIHeaders(){
		param name="request.context.headers" default="#structNew()#";
		var httpRequestData = getHTTPRequestData();

		if(this.CORSEnabled && arrayLen(this.CORSWhitelist) && structKeyExists(httpRequestData.headers,'Origin') && !isNull(httpRequestData.headers['Origin'])){
			populateCORSHeader(httpRequestData.headers['Origin']);
		}
		if(!structKeyExists(request.context.headers,'Content-Type')){
			request.context.headers['Content-Type'] = 'application/json';
		}
		var context = getPageContext();
		context.getOut().clearBuffer();
		var response = context.getResponse();
		if(structKeyExists(request.context,'headers')){
			for(var header in request.context.headers){
				response.setHeader(header,request.context.headers[header]);
			}
		}
	}

	public void function populateCORSHeader(origin){
		var matched = false;
		for(var domain in this.CORSWhiteList){
			if(domain == '*'){
				request.context.headers['Access-Control-Allow-Origin'] = domain;
				matched = true;
				break;
			}else if(REfind(domain, arguments.origin)){
				request.context.headers['Access-Control-Allow-Origin'] = arguments.origin;
				matched = true;
				break;
			}
		}
		if(matched){
			request.context.headers['Access-Control-Allow-Credentials'] = true;
		}
	}

	public void function renderApiResponse(){

		param name="request.context.apiResponse.content" default="#structNew()#";
		//need response header for api
		var context = getPageContext();
		context.getOut().clearBuffer();
		var response = context.getResponse();
		populateAPIHeaders();
		var responseString = '';

		if(structKeyExists(request.context, "messages")) {
			if(!structKeyExists(request.context.apiResponse.content,'messages')){
				request.context.apiResponse.content["messages"] = request.context.messages;
			}else{
				for(var message in request.context.messages){
					arrayAppend(request.context.apiResponse.content["messages"],message);
				}

			}

		}

		//leaving a note here in case we ever wish to support XML for api responses
		if(isStruct(request.context.apiResponse.content) && request.context.headers['Content-Type'] eq 'application/json'){
			responseString = serializeJSON(request.context.apiResponse.content);

			// If running CF9 we need to fix strings that were improperly cast to numbers
			if(left(server.coldFusion.productVersion, 1) eq 9) {
				responseString = getHibachiScope().getService("hibachiUtilityService").updateCF9SerializeJSONOutput(responseString);
			}
		}
		if(isStruct(request.context.apiResponse.content) && request.context.headers['Content-Type'] eq 'application/xml'){
			//response String to xml placeholder
		}
		writeOutput( responseString );
		abort;
	}

	public void function setupResponse(rc) {
		param name="arguments.rc.ajaxRequest" default="false";
		param name="arguments.rc.ajaxResponse" default="#structNew()#";
		param name="arguments.rc.apiRequest" default="false";
		param name="arguments.rc.apiResponse.content" default="#structNew()#";

		if(getHibachiScope().getService('hibachiUtilityService').isInThread()){
			getHibachiScope().setPersistSessionFlag(false);
		}
		
		endHibachiLifecycle();
		// Announce the applicationRequestStart event
		getHibachiScope().getService("hibachiEventService").announceEvent(eventName="onApplicationRequestEnd");
		
		if(getHibachiScope().getService('hibachiUtilityService').isInThread()){
			abort;
		}

		// Check for an API Response
		if(arguments.rc.apiRequest) {
			renderApiResponse();
		}

		// Check for an Ajax Response
		if(arguments.rc.ajaxRequest && !structKeyExists(request, "exception")) {
			populateAPIHeaders();
			if(isStruct(arguments.rc.ajaxResponse)){
				if(structKeyExists(arguments.rc, "messages")) {
					arrayAppend(arguments.rc.messages,getHibachiScope().getMessages(),true);
					arguments.rc.ajaxResponse["messages"] = arguments.rc.messages;
				}
  				arguments.rc.ajaxResponse["successfulActions"] = getHibachiScope().getSuccessfulActions();
  				arguments.rc.ajaxResponse["failureActions"] = getHibachiScope().getFailureActions();
  				if(structKeyExists(arguments.rc, "returnJSONObjects") && len(arguments.rc.returnJSONObjects)) {
  					for(var item in listToArray(arguments.rc.returnJSONObjects)) {
  						if(structKeyExists(getHibachiScope(), "get#item#Data")) {
			  				arguments.rc.ajaxResponse[item] = getHibachiScope().invokeMethod("get#item#Data");
  						}
  					}
  				}
  			}
  			if(structKeyExists(arguments.rc, "returnJSONKeyLCase") && isBoolean(arguments.rc.returnJSONKeyLCase) && arguments.rc.returnJSONKeyLCase) {
				writeOutput( serializeJSON( getHibachiScope().getService("hibachiUtilityService").lcaseStructKeys(arguments.rc.ajaxResponse) ) );
			} else {
				writeOutput( serializeJSON(arguments.rc.ajaxResponse) );
			}
			abort;
		}

	}

	public void function setupView(rc) {
		
		param name="arguments.rc.ajaxRequest" default="false";

		if(arguments.rc.ajaxRequest) {
			setupResponse(rc);
		}

		if(structKeyExists(url, "modal") && url.modal) {
			request.layout = false;
			setLayout("#getSubsystem(arguments.rc[ getAction() ])#:modal");
		}
		
	}

	// Allows for custom views to be created for the admin, frontend or public subsystems
	public string function customizeViewOrLayoutPath( struct pathInfo, string type, string fullPath ) {
		if(!fileExists(expandPath(arguments.fullPath)) && left(listLast(arguments.fullPath, "/"), 6) eq "create" && fileExists(expandPath(replace(arguments.fullPath, "/create", "/detail")))) {
			return replace(arguments.fullPath, "/create", "/detail");
		} else if(!fileExists(expandPath(arguments.fullPath)) && left(listLast(arguments.fullPath, "/"), 4) eq "edit" && fileExists(expandPath(replace(arguments.fullPath, "/edit", "/detail")))) {
			return replace(arguments.fullPath, "/edit", "/detail");
		}

		return arguments.fullPath;
	}

	// Override from FW/1 so that we can make it public
	public string function getSubsystemDirPrefix( string subsystem ) {
		return super.getSubsystemDirPrefix( arguments.subsystem );
	}

	// This handels all of the ORM persistece.
	public void function endHibachiLifecycle() {

		if(getHibachiScope().getPersistSessionFlag()) {
			getHibachiScope().getService("hibachiSessionService").persistSession();
		}
		if(!getHibachiScope().getORMHasErrors()) {
			getHibachiScope().getDAO("hibachiDAO").flushORMSession();
		}

		// Commit audit queue
		getHibachiScope().getService("hibachiAuditService").commitAudits();
		getHibachiScope().getProfiler().logProfiler();
	}

	// Additional redirect function to redirect to an exact URL and flush the ORM Session when needed
	public void function redirectExact(required string redirectLocation, boolean addToken=false) {
		endHibachiLifecycle();

		if(!redirectLocation.startsWith('http')) {
			location(arguments.redirectLocation, arguments.addToken);
		} else {
			//Check to see if redirect link has a domain that is in the approved settings attribute
			var redirectDomainApprovedFlag = false;
			if (listLen( getHibachiScope().setting('globalAllowedOutsideRedirectSites') )){
				allowedDomainArray = listToArray( getHibachiScope().setting('globalAllowedOutsideRedirectSites') );

				for (var allowedDomain in allowedDomainArray){
					if ( LEFT(arguments.redirectLocation, len(allowedDomain)) == allowedDomain){
						redirectDomainApprovedFlag = true;
						break;
					}
				}
			}

			// Check to make sure that the redirect stays on the Slatwall site, redirect back to the Slatwall landing page.
			if ( getPageContext().getRequest().GetRequestUrl().toString() == LEFT(arguments.redirectLocation, len(getPageContext().getRequest().GetRequestUrl().toString())) || redirectDomainApprovedFlag == true ){
				location(arguments.redirectLocation, arguments.addToken);
			}else{
				location(getPageContext().getRequest().GetRequestUrl().toString(), arguments.addToken);
			}
		}
	}

	// This method will execute an actions controller, render the view for that action and return it without going through an entire lifecycle
	public string function doAction(required string action, struct data) {

		var response = "";
		var originalFW1 = {};
		var originalContext = {};
		var originalCFCBase = "";
		var originalBase = "";
		var originalURLAction = "";
		var originalFormAction = "";

		// If there was already a request._fw1, then we need to save it to be used later
		if(structKeyExists(request, "_fw1")) {
			originalFW1 = request._fw1;
			structDelete(request, "_fw1");
		}

		// If there was already a request.context, then we need to save it to be used later
		if(structKeyExists(request, "context")) {
			originalContext = request.context;
			structDelete(request, "context");
		}

		// We also need to store the original cfcbase if there was one
		if(structKeyExists(request, "cfcbase")) {
			originalCFCBase = request.cfcbase;
			structDelete(request, "cfcbase");
		}

		// We also need to store the original base if there was one
		if(structKeyExists(request, "base")) {
			originalBase = request.base;
			structDelete(request, "base");
		}

		// Look for an action in the URL
		if( structKeyExists(url, getAction() ) ) {
			originalURLAction = url[ getAction() ];
		}

		// Look for an action in the Form
		if( structKeyExists(form, getAction() ) ) {
			originalFormAction = form[ getAction() ];
		}

		// Set the passed in action to the form scope
		form[ getAction() ] = arguments.action;

		// create a new request context to hold simple data, and an empty request services so that the view() function works
		request.context = {};
		if(!isnull(arguments.data)){
			request.context = arguments.data;
		}

		request._fw1 = {
			cgiPathInfo=CGI.PATH_INFO,
	        cgiScriptName = CGI.SCRIPT_NAME,
	        cgiRequestMethod = CGI.REQUEST_METHOD,
	        controllers = [ ],
	        requestDefaultsInitialized = false,
	        services = [ ],
	        trace = [ ],
	        doTrace=false
	    };

		savecontent variable="response" {
			onRequestStart('/index.cfm');
			onRequest('/index.cfm');
			onRequestEnd();
		}

		// Remove the cfcbase & base from the request so that future actions don't get screwed up
		structDelete( request, 'context' );
		structDelete( request, '_fw1' );
		structDelete( request, 'cfcbase' );
		structDelete( request, 'base' );

		// If there was an override view action before... place it back into the request
		if(structCount(originalContext)) {
			request.context = originalContext;
		}

		// If there was an override view action before... place it back into the request
		if(structCount(originalFW1)) {
			request._fw1 = originalFW1;
		}

		// If there was a different cfcbase before... place it back into the request
		if(len(originalCFCBase)) {
			request.cfcbase = originalCFCBase;
		}

		// If there was a different base before... place it back into the request
		if(len(originalBase)) {
			request.base = originalBase;
		}

		if(len(originalURLAction)) {
			url[ getAction() ] = originalURLAction;
		}

		if(len(originalFormAction)) {
			form[ getAction() ] = originalFormAction;
		}

		return response;
	}

	// @hint private helper method
	public any function getHibachiScope() {
		if(!structKeyExists(request,"#variables.framework.applicationKey#Scope")){
			createHibachiScope();
		}
		return request["#variables.framework.applicationKey#Scope"];
	}

	// @hint setups an application scope value that will always be consistent
	public any function getHibachiInstanceApplicationScopeKey() {
		return getHibachiScope().getHibachiInstanceApplicationScopeKey();
	} 

	public void function onError(any exception, string event){
		//if something fails for any reason then we want to set the response status so our javascript can handle rest errors
		var context = getPageContext();
		var response = context.getResponse();
		
		//this will only run if we are updating from fw/1 2.2 to fw/1 4.x
		if(structKeyExists(exception,'cause') && structKeyExists(exception.cause,'message') && exception.cause.message == "Element CACHE.ROUTES.REGEX is undefined in a CFML structure referenced as part of an expression."){
			structDelete(application,variables.framework.applicationKey);
			applicationStop();
			location('?reload=true&update=true',false);
		}
		if(variables.framework.hibachi.errorDisplayFlag && structKeyExists(request,'context') && structKeyExists(request.context,'apiRequest') && request.context.apiRequest){
			writeDump(exception); abort;
		}
		response.setStatus(500);
		super.onError(arguments.exception,arguments.event);
	}

	// THESE METHODS ARE INTENTIONALLY LEFT BLANK AS EXTENSION POINTS
	public void function onEveryRequest() {}

	public void function onInternalRequest() {}

	public void function onFirstRequest() {}

	public void function onUpdateRequest() {}

	public void function onFirstRequestPostUpdate() {}
	
	public void function onBeanFactoryLoadComplete() {}

}
