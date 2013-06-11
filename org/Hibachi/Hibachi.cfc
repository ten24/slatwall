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
  	variables.framework.SESOmitIndex = true;
  	variables.framework.suppressImplicitService = true;
	variables.framework.unhandledExtensions = 'cfc';
	variables.framework.unhandledPaths = '/flex2gateway';
	variables.framework.unhandledErrorCaught = false;
	variables.framework.preserveKeyURLKey = 'fw1pk';
	variables.framework.maxNumContextsPreserved = 10;
	variables.framework.cacheFileExists = false;
	variables.framework.trace = false;
	variables.framework.routes = [
		{ "$GET/api/:entityName/:entityID" = "/admin:api/get/entityName/:entityName/entityID/:entityID"},
		{ "$GET/api/:entityName/" = "/admin:api/get/entityName/:entityName/"}
	];
	
	// Hibachi Setup
	variables.framework.hibachi = {};
	variables.framework.hibachi.fullUpdateKey = "update";
	variables.framework.hibachi.fullUpdatePassword = "true";
	variables.framework.hibachi.authenticationSubsystems = "admin,public";
	variables.framework.hibachi.loginSubsystems = "admin,public";
	variables.framework.hibachi.loginDefaultSubsystem = 'admin';
	variables.framework.hibachi.loginDefaultSection = 'main';
	variables.framework.hibachi.loginDefaultItem = 'login';
	
	
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
	
	// Defaults
	if(!structKeyExists(this, "customtagpaths")) {
		this.customtagpaths = ""; 
	}
	if(!listFindNoCase(this.customtagpaths, this.mappings[ "/#variables.framework.applicationKey#" ] & "/org/Hibachi/HibachiTags")) {
		this.customtagpaths = listAppend(this.customtagpaths, this.mappings[ "/#variables.framework.applicationKey#" ] & "/org/Hibachi/HibachiTags" );	
	}
	//this.customtagpaths = this.mappings[ "/#variables.framework.applicationKey#" ] & "/org/Hibachi/HibachiTags";
	
	// Allow For Application Config 
	try{include "../../config/configCustomTags.cfm";}catch(any e){}
	// Allow For Instance Config
	try{include "../../custom/config/configCustomTags.cfm";}catch(any e){}
	
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
	this.ormSettings.useDBforMapping = true;
	this.ormSettings.autogenmap = true;
	this.ormSettings.logsql = false;
	
	// Allow For Application Config 
	try{include "../../config/configORM.cfm";}catch(any e){}
	// Allow For Instance Config
	try{include "../../custom/config/configORM.cfm";}catch(any e){}
	
	if(!fileExists(expandPath('/#variables.framework.applicationKey#/config/lastFullUpdate.txt.cfm')) || (structKeyExists(url, variables.framework.hibachi.fullUpdateKey) && url[ variables.framework.hibachi.fullUpdateKey ] == variables.framework.hibachi.fullUpdatePassword)) {
		this.ormSettings.secondaryCacheEnabled = false;
	}
	
	// Make Sure that the required values end up in the application scope so that we can get them from somewhere else
	
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
		if(!structKeyExists(request, "#variables.framework.applicationKey#Scope")) {
			request["#variables.framework.applicationKey#Scope"] = createObject("component", "#variables.framework.applicationKey#.model.transient.HibachiScope").init();
			
			// Verify that the application is setup
			verifyApplicationSetup();
			
			// Verify that the session is setup
			getHibachiScope().getService("hibachiSessionService").setPropperSession();
			
			// Call the onEveryRequest() Method for the parent Application.cfc
			onEveryRequest();
		}
	}
	
	public void function setupRequest() {
		setupGlobalRequest();
		
		application[ "#variables.framework.applicationKey#Bootstrap" ] = this.bootstrap;
		
		// Verify Authentication before anything happens
		if(!getHibachiScope().authenticateAction( action=request.context[ getAction() ] )) {
			
			// Get the hibachiConfig out of the application scope in case any changes were made to it
			var hibachiConfig = getHibachiScope().getApplicationValue("hibachiConfig");
			
			// If the current subsytem is a 'login' subsystem, then we can use the current subsystem
			if(listFindNoCase(hibachiConfig.loginSubsystems, getSubsystem(request.context[ getAction() ]))) {
				redirect(action="#getSubsystem(request.context[ getAction() ])#:#hibachiConfig.loginDefaultSection#.#hibachiConfig.loginDefaultItem#");
			} else {
				redirect(action="#hibachiConfig.loginDefaultSubsystem#:#hibachiConfig.loginDefaultSection#.#hibachiConfig.loginDefaultItem#");
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
		request.context.ajaxRequest = false;
		request.context.ajaxResponse = {};
		if(!structKeyExists(request.context, "messages")) {
			request.context.messages = [];	
		}
		
		var httpRequestData = getHTTPRequestData();
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
			lock scope="Application" timeout="240"  {
				
				// Check again so that the qued requests don't back up
				if(!getHibachiScope().hasApplicationValue("initialized") || !getHibachiScope().getApplicationValue("initialized")) {
					
					// Setup the app init data
					var applicationInitData = {}; 
					applicationInitData["initialized"] = 				false;
					applicationInitData["application"] = 				this;
					applicationInitData["applicationKey"] = 			variables.framework.applicationKey;
					applicationInitData["applicationRootMappingPath"] = this.mappings[ "/#variables.framework.applicationKey#" ];
					applicationInitData["applicationReloadKey"] = 		variables.framework.reload;
					applicationInitData["applicationReloadPassword"] =	variables.framework.password;
					applicationInitData["applicationUpdateKey"] = 		variables.framework.hibachi.fullUpdateKey;
					applicationInitData["applicationUpdatePassword"] =	variables.framework.hibachi.fullUpdatePassword;
					applicationInitData["baseURL"] = 					variables.framework.baseURL;
					applicationInitData["action"] = 					variables.framework.action;
					applicationInitData["hibachiConfig"] =				variables.framework.hibachi;
					
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
						transients=["entity", "process", "transient"],
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
					if(!coreBF.containsBean("hibachiEventService")) {
						coreBF.declareBean("hibachiEventService", "#variables.framework.applicationKey#.org.Hibachi.HibachiEventService", true);	
					}
					if(!coreBF.containsBean("hibachiRBService")) {
						coreBF.declareBean("hibachiRBService", "#variables.framework.applicationKey#.org.Hibachi.HibachiRBService", true);	
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
					
					// Setup the custom bean factory
					if(directoryExists("#getHibachiScope().getApplicationValue("applicationRootMappingPath")#/custom/model")) {
						var customBF = new DI1.ioc("/#variables.framework.applicationKey#/custom/model", {
							transients=["entity", "process", "transient"]
						});
						
						customBF.setParent( coreBF );
						
						setBeanFactory( customBF );
					} else {
						setBeanFactory( coreBF );
					}
					writeLog(file="#variables.framework.applicationKey#", text="General Log - Bean Factory Set");
					
					//========================= END: IOC SETUP ===============================
					
					// Call the onFirstRequest() Method for the parent Application.cfc
					onFirstRequest();
					
					// Announce the applicationSetup event
					getHibachiScope().getService("hibachiEventService").announceEvent("onApplicationSetup");
					
					// ============================ FULL UPDATE =============================== (this is only run when updating, or explicitly calling it by passing update=true as a url key)
					if(!fileExists(expandPath('/#variables.framework.applicationKey#/config/lastFullUpdate.txt.cfm')) || (structKeyExists(url, variables.framework.hibachi.fullUpdateKey) && url[ variables.framework.hibachi.fullUpdateKey ] == variables.framework.hibachi.fullUpdatePassword)){
						writeLog(file="#variables.framework.applicationKey#", text="General Log - Full Update Initiated");
						
						// Set the request timeout to 360
						getHibachiScope().getService("hibachiTagService").cfsetting(requesttimeout=360);
						
						// Reload ORM
						writeLog(file="#variables.framework.applicationKey#", text="General Log - ORMReload() started");
						ormReload();
						writeLog(file="#variables.framework.applicationKey#", text="General Log - ORMReload() was successful");
							
						onUpdateRequest();
						
						// Write File
						fileWrite(expandPath('/#variables.framework.applicationKey#') & '/config/lastFullUpdate.txt.cfm', now());				
						
						// Announce the applicationFullUpdate event
						getHibachiScope().getService("hibachiEventService").announceEvent("onApplicationFullUpdate");
					}
					// ========================== END: FULL UPDATE ==============================
					
					// Application Setup Ended
					getHibachiScope().setApplicationValue("initialized", true);
					writeLog(file="#variables.framework.applicationKey#", text="General Log - Application Setup Complete");
				}
			}
		}
	}
	
	public void function setupResponse() {
		param name="request.context.ajaxRequest" default="false";
		param name="request.context.ajaxResponse" default="#structNew()#";
		
		endHibachiLifecycle();
		
		// Announce the applicatoinRequestStart event
		getHibachiScope().getService("hibachiEventService").announceEvent(eventName="onApplicationRequestEnd");
		
		if(request.context.ajaxRequest && !structKeyExists(request, "exception")) {
			request.context.ajaxResponse["messages"] = request.context.messages;
			writeOutput( serializeJSON(request.context.ajaxResponse) );
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
		if(!getHibachiScope().getORMHasErrors()) {
			getHibachiScope().getService("hibachiDAO").flushORMSession();
		}
	}
	
	// Additional redirect function to redirect to an exact URL and flush the ORM Session when needed
	public void function redirectExact(required string location, boolean addToken=false) {
		endHibachiLifecycle();
		location(arguments.location, arguments.addToken);
	}
	
	// This method will execute an actions controller, render the view for that action and return it without going through an entire lifecycle
	public string function doAction(required string action) {
		
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
	
	// THESE METHODS ARE INTENTIONALLY LEFT BLANK
	public void function onEveryRequest() {}
	
	public void function onInternalRequest() {}
	
	public void function onFirstRequest() {}
	
	public void function onUpdateRequest() {}
	
}
