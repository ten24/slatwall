component {
	
	// This event handler will always get called
	function setupGlobalRequestComplete() {
		// If the domain matches a slatwallCMS application site, then render that site. UNLESS the path has "/admin", then do nothing
		
		// myApp = create an object of /custom/apps/slatwallcms/sitex/Application.cfc
		// myApp.runRequestActions();
		// writeOutput(myApp.generateRenderedContent());
		// abort;
	}
	// Special Function to relay all events called in Slatwall over to mura
	//announced event should send eventdata of appid,siteid,contentURL
	public void function onEvent( required any slatwallScope, required any eventName) {
		if(arguments.eventName == 'setupGlobalRequestComplete' && !isnull(arguments.appID)){
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
					var sitePath = '/apps/' & domainNamesite.getApp().getAppID() & '/' & domainNamesite.getSiteID();
					//if a site does exist then check that site directory for the template
					//are we rendering a basic content node or have we been provided with an entityURL type?
					if(directoryExists(arguments.slatwallScope.getApplicationValue('applicationRootMappingPath') & sitePath)) {
						//declareTemplatePath
						var templatePath = '../../../..' & sitePath & '/templates/';
						
						if(!isNull(arguments.contentURL)){
							//now that we have the site directory, we should see if we can retrieve the content via the urltitle and site
							var content = arguments.slatwallScope.getService('contentService').getContentBySiteIDAndUrlTitle(site.getSiteID(),arguments.contentURL);
							if(isNull(content)){
								throw('content does not exists for #arguments.contentURL#');
							}
							//now that we have the content, get the file name so that we can retrieve it form the site's template directory
							var contentTemplateFile = content.Setting('contentTemplateFile');
							//templatePath relative to the slatwallCMS
							request.context['contentPath'] = templatePath & contentTemplateFile;
							arguments.slatwallScope.setContent(content);
							
						}else if(!isNull(arguments.entityURL)){
							var isBrandURLKey = arguments.slatwallScope.setting('globalURLKeyBrand') == arguments.entityURL;
							var isProductURLKey = arguments.slatwallScope.setting('globalURLKeyProduct') == arguments.entityURL;
							var isProductTypeURLKey = arguments.slatwallScope.setting('globalURLKeyProductType') == arguments.entityURL;
							var entityName = '';
							
							// First look for the Brand URL Key
							if (isBrandURLKey) {
								var brand = arguments.slatwallScope.getService("brandService").getBrandByURLTitle(arguments.urlTitle, true);
								arguments.slatwallScope.setBrand( brand );
								entityName = 'brand';
							}
							
							// Look for the Product URL Key
							if(isProductURLKey) {
								var product = arguments.slatwallScope.getService("productService").getProductByURLTitle(arguments.urlTitle, true);
								arguments.slatwallScope.setProduct( product );	
								entityName = 'product';
							}
							
							// Look for the Product Type URL Key
							if (isProductTypeURLKey) {
								var productType = arguments.slatwallScope.getService("productService").getProductTypeByURLTitle(arguments.entityURL, true);
								arguments.slatwallScope.setProductType( productType );
								entityName = 'productType';
							}
							var entityDisplayTemplateSetting = arguments.slatwallScope.invokeMethod('get#entityName#').setting('#entityName#DisplayTemplate', [site]); 
							var entityTemplateContent = arguments.slatwallScope.getService("contentService").getContent( entityDisplayTemplateSetting );;
							if(!isnull(entityTemplateContent)){
								arguments.slatwallScope.setContent( entityTemplateContent );
								var contentTemplateFile = entityTemplateContent.Setting('contentTemplateFile');
								if(!isNull(contentTemplateFile)){
									request.context['contentPath'] = templatePath & contentTemplateFile;
									
									arguments.slatwallScope.setContent(entityTemplateContent);
								}else{
									throw('no contentTemplateFile for the entity');
								}
							}else{
								throw('no content for entity');
							}
						}
					}else{
						throw('site directory does not exist for ' & site.getSiteName());
					}
				}
			}
		}
	}
}