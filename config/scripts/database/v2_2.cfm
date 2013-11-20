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

<cfdbinfo datasource="#getApplicationValue("datasource")#" username="#getApplicationValue("datasourceUsername")#" password="#getApplicationValue("datasourcePassword")#" type="Tables" name="local.infoTables" pattern="Sw%" />

<!--- Update payment methods to use the new paymentIntegrationID value instead of provider gateway --->
<cftry>
	<cfdbinfo datasource="#getApplicationValue("datasource")#" username="#getApplicationValue("datasourceUsername")#" password="#getApplicationValue("datasourcePassword")#" type="Columns" table="SwPaymentMethod" name="local.infoColumns" />
	
	<cfquery name="local.hasColumn" dbtype="query">
		SELECT
			* 
		FROM
			infoColumns
		WHERE
			COLUMN_NAME = 'providerGateway'
	</cfquery>
	
	<cfif local.hasColumn.recordCount>
		<cfquery name="local.updateData">
			UPDATE
				SwPaymentMethod
			SET
				paymentIntegrationID = (SELECT integrationID FROM SlatwallIntegration WHERE SlatwallIntegration.integrationPackage = SlatwallPaymentMethod.providerGateway)
			WHERE
				paymentIntegrationID IS NULL
			  AND
			  	providerGateway IS NOT NULL
		</cfquery>
	</cfif>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update paymentIntegrationID on SlatwallPaymentMethod Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<!--- Update creditCard transactions and move them into the paymentTransaction table --->
