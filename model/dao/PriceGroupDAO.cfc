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


	<cffunction name="getAccountSubscriptionPriceGroups">
		<cfargument name="accountID" type="string">

		<cfset var getpg = "" />
		<!--- can't figure out top 1 hql so, doing query: Sumit --->
		<cfif getApplicationValue("databaseType") eq "mySQL">
				<cfquery name="getpg">
					SELECT DISTINCT subpg.priceGroupID
					FROM SwSubsUsageBenefitAccount suba
					INNER JOIN SwSubsUsageBenefit sub ON suba.subscriptionUsageBenefitID = sub.subscriptionUsageBenefitID
					INNER JOIN SwSubsUsageBenefitPriceGroup subpg ON sub.subscriptionUsageBenefitID = subpg.subscriptionUsageBenefitID
					INNER JOIN SwSubsUsage su ON sub.subscriptionUsageID = su.subscriptionUsageID
					WHERE (suba.endDateTime IS NULL
							OR suba.endDateTime > <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp" />)
						AND suba.accountID = <cfqueryparam value="#arguments.accountID#" cfsqltype="cf_sql_varchar" />
						AND 'sstActive' = (SELECT systemCode FROM SwSubscriptionStatus
									INNER JOIN SwType ON SwSubscriptionStatus.subscriptionStatusTypeID = SwType.typeID
									WHERE SwSubscriptionStatus.subscriptionUsageID = su.subscriptionUsageID
									AND SwSubscriptionStatus.effectiveDateTime <= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp" />
									ORDER BY changeDateTime DESC LIMIT 1)
				</cfquery>
		<cfelseif getApplicationValue("databaseType") eq "Oracle10g">
				<cfquery name="getpg">
					SELECT DISTINCT subpg.priceGroupID
					FROM SwSubsUsageBenefitAccount suba
					INNER JOIN SwSubsUsageBenefit sub ON suba.subscriptionUsageBenefitID = sub.subscriptionUsageBenefitID
					INNER JOIN SwSubsUsageBenefitPriceGroup subpg ON sub.subscriptionUsageBenefitID = subpg.subscriptionUsageBenefitID
					INNER JOIN SwSubsUsage su ON sub.subscriptionUsageID = su.subscriptionUsageID
					WHERE (suba.endDateTime IS NULL
							OR suba.endDateTime > <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp" />)
						AND suba.accountID = <cfqueryparam value="#arguments.accountID#" cfsqltype="cf_sql_varchar" />
						AND 'sstActive' = (SELECT systemcode FROM (SELECT systemCode,subscriptionUsageID FROM SwSubscriptionStatus
				                    INNER JOIN SwType ON SwSubscriptionStatus.subscriptionStatusTypeID = SwType.typeID
				                    WHERE SwSubscriptionStatus.effectiveDateTime <= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp" />
				                    ORDER BY changeDateTime DESC)
									WHERE subscriptionUsageID = su.subscriptionUsageID
				                    AND rownum <= 1)
				</cfquery>
		<cfelse>
				<cfquery name="getpg">
					SELECT DISTINCT subpg.priceGroupID
					FROM SwSubsUsageBenefitAccount suba
					INNER JOIN SwSubsUsageBenefit sub ON suba.subscriptionUsageBenefitID = sub.subscriptionUsageBenefitID
					INNER JOIN SwSubsUsageBenefitPriceGroup subpg ON sub.subscriptionUsageBenefitID = subpg.subscriptionUsageBenefitID
					INNER JOIN SwSubsUsage su ON sub.subscriptionUsageID = su.subscriptionUsageID
					WHERE (suba.endDateTime IS NULL
							OR suba.endDateTime > <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp" />)
						AND suba.accountID = <cfqueryparam value="#arguments.accountID#" cfsqltype="cf_sql_varchar" />
						AND 'sstActive' = (SELECT TOP 1 systemCode FROM SwSubscriptionStatus
									INNER JOIN SwType ON SwSubscriptionStatus.subscriptionStatusTypeID = SwType.typeID
									WHERE SwSubscriptionStatus.subscriptionUsageID = su.subscriptionUsageID
									AND SwSubscriptionStatus.effectiveDateTime <= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp" />
									ORDER BY changeDateTime DESC)
				</cfquery>
		</cfif>


		<cfif getpg.recordCount>
			<cfset var hql = "FROM SlatwallPriceGroup pg WHERE pg.priceGroupID IN (:priceGroupIDs) AND pg.activeFlag = :activeFlag" />

			<cfreturn ormExecuteQuery(hql, {priceGroupIDs=listToArray(valueList(getpg.priceGroupID)), activeFlag=1}) />
		</cfif>

		<cfreturn [] />

	</cffunction>

	<cffunction name="getPriceGroupRateBySkuID" returntype="any" access="public">
		<cfargument name="priceGroupID" type="string">
		<cfargument name="skuID" type="string">

		<!--- The results should be unique but previous code made me unsure if that is true. --->
		<cfset var results = ormExecuteQuery("SELECT pgr FROM SlatwallPriceGroupRate pgr INNER JOIN FETCH pgr.skus pgrs WHERE pgr.priceGroup.activeFlag=:activeFlag AND pgr.priceGroup.priceGroupID=:priceGroupID AND pgrs.skuID=:skuID", {activeFlag=1,priceGroupID=arguments.priceGroupID, skuID=arguments.skuID}, false, {maxresults=1} ) />

		<cfif arraylen(results)>
			<cfreturn results[1] >
		</cfif>

		<!--- return void if no results found --->
		<cfreturn>
	</cffunction>

	<cffunction name="getPriceGroupRateByProductID" returntype="any" access="public">
		<cfargument name="priceGroupID" type="string">
		<cfargument name="productID" type="string">

		<!--- The results should be unique but previous code made me unsure if that is true. --->
		<cfset var results = ormExecuteQuery("SELECT pgr FROM SlatwallPriceGroupRate pgr INNER JOIN FETCH pgr.products pgrp WHERE pgr.priceGroup.activeFlag=:activeFlag AND pgr.priceGroup.priceGroupID=:priceGroupID AND pgrp.productID=:productID", {activeFlag=1,priceGroupID=arguments.priceGroupID,productID=arguments.productID}, false, {maxresults=1}) />

		<cfif arraylen(results)>
			<cfreturn results[1] >
		</cfif>

		<!--- return void if no results found --->
		<cfreturn>
	</cffunction>

	<cffunction name="getPriceGroupRateByProductTypeID" returntype="any" access="public">
		<cfargument name="priceGroupID" type="string">
		<cfargument name="productTypeID" type="string">

		<!--- The results should be unique but previous code made me unsure if that is true. --->
		<cfset var results = ormExecuteQuery("SELECT pgr FROM SlatwallPriceGroupRate pgr INNER JOIN FETCH pgr.productTypes pgrpt WHERE pgr.priceGroup.activeFlag=:activeFlag AND pgr.priceGroup.priceGroupID=:priceGroupID AND pgrpt.productTypeID=:productTypeID", {activeFlag=1,priceGroupID=arguments.priceGroupID, productTypeID=arguments.productTypeID}, false, {maxresults=1}) />

		<cfif arraylen(results)>
			<cfreturn results[1] >
		</cfif>

		<cfreturn>
	</cffunction>

	<cffunction name="getGlobalPriceGroupRate" returntype="any" access="public">
		<cfargument name="priceGroupID" type="string">

		<!--- The results should be unique but previous code made me unsure if that is true. --->
		<cfset var results = ormExecuteQuery("SELECT pgr FROM SlatwallPriceGroupRate pgr WHERE pgr.priceGroup.activeFlag=:activeFlag AND pgr.priceGroup.priceGroupID=:priceGroupID AND pgr.globalFlag=1", {activeFlag=1,priceGroupID=arguments.priceGroupID}, false, {maxresults=1}) />

		<cfif arraylen(results)>
			<cfreturn results[1] >
		</cfif>

		<!--- return void if no results found --->
		<cfreturn>
	</cffunction>
</cfcomponent>



