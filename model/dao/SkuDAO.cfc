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
<cfcomponent extends="HibachiDAO" accessors="true" output="false">
	
	<cfproperty name="hibachiCacheService" type="any" />
	
	<cffunction name="getSkuDefinitionForMerchandiseBySkuID">
		<cfargument name="skuID" required="true"/>
		
		<cfscript>
			var skuDefinition = "";
			var optionCollectionList = getService('optionService').getOptionCollectionList();
			optionCollectionList.setDisplayProperties('optionGroup.optionGroupName,optionName,optionGroup.sortOrder');
			optionCollectionList.addFilter('skus.skuID',arguments.skuID);
			optionCollectionList.setOrderBy('optionGroup.sortOrder');
			for(var item in optionCollectionList.getRecords()) {
				skuDefinition = listAppend(skuDefinition, " #item['optionGroup_optionGroupName']#: #item['optionName']#", ",");
			}
			
			return skuDefinition;
		</cfscript>
	</cffunction>
	
	<cffunction name="getTransactionExistsFlag" returntype="boolean" output="false">
		<cfargument name="productID" />
		<cfargument name="skuID" />
		
		<cfset var hql = "SELECT count(ss.skuID) FROM SlatwallSku ss WHERE " />
		
		<cfif structKeyExists(arguments, "skuID") && !isNull(arguments.skuID)>
			<cfset hql &= "ss.skuID = :skuID" />	
		<cfelse>
			<cfset hql &= "ss.product.productID = :productID" />
		</cfif>

		<cfset hql &= " AND (
				EXISTS( SELECT a.orderItemID as id FROM SlatwallOrderItem a WHERE sku.skuID = ss.skuID )
				  OR
			  	EXISTS( SELECT a.inventoryID as id FROM SlatwallInventory a WHERE stock.sku.skuID = ss.skuID )
			  	  OR
			  	EXISTS( SELECT a.orderDeliveryItemID as id FROM SlatwallOrderDeliveryItem a WHERE stock.sku.skuID = ss.skuID )
				  OR
			  	EXISTS( SELECT a.physicalCountItemID as id FROM SlatwallPhysicalCountItem a WHERE stock.sku.skuID = ss.skuID )
			  	  OR
			  	EXISTS( SELECT a.stockAdjustmentDeliveryItemID as id FROM SlatwallStockAdjustmentDeliveryItem a WHERE stock.sku.skuID = ss.skuID )
			  	  OR
			  	EXISTS( SELECT a.stockAdjustmentItemID as id FROM SlatwallStockAdjustmentItem a WHERE fromStock.sku.skuID = ss.skuID )
			  	  OR
			  	EXISTS( SELECT a.stockAdjustmentItemID as id FROM SlatwallStockAdjustmentItem a WHERE toStock.sku.skuID = ss.skuID )
			  	  OR
			  	EXISTS( SELECT a.stockHoldID as id FROM SlatwallStockHold a WHERE stock.sku.skuID = ss.skuID )
			  	  OR
			  	EXISTS( SELECT a.stockReceiverItemID as id FROM SlatwallStockReceiverItem a WHERE stock.sku.skuID = ss.skuID )
			  	  OR
			  	EXISTS( SELECT a.vendorOrderItemID as id FROM SlatwallVendorOrderItem a WHERE stock.sku.skuID = ss.skuID )
			  )" />

		<cfif structKeyExists(arguments, "skuID") && !isNull(arguments.skuID)>
			<cfset var results = ormExecuteQuery(hql, {skuID = arguments.skuID}) />
		<cfelse>
			<cfset var results = ormExecuteQuery(hql, {productID = arguments.productID}) />
		</cfif>
		
		<cfif results[1] eq 0>
			<cfreturn false />
		</cfif>
		
		<cfreturn true />
	</cffunction>
	
	<cfscript>
		
	public array function getImageFileDataBySkuIDList(required string skuIDList){
		var hql = "SELECT NEW MAP(imageFile as imageFile,skuID as skuID) FROM #getApplicationKey()#Sku WHERE skuID IN (:skuIDList)";
		
		var params = {skuIDList=arguments.skuIDList};
		
		return ORMExecuteQuery(hql,params);
    }

	public any function getSkuBySkuCode( required string skuCode){
		return ormExecuteQuery( "SELECT ss FROM SlatwallSku ss LEFT JOIN ss.alternateSkuCodes ascs WHERE ss.skuCode = :skuCode OR ascs.alternateSkuCode = :skuCode", {skuCode=arguments.skuCode}, true ); 
	}
		
	// returns product skus which matches ALL options (list of optionIDs) that are passed in
	public any function getSkusBySelectedOptions(required string selectedOptions, string productID) {
		
		var params = [];
		var hql = "select distinct sku from SlatwallSku as sku 
					inner join sku.options as opt 
					where 
					0 = 0 ";
		for(var i=1; i<=listLen(arguments.selectedOptions); i++) {
			var thisOptionID = listGetat(arguments.selectedOptions,i);
			hql &= "and exists (
						from SlatwallOption o
						join o.skus s where s.id = sku.id
						and o.optionID = ?
					) ";
			arrayAppend(params,thisOptionID);
		}
		// if product ID is passed in, limit query to the product
		if(structKeyExists(arguments,"productID")) {
			hql &= "and sku.product.id = ?";
			arrayAppend(params,arguments.productID);	
		}
		return ormExecuteQuery(hql,params);
	}
	
	public any function searchSkusByProductType(string term,string productTypeID) {
		var q = new Query();
		var sql = "select skuID,skuCode from SlatwallSku where skuCode like :code";
		q.addParam(name="code",value="%#arguments.term#%",cfsqltype="cf_sql_varchar");
		if(structKeyExists(arguments,"productTypeID") && trim(arguments.productTypeID) != "") {
			sql &= " and productID in (select productID from SlatwallProduct where productTypeID in (:productTypeIDs))";
			q.addParam(name="productTypeIDs", value="#arguments.productTypeID#", cfsqltype="cf_sql_varchar", list="true");
		}
		q.setSQL(sql);
		var records = q.execute().getResult();
		var result = [];
		for(var i=1;i<=records.recordCount;i++) {
			result[i] = {
				"id" = records.skuID[i],
				"value" = records.skuCode[i]
			};
		}
		return result;
	}
	
	public array function getProductSkus(required any product, required any fetchOptions, required string joinType) {
		
		var hql = "SELECT sku FROM SlatwallSku sku ";
		if(fetchOptions) {
			if(arguments.product.getBaseProductType() eq "contentAccess") {
				hql &= "#arguments.joinType# JOIN FETCH sku.accessContents contents ";	
			} else if (arguments.product.getBaseProductType() eq "merchandise") {
				hql &= "#arguments.joinType# JOIN FETCH sku.options option ";
			} else if (arguments.product.getBaseProductType() eq "subscription") {
				hql &= "#arguments.joinType# JOIN sku.subscriptionTerm st ";
				hql &= "#arguments.joinType# JOIN sku.orderItems oi ";
				hql &= "#arguments.joinType# JOIN FETCH sku.subscriptionBenefits sb ";
			}
		}
		var hql &= "WHERE sku.product.productID = :productID ";
		
		var skus = ORMExecuteQuery(hql,	{productID = arguments.product.getProductID()}, false, {ignoreCase="true"});
		
		return skus;
	}
	
	public any function getAverageCost(required string skuID, required string currencyCode, string locationID=""){
		var params = {
			skuID=arguments.skuID,
			currencyCode=arguments.currencyCode
		};
		
		
		var hql = 'SELECT COALESCE( sum(stock.averageCost * stock.calculatedQOH) / nullIf(sum(stock.calculatedQOH),0), 0)
			FROM SlatwallStock stock 
			LEFT JOIN stock.sku sku
			LEFT JOIN stock.location location
		';
		
		hql &= ' WHERE sku.skuID=:skuID AND stock.averageCost IS NOT NULL AND location.currencyCode=:currencyCode ';
		
		if(len(arguments.locationID)){
			hql&= ' AND location.locationID = :locationID';	
			params.locationID = arguments.locationID;
		}
		
		
		return ORMExecuteQuery(
			hql,
			params,
			true
		);
	}
	
	public any function getAverageLandedCost(required string skuID, required string currencyCode, string locationID=""){
		var params = {
			skuID=arguments.skuID,
			currencyCode=arguments.currencyCode
		};
		
		var hql = 'SELECT COALESCE(AVG(stock.averageLandedCost),0)
			FROM SlatwallStock stock 
			LEFT JOIN stock.sku sku
			LEFT JOIN stock.location location
		';
		
		hql &= ' WHERE sku.skuID=:skuID AND stock.averageCost IS NOT NULL AND location.currencyCode=:currencyCode ';
		
		if(len(arguments.locationID)){
			hql &= ' AND location.locationID=:locationID ';	
			params.locationID=arguments.locationID;
		}
		
		return ORMExecuteQuery(
			hql,
			params,
			true
		);
	}
	
	public any function getAverageProfit(required string skuID, required string currencyCode){
		return getService('hibachiUtilityService').precisionCalculate(getAveragePriceSold(argumentCollection=arguments) - getAverageCost(argumentCollection=arguments));
	}
	
	public any function getAverageLandedProfit(required string skuID, required string currencyCode){
		return getService('hibachiUtilityService').precisionCalculate(getAveragePriceSold(argumentCollection=arguments) - getAverageLandedCost(argumentCollection=arguments));
	}
	
	public any function getAverageMarkup(required string skuID, required string currencyCode){
		var averagePriceSold = getAveragePriceSold(argumentCollection=arguments);
		var averageCost = getAverageCost(argumentCollection=arguments);
		if(averageCost == 0){
			return 0;
		}
		
		return getService('hibachiUtilityService').precisionCalculate(((averagePriceSold-averageCost)/averageCost)*100);
	}
	
	public any function getAverageLandedMarkup(required string skuID, required string currencyCode){
		var averagePriceSold = getAveragePriceSold(argumentCollection=arguments);
		var averageLandedCost = getAverageLandedCost(argumentCollection=arguments);
		if(averageLandedCost == 0){
			return 0;
		}
		return getService('hibachiUtilityService').precisionCalculate(((averagePriceSold-averageLandedCost)/averageLandedCost)*100);
	}
	
	public numeric function getCurrentMarginBeforeDiscount(required string skuID, required string currencyCode){
		var averagePriceSold = getAveragePriceSoldAfterDiscount(argumentCollection=arguments);
		if(averagePriceSold == 0){
			return 0;
		}
		return getService('hibachiUtilityService').precisionCalculate((getAverageProfit(argumentCollection=arguments) / averagePriceSold) * 100);
	}
	
	public numeric function getCurrentMargin(required string skuID, required string currencyCode){
		var averagePriceSold = getAveragePriceSold(argumentCollection=arguments);
		if(averagePriceSold == 0){
			return 0;
		}
		return getService('hibachiUtilityService').precisionCalculate((getAverageProfit(argumentCollection=arguments) / averagePriceSold) * 100);
	}
	
	public numeric function getCurrentLandedMargin(required string skuID, required string currencyCode){
		var averagePriceSold = getAveragePriceSold(argumentCollection=arguments);
		if(averagePriceSold == 0){
			return 0;
		}
		return getService('hibachiUtilityService').precisionCalculate((getAverageLandedProfit(argumentCollection=arguments) / averagePriceSold) * 100);
	}
	
	public numeric function getAverageDiscountAmount(required string skuID, required string currencyCode){
		var hql = "SELECT NEW MAP(
							COALESCE( sum(orderDeliveryItem.quantity), 0 ) as QDOO, 
							COALESCE( sum(orderDeliveryItem.quantity*orderDeliveryItem.orderItem.calculatedDiscountAmount),0) as totalDiscountAmount 
						) 
						FROM
							SlatwallOrderDeliveryItem orderDeliveryItem
						  LEFT JOIN
					  		orderDeliveryItem.orderItem orderItem
						WHERE
							orderDeliveryItem.orderItem.order.orderStatusType.systemCode NOT IN ('ostNotPlaced','ostCanceled')
						  AND
						  	orderDeliveryItem.orderItem.orderItemType.systemCode = 'oitSale'
						  AND 
							orderDeliveryItem.orderItem.sku.skuID = :skuID
						  AND 
						  	orderDeliveryItem.orderItem.currencyCode = :currencyCode
						";
		var QDOODetails = ormExecuteQuery(hql, {skuID=arguments.skuID,currencyCode=arguments.currencyCode},true);	
		if(QDOODetails['QDOO']==0){
			return 0;
		}
		var averageDiscountAmount = getService('hibachiUtilityService').precisionCalculate(QDOODetails['totalDiscountAmount']/QDOODetails['QDOO']);
		return averageDiscountAmount;
	}
	
	public numeric function getAveragePriceSoldAfterDiscount(required string skuID, required string currencyCode){
		var hql = "SELECT NEW MAP(
							COALESCE( sum(orderDeliveryItem.quantity), 0 ) as QDOO, 
							COALESCE( sum(orderDeliveryItem.orderItem.calculatedExtendedPriceAfterDiscount),0) as totalAfterDiscount 
						) 
						FROM
							SlatwallOrderDeliveryItem orderDeliveryItem
						  LEFT JOIN
					  		orderDeliveryItem.orderItem orderItem
						WHERE
							orderDeliveryItem.orderItem.order.orderStatusType.systemCode NOT IN ('ostNotPlaced','ostCanceled')
						  AND
						  	orderDeliveryItem.orderItem.orderItemType.systemCode = 'oitSale'
						  AND 
							orderDeliveryItem.orderItem.sku.skuID = :skuID
						  AND 
						  	orderDeliveryItem.orderItem.currencyCode = :currencyCode
						";
		var QDOODetails = ormExecuteQuery(hql, {skuID=arguments.skuID,currencyCode=arguments.currencyCode},true);	
		if(QDOODetails['QDOO']==0){
			return 0;
		}
		var AveragePriceSoldAfterDiscount = getService('hibachiUtilityService').precisionCalculate(QDOODetails['totalAfterDiscount']/QDOODetails['QDOO']);
		return AveragePriceSoldAfterDiscount;
	}
	
	public numeric function getAveragePriceSold(required string skuID, required string currencyCode){
		 
		var hql = "SELECT NEW MAP(
							COALESCE( sum(orderDeliveryItem.quantity), 0 ) as QDOO, 
							COALESCE( sum(orderDeliveryItem.orderItem.calculatedExtendedPrice),0) as totalEarned 
						) 
						FROM
							SlatwallOrderDeliveryItem orderDeliveryItem
						  LEFT JOIN
					  		orderDeliveryItem.orderItem orderItem
						WHERE
							orderDeliveryItem.orderItem.order.orderStatusType.systemCode NOT IN ('ostNotPlaced','ostCanceled')
						  AND
						  	orderDeliveryItem.orderItem.orderItemType.systemCode = 'oitSale'
						  AND 
							orderDeliveryItem.orderItem.sku.skuID = :skuID
						  AND 
						  	orderDeliveryItem.orderItem.currencyCode = :currencyCode
						";
		var QDOODetails = ormExecuteQuery(hql, {skuID=arguments.skuID,currencyCode=arguments.currencyCode},true);	
		if(QDOODetails['QDOO']==0){
			return 0;
		}
		var averagePriceSold = getService('hibachiUtilityService').precisionCalculate(QDOODetails['totalEarned']/QDOODetails['QDOO']);
		return averagePriceSold;
	}

	</cfscript>

	<cffunction name="getSortedProductSkusID">
		<cfargument name="productID" type="string" required="true" />
		<cfargument name="joinType" type="string" default="INNER" />
		
		<cfset var sorted = "" />
		<cfset var nextOptionGroupSortOrder = getHibachiCacheService().getOrCacheFunctionValue("skuDAO_getNextOptionGroupSortOrder", this, "getNextOptionGroupSortOrder") />
		
		<!--- TODO: test to see if this query works with DB's other than MSSQL and MySQL --->
		<cfquery name="sorted">
			SELECT
				SwSku.skuID
			FROM
				SwSku
			  #arguments.joinType# JOIN
				SwSkuOption on SwSku.skuID = SwSkuOption.skuID
			  #arguments.joinType# JOIN
				SwOption on SwSkuOption.optionID = SwOption.optionID
			  #arguments.joinType# JOIN
				SwOptionGroup on SwOption.optionGroupID = SwOptionGroup.optionGroupID
			WHERE
				SwSku.productID = <cfqueryparam value="#arguments.productID#" cfsqltype="cf_sql_varchar" />
			GROUP BY
				SwSku.skuID
			ORDER BY
				<cfif getApplicationValue("databaseType") eq "MicrosoftSQLServer">
					SUM(SwOption.sortOrder * POWER(CAST(10 as bigint), CAST((#nextOptionGroupSortOrder# - SwOptionGroup.sortOrder) as bigint))) ASC
				<cfelse>
					SUM(SwOption.sortOrder * POWER(10, #nextOptionGroupSortOrder# - SwOptionGroup.sortOrder)) ASC
				</cfif>
		</cfquery>
		
		<cfreturn sorted />
	</cffunction>
	
	<cffunction name="getNextOptionGroupSortOrder" returntype="numeric" access="public">
		<cfset var nogSortOrder = 1 />
		<cfset var rs = "" />
		
		<cfquery name="rs">
			SELECT max(SwOptionGroup.sortOrder) as max FROM SwOptionGroup
		</cfquery>
		<cfif rs.recordCount>
			<cfset nogSortOrder = rs.max + 1 />
		</cfif>
		
		<cfreturn nogSortOrder />
	</cffunction>
	
	<!--- Retuns a list of all locationID's used during a given time range --->
	<cffunction name="getUsedLocationIdsByEventDates" returntype="any" access="public" >
		<cfargument name="eventStartDateTime" type="date" />
		<cfargument name="eventEndDateTime" type="date" />
	 
		<cfquery name="local.getUsedLocationIdsByEventDates" >
			SELECT
				DISTINCT lc.LocationID 
			FROM 
				SwSku
			LEFT OUTER JOIN 
				SwProduct 
			ON 
				SwSku.productID=SwProduct.productID 
			LEFT OUTER JOIN 
				SwSkuLocationConfiguration slc
			ON 
				SwSku.skuID = slc.skuID
			LEFT OUTER JOIN 
				SwLocationConfiguration lc
			ON 
				slc.locationConfigurationID = lc.locationConfigurationID
			WHERE 
				SwSku.activeFlag=1
			AND 
				SwProduct.activeFlag=1 
			AND 
				SwSku.bundleFlag=0 
			AND
				(	
					(	
						SwSku.eventStartDateTime <= <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#arguments.eventStartDateTime#">
							AND 
						SwSku.eventEndDateTime >= <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#arguments.eventEndDateTime#">
					)
					OR
					(
						SwSku.eventStartDateTime BETWEEN <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#arguments.eventStartDateTime#"> AND <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#arguments.eventEndDateTime#"> 
							OR 
						SwSku.eventEndDateTime BETWEEN <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#arguments.eventStartDateTime#"> AND <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#arguments.eventEndDateTime#">
					)
				)
		</cfquery> 
		
		<cfreturn valueList(getUsedLocationIdsByEventDates.LocationID) />
	</cffunction>
	
	<cffunction name="getSkuCostBySkuIDAndCurrencyCode">
		<cfargument name="skuID" type="string" />
		<cfargument name="currencyCode" type="string" />
		<cfreturn ORMExecuteQuery('
			FROM SlatwallSkuCost sc 
			where sc.currency.currencyCode=:currencyCode
			and sc.sku.skuID = :skuID
			',{skuID=arguments.skuID,currencyCode=arguments.currencyCode},true)
		/>
		
	</cffunction>
	
</cfcomponent>
