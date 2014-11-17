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

<cfdbinfo type="Columns" name="local.accountPaymentColumns" table="SwAccountPayment"  datasource="#getApplicationValue("datasource")#" username="#getApplicationValue("datasourceUsername")#" password="#getApplicationValue("datasourcePassword")#" />

<!--- Update accountPayment and move amount into the AccountPaymentApplied table --->
<cftry>
	<cfquery name="local.hasColumn" dbtype="query">
		SELECT
			* 
		FROM
			accountPaymentColumns
		WHERE
			LOWER(COLUMN_NAME) = 'amount'
	</cfquery>
	
	<cfif local.hasColumn.recordCount>
		<cfquery name="local.updateData">
			SELECT
				accountPaymentID,
				amount,
				createdDateTime,
				createdByAccountID,
				modifiedDateTime,
				modifiedByAccountID
			FROM
				SwAccountPayment
			WHERE NOT EXISTS( SELECT accountPaymentID FROM SwAccountPaymentApplied WHERE SwAccountPaymentApplied.accountPaymentID = SwAccountPayment.accountPaymentID )
		</cfquery>
		
		<cfloop query="local.updateData">
			<cfquery name="local.change">
				INSERT INTO SwAccountPaymentApplied (
					accountPaymentAppliedID,
					accountPaymentID,
					amount,
					createdDateTime,
					createdByAccountID,
					modifiedDateTime,
					modifiedByAccountID
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#createHibachiUUID()#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" null="#not len(local.updateData.accountPaymentID)#" value="#local.updateData.accountPaymentID#" />,
					<cfqueryparam cfsqltype="cf_sql_money" value="#local.updateData.amount#" />,
					<cfqueryparam cfsqltype="cf_sql_timestamp" null="#not len(local.updateData.createdDateTime)#" value="#local.updateData.createdDateTime#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" null="#not len(local.updateData.createdByAccountID)#" value="#local.updateData.createdByAccountID#" />,
					<cfqueryparam cfsqltype="cf_sql_timestamp" null="#not len(local.updateData.modifiedDateTime)#" value="#local.updateData.modifiedDateTime#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" null="#not len(local.updateData.modifiedByAccountID)#" value="#local.updateData.modifiedByAccountID#" />
				)
			</cfquery>
		</cfloop>
		
		<cfdbinfo datasource="#getApplicationValue("datasource")#" username="#getApplicationValue("datasourceUsername")#" password="#getApplicationValue("datasourcePassword")#" type="Columns" table="SwAccountPayment" name="local.infoColumns" />
	
		<cfquery name="local.hasColumn" dbtype="query">
			SELECT
				* 
			FROM
				infoColumns
			WHERE
				COLUMN_NAME = 'amount'
		</cfquery>
		
		<!--- Allow nulls in the AccountPayment amount field since we are using AccountPaymentApplied --->
		<cfif local.hasColumn.recordCount>
			<cfquery name="local.allowNull">
				<cfif getApplicationValue("databaseType") eq "MySQL">
					ALTER TABLE SwAccountPayment MODIFY COLUMN amount decimal(19,2) NULL
				<cfelseif getApplicationValue("databaseType") eq "Oracle10g">
					ALTER TABLE SwAccountPayment MODIFY (amount decimal(19,2) NULL)
				<cfelse>
					ALTER TABLE SwAccountPayment ALTER COLUMN amount decimal(19,2) NULL
				</cfif>
			</cfquery>
		</cfif>
	</cfif>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update accountPayment and move amount into the AccountPaymentApplied table has error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Part of Script v3_3 had errors when running">
	<cfthrow detail="Part of Script v3_3 had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Script v3_3 has run with no errors">
</cfif>
