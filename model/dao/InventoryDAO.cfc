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
		
		//Quantity on Order
		public array function getQOO(required string productID, string productRemoteID){
			var params = { productID = arguments.productID };
			var hql = "SELECT NEW MAP(
							COALESCE(sum(orderItem.quantity),0) as QOO, 
							orderItem.sku.skuID as skuID, 
							stock.stockID as stockID, 
							location.locationID as locationID, 
							location.locationIDPath as locationIDPath
						)
						FROM SlatwallOrderItem orderItem
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
						location.locationIDPath
					  	 ";
			var QOO = ORMExecuteQuery(hql,params);	
			return QOO;
		}	
		
		//Quantity Delivered on Order
		public array function getQDOO(required string productID, string productRemoteID){
			var hql = "SELECT NEW MAP(
							coalesce( sum(orderDeliveryItem.quantity), 0 ) as QDOO, 
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
			var QDOO = ormExecuteQuery(hql, {productID=arguments.productID});	
			return QDOO;
		}	
		
		// Quantity Not Delivered on Order 
		public array function getQNDOO(required string productID, string productRemoteID) {
			var QNDOO = [];
			
			var params = { productID = arguments.productID };
			
			var QDOO = getQDOO(productID=arguments.productID);
			var QDOOHashMap = {};
			for(var i=1;i <= arrayLen(QDOO);i++){
				QDOOHashMap["#QDOO[i]['skuID']#"] = QDOO[i]; 
			}
			
			var QOO = getQOO(productID=arguments.productID);
			
			for(var QOOData in QOO){
				var record = {};
				record['skuID'] = QOOData['skuID'];
				if(structKeyExists(QOOData,'stockID')){
					record['stockID'] = QOOData['stockID'];
				}else{
					record['stockID'] = javacast('null','');
				}
				if(structKeyExists(QOOData,'locationID')){
					record['locationID'] = QOOData['locationID'];	
				}else{
					record['locationID'] = javacast('null','');
				}
				if(structKeyExists(QOOData,'locationIDPath')){
					record['locationIDPath'] = QOOData['locationIDPath'];
				}else{
					record['locationIDPath'] = javacast('null','');
				}
				var quantityReceived = 0;
				if(structKeyExists(QDOOHashMap,'#QOOData['skuID']#')){
					quantityReceived = QDOOHashMap['#QOOData['skuID']#']['QDOO'];
				}
				record['QNDOO'] = QOOData['QOO'] - quantityReceived;
				arrayAppend(QNDOO,record);
			}
			
			
			return QNDOO;	
		}
		
		// Quantity not delivered on return vendor order 
		public numeric function getQNDORVO(required string productID, string productRemoteID) {
			// TODO: Impliment this later when we add return vendor orders
			return 0;
		}
		
		//Quantity delivered on stock adjustment
		public array function getQDOSA(required string productID, string productRemoteID) {
			var params = {productiD=arguments.productID};
			var hql = "SELECT NEW MAP(
					coalesce( sum(stockAdjustmentDeliveryItem.quantity), 0 ) as QDOSA, 
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
		//Quantity on stock adjustment
		public array function getQOSA(required string productID, string direction) {
			var params = {productID=arguments.productID};
			var stockDirection = "#arguments.direction#Stock";
			var stockAdjustmentItemQuantityHql = "SELECT NEW MAP(
								COALESCE(sum(stockAdjustmentItem.quantity),0) as QOSA,
								#stockDirection#.sku.skuID as skuID, 
								#stockDirection#.stockID as stockID, 
								location.locationID as locationID, 
								location.locationIDPath as locationIDPath
							)
							FROM SlatwallStockAdjustmentItem stockAdjustmentItem
								 LEFT JOIN
								  	stockAdjustmentItem.#stockDirection# #stockDirection#
								  LEFT JOIN
								  	#stockDirection#.location location
							WHERE
								stockAdjustmentItem.stockAdjustment.stockAdjustmentStatusType.systemCode != 'sastClosed'
							  AND
								#stockDirection#.sku.product.productID = :productID
							GROUP BY
								#stockDirection#.sku.skuID,
								#stockDirection#.stockID,
								location.locationID,
								location.locationIDPath
									";
			
			return ORMExecuteQuery(stockAdjustmentItemQuantityHql,params);
		}
		// Quantity not delivered on stock adjustment
		public array function getQNDOSA(required string productID, string productRemoteID) {
			var QNDOSA = [];
			
			var QDOSA = getQDOSA(productID=arguments.productID);
			var QDOSAHashMap = {};
			for(var i=1;i <= arrayLen(QDOSA);i++){
				QDOSAHashMap["#QDOSA[i]['skuID']#"] = QDOSA[i]; 
			}
			
			var QOSA = getQOSA(productID=arguments.productID,direction='from');
			for(var QOSAData in QOSA){
				var record = {};
				record['skuID'] = QOSAData['skuID'];
				if(structKeyExists(QOSAData,'stockID')){
					record['stockID'] = QOSAData['stockID'];
				}else{
					record['stockID'] = javacast('null','');
				}
				if(structKeyExists(QOSAData,'locationID')){
					record['locationID'] = QOSAData['locationID'];
				}else{
					record['locationID'] = javacast('null','');
				}
				if(structKeyExists(QOSAData,'locationIDPath')){
					record['locationIDPath'] = QOSAData['locationIDPath'];	
				}else{
					record['locationIDPath'] = javacast('null','');
				}
				
				var quantityReceived = 0;
				if(structKeyExists(QDOSAHashMap,'#QOSAData['skuID']#')){
					quantityReceived = QDOSAHashMap['#QOSAData['skuID']#']['QDOSA'];
				}
				record['QNDOSA'] = QOSAData['QOSA'] - quantityReceived;
				arrayAppend(QNDOSA,record);
			}
			
			return QNDOSA;
		}
		//Quantity Received on return order
		public array function getQRORO(required string productID, string productRemoteID){
			var params = {productID=arguments.productID};			
			var hql = "SELECT NEW MAP(
							coalesce( sum(stockReceiverItem.quantity), 0 ) as QRORO, 
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
		//Quantity on return order
		public array function getQORO(required string productID, string productRemoteID){
			var params = { productID=arguments.productID };
			var orderItemQuantityHQL = "SELECT New Map(COALESCE(sum(orderItem.quantity),0) as QORO,
										orderItem.sku.skuID as skuID, 
										stock.stockID as stockID, 
										location.locationID as locationID, 
										location.locationIDPath as locationIDPath)
									FROM SlatwallOrderItem orderItem
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
									location.locationIDPath
									";
			
			return ORMExecuteQuery(orderItemQuantityHQL,params);
		}
		
		// Quantity not received on return order
		public array function getQNRORO(required string productID, string productRemoteID) {
			var QNRORO = [];
			
			var QRORO = getQRORO(productID=arguments.productID);
			var QROROHashMap = {};
			for(var i=1;i <= arrayLen(QRORO);i++){
				QROROHashMap["#QRORO[i]['skuID']#"] = QRORO[i]; 
			}
			
			var QORO = getQORO(productID=arguments.productID);
			for(var QOROData in QORO){
				var record = {};
				record['skuID'] = QOROData['skuID'];
				if(structKeyExists(QOROData,'stockID')){
					record['stockID'] = QOROData['stockID'];
				}else{
					record['stockID'] = javacast('null','');
				}
				if(structKeyExists(QOROData,'locationID')){
					record['locationID'] = QOROData['locationID'];
				}else{
					record['locationID'] = javacast('null','');
				}
				if(structKeyExists(QOROData,'locationIDPath')){
					record['locationIDPath'] = QOROData['locationIDPath'];
				}else{
					record['locationIDPath'] = javacast('null','');
				}
				var quantityReceived = 0;
				if(structKeyExists(QROROHashMap,'#QOROData['skuID']#')){
					quantityReceived = QROROHashMap['#QOROData['skuID']#']['QRORO'];
				}
				record['QNRORO'] = QOROData['QORO'] - quantityReceived;
				arrayAppend(QNRORO,record);
			}
			
			return QNRORO;
		}
		
		public array function getQROVO(required string productID, string productRemoteID){
			
			var params = {productID=arguments.productID};
			var hql = "SELECT NEW MAP(
							coalesce( sum(stockReceiverItem.quantity), 0 ) as QROVO, 
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
					  	  LEFT JOIN 
					  	  	stock.sku sku
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
		
		public array function getQOVO(required string productID, string productRemoteID) {
				
			var params = {productID=arguments.productID};
			var hql = "SELECT NEW MAP(
							sum(vendorOrderItem.quantity) as QOVO, 
							stock.sku.skuID as skuID, 
							stock.stockID as stockID, 
							location.locationID as locationID, 
							location.locationIDPath as locationIDPath
						)
						FROM
							SlatwallVendorOrderItem vendorOrderItem
					  	  LEFT JOIN
					  	  	vendorOrderItem.stock stock
					  	  LEFT JOIN
					  	  	stock.location location
					  	  LEFT JOIN 
					  	  	stock.sku sku
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
		
		// Quantity not received on vendor order
		public array function getQNROVO(required string productID, string productRemoteID) {
			var QROVO = getQROVO(productID=arguments.productID);
			var QROVOHashMap = {};
			for(var i=1;i <= arrayLen(QROVO);i++){
				QROVOHashMap["#QROVO[i]['skuID']#"] = QROVO[i]; 
			}
			var QNROVO = [];
			
			var QOVO = getQOVO(productID=arguments.productID);
			for(var QOVOData in QOVO){
				var record = {};
				record['skuID'] = QOVOData['skuID'];
				if(structKeyExists(QOVOData,'stockID')){
					record['stockID'] = QOVOData['stockID'];
				}else{
					record['stockID'] = javacast('null','');
				}
				if(structKeyExists(QOVOData,'locationID')){
					record['locationID'] = QOVOData['locationID'];
				}else{
					record['locationID'] = javacast('null','');
				}
				if(structKeyExists(QOVOData,'locationIDPath')){
					record['locationIDPath'] = QOVOData['locationIDPath'];
				}else{
					record['locationIDPath'] = javacast('null','');
				}
				
				var quantityReceived = 0;
				if(structKeyExists(QROVOHashMap,'#QOVOData['skuID']#')){
					quantityReceived = QROVOHashMap['#QOVOData['skuID']#']['QROVO'];
				}
				record['QNROVO'] = QOVOData['QOVO'] - quantityReceived;
				arrayAppend(QNROVO,record);
			}
			return QNROVO;
		}
		
		//Quantity received on stock adjustment
		
		public array function getQROSA(required string productID, string productRemoteID) {
			var params = {productID = arguments.productID };
			var hql = "SELECT NEW MAP(
							coalesce( sum(stockReceiverItem.quantity), 0 ) as QROSA, 
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
		
		// Quantity not received on stock adjustment
		public array function getQNROSA(required string productID, string productRemoteID) {
			
			var QNROSA = [];
			
			var QROSA = getQROSA(productID=arguments.productID);
			var QROSAHashMap = {}; 
			for(var i=1;i <= arrayLen(QROSA);i++){
				QROSAHashMap["#QROSA[i]['skuID']#"] = QROSA[i]; 
			}
			
			var QOSA = getQOSA(productID=arguments.productID,direction='to');
			for(var QOSAData in QOSA){
				var record = {};
				record['skuID'] = QOSAData['skuID'];
				if(structKeyExists(QOSAData,'stockID')){
					record['stockID'] = QOSAData['stockID'];
				}else{
					record['stockID'] = javacast('null','');
				}
				if(structKeyExists(QOSAData,'locationID')){
					record['locationID'] = QOSAData['locationID'];
				}else{
					record['locationID'] = javacast('null','');
				}
				if(structKeyExists(QOSAData,'locationIDPath')){
					record['locationIDPath'] = QOSAData['locationIDPath'];					
				}else{
					record['locationIDPath'] = javacast('null','');
				}
				var quantityReceived = 0;
				if(structKeyExists(QROSAHashMap,'#QOSAData['skuID']#')){
					quantityReceived = QROSAHashMap['#QOSAData['skuID']#']['QROSA'];
				}
				record['QNROSA'] = QOSAData['QOSA'] - quantityReceived;
				arrayAppend(QNROSA,record);
			}
			
			return QNROSA;
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

