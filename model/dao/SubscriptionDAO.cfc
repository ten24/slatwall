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

	<cffunction name="getUniquePreviousSubscriptionOrderPayments">
		<cfargument name="subscriptionUsageID" type="string" required="true" />

		<cfreturn ormExecuteQuery("SELECT DISTINCT op FROM SlatwallSubscriptionOrderItem soi INNER JOIN soi.orderItem oi INNER JOIN oi.order o INNER JOIN o.orderPayments op WHERE soi.subscriptionUsage.subscriptionUsageID = :subscriptionUsageID AND op.referencedOrderPayment IS NULL AND op.orderPaymentStatusType.systemCode = 'opstActive'", {subscriptionUsageID=arguments.subscriptionUsageID}) />
	</cffunction>

	<cffunction name="getSubscriptionCurrentStatus">
		<cfargument name="subscriptionUsageID" type="string" required="true" />

		<cfset var hql = "FROM SlatwallSubscriptionStatus ss
							WHERE ss.subscriptionUsage.subscriptionUsageID = :subscriptionUsageID
							AND ss.effectiveDateTime <= :now
							ORDER BY ss.effectiveDateTime DESC " />


		<cfreturn ormExecuteQuery(hql, {subscriptionUsageID=arguments.subscriptionUsageID, now=now()}, true, {maxresults=1}) />
	</cffunction>

	<cffunction name="getSubscriptionUsageForRenewal">

		<cfset var getsu = "" />
		<!--- can't figure out top 1 hql so, doing query: Sumit --->
		<cfif getApplicationValue("databaseType") eq "MySQL">
			<cfquery name="getsu">
				SELECT DISTINCT su.subscriptionUsageID
				FROM SwSubsUsage su
				WHERE (su.nextBillDate <= <cfqueryparam value="#dateformat(now(),'mm-dd-yyyy 23:59')#" cfsqltype="cf_sql_timestamp" />)
					AND 'sstActive' = (SELECT systemCode FROM SwSubscriptionStatus
								INNER JOIN SwType ON SwSubscriptionStatus.subscriptionStatusTypeID = SwType.typeID
								WHERE SwSubscriptionStatus.subscriptionUsageID = su.subscriptionUsageID
								AND SwSubscriptionStatus.effectiveDateTime <= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp" />
								ORDER BY changeDateTime DESC LIMIT 1)
			</cfquery>
		<cfelseif getApplicationValue("databaseType") eq "Oracle10g">
			<cfquery name="getsu">
				SELECT DISTINCT su.subscriptionUsageID
				FROM SwSubsUsage su
				WHERE (su.nextBillDate <= <cfqueryparam value="#dateformat(now(),'mm-dd-yyyy 23:59')#" cfsqltype="cf_sql_timestamp" />)
					AND 'sstActive' = (SELECT systemcode FROM (SELECT systemCode,subscriptionUsageID FROM SwSubscriptionStatus
				                    INNER JOIN SwType ON SwSubscriptionStatus.subscriptionStatusTypeID = SwType.typeID
				                    WHERE SwSubscriptionStatus.effectiveDateTime <= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp" />
				                    ORDER BY changeDateTime DESC)
									WHERE subscriptionUsageID = su.subscriptionUsageID
				                    AND rownum <= 1)
			</cfquery>
		<cfelse>
			<cfquery name="getsu">
				SELECT DISTINCT su.subscriptionUsageID
				FROM SwSubsUsage su
				WHERE (su.nextBillDate <= <cfqueryparam value="#dateformat(now(),'mm-dd-yyyy 23:59')#" cfsqltype="cf_sql_timestamp" />)
					AND 'sstActive' = (SELECT TOP 1 systemCode FROM SwSubscriptionStatus
								INNER JOIN SwType ON SwSubscriptionStatus.subscriptionStatusTypeID = SwType.typeID
								WHERE SwSubscriptionStatus.subscriptionUsageID = su.subscriptionUsageID
								AND SwSubscriptionStatus.effectiveDateTime <= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp" />
								ORDER BY changeDateTime DESC)
			</cfquery>
		</cfif>

		<cfif getsu.recordCount>
			<cfset var hql = "FROM SlatwallSubscriptionUsage WHERE subscriptionUsageID IN (:subscriptionUsageIDs)" />

			<cfreturn ormExecuteQuery(hql, {subscriptionUsageIDs=listToArray(valueList(getsu.subscriptionUsageID))}) />
		</cfif>
		<cfreturn [] />

	</cffunction>

	<cffunction name="getSubscriptionUsageForRenewalReminder">

		<cfset var getsu = "" />
		<!--- can't figure out top 1 hql so, doing query: Sumit --->
		<cfif getApplicationValue("databaseType") eq "MySQL">
			<cfquery name="getsu">
				SELECT DISTINCT su.subscriptionUsageID
				FROM SwSubsUsage su
				WHERE (su.nextReminderEmailDate <= <cfqueryparam value="#dateformat(now(),'mm-dd-yyyy 23:59')#" cfsqltype="cf_sql_timestamp" />)
					AND 'sstActive' = (SELECT systemCode FROM SwSubscriptionStatus
								INNER JOIN SwType ON SwSubscriptionStatus.subscriptionStatusTypeID = SwType.typeID
								WHERE SwSubscriptionStatus.subscriptionUsageID = su.subscriptionUsageID
								AND SwSubscriptionStatus.effectiveDateTime <= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp" />
								ORDER BY changeDateTime DESC LIMIT 1)
			</cfquery>
		<cfelseif getApplicationValue("databaseType") eq "Oracle10g">
			<cfquery name="getsu">
				SELECT DISTINCT su.subscriptionUsageID
				FROM SwSubsUsage su
				WHERE (su.nextReminderEmailDate <= <cfqueryparam value="#dateformat(now(),'mm-dd-yyyy 23:59')#" cfsqltype="cf_sql_timestamp" />)
					AND 'sstActive' = (SELECT systemcode FROM (SELECT systemCode,subscriptionUsageID FROM SwSubscriptionStatus
				                    INNER JOIN SwType ON SwSubscriptionStatus.subscriptionStatusTypeID = SwType.typeID
				                    WHERE SwSubscriptionStatus.effectiveDateTime <= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp" />
				                    ORDER BY changeDateTime DESC)
									WHERE subscriptionUsageID = su.subscriptionUsageID
				                    AND rownum <= 1)
			</cfquery>
		<cfelse>
			<cfquery name="getsu">
				SELECT DISTINCT su.subscriptionUsageID
				FROM SwSubsUsage su
				WHERE (su.nextReminderEmailDate <= <cfqueryparam value="#dateformat(now(),'mm-dd-yyyy 23:59')#" cfsqltype="cf_sql_timestamp" />)
					AND 'sstActive' = (SELECT TOP 1 systemCode FROM SwSubscriptionStatus
								INNER JOIN SwType ON SwSubscriptionStatus.subscriptionStatusTypeID = SwType.typeID
								WHERE SwSubscriptionStatus.subscriptionUsageID = su.subscriptionUsageID
								AND SwSubscriptionStatus.effectiveDateTime <= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp" />
								ORDER BY changeDateTime DESC)
			</cfquery>
		</cfif>

		<cfif getsu.recordCount>
			<cfset var hql = "FROM SlatwallSubscriptionUsage WHERE subscriptionUsageID IN (:subscriptionUsageIDs)" />

			<cfreturn ormExecuteQuery(hql, {subscriptionUsageIDs=listToArray(valueList(getsu.subscriptionUsageID))}) />
		</cfif>
		<cfreturn [] />

	</cffunction>

	<cffunction name="getUnusedProductSubscriptionTerms">
		<cfargument name="productID" required="true" type="string" />

		<cfset var hql = "SELECT new map(st.subscriptionTermName as name, st.subscriptionTermID as value)
			FROM
				SlatwallSubscriptionTerm st
			WHERE
				st.subscriptionTermID NOT IN (SELECT skust.subscriptionTermID FROM SlatwallSku sku INNER JOIN sku.subscriptionTerm skust INNER JOIN sku.product skup WHERE skup.productID = :productID)" />

		<cfreturn ormExecuteQuery(hql, {productID=arguments.productID}) />
	</cffunction>

</cfcomponent>
