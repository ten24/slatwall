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
<cfcomponent extends="HibachiDAO" accessors="true" output="false">
	
	<cfproperty name="hibachiCacheService" type="any" />
	
	<cffunction name="getSettingRecordExistsFlag" output="false" returntype="boolean">
		<cfargument name="settingName" type="string" required="true" />
		<cfargument name="settingValue" />
		
		<cfset var rs = "" />
		
		<cfquery name="rs" maxrows="1">
			SELECT
				settingID
			FROM
				SwSetting
			WHERE
			  	LOWER(settingName) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(arguments.settingName)#">
		  		<cfif structKeyExists(arguments, "settingValue")>
			  	  		AND
			  		LOWER(settingValue) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(arguments.settingValue)#">  
		  		</cfif>
		</cfquery>
		
		<cfreturn rs.recordCount gt 0 />
	</cffunction>
	
	<cffunction name="getSettingRecordBySettingRelationships" output="false">
		<cfargument name="settingName" type="string" required="true" />
		<cfargument name="settingRelationships" type="struct" default="#structNew()#" />
		
		<cfset var potentialRelationships = "accountID,contentID,brandID,emailID,emailTemplateID,fulfillmentMethodID,locationID,locationConfigurationID,paymentMethodID,productID,productTypeID,shippingMethodID,shippingMethodRateID,siteID,skuID,subscriptionTermID,subscriptionUsageID,taskID" />
		<cfset var relationship = "">
		<cfset var rs = "">
		
		<cfquery name="rs" >
			SELECT
				settingID,
				settingValue,
				settingValueEncryptGen
			FROM
				SwSetting
			WHERE
				LOWER(settingName) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCASE(arguments.settingName)#">
				<cfloop list="#potentialRelationships#" index="local.relationship">
					<cfif structKeyExists(arguments.settingRelationships, relationship)>
						AND #relationship# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.settingRelationships[ relationship ]#" > 
					<cfelse>
						AND #relationship# IS NULL
					</cfif>
				</cfloop>
		</cfquery>
		
		<cfreturn rs />		
	</cffunction>
	
	<cffunction name="removeAllRelatedSettings">
		<cfargument name="columnName" type="string" />
		<cfargument name="columnID" type="string" />
		
		<cfset var rs = "" />
		<cfset var rs2 = "" />
		<cfset var rsResult = "" />
		
		<cfquery name="rs">
			SELECT DISTINCT settingName FROM SwSetting WHERE #columnName# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.columnID#">
		</cfquery>
		
		<cfquery name="rs2" result="rsResult">
			DELETE FROM SwSetting WHERE #columnName# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.columnID#">
		</cfquery>
		
		<cfloop query="rs">
			<cfset getHibachiCacheService().resetCachedKeyByPrefix('setting_#rs.settingName#') />
		</cfloop>
		
		<cfreturn rsResult.recordCount />
	</cffunction>
	
	<cffunction name="updateAllSettingValuesToRemoveSpecificID">
		<cfargument name="primaryIDValue" type="string" />
		
		<cfset var rs = "" />
		<cfset var rs2 = "" />
		<cfset var rsResult = "" />
		<cfset var updatedSettings = 0 />
		
		<cfquery name="rs">
			SELECT settingID, settingName, settingValue FROM SwSetting WHERE settingValue LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.primaryIDValue#%">
		</cfquery>
		
		<cfloop query="rs">
			
			<cfset var oldListIndex = listFindNoCase(rs.settingValue, arguments.primaryIDValue) />
			
			<cfif oldListIndex>
				
				<cfset var newValue = listDeleteAt(rs.settingValue, oldListIndex) />
				
				<cfquery name="rs2">
					UPDATE SwSetting SET settingValue = <cfqueryparam cfsqltype="cf_sql_varchar" value="#newValue#"> WHERE settingID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.settingID#">
				</cfquery>
				
				<cfset getHibachiCacheService().resetCachedKeyByPrefix('setting_#rs.settingName#') />
				
				<cfset updatedSettings += 1 />
				
			</cfif>
		</cfloop>
		
		<cfreturn updatedSettings />
	</cffunction>
	
</cfcomponent>
