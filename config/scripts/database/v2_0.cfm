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

<cfdbinfo datasource="#getApplicationValue("datasource")#" username="#getApplicationValue("datasourceUsername")#" password="#getApplicationValue("datasourcePassword")#" type="Tables" name="local.infoTables" />

<!--- Update fulfillmentMethodID for all shippingMethods where the fulfillmentMethodID = "shipping" --->
<cftry>
	<cfquery name="local.updateData">
		UPDATE
			SlatwallShippingMethod
		SET
			fulfillmentMethodID = <cfqueryparam cfsqltype="cf_sql_varchar" value="444df2fb93d5fa960ba2966ba2017953">
		WHERE
			fulfillmentMethodID = <cfqueryparam cfsqltype="cf_sql_varchar" value="shipping">
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="General Log - Update fulfillmentMethodID on SlatwallShippingMethod Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<!--- Update fulfillmentMethodID for all orderFulfillments where the fulfillmentMethodID = "shipping" --->
<cftry>
	<cfquery name="local.updateData">
		UPDATE
			SlatwallOrderFulfillment
		SET
			fulfillmentMethodID = <cfqueryparam cfsqltype="cf_sql_varchar" value="444df2fb93d5fa960ba2966ba2017953">
		WHERE
			fulfillmentMethodID = <cfqueryparam cfsqltype="cf_sql_varchar" value="shipping">
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="General Log - Update fulfillmentMethodID on SlatwallOrderFulfillment Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<!--- Update fulfillmentMethodID for all orderDeliveries where the fulfillmentMethodID = "shipping" --->
<cftry>
	<cfquery name="local.updateData">
		UPDATE
			SlatwallOrderDelivery
		SET
			fulfillmentMethodID = <cfqueryparam cfsqltype="cf_sql_varchar" value="444df2fb93d5fa960ba2966ba2017953">
		WHERE
			fulfillmentMethodID = <cfqueryparam cfsqltype="cf_sql_varchar" value="shipping">
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="General Log - Update fulfillmentMethodID on SlatwallOrderDelivery Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<!--- Remove any fulfillmentMethods where the fulfillmentMethodID is "shipping" --->
<cftry>
	<cfquery name="local.updateData">
		DELETE FROM
			SlatwallFulfillmentMethod
		WHERE
			fulfillmentMethodID = <cfqueryparam cfsqltype="cf_sql_varchar" value="shipping">
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="General Log - Remove fulfillmentMethodID of shipping Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<!--- Update providerGateway for the new CreditCard payment method --->
<!---
<cftry>
	<cfquery name="local.getData">
		SELECT
			providerGateway
		FROM
			SlatwallPaymentMethod
		WHERE
			paymentMethodID = <cfqueryparam cfsqltype="cf_sql_varchar" value="creditCard">
	</cfquery>
	
	<cfif local.getData.recordCount>
		<cfquery name="local.updateData">
			UPDATE
				SlatwallPaymentMethod
			SET
				providerGateway = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.getData.providerGateway#">
			WHERE
				paymentMethodID = <cfqueryparam cfsqltype="cf_sql_varchar" value="444df303dedc6dab69dd7ebcc9b8036a">
		</cfquery>
	</cfif>
	
	<cfcatch>
		<cflog file="Slatwall" text="General Log - Update providerGateway on SlatwallPaymentMethod Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>
--->

<!--- Update paymentMethodID for all orderDeliveries where the paymentMethodID = "creditCard" --->
<cftry>
	<cfquery name="local.updateData">
		UPDATE
			SlatwallOrderPayment
		SET
			paymentMethodID = <cfqueryparam cfsqltype="cf_sql_varchar" value="444df303dedc6dab69dd7ebcc9b8036a">
		WHERE
			paymentMethodID = <cfqueryparam cfsqltype="cf_sql_varchar" value="creditCard">
	</cfquery>
	
	<cfcatch>	
		<cflog file="Slatwall" text="General Log - Update paymentMethodID on SlatwallOrderPayment Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<!--- Remove any paymentMethods where the paymentMethodID is "creditCard" --->
<cftry>
	<cfquery name="local.updateData">
		DELETE FROM
			SlatwallPaymentMethod
		WHERE
			paymentMethodID = <cfqueryparam cfsqltype="cf_sql_varchar" value="creditCard">
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="General Log - remove creditCard Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<!--- Remove any paymentMethods where the paymentMethodID is "dwolla" --->
<cftry>
	<cfquery name="local.updateData">
		DELETE FROM
			SlatwallPaymentMethod
		WHERE
			paymentMethodID = <cfqueryparam cfsqltype="cf_sql_varchar" value="dwolla">
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="General Log - remove dwolla Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<!--- Remove any paymentMethods where the paymentMethodID is "paypalExpress" --->
<cftry>
	<cfquery name="local.updateData">
		DELETE FROM
			SlatwallPaymentMethod
		WHERE
			paymentMethodID = <cfqueryparam cfsqltype="cf_sql_varchar" value="paypalExpress">
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="General Log - remove paypalExpress Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<!--- Update attributeValueType for all attributeValueTypes of astProductCustomization --->
<cftry>
	<cfquery name="local.updateData">
		UPDATE
			SlatwallAttributeValue
		SET
			attributeValueType = <cfqueryparam cfsqltype="cf_sql_varchar" value="astOrderItem">
		WHERE
			attributeValueType = <cfqueryparam cfsqltype="cf_sql_varchar" value="astProductCustomization">
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="General Log - update astProductCustomization attribute type to astOrderItem Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<!--- Create Content Record for Every Content in Mura Admin with type of SlatwallProductListing --->
<!---
<cftry>
	<cfquery name="local.getData">
		SELECT DISTINCT
			contentID,
			path
		FROM
			tcontent
		WHERE
			subType = <cfqueryparam cfsqltype="cf_sql_varchar" value="SlatwallProductListing">
	</cfquery>
	
	<cfloop query="local.getData">
		<cfquery name="local.contentExists">
			SELECT DISTINCT
				cmsContentID
			FROM
				SlatwallContent
			WHERE
				cmsContentID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.getData.contentID#">
		</cfquery>
		
		<cfif not local.contentExists.recordCount>
			<cfquery name="local.updateData">
				INSERT INTO SlatwallContent (
					contentID,
					cmsContentID,
					cmsContentIDPath
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#replace(lcase(createUUID()), "-", "", "all")#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.getData.contentID#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.getData.path#">
				)
			</cfquery>
		</cfif>
	</cfloop>
	
	<cfcatch>	
		<cflog file="Slatwall" text="General Log - Create Listing Pages Has Errors">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>
