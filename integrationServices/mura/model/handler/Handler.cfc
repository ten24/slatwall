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
<cfcomponent  extends="Slatwall.org.Hibachi.HibachiEventHandler">
	
	<!--- ======================= Helper Methods ================================ --->
		
	<cfscript>
		// Helper method to get the Slatwall Application
		public any function getSlatwallApplication() {
			if(!structKeyExists(variables, "slatwallApplication")) {
				variables.slatwallApplication = createObject("component", "Slatwall.Application");
			}
			return variables.slatwallApplication;
		}
		
		// Helper method to return the mura plugin config for the slatwall-mura connector
		public any function getMuraPluginConfig() {
			if(!structKeyExists(variables, "muraPluginConfig")) {
				variables.muraPluginConfig = application.pluginManager.getConfig("slatwall-mura");
			}
			return variables.muraPluginConfig;
		}
		
		// For admin request end, we call the endLifecycle
		public void function verifySlatwallRequest( required any $ ) {
			if(!structKeyExists(request, "slatwallScope")) {
				getSlatwallApplication().setupGlobalRequest();	
			}
			if(!structKeyExists(arguments.$, "slatwall")) {
				$.setCustomMuraScopeKey("slatwall", request.slatwallScope);	
			}
		}
		
		// For admin request end, we call the endLifecycle
		public void function endSlatwallRequest() {
			getSlatwallApplication().endHibachiLifecycle();
		}
	</cfscript>
	
	<cffunction name="getMuraIntegrationID">
		<cfif not structKeyExists(variables, "muraIntegrationID")>
			<cfset var muraIntegrationQuery = "" />
			<cfquery name="muraIntegrationQuery">
				SELECT integrationID FROM SwIntegration WHERE integrationPackage = <cfqueryparam cfsqltype="cf_sql_varchar" value="mura" />
			</cfquery>
			<cfset variables.muraIntegrationID = muraIntegrationQuery.integrationID />
		</cfif>
		<cfreturn variables.muraIntegrationID />
	</cffunction>
	
	<cffunction name="getMuraSiteIDByMuraUserID">
		<cfargument name="muraUserID" />
		
		<cfset var rs = "" />
		<cfquery name="rs">
			SELECT siteID FROM tusers WHERE userID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.muraUserID#" > 
		</cfquery>
		
		<cfreturn rs.siteID />
	</cffunction>
	
	<cffunction name="updatePluginSetting">
		<cfargument name="moduleID" />
		<cfargument name="settingName" />
		<cfargument name="settingValue" />
		
		<cfset var rs = "" />
		<cfquery name="rs">
			UPDATE
				tpluginsettings
			SET
				settingValue = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.settingValue#"/>
			WHERE
				name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.settingName#"/>
			  AND
			  	moduleID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#"/>
		</cfquery>
		
		<!--- Delete the plugin config from variables so that it gets reloaded --->
		<cfset structDelete(variables, "muraPluginConfig") />
	</cffunction>
</cfcomponent>
