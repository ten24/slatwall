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
	
	<cfscript>
		
		// Quantity on hand. Physically at any location
		public array function getQOH(required string productID, string productRemoteID) {
			var params = [arguments.productID];
			
			var hql = "SELECT NEW MAP(coalesce( sum(inventory.quantityIn), 0 ) - coalesce( sum(inventory.quantityOut), 0 ) as QOH, 
							sku.skuID as skuID, 
							stock.stockID as stockID, 
							location.locationID as locationID, 
							location.locationIDPath as locationIDPath)
						FROM
							SlatwallInventory inventory
							LEFT JOIN inventory.stock stock
							LEFT JOIN stock.sku sku
							LEFT JOIN stock.location location
						WHERE
							sku.product.productID = ?
						GROUP BY
							sku.skuID,
							stock.stockID,
							location.locationID,
							location.locationIDPath";
			
			return ormExecuteQuery(hql, params);
		}
		
		// Quantity On Sales Hold
		public numeric function getQOSH(required string productID, string productRemoteID) {
			// TODO: Setup Sales Hold
			return 0;
		}
		
		// Quantity Not Delivered on Order 
		public array function getQNDOO(required string productID, string productRemoteID) {
			var params = { productID = arguments.productID };
			
			var orderItemQuantityHql = "SELECT COALESCE(sum(orderItem.quantity),0)
									FROM SlatwallOrderItem orderItem
									WHERE
										orderItem.order.orderStatusType.systemCode NOT IN ('ostNotPlaced','ostClosed','ostCanceled')
						  			AND
						  				orderItem.orderItemType.systemCode = 'oitSale'
						  			AND 
										orderItem.sku.product.productID = :productID
									";
			var orderItemQuantitySum = ORMExecuteQuery(orderItemQuantityHql,params,true);								
			
			var hql = "SELECT NEW MAP(
									
								:orderItemQuantitySum
								
								- coalesce( sum(orderDeliveryItem.quantity), 0 ) as QNDOO, 
							orderItem.sku.skuID as skuID, 
							stock.stockID as stockID, 
							location.locationID as locationID, 
							location.locationIDPath as locationIDPath)
						FROM
							SlatwallOrderItem orderItem
						  LEFT JOIN
					  		orderItem.orderDeliveryItems orderDeliveryItem
					  	  LEFT JOIN
					  	  	orderItem.stock stock
					  	  LEFT JOIN 
					  	  	stock.location location
						WHERE
							orderItem.order.orderStatusType.systemCode NOT IN ('ostNotPlaced','ostClosed','ostCanceled')
						  AND
						  	orderItem.orderItemType.systemCode = 'oitSale'
						  AND 
							orderItem.sku.product.productID = :productID
						 
						GROUP BY
							orderItem.sku.skuID,
							stock.stockID,
							location.locationID,
							location.locationIDPath";
			return ormExecuteQuery(hql, {productID=arguments.productID,orderItemQuantitySum=orderItemQuantitySum});	
		}
		
		// Quantity not delivered on return vendor order 
		public numeric function getQNDORVO(required string productID, string productRemoteID) {
			// TODO: Impliment this later when we add return vendor orders
			return 0;
		}
		
		// Quantity not delivered on stock adjustment
		public array function getQNDOSA(required string productID, string productRemoteID) {
			
			var params = {productID=arguments.productID};
			
			var stockAdjustmentItemQuantityHql = "SELECT COALESCE(sum(stockAdjustmentItem.quantity),0)
									FROM SlatwallStockAdjustmentItem stockAdjustmentItem
										LEFT JOIN
										stockAdjustmentItem.fromStock fromStock
									WHERE
										stockAdjustmentItem.stockAdjustment.stockAdjustmentStatusType.systemCode != 'sastClosed'
									  AND
										fromStock.sku.product.productID = :productID
									";
			
			var stockAdjustmentItemQuantitySum = ORMExecuteQuery(stockAdjustmentItemQuantityHql,params,true);
			params['stockAdjustmentItemQuantitySum'] = stockAdjustmentItemQuantitySum;
			
			var hql = "SELECT NEW MAP(
					:stockAdjustmentItemQuantitySum
					- coalesce( sum(stockAdjustmentDeliveryItem.quantity), 0 ) as QNDOSA, 
						fromStock.sku.skuID as skuID, 
						fromStock.stockID as stockID, 
						location.locationID as locationID, 
						location.locationIDPath as locationIDPath)
					FROM
						SlatwallStockAdjustmentItem stockAdjustmentItem
					  LEFT JOIN
					  	stockAdjustmentItem.stockAdjustmentDeliveryItems stockAdjustmentDeliveryItem
					  LEFT JOIN
					  	stockAdjustmentItem.fromStock fromStock
					  LEFT JOIN
					  	fromStock.location location
					WHERE
						stockAdjustmentItem.stockAdjustment.stockAdjustmentStatusType.systemCode != 'sastClosed'
					  AND
						fromStock.sku.product.productID = :productID
					GROUP BY
						fromStock.sku.skuID,
						fromStock.stockID,
						location.locationID,
						location.locationIDPath";
			
			return ormExecuteQuery(hql, params);
		}
		
		// Quantity not received on return order
		public array function getQNRORO(required string productID, string productRemoteID) {
			
			var params = { productID=arguments.productID };
			var orderItemQuantityHQL = "SELECT COALESCE(sum(orderItem.quantity),0)
									FROM SlatwallOrderItem orderItem
									WHERE
										orderItem.order.orderStatusType.systemCode NOT IN ('ostNotPlaced','ostClosed','ostCanceled')
					 				 AND
					  					orderItem.orderItemType.systemCode = 'oitReturn'
					  				 AND
										orderItem.sku.product.productID = :productID
									";
			
			var orderItemQuantitySum = ORMExecuteQuery(orderItemQuantityHQL,params,true);
			params['orderItemQuantitySum'] = orderItemQuantitySum;
			
			var hql = "SELECT NEW MAP(
								:orderItemQuantitySum
								- coalesce( sum(stockReceiverItem.quantity), 0 ) as QNRORO, 
							orderItem.sku.skuID as skuID, 
							stock.stockID as stockID, 
							location.locationID as locationID, 
							location.locationIDPath as locationIDPath)
						FROM
							SlatwallOrderItem orderItem
						  LEFT JOIN
					  		orderItem.stockReceiverItems stockReceiverItem
					  	  LEFT JOIN
					  	  	orderItem.stock stock
					  	  LEFT JOIN
					  	  	stock.location location
						WHERE
							orderItem.order.orderStatusType.systemCode NOT IN ('ostNotPlaced','ostClosed','ostCanceled')
						  AND
						  	orderItem.orderItemType.systemCode = 'oitReturn'
						  AND
							orderItem.sku.product.productID = :productID
						GROUP BY
							orderItem.sku.skuID,
							stock.stockID,
							location.locationID,
							location.locationIDPath";
			return ormExecuteQuery(hql, params);
		}
		
		// Quantity not received on vendor order
		public array function getQNROVO(required string productID, string productRemoteID) {
			
			var params = {productID=arguments.productID};
			var vendorOrderItemQuantityHQL = "SELECT COALESCE(sum(vendorOrderItem.quantity),0)
								FROM SlatwallVendorOrderItem vendorOrderItem
									WHERE
										vendorOrderItem.vendorOrder.vendorOrderStatusType.systemCode != 'ostClosed'
							 		AND
							  			vendorOrderItem.vendorOrder.vendorOrderType.systemCode = 'votPurchaseOrder'
							  		AND
										vendorOrderItem.stock.sku.product.productID = :productID
									";
			
			var vendorOrderItemQuantitySum = ORMExecuteQuery(vendorOrderItemQuantityHQL,params,true);
			params['vendorOrderItemQuantitySum'] = vendorOrderItemQuantitySum;
			
			var hql = "SELECT NEW MAP(
							:vendorOrderItemQuantitySum 
							- coalesce( sum(stockReceiverItem.quantity), 0 ) as QNROVO, 
							stock.sku.skuID as skuID, 
							stock.stockID as stockID, 
							location.locationID as locationID, 
							location.locationIDPath as locationIDPath
						)
						FROM
							SlatwallVendorOrderItem vendorOrderItem
						  LEFT JOIN
					  		vendorOrderItem.stockReceiverItems stockReceiverItem
					  	  LEFT JOIN
					  	  	vendorOrderItem.stock stock
					  	  LEFT JOIN
					  	  	stock.location location
						WHERE
							vendorOrderItem.vendorOrder.vendorOrderStatusType.systemCode != 'ostClosed'
						  AND
						  	vendorOrderItem.vendorOrder.vendorOrderType.systemCode = 'votPurchaseOrder'
						  AND
							vendorOrderItem.stock.sku.product.productID = :productID
						GROUP BY
							stock.sku.skuID,
							stock.stockID,
							location.locationID,
							location.locationIDPath";
			
			return ormExecuteQuery(hql, params);
		}
		
		// Quantity not received on stock adjustment
		public array function getQNROSA(required string productID, string productRemoteID) {
			
			var params = {productID = arguments.productID };
			var stockAdjustmentItemQuantityHQL = "SELECT COALESCE(sum(stockAdjustmentItem.quantity),0)
									FROM 
										SlatwallStockAdjustmentItem stockAdjustmentItem
									  LEFT JOIN
										stockAdjustmentItem.toStock toStock
									WHERE
										stockAdjustmentItem.stockAdjustment.stockAdjustmentStatusType.systemCode != 'sastClosed'
						  			  AND 
										toStock.sku.product.productID = :productID
									";
			
			var stockAdjustmentItemQuantitySum = ORMExecuteQuery(stockAdjustmentItemQuantityHQL,params,true);
			params['stockAdjustmentItemQuantitySum'] = stockAdjustmentItemQuantitySum;
			
			var hql = "SELECT NEW MAP(
							:stockAdjustmentItemQuantitySum 
							- coalesce( sum(stockReceiverItem.quantity), 0 ) as QNROSA, 
							toStock.sku.skuID as skuID, 
							toStock.stockID as stockID, 
							location.locationID as locationID, 
							location.locationIDPath as locationIDPath)
						FROM
							SlatwallStockAdjustmentItem stockAdjustmentItem
						  LEFT JOIN
						  	stockAdjustmentItem.stockReceiverItems stockReceiverItem
						  LEFT JOIN
						  	stockAdjustmentItem.toStock toStock
						  LEFT JOIN
						  	toStock.location location
						WHERE
							stockAdjustmentItem.stockAdjustment.stockAdjustmentStatusType.systemCode != 'sastClosed'
						  AND 
							toStock.sku.product.productID = :productID
						GROUP BY
							toStock.sku.skuID,
							toStock.stockID,
							location.locationID,
							location.locationIDPath";
			
			return ormExecuteQuery(hql, params);
		}
		
		// Quantity received
		public numeric function getQR(string stockID, string skuID, string productID, string stockRemoteID, string skuRemoteID, string productRemoteID) {
			return 0;
		}
		
		// Quantity sold
		public numeric function getQS(string stockID, string skuID, string productID, string stockRemoteID, string skuRemoteID, string productRemoteID) {
			return 0;
		}
	</cfscript>

</cfcomponent>

