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
	
	property name="venderOrderDAO" type="any";
	
	property name="addressService" type="any";
	property name="locationService" type="any";
	property name="productService" type="any";
	property name="settingService" type="any";
	property name="skuService" type="any";
	property name="stockService" type="any";
	property name="taxService" type="any";
	property name="typeService" type="any";
	
	public any function getVendorOrderSmartList(struct data={}) {
		arguments.entityName = "SlatwallVendorOrder";
		
		var smartList = getHibachiDAO().getSmartList(argumentCollection=arguments);
		
		smartList.joinRelatedProperty("SlatwallVendorOrder","vendor");
			
		smartList.addKeywordProperty(propertyIdentifier="vendorOrderNumber", weight=9);
		smartList.addKeywordProperty(propertyIdentifier="vendor.vendorName", weight=4);	
		
		return smartList;
	}
	
	public any function getStockReceiverSmartList(string vendorOrderID) {
		var smartList = getStockService().getStockReceiverSmartlist();	
		smartList.addFilter("stockReceiverItems.vendorOrderItem.vendorOrder.vendorOrderID", arguments.vendorOrderID);
		return smartList;
	}
	
	public any function getStockReceiverItemSmartList(any stockReceiver) {
		var smartList = getStockService().getStockReceiverItemSmartlist();	
		smartList.addFilter("stockReceiver.stockReceiverID", arguments.stockReceiver.getStockReceiverID());
		return smartList;
	}
		
	public any function isProductInVendorOrder(required any productID, required any vendorOrderID){
		return getVenderOrderDAO().isProductInVendorOrder(arguments.productID, arguments.vendorOrderID);
	}
	
	public any function getQuantityOfStockAlreadyOnOrder(required any vendorOrderID, required any skuID, required any stockID) {
		return getVenderOrderDAO().getQuantityOfStockAlreadyOnOrder(arguments.vendorOrderId, arguments.skuID, arguments.stockID);
	}
	
	public any function getQuantityOfStockAlreadyReceived(required any vendorOrderID, required any skuID, required any stockID) {
		return getVenderOrderDAO().getQuantityOfStockAlreadyReceived(arguments.vendorOrderId, arguments.skuID, arguments.stockID);
	}
	
	public any function getSkusOrdered(required any vendorOrderID) {
		return getVenderOrderDAO().getSkusOrdered(arguments.vendorOrderId);
	}
	
	// ===================== START: Logical Methods ===========================
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	public any function processVendorOrder_addVendorOrderItem(required any vendorOrder, required any processObject){
		
		var vendorOrderItemType = getTypeService().getTypeBySystemCode( arguments.processObject.getVendorOrderItemTypeSystemCode() );
		var deliverToLocation = getStockService().getStockBySkuAndLocation(arguments.processObject.getSku(),getLocationService().getLocation(arguments.processObject.getDeliverToLocationID()));
		
		var newVendorOrderItem = this.newVendorOrderItem();
		newVendorOrderItem.setVendorOrderItemType( vendorOrderItemType );
		newVendorOrderItem.setVendorOrder( arguments.vendorOrder );
		newVendorOrderItem.setCurrencyCode( arguments.vendorOrder.getCurrencyCode() );
		newVendorOrderItem.setStock( deliverToLocation );
		newVendorOrderItem.setQuantity( arguments.processObject.getQuantity() );
		newVendorOrderItem.setCost( arguments.processObject.getCost() );
		
		return arguments.vendorOrder;
	}
	
	public any function processVendorOrder_receive(required any vendorOrder, required any processObject){
		
		var stockReceiver = getStockService().newStockReceiver();
		stockReceiver.setReceiverType( "vendorOrder" );
		stockReceiver.setVendorOrder( arguments.vendorOrder );
		
		if(!isNull(processObject.getPackingSlipNumber())) {
			stockReceiver.setPackingSlipNumber( processObject.getPackingSlipNumber() );
		}
		if(!isNull(processObject.getBoxCount())) {
			stockReceiver.setBoxCount( processObject.getBoxCount() );
		}
		
		var location = getLocationService().getLocation( arguments.processObject.getLocationID() );
		
		for(var thisRecord in arguments.data.vendorOrderItems) {
			
			if(val(thisRecord.quantity) gt 0) {
				
				var foundItem = false;
				var vendorOrderItem = this.getVendorOrderItem( thisRecord.vendorOrderItem.vendorOrderItemID );
				var stock = getStockService().getStockBySkuAndLocation( vendorOrderItem.getStock().getSku(), location );
				
				var stockReceiverItem = getStockService().newStockReceiverItem();
			
				stockreceiverItem.setQuantity( thisRecord.quantity );
				stockreceiverItem.setStock( stock );
				stockreceiverItem.setVendorOrderItem( vendorOrderItem );
				stockreceiverItem.setStockReceiver( stockReceiver );
				
			}
		}
		
		getStockService().saveStockReceiver( stockReceiver );
		
		var closedFlag = true;
		var partiallyReceivedFlag = false;
		
		for(var vendorOrderItem in arguments.vendorOrder.getVendorOrderItems()) {
			if(vendorOrderItem.getQuantityUnreceived() > 0) {
				closedFlag = false;
			}
			if(vendorOrderItem.getQuantityReceived() > 0) {
				partiallyReceivedFlag = true;
			}
		}
		// Change the status depending on what value the partiallyReceivedFlag or closedFlag
		if(closedFlag){
			arguments.vendorOrder.setVendorOrderStatusType( getTypeService().getTypeBySystemCode("vostClosed") );
		} else if(partiallyReceivedFlag) {
			arguments.vendorOrder.setVendorOrderStatusType( getTypeService().getTypeBySystemCode("vostPartiallyReceived") );

		}
		
		
		return arguments.vendorOrder;
	}
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Status Methods ===========================
	
	// ======================  END: Status Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
	
}