<cftry>
	<cfquery name="local.hasTable" dbtype="query">
		SELECT
			* 
		FROM
			infoTables
		WHERE
			TABLE_NAME = 'SlatwallCreditCardTransaction'
	</cfquery>
	
	<cfif local.hasTable.recordCount>
		<cfquery name="local.updateData">
			SELECT
				creditCardTransactionID,
				transactionType,
				providerTransactionID,
				authorizationCode,
				amountAuthorized,
				amountCharged,
				amountCredited,
				avsCode,
				statusCode,
				message,
				orderPaymentID,
				createdDateTime,
				createdByAccountID,
				modifiedDateTime,
				modifiedByAccountID
			FROM
				SlatwallCreditCardTransaction
			WHERE NOT EXISTS( SELECT paymentTransactionID FROM SlatwallPaymentTransaction WHERE SlatwallPaymentTransaction.paymentTransactionID = SlatwallCreditCardTransaction.creditCardTransactionID )
		</cfquery>
		
		<cfloop query="local.updateData">
			<cfquery name="local.change">
				INSERT INTO SwPaymentTransaction (
					paymentTransactionID,
					transactionType,
					providerTransactionID,
					transactionDateTime,
					authorizationCode,
					amountAuthorized,
					amountCharged,
					amountCredited,
					avsCode,
					statusCode,
					message,
					orderPaymentID,
					createdDateTime,
					createdByAccountID,
					modifiedDateTime,
					modifiedByAccountID
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.updateData.creditCardTransactionID#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.updateData.transactionType#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" null="#not len(local.updateData.providerTransactionID)#" value="#local.updateData.providerTransactionID#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" null="#not len(local.updateData.createdDateTime)#" value="#local.updateData.createdDateTime#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" null="#not len(local.updateData.authorizationCode)#" value="#local.updateData.authorizationCode#" />,
					<cfqueryparam cfsqltype="cf_sql_money" value="#local.updateData.amountAuthorized#" />,
					<cfqueryparam cfsqltype="cf_sql_money" value="#local.updateData.amountCharged#" />,
					<cfqueryparam cfsqltype="cf_sql_money" value="#local.updateData.amountCredited#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" null="#not len(local.updateData.avsCode)#" value="#local.updateData.avsCode#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" null="#not len(local.updateData.statusCode)#" value="#local.updateData.statusCode#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" null="#not len(local.updateData.message)#" value="#local.updateData.message#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" null="#not len(local.updateData.orderPaymentID)#" value="#local.updateData.orderPaymentID#" />,
					<cfqueryparam cfsqltype="cf_sql_timestamp" null="#not len(local.updateData.createdDateTime)#" value="#local.updateData.createdDateTime#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" null="#not len(local.updateData.createdByAccountID)#" value="#local.updateData.createdByAccountID#" />,
					<cfqueryparam cfsqltype="cf_sql_timestamp" null="#not len(local.updateData.modifiedDateTime)#" value="#local.updateData.modifiedDateTime#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" null="#not len(local.updateData.modifiedByAccountID)#" value="#local.updateData.modifiedByAccountID#" />
				)
			</cfquery>
		</cfloop>
	</cfif>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - move credit card transactions to payment transactions has error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cftry>
	<cfquery name="local.change">
		UPDATE
			SwOrder
		SET
			currencyCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="USD" />
		WHERE
			currencyCode is null
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update currencyCode on SlatwallOrder Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cftry>
	<cfquery name="local.change">
		UPDATE
			SwOrderFulfillment
		SET
			currencyCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="USD" />
		WHERE
			currencyCode is null
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update currencyCode on SlatwallOrderFulfillment Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cftry>
	<cfquery name="local.change">
		UPDATE
			SwOrderReturn
		SET
			currencyCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="USD" />
		WHERE
			currencyCode is null
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update currencyCode on SlatwallOrderReturn Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cftry>
	<cfquery name="local.change">
		UPDATE
			SwOrderPayment
		SET
			currencyCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="USD" />
		WHERE
			currencyCode is null
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update currencyCode on SlatwallOrderPayment Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cftry>
	<cfquery name="local.change">
		UPDATE
			SwPaymentTransaction
		SET
			currencyCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="USD" />
		WHERE
			currencyCode is null
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update currencyCode on SlatwallPaymentTransaction Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cftry>
	<cfquery name="local.change">
		UPDATE
			SwPromotionApplied
		SET
			currencyCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="USD" />
		WHERE
			currencyCode is null
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update currencyCode on SlatwallPromotionApplied Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cftry>
	<cfquery name="local.change">
		UPDATE
			SwShippingMethodOption
		SET
			currencyCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="USD" />
		WHERE
			currencyCode is null
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update currencyCode on SlatwallShippingMethodOption Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cftry>
	<cfquery name="local.change">
		UPDATE
			SwStockReceiverItem
		SET
			currencyCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="USD" />
		WHERE
			currencyCode is null
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update currencyCode on SlatwallStockReceiverItem Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cftry>
	<cfquery name="local.change">
		UPDATE
			SwSubsUsage
		SET
			currencyCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="USD" />
		WHERE
			currencyCode is null
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update currencyCode on SlatwallSubscriptionUsage Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cftry>
	<cfquery name="local.change">
		UPDATE
			SwTaxApplied
		SET
			currencyCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="USD" />
		WHERE
			currencyCode is null
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update currencyCode on SlatwallTaxApplied Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cftry>
	<cfquery name="local.change">
		UPDATE
			SwVendorOrder
		SET
			currencyCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="USD" />
		WHERE
			currencyCode is null
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update currencyCode on SlatwallVendorOrder Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cftry>
	<cfquery name="local.change">
		UPDATE
			SwVendorOrderItem
		SET
			currencyCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="USD" />
		WHERE
			currencyCode is null
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update currencyCode on SlatwallVendorOrderItem Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cftry>
	<cfquery name="local.change">
		UPDATE
			SwVendorSkuStock
		SET
			currencyCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="USD" />
		WHERE
			currencyCode is null
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update currencyCode on SlatwallVendorSkuStock Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cftry>
	<cfquery name="local.change">
		UPDATE
			SwOrderItem
		SET
			currencyCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="USD" />
		WHERE
			currencyCode is null
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update currencyCode on SlatwallOrderItem Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<!--- Move amountCharged into amountReceived --->
<cftry>
	<cfdbinfo datasource="#getApplicationValue("datasource")#" username="#getApplicationValue("datasourceUsername")#" password="#getApplicationValue("datasourcePassword")#" type="Columns" table="SwPaymentTransaction" name="local.infoColumns" />
	
	<cfquery name="local.hasColumn" dbtype="query">
		SELECT
			* 
		FROM
			infoColumns
		WHERE
			COLUMN_NAME = 'amountCharged'
	</cfquery>
	
	<cfif local.hasColumn.recordCount>
		<cfquery name="local.updateData">
			UPDATE
				SwPaymentTransaction
			SET
				amountReceived = amountCharged,
				amountCharged = 0
			WHERE
				amountCharged IS NOT NULL
			  AND
			  	amountCharged > 0
		</cfquery>
	<cfelse>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - WHAT!!!!">
	</cfif>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update amountCharged column into amountReceived column Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Part of Script v2_2 had errors when running">
	<cfthrow detail="Part of Script v2_2 had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Script v2_2 has run with no errors">
</cfif>
