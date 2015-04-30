component {
	
	variables.fullSitePaths = {};
	variables.slatwallApplications = {};
	
	public any function getSlatwallCMSApplication(required any site) {
		if(!structKeyExists(variables.slatwallApplications,arguments.site.getApp().getAppID())){
			var applicationDotPath = rereplace(arguments.site.getApp().getAppRootPath(),'/','.','all');
			variables.slatwallApplications[arguments.site.getApp().getAppID()] = createObject("component", "Slatwall" & applicationDotPath & '.Application');
		}
		return variables.slatwallApplications[arguments.site.getApp().getAppID()];
	}
	
	public any function getFullSitePath(required any site){
		if(!structKeyExists(variables.fullSitePaths,arguments.site.getSiteID())){
			variables.fullSitePaths[site.getSiteID()] = getSlatwallCMSApplication(arguments.site).Mappings['/Slatwall'] & site.getSiteID();
		}
		return variables.fullSitePaths[site.getSiteID()];
	}
	
	//public any function get
	
	// This event handler will always get called
	public void function setupGlobalRequestComplete() {
		// If the domain matches a slatwallCMS application site, then render that site. UNLESS the path has "/admin", then do nothing
		// myApp = create an object of /custom/apps/slatwallcms/sitex/Application.cfc
		// myApp.runRequestActions();
		// writeOutput(myApp.generateRenderedContent());
		// abort;
		if(!isnull(arguments.appID)){
			//try to get a site form the domain name
			
			var domainNameSite = arguments.slatwallScope.getService('siteService').getCurrentRequestSite();
			if(!isnull(domainNameSite)){
				var app = arguments.slatwallScope.getService('appService').getAppByAppID(arguments.appID);
				
				//if siteid is not specified then try to get the first site from the app
				if(isNull(arguments.siteID)){
					if(arraylen(app.getSites())){
						var site = app.getSites()[1];
					}
				}else{
					var site = arguments.slatwallScope.getService('siteService').getSiteBySiteID(arguments.siteID);
				}
				//if we obtained a site and it is allowed by the domain name then prepare to render content
				if(!isNull(site) && domainNameSite.getSiteID() == site.getSiteID()){
					
					// Setup the correct local in the request object for the current site
					arguments.slatwallScope.setRBLocale( arguments.slatwallScope.siteConfig('javaLocale') );
					
					// Setup the correct app in the request object
					arguments.slatwallScope.setApp( app );
					
					// Setup the correct site in the request object
					arguments.slatwallScope.setSite( site );
					
					//declare sitePath
					//variables.fullSitePaths[domainNamesite.getSiteID()] = app.getAppRootPath() & '/' & domainNamesite.getSiteID();
					var sitePath = getFullSitePath(site);
					
					//if a site does exist then check that site directory for the template
					//are we rendering a basic content node or have we been provided with an entityURL type?
					if(directoryExists(sitePath)) {
						
						var slatwallCMSApplication = getSlatwallCMSApplication(site);
						slatwallCMSApplication.runRequestActions();
						slatwallCMSApplication.generateRenderedContent(argumentCollection=arguments);
					}else{
						throw('site directory does not exist for ' & site.getSiteName());
					}
				}
			}
		}
	}
	
	
	// Special Function to relay all events called in Slatwall over to mura
	//announced event should send eventdata of appid,siteid,contentURL
	public void function onEvent( required any slatwallScope, required any eventName) {
	}
}