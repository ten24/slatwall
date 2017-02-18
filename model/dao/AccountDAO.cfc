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
<cfcomponent extends="HibachiDAO">

	<cffunction name="getPrimaryEmailAddressNotInUseFlag" returntype="boolean" access="public">
		<cfargument name="emailAddress" required="true" type="string" />
		<cfargument name="accountID" type="string" />

		<cfif structKeyExists(arguments, "accountID")>
			<cfreturn not arrayLen(ormExecuteQuery("SELECT aa FROM #getApplicationKey()#AccountAuthentication aa INNER JOIN FETCH aa.account a INNER JOIN a.primaryEmailAddress pea WHERE lower(pea.emailAddress)=:emailAddress AND a.accountID <> :accountID", {emailAddress=lcase(arguments.emailAddress), accountID=arguments.accountID})) />
		</cfif>
		<cfreturn not arrayLen(ormExecuteQuery("SELECT aa FROM #getApplicationKey()#AccountAuthentication aa INNER JOIN FETCH aa.account a INNER JOIN a.primaryEmailAddress pea WHERE lower(pea.emailAddress)=:emailAddress", {emailAddress=lcase(arguments.emailAddress)})) />
	</cffunction>

	<cffunction name="getAccountIDByPrimaryEmailAddress">
		<cfargument name="emailAddress" required="true" type="string" />

		<cfquery name="local.getAccountIDByPrimaryEmailAddress" maxrows="1">
			SELECT a.accountID FROM SwAccount AS a LEFT JOIN SwAccountEmailAddress AS aea ON aea.accountID=a.accountID
			WHERE emailAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailAddress#" />
		</cfquery>

		<cfreturn getAccountIDByPrimaryEmailAddress.accountID />

	</cffunction>

	<cffunction name="removeAccountAuthenticationFromSessions">
		<cfargument name="accountAuthenticationID" type="string" required="true" >

		<cfset var rs = "" />

		<cfquery name="rs">
			UPDATE
				SwSession
			SET
				accountAuthenticationID = null,
				accountID = null
			WHERE
				accountAuthenticationID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.accountAuthenticationID#" />
		</cfquery>
	</cffunction>

	<cffunction name="removeAccountAddressFromOrderFulfillments">
		<cfargument name="accountAddressID" type="string" required="true" >

		<cfset var rs = "" />

		<cfquery name="rs">
			UPDATE
				SwOrderFulfillment
			SET
				accountAddressID = null
			WHERE
				accountAddressID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.accountAddressID#" />
		</cfquery>
	</cffunction>

	<cffunction name="removeAccountAddressFromOrderPayments">
		<cfargument name="accountAddressID" type="string" required="true" >

		<cfset var rs = "" />

		<cfquery name="rs">
			UPDATE
				SwOrderPayment
			SET
				billingAccountAddressID = null
			WHERE
				billingAccountAddressID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.accountAddressID#" />
		</cfquery>
	</cffunction>

	<cffunction name="removeAccountAddressFromOrders">
		<cfargument name="accountAddressID" type="string" required="true" >

		<cfset var rs = "" />

		<cfquery name="rs">
			UPDATE
				SwOrder
			SET
				billingAccountAddressID = null
			WHERE
				billingAccountAddressID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.accountAddressID#" />
		</cfquery>

		<cfquery name="rs">
			UPDATE
				SwOrder
			SET
				shippingAccountAddressID = null
			WHERE
				shippingAccountAddressID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.accountAddressID#" />
		</cfquery>

	</cffunction>

	<cffunction name="removeAccountAddressFromSubscriptionUsages">
		<cfargument name="accountAddressID" type="string" required="true" >

		<cfset var rs = "" />

		<cfquery name="rs">
			UPDATE
				SwSubsUsage
			SET
				shippingAccountAddressID = null
			WHERE
				shippingAccountAddressID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.accountAddressID#" />
		</cfquery>

	</cffunction>
	
	<cffunction name="removeAccountPaymentMethodFromOrderPayments">
		<cfargument name="accountPaymentMethodID" type="string" required="true" >

		<cfset var rs = "" />

		<cfquery name="rs">
			UPDATE
				SwOrderPayment
			SET
				accountPaymentMethodID = null
			WHERE
				accountPaymentMethodID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.accountPaymentMethodID#" />
		</cfquery>
	</cffunction>

	<cffunction name="removeAccountAuthenticationFromAllSessions" returntype="void" access="public">
		<cfargument name="accountAuthenticationID" required="true"  />

		<cfset var rs = "" />

		<cfquery name="rs">
			UPDATE SwSession
			SET accountAuthenticationID = null
			WHERE accountAuthenticationID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.accountAuthenticationID#" />
		</cfquery>

	</cffunction>

	<cffunction name="getInternalAccountAuthenticationsByEmailAddress" returntype="any" access="public">
		<cfargument name="emailAddress" required="true" type="string" />

		<cfreturn ormExecuteQuery("SELECT aa FROM #getApplicationKey()#AccountAuthentication aa INNER JOIN FETCH aa.account a INNER JOIN a.primaryEmailAddress pea WHERE aa.password is not null AND aa.integration.integrationID is null AND lower(pea.emailAddress)=:emailAddress", {emailAddress=lcase(arguments.emailAddress)}) />
	</cffunction>

	<cffunction name="getActivePasswordByEmailAddress" returntype="any" access="public">
		<cfargument name="emailAddress" required="true" type="string" />

		<cfreturn ormExecuteQuery("SELECT aa FROM #getApplicationKey()#AccountAuthentication aa INNER JOIN FETCH aa.account a INNER JOIN a.primaryEmailAddress pea WHERE aa.password is not null AND aa.integration.integrationID is null AND lower(pea.emailAddress)=:emailAddress AND aa.activeFlag = true ORDER BY aa.createdDateTime DESC", {emailAddress=lcase(arguments.emailAddress)}, true, {maxResults=1}) />
	</cffunction>

	<cffunction name="getActivePasswordByAccountID" returntype="any" access="public">
		<cfargument name="accountID" required="true" type="string" />

		<cfreturn ormExecuteQuery("SELECT aa FROM #getApplicationKey()#AccountAuthentication aa INNER JOIN FETCH aa.account a WHERE aa.password is not null AND aa.integration.integrationID is null AND a.accountID=:accountid AND aa.activeFlag = true", {accountid=arguments.accountID}, true) />
	</cffunction>

	<cffunction name="getAccountAuthenticationExists" returntype="any" access="public">
		<cfset var aaCount = ormExecuteQuery("SELECT count(aa.accountAuthenticationID) FROM #getApplicationKey()#AccountAuthentication aa") />
		<cfreturn aaCount[1] gt 0 />
	</cffunction>
	
	<cffunction name="getAccountExists" returntype="any" access="public">
		<cfset var accountCount = ormExecuteQuery("Select count(a.accountID) FROM #getApplicationKey()#Account a") />
		<cfreturn accountCount[1] gt 0 />
	</cffunction>

	<cffunction name="getAccountWithAuthenticationByEmailAddress" returntype="any" access="public">
		<cfargument name="emailAddress" required="true" type="string" />

		<cfset var accounts = ormExecuteQuery("SELECT a FROM #getApplicationKey()#Account a INNER JOIN a.primaryEmailAddress pea WHERE lower(pea.emailAddress) = :emailAddress AND EXISTS(SELECT aa.accountAuthenticationID FROM #getApplicationKey()#AccountAuthentication aa WHERE aa.account.accountID = a.accountID)", {emailAddress=lcase(arguments.emailAddress)}) />
		<cfif arrayLen(accounts)>
			<cfreturn accounts[1] />
		</cfif>
	</cffunction>

	<cffunction name="getPasswordResetAccountAuthentication">
		<cfargument name="accountID" type="string" required="true" />

		<cfset var accountAuthentication = ormExecuteQuery("
			SELECT aa FROM #getApplicationKey()#AccountAuthentication 
			aa LEFT JOIN aa.integration i WHERE aa.account.accountID = :accountID 
										and aa.expirationDateTime >= :now 
										and aa.password is null 
										and i.integrationID is null 
			ORDER BY aa.expirationDateTime desc
			", {accountID=arguments.accountID, now=now()}, true, {maxresults=1}) />

		<cfif !isNull(accountAuthentication)>
			<cfreturn accountAuthentication />
		</cfif>
	</cffunction>

	<cffunction name="removeAccountFromAuditProperties" returntype="void" access="public">
		<cfargument name="accountID" type="string" required="true" />

		<cfset var allTables = "" />
		<cfset var auditColumns = "" />
		<cfset var rs = "" />

		<cfdbinfo type="Tables" name="allTables" pattern="Sw%" />

		<cfloop query="allTables">
			<cfdbinfo type="Columns" table="#allTables.TABLE_NAME#" name="auditColumns" pattern="%ByAccountID" />

			<cfloop query="auditColumns">
				<cfquery name="rs">
					UPDATE
						#allTables.TABLE_NAME#
					SET
						#auditColumns.COLUMN_NAME# = null
					WHERE
						#auditColumns.COLUMN_NAME# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.accountID#" />
				</cfquery>
			</cfloop>
		</cfloop>

	</cffunction>

	<cffunction name="removeAccountFromAllSessions" returntype="void" access="public">
		<cfargument name="accountID" required="true"  />
		<cfset var rs = "" />
		<cfquery name="rs">
			UPDATE SwSession SET accountID = null, accountAuthenticationID = null WHERE accountID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.accountID#" />
		</cfquery>
	</cffunction>

	<cffunction name="mergeAccount" returntype="void" access="public">
		<cfargument name="newAccountID" type="string" required="true" />
		<cfargument name="oldAccountID" type="string" required="true" />

		<cfset var rs = "" />
		<cfset var tableInfo = "" />
		<cfdbinfo type="Tables" name="tableInfo" pattern="Sw%">

		<cfloop query="#tableInfo#">
			<cfset var tableName = tableInfo.tableName />

			<cfif tableName neq "#getApplicationKey()#Account">
				<cfset var columnInfo = "" />
				<cfdbinfo type="Columns" table="#tableName#" name="columnInfo">

				<cfloop query="columnInfo">
					<cfset var columnName = columnInfo.columnName />

					<cfif listFindNoCase("accountID,createdByAccountID,modifiedByAccountID", columnName)>>
						<cfquery name="rs">
							UPDATE #tableName# SET #columnName# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newAccountID#" /> WHERE #columnName# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.oldAccountID#" />
						</cfquery>
					</cfif>
				</cfloop>
			</cfif>

		</cfloop>

		<cfquery name="rs">
			DELETE FROM SwAccount WHERE accountID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.oldAccountID#" />
		</cfquery>
	</cffunction>

	<cffunction name="getNewAccountLoyaltyNumber" output="false">
		<cfargument name="loyaltyID" type="string" required="true" />

		<cfset var accountLoyaltyNumber="1234" />
		<cfset var rs = "" />

		<cfquery name="rs">
			SELECT MAX(accountLoyaltyNumber) as maxAccountLoyaltyNumber FROM SwAccountLoyalty WHERE loyaltyID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.loyaltyID#" />
		</cfquery>

		<cfif rs.maxAccountLoyaltyNumber gt 0 >
			<cfset accountLoyaltyNumber = rs.maxAccountLoyaltyNumber + 1 />
		</cfif>

		<cfreturn accountLoyaltyNumber />
	</cffunction>

</cfcomponent>

