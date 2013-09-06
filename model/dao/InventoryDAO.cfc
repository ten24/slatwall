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
			
			var hql = "
					SELECT 
						NEW MAP(coalesce( sum(inventory.quantityIn), 0 ) - coalesce( sum(inventory.quantityOut), 0 ) as QOH, 
						inventory.stock.sku.skuID as skuID, 
						inventory.stock.stockID as stockID, 
						inventory.stock.location.locationID as locationID, 
						inventory.stock.location.locationIDPath as locationIDPath)
					FROM
						SlatwallInventory inventory
					WHERE
						inventory.stock.sku.product.productID = ?
					GROUP BY
						inventory.stock.sku.skuID,
						inventory.stock.stockID,
						inventory.stock.location.locationID,
						inventory.stock.location.locationIDPath";
						
			
			return ormExecuteQuery(hql, params);
		}
		
		// Quantity On Sales Hold
		public numeric function getQOSH(required string productID, string productRemoteID) {
			// TODO: Setup Sales Hold
			return 0;
		}
		
		// Quantity Not Delivered on Order 
		public array function getQNDOO(required string productID, string productRemoteID) {
			
			var params = [ arguments.productID ];
			var hql = "
					SELECT 
						NEW MAP(coalesce( sum(orderItem.quantity), 0 ) - coalesce( sum(orderDeliveryItem.quantity), 0 ) as QNDOO, 
						orderItem.sku.skuID as skuID, 
						stock.stockID as stockID, 
						stock.location.locationID as locationID, 
						stock.location.locationIDPath as locationIDPath)
					FROM
						SlatwallOrderItem orderItem
					  LEFT JOIN
				  		orderItem.orderDeliveryItems orderDeliveryItem
				  	  LEFT JOIN
				  	  	orderItem.stock stock
					WHERE
						orderItem.order.orderStatusType.systemCode != 'ostNotPlaced'
					  AND
					    orderItem.order.orderStatusType.systemCode != 'ostClosed'
					  AND
					  	orderItem.orderItemType.systemCode = 'oitSale'
					  AND 
						orderItem.sku.product.productID = ?
					GROUP BY
						orderItem.sku.skuID,
						stock.stockID,
						stock.location.locationID,
						stock.location.locationIDPath";
			
			return ormExecuteQuery(hql, params);
			
		}
		
		// Quantity not delivered on return vendor order 
		public numeric function getQNDORVO(required string productID, string productRemoteID) {
			// TODO: Impliment this later when we add return vendor orders
			return 0;
		}
		
		// Quantity not delivered on stock adjustment
		public array function getQNDOSA(required string productID, string productRemoteID) {
			
			var params = [ arguments.productID ];
			var hql = "
				SELECT 
					NEW MAP(coalesce( sum(stockAdjustmentItem.quantity), 0 ) - coalesce( sum(stockAdjustmentDeliveryItem.quantity), 0 ) as QNDOSA, 
					stockAdjustmentItem.fromStock.sku.skuID as skuID, 
					stockAdjustmentItem.fromStock.stockID as stockID, 
					stockAdjustmentItem.fromStock.location.locationID as locationID, 
					stockAdjustmentItem.fromStock.location.locationIDPath as locationIDPath)
				FROM
					SlatwallStockAdjustmentItem stockAdjustmentItem
				  LEFT JOIN
				  	stockAdjustmentItem.stockAdjustmentDeliveryItems stockAdjustmentDeliveryItem
				WHERE
					stockAdjustmentItem.stockAdjustment.stockAdjustmentStatusType.systemCode != 'sastClosed'
				  AND
					stockAdjustmentItem.fromStock.sku.product.productID = ?
				GROUP BY
					stockAdjustmentItem.fromStock.sku.skuID,
					stockAdjustmentItem.fromStock.stockID,
					stockAdjustmentItem.fromStock.location.locationID,
					stockAdjustmentItem.fromStock.location.locationIDPath";
			
			return ormExecuteQuery(hql, params);
		}
		
		// Quantity not received on return order
		public array function getQNRORO(required string productID, string productRemoteID) {
			
			var params = [ arguments.productID ];
			var hql = "
					SELECT 
						NEW MAP(coalesce( sum(orderItem.quantity), 0 ) - coalesce( sum(stockReceiverItem.quantity), 0 ) as QNRORO, 
						orderItem.sku.skuID as skuID, stock.stockID as stockID, 
						stock.location.locationID as locationID, 
						stock.location.locationIDPath)
					FROM
						SlatwallOrderItem orderItem
					  LEFT JOIN
				  		orderItem.stockReceiverItems stockReceiverItem
				  	  LEFT JOIN
				  	  	orderItem.stock stock
					WHERE
						orderItem.order.orderStatusType.systemCode != 'ostNotPlaced'
					  AND
					    orderItem.order.orderStatusType.systemCode != 'ostClosed'
					  AND
					  	orderItem.orderItemStatusType.systemCode = 'oitReturn'
					  AND
						orderItem.sku.product.productID = ?
					GROUP BY
						orderItem.sku.skuID,
						stock.stockID,
						stock.location.locationID,
						stock.location.locationIDPath";
				
			return ormExecuteQuery(hql, params);
		}
		
		// Quantity not received on vendor order
		public array function getQNROVO(required string productID, string productRemoteID) {
			
			var params = [ arguments.productID ];
			var hql = "
					SELECT 
						NEW MAP(coalesce( sum(vendorOrderItem.quantity), 0 ) - coalesce( sum(stockReceiverItem.quantity), 0 ) as QNROVO, 
						vendorOrderItem.stock.sku.skuID as skuID, 
						vendorOrderItem.stock.stockID as stockID, 
						vendorOrderItem.stock.location.locationID as locationID, 
						vendorOrderItem.stock.location.locationIDPath as locationIDPath)
					FROM
						SlatwallVendorOrderItem vendorOrderItem
					  LEFT JOIN
				  		vendorOrderItem.stockReceiverItems stockReceiverItem
					WHERE
						vendorOrderItem.vendorOrder.vendorOrderStatusType.systemCode != 'ostClosed'
					  AND
					  	vendorOrderItem.vendorOrder.vendorOrderType.systemCode = 'votPurchaseOrder'
					  AND
						vendorOrderItem.stock.sku.product.productID = ?
					GROUP BY
						vendorOrderItem.stock.sku.skuID,
						vendorOrderItem.stock.stockID,
						vendorOrderItem.stock.location.locationID,
						vendorOrderItem.stock.location.locationIDPath";
			
			return ormExecuteQuery(hql, params);
		}
		
		// Quantity not received on stock adjustment
		public array function getQNROSA(required string productID, string productRemoteID) {
			
			var params = [ arguments.productID ];
			var hql = "
				SELECT 
					NEW MAP(coalesce( sum(stockAdjustmentItem.quantity), 0 ) - coalesce( sum(stockReceiverItem.quantity), 0 ) as QNROSA, 
					stockAdjustmentItem.toStock.sku.skuID as skuID, 
					stockAdjustmentItem.toStock.stockID as stockID, 
					stockAdjustmentItem.toStock.location.locationID as locationID, 
					stockAdjustmentItem.toStock.location.locationIDPath as locationIDPath)
				FROM
					SlatwallStockAdjustmentItem stockAdjustmentItem
				  LEFT JOIN
				  	stockAdjustmentItem.stockReceiverItems stockReceiverItem
				WHERE
					stockAdjustmentItem.stockAdjustment.stockAdjustmentStatusType.systemCode != 'sastClosed'
				  AND 
					stockAdjustmentItem.toStock.sku.product.productID = ?
				GROUP BY
					stockAdjustmentItem.toStock.sku.skuID,
					stockAdjustmentItem.toStock.stockID,
					stockAdjustmentItem.toStock.location.locationID,
					stockAdjustmentItem.toStock.location.locationIDPath";
			
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

