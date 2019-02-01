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
<cfcomponent extends="HibachiDAO" output="false">

	<cffunction name="isDuplicatePaymentTransaction" access="public" returntype="boolean" output="false">
		<cfargument name="paymentID" type="string" required="true" />
		<cfargument name="idColumnName" type="string" required="true" />
		<cfargument name="paymentType" type="string" required="true" />
		<cfargument name="transactionType" type="string" required="true" />
		<cfargument name="transactionAmount" type="numeric" required="true" />

		<cfset var rs = "" />

		<!--- check for any transaction for this payment in last 60 sec with same type and amount --->
		<cfquery name="rs">
			SELECT
				#idColumnName#
			FROM
				SwPaymentTransaction
			WHERE
				#idColumnName# = <cfqueryparam value="#arguments.paymentID#" cfsqltype="cf_sql_varchar" />
			  AND
				transactionType = <cfqueryparam value="#arguments.transactionType#" cfsqltype="cf_sql_varchar" />
			  AND
				modifiedDateTime > <cfqueryparam value="#DateAdd("s",-60,now())#" cfsqltype="cf_sql_timestamp" />
			  AND
				(
					amountAuthorized = <cfqueryparam value="#arguments.transactionAmount#" cfsqltype="cf_sql_numeric" />
					OR
					amountReceived = <cfqueryparam value="#arguments.transactionAmount#" cfsqltype="cf_sql_numeric" />
					OR
					amountCredited = <cfqueryparam value="#arguments.transactionAmount#" cfsqltype="cf_sql_numeric" />
				)
		</cfquery>

		<cfreturn rs.recordcount />
	</cffunction>

	<cffunction name="getOriginalAuthorizationCode" access="public" returntype="string" output="false">
		<cfargument name="orderPaymentID" type="string" />
		<cfargument name="referencedOrderPaymentID" type="string" />
		<cfargument name="accountPaymentID" type="string" />

		<cfset var hql = "SELECT NEW MAP(spt.authorizationCode as authorizationCode) FROM SlatwallPaymentTransaction spt WHERE spt.transactionSuccessFlag = 1 AND spt.authorizationCode is not null AND spt.transactionType IN ( :transactionType ) AND " />
		<cfset var hqlParams = {} />
		<cfset hqlParams['transactionType'] = ["authorize", "authorizeAndCharge"] />

		<cfif structKeyExists(arguments, "orderPaymentID") and structKeyExists(arguments, "referencedOrderPaymentID")>
			<cfset hql &= "(spt.orderPayment.orderPaymentID = :orderPaymentID OR spt.orderPayment.orderPaymentID = :referencedOrderPaymentID) " />
			<cfset hqlParams['orderPaymentID'] = arguments.orderPaymentID />
			<cfset hqlParams['referencedOrderPaymentID'] = arguments.referencedOrderPaymentID />
		<cfelseif structKeyExists(arguments, "orderPaymentID")>
			<cfset hql &= "spt.orderPayment.orderPaymentID = :orderPaymentID " />
			<cfset hqlParams['orderPaymentID'] = arguments.orderPaymentID />
		<cfelseif structKeyExists(arguments, "accountPaymentID")>
			<cfset hql &= "spt.accountPayment.accountPaymentID = :accountPaymentID " />
			<cfset hqlParams['accountPaymentID'] = arguments.accountPaymentID />
		</cfif>

		<cfset var results = ormExecuteQuery(hql, hqlParams) />

		<cfif arrayLen(results)>
			<cfreturn results[1]['authorizationCode'] />
		</cfif>

		<cfreturn "" />
	</cffunction>

	<cffunction name="getOriginalAuthorizationProviderTransactionID" access="public" returntype="string" output="false">
		<cfargument name="orderPaymentID" type="string" />
		<cfargument name="referencedOrderPaymentID" type="string" />
		<cfargument name="accountPaymentID" type="string" />

		<cfset var hql = "SELECT NEW MAP(spt.providerTransactionID as providerTransactionID) FROM SlatwallPaymentTransaction spt WHERE spt.transactionSuccessFlag = 1 AND spt.providerTransactionID is not null AND spt.transactionType IN (:transactionType) AND " />
		<cfset var hqlParams = {} />
		<cfset hqlParams['transactionType'] = ["authorize","authorizeAndCharge"] />

		<cfif structKeyExists(arguments, "orderPaymentID") and structKeyExists(arguments, "referencedOrderPaymentID")>
			<cfset hql &= "(spt.orderPayment.orderPaymentID = :orderPaymentID OR spt.orderPayment.orderPaymentID = :referencedOrderPaymentID) " />
			<cfset hqlParams['orderPaymentID'] = arguments.orderPaymentID />
			<cfset hqlParams['referencedOrderPaymentID'] = arguments.referencedOrderPaymentID />
		<cfelseif structKeyExists(arguments, "orderPaymentID")>
			<cfset hql &= "spt.orderPayment.orderPaymentID = :orderPaymentID " />
			<cfset hqlParams['orderPaymentID'] = arguments.orderPaymentID />
		<cfelseif structKeyExists(arguments, "accountPaymentID")>
			<cfset hql &= "spt.accountPayment.accountPaymentID = :accountPaymentID " />
			<cfset hqlParams['accountPaymentID'] = arguments.accountPaymentID />
		</cfif>

		<cfset var results = ormExecuteQuery(hql, hqlParams) />

		<cfif arrayLen(results)>
			<cfreturn results[1]['providerTransactionID'] />
		</cfif>

		<cfreturn "" />
	</cffunction>

	<cffunction name="getOriginalChargeProviderTransactionID" access="public" returntype="string" output="false">
		<cfargument name="orderPaymentID" type="string" />
		<cfargument name="referencedOrderPaymentID" type="string" />
		<cfargument name="accountPaymentID" type="string" />

		<cfset var hql = "SELECT NEW MAP(spt.providerTransactionID as providerTransactionID) FROM SlatwallPaymentTransaction spt WHERE spt.transactionSuccessFlag = 1 AND spt.providerTransactionID is not null AND spt.transactionType IN (:transactionType) AND " />
		<cfset var hqlParams = {} />
		<cfset hqlParams['transactionType'] = ["chargePreAuthorization","authorizeAndCharge"] />

		<cfif structKeyExists(arguments, "orderPaymentID") and structKeyExists(arguments, "referencedOrderPaymentID")>
			<cfset hql &= "(spt.orderPayment.orderPaymentID = :orderPaymentID OR spt.orderPayment.orderPaymentID = :referencedOrderPaymentID) " />
			<cfset hqlParams['orderPaymentID'] = arguments.orderPaymentID />
			<cfset hqlParams['referencedOrderPaymentID'] = arguments.referencedOrderPaymentID />
		<cfelseif structKeyExists(arguments, "orderPaymentID")>
			<cfset hql &= "spt.orderPayment.orderPaymentID = :orderPaymentID " />
			<cfset hqlParams['orderPaymentID'] = arguments.orderPaymentID />
		<cfelseif structKeyExists(arguments, "accountPaymentID")>
			<cfset hql &= "spt.accountPayment.accountPaymentID = :accountPaymentID " />
			<cfset hqlParams['accountPaymentID'] = arguments.accountPaymentID />
		</cfif>

		<cfset var results = ormExecuteQuery(hql, hqlParams) />

		<cfif arrayLen(results)>
			<cfreturn results[1]['providerTransactionID'] />
		</cfif>

		<cfreturn "" />
	</cffunction>

	<cffunction name="getOriginalProviderTransactionID" access="public" returntype="string" output="false">
		<cfargument name="orderPaymentID" type="string" />
		<cfargument name="referencedOrderPaymentID" type="string" />
		<cfargument name="accountPaymentID" type="string" />

		<cfset var hql = "SELECT NEW MAP(spt.providerTransactionID as providerTransactionID) FROM SlatwallPaymentTransaction spt WHERE spt.transactionSuccessFlag = 1 AND spt.providerTransactionID is not null AND " />
		<cfset var hqlParams = {} />

		<cfif structKeyExists(arguments, "orderPaymentID") and structKeyExists(arguments, "referencedOrderPaymentID")>
			<cfset hql &= "(spt.orderPayment.orderPaymentID = :orderPaymentID OR spt.orderPayment.orderPaymentID = :referencedOrderPaymentID) " />
			<cfset hqlParams['orderPaymentID'] = arguments.orderPaymentID />
			<cfset hqlParams['referencedOrderPaymentID'] = arguments.referencedOrderPaymentID />
		<cfelseif structKeyExists(arguments, "orderPaymentID")>
			<cfset hql &= "spt.orderPayment.orderPaymentID = :orderPaymentID " />
			<cfset hqlParams['orderPaymentID'] = arguments.orderPaymentID />
		<cfelseif structKeyExists(arguments, "accountPaymentID")>
			<cfset hql &= "spt.accountPayment.accountPaymentID = :accountPaymentID " />
			<cfset hqlParams['accountPaymentID'] = arguments.accountPaymentID />
		</cfif>

		<cfset hql &= " ORDER BY spt.createdDateTime" />

		<cfset var results = ormExecuteQuery(hql, hqlParams) />

		<cfif arrayLen(results)>
			<cfreturn results[1]['providerTransactionID'] />
		</cfif>

		<cfreturn "" />
	</cffunction>

	<cffunction name="updateInvalidAuthorizationCode" access="public" returntype="any" output="false">
		<cfargument name="authorizationCode" type="string" required="true" />
		<cfargument name="orderPaymentID" type="string" />
		<cfargument name="accountPaymentID" type="string" />

		<cfset var hql = "UPDATE SlatwallPaymentTransaction SET authorizationCodeInvalidFlag = 1, modifiedDateTime = :now WHERE authorizationCode = :authorizationCode AND transactionType = :transactionType AND " />

		<cfset var hqlParams = {} />
		<cfset hqlParams['authorizationCode'] = arguments.authorizationCode />
		<cfset hqlParams['transactionType'] = "authorize" />
		<cfset hqlParams.now = now() />

		<cfif structKeyExists(arguments, "orderPaymentID")>
			<cfset hql &= "orderPayment.orderPaymentID = :orderPaymentID" />
			<cfset hqlParams['orderPaymentID'] = arguments.orderPaymentID />
		<cfelseif structKeyExists(arguments, "accountPaymentID")>
			<cfset hql &= "accountPayment.accountPaymentID = :accountPaymentID" />
			<cfset hqlParams['accountPaymentID'] = arguments.accountPaymentID />
		</cfif>

		<cfset ormExecuteQuery(hql, hqlParams) />
	</cffunction>

	<cffunction name="getAccountPaymentMethodNonGenerateTokenTransactionCount" access="public" returntype="any" output="false">
		<cfargument name="accountPaymentMethodID" type="string" required="true" />

		<cfset var hql = "SELECT count(pt.paymentTransactionID) FROM SlatwallPaymentTransaction pt WHERE pt.accountPaymentMethod.accountPaymentMethodID = :accountPaymentMethodID AND pt.transactionType != :transactionType" />

		<cfset var hqlParams = {} />
		<cfset hqlParams['transactionType'] = "generateToken" />
		<cfset hqlParams['accountPaymentMethodID'] = arguments.accountPaymentMethodID />

		<cfreturn ormExecuteQuery(hql, hqlParams)[1] />
	</cffunction>

</cfcomponent>
