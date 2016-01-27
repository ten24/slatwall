/*
	
    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC
	
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
	
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
	
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
	
    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your 
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms 
    of your choice, provided that you follow these specific guidelines: 

	- You also meet the terms and conditions of the license of each 
	  independent module 
	- You must not alter the default display of the Slatwall name or logo from  
	  any part of the application 
	- Your custom code must not alter or create any files inside Slatwall, 
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets 
	the above guidelines as a combined work under the terms of GPL for this program, 
	provided that you include the source code of that other code when and as the 
	GNU GPL requires distribution of source code.
    
    If you modify this program, you may extend this exception to your version 
    of the program, but you are not obligated to do so.
	
Notes: 
	
*/
component extends="org.Hibachi.Hibachi" output="false" {

	// ===================================== HIBACHI HOOKS
	
	// @hint this method always fires one time, even if the request is coming from an outside application.
	public void function onEveryRequest() {
		
		
	}
	
	// @hint this will fire 1 time if you are running the application.  If the application is bootstraped then it won't run
	public void function onInternalRequest() {
		if(listFindNoCase("public,frontend", getSubsystem(request.context.slatAction))) {
			getHibachiScope().setPublicPopulateFlag( true );
		}
	}
	
	public void function onFirstRequest() {
		// Version
		var versionFile = getDirectoryFromPath(getCurrentTemplatePath()) & "version.txt.cfm";
		if( fileExists( versionFile ) ) {
			request.slatwallScope.setApplicationValue("version", trim(fileRead(versionFile)));
		} else {
			request.slatwallScope.setApplicationValue("version", "unknown");
		}
		
		// Slatwall Root URL
		request.slatwallScope.setApplicationValue("slatwallRootURL", variables.framework.baseURL);
		
		// Set Datasource
		request.slatwallScope.setApplicationValue("datasource", this.datasource.name);
		
		// Set Datasource Username
		request.slatwallScope.setApplicationValue("datasourceUsername", this.datasource.username);
		
		// Set Datasource Password
		request.slatwallScope.setApplicationValue("datasourcePassword", this.datasource.password);
		
		// SET Database Type
		request.slatwallScope.setApplicationValue("databaseType", this.ormSettings.dialect);
	}
	
	public void function onUpdateRequest() {
		// Setup Default Data... Not called on soft reloads.
		getBeanFactory().getBean("hibachiDataService").loadDataFromXMLDirectory(xmlDirectory = ExpandPath("/Slatwall/config/dbdata"));
		writeLog(file="Slatwall", text="General Log - Default Data Has Been Confirmed");
		
		// Clear the setting cache so that it can be reloaded
		getBeanFactory().getBean("hibachiCacheService").resetCachedKeyByPrefix('setting_');
		writeLog(file="Slatwall", text="General Log - Setting Cache has been cleared because of updated request");
		
		// Clear the setting meta cache so that it can be reloaded
        	getBeanFactory().getBean("hibachiCacheService").resetCachedKeyByPrefix('settingService_');
        	writeLog(file="Slatwall", text="General Log - Setting Meta cache has been cleared because of updated request");
		
		// Run Scripts
		getBeanFactory().getBean("updateService").runScripts();
		writeLog(file="Slatwall", text="General Log - Update Service Scripts Have been Run");
	}
	
	public void function onFirstRequestPostUpdate() {
		
		// Reload All Integrations, we pass in the beanFactory and it is returned so that it can be updated it with any integration beans prefixed 
		var beanFactory = getBeanFactory().getBean("integrationService").updateIntegrationsFromDirectory( getBeanFactory() );
		
		setBeanFactory( beanFactory );
		
		writeLog(file="Slatwall", text="General Log - Integrations have been updated & custom beans have been added to bean factory");
	}
	
	// ===================================== END: HIBACHI HOOKS
	// ===================================== Hibachi HOOKS
	
	public void function endHibachiLifecycle() {
		
		if(getHibachiScope().getORMHasErrors()) {
			getHibachiScope().clearEmailAndPrintQueue();
		} else {
			getHibachiScope().getService("emailService").sendEmailQueue();
		}
		
		// Call the super lifecycle end
		super.endHibachiLifecycle();
	}
	
	// ===================================== END: Hibachi HOOKS
	// ===================================== FW1 HOOKS
	
	// Allows for integration services to have a seperate directory structure
	public any function getSubsystemDirPrefix( string subsystem ) {
		if ( arguments.subsystem eq '' ) {
			return '';
		}
		if ( !listFindNoCase('admin,api,frontend,public', arguments.subsystem) ) {
			return 'integrationServices/' & arguments.subsystem & '/';
		}
		return arguments.subsystem & '/';
	}
	
	// Allows for custom views to be created for the admin, frontend or public subsystems
	public string function customizeViewOrLayoutPath( struct pathInfo, string type, string fullPath ) {
		
		arguments.fullPath = super.customizeViewOrLayoutPath(argumentcollection=arguments);
		
		if(listFindNoCase("admin,public", arguments.pathInfo.subsystem)){
			var customFullPath = replace(replace(replace(arguments.fullPath, "/admin/", "/custom/admin/"), "/frontend/", "/custom/frontend/"), "/public/", "/custom/public/");
			if(fileExists(expandPath(customFullPath))) {
				arguments.fullPath = customFullPath;
			}
			
		// DEPRECATED!!!
		} else if(arguments.pathInfo.subsystem == "frontend" && arguments.type == "view" && structKeyExists(request, "muraScope")) {
			
			var themeView = replace(arguments.fullPath, "/Slatwall/frontend/views/", "#request.muraScope.siteConfig('themeAssetPath')#/display_objects/custom/slatwall/");
			var siteView = replace(arguments.fullPath, "/Slatwall/frontend/views/", "#request.muraScope.siteConfig('assetPath')#/includes/display_objects/custom/slatwall/");

			if(fileExists(expandPath(themeView))) {
				arguments.fullPath = themeView;	
			} else if (fileExists(expandPath(siteView))) {
				arguments.fullPath = siteView;
			}

		
		} else if(arguments.type eq "layout" && arguments.pathInfo.subsystem neq "common") {
			if(arguments.pathInfo.path eq "default" && !fileExists(expandPath(arguments.fullPath))) {
				arguments.fullPath = left(arguments.fullPath, findNoCase("/integrationServices/", arguments.fullPath)) & 'admin/layouts/default.cfm';
			}
		}
		
		return arguments.fullPath;
	}
	
	// ===================================== END: FW1 HOOKS
	// ===================================== SLATWALL FUNCTIONS
	
	// Additional redirect function that allows us to redirect to a setting.  This can be defined in an integration as well
	public void function redirectSetting(required string settingName, string queryString="") {
		endHibachiLifecycle();
		location(request.muraScope.createHREF(filename=request.slatwallScope.setting(arguments.settingName), queryString=arguments.queryString), false);
	}
	
}

