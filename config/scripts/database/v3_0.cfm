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

<cfset local.scriptHasErrors = false />

<!--- Move old mura settings into integration --->
<cftry>
	<cfquery name="local.oldmurasetting">
		UPDATE
			SwSetting
		SET
			settingName = 'integrationMuraLegacyShoppingCart'
		WHERE
			settingName = 'globalPageShoppingCart'
	</cfquery>
	<cfquery name="local.oldmurasetting">
		UPDATE
			SwSetting
		SET
			settingName = 'integrationMuraLegacyOrderStatus'
		WHERE
			settingName = 'globalPageOrderStatus'
	</cfquery>
	<cfquery name="local.oldmurasetting">
		UPDATE
			SwSetting
		SET
			settingName = 'integrationMuraLegacyOrderConfirmation'
		WHERE
			settingName = 'globalPageOrderConfirmation'
	</cfquery>
	<cfquery name="local.oldmurasetting">
		UPDATE
			SwSetting
		SET
			settingName = 'integrationMuraLegacyMyAccount'
		WHERE
			settingName = 'globalPageMyAccount'
	</cfquery>
	<cfquery name="local.oldmurasetting">
		UPDATE
			SwSetting
		SET
			settingName = 'integrationMuraLegacyCreateAccount'
		WHERE
			settingName = 'globalPageCreateAccount'
	</cfquery>
	<cfquery name="local.oldmurasetting">
		UPDATE
			SwSetting
		SET
			settingName = 'integrationMuraLegacyCheckout'
		WHERE
			settingName = 'globalPageCheckout'
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Moving old Mura Settings Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<!--- Add Active Flag Where needed --->
<cftry>
	<cfquery name="local.activeflag">
		UPDATE
			SwAccountPaymentMethod
		SET
			activeFlag = 1
		WHERE
			activeFlag is null
	</cfquery>
	
	<cfquery name="local.activeflag">
		UPDATE
			SwSku
		SET
			activeFlag = 1
		WHERE
			activeFlag is null
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - setting default activeFlag Has Errors">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<!--- Add other default flags --->
<cftry>
	<cfquery name="local.flag">
		UPDATE
			SwOrderFulfillment
		SET
			manualFulfillmentChargeFlag = 0
		WHERE
			manualFulfillmentChargeFlag is null
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - setting default flags Has Errors">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<!--- Allow for nulls in order payments --->
<cftry>
	<cfquery name="local.allowNull">
		<cfif getApplicationValue("databaseType") eq "MySQL">
			ALTER TABLE SwOrderPayment MODIFY COLUMN amount decimal(19,2) NULL
		<cfelse>
			ALTER TABLE SwOrderPayment ALTER COLUMN amount decimal(19,2) NULL
		</cfif>
	</cfquery>
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Allowing nulls in Order Payments">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<!--- Move the listing flags from SlatwallSetting to the content --->
<cftry>
	<cfquery name="local.listingpagesettings">
		SELECT cmsContentID FROM SwSetting WHERE settingName = 'contentProductListingFlag' and cmsContentID is not null and settingValue = 1
	</cfquery>
	
	<cfloop query="local.listingpagesettings">
		<cfquery name="local.listingflagupdate">
			UPDATE
				SwContent
			SET
				productListingPageFlag = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
			WHERE
				SwContent.cmsContentID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.listingpagesettings.cmsContentID#">
		</cfquery>
	</cfloop>
	
	<cfquery name="local.deletelistingpagesettings">
		DELETE FROM SwSetting WHERE settingName = 'contentProductListingFlag' and cmsContentID is not null
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Updating the listing page flags out of settings and into content nodes">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<!--- Update the content that has null for siteID --->
<cftry>
	<cfquery name="local.uniqueCMSSiteID">
		SELECT DISTINCT
			cmsSiteID
		FROM
			SwContent
		WHERE
			siteID is null
	</cfquery>
	
	<cfloop query="local.uniqueCMSSiteID">
		
		<cfquery name="local.findSite">
			SELECT
				siteID
			FROM
				SwSite
			WHERE
				cmsSiteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.uniqueCMSSiteID.cmsSiteID#" />
		</cfquery>
		
		<cfif not local.findSite.recordCount>
			
			<cfset local.slatwallSiteID = replace(lcase(createUUID()), '-', '', 'all') />
			
			<cfquery name="local.addSite">
				INSERT INTO SwSite(
					siteID,
					siteName,
					cmsSiteID
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.slatwallSiteID#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.uniqueCMSSiteID.cmsSiteID#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.uniqueCMSSiteID.cmsSiteID#" />
				)
			</cfquery>
			
		<cfelse>
			<cfset local.slatwallSiteID = local.findSite.siteID />
		</cfif>
		
		<cfquery name="local.findSite">
			UPDATE
				SwContent
			SET
				siteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.slatwallSiteID#" />
			WHERE
				siteID is null and cmsSiteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.uniqueCMSSiteID.cmsSiteID#" />
		</cfquery>
	</cfloop>
		
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Updating the listing page flags out of settings and into content nodes">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<!--- Update old email templates --->
<cftry>
	<cfquery name="local.updateTemplate">
		UPDATE
			SwEmailTemplate
		SET
			emailTemplateObject = 'Order',
			emailTemplateFile = 'confirmation.cfm'
		WHERE
			emailTemplateID = 'dbb327e506090fde08cc4855fa14448d'
	</cfquery>
	<cfquery name="local.updateTemplate">
		UPDATE
			SwEmailTemplate
		SET
			emailTemplateObject = 'OrderDelivery',
			emailTemplateFile = 'confirmation.cfm'
		WHERE
			emailTemplateID = 'dbb327e694534908c60ea354766bf0a8'
	</cfquery>
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Deleting old emails and email templates">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<!--- Add an orderPaymentStatusType to all missing it --->
<cftry>
	<cfquery name="local.updateOrderPaymentStatus">
		UPDATE
			SwOrderPayment
		SET
			orderPaymentStatusTypeID = '5accbf57dcf5bb3eb71614febe83a31d'
		WHERE
			orderPaymentStatusTypeID is null
	</cfquery>
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Updating the orderPaymentStatusType has issues">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Part of Script v3_0 had errors when running">
	<cfthrow detail="Part of Script v3_0 had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Script v3_0 has run with no errors">
</cfif>
