/*
	
    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC
	
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
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
	
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.
	
Notes: 
	
*/
component extends="org.Hibachi.Hibachi" output="false" {

	// ===================================== HIBACHI HOOKS
	
	// @hint this method always fires one time, even if the request is coming from an outside application.
	public void function onEveryRequest() {
		
	}
	
	// @hint this will fire 1 time if you are running the application.  If the application is bootstraped then it won't run
	public void function onInternalRequest() {
		
	}
	
	public void function onFirstRequest() {
		// Version
		var versionFile = getDirectoryFromPath(getCurrentTemplatePath()) & "version.txt";
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
		
		// Reload All Integrations
		getBeanFactory().getBean("integrationService").updateIntegrationsFromDirectory();
		writeLog(file="Slatwall", text="General Log - Integrations have been updated");
	}
	
	public void function onUpdateRequest() {
		// Setup Default Data... Not called on soft reloads.
		getBeanFactory().getBean("dataService").loadDataFromXMLDirectory(xmlDirectory = ExpandPath("/Slatwall/config/dbdata"));
		writeLog(file="Slatwall", text="General Log - Default Data Has Been Confirmed");
		
		// Clear the setting cache so that it can be reloaded
		getBeanFactory().getBean("settingService").clearAllSettingsCache();
		writeLog(file="Slatwall", text="General Log - Setting Cache has been cleared");
		
		// Run Scripts
		getBeanFactory().getBean("updateService").runScripts();
		writeLog(file="Slatwall", text="General Log - Update Service Scripts Have been Run");
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
		if ( !listFindNoCase('admin,frontend,public', arguments.subsystem) ) {
			return 'integrationServices/' & arguments.subsystem & '/';
		}
		return arguments.subsystem & '/';
	}
	
	// Allows for custom views to be created for the admin, frontend or public subsystems
	public string function customizeViewOrLayoutPath( struct pathInfo, string type, string fullPath ) {
		arguments.fullPath = super.customizeViewOrLayoutPath(argumentcollection=arguments);
		if(listFindNoCase("admin,frontend,public", arguments.pathInfo.subsystem)){
			var customFullPath = replace(replace(replace(arguments.fullPath, "/admin/", "/custom/admin/"), "/frontend/", "/custom/frontend/"), "/public/", "/custom/public/");
			if(fileExists(expandPath(customFullPath))) {
				arguments.fullPath = customFullPath;
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
