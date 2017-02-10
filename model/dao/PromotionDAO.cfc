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
				spp.promotion sp
			WHERE
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

		<cfset var params = {
			promotionEffectiveDateTime = arguments.promotionEffectiveDateTime,
			activeFlag = 1
		} />

		<cfif arguments.qualificationRequired and len(noQualRequiredList)>
			<cfset params.noQualRequiredList = listToArray(noQualRequiredList) />
		</cfif>

		<cfif len(promotionCodeList)>
			<cfset params.promotionCodeList = listToArray(arguments.promotionCodeList) />
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

		<cfset var results = ormExecuteQuery("SELECT count(o.orderID) as count FROM
					SlatwallPromotionCode pc
				  INNER JOIN
				  	pc.orders o
				WHERE
					o.orderStatusType.systemCode != :ostNotPlaced
				  AND
				  	pc.promotionCodeID = :promotionCodeID
					", {
						ostNotPlaced = "ostNotPlaced",
						promotionCodeID = arguments.promotionCode.getPromotionCodeID()
				}) />

		<cfreturn results[1] />

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

		<cfreturn ormExecuteQuery("SELECT pc FROM SlatwallPromotionCode pc WHERE LOWER(pc.promotionCode) = ?", [lcase(arguments.promotionCode)], true) />
	</cffunction>

	<!--- function to return the calculated sales price based off of the price of the sku --->
	<cffunction name="getSalePricePromotionRewardsQuery">
		<cfargument name="productID" type="string">
		<cfargument name="currencyCode" type="string">

		<cfset var noQualifierCurrentActivePromotionPeriods = "" />
		<cfset var allDiscounts = "" />
		<cfset var noQualifierDiscounts = "" />
		<cfset var noQualifierPromotionPeriods = "" />
		<cfset var skuPrice = "" />
		<cfset var skuResults = "" />
		<cfset var timeNow = now() />
		<cfset var salePromotionPeriodIDs = "" />
		<cfset var defaultSkuCurrency=getHibachiScope().setting('skuCurrency') />

		<!--- get all of the Active Promotion Periods that don't have a qualifier --->
		<cfset noQualifierCurrentActivePromotionPeriods= getNoQualifierCurrentActivePromotionPeriods(timeNow) >

		<cfloop query="noQualifierCurrentActivePromotionPeriods">
			<cfset salePromotionPeriodIDs = listAppend(salePromotionPeriodIDs, noQualifierCurrentActivePromotionPeriods.promotionPeriodID) />
		</cfloop>

		<cfif !structKeyExists(arguments,'currencyCode')>
			<cfset arguments.currencyCode = "" />
		</cfif>

		<!--- get allDiscounts at the sku level --->
		<cfset allDiscounts = getAllDiscounts(arguments.productID, timenow,arguments.currencyCode)>

		<!--- join allDiscounts with noQualifierCurrentActivePromotionPeriods to get  only the active prices --->
		<cfset noQualifierDiscounts = getNoQualifierDiscounts(noQualifierCurrentActivePromotionPeriods, allDiscounts)>

		<!--- query to find the lowest salesPrice --->
		<cfquery name="skuPrice" dbtype="query">
			SELECT
				skuID,
				MIN(salePrice) as salePrice
			FROM
				noQualifierDiscounts
			GROUP BY
				skuID
		</cfquery>

		<!--- query to get all the data for the lowest Sales Price --->
		<cfquery name="skuResults" dbtype="query">
			SELECT
				noQualifierDiscounts.skuID,
				noQualifierDiscounts.originalPrice,
				noQualifierDiscounts.discountLevel,
				noQualifierDiscounts.salePriceDiscountType,
				noQualifierDiscounts.salePrice,
				noQualifierDiscounts.roundingRuleID,
				noQualifierDiscounts.salePriceExpirationDateTime,
				noQualifierDiscounts.promotionID
			FROM
				noQualifierDiscounts,
				skuPrice
			WHERE
				noQualifierDiscounts.skuID = skuPrice.skuID
			  and
			    noQualifierDiscounts.salePrice = skuPrice.salePrice
		</cfquery>

		<cfreturn skuResults />
	</cffunction>

	<!--- function to return the calculated sales price based off of the price of the order items sku price--->
	<cffunction name = "getOrderItemSalePricePromotionRewardsQuery">
		<cfargument name="orderItem" type="any">

		<cfset var noQualifierCurrentActivePromotionPeriods = "" />
		<cfset var allDiscounts = "" />
		<cfset var noQualifierDiscounts = "" />
		<cfset var noQualifierPromotionPeriods = "" />
		<cfset var timeNow = now() />
		<cfset var salePromotionPeriodIDs = "" />
		<cfset var orderItemDiscountsQuery = "" />
		<cfset var orderItemPrice = "" />
		<cfset var orderItemResults = "" />

		<!--- get all of the Active Promotion Periods that don't have a qualifier --->
		<cfset noQualifierCurrentActivePromotionPeriods = getNoQualifierCurrentActivePromotionPeriods(timeNow) >

		<cfloop query="noQualifierCurrentActivePromotionPeriods">
			<cfset salePromotionPeriodIDs = listAppend(salePromotionPeriodIDs, noQualifierCurrentActivePromotionPeriods.promotionPeriodID) />
		</cfloop>

		<!--- get allDiscounts at the sku level --->
		<cfset allDiscounts = getAllDiscounts(arguments.orderItem.getSku().getProduct().getProductID(), timenow,arguments.orderItem.getOrder().getCurrencyCode())>

		<!--- join allDiscounts with noQualifierCurrentActivePromotionPeriods to get  only the active prices --->
		<cfset noQualifierDiscounts = getNoQualifierDiscounts(noQualifierCurrentActivePromotionPeriods, allDiscounts)>

		<!--- Build a query to get the order Item information for a query of query --->
		<cfset var orderItemDataQuery = queryNew("orderItemID, skuPrice, skuID", "varchar, decimal, varchar")>
		<cfset queryAddRow(orderItemDataQuery, 1)>
		<cfset querySetCell(orderItemDataQuery, "orderItemID", #arguments.orderItem.getOrderItemID()#, 1 )>
		<cfset querySetCell(orderItemDataQuery, "skuPrice", #arguments.orderItem.getSkuPrice()#, 1 )>
		<cfset querySetCell(orderItemDataQuery, "skuID", #arguments.orderItem.getSku().getSkuID()#, 1 )>

		<!--- Query of Query to join noQualifierDiscounts with the orderItemDataQuery. It also recalculates salePrice based on the OrderItem Price --->
		<cfquery name="orderItemDiscountsQuery" dbtype="query">
			SELECT DISTINCT
				orderItemDataQuery.orderItemID,
				orderItemDataQuery.skuPrice as originalPrice,
				noQualifierDiscounts.discountLevel,
				noQualifierDiscounts.amount,
				noQualifierDiscounts.salePriceDiscountType,
				noQualifierDiscounts.salePrice,
				noQualifierDiscounts.roundingRuleID,
				noQualifierDiscounts.salePriceExpirationDateTime,
				noQualifierDiscounts.promotionPeriodID,
				noQualifierDiscounts.promotionID
			FROM
				noQualifierDiscounts, orderItemDataQuery
			WHERE
				orderItemDataQuery.skuID = noQualifierDiscounts.skuID
		</cfquery>

		<cfloop query="orderItemDiscountsQuery">
			<cfif orderItemDiscountsQuery.salePriceDiscountType EQ "amount">
				<cfset querySetCell(orderItemDiscountsQuery, "salePrice", orderItemDiscountsQuery.amount, orderItemDiscountsQuery.currentRow )  >
			<cfelseif orderItemDiscountsQuery.salePriceDiscountType EQ "amountOff">
				<cfset querySetCell(orderItemDiscountsQuery, "salePrice", getService('HibachiUtilityService').precisionCalculate(orderItemDiscountsQuery.originalPrice - orderItemDiscountsQuery.amount), orderItemDiscountsQuery.currentRow )>
			<cfelseif orderItemDiscountsQuery.salePriceDiscountType EQ "percentageOff" >
				<cfset querySetCell(orderItemDiscountsQuery, "salePrice", getService('HibachiUtilityService').precisionCalculate(orderItemDiscountsQuery.originalPrice - ( orderItemDiscountsQuery.originalPrice * (round(orderItemDiscountsQuery.amount / 100)*100)/100)), orderItemDiscountsQuery.currentRow )>
			</cfif>
		</cfloop>

		<!--- query to find the lowest salesPrice --->
		<cfquery name="orderItemPrice" dbtype="query">
			SELECT
				orderItemID,
				MIN(salePrice) as salePrice
			FROM
				orderItemDiscountsQuery
			GROUP BY
				orderItemID
		</cfquery>

		<!--- query to get all the data for the lowest Sales Price --->
		<cfquery name="orderItemResults" dbtype="query">
			SELECT
				orderItemDiscountsQuery.orderItemID,
				orderItemDiscountsQuery.originalPrice,
				orderItemDiscountsQuery.discountLevel,
				orderItemDiscountsQuery.salePriceDiscountType,
				orderItemDiscountsQuery.salePrice,
				orderItemDiscountsQuery.roundingRuleID,
				orderItemDiscountsQuery.salePriceExpirationDateTime,
				orderItemDiscountsQuery.promotionID
			FROM
				orderItemDiscountsQuery, orderItemPrice
			WHERE
				orderItemDiscountsQuery.orderItemID = orderItemPrice.orderItemID
			AND
			    orderItemDiscountsQuery.salePrice = orderItemPrice.salePrice
		</cfquery>

		<cfreturn orderItemResults >
	</cffunction>


	<!--- Function to get all Active Promotion Periods without qualifiers --->
	<cffunction name="getNoQualifierCurrentActivePromotionPeriods" returntype="any" access="public">
		<cfargument name="timeNow" type="date">

		<cfset var noQualifierCurrentActivePromotionPeriodQuery= "" />

		<cfquery name="noQualifierCurrentActivePromotionPeriodQuery">
			SELECT
				promotionPeriodID
			FROM
				SwPromotionPeriod
			  INNER JOIN
			  	SwPromotion on SwPromotionPeriod.promotionID = SwPromotion.promotionID
			WHERE
				(SwPromotionPeriod.startDateTime is null or SwPromotionPeriod.startDateTime <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#timeNow#">)
			  AND
			  	(SwPromotionPeriod.endDateTime is null or SwPromotionPeriod.endDateTime >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#timeNow#">)
			  AND
			  	SwPromotion.activeFlag = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
			  AND
			  	NOT EXISTS(SELECT promotionPeriodID FROM SwPromoQual WHERE SwPromoQual.promotionPeriodID = SwPromotionPeriod.promotionPeriodID)
			  AND
			  	NOT EXISTS(SELECT promotionID FROM SwPromotionCode WHERE SwPromotionCode.promotionID = SwPromotion.promotionID)
		</cfquery>

		<cfreturn noQualifierCurrentActivePromotionPeriodQuery>
	</cffunction>

      <!--- function to get all discount amount at the sku level --->
      <cffunction name="getAllDiscounts" returntype="any" access="public">
          <cfargument name="productID" type="string">
          <cfargument name="timeNow" type="date">
          <cfargument name="currencyCode" type="string">

          <cfset var defaultSkuCurrency=getHibachiScope().setting('skuCurrency') />
          <cfset var allDiscountsQuery = "" />
          <cfquery name="allDiscountsQuery">
              <cfif structKeyExists(arguments, "currencyCode") && len(arguments.currencyCode)>
              SELECT
              skuID,
              originalPrice,
              discountLevel,
              salePriceDiscountType,
              CAST(CASE salePriceDiscountType
                  WHEN 'percentageOff' THEN originalPrice - (originalPrice * (discountAmount / 100))
                  WHEN 'amount' THEN discountAmount
                  WHEN 'amountOff' THEN (originalPrice - discountAmount)
              END as DECIMAL(19,2)) as salePrice,
              discountAmount as amount,
              roundingRuleID,
              salePriceExpirationDateTime,
              promotionPeriodID,
              promotionID
              FROM (
                  SELECT combinedPromotionLevels.skuID,
                      CASE
                          WHEN combinedPromotionLevels.skuCurrencyCode !=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.currencyCode#">
                              THEN COALESCE(skuCurrency.price,combinedPromotionLevels.originalPrice*skuConversionRate.conversionRate )
                          ELSE combinedPromotionLevels.originalPrice
                      END AS originalPrice,
                      CASE
                          WHEN combinedPromotionLevels.prCurrencyCode !=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.currencyCode#">  AND combinedPromotionLevels.salePriceDiscountType !='percentageOff'
                              THEN COALESCE(prCurrency.amount,combinedPromotionLevels.discountAmount*prConversionRate.conversionRate )
                          ELSE combinedPromotionLevels.discountAmount
                      END AS discountAmount,
                      combinedPromotionLevels.discountLevel,
                      combinedPromotionLevels.salePriceDiscountType,
                      combinedPromotionLevels.roundingRuleID,
                      combinedPromotionLevels.salePriceExpirationDateTime,
                      combinedPromotionLevels.promotionPeriodID,
                      combinedPromotionLevels.promotionID
              FROM (
              </cfif>
              <!---Start: Original query--->
              SELECT
                  SwSku.skuID as skuID,
                  SwSku.price as originalPrice,
                  'sku' as discountLevel,
                  prSku.amount,
                  prSku.amountType as salePriceDiscountType,
                  round(CASE prSku.amountType
                      WHEN 'amount' THEN prSku.amount
                      WHEN 'amountOff' THEN SwSku.price - prSku.amount
                      WHEN 'percentageOff' THEN SwSku.price - (SwSku.price * (prSku.amount / 100))
                  END * 100,0)/100 as salePrice,
                  prSku.roundingRuleID as roundingRuleID,
                  ppSku.endDateTime as salePriceExpirationDateTime,
                  ppSku.promotionPeriodID as promotionPeriodID,
                  ppSku.promotionID as promotionID,
                  prSku.promotionRewardID as promotionRewardID,
                  prSku.amount as discountAmount,
                  COALESCE(SwSku.currencyCode,'#defaultSkuCurrency#') as skuCurrencyCode,
                  COALESCE(prSku.currencyCode,'#defaultSkuCurrency#') as prCurrencyCode
              FROM
                  SwSku
                INNER JOIN
                  SwPromoRewardSku on SwPromoRewardSku.skuID = SwSku.skuID
                INNER JOIN
                  SwPromoReward prSku on prSku.promotionRewardID = SwPromoRewardSku.promotionRewardID
                INNER JOIN
                  SwPromotionPeriod ppSku on ppSku.promotionPeriodID = prSku.promotionPeriodID
              WHERE
                  (ppSku.startDateTime is null or ppSku.startDateTime <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#timeNow#">)
                AND
                  (ppSku.endDateTime is null or ppSku.endDateTime >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#timeNow#">)
              <cfif structKeyExists(arguments, "productID")>
                AND
                  SwSku.productID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productID#">
              </cfif>
            UNION
              SELECT
                  SwSku.skuID as skuID,
                  SwSku.price as originalPrice,
                  'product' as discountLevel,
                  prProduct.amount,
                  prProduct.amountType as salePriceDiscountType,
                  ROUND(CASE prProduct.amountType
                      WHEN 'amount' THEN prProduct.amount
                      WHEN 'amountOff' THEN SwSku.price - prProduct.amount
                      WHEN 'percentageOff' THEN SwSku.price - (SwSku.price * (prProduct.amount / 100))
                  END * 100,0)/100 as salePrice,
                  prProduct.roundingRuleID as roundingRuleID,
                  ppProduct.endDateTime as salePriceExpirationDateTime,
                  ppProduct.promotionPeriodID as promotionPeriodID,
                  ppProduct.promotionID as promotionID,
                  prProduct.promotionRewardID as promotionRewardID,
                  prProduct.amount as discountAmount,
                  COALESCE(SwSku.currencyCode,'#defaultSkuCurrency#') as skuCurrencyCode,
                  COALESCE(prProduct.currencyCode,'#defaultSkuCurrency#') as prCurrencyCode
              FROM
                  SwSku
                INNER JOIN
                  SwPromoRewardProduct on SwPromoRewardProduct.productID = SwSku.productID
                INNER JOIN
                  SwPromoReward prProduct on prProduct.promotionRewardID = SwPromoRewardProduct.promotionRewardID
                INNER JOIN
                  SwPromotionPeriod ppProduct on ppProduct.promotionPeriodID = prProduct.promotionPeriodID
              WHERE
                  (ppProduct.startDateTime is null or ppProduct.startDateTime <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#timeNow#">)
                AND
                  (ppProduct.endDateTime is null or ppProduct.endDateTime >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#timeNow#">)
              <cfif structKeyExists(arguments, "productID")>
                AND
                  SwSku.productID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productID#">
              </cfif>
            UNION
              SELECT
                  SwSku.skuID as skuID,
                  SwSku.price as originalPrice,
                  'brand' as discountLevel,
                  prBrand.amount,
                  prBrand.amountType as salePriceDiscountType,
                  ROUND(CASE prBrand.amountType
                      WHEN 'amount' THEN prBrand.amount
                      WHEN 'amountOff' THEN SwSku.price - prBrand.amount
                      WHEN 'percentageOff' THEN SwSku.price - (SwSku.price * (prBrand.amount / 100))
                  END * 100,0)/100 as salePrice,
                  prBrand.roundingRuleID as roundingRuleID,
                  ppBrand.endDateTime as salePriceExpirationDateTime,
                  ppBrand.promotionPeriodID as promotionPeriodID,
                  ppBrand.promotionID as promotionID,
                  prBrand.promotionRewardID as promotionRewardID,
                  prBrand.amount as discountAmount,
                  COALESCE(SwSku.currencyCode,'#defaultSkuCurrency#') as skuCurrencyCode,
                  COALESCE(prBrand.currencyCode,'#defaultSkuCurrency#') as prCurrencyCode
              FROM
                  SwSku
                INNER JOIN
                  SwProduct on SwProduct.productID = SwSku.productID
                INNER JOIN
                  SwPromoRewardBrand on SwPromoRewardBrand.brandID = SwProduct.brandID
                INNER JOIN
                  SwPromoReward prBrand on prBrand.promotionRewardID = SwPromoRewardBrand.promotionRewardID
                INNER JOIN
                  SwPromotionPeriod ppBrand on ppBrand.promotionPeriodID = prBrand.promotionPeriodID
              WHERE
                  (ppBrand.startDateTime is null or ppBrand.startDateTime <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#timeNow#">)
                AND
                  (ppBrand.endDateTime is null or ppBrand.endDateTime >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#timeNow#">)
              <cfif structKeyExists(arguments, "productID")>
                AND
                  SwSku.productID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productID#">
              </cfif>
            UNION
              SELECT
                  SwSku.skuID as skuID,
                  SwSku.price as originalPrice,
                  'option' as discountLevel,
                  prOption.amount,
                  prOption.amountType as salePriceDiscountType,
                  ROUND(CASE prOption.amountType
                      WHEN 'amount' THEN prOption.amount
                      WHEN 'amountOff' THEN SwSku.price - prOption.amount
                      WHEN 'percentageOff' THEN SwSku.price - (SwSku.price * (prOption.amount / 100))
                  END * 100,0)/100 as salePrice,
                  prOption.roundingRuleID as roundingRuleID,
                  ppOption.endDateTime as salePriceExpirationDateTime,
                  ppOption.promotionPeriodID as promotionPeriodID,
                  ppOption.promotionID as promotionID,
                  prOption.promotionRewardID as promotionRewardID,
                  prOption.amount as discountAmount,
                  COALESCE(SwSku.currencyCode,'#defaultSkuCurrency#') as skuCurrencyCode,
                  COALESCE(prOption.currencyCode,'#defaultSkuCurrency#') as prCurrencyCode
              FROM
                  SwSku
                INNER JOIN
                  SwSkuOption on SwSkuOption.skuID = SwSku.skuID
                INNER JOIN
                  SwPromoRewardOption on SwPromoRewardOption.optionID = SwSkuOption.optionID
                INNER JOIN
                  SwPromoReward prOption on prOption.promotionRewardID = SwPromoRewardOption.promotionRewardID
                INNER JOIN
                  SwPromotionPeriod ppOption on ppOption.promotionPeriodID = prOption.promotionPeriodID
              WHERE
                  (ppOption.startDateTime is null or ppOption.startDateTime <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#timeNow#">)
                AND
                  (ppOption.endDateTime is null or ppOption.endDateTime >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#timeNow#">)
              <cfif structKeyExists(arguments, "productID")>
                AND
                  SwSku.productID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productID#">
              </cfif>
            UNION
              SELECT
                  SwSku.skuID as skuID,
                  SwSku.price as originalPrice,
                  'productType' as discountLevel,
                  prProductType.amount,
                  prProductType.amountType as salePriceDiscountType,
                  ROUND(CASE prProductType.amountType
                      WHEN 'amount' THEN prProductType.amount
                      WHEN 'amountOff' THEN SwSku.price - prProductType.amount
                      WHEN 'percentageOff' THEN SwSku.price - (SwSku.price * (prProductType.amount / 100))
                  END * 100,0)/100 as salePrice,
                  prProductType.roundingRuleID as roundingRuleID,
                  ppProductType.endDateTime as salePriceExpirationDateTime,
                  ppProductType.promotionPeriodID as promotionPeriodID,
                  ppProductType.promotionID as promotionID,
                  prProductType.promotionRewardID as promotionRewardID,
                  prProductType.amount as discountAmount,
                  COALESCE(SwSku.currencyCode,'#defaultSkuCurrency#') as skuCurrencyCode,
                  COALESCE(prProductType.currencyCode,'#defaultSkuCurrency#') as prCurrencyCode
              FROM
                  SwSku
                INNER JOIN
                  SwProduct on SwProduct.productID = SwSku.productID
                INNER JOIN
                  SwProductType on SwProduct.productTypeID = SwProductType.productTypeID
                INNER JOIN
                <cfif getApplicationValue("databaseType") eq "MySQL">
                  SwPromoRewardProductType on SwProductType.productTypeIDPath LIKE concat('%', SwPromoRewardProductType.productTypeID, '%')
                <cfelseif getApplicationValue("databaseType") eq "Oracle10g">
                  SwPromoRewardProductType on SwProductType.productTypeIDPath LIKE ('%' || SwPromoRewardProductType.productTypeID || '%')
                <cfelse>
                  SwPromoRewardProductType on SwProductType.productTypeIDPath LIKE ('%' + SwPromoRewardProductType.productTypeID + '%')
                </cfif>
                INNER JOIN
                  SwPromoReward prProductType on prProductType.promotionRewardID = SwPromoRewardProductType.promotionRewardID
                INNER JOIN
                  SwPromotionPeriod ppProductType on ppProductType.promotionPeriodID = prProductType.promotionPeriodID
              WHERE
                  (ppProductType.startDateTime is null or ppProductType.startDateTime <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#timeNow#">)
                AND
                  (ppProductType.endDateTime is null or ppProductType.endDateTime >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#timeNow#">)
              <cfif structKeyExists(arguments, "productID")>
                AND
                  SwSku.productID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productID#">
              </cfif>
            UNION
              SELECT
                  SwSku.skuID as skuID,
                  SwSku.price as originalPrice,
                  'global' as discountLevel,
                  prGlobal.amount,
                  prGlobal.amountType as salePriceDiscountType,
                  ROUND(CASE prGlobal.amountType
                      WHEN 'amount' THEN prGlobal.amount
                      WHEN 'amountOff' THEN SwSku.price - prGlobal.amount
                      WHEN 'percentageOff' THEN SwSku.price - (SwSku.price * (prGlobal.amount / 100))
                  END * 100,0)/100 as salePrice,
                  prGlobal.roundingRuleID as roundingRuleID,
                  ppGlobal.endDateTime as salePriceExpirationDateTime,
                  ppGlobal.promotionPeriodID as promotionPeriodID,
                  ppGlobal.promotionID as promotionID,
                  prGlobal.promotionRewardID as promotionRewardID,
                  prGlobal.amount as discountAmount,
                  COALESCE(SwSku.currencyCode,'#defaultSkuCurrency#') as skuCurrencyCode,
                  COALESCE(prGlobal.currencyCode,'#defaultSkuCurrency#') as prCurrencyCode
              FROM
                  SwSku
                INNER JOIN
                  SwProduct on SwProduct.productID = SwSku.productID
                CROSS JOIN
                  SwPromoReward prGlobal
                INNER JOIN
                  SwPromotionPeriod ppGlobal on prGlobal.promotionPeriodID = ppGlobal.promotionPeriodID
              WHERE
                  prGlobal.rewardType IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="merchandise,subscription,contentAccess" list="true">)
                AND
                  NOT EXISTS(SELECT promotionRewardID FROM SwPromoRewardSku WHERE SwPromoRewardSku.promotionRewardID = prGlobal.promotionRewardID)
                AND
                  NOT EXISTS(SELECT promotionRewardID FROM SwPromoRewardProduct WHERE SwPromoRewardProduct.promotionRewardID = prGlobal.promotionRewardID)
                AND
                  NOT EXISTS(SELECT promotionRewardID FROM SwPromoRewardBrand WHERE SwPromoRewardBrand.promotionRewardID = prGlobal.promotionRewardID)
                AND
                  NOT EXISTS(SELECT promotionRewardID FROM SwPromoRewardOption WHERE SwPromoRewardOption.promotionRewardID = prGlobal.promotionRewardID)
                AND
                  NOT EXISTS(SELECT promotionRewardID FROM SwPromoRewardProductType WHERE SwPromoRewardProductType.promotionRewardID = prGlobal.promotionRewardID)
                AND
                  (ppGlobal.startDateTime is null or ppGlobal.startDateTime <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#timeNow#">)
                AND
                  (ppGlobal.endDateTime is null or ppGlobal.endDateTime >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#timeNow#">)
              <cfif structKeyExists(arguments, "productID")>
                AND
                  SwSku.productID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productID#">
              </cfif>
              <!---END: Original query--->

              <cfif structKeyExists(arguments, "currencyCode") && len(arguments.currencyCode)>

               ) combinedPromotionLevels
                  LEFT JOIN SwSkuCurrency skuCurrency
                      ON combinedPromotionLevels.skuCurrencyCode !=<cfqueryparam cfsqltype="cf_sql_string" value="#arguments.currencyCode#">
                      AND combinedPromotionLevels.skuID=skuCurrency.skuID
                      AND skuCurrency.currencyCode=<cfqueryparam cfsqltype="cf_sql_string" value="#arguments.currencyCode#">
                  LEFT JOIN SwPromotionRewardCurrency prCurrency
                      ON combinedPromotionLevels.prCurrencyCode !=<cfqueryparam cfsqltype="cf_sql_string" value="#arguments.currencyCode#">
                      AND combinedPromotionLevels.promotionRewardID=prCurrency.promotionRewardID
                      AND prCurrency.currencyCode=<cfqueryparam cfsqltype="cf_sql_string" value="#arguments.currencyCode#">
                  LEFT JOIN (
                      SELECT cr1.currencyCode, cr1.conversionRate
                      FROM SwCurrencyRate cr1
                          LEFT JOIN SwCurrencyRate cr2
                              ON (cr1.conversionCurrencyCode=cr2.conversionCurrencyCode
                                  AND cr1.currencyCode=cr2.currencyCode
                                  AND cr1.effectiveStartDateTime < cr2.effectiveStartDateTime
                                  AND cr1.effectiveStartDateTime < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#timeNow#">
                                  AND cr2.effectiveStartDateTime < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#timeNow#">
                              )
                              WHERE cr2.currencyRateID IS NULL AND cr1.effectiveStartDateTime < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#timeNow#">
                              AND cr1.conversionCurrencyCode=<cfqueryparam cfsqltype="cf_sql_string" value="#arguments.currencyCode#">
                      ) skuConversionRate ON skuCurrencyCode=skuConversionRate.currencyCode
                  LEFT JOIN (
                      SELECT cr1.currencyCode, cr1.conversionCurrencyCode, cr1.conversionRate
                      FROM SwCurrencyRate cr1
                          LEFT JOIN SwCurrencyRate cr2
                              ON (cr1.conversionCurrencyCode=cr2.conversionCurrencyCode
                                  AND cr1.currencyCode=cr2.currencyCode
                                  AND cr1.effectiveStartDateTime < cr2.effectiveStartDateTime
                                  AND cr1.effectiveStartDateTime < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#timeNow#">
                                  AND cr2.effectiveStartDateTime < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#timeNow#">
                              )
                              WHERE cr2.currencyRateID IS NULL AND cr1.effectiveStartDateTime < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#timeNow#">

                      ) prConversionRate
                      ON prConversionRate.conversionCurrencyCode = <cfqueryparam cfsqltype="cf_sql_string" value="#arguments.currencyCode#">
                          AND combinedPromotionLevels.prCurrencyCode=prConversionRate.currencyCode
                  ) convertedDiscounts WHERE
                      CASE salePriceDiscountType
                          WHEN 'percentageOff' THEN (round((originalPrice - (originalPrice * (discountAmount / 100)))*100, 0)/100)
                          WHEN 'amount' THEN (round(discountAmount * 100, 0) / 100)
                          WHEN 'amountOff' THEN (round((originalPrice - discountAmount) * 100, 0) / 100)
                      END IS NOT NULL
              </cfif>
          </cfquery>
          <cfreturn allDiscountsQuery />
      </cffunction>

	<!--- function to only return price of the active noQualifer Discount Prices --->
	<cffunction name="getNoQualifierDiscounts" returntype="any" access="public">
		<cfargument name="noQualifierCurrentActivePromotionPeriodsQuery" type="any">
		<cfargument name="allDiscountsQuery" type="any">

		<cfset var noQualifierDiscountsQuery = "" >

		<cfquery name="noQualifierDiscountsQuery" dbtype="query">
			SELECT DISTINCT
				allDiscountsQuery.skuID,
				allDiscountsQuery.originalPrice,
				allDiscountsQuery.discountLevel,
				allDiscountsQuery.amount,
				allDiscountsQuery.salePriceDiscountType,
				allDiscountsQuery.salePrice,
				allDiscountsQuery.roundingRuleID,
				allDiscountsQuery.salePriceExpirationDateTime,
				allDiscountsQuery.promotionPeriodID,
				allDiscountsQuery.promotionID
			FROM
				noQualifierCurrentActivePromotionPeriodsQuery, allDiscountsQuery
			WHERE
				allDiscountsQuery.promotionPeriodID = noQualifierCurrentActivePromotionPeriodsQuery.promotionPeriodID

		</cfquery>

		<cfreturn noQualifierDiscountsQuery >
	</cffunction>

</cfcomponent>
