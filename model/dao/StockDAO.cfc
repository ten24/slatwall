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
		
		public any function getStockBySkuAndLocation(required any sku, required any location) {
			return entityLoad("SlatwallStock", {location=arguments.location, sku=arguments.sku}, true);
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
