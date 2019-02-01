component extends="Slatwall.org.Hibachi.HibachiEventHandler" {
	
	variables.fullSitePaths = {};
	variables.slatwallApplications = {};
	
	public any function getSlatwallAdminApplication() {
		return  createObject("component", "Slatwall.Application");
	}
	
	public any function getSlatwallCMSApplication(required any site) {
		var applicationDotPath = rereplace(arguments.site.getApp().getAppRootPath(),'/','.','all');
		return createObject("component", "Slatwall" & applicationDotPath & '.Application');
	}
	
	public any function getFullSitePath(required any site){
		if(!structKeyExists(variables.fullSitePaths,arguments.site.getSiteID())){
			variables.fullSitePaths[site.getSiteID()] = site.getSitePath();
		}
		return variables.fullSitePaths[site.getSiteID()];
	}
	
	//public any function get
	
	// This event handler will always get called
	public void function setupGlobalRequestComplete() {
		if ( len( getContextRoot() ) ) {
			var cgiScriptName = replace( CGI.SCRIPT_NAME, getContextRoot(), '' );
			var cgiPathInfo = replace( CGI.PATH_INFO, getContextRoot(), '' );
		} else {
			var cgiScriptName = CGI.SCRIPT_NAME;
			var cgiPathInfo = CGI.PATH_INFO;
		}
		var pathInfo = cgiPathInfo;
		 if ( len( pathInfo ) > len( cgiScriptName ) && left( pathInfo, len( cgiScriptName ) ) == cgiScriptName ) {
            // canonicalize for IIS:
            pathInfo = right( pathInfo, len( pathInfo ) - len( cgiScriptName ) );
        } else if ( len( pathInfo ) > 0 && pathInfo == left( cgiScriptName, len( pathInfo ) ) ) {
            // pathInfo is bogus so ignore it:
            pathInfo = '';
        }
        //take path and  parse it
        var pathArray = listToArray(pathInfo,'/');
        var pathArrayLen = arrayLen(pathArray);
        
        //Make sure this isn't a call to the api, if it is, return without using CMS logic
		if(pathArrayLen && pathArray[1] == 'api' || (structkeyExists(request,'context') && structKeyExists(request.context,'doNotRender'))){
        		return;
        }
        //try to get a site form the domain name
		var domainNameSite = arguments.slatwallScope.getCurrentRequestSite();
      
       	if(!isNull(domainNameSite)){
   			//render site via apps route
	        if(pathArrayLen && pathArray[1] == 'apps'){
	        	
	        	if(pathArrayLen > 1){
	        		arguments.appCode = pathArray[2];
	        	}
	        	if(pathArrayLen > 2){
	        		arguments.siteCode = pathArray[3];
	        	}
	        	if(pathArrayLen > 3){
	        		//need to figure out if we are working with a detail page type
	        		var urlTitlePathStartPosition = 4;
	        		if(
	        			arguments.slatwallScope.setting('globalURLKeyBrand') == pathArray[4]
	        			|| arguments.slatwallScope.setting('globalURLKeyProduct') == pathArray[4]
	        			|| arguments.slatwallScope.setting('globalURLKeyProductType') == pathArray[4]
	        		){
	        			arguments.entityUrl = pathArray[4];
	        			urlTitlePathStartPosition = 5;
	        		}else{
	        			urlTitlePathStartPosition = 4;
	        		}
	        		arguments.contenturlTitlePath = '';
	        		for(var i = urlTitlePathStartPosition;i <= arraylen(pathArray);i++){
	        			if(i == arrayLen(pathArray)){
	        				arguments.contenturlTitlePath &= pathArray[i];
	        			}else{
	        				arguments.contenturlTitlePath &= pathArray[i] & '/';
	        			}
	        		}
	        	}
	        	
				if(!isnull(arguments.appCode)){
					if(!isnull(domainNameSite)){
						
						var app = arguments.slatwallScope.getService('appService').getAppByAppCode(arguments.appCode);
						
						//if siteid is not specified then try to get the first site from the app
						if(isNull(arguments.siteID)){
							if(arraylen(app.getSites())){
								var site = app.getSites()[1];
							}
						}else{
							var site = arguments.slatwallScope.getService('siteService').getSiteBySiteCode(arguments.siteCode);
						}
					}
				}
			//if we are not using apps path
			}else if(pathArrayLen && pathArray[1] != 'apps'){
					
				var urlTitlePathStartPosition = 1;
        		if(
        			arguments.slatwallScope.setting('globalURLKeyBrand') == pathArray[1]
        			|| arguments.slatwallScope.setting('globalURLKeyProduct') == pathArray[1]
        			|| arguments.slatwallScope.setting('globalURLKeyProductType') == pathArray[1]
        		){
        			arguments.entityUrl = pathArray[1];
        			urlTitlePathStartPosition = 2;
        		}else{
        			urlTitlePathStartPosition = 1;
        		}
        		arguments.contenturlTitlePath = '';
        		for(var i = urlTitlePathStartPosition;i <= arraylen(pathArray);i++){
        			if(i == arrayLen(pathArray)){
        				arguments.contenturlTitlePath &= pathArray[i];
        			}else{
        				arguments.contenturlTitlePath &= pathArray[i] & '/';
        			}
        		}
				var app = domainNameSite.getApp();
				var site = domainNameSite;
       		}else{
       			arguments.contentTitlePath = '/';
				var app = domainNameSite.getApp();
				var site = domainNameSite;
       		}
       		
	        //if we obtained a site and it is allowed by the domain name then prepare to render content
			if(!isNull(site) && domainNameSite.getSiteID() == site.getSiteID()){
				prepareSlatwallScope(arguments.slatwallScope,app,site);
				prepareSiteForRendering(site=site, argumentsCollection=arguments);
			}
       	}else{
       		//if domain name is not a CMS site check to see if we have admin restricted domains via global setting
       		var adminDomanNamesSetting = arguments.slatwallScope.getService('SettingService').getSettingValue("globalAdminDomainNames");
       		//if a list of admin domains has been specified then check to see if the domain exists in the list. if none specified then pass through
       		if(!isNull(adminDomanNamesSetting) && len(adminDomanNamesSetting)){
       			if(!ListFind(adminDomanNamesSetting, arguments.slatwallScope.getCurrentDomain())){
       				writeOutput('#arguments.slatwallScope.getCurrentDomain()# is neither a CMS domain or an admin domain and therefore restricted.');
       				abort;
       			}
       		}
       	}
	}
	
	public void function prepareSlatwallScope(required any slatwallScope, required any app, required any site){
		// Setup the correct local in the request object for the current site
		arguments.slatwallScope.setRBLocale( arguments.slatwallScope.getRBLocale() );
		
		// Setup the correct app in the request object
		arguments.slatwallScope.setApp( app );
		
		// Setup the correct site in the request object
		arguments.slatwallScope.setSite( site );
	}
	
	public void function prepareSiteForRendering(required any site, required struct argumentsCollection){
		//declare sitePath
		var sitePath = getFullSitePath(site);
		
		//if a site does exist then check that site directory for the template
		//are we rendering a basic content node or have we been provided with an entityURL type?
		
		if(directoryExists(sitePath)) {
			var slatwallCMSApplication = getSlatwallCMSApplication(site);
			slatwallCMSApplication.onRequestStart(argumentCollection=arguments.argumentsCollection);
		}else{
			throw('site directory does not exist for ' & site.getSiteName());
		}
	}
	
		/*
		
        
	}
	
	
		
	
	
	
	// Special Function to relay all events called in Slatwall over to mura
	//announced event should send eventdata of appid,siteid,contentURL
	public void function onEvent( required any slatwallScope, required any eventName) {
		
	}*/
}