--->
<!--- Delete Extended Attribute Type of "SlatwallProductListing" --->

<!--- Delete Extended Attribute Type of "SlatwallProductTemplate" --->

<!--- Move the productPage Mappings --->
<cftry>
	<cfquery name="local.hasTable" dbtype="query">
		SELECT
			* 
		FROM
			infoTables
		WHERE
			TABLE_NAME = 'SlatwallProductContent'
	</cfquery>
	
	<cfif local.hasTable.recordCount>
		<cfquery name="local.updateData">
			INSERT INTO SlatwallProductListingPage (
				contentID,
				productID
			) SELECT
				sc.contentID,
				spc.productID
			FROM
				SlatwallContent sc
			  INNER JOIN
				SlatwallProductContent spc on sc.cmsContentID = spc.contentID
		</cfquery>
		
		<cfquery name="local.updateData">
			DELETE FROM SlatwallProductContent
		</cfquery>
	</cfif>
	
	<cfcatch>	
		<cflog file="Slatwall" text="General Log - Update productPage Mappings Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<!--- Update Promotions to move Info Down into PromotionPeriod --->
<cftry>
	<cfdbinfo datasource="#getApplicationValue("datasource")#" username="#getApplicationValue("datasourceUsername")#" password="#getApplicationValue("datasourcePassword")#" type="Columns" table="SlatwallPromotionReward" name="local.infoColumns" />
	
	<cfquery name="local.hasColumn" dbtype="query">
		SELECT
			* 
		FROM
			infoColumns
		WHERE
			COLUMN_NAME = 'promotionID'
	</cfquery>
	
	<cfif local.hasColumn.recordCount>
		
		<cfquery name="local.getData">
			SELECT
				promotionID,
				startDateTime,
				endDateTime
			FROM
				SlatwallPromotion
			WHERE
				NOT EXISTS(SELECT SlatwallPromotionPeriod.promotionPeriodID FROM SlatwallPromotionPeriod WHERE SlatwallPromotionPeriod.promotionID = SlatwallPromotion.promotionID)
		</cfquery>
		
		<cfloop query="local.getData">
			<cfset local.newUUID = replace(lcase(createUUID()), "-", "", "all") />
			<cfquery name="local.updateData">
				INSERT INTO SlatwallPromotionPeriod (
					promotionPeriodID,
					promotionID,
					startDateTime,
					endDateTime
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.newUUID#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.getData.startDateTime#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#local.getData.startDateTime#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#local.getData.endDateTime#">
				)
			</cfquery>
			
			<cfquery name="local.updateData">
				UPDATE
					SlatwallPromotionReward
				SET
					promotionPeriodID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.newUUID#">,
					promotionID = null
				WHERE
					promotionID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.getData.promotionID#">
			</cfquery>
			
		</cfloop>
	</cfif>
	
	<cfcatch>
		<cflog file="Slatwall" text="General Log - Update Promotions Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>


<!--- Update Integration Settings --->
<!--- 
<cftry>
	<cfdbinfo datasource="#getApplicationValue("datasource")#" username="#getApplicationValue("datasourceUsername")#" password="#getApplicationValue("datasourcePassword")#" type="Columns" table="SlatwallIntegration" name="local.infoColumns" />
	
	<cfquery name="local.hasColumn" dbtype="query">
		SELECT
			* 
		FROM
			local.infoColumns
		WHERE
			COLUMN_NAME = 'filename'
	</cfquery>
	
	<cfif local.hascolumn.recordCount>
		
		<cfquery name="local.getData">
			SELECT
				integrationID,
				integrationSettings
			FROM
				SlatwallIntegration
			WHERE
				integrationSettings is not null
		</cfquery>
		
		<cfloop query="local.getData">
			
			<cfquery name="local.updateData">
				UPDATE SlatwallIntegration SET integrationSettings = null WHERE integrationID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.getData.integrationID#">
			</cfquery>
			
			<cfset local.settings = structNew() />
			<cftry>
				<cfset local.settings = deserializeJSON(local.getData.integrationSettings) />
				<cfcatch></cfcatch>
			</cftry>
			<cfloop collection="#local.settings#" item="local.settingName">
				<!--- You Stopped Here --->
			</cfloop>
			<cfquery name="local.updateData">
				UPDATE SlatwallIntegration SET integrationSettings = null WHERE integrationID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.getData.integrationID#">
			</cfquery>
		</cfloop>
	</cfif>
	
	<cfcatch>	
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>
--->

<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Part of Script v2_0 had errors when running">
	<cfthrow detail="Part of Script v2_0 had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Script v2_0 has run with no errors">
</cfif>
