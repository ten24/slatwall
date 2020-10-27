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
	
	<cffunction name="updateStockLocation" hint="Moves all stock from one location to another">
		<cfargument name="fromLocationID" type="string" required="true" >
		<cfargument name="toLocationID" type="string" required="true" >
		<cfquery name="local.updatestock" >
			UPDATE SwStock 
			SET locationID = <cfqueryparam value="#arguments.toLocationID#" cfsqltype="cf_sql_varchar" >
			WHERE locationID = <cfqueryparam value="#arguments.fromLocationID#" cfsqltype="cf_sql_varchar" >
		</cfquery>
	</cffunction>
		

	<cfscript>
		public void function updateStockMinMax(required string skuID, required string locationID, required any minQuantity, required any maxQuantity) {
			var dataQuery = new Query();
			dataQuery.setSql("
				UPDATE swStock 
				SET minQuantity = #arguments.minQuantity#,
					maxQuantity = #arguments.maxQuantity#
				WHERE skuID = '#arguments.skuID#'
					AND locationID  = '#arguments.locationID#'
			");
			dataQuery.execute();
		}

		public query function getMinMaxStockTransferDetails(required string fromLocationID, required string toLocationID){
			var dataQuery = new Query();
			dataQuery.setSql("
				SELECT
				  st.skuID, sk.skuCode, 
				  st.locationID AS toTopLocationID, st.minQuantity AS toMinQuantity, st.maxQuantity AS toMaxQuantity, 0 AS toOffsetQuantity,
				  ( SELECT sum(st1.calculatedQATS)
				    FROM swstock AS st1
				      JOIN swlocation AS lt1 ON st1.locationID = lt1.locationID
				    WHERE st1.skuID = st.skuID
				      AND lt1.locationIDPath LIKE concat('%',st.locationID,'%')
				  ) AS toSumQATS,
				  ( SELECT st2.locationID
				    FROM swstock AS st2
				    INNER JOIN swlocation AS lt2 ON lt2.locationID = st2.locationID
				    WHERE st2.skuID = st.skuID
				      AND lt2.locationIDPath LIKE concat('%',st.locationID,'%')
				    ORDER BY st2.calculatedQATS DESC LIMIT 1
				  ) AS toLeafLocationID,
				  sf.locationID AS fromTopLocationID, sf.minQuantity AS fromMinQuantity, sf.maxQuantity AS fromMaxQuantity, 0 AS fromOffsetQuantity,
				  ( SELECT sum(sf1.calculatedQATS)
				    FROM swstock AS sf1
				      JOIN swlocation AS lf1 ON sf1.locationID = lf1.locationID
				    WHERE lf1.locationIDPath LIKE concat('%',sf.locationID,'%')
				      AND sf1.skuID = st.skuID
				  ) AS fromSumQATS,
				  sfl.locationID AS fromLeafLocationID, sfl.calculatedQATS as fromCalculatedQATS
				FROM swstock AS st
				  INNER JOIN swstock AS sf ON sf.skuID = st.skuID
				  INNER JOIN swsku AS sk ON sk.skuID = sf.skuID
				    AND sf.locationID <> st.locationID
				  INNER JOIN swstock AS sfl ON sfl.skuID = sf.skuID
				    INNER JOIN swlocation AS lfl ON lfl.locationID = sfl.locationID
				WHERE sf.locationID = '#arguments.fromLocationID#'
				  AND st.locationID = '#arguments.toLocationID#'
				  AND st.skuID = sf.skuID
				  AND sfl.calculatedQATS > 0
				  AND lfl.locationIDPath LIKE concat('%',sf.locationID,'%')
				  AND st.minQuantity > 0
				  AND st.maxQuantity > 0
				  -- AND sf.minQuantity > 0
				  -- AND sf.maxQuantity > 0
				ORDER BY st.locationID, sk.skuCode, sfl.calculatedQATS DESC
			");

			return dataQuery.execute().getResult();
		}

		public void function insertMinMaxStockTransferItem(required struct minMaxStockTransferItemData) {
			var minMaxStockTransferItemID = lcase(replace(createUUID(),"-","","all"));
			var dataQuery = new Query();
			dataQuery.setSql("
				INSERT INTO swMinMaxStockTransferItem
					(
						minMaxStockTransferItemID, minMaxStockTransferID, skuID, toTopLocationID, toLeafLocationID, fromTopLocationID, fromLeafLocationID, toMinQuantity, toMaxQuantity, toOffsetQuantity, toSumQATS, fromMinQuantity, fromMaxQuantity, fromOffsetQuantity, fromSumQATS, fromCalculatedQATS, transferQuantity, createdDatetime, modifiedDatetime, createdByAccountID, modifiedByAccountID
					)
				VALUES 
					(
						'#minMaxStockTransferItemID#', 
						'#arguments.minMaxStockTransferItemData.minMaxStockTransferID#', 
						'#arguments.minMaxStockTransferItemData.skuID#', 
						'#arguments.minMaxStockTransferItemData.toTopLocationID#', 
						'#arguments.minMaxStockTransferItemData.toLeafLocationID#', 
						'#arguments.minMaxStockTransferItemData.fromTopLocationID#', 
						'#arguments.minMaxStockTransferItemData.fromLeafLocationID#', 
						#arguments.minMaxStockTransferItemData.toMinQuantity#, 
						#arguments.minMaxStockTransferItemData.toMaxQuantity#, 
						#arguments.minMaxStockTransferItemData.toOffsetQuantity#, 
						#arguments.minMaxStockTransferItemData.toSumQATS#, 
						#arguments.minMaxStockTransferItemData.fromMinQuantity#, 
						#arguments.minMaxStockTransferItemData.fromMaxQuantity#, 
						#arguments.minMaxStockTransferItemData.fromOffsetQuantity#, 
						#arguments.minMaxStockTransferItemData.fromSumQATS#, 
						#arguments.minMaxStockTransferItemData.fromCalculatedQATS#, 
						#arguments.minMaxStockTransferItemData.transferQuantity#, 
						#arguments.minMaxStockTransferItemData.timeStamp#, 
						#arguments.minMaxStockTransferItemData.timeStamp#, 
						'#arguments.minMaxStockTransferItemData.administratorID#', 
						'#arguments.minMaxStockTransferItemData.administratorID#'
					);
			");
			dataQuery.execute();
		}

		public void function deleteMinMaxStockTransferItems(required string minMaxStockTransferID) {
			var dataQuery = new Query();
			dataQuery.setSql("
				DELETE FROM swMinMaxStockTransferItem 
				WHERE minMaxStockTransferID = '#arguments.minMaxStockTransferID#'
			");
			dataQuery.execute();
		}

		public void function insertMinMaxTransferStockAjustment(required struct stockAdjustmentData) {
			
			lock scope="Application" timeout="30" {
	 			var maxReferenceNumber = getStockAdjustmentMaxReferenceNumber()['maxReferenceNumber'];
		 		var referenceNumber = maxReferenceNumber + 1;
	 		}
			var dataQuery = new Query();
			dataQuery.setSql("
				INSERT INTO swStockAdjustment
					(
						stockAdjustmentID,referenceNumber, fromLocationID, toLocationID, stockAdjustmentTypeID, stockAdjustmentStatusTypeID, #!isNull(arguments.stockAdjustmentData.minMaxStockTransferID) ? 'minMaxStockTransferID,' : ''# #!isNull(arguments.stockAdjustmentData.fulfillmentBatchID) ? 'fulfillmentBatchID,' : ''# createdDatetime, modifiedDatetime, createdByAccountID, modifiedByAccountID
					)
				VALUES 
					(
						'#arguments.stockAdjustmentData.stockAdjustmentID#', 
						'#referenceNumber#',
						'#arguments.stockAdjustmentData.fromLocationID#', 
						'#arguments.stockAdjustmentData.toLocationID#', 
						'#arguments.stockAdjustmentData.stockAdjustmentTypeID#', 
						'#arguments.stockAdjustmentData.stockAdjustmentStatusTypeID#', 
						#!isNull(arguments.stockAdjustmentData.minMaxStockTransferID) ? "'#arguments.stockAdjustmentData.minMaxStockTransferID#'," : ""#
						#!isNull(arguments.stockAdjustmentData.fulfillmentBatchID) ? "'#arguments.stockAdjustmentData.fulfillmentBatchID#'," : ""#
						#arguments.stockAdjustmentData.timeStamp#, 
						#arguments.stockAdjustmentData.timeStamp#, 
						'#arguments.stockAdjustmentData.administratorID#', 
						'#arguments.stockAdjustmentData.administratorID#'
					);
			");
			dataQuery.execute();
		}

		public void function insertMinMaxTransferStockAjustmentItem(required struct stockAdjustmentItemData) {
			var dataQuery = new Query();
			dataQuery.setSql("
				INSERT INTO swStockAdjustmentItem
					(
						stockAdjustmentItemID, stockAdjustmentID, quantity, cost, currencyCode, fromStockID, toStockID, skuID, createdDatetime, modifiedDatetime, createdByAccountID, modifiedByAccountID
					)
				VALUES 
					(
						'#arguments.stockAdjustmentItemData.stockAdjustmentItemID#', 
						'#arguments.stockAdjustmentItemData.stockAdjustmentID#', 
						#arguments.stockAdjustmentItemData.quantity#, 
						#arguments.stockAdjustmentItemData.cost#, 
						'#arguments.stockAdjustmentItemData.currencyCode#', 
						'#arguments.stockAdjustmentItemData.fromStockID#', 
						'#arguments.stockAdjustmentItemData.toStockID#', 
						'#arguments.stockAdjustmentItemData.skuID#', 
						#arguments.stockAdjustmentItemData.timeStamp#, 
						#arguments.stockAdjustmentItemData.timeStamp#, 
						'#arguments.stockAdjustmentItemData.administratorID#', 
						'#arguments.stockAdjustmentItemData.administratorID#'
					);
			");
			dataQuery.execute();
		}

		public void function deleteMinMaxStockAdjustments(required string minMaxStockTransferID) {
			var dataQuery = new Query();
			dataQuery.setSql("
				DELETE FROM swStockAdjustmentItem 
				WHERE stockAdjustmentID IN
					(SELECT stockAdjustmentID FROM swStockAdjustment WHERE minMaxStockTransferID = '#arguments.minMaxStockTransferID#')
			");
			dataQuery.execute();
			var dataQuery2 = new Query();
			dataQuery2.setSql("
				DELETE FROM swStockAdjustment
				WHERE minMaxStockTransferID = '#arguments.minMaxStockTransferID#'
			");
			dataQuery2.execute();
		}

	public numeric function getCurrentMargin(required string stockID, required string currencyCode){
		var averagePriceSold = getAveragePriceSold(argumentCollection=arguments);
		if(averagePriceSold == 0){
			return 0;
		}
		return getService('hibachiUtilityService').precisionCalculate((getAverageProfit(argumentCollection=arguments) / averagePriceSold) * 100);
	}
	
	public numeric function getCurrentLandedMargin(required string stockID, required string currencyCode){
		var averagePriceSold = getAveragePriceSold(argumentCollection=arguments);
		if(averagePriceSold == 0){
			return 0;
		}
		return getService('hibachiUtilityService').precisionCalculate((getAverageLandedProfit(argumentCollection=arguments) / averagePriceSold) * 100);
	}
	
	public numeric function getAveragePriceSoldAfterDiscount(required string stockID, required string currencyCode){
		 
		var hql = "SELECT NEW MAP(
							COALESCE( sum(orderDeliveryItem.quantity), 0 ) as QDOO, 
							COALESCE( sum(orderDeliveryItem.orderItem.calculatedExtendedPriceAfterDiscount),0) as totalAfterDiscount 
						) 
						FROM
							SlatwallOrderDeliveryItem orderDeliveryItem
						LEFT JOIN
					  		orderDeliveryItem.orderItem orderItem
					  	LEFT JOIN
					  		orderItem.sku sku
					  	LEFT JOIN
					  		sku.stocks stocks
					  		
						WHERE
							orderDeliveryItem.orderItem.order.orderStatusType.systemCode NOT IN ('ostNotPlaced','ostCanceled')
						  AND
						  	orderDeliveryItem.orderItem.orderItemType.systemCode = 'oitSale'
						  AND 
						  	orderDeliveryItem.orderItem.currencyCode = :currencyCode
						  AND 
							stocks.stockID = :stockID
						GROUP BY stocks.stockID
						";
		var QDOODetails = ormExecuteQuery(hql, {stockID=arguments.stockID, currencyCode=arguments.currencyCode},true);	
		
		if(isNull(QDOODetails) || QDOODetails['QDOO']==0){
			return 0;
		}
		var averagePriceSold = getService('hibachiUtilityService').precisionCalculate(QDOODetails['totalAfterDiscount']/QDOODetails['QDOO']);
		return averagePriceSold;
	}
	
	public numeric function getAverageDiscountAmount(required string stockID, required string currencyCode){
		 
		var hql = "SELECT NEW MAP(
							COALESCE( sum(orderDeliveryItem.quantity), 0 ) as QDOO, 
							COALESCE( sum(orderDeliveryItem.quantity*orderDeliveryItem.orderItem.calculatedDiscountAmount),0) as discountAmount 
						) 
						FROM
							SlatwallOrderDeliveryItem orderDeliveryItem
						LEFT JOIN
					  		orderDeliveryItem.orderItem orderItem
					  	LEFT JOIN
					  		orderItem.sku sku
					  	LEFT JOIN
					  		sku.stocks stocks
					  		
						WHERE
							orderDeliveryItem.orderItem.order.orderStatusType.systemCode NOT IN ('ostNotPlaced','ostCanceled')
						  AND
						  	orderDeliveryItem.orderItem.orderItemType.systemCode = 'oitSale'
						  AND 
						  	orderDeliveryItem.orderItem.currencyCode = :currencyCode
						  AND 
							stocks.stockID = :stockID
						GROUP BY stocks.stockID
						";
		var QDOODetails = ormExecuteQuery(hql, {stockID=arguments.stockID, currencyCode=arguments.currencyCode},true);	
		
		if(isNull(QDOODetails) || QDOODetails['QDOO']==0){
			return 0;
		}
		var averageDiscountAmount = getService('hibachiUtilityService').precisionCalculate(QDOODetails['discountAmount']/QDOODetails['QDOO']);
		return averageDiscountAmount;
	}
	
	public numeric function getAveragePriceSold(required string stockID, required string currencyCode){
		 
		var hql = "SELECT NEW MAP(
							COALESCE( sum(orderDeliveryItem.quantity), 0 ) as QDOO, 
							COALESCE( sum(orderDeliveryItem.orderItem.calculatedExtendedPrice),0) as totalEarned 
						) 
						FROM
							SlatwallOrderDeliveryItem orderDeliveryItem
						LEFT JOIN
					  		orderDeliveryItem.orderItem orderItem
					  	LEFT JOIN
					  		orderItem.sku sku
					  	LEFT JOIN
					  		sku.stocks stocks
					  		
						WHERE
							orderDeliveryItem.orderItem.order.orderStatusType.systemCode NOT IN ('ostNotPlaced','ostCanceled')
						  AND
						  	orderDeliveryItem.orderItem.orderItemType.systemCode = 'oitSale'
						  AND 
						  	orderDeliveryItem.orderItem.currencyCode = :currencyCode
						  AND 
							stocks.stockID = :stockID
						GROUP BY stocks.stockID
						";
		var QDOODetails = ormExecuteQuery(hql, {stockID=arguments.stockID, currencyCode=arguments.currencyCode},true);	
		
		if(isNull(QDOODetails) || QDOODetails['QDOO']==0){
			return 0;
		}
		var averagePriceSold = getService('hibachiUtilityService').precisionCalculate(QDOODetails['totalEarned']/QDOODetails['QDOO']);
		return averagePriceSold;
	}
	
	public any function getAverageCost(required string stockID, required string currencyCode, string locationID=""){
		var stock = getService('stockService').getStock(arguments.stockID);
		if(isNull(stock)){
			return 0;
		}
		return val(stock.getAverageCost());
	}

	public any function getStockAdjustmentMaxReferenceNumber() { 
		var query = new Query();
		query.setSQL("SELECT COALESCE(max(COALESCE(referenceNumber,0)), 0) as maxReferenceNumber FROM swStockAdjustment;");
		var queryResult = query.execute();
		return queryResult.getResult().getRow(1);
 	}
	
	public any function getAverageLandedCost(required string stockID, required string currencyCode, string locationID=""){
		var params = {stockID=arguments.stockID,currencyCode=arguments.currencyCode};
		
		var hql = 'SELECT COALESCE(SUM(i.landedCost*i.quantityIn)/SUM(i.quantityIn),0)
			FROM SlatwallInventory i 
			LEFT JOIN i.stock stock
		';
			
		if(len(arguments.locationID)){
			hql &= ' LEFT JOIN stock.location location ';
		}
		hql &= ' WHERE stock.stockID = :stockID AND i.landedCost IS NOT NULL AND i.currencyCode=:currencyCode ';
		
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
		
		public any function getAverageProfit(required string stockID, required string currencyCode){
			return getService('hibachiUtilityService').precisionCalculate(getAveragePriceSold(argumentCollection=arguments) - getAverageCost(argumentCollection=arguments));
		}
		
		public any function getAverageLandedProfit(required string stockID, required string currencyCode){
			return getService('hibachiUtilityService').precisionCalculate(getAveragePriceSold(argumentCollection=arguments) - getAverageLandedCost(argumentCollection=arguments));
		}
		
		public any function getAverageMarkup(required string stockID, required string currencyCode){
			var averagePriceSold = getAveragePriceSold(argumentCollection=arguments);
			var averageCost = getAverageCost(argumentCollection=arguments);
			if(averageCost == 0){
				return 0;
			}
			
			return getService('hibachiUtilityService').precisionCalculate(((averagePriceSold-averageCost)/averageCost)*100);
		}
		
		public any function getAverageLandedMarkup(required string stockID, required string currencyCode){
			var averagePriceSold = getAveragePriceSold(argumentCollection=arguments);
			var averageLandedCost = getAverageLandedCost(argumentCollection=arguments);
			if(averageLandedCost == 0){
				return 0;
			}
			return getService('hibachiUtilityService').precisionCalculate(((averagePriceSold-averageLandedCost)/averageLandedCost)*100);
		}
		
		public any function getStockBySkuAndLocation(required any sku, required any location) {
			return entityLoad("SlatwallStock", {location=arguments.location, sku=arguments.sku}, true);
		}
		
		public any function findStockBySkuIDAndLocationID(required string skuID, required string locationID) {
			var params = {skuID=arguments.skuID, locationID=arguments.locationID};
			var q= "FROM SlatwallStock where sku.skuID = :skuID AND location.locationID= :locationID";
			return ormExecuteQuery(q, params, true);
		}
		
		public any function getStockAdjustmentItemForSku(required any sku, required any stockAdjustment) {
			var params = [arguments.sku.getSkuID(), arguments.stockAdjustment.getStockAdjustmentID()];
			
		 	// Epic hack. In order to find the stockAdjustment Item for this Sku, we don't know if it will be in the fromStock or toStock, so try them both.
			var hql = " SELECT i
						FROM SlatwallStockAdjustmentItem i
						WHERE i.fromStock.sku.skuID = ? 
						AND i.stockAdjustment.stockAdjustmentID = ? ";
		
			var stockAdjustmentItem =  ormExecuteQuery(hql, params, true);
			
			if(!isNull(stockAdjustmentItem)) {
				return stockAdjustmentItem;
			}
			
			var hql = " SELECT i
						FROM SlatwallStockAdjustmentItem i
						WHERE i.toStock.sku.skuID = ? 
						AND i.stockAdjustment.stockAdjustmentID = ? ";
		
			var stockAdjustmentItem = ormExecuteQuery(hql, params, true);
			
			if(!isNull(stockAdjustmentItem)) {
				return stockAdjustmentItem;
			} else {
				// Return void
				return;
			}
	
		}
		
		public array function getEstimatedReceival(required string productID) {
			var params = [arguments.productID];
			
			var hql = "SELECT NEW MAP(
							vendorOrder.estimatedReceivalDateTime as orderEstimatedReceival,
							vendorOrderItem.estimatedReceivalDateTime as orderItemEstimatedReceival,
							vendorOrderItem.quantity as orderedQuantity,
							(SELECT coalesce( sum(stockReceiverItem.quantity), 0 ) FROM SlatwallStockReceiverItem stockReceiverItem WHERE stockReceiverItem.vendorOrderItem.vendorOrderItemID = vendorOrderItem.vendorOrderItemID) as receivedQuantity,
							vendorOrderItem.stock.sku.skuID as skuID,
							vendorOrderItem.stock.stockID as stockID,
							vendorOrderItem.stock.location.locationID as locationID,
							vendorOrderItem.stock.sku.product.productID as productID)
						FROM
							SlatwallVendorOrderItem vendorOrderItem
						  INNER JOIN
						  	vendorOrderItem.vendorOrder vendorOrder
						  INNER JOIN
						  	vendorOrderItem.stock stock
						  INNER JOIN
						  	stock.sku sku
						  INNER JOIN
						  	sku.product product
						WHERE
							vendorOrder.vendorOrderStatusType.systemCode != 'vostClosed'
						  AND
						  	vendorOrder.vendorOrderType.systemCode = 'votPurchaseOrder'
						  AND
							product.productID = ?
						  AND
						  	(vendorOrderItem.estimatedReceivalDateTime IS NOT NULL OR vendorOrder.estimatedReceivalDateTime IS NOT NULL)
						  AND
							(SELECT coalesce( sum(sri.quantity), 0 ) FROM SlatwallStockReceiverItem sri INNER JOIN sri.vendorOrderItem voi WHERE voi.vendorOrderItemID = vendorOrderItem.vendorOrderItemID) < vendorOrderItem.quantity
						";
			
			return ormExecuteQuery(hql, params);
		}
	
	</cfscript>
</cfcomponent>