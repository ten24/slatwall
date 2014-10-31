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
<cfparam name="this.ormSettings.dialect" />
<cfparam name="this.datasource.name" />
<cfparam name="this.datasource.username" default="" />
<cfparam name="this.datasource.password" default="" />

<cfif this.ormSettings.dialect neq "Oracle10g">
	<cfsetting requesttimeout="1200" />
	
	<cfdbinfo datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#" type="tables" name="currenttables" pattern="Slatwall%" />
	
	<!--- Make sure that tables exist with the name 'Slatwall' --->
	<cfif currenttables.recordCount>
		
		<cfif this.ormSettings.dialect eq "MySQL">
			<!--- drop all constraints and index on mysql --->
			<cfdbinfo datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#" type="tables" name="infoTables" />
			<cfloop query="infoTables">
				<cfdbinfo datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#" type="index" table="#infoTables.table_name#" name="local.indexes" />
				<cfloop query="local.indexes">
					<cfif left(local.indexes.INDEX_NAME,"2") EQ "FK">
						<cftry>
						<cfquery name="dropConstraint" datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#">
							ALTER TABLE #infoTables.table_name#
							DROP FOREIGN KEY #local.indexes.INDEX_NAME#
						</cfquery>
						<cfcatch></cfcatch>
						</cftry>
						<cftry>
						<cfquery name="dropIndex" datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#">
							DROP INDEX #local.indexes.INDEX_NAME# ON #infoTables.table_name#
						</cfquery>
						<cfcatch></cfcatch>
						</cftry>
					</cfif>
				</cfloop>
			</cfloop>
		</cfif>
		
		<!--- Rename DB Table --->
		<cfset local.lookupValues = ['Slatwall','PromotionReward','PromotionQualifier','SubscriptionUsage','SubscriptionBenefit','Exclusion','Excluded','PriceGroupRateExclProductType','PromoRewardEligiblePriceGroup','PromoRewardShippingAddressZone','PromoQualShippingAddressZone'] />
		<cfset local.newValues = ['Sw','PromoReward','PromoQual','SubsUsage','SubsBenefit','Excl','Excl','PriceGrpRateExclProductType','PromoRewardEligiblePriceGrp','PromoRewardShipAddressZone','PromoQualShipAddressZone'] />
		<cfdbinfo datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#" type="tables" name="local.tables" />
		
		<cfset local.allTables = "" />
		
		<!--- loop through all the table --->
		<cfloop query="local.tables">
			<cfset local.newTableName = local.tables.table_name />
			
			<!--- loop through all the string in name that needs to get replaced --->
			<cfloop from="1" to="#arrayLen(local.lookupvalues)#" index="i">
				<cfif findNoCase(local.lookupvalues[i],local.newTableName)>
					<cfset local.newTableName = replaceNoCase(local.newTableName,local.lookupvalues[i],local.newValues[i]) /> 
				</cfif>
			</cfloop>
			<cfif local.newTableName NEQ local.tables.table_name>
				<cfif this.ormSettings.dialect eq "MySQL">
					<cfquery name="local.qryrenametable" datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#">
						RENAME TABLE #local.tables.table_name# TO #local.newTableName#
					</cfquery>
				<cfelse>
					<cfquery name="local.qryrenametable" datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#">
						EXEC sp_rename '#local.tables.table_name#','#local.newTableName#'
					</cfquery>
				</cfif>
			</cfif>
			
			<cfset local.allTables = listAppend(local.allTables, local.newTableName) />
		</cfloop>
		
		<!--- change the long field names --->
		<cfset local.lookupValues = ['SwAccountAuthentication.integrationAccessTokenExpiration','SwPaymentMethod.saveAccountPaymentMethodTransactionType','SwPaymentMethod.saveAccountPaymentMethodEncryptFlag','SwPaymentMethod.saveOrderPaymentTransactionType','SwPaymentMethod.placeOrderChargeTransactionType','SwPaymentMethod.placeOrderCreditTransactionType','SwAccess.subscriptionUsageBenefitAccountID','SwSubscriptionStatus.subscriptionStatusChangeReasonTypeID','SwSubsUsageBenefitAccount.subscriptionUsageBenefitAccountID'] />
		<cfset local.newValues = ['SwAccountAuthentication.integrationAccessTokenExp','SwPaymentMethod.saveAccountPaymentMethodTxType','SwPaymentMethod.saveAccPaymentMethodEncFlag','SwPaymentMethod.saveOrderPaymentTxType','SwPaymentMethod.placeOrderChargeTxType','SwPaymentMethod.placeOrderCreditTxType','SwAccess.subsUsageBenefitAccountID','SwSubscriptionStatus.subsStatusChangeReasonTypeID','SwSubsUsageBenefitAccount.subsUsageBenefitAccountID'] />
		
		<cfloop from="1" to="#arrayLen(local.lookupValues)#" index="i">
			<cfif listFindNoCase(local.allTables, listFirst(local.lookupValues[i],'.'))>
				<cfdbinfo datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#" type="columns" table="#listFirst(local.lookupValues[i],'.')#" name="local.columns" />
				
				<cfloop query="local.columns">
					<cfif local.columns.column_name EQ listLast(local.lookupValues[i],'.')>
						<!--- for mysql first drop the primary key constraints --->
						<cfif local.columns.IS_PRIMARYKEY AND this.ormSettings.dialect eq "MySQL">
							<cfquery name="dropConstraint" datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#">
								ALTER TABLE #listFirst(local.lookupValues[i],'.')#
								DROP PRIMARY KEY
							</cfquery>
						</cfif>
						<!--- update column names --->
						<cfif this.ormSettings.dialect eq "MySQL">
							<cfquery name="local.qryrenametable" datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#">
								ALTER TABLE #listFirst(local.lookupValues[i],'.')# CHANGE #listLast(local.lookupValues[i],'.')# #listLast(local.newValues[i],'.')# <cfif local.columns.TYPE_NAME EQ "varchar">varchar(#local.columns.COLUMN_SIZE#)<cfelse>#local.columns.TYPE_NAME#</cfif>
							</cfquery>
						<cfelse>
							<cfquery name="local.qryrenametable" datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#">
								EXEC sp_rename '#listFirst(local.lookupValues[i],'.')#.#listLast(local.lookupValues[i],'.')#','#listLast(local.newValues[i],'.')#','COLUMN'
							</cfquery>
						</cfif>
						<!--- for mysql create primary key --->
						<cfif local.columns.IS_PRIMARYKEY AND this.ormSettings.dialect eq "MySQL">
							<cfquery name="addConstraint" datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#">
								ALTER TABLE #listFirst(local.lookupValues[i],'.')# ADD PRIMARY KEY(#listLast(local.newValues[i],'.')#)
							</cfquery>
						</cfif>
					</cfif>
				</cfloop>
			</cfif>
		</cfloop>
		
	</cfif>
	
</cfif>
<cflog file="Slatwall" text="General Log - Preupdate Script v3_1 has run with no errors">