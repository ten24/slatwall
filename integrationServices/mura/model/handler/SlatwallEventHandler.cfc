<!---

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
	
--->
<cfcomponent extends="Handler" output="false" accessors="true">
	
	<cfproperty name="assignedSiteIDArray" type="array" />
	
	<cfscript>
	
	// Cached the assigned sites
	private array function getAssignedSiteIDArray() {
		if(!structKeyExists(variables, "assignedSiteIDArray")) {
			var arr = [];
			var assignedSitesQuery = getMuraPluginConfig().getAssignedSites();
			for(var i=1; i<=assignedSitesQuery.recordCount; i++) {
				arrayAppend(arr, assignedSitesQuery["siteid"][i]);
			}
			variables.assignedSiteIDArray = arr;
		}
		return variables.assignedSiteIDArray;
	}
	
	// Helper function meant to be used by events to get a mura scope
	private any function getMuraScope() {
		if(structKeyExists(request, "siteID")) {
			arguments.siteID = request.siteID;
		} else if(structKeyExists(form, "siteID")) {
			arguments.siteID = form.siteID;
		} else if(structKeyExists(url, "siteID")) {
			arguments.siteID = url.siteID;	
		} else if(structKeyExists(session, "siteID")) {
			arguments.siteID = session.siteID;
		}
		
		var $ = application.serviceFactory.getBean('$').init( arguments );
		
		$.setCustomMuraScopeKey("slatwall", arguments.slatwallScope);
		
		return $;
	}

	// Special Function to relay all events called in Slatwall over to mura
	public void function onEvent( required any slatwallScope, required any eventName ) {
		
		if(structKeyExists(application,"appinitialized") && application.appinitialized) {
			if(!structKeyExists(request.customMuraScopeKeys, "slatwall")) {
				request.customMuraScopeKeys.slatwall = arguments.slatwallScope;	
			}
			
			// If there was a request.siteID defined, then announce the event against that specific site.  This would typically happen on a Frontend mura request
			if(structKeyExists(request, "siteID")) {
				arguments.siteID = request.siteID;
				application.serviceFactory.getBean('$').init( arguments ).announceEvent("slatwall#arguments.eventName#");
				
			// If there was no siteID in the request the event probably originated in the Slatwall admin.  In this situation we need to re-announce to all sites that Slatwall is defined for
			} else {
				var asArr = getAssignedSiteIDArray();
				for(var i=1; i<=arrayLen(asArr); i++) {
					arguments.siteID = asArr[i];
					application.serviceFactory.getBean('$').init( arguments ).announceEvent("slatwall#arguments.eventName#");
				}
			}
		}
	}

	// Login to Mura when Slatwall user is logged in
	public void function onSessionAccountLogin( required any slatwallScope ) {
		if(structKeyExists(application,"appinitialized") && application.appinitialized) {
			if(!isNull(arguments.slatwallScope.getAccount().getCMSAccountID()) && len(arguments.slatwallScope.getAccount().getCMSAccountID())) {
				var $ = getMuraScope(argumentCollection=arguments);
				
				$.getBean("userUtility").loginByUserID(arguments.slatwallScope.getAccount().getCMSAccountID(), getMuraSiteIDByMuraUserID(arguments.slatwallScope.getAccount().getCMSAccountID()));
				$.announceEvent("onGlobalLoginSuccess");
			}
		}
	}
	
	// Logout of Mura when Slatwall user is logged out
	public void function onSessionAccountLogout( required any slatwallScope ) {
		param name="session" default="#structNew()#";
		
		if(structKeyExists(application,"appinitialized") && application.appinitialized) {
			// Auto Logout of Mura if needed
			if(structKeyExists(session, "mura") && structKeyExists(session.mura, "isLoggedIn") && session.mura.isLoggedIn) {
				getMuraScope(argumentCollection=arguments).getBean('loginManager').logout();
			}
		}
	}
	
	// When a "mura" setting gets saved it should also be updated on the Mura plugin config side.
	public void function afterSettingSaveSuccess( required any slatwallScope, required any entity ) {
		if(listFindNoCase("integrationMuraAccountSyncType,integrationMuraCreateDefaultPages,integrationMuraSuperUserSyncFlag", arguments.entity.getSettingName())) {
			updatePluginSetting(moduleID=getMuraPluginConfig().getModuleID(), settingName=replaceNoCase(arguments.entity.getSettingName(), "integrationmura", ""), settingValue=arguments.entity.getSettingValue());
		}
	}
	
	</cfscript>

	<cffunction name="afterAccountSaveSuccess">
		<cfargument name="slatwallScope" type="any" required="true" />
		<cfargument name="entity" type="any" required="true" />
		
		<cfif !isNull(arguments.entity.getCMSAccountID()) and len(arguments.entity.getCMSAccountID()) >
			<cfquery name="local.rs">
				UPDATE
					tusers
				SET
					Fname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entity.getFirstName()#" />,
					Lname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entity.getLastName()#" />,
					<cfif not isNull(arguments.entity.getCompany())>
						Company = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entity.getCompany()#" />,
					<cfelse>
						Company = '',
					</cfif>
					Email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entity.getEmailAddress()#" />,
					MobilePhone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entity.getPhoneNumber()#" />
				WHERE
					tusers.userID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entity.getCMSAccountID()#" />
			</cfquery>
		</cfif>
	</cffunction>
</cfcomponent>
