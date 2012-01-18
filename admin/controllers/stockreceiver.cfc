/*

    Slatwall - An e-commerce plugin for Mura CMS
    Copyright (C) 2011 ten24, LLC

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
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes: Test.

*/
component extends="BaseController" persistent="false" accessors="true" output="false" {

	// fw1 Auto-Injected Service Properties
	property name="stockService" type="any";
	property name="vendorOrderService" type="any";
	property name="locationService" type="any";
	property name="skuService" type="any";
	
	public void function default(required struct rc) {
		getFW().redirect("admin:stockreceiver.list");
	}
	
	public void function listStockReceivers(required struct rc) {
        param name="rc.orderBy" default="stockReceiverId|ASC";
        
        rc.stockReceiverSmartList = getStockService().getStockReceiverSmartList(data=arguments.rc);  
    }
    
    /*
    	Generic to all Stock Receiver types
    */
    public void function initStockReceiver(required struct rc) {
    	param name="rc.stockReceiverID" default="";
    	param name="rc.stockReceiverType" default="";
    	
    	if(len(rc.StockReceiverID)) {
    		rc.stockReceiver = getStockService().getStockReceiver(rc.stockReceiverID, true);
    	} else {
    		if(rc.stockReceiverType == "vendorOrder") {
    			rc.stockReceiver = getStockService().newStockReceiverVendorOrder();
    		} else if(rc.stockReceiverType == "order") {
    			rc.stockReceiver = getStockService().newStockReceiverOrder();
    		} else {
    			throw("Unknown StockReceiver type: #rc.stockReceiverType#");
    		}
    	}
    	
    	// Set up the locations smart list to return an array that is compatible with the cf_slatwallformfield output tag
		rc.locationSmartList = getLocationService().getLocationSmartList();
		rc.locationSmartList.setPageRecordsShow(9999999);
		rc.locationSmartList.addSelect(propertyIdentifier="locationName", alias="name");
		rc.locationSmartList.addSelect(propertyIdentifier="locationId", alias="value");
	}
    
    public void function detailStockReceiver(required struct rc) {
    	param name="rc.stockReceiverID" default="";
    	
    	initStockReceiver(rc);
    	
    	if(isNull(rc.stockReceiver)) {
    		//getFW().redirect(action="admin:stockReceiver.listStockReceivers");
    		throw("No stock receiver found!")
    	}
    	
    	// Proceed to the type-specific detail
    	if(rc.stockReceiver.getReceiverType() == "vendorOrder") {
    		detailStockReceiverVendorOrder(rc);
    	} else if(rc.stockReceiver.getReceiverType() == "order") {
    		detailStockReceiverOrder(rc);
    	} else {
    		throw("Unrecognized StockReceiver type: #rc.stockReceiver.getReceiverType()#");
    	}
			
		rc.edit = false;
		rc.itemTitle = rc.$.Slatwall.rbKey("admin.stockreceiver.detailStockReceiver") & rc.$.Slatwall.rbKey("admin.stockreceiver.typeName_#rc.stockreceiver.getReceiverType()#");
		getFW().setView(action="admin:stockReceiver.detailStockReceiver");
		  	
    }
    
    /*
    	Vendor Order related. Some of these are not meant to be called as public event handlers.
    */
    public void function detailStockReceiverVendorOrder(required struct rc) {
		param name="rc.vendorOrderID";
    	
    	rc.backAction = "admin:vendorOrder.detailVendorOrder";
    	rc.backQueryString = "vendorOrderID=#rc.vendorOrderId#";
    }

    public void function createStockReceiverVendorOrder(required struct rc) {
    	param name="rc.vendorOrderId" default="";
    	rc.stockReceiverType = "vendorOrder";
    	initStockReceiver(rc);
    	
    	// Populate Vendor Order specific data
		rc.vendorOrder = getVendorOrderService().getVendorOrder(rc.vendorOrderID);
		
		if(isNull(rc.vendorOrder)) {
			getFW().redirect(action="admin:vendorOrder.detailOrderReceivers", queryString="VendorOrderID=#rc.VendorOrder.getVendorOrderID()#");
		}
	
		// Get Items
		//rc.vendorOrderItemSmartList = getVendorOrderService().getVendorOrderItemSmartList();
		//rc.vendorOrderItemSmartList.setPageRecordsShow(9999999);
		//rc.vendorOrderItemSmartList.addFilter("vendorOrder.vendorOrderID", rc.vendorOrderID);

    	rc.backAction = "admin:vendorOrder.detailVendorOrder";
    	rc.backQueryString = "vendorOrderID=#rc.vendorOrderId#";
    	rc.action = "admin:stockReceiver.saveStockReceiverVendorOrder";
    	
    	rc.edit = true;
		rc.itemTitle = rc.StockReceiver.isNew() ? rc.$.Slatwall.rbKey("admin.stockreceiver.createStockReceiver") : rc.$.Slatwall.rbKey("admin.stockreceiver.editStockReceiver") & rc.$.Slatwall.rbKey("admin.stockreceiver.typeName_#rc.stockreceiver.getReceiverType()#");
		getFW().setView(action="admin:stockReceiver.detailStockReceiver");
	}
    
   /* public void function editStockReceiver(required struct rc) {
    	param name="rc.stockReceiverID" default="";
    	param name="rc.stockReceiverRateID" default="";
    	
    	rc.stockReceiver = getStockService().getStockReceiver(rc.stockReceiverID, true);
    	rc.stockReceiverRate = getStockService().getStockReceiverRate(rc.stockReceiverRateId, true);
    	
    	rc.edit = true; 
    	getFW().setView("admin:stockreceiver.detailStockReceiver");  
	}*/
	
	public void function saveStockReceiverVendorOrder(required struct rc) {
		rc.stockReceiverType = "vendorOrder";
		initStockReceiver(rc);
		
		var vendorOrder = getVendorOrderService().getVendorOrder(rc.vendorOrderId);
		
		// Call the generic save method.
		//saveStockReceiver(rc);
		
		// Since this is a vendor order reciever, also add the vendororder
		rc.StockReceiver.setVendorOrder(vendorOrder);

		// Quantities provided by fields named like: quantity_skuid(4028b8813414708a01341514ad67001e). Loop over rc and find these fields. 
		for (var key IN rc) {
			var res = REFindNoCase("quantity_skuid\((.+)\)", key, 1, true);

			if(ArrayLen(res.pos) == 2) {
				var skuID = lcase(mid(key, res.pos[2], res.len[2]));
				var quantity = val(rc[key]);
				var stock = getStockService().getStockBySkuAndLocation(getSkuService().getSku(skuID), getLocationService().getLocation(rc.receiveForLocationID));
				
				//logSlatwall("Found: #key# - #skuID# - #quantity#");
				
				if(len(skuID) && isNumeric(quantity)) {
					// Take the sku, location (selected), and quantity, and build a StockRecieverItem
					var stockReceiverItem = getStockService().newStockReceiverItem();
					stockReceiverItem.setStockReceiver(rc.stockReceiver);		
					stockReceiverItem.setQuantity(quantity);
					stockReceiverItem.setStock(stock);
					
					// Set the vendorOrderItem of the StockReceiverItem to that of the vendorOrder
					var vendorOrderItem = vendorOrder.getVendorOrderItemForSkuAndLocation(stockReceiverItem.getStock().getSku().getSkuID(), stockReceiverItem.getStock().getLocation().getLocationID());
					getStockService().saveVendorOrderItem(vendorOrderItem);
					stockReceiverItem.setVendorOrderItem(vendorOrderItem);
					
					// Save the vendorOrderItem, as it may be new (if one wasn't found)
					/*if(vendorOrderItem.isNew()) {
						vendorOrderItem.setQuantity(0);
						getStockService().saveVendorOrderItem(vendorOrderItem);
					}*/
				}
			}
		}
		
		// Populate with box count & packing slip, validate, and save
		rc.stockReceiver = getStockService().saveStockReceiver(rc.stockReceiver, rc);
		
		/*
		// Loop over each stockReceiverItem and set the vendorOrderItem to that of the vendorOrder
		var stockReceiverItems = rc.StockReceiver.getStockReceiverItems();
		for(var i=0; i <= ArrayLen(stockReceiverItems); i++) {
			var vendorOrderItem = vendorOrder.getVendorOrderItemForSkuAndLocation(stockReceiverItems[i].getStock().getSku().getSkuID(), stockReceiverItems[i].getStock().getLocation().getLocationID());
			stockReceiverItems.setVendorOrderItem(vendorOrderItem);
			
			// Save the vendorOrderItem, as it may be new (if one wasn't found)
			if(vendorOrderItem.isNew()) {
				vendorOrderItem.setQuantity(0);
				getStockService().saveVendorOrderItem(vendorOrderItem);
			}
			
		}
		*/

		rc.message=rbKey("admin.vendorOrder.saveStockReceiverVendorOrder_success");
		getFW().redirect(action="admin:vendorOrder.detailVendorOrder", querystring="vendorOrderId=#rc.vendorOrderId#", preserve="message");
	} 
	

	// Only to be called from the type-specific save methods
	/*public void function saveStockReceiver(required struct rc) {
		initStockReceiver(rc);

		// Quantities provided by fields named like: quantity_skuid(4028b8813414708a01341514ad67001e). Loop over rc and find these fields. 
		for (var key IN rc) {
			var res = REFindNoCase("quantity_skuid\((.+)\)", key, 1, true);

			if(ArrayLen(res.pos) == 2) {
				var skuID = mid(key, res.pos[2], res.len[2]);
				var quantity = val(rc[key]);
				var stock = getStockService().getStockBySkuAndLocation(getSkuService().getSku(skuID), getLocationService().getLocation(rc.receiveForLocationID));
				
				//logSlatwall("Found: #key# - #skuID# - #quantity#");
				
				if(len(skuID) && isNumeric(quantity)) {
					// Take the sku, location (selected), and quantity, and build a StockRecieverItem
					var stockReceiverItem = getStockService().newStockReceiverItem();
					stockReceiverItem.setStockReceiver(rc.stockReceiver);		
					stockReceiverItem.setQuantity(quantity);
					stockReceiverItem.setStock(stock);
				}
			}
		}
		
		// Populate with box count & packing slip, validate, and save
		rc.stockReceiver = getStockService().saveStockReceiver(rc.stockReceiver, rc);
	}*/
}
