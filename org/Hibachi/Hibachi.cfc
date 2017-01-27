component extends="FW1.framework" {
	
	// ======= START: ENVIORNMENT CONFIGURATION =======

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
	variables.framework.unhandledExtensions = 'cfc';
	variables.framework.unhandledPaths = '/flex2gateway';
	variables.framework.unhandledErrorCaught = false;
	variables.framework.preserveKeyURLKey = 'fw1pk';
	variables.framework.maxNumContextsPreserved = 10;
	variables.framework.cacheFileExists = false;
	variables.framework.trace = false;
	
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
	variables.framework.hibachi.debugFlag = false;
	variables.framework.hibachi.updateDestinationContentExclustionList = '/.git,/apps,/integrationServices,/custom,/WEB-INF,/.project,/setting.xml,/.htaccess,/web.config,/.settings,/.gitignore';
	variables.framework.hibachi.gzipJavascript = true;
	variables.framework.hibachi.errorDisplayFlag = false;
	variables.framework.hibachi.errorNotifyEmailAddresses = '';
	variables.framework.hibachi.fullUpdateKey = "update";
	variables.framework.hibachi.fullUpdatePassword = "true";
	variables.framework.hibachi.loginSubsystems = "admin,public";
	variables.framework.hibachi.loginDefaultSubsystem = 'admin';
	variables.framework.hibachi.loginDefaultSection = 'main';
	variables.framework.hibachi.loginDefaultItem = 'login';
	variables.framework.hibachi.useCachingEngineFlag = false;
	
	variables.framework.hibachi.noaccessDefaultSubsystem = 'admin';
	variables.framework.hibachi.noaccessDefaultSection = 'main';
	variables.framework.hibachi.noaccessDefaultItem = 'noaccess';
	variables.framework.hibachi.sessionCookieDomain = "";
	variables.framework.hibachi.lineBreakStyle = SERVER.OS.NAME;
	variables.framework.hibachi.disableFullUpdateOnServerStartup = false;
	
	// Allow For Application Config
	try{include "../../config/configFramework.cfm";}catch(any e){}
	// Allow For Instance Config
	try{include "../../custom/config/configFramework.cfm";}catch(any e){}
	
	
	// =============== configMappings
	
	// Defaults
	this.mappings[ "/#variables.framework.applicationKey#" ] = replace(replace(getDirectoryFromPath(getCurrentTemplatePath()),"\","/","all"), "/org/Hibachi/", "");
	
	// Allow For Application Config 
	try{include "../../config/configMappings.cfm";}catch(any e){}
	// Allow For Instance Config
	try{include "../../custom/config/configMappings.cfm";}catch(any e){}
	
	
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
	
	// ==================== START: PRE UPDATE SCRIPTS ======================
	if(!fileExists("#this.mappings[ '/#variables.framework.applicationKey#' ]#/custom/config/lastFullUpdate.txt.cfm") || !fileExists("#this.mappings[ '/#variables.framework.applicationKey#' ]#/custom/config/preUpdatesRun.txt.cfm") || (structKeyExists(url, variables.framework.hibachi.fullUpdateKey) && url[ variables.framework.hibachi.fullUpdateKey ] == variables.framework.hibachi.fullUpdatePassword)){
		
		this.ormSettings.secondaryCacheEnabled = false;
		
		variables.preupdate = {};
		
		if(!fileExists("#this.mappings[ '/#variables.framework.applicationKey#' ]#/custom/config/preUpdatesRun.txt.cfm")) {
			fileWrite("#this.mappings[ '/#variables.framework.applicationKey#' ]#/custom/config/preUpdatesRun.txt.cfm", "");
		}
		
		variables.preupdate.preUpdatesRun = fileRead("#this.mappings[ '/#variables.framework.applicationKey#' ]#/custom/config/preUpdatesRun.txt.cfm");
		
		
		
		// Loop over and run any pre-update files
		variables.preupdate.preUpdateFiles = directoryList("#this.mappings[ '/#variables.framework.applicationKey#' ]#/config/scripts/preupdate");
		
		for(variables.preupdate.preUpdateFullFilename in variables.preupdate.preUpdateFiles) {
			variables.preupdate.thisFilename = listLast(variables.preupdate.preUpdateFullFilename, "/\");
			if(!listFindNoCase(variables.preupdate.preUpdatesRun, variables.preupdate.thisFilename)) {
				include "../../config/scripts/preupdate/#variables.preupdate.thisFilename#";
				variables.preupdate.preUpdatesRun = listAppend(variables.preupdate.preUpdatesRun, variables.preupdate.thisFilename);
			}
		}
		
		fileWrite("#this.mappings[ '/#variables.framework.applicationKey#' ]#/custom/config/preUpdatesRun.txt.cfm", variables.preupdate.preUpdatesRun);
	}
	// ==================== END: PRE UPDATE SCRIPTS ======================
	
	// =======  END: ENVIORNMENT CONFIGURATION  =======
	
	public any function bootstrap() {
		setupGlobalRequest();
		
		// Announce the applicatoinRequest event
		getHibachiScope().getService("hibachiEventService").announceEvent(eventName="onApplicationBootstrapRequestStart");
		
		return getHibachiScope();
	}
	
	public any function reloadApplication() {
		setupApplicationWrapper();
		
		lock name="application_#getHibachiInstanceApplicationScopeKey()#_initialized" timeout="10" {
			if( !structKeyExists(application, getHibachiInstanceApplicationScopeKey()) ) {
				application[ getHibachiInstanceApplicationScopeKey() ] = {};
			}
			application[ getHibachiInstanceApplicationScopeKey() ].initialized = false;
		}
	}
	
	public void function setupGlobalRequest() {
		var httpRequestData = GetHttpRequestData();
		
		if(!structKeyExists(request, "#variables.framework.applicationKey#Scope")) {
            if(fileExists(expandPath('/#variables.framework.applicationKey#') & "/custom/model/transient/HibachiScope.cfc")) {
                request["#variables.framework.applicationKey#Scope"] = createObject("component", "#variables.framework.applicationKey#.custom.model.transient.HibachiScope").init();
            } else {
                request["#variables.framework.applicationKey#Scope"] = createObject("component", "#variables.framework.applicationKey#.model.transient.HibachiScope").init();
            }
			
			// Verify that the application is setup
			verifyApplicationSetup();
			// Verify that the session is setup
			getHibachiScope().getService("hibachiSessionService").setProperSession();
			
			var AuthToken = "";
			if(structKeyExists(GetHttpRequestData().Headers,'Auth-Token')){
				AuthToken = GetHttpRequestData().Headers['Auth-Token'];
			}
			
			// If there is no account on the session, then we can look for an Access-Key, Access-Key-Secret, to setup that account for this one request.
			if(!getHibachiScope().getLoggedInFlag() &&
				structKeyExists(httpRequestData, "headers") &&
				structKeyExists(httpRequestData.headers, "Access-Key") &&
				len(httpRequestData.headers["Access-Key"]) &&
				structKeyExists(httpRequestData.headers, "Access-Key-Secret") &&
				len(httpRequestData.headers["Access-Key-Secret"])) {

				var accessKey 		= httpRequestData.headers["Access-Key"];
				var accessKeySecret = httpRequestData.headers["Access-Key-Secret"];

				// Attempt to find an account by accessKey & accessKeySecret and set a default JWT if found.
				var account = getHibachiScope().getService("AccountService").getAccountByAccessKeyAndSecret( accessKey=accessKey, accessKeySecret=accessKeySecret );
				
				// If an account was found, then set that account in the session for this request.  This should not persist
				if (!isNull(account)){
					getHibachiScope().getSession().setAccount( account );
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
					var account = getHibachiScope().getService('accountService').getAccountByAccountID(jwt.getPayload().accountid);
					if(!isNull(account)){
						account.setJwtToken(jwt);
						getHibachiScope().getSession().setAccount( account );
					}
				}
			
			}
			// Call the onEveryRequest() Method for the parent Application.cfc
			onEveryRequest();
		}
		if(structKeyExists(request,'context')){
			getHibachiScope().getService("hibachiEventService").announceEvent(eventName="setupGlobalRequestComplete");
		}
	}
	
	public void function setupRequest() {
		var status = 200;
		setupGlobalRequest();
		var httpRequestData = getHTTPRequestData();

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
		
		var authorizationDetails = getHibachiScope().getService("hibachiAuthenticationService").getActionAuthenticationDetailsByAccount(action=request.context[ getAction() ] , account=getHibachiScope().getAccount(), restInfo=restInfo);	
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
	
	public void function verifyApplicationSetup() {
		if(structKeyExists(url, variables.framework.reload) && url[variables.framework.reload] == variables.framework.password) {
			getHibachiScope().setApplicationValue("initialized", false);
		}
		
		// Check to see if out application stuff is initialized
		if(!getHibachiScope().hasApplicationValue("initialized") || !getHibachiScope().getApplicationValue("initialized")) {
			// If not, lock the application until this is finished
			lock scope="Application" timeout="600"  {
				
				// Set the request timeout to 600
				createObject("Slatwall.org.Hibachi.HibachiTagService").cfsetting(requesttimeout=600);
						
				// Check again so that the qued requests don't back up
				if(!getHibachiScope().hasApplicationValue("initialized") || !getHibachiScope().getApplicationValue("initialized")) {
					
					// Setup the app init data
					var applicationInitData = {}; 
					applicationInitData["initialized"] = 				false;
					applicationInitData["instantiationKey"] =			createUUID();
					applicationInitData["application"] = 				this;
					applicationInitData["applicationKey"] = 			variables.framework.applicationKey;
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
					// Log the setup start with values
					writeLog(file="#variables.framework.applicationKey#", text="General Log - Application setup started.");
					for(var key in applicationInitData) {
						if(isSimpleValue(applicationInitData[key])) {
							writeLog(file="#variables.framework.applicationKey#", text="General Log - Application Init '#key#' as: #applicationInitData[key]#");	
						}
					}
					
					// Application Setup Started
					application[ getHibachiInstanceApplicationScopeKey() ] = applicationInitData;
					writeLog(file="#variables.framework.applicationKey#", text="General Log - Application cache cleared, and init values set.");

					//Add application name to ckfinder
					fileWrite(expandPath('/#variables.framework.applicationKey#') & '/org/Hibachi/ckfinder/core/connector/cfm/configApplication.cfm', '<cfset this.name="#this.name#" />');
					
					// =================== Required Application Setup ===================
					// The FW1 Application had not previously been loaded so we are going to call onApplicationStart()
					if(!structKeyExists(application, variables.framework.applicationKey)) {
						writeLog(file="#variables.framework.applicationKey#", text="General Log - onApplicationStart() was called");
						onApplicationStart();
						writeLog(file="#variables.framework.applicationKey#", text="General Log - onApplicationStart() finished");
					}
					// ================ END: Required Application Setup ==================
					
					//========================= IOC SETUP ====================================
					
					var coreBF = new DI1.ioc("/#variables.framework.applicationKey#/model", {
						transients=["entity", "process", "transient", "report"],
						transientPattern="Bean$"
					});
					
					coreBF.addBean("applicationKey", variables.framework.applicationKey);
					coreBF.addBean("hibachiInstanceApplicationScopeKey", getHibachiInstanceApplicationScopeKey());
					
					// If the default singleton beans were not found in the model, add a reference to the core one in hibachi
					if(!coreBF.containsBean("hibachiDAO")) {
						coreBF.declareBean("hibachiDAO", "#variables.framework.applicationKey#.org.Hibachi.HibachiDAO", true);	
					}
					if(!coreBF.containsBean("hibachiService")) {
						coreBF.declareBean("hibachiService", "#variables.framework.applicationKey#.org.Hibachi.HibachiService", true);	
					}
					if(!coreBF.containsBean("hibachiAuthenticationService")) {
						coreBF.declareBean("hibachiAuthenticationService", "#variables.framework.applicationKey#.org.Hibachi.HibachiAuthenticationService", true);	
					}
					if(!coreBF.containsBean("hibachiCacheService")) {
						coreBF.declareBean("hibachiCacheService", "#variables.framework.applicationKey#.org.Hibachi.HibachiCacheService", true);	
					}
					if(!coreBF.containsBean("hibachiDataService")) {
						coreBF.declareBean("hibachiDataService", "#variables.framework.applicationKey#.org.Hibachi.HibachiDataService", true);	
					}
					if(!coreBF.containsBean("hibachiDocsService")) {
						coreBF.declareBean("hibachiDocsService", "#variables.framework.applicationKey#.org.Hibachi.HibachiDocsService", true);
					}
					if(!coreBF.containsBean("hibachiEventService")) {
						coreBF.declareBean("hibachiEventService", "#variables.framework.applicationKey#.org.Hibachi.HibachiEventService", true);	
					}
					if(!coreBF.containsBean("hibachiRBService")) {
						coreBF.declareBean("hibachiRBService", "#variables.framework.applicationKey#.org.Hibachi.HibachiRBService", true);	
					}
					if(!coreBF.containsBean("hibachiReportService")) {
						coreBF.declareBean("hibachiReportService", "#variables.framework.applicationKey#.org.Hibachi.HibachiReportService", true);	
					}
					if(!coreBF.containsBean("hibachiSessionService")) {
						coreBF.declareBean("hibachiSessionService", "#variables.framework.applicationKey#.org.Hibachi.HibachiSessionService", true);	
					}
					if(!coreBF.containsBean("hibachiTagService")) {
						coreBF.declareBean("hibachiTagService", "#variables.framework.applicationKey#.org.Hibachi.HibachiTagService", true);	
					}
					if(!coreBF.containsBean("hibachiUtilityService")) {
						coreBF.declareBean("hibachiUtilityService", "#variables.framework.applicationKey#.org.Hibachi.HibachiUtilityService", true);	
					}
					if(!coreBF.containsBean("hibachiValidationService")) {
						coreBF.declareBean("hibachiValidationService", "#variables.framework.applicationKey#.org.Hibachi.HibachiValidationService", true);	
					}
					if(!coreBF.containsBean("hibachiCollectionService")) {
                        coreBF.declareBean("hibachiCollectionService", "#variables.framework.applicationKey#.org.Hibachi.HibachiCollectionService", true);  
                    } 
                    if(!coreBF.containsBean("hibachiYamlService")) {
                        coreBF.declareBean("hibachiYamlService", "#variables.framework.applicationKey#.org.Hibachi.HibachiYamlService", true);  
                    } 
                    if(!coreBF.containsBean("hibachiJWTService")) {
                        coreBF.declareBean("hibachiJWTService", "#variables.framework.applicationKey#.org.Hibachi.HibachiJWTService", true);  
                    } 
                    if(!coreBF.containsBean("hibachiJsonService")){
						coreBF.declareBean("hibachiJsonService", "#variables.framework.applicationKey#.org.Hibachi.HibachiJsonService",true);
					}
					// If the default transient beans were not found in the model, add a reference to the core one in hibachi
					if(!coreBF.containsBean("hibachiScope")) {
						coreBF.declareBean("hibachiScope", "#variables.framework.applicationKey#.org.Hibachi.HibachiScope", false);
					}
					if(!coreBF.containsBean("hibachiSmartList")) {
						coreBF.declareBean("hibachiSmartList", "#variables.framework.applicationKey#.org.Hibachi.HibachiSmartList", false);
					}
					if(!coreBF.containsBean("hibachiErrors")) {
						coreBF.declareBean("hibachiErrors", "#variables.framework.applicationKey#.org.Hibachi.HibachiErrors", false);
					}
					if(!coreBF.containsBean("hibachiMessages")) {
						coreBF.declareBean("hibachiMessages", "#variables.framework.applicationKey#.org.Hibachi.HibachiMessages", false);
					}
					if(!coreBF.containsBean("hibachiJWT")){
						coreBF.declareBean("hibachiJWT", "#variables.framework.applicationKey#.org.Hibachi.HibachiJWT",false);
					}
					if(!coreBF.containsBean("hibachiRecaptcha")){
						coreBF.declareBean("hibachiRecaptcha", "#variables.framework.applicationKey#.org.Hibachi.HibachiRecaptcha",false);
					}
					
					
					// Setup the custom bean factory
					if(directoryExists("#getHibachiScope().getApplicationValue("applicationRootMappingPath")#/custom/model")) {
						var customBF = new DI1.ioc("/#variables.framework.applicationKey#/custom/model", {
							transients=["process", "transient", "report"],
							exclude=["entity"]
						});
						
						// Folder argument is left blank because at this point bean discovery has already occurred and we will not be looking at directories
						var aggregateBF = new DI1.ioc("");
						
						// Process factories, last takes precendence
						var beanFactories = [coreBF, customBF];
						
						// Build the aggregate bean factory by manually declaring the beans
						for (var bf in beanFactories) {
							var beanInfo = bf.getBeanInfo().beanInfo;
							for (var beanName in beanInfo) {
								// Manually declare all beans from current bean factory except for the automatically generated beanFactory self reference
								if (beanName != "beanFactory") {
									if (structKeyExists(beanInfo[beanName], "cfc")) {
										// Adding bean by class name
										aggregateBF.declareBean(beanName, beanInfo[beanName].cfc, beanInfo[beanName].isSingleton);
									} else if (structKeyExists(beanInfo[beanName], "value")) {
										// Adding bean by instantiated value
										aggregateBF.addBean(beanName, beanInfo[beanName].value);
									}
								}
							}
						}
						
						setBeanFactory(aggregateBF);
					} else {
						setBeanFactory(coreBF);
					}
					writeLog(file="#variables.framework.applicationKey#", text="General Log - Bean Factory Set");
					
					//========================= END: IOC SETUP ===============================
					
					// Call the onFirstRequest() Method for the parent Application.cfc
					onFirstRequest();
					
					var runFullUpdate = !variables.framework.hibachi.disableFullUpdateOnServerStartup 
						&& (
							!structKeyExists(server,'runFullUpdate') 
							|| (structKeyExists(server,'runFullUpdate') && server.runFullUpdate
						)
					);
					// ============================ FULL UPDATE =============================== (this is only run when updating, or explicitly calling it by passing update=true as a url key)
					if(
						!fileExists(expandPath('/#variables.framework.applicationKey#/custom/config') & '/lastFullUpdate.txt.cfm') 
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
						if (success){
							writeLog(file="Slatwall", text="General Log - Attempting to update entities with custom properties.");
						}else{
							writeLog(file="Slatwall", text="General Log - Error updating entities with custom properties");
						}
						
						// Reload ORM
						writeLog(file="#variables.framework.applicationKey#", text="General Log - ORMReload() started");
						ormReload();
						writeLog(file="#variables.framework.applicationKey#", text="General Log - ORMReload() was successful"); 
						
						onUpdateRequest();
						
						// Write File
						fileWrite(expandPath('/#variables.framework.applicationKey#') & '/custom/config/lastFullUpdate.txt.cfm', now());				
						
						// Announce the applicationFullUpdate event
						getHibachiScope().getService("hibachiEventService").announceEvent("onApplicationFullUpdate");
					}
					// ========================== END: FULL UPDATE ==============================
					
					// Call the onFirstRequestPostUpdate() Method for the parent Application.cfc
					onFirstRequestPostUpdate();
					
					//==================== START: EVENT HANDLER SETUP ========================
					
					getBeanFactory().getBean('hibachiEventService').registerEventHandlers();
					
					//===================== END: EVENT HANDLER SETUP =========================
					
					//==================== START: JSON BUILD SETUP ========================
					
					getBeanFactory().getBean('hibachiJsonService').createJson();
					
					//===================== END: JSON BUILD SETUP =========================
					
					// Application Setup Ended
					getHibachiScope().setApplicationValue("initialized", true);
					writeLog(file="#variables.framework.applicationKey#", text="General Log - Application Setup Complete");
					
					// Announce the applicationSetup event
					getHibachiScope().getService("hibachiEventService").announceEvent("onApplicationSetup");
					
				}
			}
		}
	}
	
	public void function populateAPIHeaders(){
		param name="request.context.headers" default="#structNew()#"; 
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
					request.context.apiResponse.content["messages"];	
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
	
	public void function setupResponse() {
		param name="request.context.ajaxRequest" default="false";
		param name="request.context.ajaxResponse" default="#structNew()#";
		param name="request.context.apiRequest" default="false";
		param name="request.context.apiResponse.content" default="#structNew()#";
		
		endHibachiLifecycle();
		// Announce the applicationRequestStart event
		getHibachiScope().getService("hibachiEventService").announceEvent(eventName="onApplicationRequestEnd");
		
		
		// Check for an API Response
		if(request.context.apiRequest) {
			renderApiResponse();
		}		
		// Check for an Ajax Response
		if(request.context.ajaxRequest && !structKeyExists(request, "exception")) {
			populateAPIHeaders();
			if(isStruct(request.context.ajaxResponse)){
				if(structKeyExists(request.context, "messages")) {
					request.context.ajaxResponse["messages"] = request.context.messages;	
				}
  				request.context.ajaxResponse["successfulActions"] = getHibachiScope().getSuccessfulActions();
  				request.context.ajaxResponse["failureActions"] = getHibachiScope().getFailureActions();
  				if(structKeyExists(request.context, "returnJSONObjects") && len(request.context.returnJSONObjects)) {
  					for(var item in listToArray(request.context.returnJSONObjects)) {
  						if(structKeyExists(getHibachiScope(), "get#item#Data")) {
			  				request.context.ajaxResponse[item] = getHibachiScope().invokeMethod("get#item#Data");
  						}
  					}
  				}
  			}
  			if(structKeyExists(request.context, "returnJSONKeyLCase") && isBoolean(request.context.returnJSONKeyLCase) && request.context.returnJSONKeyLCase) {
				writeOutput( serializeJSON( getHibachiScope().getService("hibachiUtilityService").lcaseStructKeys(request.context.ajaxResponse) ) );	
			} else {
				writeOutput( serializeJSON(request.context.ajaxResponse) );
			}
			abort;
		}
		
	}
	
	public void function setupView() {
		param name="request.context.ajaxRequest" default="false";
		
		if(request.context.ajaxRequest) {
			setupResponse();
		}
		
		if(structKeyExists(url, "modal") && url.modal) {
			request.layout = false;
			setLayout("#getSubsystem(request.context[ getAction() ])#:modal");
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
				location(getPageContext().getRequest().GetRequestUrl().toString(), arguments.addToken)
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
	        cgiScriptName = CGI.SCRIPT_NAME,
	        cgiRequestMethod = CGI.REQUEST_METHOD,
	        controllers = [ ],
	        requestDefaultsInitialized = false,
	        services = [ ],
	        trace = [ ]
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
		return request["#variables.framework.applicationKey#Scope"];
	}
	
	// @hint setups an application scope value that will always be consistent
	public any function getHibachiInstanceApplicationScopeKey() {
		var metaData = getMetaData( this );
		do {
			var filePath = metaData.path;
			metaData = metaData.extends;
		} while( structKeyExists(metaData, "extends") );
		
		filePath = lcase(replaceNoCase(getDirectoryFromPath(replace(filePath,"\","/","all")), "/fw1/","/","all"));
		var appKey = hash(filePath);
		
		return appKey;
	}
	
	public void function onError(any exception, string event){
		//if something fails for any reason then we want to set the response status so our javascript can handle rest errors
		var context = getPageContext();
		var response = context.getResponse();
		response.setStatus(500);
		super.onError(arguments.exception,arguments.event);
	}
	
	// THESE METHODS ARE INTENTIONALLY LEFT BLANK
	public void function onEveryRequest() {}
	
	public void function onInternalRequest() {}
	
	public void function onFirstRequest() {}
	
	public void function onUpdateRequest() {}
	
	public void function onFirstRequestPostUpdate() {}
	
}
