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
	
	<cffunction name="getSalePricePromotionRewardsQuery">
		<cfargument name="productID" type="string">
		<cfargument name="currencyCode" type="string">

		<cfset var allDiscounts = "" />
		<cfset var noQualifierDiscounts = "" />
		<cfset var noQualifierPromotionPeriods = "" />
		<cfset var skuPrice = "" />
		<cfset var skuResults = "" />
		<cfset var timeNow = now() />
		<cfset var salePromotionPeriodIDs = "" />
		
		<cfquery name="local.noQualifierCurrentActivePromotionPeriods">
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
		
		<cfloop query="noQualifierCurrentActivePromotionPeriods">
			<cfset salePromotionPeriodIDs = listAppend(salePromotionPeriodIDs, noQualifierCurrentActivePromotionPeriods.promotionPeriodID) />
		</cfloop>
		
		<cfquery name="allDiscounts">
		SELECT
			skuID,
			originalPrice,
			discountLevel,
			salePriceDiscountType,
			CASE salePriceDiscountType
				WHEN 'amount' THEN discountAmount
				WHEN 'amountOff' THEN originalPrice - discountAmount
				WHEN 'percentageOff' THEN originalPrice - (originalPrice * (discountAmount / 100))
			END AS salePrice,
			roundingRuleID,
			salePriceExpirationDateTime,
			promotionPeriodID,
			promotionID
			FROM (
				SELECT
					SwSku.skuID AS skuID,
					CASE 
						WHEN skuCurrency.price IS NOT NULL THEN skuCurrency.price
						WHEN  skuCurrencyRate.conversionRate IS NOT NULL THEN CAST(skuCurrencyRate.conversionRate*SwSku.priceAS DECIMAL(19,2)) /*Cast required as conversionRate is currently a float*/ 
						ELSE SwSku.price
					END AS originalPrice,
					'sku' AS discountLevel,
					prSku.amountType AS salePriceDiscountType,
					CASE prSku.amountType 
						WHEN 'percentageOff' THEN prSku.amount
						ELSE
							CASE 
								WHEN prCurrency.amount IS NOT NULL THEN prCurrency.amount
								WHEN  prCurrencyRate.conversionRate IS NOT NULL THEN CAST(prCurrencyRate.conversionRate*prSku.amount AS DECIMAL(19,2))  /*Cast required as conversionRate is currently a float*/ 
								ELSE prSku.amount
							END
					END  AS discountAmount,
					prSku.roundingRuleID AS roundingRuleID,
					ppSku.endDateTime AS salePriceExpirationDateTime,
					ppSku.promotionPeriodID AS promotionPeriodID,
					ppSku.promotionID AS promotionID
				FROM
					SwSku
				  INNER JOIN
				  	SwPromoRewardSku ON SwPromoRewardSku.skuID = SwSku.skuID
				  INNER JOIN
				  	SwPromoReward prSku ON prSku.promotionRewardID = SwPromoRewardSku.promotionRewardID
				  INNER JOIN
				    SwPromotionPeriod ppSku ON ppSku.promotionPeriodID = prSku.promotionPeriodID
				  LEFT JOIN
					SwSkuCurrency skuCurrency ON SwSku.skuID=skuCurrency.skuID 
						AND skuCurrency.currencyCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.currencyCode#">	
				LEFT JOIN
					SwCurrencyRate skuCurrencyRate ON skuCurrencyRate.conversionCurrencyCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.currencyCode#">
						AND skuCurrencyRate.currencyCode = SwSku.currencyCode
						/* TODO: need to add temporal component to this join to pick up only the currently active rate */
				  LEFT JOIN
				  	SwPromotionRewardCurrency prCurrency ON prSku.promotionRewardID=prCurrency.promotionRewardID
				  		AND prCurrency.currencyCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.currencyCode#">
				  LEFT JOIN
					SwCurrencyRate prCurrencyRate ON prCurrencyRate.conversionCurrencyCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.currencyCode#">
						AND prCurrencyRate.currencyCode = prSku.currencyCode
						/* TODO: need to add temporal component to this join to pick up only the currently active rate */
				WHERE
					(ppSku.startDateTime is null or ppSku.startDateTime <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#timeNow#">)
				  AND
				  	(ppSku.endDateTime is null or ppSku.endDateTime >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#timeNow#">)
				<cfif structKeyExists(arguments, "productID")>
				  AND
					SwSku.productID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productID#">	
				</cfif>

			/*For demo purposes - ignore all the unions below
			  UNION
				SELECT
					SwSku.skuID as skuID,
					CASE 
						WHEN SwSkuCurrency.price IS NOT NULL THEN SwSkuCurrency.price
						WHEN  SwCurrencyRate.conversionRate IS NOT NULL THEN SwCurrencyRate.conversionRate*SwSku.price 
						ELSE SwSku.price
					END AS	originalPrice,
					'product' as discountLevel,
					prProduct.amountType as salePriceDiscountType,
					prProduct.amount AS discountAmount,
					prProduct.roundingRuleID as roundingRuleID,
					ppProduct.endDateTime as salePriceExpirationDateTime,
					ppProduct.promotionPeriodID as promotionPeriodID,
					ppProduct.promotionID as promotionID
				FROM
					SwSku
				  INNER JOIN
				  	SwPromoRewardProduct on SwPromoRewardProduct.productID = SwSku.productID
				  INNER JOIN
				  	SwPromoReward prProduct on prProduct.promotionRewardID = SwPromoRewardProduct.promotionRewardID
				  INNER JOIN
				    SwPromotionPeriod ppProduct on ppProduct.promotionPeriodID = prProduct.promotionPeriodID
				  LEFT JOIN
					SwSkuCurrency ON SwSku.skuID=SwSkuCurrency.skuID AND SwSkuCurrency.currencyCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.currencyCode#">
				  LEFT JOIN
					SwCurrencyRate ON SwCurrencyRate.conversionCurrencyCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.currencyCode#"> 
						and SwCurrencyRate.currencyCode = SwSku.currencyCode 
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
					CASE 
						WHEN SwSkuCurrency.price IS NOT NULL THEN SwSkuCurrency.price
						WHEN  SwCurrencyRate.conversionRate IS NOT NULL THEN SwCurrencyRate.conversionRate*SwSku.price 
						ELSE SwSku.price
					END AS	originalPrice,
					'brand' as discountLevel,
					prBrand.amountType as salePriceDiscountType,
					prBrand.amount AS discountAmount,
					prBrand.roundingRuleID as roundingRuleID,
					ppBrand.endDateTime as salePriceExpirationDateTime,
					ppBrand.promotionPeriodID as promotionPeriodID,
					ppBrand.promotionID as promotionID
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
				  LEFT JOIN
					SwSkuCurrency ON SwSku.skuID=SwSkuCurrency.skuID AND SwSkuCurrency.currencyCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.currencyCode#">
				  LEFT JOIN
					SwCurrencyRate ON SwCurrencyRate.conversionCurrencyCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.currencyCode#"> 
						and SwCurrencyRate.currencyCode = SwSku.currencyCode
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
					CASE 
						WHEN SwSkuCurrency.price IS NOT NULL THEN SwSkuCurrency.price
						WHEN  SwCurrencyRate.conversionRate IS NOT NULL THEN SwCurrencyRate.conversionRate*SwSku.price 
						ELSE SwSku.price
					END AS	originalPrice,
					'option' as discountLevel,
					prOption.amountType as salePriceDiscountType,
					prOption.amount AS discountAmount,
					prOption.roundingRuleID as roundingRuleID,
					ppOption.endDateTime as salePriceExpirationDateTime,
					ppOption.promotionPeriodID as promotionPeriodID,
					ppOption.promotionID as promotionID
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
				  LEFT JOIN
					SwSkuCurrency ON SwSku.skuID=SwSkuCurrency.skuID AND SwSkuCurrency.currencyCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.currencyCode#">
				  LEFT JOIN
					SwCurrencyRate ON SwCurrencyRate.conversionCurrencyCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.currencyCode#"> 
						and SwCurrencyRate.currencyCode = SwSku.currencyCode 
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
					CASE 
						WHEN SwSkuCurrency.price IS NOT NULL THEN SwSkuCurrency.price
						WHEN  SwCurrencyRate.conversionRate IS NOT NULL THEN SwCurrencyRate.conversionRate*SwSku.price 
						ELSE SwSku.price
					END AS	originalPrice,
					'productType' as discountLevel,
					prProductType.amountType as salePriceDiscountType,
					prProductType.amount AS discountAmount,
					prProductType.roundingRuleID as roundingRuleID,
					ppProductType.endDateTime as salePriceExpirationDateTime,
					ppProductType.promotionPeriodID as promotionPeriodID,
					ppProductType.promotionID as promotionID
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
				  LEFT JOIN
					SwSkuCurrency ON SwSku.skuID=SwSkuCurrency.skuID AND SwSkuCurrency.currencyCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.currencyCode#">
				  LEFT JOIN
					SwCurrencyRate ON SwCurrencyRate.conversionCurrencyCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.currencyCode#"> 
						and SwCurrencyRate.currencyCode = SwSku.currencyCode
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
					CASE 
						WHEN SwSkuCurrency.price IS NOT NULL THEN SwSkuCurrency.price
						WHEN  SwCurrencyRate.conversionRate IS NOT NULL THEN SwCurrencyRate.conversionRate*SwSku.price 
						ELSE SwSku.price
					END AS	originalPrice,
					'global' as discountLevel,
					prGlobal.amountType as salePriceDiscountType,
					prGlobal.amount AS discountAmount,
					prGlobal.roundingRuleID as roundingRuleID,
					ppGlobal.endDateTime as salePriceExpirationDateTime,
					ppGlobal.promotionPeriodID as promotionPeriodID,
					ppGlobal.promotionID as promotionID
				FROM
					SwSku
				  INNER JOIN
				  	SwProduct on SwProduct.productID = SwSku.productID
				  CROSS JOIN
					SwPromoReward prGlobal
				  INNER JOIN
				  	SwPromotionPeriod ppGlobal on prGlobal.promotionPeriodID = ppGlobal.promotionPeriodID
				  LEFT JOIN
					SwSkuCurrency ON SwSku.skuID=SwSkuCurrency.skuID AND SwSkuCurrency.currencyCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.currencyCode#">
				  LEFT JOIN
					SwCurrencyRate ON SwCurrencyRate.conversionCurrencyCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.currencyCode#"> 
						and SwCurrencyRate.currencyCode = SwSku.currencyCode
				WHERE
				  	prGlobal.rewardType IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="merchandise,subscription,contentAccess" list="true">)
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
				</cfif>*/
			) as combinedPromotionLevels
		</cfquery>
		
		<cfquery name="noQualifierDiscounts" dbtype="query">
			SELECT DISTINCT
				allDiscounts.skuID,
				allDiscounts.originalPrice,
				allDiscounts.discountLevel,
				allDiscounts.salePriceDiscountType,
				allDiscounts.salePrice,
				allDiscounts.roundingRuleID,
				allDiscounts.salePriceExpirationDateTime,
				allDiscounts.promotionPeriodID,
				allDiscounts.promotionID
			FROM
				allDiscounts, noQualifierCurrentActivePromotionPeriods
			WHERE
				allDiscounts.promotionPeriodID = noQualifierCurrentActivePromotionPeriods.promotionPeriodID
		</cfquery>
		
		<cfquery name="skuPrice" dbtype="query">
			SELECT
				skuID,
				MIN(salePrice) as salePrice
			FROM
				noQualifierDiscounts
			GROUP BY
				skuID
		</cfquery>
		
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
		
</cfcomponent>
