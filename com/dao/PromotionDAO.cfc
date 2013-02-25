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
	
	<cffunction name="getActivePromotionRewards" returntype="Array" access="public">
		<cfargument name="rewardTypeList" required="true" type="string" />
		<cfargument name="promotionCodeList" required="true" type="string" />
		<cfargument name="qualificationRequired" type="boolean" default="false" />
		
		<cfset var noQualRequiredList = "" />
		<cfif listFindNoCase(arguments.rewardTypeList,"fulfillment")>
			<cfset noQualRequiredList = listAppend(noQualRequiredList, "fulfillment") />
		</cfif>
		<cfif listFindNoCase(arguments.rewardTypeList,"order")>
			<cfset noQualRequiredList = listAppend(noQualRequiredList, "fulfillment") />
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
				spp.startDateTime < :now
			  and
				spp.endDateTime > :now
			  and
				sp.activeFlag = :activeFlag" />
		
		<cfif arguments.qualificationRequired>
			<cfset hql &= " AND (" />
			<cfset hql &= " EXISTS( SELECT pq.promotionQualifierID FROM SlatwallPromotionQualifier pq WHERE pq.promotionPeriod.promotionPeriodID = spp.promotionPeriodID )" />
			<cfif len(noQualRequiredList)>
				<cfset hql &= " OR spr.rewardType IN (:noQualRequiredList)" /> 
			</cfif>
			<cfset hql &= " )" />
		</cfif>
		
		<cfset hql &= " AND (" />
		<cfset hql &= " NOT EXISTS ( SELECT c.promotionCodeID FROM SlatwallPromotionCode c WHERE c.promotion.promotionID = sp.promotionID )" />
		<cfif len(promotionCodeList)>
			<cfset hql &= " OR EXISTS ( SELECT c.promotionCodeID FROM SlatwallPromotionCode c WHERE c.promotion.promotionID = sp.promotionID AND c.promotionCode IN (:promotionCodeList) AND (c.startDateTime is null or c.startDateTime < :now) AND (c.endDateTime is null or c.endDateTime > :now) )" />	
		</cfif>
		<cfset hql &= " )" />
			
		<cfset var params = {
			now = now(),
			activeFlag = 1
		} />
		
		<cfif arguments.qualificationRequired and len(noQualRequiredList)>
			<cfif structKeyExists(server, "railo")>
				<cfset params.noQualRequiredList = noQualRequiredList />
			<cfelse>
				<cfset params.noQualRequiredList = listToArray(noQualRequiredList) />		
			</cfif>
		</cfif>
		
		<cfif len(promotionCodeList)>
			<cfif structKeyExists(server, "railo")>
				<cfset params.promotionCodeList = arguments.promotionCodeList />
			<cfelse>
				<cfset params.promotionCodeList = listToArray(arguments.promotionCodeList) />		
			</cfif>
		</cfif>
		
		<cfif structKeyExists(server, "railo")>
			<cfset params.rewardTypeList = arguments.rewardTypeList />
		<cfelse>
			<cfset params.rewardTypeList = listToArray(arguments.rewardTypeList) />		
		</cfif>
		
		<cfreturn ormExecuteQuery(hql, params) />
	</cffunction>
	
	<cffunction name="getPromotionPeriodUseCount" returntype="numeric" access="public">
		<cfargument name="promotionPeriod" required="true" type="any" />
		
		<cfset var results = ormExecuteQuery("SELECT count(pa.promotionAppliedID) as count 
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
					pap.promotionID = :promotionID
				  and
					pa.createdDateTime > :promotionPeriodStartDateTime
				  and
				  	pa.createdDateTime < :promotionPeriodEndDateTime", {
					  
				promotionID = arguments.promotionPeriod.getPromotion().getPromotionID(),
				promotionPeriodStartDateTime = arguments.promotionPeriod.getStartDateTime(),
				promotionPeriodEndDateTime = arguments.promotionPeriod.getEndDateTime(),
				ostNotPlaced = "ostNotPlaced"
				}) />
		
		<cfreturn results[1] />
	</cffunction>
	
	<cffunction name="getPromotionPeriodAccountUseCount" returntype="numeric" access="public">
		<cfargument name="promotionPeriod" required="true" type="any" />
		<cfargument name="account" required="true" type="any" />
		
		<cfset var results = ormExecuteQuery("SELECT count(pa.promotionAppliedID) as count
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
					pa.promotion.promotionID = :promotionID
				  and
				  	pa.createdDateTime > :promotionPeriodStartDateTime
				  and
				  	pa.createdDateTime < :promotionPeriodEndDateTime", {
					  	accountID = arguments.account.getAccountID(),
						promotionID = arguments.promotionPeriod.getPromotion().getPromotionID(),
						promotionPeriodStartDateTime = arguments.promotionPeriod.getStartDateTime(),
						promotionPeriodEndDateTime = arguments.promotionPeriod.getEndDateTime(),
						ostNotPlaced = "ostNotPlaced"
				}) />
		
		<cfreturn results[1] />
	</cffunction>
	
	<cffunction name="getSalePricePromotionRewardsQuery">
		<cfargument name="productID" type="string">
		
		<cfset var allDiscounts = "" />
		<cfset var noQualifierPromotionPeriods = "" />
		<cfset var skuPrice = "" />
		<cfset var skuResults = "" />
		<cfset var timeNow = now() />
		<cfset var salePromotionPeriodIDs = "" />
		
		<cfquery name="noQualifierCurrentActivePromotionPeriods">
			SELECT
				promotionPeriodID
			FROM
				SlatwallPromotionPeriod
			  INNER JOIN
			  	SlatwallPromotion on SlatwallPromotionPeriod.promotionID = SlatwallPromotion.promotionID
			WHERE
				SlatwallPromotionPeriod.startDateTime <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#timeNow#">
			  AND
			  	SlatwallPromotionPeriod.endDateTime >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#timeNow#">
			  AND
			  	SlatwallPromotion.activeFlag = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
			  AND
			  	NOT EXISTS(SELECT promotionPeriodID FROM SlatwallPromotionQualifier WHERE SlatwallPromotionQualifier.promotionPeriodID = SlatwallPromotionPeriod.promotionPeriodID)
			  AND
			  	NOT EXISTS(SELECT promotionID FROM SlatwallPromotionCode WHERE SlatwallPromotionCode.promotionID = SlatwallPromotion.promotionID)
		</cfquery>
		
		<cfloop query="noQualifierCurrentActivePromotionPeriods">
			<cfset salePromotionPeriodIDs = listAppend(salePromotionPeriodIDs, noQualifierCurrentActivePromotionPeriods.promotionPeriodID) />
		</cfloop>
		
		<cfquery name="allDiscounts">
			SELECT
				SlatwallSku.skuID as 'skuID',
				SlatwallSku.price as 'originalPrice',
				'sku' as 'discountLevel',
				prSku.amountType as 'salePriceDiscountType',
				CASE prSku.amountType
					WHEN 'amount' THEN prSku.amount
					WHEN 'amountOff' THEN SlatwallSku.price - prSku.amount
					WHEN 'percentageOff' THEN SlatwallSku.price - (SlatwallSku.price * (prSku.amount / 100))
				END as 'salePrice',
				prSku.roundingRuleID as 'roundingRuleID',
				ppSku.endDateTime as 'salePriceExpirationDateTime',
				ppSku.promotionID as 'promotionID'
			FROM
				SlatwallSku
			  INNER JOIN
			  	SlatwallPromotionRewardSku on SlatwallPromotionRewardSku.skuID = SlatwallSku.skuID
			  INNER JOIN
			  	SlatwallPromotionReward prSku on prSku.promotionRewardID = SlatwallPromotionRewardSku.promotionRewardID
			  INNER JOIN
			    SlatwallPromotionPeriod ppSku on ppSku.promotionPeriodID = prSku.promotionPeriodID
			WHERE
				ppSku.promotionPeriodID IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#salePromotionPeriodIDs#" list="true">)
			<cfif structKeyExists(arguments, "productID")>
			  AND
				SlatwallSku.productID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productID#">	
			</cfif>
		  UNION
			SELECT
				SlatwallSku.skuID as 'skuID',
				SlatwallSku.price as 'originalPrice',
				'product' as 'discountLevel',
				prProduct.amountType as 'salePriceDiscountType',
				CASE prProduct.amountType
					WHEN 'amount' THEN prProduct.amount
					WHEN 'amountOff' THEN SlatwallSku.price - prProduct.amount
					WHEN 'percentageOff' THEN SlatwallSku.price - (SlatwallSku.price * (prProduct.amount / 100))
				END as 'salePrice',
				prProduct.roundingRuleID as 'roundingRuleID',
				ppProduct.endDateTime as 'salePriceExpirationDateTime',
				ppProduct.promotionID as 'promotionID'
			FROM
				SlatwallSku
			  INNER JOIN
			  	SlatwallPromotionRewardProduct on SlatwallPromotionRewardProduct.productID = SlatwallSku.productID
			  INNER JOIN
			  	SlatwallPromotionReward prProduct on prProduct.promotionRewardID = SlatwallPromotionRewardProduct.promotionRewardID
			  INNER JOIN
			    SlatwallPromotionPeriod ppProduct on ppProduct.promotionPeriodID = prProduct.promotionPeriodID
			WHERE
				ppProduct.promotionPeriodID IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#salePromotionPeriodIDs#" list="true">)
			<cfif structKeyExists(arguments, "productID")>
			  AND
				SlatwallSku.productID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productID#">	
			</cfif>
		  UNION
			SELECT
				SlatwallSku.skuID as 'skuID',
				SlatwallSku.price as 'originalPrice',
				'brand' as 'discountLevel',
				prBrand.amountType as 'salePriceDiscountType',
				CASE prBrand.amountType
					WHEN 'amount' THEN prBrand.amount
					WHEN 'amountOff' THEN SlatwallSku.price - prBrand.amount
					WHEN 'percentageOff' THEN SlatwallSku.price - (SlatwallSku.price * (prBrand.amount / 100))
				END as 'salePrice',
				prBrand.roundingRuleID as 'roundingRuleID',
				ppBrand.endDateTime as 'salePriceExpirationDateTime',
				ppBrand.promotionID as 'promotionID'
			FROM
				SlatwallSku
			  INNER JOIN
			  	SlatwallProduct on SlatwallProduct.productID = SlatwallSku.productID
			  INNER JOIN
			  	SlatwallPromotionRewardBrand on SlatwallPromotionRewardBrand.brandID = SlatwallProduct.brandID
			  INNER JOIN
			  	SlatwallPromotionReward prBrand on prBrand.promotionRewardID = SlatwallPromotionRewardBrand.promotionRewardID
			  INNER JOIN
			    SlatwallPromotionPeriod ppBrand on ppBrand.promotionPeriodID = prBrand.promotionPeriodID
			WHERE
				ppBrand.promotionPeriodID IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#salePromotionPeriodIDs#" list="true">)
			<cfif structKeyExists(arguments, "productID")>
			  AND
				SlatwallSku.productID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productID#">	
			</cfif>
		  UNION
		  	SELECT
		  		SlatwallSku.skuID as 'skuID',
				SlatwallSku.price as 'originalPrice',
				'option' as 'discountLevel',
				prOption.amountType as 'salePriceDiscountType',
				CASE prOption.amountType
					WHEN 'amount' THEN prOption.amount
					WHEN 'amountOff' THEN SlatwallSku.price - prOption.amount
					WHEN 'percentageOff' THEN SlatwallSku.price - (SlatwallSku.price * (prOption.amount / 100))
				END as 'salePrice',
				prOption.roundingRuleID as 'roundingRuleID',
				ppOption.endDateTime as 'salePriceExpirationDateTime',
				ppOption.promotionID as 'promotionID'
			FROM
				SlatwallSku
			  INNER JOIN
			  	SlatwallSkuOption on SlatwallSkuOption.skuID = SlatwallSku.skuID
			  INNER JOIN
			  	SlatwallPromotionRewardOption on SlatwallPromotionRewardOption.optionID = SlatwallSkuOption.optionID
			  INNER JOIN
			  	SlatwallPromotionReward prOption on prOption.promotionRewardID = SlatwallPromotionRewardOption.promotionRewardID
			  INNER JOIN
			    SlatwallPromotionPeriod ppOption on ppOption.promotionPeriodID = prOption.promotionPeriodID
			WHERE
				ppOption.promotionPeriodID IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#salePromotionPeriodIDs#" list="true">)
			<cfif structKeyExists(arguments, "productID")>
			  AND
				SlatwallSku.productID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productID#">	
			</cfif>
		  UNION
		  	SELECT
		  		SlatwallSku.skuID as 'skuID',
				SlatwallSku.price as 'originalPrice',
				'productType' as 'discountLevel',
				prProductType.amountType as 'salePriceDiscountType',
				CASE prProductType.amountType
					WHEN 'amount' THEN prProductType.amount
					WHEN 'amountOff' THEN SlatwallSku.price - prProductType.amount
					WHEN 'percentageOff' THEN SlatwallSku.price - (SlatwallSku.price * (prProductType.amount / 100))
				END as 'salePrice',
				prProductType.roundingRuleID as 'roundingRuleID',
				ppProductType.endDateTime as 'salePriceExpirationDateTime',
				ppProductType.promotionID as 'promotionID'
			FROM
				SlatwallSku
			  INNER JOIN
			  	SlatwallProduct on SlatwallProduct.productID = SlatwallSku.productID
			  INNER JOIN
			  	SlatwallProductType on SlatwallProduct.productTypeID = SlatwallProductType.productTypeID
			  INNER JOIN
			  <cfif getDBType() eq "MySQL">
			  	SlatwallPromotionRewardProductType on SlatwallProductType.productTypeIDPath LIKE concat('%', SlatwallPromotionRewardProductType.productTypeID, '%')
			  <cfelse>
			  	SlatwallPromotionRewardProductType on SlatwallProductType.productTypeIDPath LIKE ('%' + SlatwallPromotionRewardProductType.productTypeID + '%')
			  </cfif>
			  INNER JOIN
			  	SlatwallPromotionReward prProductType on prProductType.promotionRewardID = SlatwallPromotionRewardProductType.promotionRewardID
			  INNER JOIN
			    SlatwallPromotionPeriod ppProductType on ppProductType.promotionPeriodID = prProductType.promotionPeriodID
			WHERE
				ppProductType.promotionPeriodID IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#salePromotionPeriodIDs#" list="true">)
			<cfif structKeyExists(arguments, "productID")>
			  AND
				SlatwallSku.productID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productID#">	
			</cfif>
		  UNION
			SELECT
				SlatwallSku.skuID as 'skuID',
				SlatwallSku.price as 'originalPrice',
				'global' as 'discountLevel',
				prGlobal.amountType as 'salePriceDiscountType',
				CASE prGlobal.amountType
					WHEN 'amount' THEN prGlobal.amount
					WHEN 'amountOff' THEN SlatwallSku.price - prGlobal.amount
					WHEN 'percentageOff' THEN SlatwallSku.price - (SlatwallSku.price * (prGlobal.amount / 100))
				END as 'salePrice',
				prGlobal.roundingRuleID as 'roundingRuleID',
				ppGlobal.endDateTime as 'salePriceExpirationDateTime',
				ppGlobal.promotionID as 'promotionID'
			FROM
				SlatwallSku
			  INNER JOIN
			  	SlatwallProduct on SlatwallProduct.productID = SlatwallSku.productID
			  CROSS JOIN
				SlatwallPromotionReward prGlobal
			  INNER JOIN
			  	SlatwallPromotionPeriod ppGlobal on prGlobal.promotionPeriodID = ppGlobal.promotionPeriodID
			WHERE
				ppGlobal.promotionPeriodID IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#salePromotionPeriodIDs#" list="true">)
			  AND
			  	prGlobal.rewardType IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="merchandise,subscription,contentAccess" list="true">)
			  AND
			  	NOT EXISTS(SELECT promotionRewardID FROM SlatwallPromotionRewardProduct WHERE SlatwallPromotionRewardProduct.promotionRewardID = prGlobal.promotionRewardID)
			  AND
			  	NOT EXISTS(SELECT promotionRewardID FROM SlatwallPromotionRewardBrand WHERE SlatwallPromotionRewardBrand.promotionRewardID = prGlobal.promotionRewardID)
			  AND
			  	NOT EXISTS(SELECT promotionRewardID FROM SlatwallPromotionRewardOption WHERE SlatwallPromotionRewardOption.promotionRewardID = prGlobal.promotionRewardID)
			  AND
			  	NOT EXISTS(SELECT promotionRewardID FROM SlatwallPromotionRewardProductType WHERE SlatwallPromotionRewardProductType.promotionRewardID = prGlobal.promotionRewardID)
			<cfif structKeyExists(arguments, "productID")>
			  AND
				SlatwallSku.productID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productID#">	
			</cfif>
		</cfquery>
		
		<cfquery name="skuPrice" dbtype="query">
			SELECT
				skuID,
				MIN(salePrice) as salePrice
			FROM
				allDiscounts
			GROUP BY
				skuID
		</cfquery>
		
		<cfquery name="skuResults" dbtype="query">
			SELECT
				AllDiscounts.skuID,
				AllDiscounts.originalPrice,
				AllDiscounts.discountLevel,
				AllDiscounts.salePriceDiscountType,
				AllDiscounts.salePrice,
				AllDiscounts.roundingRuleID,
				AllDiscounts.salePriceExpirationDateTime,
				AllDiscounts.promotionID
			FROM
				allDiscounts,
				skuPrice
			WHERE
				allDiscounts.skuID = skuPrice.skuID
			  and
			    allDiscounts.salePrice = skuPrice.salePrice
		</cfquery>
		
		<cfreturn skuResults /> 
	</cffunction>
		
</cfcomponent>