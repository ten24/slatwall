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
component extends="HibachiService" accessors="true" output="false" {

	// Injected Services
	property name="commentService" type="any";
	property name="locationService" type="any";
	property name="skuService" type="any";
	property name="settingService" type="any";
	property name="typeService" type="any";
	
	// Inject DAO's
	property name="stockDAO" type="any";
	
	public any function getStockBySkuAndLocation(required any sku, required any location){
		var stock = getStockDAO().getStockBySkuAndLocation(argumentCollection=arguments);
		
		if(isNull(stock)) {
			
			if(getSlatwallScope().hasValue("stock_#arguments.sku.getSkuID()#_#arguments.location.getLocationID()#")) {
				// Set the stock in the requestCache so that duplicates for this stock don't get created.
				stock = getSlatwallScope().getValue("stock_#arguments.sku.getSkuID()#_#arguments.location.getLocationID()#");
				
			} else {
				stock = this.newStock();
				stock.setSku(arguments.sku);
				stock.setLocation(arguments.location);
				getHibachiDAO().save(stock);
				
				// Set the stock in the requestCache so that duplicates for this stock don't get created.
				getSlatwallScope().setValue("stock_#arguments.sku.getSkuID()#_#arguments.location.getLocationID()#", stock);
				
			}
		}
		
		return stock;
	}
	
	public any function getStockAdjustmentItemForSku(required any sku, required any stockAdjustment){
		var stockAdjustmentItem = getStockDAO().getStockAdjustmentItemForSku(arguments.sku, arguments.stockAdjustment);
		
		if(isNull(stockAdjustmentItem)) {
			stockAdjustmentItem = this.newStockAdjustmentItem();
		}

		return stockAdjustmentItem;
	}
	
	public any function getEstimatedReceivalDetails(required string productID) {
		return createEstimatedReceivalDataStruct( getStockDAO().getEstimatedReceival(arguments.productID) );
	}
	
	private struct function createEstimatedReceivalDataStruct(required array receivalArray) {
		
		var returnStruct = {};
		var insertedAt = 0;
		
		returnStruct.locations = {};
		returnStruct.skus = {};
		returnStruct.stocks = {};
		returnStruct.estimatedReceivals = [];
		
		for(var i=1; i<=arrayLen(arguments.receivalArray); i++) {
			
			var skuID = arguments.receivalArray[i]["skuID"];
			var locationID = arguments.receivalArray[i]["locationID"];
			var stockID = arguments.receivalArray[i]["stockID"];
			
			// Setup the estimate data
			var data = {};
			data.quantity = arguments.receivalArray[i]["orderedQuantity"] - arguments.receivalArray[i]["receivedQuantity"];
			if(structKeyExists(arguments.receivalArray[i], "orderItemEstimatedReceival")) {
				data.estimatedReceivalDateTime = arguments.receivalArray[i]["orderItemEstimatedReceival"];	
			} else {
				data.estimatedReceivalDateTime = arguments.receivalArray[i]["orderEstimatedReceival"];	
			}
			
			// First do the product level addition
			inserted = false;
			for(var e=1; e<=arrayLen(returnStruct.estimatedReceivals); e++) {
				if(returnStruct.estimatedReceivals[e].estimatedReceivalDateTime eq data.estimatedReceivalDateTime) {
					returnStruct.estimatedReceivals[e].quantity += data.quantity;
					inserted = true;
					break;
				} else if (returnStruct.estimatedReceivals[e].estimatedReceivalDateTime gt data.estimatedReceivalDateTime) {
					arrayInsertAt(returnStruct.estimatedReceivals, e, duplicate(data));
					inserted = true;
					break;
				}
			}
			if(!inserted) {
				arrayAppend(returnStruct.estimatedReceivals, duplicate(data));
			}
			
			
			// Do the sku level addition
			if(!structKeyExists(returnStruct.skus, skuID)) {
				returnStruct.skus[ skuID ] = {};
				returnStruct.skus[ skuID ].locations = {};
				returnStruct.skus[ skuID ].estimatedReceivals = [];
			}
			inserted = false;
			for(var e=1; e<=arrayLen(returnStruct.skus[ skuID ].estimatedReceivals); e++) {
				if(returnStruct.skus[ skuID ].estimatedReceivals[e].estimatedReceivalDateTime eq data.estimatedReceivalDateTime) {
					returnStruct.skus[ skuID ].estimatedReceivals[e].quantity += data.quantity;
					inserted = true;
					break;
				} else if (returnStruct.skus[ skuID ].estimatedReceivals[e].estimatedReceivalDateTime gt data.estimatedReceivalDateTime) {
					arrayInsertAt(returnStruct.skus[ skuID ].estimatedReceivals, e, duplicate(data));
					inserted = true;
					break;
				}
			}
			if(!inserted) {
				arrayAppend(returnStruct.skus[ skuID ].estimatedReceivals, duplicate(data));
			}
			// Add the location break up to this sku
			if(!structKeyExists(returnStruct.skus[ skuID ].locations, locationID)) {
				returnStruct.skus[ skuID ].locations[ locationID ] = [];
			}
			inserted = false;
			for(var e=1; e<=arrayLen(returnStruct.skus[ skuID ].locations[ locationID ] ); e++) {
				if(returnStruct.skus[ skuID ].locations[ locationID ][e].estimatedReceivalDateTime eq data.estimatedReceivalDateTime) {
					returnStruct.skus[ skuID ].locations[ locationID ][e].quantity += data.quantity;
					inserted = true;
					break;
				} else if (returnStruct.skus[ skuID ].locations[ locationID ][e].estimatedReceivalDateTime gt data.estimatedReceivalDateTime) {
					arrayInsertAt(returnStruct.skus[ skuID ].locations[ locationID ], e, duplicate(data));
					inserted = true;
					break;
				}
			}
			if(!inserted) {
				arrayAppend(returnStruct.skus[ skuID ].locations[ locationID ], duplicate(data));
			}
			
			
			
			// Do the location level addition
			if(!structKeyExists(returnStruct.locations, locationID)) {
				returnStruct.locations[ locationID ] = [];
			}
			inserted = false;
			for(var e=1; e<=arrayLen(returnStruct.locations[ locationID ]); e++) {
				if(returnStruct.locations[ locationID ][e].estimatedReceivalDateTime eq data.estimatedReceivalDateTime) {
					returnStruct.locations[ locationID ][e].quantity += data.quantity;
					inserted = true;
					break;
				} else if (returnStruct.locations[ locationID ][e].estimatedReceivalDateTime gt data.estimatedReceivalDateTime) {
					arrayInsertAt(returnStruct.locations[ locationID ], e, duplicate(data));
					inserted = true;
					break;
				}
			}
			if(!inserted) {
				arrayAppend(returnStruct.locations[ locationID ], duplicate(data));
			}
			
			// Do the stock level addition
			if(!structKeyExists(returnStruct.stocks, stockID)) {
				returnStruct.stocks[ stockID ] = [];
			}
			inserted = false;
			for(var e=1; e<=arrayLen(returnStruct.stocks[ stockID ]); e++) {
				if(returnStruct.stocks[ stockID ][e].estimatedReceivalDateTime eq data.estimatedReceivalDateTime) {
					returnStruct.stocks[ stockID ][e].quantity += data.quantity;
					inserted = true;
					break;
				} else if (returnStruct.stocks[ stockID ][e].estimatedReceivalDateTime gt data.estimatedReceivalDateTime) {
					arrayInsertAt(returnStruct.stocks[ stockID ], e, duplicate(data));
					inserted = true;
					break;
				}
			}
			if(!inserted) {
				arrayAppend(returnStruct.stocks[ stockID ], duplicate(data));
			}
			
			
		}
		
		return returnStruct;
	}
	
	
	// ===================== START: Logical Methods ===========================
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	//Process: StockAdjustment Context: addItems 
	public any function processStockAdjustment_addItems(required any stockAdjustment, struct data={}, string processContext="process") {
	
		for(var i=1; i<=arrayLen(arguments.data.records); i++) {
			
			var thisRecord = arguments.data.records[i];
			
			if(val(thisRecord.quantity)) {
				
				var foundItem = false;
				var sku = getSkuService().getSku( thisRecord.skuid );
				
				if( listFindNoCase("satLocationTransfer,satManualOut", arguments.stockAdjustment.getStockAdjustmentType().getSystemCode()) ) {
					var fromStock = getStockBySkuAndLocation(sku, arguments.stockAdjustment.getFromLocation());	
				}
				if( listFindNoCase("satLocationTransfer,satManualIn", arguments.stockAdjustment.getStockAdjustmentType().getSystemCode()) ) {
					var toStock = getStockBySkuAndLocation(sku, arguments.stockAdjustment.getToLocation());
				}
				
				
				// Look for the orderItem in the vendorOrder
				for(var ai=1; ai<=arrayLen(arguments.stockAdjustment.getStockAdjustmentItems()); ai++) {
					// If the location, sku, cost & estimated arrival are already the same as an item on the order then we can merge them.  Otherwise seperate
					if( ( listFindNoCase("satLocationTransfer,satManualOut", arguments.stockAdjustment.getStockAdjustmentType().getSystemCode()) && arguments.stockAdjustment.getStockAdjustmentItems()[ai].getFromStock().getSku().getSkuID() == thisRecord.skuid )
						||
						( listFindNoCase("satLocationTransfer,satManualIn", arguments.stockAdjustment.getStockAdjustmentType().getSystemCode()) && arguments.stockAdjustment.getStockAdjustmentItems()[ai].getToStock().getSku().getSkuID() == thisRecord.skuid )
						) {
							
						foundItem = true;
						arguments.stockAdjustment.getStockAdjustmentItems()[ai].setQuantity( arguments.stockAdjustment.getStockAdjustmentItems()[ai].getQuantity() + int(thisRecord.quantity) );
					}
				}
				
				
				if(!foundItem) {
					
					var stockAdjustmentItem = this.newStockAdjustmentItem();
					stockAdjustmentItem.setQuantity( int(thisRecord.quantity) );
					if( listFindNoCase("satLocationTransfer,satManualOut", arguments.stockAdjustment.getStockAdjustmentType().getSystemCode()) ) {
						stockAdjustmentItem.setFromStock( fromStock );
					}
					if( listFindNoCase("satLocationTransfer,satManualIn", arguments.stockAdjustment.getStockAdjustmentType().getSystemCode()) ) {
						stockAdjustmentItem.setToStock( toStock );
					}
					stockAdjustmentItem.setStockAdjustment( arguments.stockAdjustment );
					
				}
				
			}
		}
		
		return arguments.stockAdjustment;
	}
	
	// Process: StockAdjustment
	public any function processStockAdjustment_addStockAdjustmentItem(required any stockAdjustment, required any processObject) {
		var foundItem = false;
		
		if( listFindNoCase("satLocationTransfer,satManualOut", arguments.stockAdjustment.getStockAdjustmentType().getSystemCode()) ) {
			var fromStock = getStockBySkuAndLocation(arguments.processObject.getSku(), arguments.stockAdjustment.getFromLocation());	
		}
		if( listFindNoCase("satLocationTransfer,satManualIn", arguments.stockAdjustment.getStockAdjustmentType().getSystemCode()) ) {
			var toStock = getStockBySkuAndLocation(arguments.processObject.getSku(), arguments.stockAdjustment.getToLocation());
		}
		
		
		// Look for the orderItem in the vendorOrder
		for(var ai=1; ai<=arrayLen(arguments.stockAdjustment.getStockAdjustmentItems()); ai++) {
			// If the location, sku, cost & estimated arrival are already the same as an item on the order then we can merge them.  Otherwise seperate
			if( ( listFindNoCase("satLocationTransfer,satManualOut", arguments.stockAdjustment.getStockAdjustmentType().getSystemCode()) && arguments.stockAdjustment.getStockAdjustmentItems()[ai].getFromStock().getSku().getSkuID() == arguments.processObject.getSku().getSkuID() )
				||
				( listFindNoCase("satLocationTransfer,satManualIn", arguments.stockAdjustment.getStockAdjustmentType().getSystemCode()) && arguments.stockAdjustment.getStockAdjustmentItems()[ai].getToStock().getSku().getSkuID() == arguments.processObject.getSku().getSkuID() )
				) {
					
				foundItem = true;
				arguments.stockAdjustment.getStockAdjustmentItems()[ai].setQuantity( arguments.stockAdjustment.getStockAdjustmentItems()[ai].getQuantity() + int(arguments.processObject.getQuantity()) );
			}
		}
		
		if(!foundItem) {
			
			var stockAdjustmentItem = this.newStockAdjustmentItem();
			stockAdjustmentItem.setQuantity( int(arguments.processObject.getQuantity()) );
			if( listFindNoCase("satLocationTransfer,satManualOut", arguments.stockAdjustment.getStockAdjustmentType().getSystemCode()) ) {
				stockAdjustmentItem.setFromStock( fromStock );
			}
			if( listFindNoCase("satLocationTransfer,satManualIn", arguments.stockAdjustment.getStockAdjustmentType().getSystemCode()) ) {
				stockAdjustmentItem.setToStock( toStock );
			}
			stockAdjustmentItem.setStockAdjustment( arguments.stockAdjustment );
			
		}
		
		return arguments.stockAdjustment;
	}
	
	public any function processStockAdjustment_processAdjustment(required any stockAdjustment) {
		
		// Incoming (Transfer or ManualIn)
		if( listFindNoCase("satLocationTransfer,satManualIn", arguments.stockAdjustment.getStockAdjustmentType().getSystemCode()) ) {
			
			var stockReceiver = this.newStockReceiver();
			stockReceiver.setReceiverType("stockAdjustment");
			stockReceiver.setStockAdjustment(arguments.stockAdjustment);
			
			for(var i=1; i <= arrayLen(arguments.stockAdjustment.getStockAdjustmentItems()); i++) {
				var stockAdjustmentItem = arguments.stockAdjustment.getStockAdjustmentItems()[i];
				var stockReceiverItem = this.newStockReceiverItem();
				stockReceiverItem.setStockReceiver( stockReceiver );
				stockReceiverItem.setStockAdjustmentItem( stockAdjustmentItem );
				stockReceiverItem.setQuantity(stockAdjustmentItem.getQuantity());
				stockReceiverItem.setCost(0);
				stockReceiverItem.setStock(stockAdjustmentItem.getToStock());
			}
			
			this.saveStockReceiver( stockReceiver );
		}
		
		// Outgoing (Transfer or ManualOut)
		if( listFindNoCase("satLocationTransfer,satManualOut", arguments.stockAdjustment.getStockAdjustmentType().getSystemCode()) ) {
			var stockAdjustmentDelivery = this.newStockAdjustmentDelivery();
			stockAdjustmentDelivery.setStockAdjustment(arguments.stockAdjustment);
			
			for(var i=1; i <= arrayLen(arguments.stockAdjustment.getStockAdjustmentItems()); i++) {
				var stockAdjustmentItem = arguments.stockAdjustment.getStockAdjustmentItems()[i];
				var stockAdjustmentDeliveryItem = this.newStockAdjustmentDeliveryItem();
				stockAdjustmentDeliveryItem.setStockAdjustmentDelivery(stockAdjustmentDelivery);
				stockAdjustmentDeliveryItem.setStockAdjustmentItem(stockAdjustmentItem);
				stockAdjustmentDeliveryItem.setQuantity(stockAdjustmentItem.getQuantity());
				stockAdjustmentDeliveryItem.setStock(stockAdjustmentItem.getFromStock());
			}
			
			this.saveStockAdjustmentDelivery(stockAdjustmentDelivery);
		}
		
		
		// Physical / Makeup / Breakup (Maybe Incoming, Maybe Outgoing)
		if( listFindNoCase("satPhysicalCount,satMakeupBundledSkus,satBreakupBundledSkus", arguments.stockAdjustment.getStockAdjustmentType().getSystemCode()) ) {
			
			var headObjects = {};
			
			for(var i=1; i <= arrayLen(arguments.stockAdjustment.getStockAdjustmentItems()); i++) {
				
				var stockAdjustmentItem = arguments.stockAdjustment.getStockAdjustmentItems()[i];
				
				// If this is In, create receiver
				if(!isNull(stockAdjustmentItem.getToStock())) {
					
					if(!structKeyExists(headObjects, "stockReceiver")) {
						// Creating Header
						headObjects.stockReceiver = this.newStockReceiver();
						headObjects.stockReceiver.setReceiverType( "stockAdjustment" );
						headObjects.stockReceiver.setStockAdjustment( arguments.stockAdjustment );
						this.saveStockReceiver( headObjects.stockReceiver );
					}
					
					// Creating Detail
					var stockReceiverItem = this.newStockReceiverItem();
					stockReceiverItem.setStockReceiver( headObjects.stockReceiver );
					stockReceiverItem.setStockAdjustmentItem( stockAdjustmentItem );
					stockReceiverItem.setQuantity( stockAdjustmentItem.getQuantity() );
					stockReceiverItem.setCost( 0 );
					stockReceiverItem.setStock( stockAdjustmentItem.getToStock() );
			
				
				// If this is Out, create delivery
				} else if (!isNull(stockAdjustmentItem.getFromStock())) {
					
					// Creating Header
					if(!structKeyExists(headObjects, "stockAdjustmentDelivery")) {
						headObjects.stockAdjustmentDelivery = this.newStockAdjustmentDelivery();
						headObjects.stockAdjustmentDelivery.setStockAdjustment( arguments.stockAdjustment );
						this.saveStockAdjustmentDelivery( headObjects.stockAdjustmentDelivery );
					}
					
					// Creating Detail
					var stockAdjustmentDeliveryItem = this.newStockAdjustmentDeliveryItem();
					stockAdjustmentDeliveryItem.setStockAdjustmentDelivery( headObjects.stockAdjustmentDelivery );
					stockAdjustmentDeliveryItem.setStockAdjustmentItem( stockAdjustmentItem );
					stockAdjustmentDeliveryItem.setQuantity( stockAdjustmentItem.getQuantity() );
					stockAdjustmentDeliveryItem.setStock( stockAdjustmentItem.getFromStock() );
				}
			}
		}
		
		// Set the status to closed
		arguments.stockAdjustment.setStockAdjustmentStatusType( getTypeService().getTypeBySystemCode("sastClosed") );	

	return arguments.stockAdjustment;

	}
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Status Methods ===========================
	
	// ======================  END: Status Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	public any function getStockSmartList(struct data={}, currentURL="") {
		arguments.entityName = "SlatwallStock";
		
		var smartList = getStockDAO().getSmartList(argumentCollection=arguments);
		
		smartList.joinRelatedProperty("SlatwallStock", "sku");
		smartList.joinRelatedProperty("SlatwallSku", "product");
		smartList.joinRelatedProperty("SlatwallProduct", "productType");
		smartList.joinRelatedProperty("SlatwallSku", "alternateSkuCodes", "left");
		
		smartList.addKeywordProperty(propertyIdentifier="sku.skuCode", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="sku.skuID", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="sku.publishedFlag", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="sku.product.productName", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="sku.product.productType.productTypeName", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="sku.alternateSkuCodes.alternateSkuCode", weight=1);
		
		// Must be set to distinct so that we can search alternate sku codes
		smartList.setSelectDistinctFlag( true );
				
		return smartList;
	}

	public any function getStockAdjustmentSmartList(struct data={}, currentURL="") {
		arguments.entityName = "SlatwallStockAdjustment";
		
		var smartList = getSmartList(argumentCollection=arguments);
		
		smartList.joinRelatedProperty("SlatwallStockAdjustment", "fromLocation", "left");
		smartList.joinRelatedProperty("SlatwallStockAdjustment", "toLocation", "left");
		
		return smartList;
	}
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
	
	// ===================== START: Delete Overrides ==========================
	
	// =====================  END: Delete Overrides ===========================
	
	
}

