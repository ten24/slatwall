<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC

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
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

--->
<cfcomponent extends="BaseDAO">
	
	
	<cffunction name="getAccountSubscriptionPriceGroups">
		<cfargument name="accountID" type="string">
		
		<cfset var getpg = "" />
		<!--- can't figure out top 1 hql so, doing query: Sumit --->
		<cfif getDBType() eq "mySql">
				<cfquery name="getpg">
					SELECT DISTINCT subpg.priceGroupID
					FROM SlatwallSubscriptionUsageBenefitAccount suba
					INNER JOIN SlatwallSubscriptionUsageBenefit sub ON suba.subscriptionUsageBenefitID = sub.subscriptionUsageBenefitID
					INNER JOIN SlatwallSubscriptionUsageBenefitPriceGroup subpg ON sub.subscriptionUsageBenefitID = subpg.subscriptionUsageBenefitID
					INNER JOIN SlatwallSubscriptionUsage su ON sub.subscriptionUsageID = su.subscriptionUsageID
					WHERE (suba.endDateTime IS NULL
							OR suba.endDateTime > <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp" />)
						AND suba.accountID = <cfqueryparam value="#arguments.accountID#" cfsqltype="cf_sql_varchar" />
						AND 'sstActive' = (SELECT systemCode FROM SlatwallSubscriptionStatus 
									INNER JOIN SlatwallType ON SlatwallSubscriptionStatus.subscriptionStatusTypeID = SlatwallType.typeID
									WHERE SlatwallSubscriptionStatus.subscriptionUsageID = su.subscriptionUsageID
									AND SlatwallSubscriptionStatus.effectiveDateTime <= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp" />
									ORDER BY changeDateTime DESC LIMIT 1)
				</cfquery>
		<cfelse>
				<cfquery name="getpg">
					SELECT DISTINCT subpg.priceGroupID
					FROM SlatwallSubscriptionUsageBenefitAccount suba
					INNER JOIN SlatwallSubscriptionUsageBenefit sub ON suba.subscriptionUsageBenefitID = sub.subscriptionUsageBenefitID
					INNER JOIN SlatwallSubscriptionUsageBenefitPriceGroup subpg ON sub.subscriptionUsageBenefitID = subpg.subscriptionUsageBenefitID
					INNER JOIN SlatwallSubscriptionUsage su ON sub.subscriptionUsageID = su.subscriptionUsageID
					WHERE (suba.endDateTime IS NULL
							OR suba.endDateTime > <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp" />)
						AND suba.accountID = <cfqueryparam value="#arguments.accountID#" cfsqltype="cf_sql_varchar" />
						AND 'sstActive' = (SELECT TOP 1 systemCode FROM SlatwallSubscriptionStatus 
									INNER JOIN SlatwallType ON SlatwallSubscriptionStatus.subscriptionStatusTypeID = SlatwallType.typeID
									WHERE SlatwallSubscriptionStatus.subscriptionUsageID = su.subscriptionUsageID
									AND SlatwallSubscriptionStatus.effectiveDateTime <= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp" />
									ORDER BY changeDateTime DESC)
				</cfquery>
		</cfif>
		
		
		<cfif getpg.recordCount>
			<cfset var hql = "FROM SlatwallPriceGroup WHERE priceGroupID IN (:priceGroupIDs)" />
			
			<cfreturn ormExecuteQuery(hql, {priceGroupIDs=listToArray(valueList(getpg.priceGroupID))}) />
		</cfif>
		
		<cfreturn [] />
		
	</cffunction>
</cfcomponent>


