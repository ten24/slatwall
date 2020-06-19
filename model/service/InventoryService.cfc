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

	property name="inventoryDAO" type="any";
	property name="skuService" type="any";
	
	public void function createInventoryByStockReceiverItem(required any stockReceiverItem){
		if(arguments.stockReceiverItem.getStock().getSku().setting("skuTrackInventoryFlag")) {
			// Dynamically do a breakupBundledSkus call, if this is an order return, a bundle sku, the setting is enabled to do this dynamically
			if(arguments.stockReceiverItem.getStockReceiver().getReceiverType() == 'order' 
				&& ( !isNull(arguments.stockReceiverItem.getStock().getSku().getBundleFlag()) && arguments.stockReceiverItem.getStock().getSku().getBundleFlag() )
				&& arguments.stockReceiverItem.getStock().getSku().setting("skuBundleAutoBreakupInventoryOnReturnFlag")) {

				var processData = {
					locationID=arguments.stockReceiverItem.getStock().getLocation().getLocationID(),
					quantity=arguments.stockReceiverItem.getQuantity()
				};
				
				if(arguments.entity.getStock().getSku().getProcessObject('breakupBundledSkus').getPopulatedFlag()){
					arguments.entity.getStock().getSku().getProcessObject('breakupBundledSkus').setPopulatedFlag(false);
				}

				getSkuService().processSku(arguments.stockReceiverItem.getStock().getSku(), processData, 'breakupBundledSkus');
				
			}
			var inventory = this.newInventory();
			inventory.setQuantityIn(arguments.stockReceiverItem.getQuantity());
			inventory.setStock(arguments.stockReceiverItem.getStock());
			inventory.setStockReceiverItem(arguments.stockReceiverItem);
			inventory.setCurrencyCode(arguments.stockReceiverItem.getCurrencyCode());

			//vendorOrderItem logic
			if(arguments.stockReceiverItem.getStockReceiver().getReceiverType() == 'vendorOrder' || arguments.stockReceiverItem.getStockReceiver().getReceiverType() == 'stockAdjustment'){
				inventory.setCost(arguments.stockReceiverItem.getCost());
				inventory.setLandedCost(arguments.stockReceiverItem.getLandedCost());
				inventory.setLandedAmount(arguments.stockReceiverItem.getLandingAmount());
				// calculate average cost
				var stock = arguments.stockReceiverItem.getStock();
				if(val(arguments.stockReceiverItem.getCost()) != 0){
					stock.updateAverageCost(arguments.stockReceiverItem.getCost(), arguments.stockReceiverItem.getQuantity());
					//arguments.stockReceiverItem.getVendorOrderItem().getVendorOrder().getShippingAndHandlingCost()
					stock.updateAverageLandedCost(arguments.stockReceiverItem.getCost(), arguments.stockReceiverItem.getQuantity(), 0);
				}
				
				if(arguments.stockReceiverItem.getStock().getSku().getProduct().getProductType().getSystemCode() != 'gift-card'){
					//set the assets ledger account 
					var assetLedgerAccount = getService('LedgerAccountService').getLedgerAccount(arguments.stockReceiverItem.getStock().getSku().setting('skuAssetLedgerAccount'));
					inventory.setAssetLedgerAccount(assetLedgerAccount);
				}
			}
			
			//Physical logic
			if(!isNull(arguments.stockReceiverItem.getStockReceiver().getStockAdjustment()) && !isNull(arguments.stockReceiverItem.getStockReceiver().getStockAdjustment().getPhysical())){
				//set the expense ledger account by physical ledger account 
				if(!isNull(arguments.stockReceiverItem.getStockReceiver().getStockAdjustment().getPhysical().getExpenseLedgerAccount())){
					var expenseLedgerAccount = arguments.stockReceiverItem.getStockReceiver().getStockAdjustment().getPhysical().getExpenseLedgerAccount();
				}else{
					var ledgerAccountID = arguments.stockReceiverItem.getStockReceiver().getStockAdjustment().getPhysical().setting('physicalDefaultExpenseLedgerAccount');
					var expenseLedgerAccount = getService('LedgerAccountService').getLedgerAccount(ledgerAccountID);
				}
				if(!isNull(arguments.stockReceiverItem.getStockReceiver().getStockAdjustment().getPhysical().getAssetLedgerAccount())){
					var assetLedgerAccount = arguments.stockReceiverItem.getStockReceiver().getStockAdjustment().getPhysical().getAssetLedgerAccount();
				}else{
					var ledgerAccountID = arguments.stockReceiverItem.getStockReceiver().getStockAdjustment().getPhysical().setting('physicalDefaultAssetLedgerAccount');
					var assetLedgerAccount = getService('LedgerAccountService').getLedgerAccount(ledgerAccountID);
				}
				inventory.setAssetLedgerAccount(assetLedgerAccount);
				inventory.setExpenseLedgerAccount(expenseLedgerAccount);
			}
			
			inventory = getService('inventoryService').saveInventory( inventory );
			
		}
	}
	
	// entity will be one of StockReceiverItem, StockPhysicalItem, StrockAdjustmentDeliveryItem, VendorOrderDeliveryItem, OrderDeliveryItem
	public void function createInventory(required any entity) {
		
		switch(arguments.entity.getEntityName()) {
			case "SlatwallStockReceiverItem": {
				createInventoryByStockReceiverItem(arguments.entity);
				break;
			}
			case "SlatwallOrderDeliveryItem": {
				if(arguments.entity.getStock().getSku().setting("skuTrackInventoryFlag")) {

					// Dynamically do a makeupBundledSkus call, if this is a bundle sku, the setting is enabled to do this dynamically, and we have QOH < whats needed
					if(!isNull(arguments.entity.getStock().getSku().getBundleFlag())
						&& arguments.entity.getStock().getSku().getBundleFlag()
						&& arguments.entity.getStock().getSku().setting("skuBundleAutoMakeupInventoryOnSaleFlag") 
						&& arguments.entity.getStock().getQuantity("QOH") - arguments.entity.getQuantity() < 0) {

						var processData = {
							locationID=arguments.entity.getStock().getLocation().getLocationID(),
							quantity=arguments.entity.getQuantity() - arguments.entity.getStock().getQuantity("QOH")
						};

						if(arguments.entity.getStock().getSku().getProcessObject('makeupBundledSkus').getPopulatedFlag()){
							arguments.entity.getStock().getSku().getProcessObject('makeupBundledSkus').setPopulatedFlag(false);
						}

						getSkuService().processSku(arguments.entity.getStock().getSku(), processData, 'makeupBundledSkus');
					}
					
					var inventory = this.newInventory();
					inventory.setQuantityOut( arguments.entity.getQuantity() );
					inventory.setStock( arguments.entity.getStock() );
					inventory.setCogs(arguments.entity.getStock().getAverageCost());
					inventory.setOrderDeliveryItem( arguments.entity );
					inventory.setCurrencyCode(arguments.entity.getOrderItem().getCurrencyCode());
					if(arguments.entity.getStock().getSku().getProduct().getProductType().getSystemCode() != 'gift-card'){
						//set the revenue ledger account 
						var revenueLedgerAccount = getService('LedgerAccountService').getLedgerAccount(arguments.entity.getStock().getSku().setting('skuRevenueLedgerAccount'));
						inventory.setRevenueLedgerAccount(revenueLedgerAccount);
						var cogsLedgerAccount = getService('LedgerAccountService').getLedgerAccount(arguments.entity.getStock().getSku().setting('skuCogsLedgerAccount'));
						inventory.setCogsLedgerAccount(cogsLedgerAccount);
					}
					
					
					getService('inventoryService').saveInventory( inventory );	
					
				}
				break;
			}
			case "SlatwallVendorOrderDeliveryItem": {
				if(arguments.entity.getStock().getSku().setting("skuTrackInventoryFlag")) {
					var inventory = this.newInventory();
					inventory.setQuantityOut(arguments.entity.getQuantity());
					inventory.setStock(arguments.entity.getStock());
					//calculate stock
					getHibachiScope().addModifiedEntity(arguments.entity.getStock());
					inventory.setCost(arguments.entity.getVendorOrderItem().getCost());
					inventory.setVendorOrderDeliveryItem(arguments.entity);
					inventory.setCurrencyCode(arguments.entity.getVendorOrderItem().getCurrencyCode());

					if(arguments.entity.getStock().getSku().getProduct().getProductType().getSystemCode() != 'gift-card'){
						//set the inventory ledger account 
						var assetLedgerAccount = getService('LedgerAccountService').getLedgerAccount(arguments.entity.getStock().getSku().setting('skuAssetLedgerAccount'));
						inventory.setAssetLedgerAccount(assetLedgerAccount);
					}
					getService('inventoryService').saveInventory( inventory );
				}
				break;
			}
			case "SlatwallStockAdjustmentDeliveryItem": {
				if(arguments.entity.getStock().getSku().setting("skuTrackInventoryFlag")) {

					// Dynamically do a makeupBundledSkus call, if this is a bundle sku, the setting is enabled to do this dynamically, and we have QOH < whats needed
					if(!isNull(arguments.entity.getStock().getSku().getBundleFlag())
						&& arguments.entity.getStock().getSku().getBundleFlag()
						&& arguments.entity.getStock().getSku().setting("skuBundleAutoMakeupInventoryOnSaleFlag") 
						&& arguments.entity.getStock().getQuantity("QOH") - arguments.entity.getQuantity() < 0) {

						var processData = {
							locationID=arguments.entity.getStock().getLocation().getLocationID(),
							quantity=arguments.entity.getQuantity() - arguments.entity.getStock().getQuantity("QOH")
						};

						if(arguments.entity.getStock().getSku().getProcessObject('makeupBundledSkus').getPopulatedFlag()){
							arguments.entity.getStock().getSku().getProcessObject('makeupBundledSkus').setPopulatedFlag(false);
						}

						getSkuService().processSku(arguments.entity.getStock().getSku(), processData, 'makeupBundledSkus');
					}
					
					var inventory = this.newInventory();
					inventory.setQuantityOut(arguments.entity.getQuantity());
					inventory.setStock(arguments.entity.getStock());
					inventory.setCogs(arguments.entity.getStock().getAverageCost());
					inventory.setStockAdjustmentDeliveryItem(arguments.entity);
					inventory.setCurrencyCode(arguments.entity.getCurrencyCode());

					if(arguments.entity.getStock().getSku().getProduct().getProductType().getSystemCode() != 'gift-card'){
						//set the inventory ledger account 
						var cogsLedgerAccount = getService('LedgerAccountService').getLedgerAccount(arguments.entity.getStock().getSku().setting('skuCogsLedgerAccount'));
						inventory.setCogsLedgerAccount(cogsLedgerAccount);
					}
					getService('inventoryService').saveInventory( inventory );
				}
				break;
			}
			default: {
				throw("You are trying to create an inventory record for an entity that is not one of the 5 entities that manage inventory.  Those entities are: StockReceiverItem, StockPhysicalItem, StrockAdjustmentDeliveryItem, VendorOrderDeliveryItem, OrderDeliveryItem");
			}
		}
		
	}
	
	public any function saveInventory(required any inventory, required struct data={}){
	
		arguments.inventory = super.save(entity=arguments.inventory, data=arguments.data);
		
		if(!inventory.hasErrors()){
			getService('skuService').processSku(arguments.inventory.getStock().getSku(),{},'createSkuCost');
		}
		
		return arguments.inventory;	
	}
	
	public struct function getQDOO(string productID, string productRemoteID){
		return createInventoryDataStruct( getInventoryDAO().getQDOO(argumentCollection=arguments), "QDOO" );
	}
	
	// Quantity On Hand
	public struct function getQOH(string productID, string productRemoteID, string currencyCode) {
		return createInventoryDataStruct( getInventoryDAO().getQOH(argumentCollection=arguments), "QOH" );
	}
	
	// Quantity On Stock Hold
	public struct function getQOSH(string productID, string productRemoteID) {
		return {skus={},stocks={},locations={},QOSH=0};
		//return createInventoryDataStruct( getInventoryDAO().getQOSH(argumentCollection=arguments), "QOSH" );
	}
	
	// Quantity Not Delivered On Open Order
	public struct function getQNDOO(string productID, string productRemoteID) {
		return createInventoryDataStruct( getInventoryDAO().getQNDOO(argumentCollection=arguments), "QNDOO" );
	}
	
	// Quantity Not Delivered On Return Vendor Order
	public struct function getQNDORVO(string productID, string productRemoteID) {
		return createInventoryDataStruct( getInventoryDAO().getQNDORVO(argumentCollection=arguments), "QNDORVO" );
	}
	
	// Quantity Not Delivered On Stock Adjustment
	public struct function getQNDOSA(string productID, string productRemoteID) {
		return createInventoryDataStruct( getInventoryDAO().getQNDOSA(argumentCollection=arguments), "QNDOSA" );
	}
	
	// Quantity Not Received On Return Order
	public struct function getQNRORO(string productID, string productRemoteID) {
		return createInventoryDataStruct( getInventoryDAO().getQNRORO(argumentCollection=arguments), "QNRORO" );
	}
	
	// Quantity Not Received On Vendor Order
	public struct function getQNROVO(string productID, string productRemoteID) {
		return createInventoryDataStruct( getInventoryDAO().getQNROVO(argumentCollection=arguments), "QNROVO" );
	}
	
	// Quantity Not Received On Stock Adjustment
	public struct function getQNROSA(string productID, string productRemoteID) {
		return createInventoryDataStruct( getInventoryDAO().getQNROSA(argumentCollection=arguments), "QNROSA" );
	}
	
	// Quantity Returned
	public struct function getQR(string productID, string productRemoteID) {
		return createInventoryDataStruct( getInventoryDAO().getQR(argumentCollection=arguments), "QR" );
	}
	
	// Quantity Sold
	public struct function getQS(string productID, string productRemoteID) {
		return createInventoryDataStruct( getInventoryDAO().getQS(argumentCollection=arguments), "QS" );
	}

	//Minimum Quantity Available to Sell of Build of Materials - returns quantity of sku that can be made based on the smallest QATS of bundled skus
	public numeric function getMQATSBOM(required any entity){
		if(arguments.entity.getEntityName() == "SlatwallProduct"){
			var sumMQATS = 0;
			for(var sku in arguments.entity.getSkus()){
				sumMQATS += this.getMQATSBOM(sku);
			}
			return sumMQATS;
		}else if(arguments.entity.getEntityName() == "SlatwallStock"){
			var sku = arguments.entity.getSku();
			var locationID = arguments.entity.getLocationID();
		}else{
			var sku = arguments.entity;
			var locationID = '';
		}
		if(!sku.getBundleFlag()){
			return 0;
		}
		var MQATS = '';
		for(var bundledSku in sku.getBundledSkus()){
			var skuQATS = bundledSku.getBundleQATS(locationID=locationID);
			if(!len(MQATS) || skuQATS < MQATS){
				MQATS = skuQATS;
			}
		}
		if(MQATS < 0){
			MQATS = 0;
		}
		return MQATS;
	}
	
	// These methods are derived quantity methods from respective DAO methods
	public numeric function getQC(required any entity) {
		return arguments.entity.getQuantity('QNDOO') + arguments.entity.getQuantity('QNDORVO') + arguments.entity.getQuantity('QNDOSA');
	}
	
	public numeric function getQE(required any entity) {
		return arguments.entity.getQuantity('QNRORO') + arguments.entity.getQuantity('QNROVO') + arguments.entity.getQuantity('QNROSA');
	}
	
	public numeric function getQNC(required any entity) {
		return arguments.entity.getQuantity('QOH') - arguments.entity.getQuantity('QC');
	}
	
	public numeric function getQOQ(required any entity){
		var skuID = '';
		var locationID = '';
		if(arguments.entity.getEntityName() eq "SlatwallStock") {
			skuID = arguments.entity.getSku().getSkuID();
			location = arguments.entity.getLocation().getLocationID();
		} else {
			skuID = arguments.entity.getSkuID();
		}
		return getInventoryDAO().getQOQ(skuID,locationID);
	}
	
	public numeric function getQATS(required any entity) {
		
		if(arguments.entity.getEntityName() eq "SlatwallStock") {
			var trackInventoryFlag = arguments.entity.getSku().setting('skuTrackInventoryFlag');
			var allowBackorderFlag = arguments.entity.getSku().setting('skuAllowBackorderFlag');
			var orderMaximumQuantity = arguments.entity.getSku().setting('skuOrderMaximumQuantity'); 
			var qatsIncludesQNROROFlag = arguments.entity.getSku().setting('skuQATSIncludesQNROROFlag');
			var qatsIncludesQNROVOFlag = arguments.entity.getSku().setting('skuQATSIncludesQNROVOFlag');
			var qatsIncludesQNROSAFlag = arguments.entity.getSku().setting('skuQATSIncludesQNROSAFlag');
			var holdBackQuantity = arguments.entity.getSku().setting('skuHoldBackQuantity');
			var qatsIncludesMQATSBOMFlag = arguments.entity.getSku().setting('skuQATSIncludesMQATSBOMFlag');
		} else {
			var trackInventoryFlag = arguments.entity.setting('skuTrackInventoryFlag');
			var allowBackorderFlag = arguments.entity.setting('skuAllowBackorderFlag');
			var orderMaximumQuantity = arguments.entity.setting('skuOrderMaximumQuantity'); 
			var qatsIncludesQNROROFlag = arguments.entity.setting('skuQATSIncludesQNROROFlag');
			var qatsIncludesQNROVOFlag = arguments.entity.setting('skuQATSIncludesQNROVOFlag');
			var qatsIncludesQNROSAFlag = arguments.entity.setting('skuQATSIncludesQNROSAFlag');
			var holdBackQuantity = arguments.entity.setting('skuHoldBackQuantity');
			var qatsIncludesMQATSBOMFlag = arguments.entity.setting('skuQATSIncludesMQATSBOMFlag');
		}

		// If trackInventory is not turned on, or backorder is true then we can set the qats to the max orderQuantity
		if( !trackInventoryFlag || allowBackorderFlag ) {
			return orderMaximumQuantity;
		}
		
		// Otherwise we will do a normal bit of calculation logic
		var ats = arguments.entity.getQuantity('QNC');

		if(qatsIncludesQNROROFlag) {
			ats += arguments.entity.getQuantity('QNRORO');
		}
		if(qatsIncludesQNROVOFlag) {
			ats += arguments.entity.getQuantity('QNROVO');
		}
		if(qatsIncludesQNROSAFlag) {
			ats += arguments.entity.getQuantity('QNROSA');
		}
		if(qatsIncludesMQATSBOMFlag){
			ats += arguments.entity.getQuantity('MQATSBOM');
		}
		
		if(isNumeric(holdBackQuantity)) {
			ats -= holdBackQuantity;
		}
		
		return ats;
		
	}
	
	public numeric function getQIATS(required any entity) {
		if(arguments.entity.getEntityName() eq "SlatwallStock") {
			var trackInventoryFlag = arguments.entity.getSku().setting('skuTrackInventoryFlag');
			var orderMaximumQuantity = arguments.entity.getSku().setting('skuOrderMaximumQuantity'); 
			var holdBackQuantity = arguments.entity.getSku().setting('skuHoldBackQuantity');
		} else {
			var trackInventoryFlag = arguments.entity.setting('skuTrackInventoryFlag');
			var orderMaximumQuantity = arguments.entity.setting('skuOrderMaximumQuantity'); 
			var holdBackQuantity = arguments.entity.setting('skuHoldBackQuantity');
		}
		
		if(!trackInventoryFlag) {
			return orderMaximumQuantity;
		}
		
		return arguments.entity.getQuantity('QNC') - holdBackQuantity;
	}

	private struct function createInventoryDataStruct(required any inventoryArray, required string inventoryType) {
		
		var returnStruct = {};
		
		returnStruct[ arguments.inventoryType ] = 0;
		returnStruct.locations = {};
		returnStruct.skus = {};
		returnStruct.stocks = {};
		
		for(var i=1; i<=arrayLen(arguments.inventoryArray); i++) {
			
			var locationID = "";
			var stockID = "";
			var skuID = "";
		
			// Increment Product value
			returnStruct[ arguments.inventoryType ] += arguments.inventoryArray[i][ arguments.inventoryType ];
			
			// Setup the location
			if( structKeyExists(arguments.inventoryArray[i], "locationIDPath") ) {
				for(var l=1; l<=listLen(arguments.inventoryArray[i]["locationIDPath"]); l++) {
					locationID = listGetAt(arguments.inventoryArray[i]["locationIDPath"], l);
					
					if( !structKeyExists(returnStruct.locations, locationID) ) {
						returnStruct.locations[ locationID ] = 0;
					}
					
					// Increment Location
					returnStruct.locations[ locationID ] += arguments.inventoryArray[i][ arguments.inventoryType ];	
				}
			}
			
			// Setup the stock
			if( structKeyExists(arguments.inventoryArray[i], "stockID") ) {
				var stockID = arguments.inventoryArray[i]["stockID"];	
				returnStruct.stocks[ stockID ] = arguments.inventoryArray[i][ arguments.inventoryType ];	
			}
			
			// Setup the sku
			if( structKeyExists(arguments.inventoryArray[i], "skuID") ) {
				var skuID = arguments.inventoryArray[i]["skuID"];
				
				if(!structKeyExists(returnStruct.skus, skuID)) {
					returnStruct.skus[ skuID ] = {};
					returnStruct.skus[ skuID ].locations = {};
					returnStruct.skus[ skuID ][ arguments.inventoryType ] = 0;
				}
				
				returnStruct.skus[ skuID ][ arguments.inventoryType ] += arguments.inventoryArray[i][ arguments.inventoryType ];
				
				// Add location to sku if it exists
				if(structKeyExists(arguments.inventoryArray[i],'locationIDPath')){
					for(var l=1; l<=listLen(arguments.inventoryArray[i]["locationIDPath"]); l++) {
						locationID = listGetAt(arguments.inventoryArray[i]["locationIDPath"], l);
					
						if(!structKeyExists(returnStruct.skus[ skuID ].locations, locationID)) {
							returnStruct.skus[ skuID ].locations[ locationID ] = 0;
						}
						returnStruct.skus[ skuID ].locations[ locationID ] += arguments.inventoryArray[i][ arguments.inventoryType ];
					}
				}
				

			}
			
		}
		
		return returnStruct;
		
	}
	
	public any function getSkuLocationQuantityBySkuIDAndLocationID(required string skuID, required string locationID) {
		return getInventoryDAO().getSkuLocationQuantityBySkuIDAndLocationID(argumentCollection=arguments);
	}

	// ===================== START: Logical Methods ===========================
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	

	public any function saveInventoryAnalysis(required any inventoryAnalysis, struct data={}, string context="save"){
		
		arguments.inventoryAnalysis = super.save(entity=arguments.inventoryAnalysis,data=arguments.data);

		arguments.inventoryAnalysis.setAnalysisHistoryStartDateTime(dateAdd('yyyy',-1,arguments.inventoryAnalysis.getAnalysisStartDateTime()));
		arguments.inventoryAnalysis.setAnalysisHistoryEndDateTime(arguments.inventoryAnalysis.getAnalysisStartDateTime());
		arguments.inventoryAnalysis.setAnalysisHistoryDaysOutDateTime(dateAdd('d',arguments.inventoryAnalysis.getDaysOut(),arguments.inventoryAnalysis.getAnalysisStartDateTime()));

		return arguments.inventoryAnalysis;
	}

	public any function processInventoryAnalysis_exportXLS(required any InventoryAnalysis, required any processObject) {

		var filename = getService("HibachiUtilityService").createSEOString(arguments.InventoryAnalysis.getInventoryAnalysisName() &'-'& arguments.InventoryAnalysis.getFormattedValue('analysisStartDateTime')) &'.xls';
		var fullFilename = getHibachiTempDirectory() & filename;

		// Create spreadsheet object
		var spreadsheet = spreadsheetNew(filename);
		var spreadsheetrowcount = 0;
		// Add the column headers
		spreadsheetAddRow(spreadsheet, arguments.InventoryAnalysis.getReportData().headerRowXSL);
		spreadsheetrowcount += 1;
		spreadsheetFormatRow(spreadsheet, {bold=true}, 1);
		// Add rows
		spreadsheetAddRows(spreadsheet, arguments.InventoryAnalysis.getReportData(arguments.inventoryAnalysis.getSkuCollection().getRecords()).query);
		spreadsheetrowcount += arguments.InventoryAnalysis.getReportData(arguments.inventoryAnalysis.getSkuCollection().getRecords()).query.recordcount;

		spreadsheetWrite( spreadsheet, fullFilename, true );
		getService("hibachiUtilityService").downloadFile( filename, fullFilename, "application/msexcel", true );

		return arguments.InventoryAnalysis;
	}
	public any function processInventoryAnalysis_exportCSV(required any InventoryAnalysis, required any processObject) {

		var filename = getService("HibachiUtilityService").createSEOString(arguments.InventoryAnalysis.getInventoryAnalysisName() &'-'& arguments.InventoryAnalysis.getFormattedValue('analysisStartDateTime')) &'.csv';
		var fullFilename = getHibachiTempDirectory() & filename;

		fileWrite(fullFilename, getService("hibachiUtilityService").queryToCSV(arguments.InventoryAnalysis.getReportData(arguments.inventoryAnalysis.getSkuCollection().getRecords()).query, arguments.InventoryAnalysis.getReportData().columnList, true ));
		getService("hibachiUtilityService").downloadFile( filename, fullFilename, "application/msexcel", true );

		return arguments.InventoryAnalysis;
	}

	// =====================  END: Process Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
}
