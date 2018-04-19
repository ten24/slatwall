/*

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

*/
component extends="HibachiService" persistent="false" accessors="true" output="false" {
	
	property name="stockService";
	property name="typeService";
	property name="stockDAO";

	// ===================== START: Logical Methods ===========================
	
	public string function getAllActiveFulfillmentMethodIDList() {
		var returnList = "";
		var apmSL = this.getFulfillmentMethodSmartList();
		apmSL.addFilter('activeFlag', 1);
		apmSL.addSelect('fulfillmentMethodID', 'fulfillmentMethodID');
		var records = apmSL.getRecords();
		for(var i=1; i<=arrayLen(records); i++) {
			returnList = listAppend(returnList, records[i]['fulfillmentMethodID']);
		}
		return returnList;
	}
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	// Process: FulfillmentBatch
	public any function processFulfillmentBatch_create(required any fulfillmentBatch, required any processObject){
		
		//populate the fulfillmentbatch with the process data
		if (isNull(fulfillmentBatch.getAssignedAccount()) && !isNull(processObject.getAssignedAccount())){
			arguments.fulfillmentBatch.setAssignedAccount(processObject.getAssignedAccount());
		}
		
		//Set the description
		if (isNull(fulfillmentBatch.getDescription())){
			arguments.fulfillmentBatch.setDescription(processObject.getDescription());
		}
		
		//Set the name of the batch
		if (isNull(fulfillmentBatch.getFulfillmentBatchName())){
			arguments.fulfillmentBatch.setFulfillmentBatchName(processObject.getFulfillmentBatchName());
		}
		
		//If they are trying to pass fulfillments for the fulfillment batch.
		if (!isNull(processObject.getOrderFulfillmentIDList()) && len(processObject.getOrderFulfillmentIDList())){
			var batchItems = arguments.processObject.getFulfillmentBatchItemsByOrderFulfillmentIDList();
			for (var fulfillmentBatchItem in batchItems){
				fulfillmentBatchItem.setQuantityOnBatch(1);
				fulfillmentBatchItem.setQuantityFulfilled(0);
				fulfillmentBatchItem.setQuantityPicked(0);
				this.saveFulfillmentBatchItem(fulfillmentBatchItem);
				arguments.fulfillmentBatch.addFulfillmentBatchItem(fulfillmentBatchItem);
			}
		}
		
		//If they are trying to pass orderItems for the fulfillment batch.
		if (!isNull(processObject.getOrderItemIDList()) && len(processObject.getOrderItemIDList())){
			var batchItems = arguments.processObject.getFulfillmentBatchItemsByOrderItemIDList();
			for (var fulfillmentBatchItem in batchItems){
				fulfillmentBatchItem.setQuantityOnBatch(1);
				fulfillmentBatchItem.setQuantityFulfilled(0);
				fulfillmentBatchItem.setQuantityPicked(0);
				this.saveFulfillmentBatchItem(fulfillmentBatchItem);
				arguments.fulfillmentBatch.addFulfillmentBatchItem(fulfillmentBatchItem);
			}
		}
		
		//Generate the next fulfillmentBatch number
		arguments.fulfillmentBatch.setFulfillmentBatchNumber(this.getMaxFulfillmentBatchNumber());
		
		//Save the batch so we can add a many to many.
		this.saveFulfillmentBatch(arguments.fulfillmentBatch);
		
		//Add the locations
		if (!isNull(processObject.getLocations()) ){
			var locations = processObject.getLocations();
			for (var location in locations){
				arguments.fulfillmentBatch.addLocation(location);
			}
		}
		
		//Save the batch and return it.
		this.saveFulfillmentBatch(arguments.fulfillmentBatch);

		return arguments.fulfillmentBatch;
	}
	
	//This is only valid if there is only one batch location
	public any function processFulfillmentBatch_createStockTransfers(required any fulfillmentBatch){
		var batchLocation = arguments.fulfillmentBatch.getLocations()[1];
		var stockTransferData = {
			stockTransfers={},
			stockTransferItems={}
		};
		
		var fulfillmentBatchItems = arguments.fulfillmentBatch.getFulfillmentBatchItems();
		for(var fulfillmentBatchItem in fulfillmentBatchItems){
			//Handle Order Item fulfillment batch items
			if(!isNull(fulfillmentBatchItem.getOrderItem())){
				var orderItem = fulfillmentBatchItem.getOrderItem();
				var stock = getStockService().getStockBySkuIDAndLocationID(orderItem.getSku().getSkuID(),batchLocation.getLocationID());
				
				//If not enough quantity on hand at batch location, attempt to create transfer
				var qoh = stock.getQOH();
				if(qoh < orderItem.getQuantity()){
					stockTransferData = createStockAdjustmentDataForFulfillmentBatchItem(stockTransferData,orderItem,arguments.fulfillmentBatch);
				}
			//Handle Order Fulfillment fulfillment batch items
			}else if(!isNull(fulfillmentBatchItem.getOrderFulfillment())){
				var orderFulfillment = fulfillmentBatchItem.getOrderFulfillment();
				for(var orderFulfillmentItem in orderFulfillment.getOrderFulfillmentItems()){
					var stock = getStockService().getStockBySkuIDAndLocationID(orderFulfillmentItem.getSku().getSkuID(),batchLocation.getLocationID());
					
					//If not enough quantity on hand at batch location, attempt to create transfer
					var qoh = stock.getQOH();
					if(qoh < orderFulfillmentItem.getQuantity()){
						stockTransferData = createStockAdjustmentDataForFulfillmentBatchItem(stockTransferData,orderFulfillmentItem,arguments.fulfillmentBatch);
					}
				}
			}
		}
		for(var key in stockTransferData.stockTransferItems){
			getStockDAO().insertMinMaxTransferStockAjustmentItem(stockTransferData.stockTransferItems[key]);
		}
		return arguments.fulfillmentBatch;
	}
	
	public any function createStockAdjustmentDataForFulfillmentBatchItem(required struct stockTransferData, required any orderItem, required any fulfillmentBatch){
		var batchLocation = arguments.fulfillmentBatch.getLocations()[1];
		var stockTransfers = arguments.stockTransferData.stockTransfers;
		var stockTransferItems = arguments.stockTransferData.stockTransferItems;
		var sku = orderItem.getSku();
		var toStock = getStockService().getStockBySkuIDAndLocationID(sku.getSkuID(), batchLocation.getLocationID());
		var QOH = toStock.getQOH();
		//Find from stock by choosing sibling location to batch location that has QATS to support transfer
		var stock = getFromStock(stockTransferItems,orderItem,batchLocation, QOH);
		
		if(isNull(stock)){
			//Nowhere to transfer from
			return arguments.stockTransferData;
		}
		
		var stockLocation = stock.getLocation();
		
		// If we already have a transfer from this location, use it
		if(structKeyExists(stockTransfers,stockLocation.getLocationID())){
			var stockTransfer = stockTransfers[stockLocation.getLocationID()];
			
		//Else create a new one
		}else{
			var stockAdjustmentData = {};
			stockAdjustmentData.stockAdjustmentID = createHibachiUUID();
			stockAdjustmentData.fromLocationID = stockLocation.getLocationID();
			stockAdjustmentData.toLocationID = batchLocation.getLocationID();
			stockAdjustmentData.stockAdjustmentTypeID = getTypeService().getTypeBySystemCode("satLocationTransfer").getTypeID();
			stockAdjustmentData.stockAdjustmentStatusTypeID = getTypeService().getTypeBySystemCode("sastNew").getTypeID();
		   	stockAdjustmentData.timeStamp = now();
			stockAdjustmentData.administratorID = getSlatwallScope().getCurrentAccount().getAccountID();
			stockAdjustmentData.fulfillmentBatchID = arguments.fulfillmentBatch.getFulfillmentBatchID();
			getStockDAO().insertMinMaxTransferStockAjustment(stockAdjustmentData);
			stockTransfers[stockLocation.getLocationID()] = stockAdjustmentData;
			var stockTransfer = stockAdjustmentData;
		}
		
		//If we already have a stock transfer item for this sku from this location, use it and add the additional quantity needed
		var transferItemRef = '#sku.getSkuID()##stockLocation.getLocationID()#';
		if(structKeyExists(stockTransferItems, transferItemRef)){
			var item = stockTransferItems[transferItemRef];
			item.quantity += arguments.orderItem.getQuantity();
			
		//Else create a new one and transfer whatever additional quantity we don't have at the batch location
		}else{
			var stockAdjustmentItemData = {};
			stockAdjustmentItemData.stockAdjustmentItemID = createHibachiUUID();
			stockAdjustmentItemData.stockAdjustmentID = stockTransfer.stockAdjustmentID;
			stockAdjustmentItemData.quantity =  arguments.orderItem.getQuantity() - Max(0,QOH);
			stockAdjustmentItemData.currencyCode = stockLocation.getCurrencyCode();
			stockAdjustmentItemData.cost = stock.getAverageCost();
			stockAdjustmentItemData.fromStockID = stock.getStockID();
			stockAdjustmentItemData.toStockID = getStockService().getStockBySkuIDAndLocationID(stock.getSku().getSkuID(),batchLocation.getLocationID()).getStockID();
			stockAdjustmentItemData.skuID = stock.getSku().getSkuID();
		   	stockAdjustmentItemData.timeStamp = now();
			stockAdjustmentItemData.administratorID = getSlatwallScope().getCurrentAccount().getAccountID();
			stockTransferItems[transferItemRef] = stockAdjustmentItemData;
		}
		return arguments.stockTransferData;
	}
	
	private any function getFromStock(required struct stockTransferItems, required any orderItem, required any toLocation, required numeric QOH){
		var sku = arguments.orderItem.getSku();
		var parentLocation = arguments.toLocation.getParentLocation();
		//Nowhere to transfer from
		if(isNull(parentLocation)){
			return;
		}
		var locationsToChoose = parentLocation.getChildLocations();
		for(var location in locationsToChoose){
			//Don't use batch location
			if(location.getLocationID() == arguments.toLocation.getLocationID()){
				continue;
			}
			var stock = getStockService().getStockBySkuIDAndLocationID(sku.getSkuID(),location.getLocationID());
			//Requires full order item quantity plus quantity of existing transfer item if adding onto existing transfer item
			var transferItemRef = '#sku.getSkuID()##location.getLocationID()#';
			if(structKeyExists(stockTransferItems, transferItemRef)){
				var item = stockTransferItems[transferItemRef];
				if(stock.getQATS() >= arguments.orderItem.getQuantity() + item.quantity){
					return stock;
				}
			//Otherwise only requires what is needed in addition to existing stock
			}else if(stock.getQATS() >= (arguments.orderItem.getQuantity() - arguments.QOH)){
				return stock;
			}
		}
		
	}
	
	public any function getMaxFulfillmentBatchNumber(){
		var maxFulfillmentBatchNumber = ormExecuteQuery("SELECT max(cast(aslatwallfulfillmentbatch.fulfillmentBatchNumber as int)) as maxFulfillmentBatchNumber FROM SlatwallFulfillmentBatch aslatwallfulfillmentbatch");
		if( arrayIsDefined(maxFulfillmentBatchNumber,1) ){
			return maxFulfillmentBatchNumber[1] + 1;
		} else {
			return 1;
		}
	}
	
	// Stub: FulfillmentBatch Auto fulfill all fulfillment batch items
	public any function autoFulfill(required any fulfillmentBatch){
		
		var fulfillmentBatchItems = fulfillmentBatch.getFulfillmentBatchItems();
		for (var fulfillmentbatchItem in fulfillmentBatchItems){
			//fulfill.
		}
		return processObject.getFulfillmentBatch();
	}
	// =====================  END: Process Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================

}
