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

	<cffunction name="getActivePromotionRewards" returntype="Array" access="public">
		<cfargument name="rewardTypeList" required="true" type="string" />
		<cfargument name="promotionCodeList" required="true" type="string" />
		<cfargument name="qualificationRequired" type="boolean" default="false" />
		<cfargument name="promotionEffectiveDateTime" type="date" default="#now()#" />
		<cfargument name="excludeRewardsWithQualifiers" type="boolean" default="true">
		<cfargument name="site" type="any" />
		
		<cfif arguments.qualificationRequired >
			<cfset arguments.excludeRewardsWithQualifiers = false />
		</cfif>

		<cfset var noQualRequiredList = "" />
		<cfif listFindNoCase(arguments.rewardTypeList,"fulfillment")>
			<cfset noQualRequiredList = listAppend(noQualRequiredList, "fulfillment") />
		</cfif>
		<cfif listFindNoCase(arguments.rewardTypeList,"order")>
			<cfset noQualRequiredList = listAppend(noQualRequiredList, "order") />
		</cfif>

		<cfset var hql = "SELECT spr FROM
				SlatwallPromotionReward spr
			  INNER JOIN FETCH
				spr.promotionPeriod spp
			  INNER JOIN FETCH
				spp.promotion sp" />
				
		<cfif NOT isNull(arguments.site)>
			<cfset hql &=" LEFT JOIN FETCH
					sp.site s" />
		</cfif>
				
		<cfset hql &= " WHERE
				spr.rewardType IN (:rewardTypeList)
			  and
				(spp.startDateTime is null or spp.startDateTime < :promotionEffectiveDateTime)
			  and
				(spp.endDateTime is null or spp.endDateTime > :promotionEffectiveDateTime)
			  and
				sp.activeFlag = :activeFlag" />

		<!--- If this query is a qualificationRequired request --->
		<cfif arguments.qualificationRequired>

			<!--- Add some qualifications to the query --->
			<cfset hql &= " AND (" />
		<cfelseif arguments.excludeRewardsWithQualifiers >
			<cfset hql &= " AND NOT (" />
		</cfif>
		<cfif arguments.qualificationRequired OR arguments.excludeRewardsWithQualifiers >
			<!--- Either a promotionQualifier exists --->
			<cfset hql &= " EXISTS( SELECT pq.promotionQualifierID FROM SlatwallPromotionQualifier pq WHERE pq.promotionPeriod.promotionPeriodID = spp.promotionPeriodID )" />

			<!--- Or a promotion code exists --->
			<cfif len(promotionCodeList)>
				<cfset hql &= " OR EXISTS ( SELECT c.promotionCodeID FROM SlatwallPromotionCode c WHERE c.promotion.promotionID = sp.promotionID AND c.promotionCode IN (:promotionCodeList) AND (c.startDateTime is null or c.startDateTime < :promotionEffectiveDateTime) AND (c.endDateTime is null or c.endDateTime > :promotionEffectiveDateTime) )" />
			</cfif>

			<!--- Or we still want these to show up because they are order/fulfillment rewards --->
			<cfif len(noQualRequiredList)>
				<cfset hql &= " OR spr.rewardType IN (:noQualRequiredList)" />
			</cfif>

			<!--- Close out the qualifications aspect of the query --->
			<cfset hql &= " )" />
		
			
		</cfif>

		<!--- Regardless of if qualifications are required, we need to make sure that the promotion reward either doesn't need a promo code, or that the promo code used is ok --->
		<cfset hql &= " AND (" />

		<!--- Make sure that the there are no promotion codes --->
		<cfset hql &= " NOT EXISTS ( SELECT c.promotionCodeID FROM SlatwallPromotionCode c WHERE c.promotion.promotionID = sp.promotionID )" />

		<!--- Or if there are promotion codes then we have passed that pomotion code in --->
		<cfif len(promotionCodeList)>
			<cfset hql &= " OR EXISTS ( SELECT c.promotionCodeID FROM SlatwallPromotionCode c WHERE c.promotion.promotionID = sp.promotionID AND c.promotionCode IN (:promotionCodeList) AND (c.startDateTime is null or c.startDateTime < :promotionEffectiveDateTime) AND (c.endDateTime is null or c.endDateTime > :promotionEffectiveDateTime) )" />
		</cfif>

		<!--- End additional where --->
		<cfset hql &= " )" />
		
		<cfif NOT isNull(arguments.site) >
			<cfset hql &= 'AND (s.siteID IS NULL OR s.siteID = :siteID)'>
		</cfif>

		<cfset var params = {
			promotionEffectiveDateTime = arguments.promotionEffectiveDateTime,
			activeFlag = 1
		} />

		<cfif (arguments.qualificationRequired OR arguments.excludeRewardsWithQualifiers) AND len(noQualRequiredList)>
			<cfset params.noQualRequiredList = listToArray(noQualRequiredList) />
		</cfif>

		<cfif len(promotionCodeList)>
			<cfset params.promotionCodeList = listToArray(arguments.promotionCodeList) />
		</cfif>
		
		<cfif NOT isNull(arguments.site) >
			<cfset params.siteID = arguments.site.getSiteID() />
		</cfif>

		<cfset params.rewardTypeList = listToArray(arguments.rewardTypeList) />

		<cfreturn ormExecuteQuery(hql, params) />
	</cffunction>

	<cffunction name="getPromotionPeriodUseCount" returntype="numeric" access="public">
		<cfargument name="promotionPeriod" required="true" type="any" />

		<cfset var hqlParams = {} />
		<cfset hqlParams.promotionID = arguments.promotionPeriod.getPromotion().getPromotionID() />
		<cfset hqlParams.ostNotPlaced = "ostNotPlaced" />

		<cfset var hql = "SELECT count(pa.promotionAppliedID) as count
				FROM
					SlatwallPromotionApplied pa
				  LEFT JOIN
				  	pa.promotion pap
				  LEFT JOIN
				  	pa.orderItem oi
				  LEFT JOIN
				  	oi.order oio
				  LEFT JOIN
				  	oio.orderStatusType oioost

				  LEFT JOIN
				  	pa.order o
				  LEFT JOIN
				  	o.orderStatusType oost

				  LEFT JOIN
				  	pa.orderFulfillment orderf
				  LEFT JOIN
				  	orderf.order ofo
				  LEFT JOIN
				  	ofo.orderStatusType ofoost
				WHERE
				  	(oioost.systemCode is null or oioost.systemCode != :ostNotPlaced)
				  and
				  	(oost.systemCode is null or oost.systemCode != :ostNotPlaced)
				  and
				  	(ofoost.systemCode is null or ofoost.systemCode != :ostNotPlaced)
				  and
					pap.promotionID = :promotionID" />

		<cfif not isNull(arguments.promotionPeriod.getStartDateTime())>
			<cfset hqlParams.promotionPeriodStartDateTime = arguments.promotionPeriod.getStartDateTime() />
			<cfset hql &= " and pa.createdDateTime > :promotionPeriodStartDateTime" />
		</cfif>
		<cfif not isNull(arguments.promotionPeriod.getStartDateTime())>
			<cfset hqlParams.promotionPeriodEndDateTime = arguments.promotionPeriod.getEndDateTime() />
			<cfset hql &= " and pa.createdDateTime < :promotionPeriodEndDateTime" />
		</cfif>

		<cfset var results = ormExecuteQuery(hql, hqlParams) />

		<cfreturn results[1] />
	</cffunction>

	<cffunction name="getPromotionPeriodAccountUseCount" returntype="numeric" access="public">
		<cfargument name="promotionPeriod" required="true" type="any" />
		<cfargument name="account" required="true" type="any" />

		<cfset var hqlParams = {} />
		<cfset hqlParams.promotionID = arguments.promotionPeriod.getPromotion().getPromotionID() />
		<cfset hqlParams.accountID = arguments.account.getAccountID() />
		<cfset hqlParams.ostNotPlaced = "ostNotPlaced" />

		<cfset var hql = "SELECT count(pa.promotionAppliedID) as count
				FROM
					SlatwallPromotionApplied pa
				  LEFT JOIN
				  	pa.orderItem oi
				  LEFT JOIN
				  	oi.order oio
				  LEFT JOIN
				  	oio.orderStatusType oioost
				  LEFT JOIN
				  	oio.account oioa

				  LEFT JOIN
				  	pa.order o
				  LEFT JOIN
				  	o.orderStatusType oost
				  LEFT JOIN
				  	o.account oa

				  LEFT JOIN
				  	pa.orderFulfillment orderf
				  LEFT JOIN
				  	orderf.order ofo
				  LEFT JOIN
				  	ofo.orderStatusType ofoost
				  LEFT JOIN
				  	ofo.account ofoa
				WHERE
					(
						oioa.accountID = :accountID
					  or
					  	oa.accountID = :accountID
					  or
					  	ofoa.accountID = :accountID
					)
				  and
					(oioost.systemCode is null or oioost.systemCode != :ostNotPlaced)
				  and
				  	(oost.systemCode is null or oost.systemCode != :ostNotPlaced)
				  and
				  	(ofoost.systemCode is null or ofoost.systemCode != :ostNotPlaced)
				  and
					pa.promotion.promotionID = :promotionID" />

		<cfif not isNull(arguments.promotionPeriod.getStartDateTime())>
			<cfset hqlParams.promotionPeriodStartDateTime = arguments.promotionPeriod.getStartDateTime() />
			<cfset hql &= " and pa.createdDateTime > :promotionPeriodStartDateTime" />
		</cfif>
		<cfif not isNull(arguments.promotionPeriod.getStartDateTime())>
			<cfset hqlParams.promotionPeriodEndDateTime = arguments.promotionPeriod.getEndDateTime() />
			<cfset hql &= " and pa.createdDateTime < :promotionPeriodEndDateTime" />
		</cfif>

		<cfset var results = ormExecuteQuery(hql, hqlParams) />

		<cfreturn results[1] />
	</cffunction>

	<cffunction name="getPromotionCodeUseCount" returntype="numeric" access="public">
		<cfargument name="promotionCode" required="true" type="any" />

		<cftransaction isolation="read_uncommitted">
			<cfquery name="local.results">
			SELECT count(swOrder.orderID) as count
			FROM SwOrderPromotionCode 
			INNER JOIN SwOrder on SwOrderPromotionCode.orderID=SwOrder.orderID AND SwOrder.orderNumber is not null
			WHERE SwOrderPromotionCode.promotionCodeID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.promotionCode.getPromotionCodeID()#">

			</cfquery>
		</cftransaction>

		<cfreturn local.results.count />

	</cffunction>

	<cffunction name="getPromotionCodeAccountUseCount" returntype="numeric" access="public">
		<cfargument name="promotionCode" required="true" type="any" />
		<cfargument name="account" required="true" type="any" />

		<cfset var results = ormExecuteQuery("SELECT count(o.orderID) as count
				FROM
					SlatwallPromotionCode pc
				  INNER JOIN
				  	pc.orders o
				WHERE
					o.orderStatusType.systemCode != :ostNotPlaced
				  AND
				  	pc.promotionCodeID = :promotionCodeID
				  AND
				  	o.account.accountID = :accountID
					", {
						ostNotPlaced = "ostNotPlaced",
						promotionCodeID = arguments.promotionCode.getPromotionCodeID(),
						accountID = arguments.account.getAccountID()
				}) />

		<cfreturn results[1] />
	</cffunction>

	<cffunction name="getPromotionCodeByPromotionCode" returntype="any" access="public">
		<cfargument name="promotionCode" required="true" type="string" />
		<cfset var comparisonValue =""/>
		<cfif getApplicationValue("databaseType") eq "Oracle10g">
			<cfset comparisonValue = "LOWER(pc.promotionCode)"/>
		<cfelse>
			<cfset comparisonValue = "pc.promotionCode"/>
		</cfif>
		<cfreturn ormExecuteQuery("SELECT pc FROM SlatwallPromotionCode pc WHERE #comparisonValue# = ?", [lcase(arguments.promotionCode)], true) />
	</cffunction>

	<cffunction name="deletePromotionAppliedToOrderItemByOrderID" returntype="void" access="public">
		<cfargument name="orderID" required="true" type="string" />
		<cfquery name="local.deletePromotionAppliedToOrderItemByOrderID">
			delete pa from swpromotionapplied pa 
			left join sworderitem oi on pa.orderItemID=oi.orderItemID
			left join sworder o on oi.orderID = o.orderID
			where o.orderID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.orderID#" />
		</cfquery> 
	</cffunction> 
	
	<cffunction name="getIncludedStackableRewardsIDListForPromotionReward" returntype="array" access="public">
		<cfargument name="promotionReward" required="true" type="any" />
		<cfargument name="includeReciprocalRecords" type="string" default="false" />
		<cfquery name="local.rewards">
			SELECT 
				linkedPromotionRewardID 
			FROM swpromorewardstackincl 
			WHERE 
				promotionRewardID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.promotionReward.getPromotionRewardID()#" />
			<cfif arguments.includeReciprocalRecords EQ true >
				UNION
				SELECT 
					promotionRewardID 
				FROM swpromorewardstackincl 
				WHERE 
					linkedPromotionRewardID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.promotionReward.getPromotionRewardID()#" />
			</cfif>
					
		</cfquery>
		<cfset local.rewardsArray = ValueArray(local.rewards,'linkedPromotionRewardID') />
		<cfreturn local.rewardsArray />
	</cffunction>
	
	<cffunction name="getExcludedStackableRewardsIDListForPromotionReward" returntype="array" access="public">
		<cfargument name="promotionReward" required="true" type="any" />
		<cfargument name="includeReciprocalRecords" type="string" default="false" />
		<cfquery name="local.rewards">
			SELECT 
				linkedPromotionRewardID 
			FROM swpromorewardstackexcl 
			WHERE 
				promotionRewardID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.promotionReward.getPromotionRewardID()#" />
			<cfif arguments.includeReciprocalRecords EQ true >
				UNION
				SELECT 
					promotionRewardID 
				FROM swpromorewardstackexcl 
				WHERE linkedPromotionRewardID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.promotionReward.getPromotionRewardID()#" />
			</cfif>
		</cfquery>
		<cfset local.rewardsArray = ValueArray(local.rewards,'linkedPromotionRewardID') />
		<cfreturn local.rewardsArray />
	</cffunction>
	
	<cffunction name="getAppliedPromotionsForOrderItemsByOrder" returntype="array" access="public">
		<cfargument name="order" required="true" type="any" />
		
		<cfquery name="local.orderItemIDs">
			SELECT orderItemID FROM sworderitem WHERE orderID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.order.getOrderID()#" />
		</cfquery>
		<cfset local.orderItemIDList = ValueList(local.orderItemIDs.orderItemID) />

		<cfquery name="local.appliedPromotions" dbtype="hql">
			SELECT 
				pa 
			FROM SlatwallPromotionApplied pa
			WHERE pa.orderItem.orderItemID IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.orderItemIDList#" list="true"/>)
		</cfquery>
		
		<cfreturn local.appliedPromotions />
	</cffunction>
	
	<cffunction name="deleteOrphanedAppliedPromotions" returntype="void" access="public">
		<cfquery name="local.deleteQuery">
			DELETE FROM swpromotionapplied 
			WHERE orderItemID IS NULL 
			AND orderID IS NULL
			AND orderFulfillmentID IS NULL
		</cfquery>
	</cffunction>
	
	<cffunction name="cloneAndInsertIncludedStackableRewards" returntype="void" access="public">
		<cfargument name="copyFromID" required="true" type="any" />
		<cfargument name="newPromoRewardID" required="true" type="any" />

		<cfquery>
		INSERT INTO swpromorewardstackincl (promotionRewardID, linkedPromotionRewardID)
		SELECT <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newPromoRewardID#" /> as promotionRewardID, linkedPromotionRewardID
		FROM swpromorewardstackincl 
		WHERE promotionRewardID IN(<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.copyFromID#" />)
		UNION
			SELECT promotionRewardID, linkedPromotionRewardID
			FROM swpromorewardstackincl 
			WHERE linkedPromotionRewardID IN(<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.copyFromID#" />);
		</cfquery>
		
		<cfquery>
			INSERT INTO swpromorewardstackexcl (promotionRewardID, linkedPromotionRewardID)
			SELECT promotionRewardID, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newPromoRewardID#" /> as linkedPromotionRewardID			
			FROM swpromorewardstackexcl 
			WHERE promotionRewardID IN(<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.copyFromID#" />)
			UNION
				SELECT promotionRewardID, linkedPromotionRewardID
				FROM swpromorewardstackexcl 
				WHERE linkedPromotionRewardID IN(<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.copyFromID#" />);
		</cfquery>
	</cffunction>
	
</cfcomponent>
