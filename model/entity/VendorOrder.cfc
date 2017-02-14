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
component entityname="SlatwallVendorOrder" table="SwVendorOrder" persistent="true" accessors="true" output="false" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="vendorOrderService" hb_permission="this" hb_processContexts="addOrderItems,receiveStock,addVendorOrderItem,receive" {
	
	// Persistent Properties
	property name="vendorOrderID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="vendorOrderNumber" ormtype="string";
	property name="estimatedReceivalDateTime" ormtype="timestamp";
	property name="currencyCode" ormtype="string" length="3" hb_formFieldType="select";
	
	// Related Object Properties (Many-To-One)
	property name="billToLocation" cfc="Location" fieldtype="many-to-one" fkcolumn="locationID";
	property name="vendor" cfc="Vendor" fieldtype="many-to-one" fkcolumn="vendorID";
	property name="vendorOrderType" cfc="Type" fieldtype="many-to-one" fkcolumn="vendorOrderTypeID" hb_optionsSmartListData="f:parentType.systemCode=vendorOrderType";
	property name="vendorOrderStatusType" cfc="Type" fieldtype="many-to-one" fkcolumn="vendorOrderStatusTypeID" hb_optionsSmartListData="f:parentType.systemCode=vendorOrderStatusType";
	
	// Related Object Properties (One-To-Many)
	property name="attributeValues" singularname="attributeValue" cfc="AttributeValue" type="array" fieldtype="one-to-many" fkcolumn="vendorOrderID" cascade="all-delete-orphan" inverse="true";
	property name="vendorOrderItems" singularname="vendorOrderItem" cfc="VendorOrderItem" fieldtype="one-to-many" fkcolumn="vendorOrderID" inverse="true" cascade="all";
	property name="stockReceivers" singularname="stockReceiver" cfc="StockReceiver" type="array" fieldtype="one-to-many" fkcolumn="vendorOrderID" cascade="all-delete-orphan" inverse="true";
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	// Non persistent properties
	property name="addVendorOrderItemSkuOptionsSmartList" persistent="false";
	property name="currencyCodeOptions" persistent="false";
	property name="subTotal" persistent="false" hb_formatType="currency";
	property name="total" persistent="false" hb_formatType="currency"; 
	
	
	
	public void function removeAllVendorOrderItems() {
		for(var i=arrayLen(getVendorOrderItems()); i >= 1; i--) {
			getVendorOrderItems()[i].removeVendorOrder(this);
		}
	}
	
	public boolean function isProductInVendorOrder(required any productID) {
		return getService("VendorOrderService").isProductInVendorOrder(arguments.productID, this.getVendorOrderId());
	}
	
	// This method first finds the Stock with the provided sku and location, then searches in the VendorOrder's Items list for an item with that stock. If either are not found, it returns a blank VendorOrderItem
	public any function getVendorOrderItemForSkuAndLocation(required any skuID, required any locationID) {
		var sku = getService("SkuService").getSku(arguments.skuID);
		var location = getService("LocationService").getLocation(arguments.locationID);
		var stock = getService("StockService").getStockBySkuAndLocation(sku, location);
		
		for(var i=1; i<=arrayLen(getVendorOrderItems()); i++) {
			if(getVendorOrderItems()[i].hasStock(stock)) {
				return vendorOrderItems[i];
			}
		}
		
		// Otherwise, if stock was null (could not find one with that sku and location) or no VendorOrderItem was found with the located stock, return a new VendorOrderItem
		return getService("VendorOrderService").newVendorOrderItem();
	}
	
	public any function getVendorOrderItemCostForSku(required any skuID) {
		// Search over all VendorOrderItems to find one that has a stock for the given skuID
		var vendorOrderItems = getVendorOrderItems(); 
		for(var i=1; i <= ArrayLen(vendorOrderItems); i++){
			if(vendorOrderItems[i].getStock().getSku().getSkuID() == arguments.skuID) {
				return vendorOrderItems[i].getCost();
			}
		}
		
		// Otherwise, if nothing could be found, the cost is 0.
		return 0;	
	}
	
	public any function getQuantityOfStockAlreadyOnOrder(required any skuID, required any locationID) {
		return getService("VendorOrderService").getQuantityOfStockAlreadyOnOrder(getVendorOrderID(), arguments.skuID, arguments.locationID);
	}
	
	public any function getQuantityOfStockAlreadyReceived(required any skuID, required any locationID) {
		return getService("VendorOrderService").getQuantityOfStockAlreadyReceived(getVendorOrderID(), arguments.skuID, arguments.locationID);
	}
	
	public any function getSkusOrdered() {
		return getService("VendorOrderService").getSkusOrdered(getVendorOrderId());
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	public array function getCurrencyCodeOptions() {
		return getService("currencyService").getCurrencyOptions();
	}
	
	public numeric function getSubtotal() {
		var subtotal = 0;
		for(var i=1; i<=arrayLen(getVendorOrderItems()); i++) {
			subtotal = getService('HibachiUtilityService').precisionCalculate(subtotal + getVendorOrderItems()[i].getExtendedCost());
		}
		return subtotal;
	}
	
	public numeric function getTotal() {
		return getSubtotal() /*+ getTaxTotal() + getFulfillmentTotal()*/;
	}
	
	public any function getAddVendorOrderItemSkuOptionsSmartList() {
		if(!structKeyExists(variables, "addVendorOrderItemSkuOptionsSmartList")) {
			variables.addVendorOrderItemSkuOptionsSmartList = getService("skuService").getSkuSmartList();
		}
		return variables.addVendorOrderItemSkuOptionsSmartList;
	}
	
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Vendor (many-to-one)
	public void function setVendor(required any vendor) {
		variables.vendor = arguments.vendor;
		if(isNew() or !arguments.vendor.hasVendorOrder( this )) {
			arrayAppend(arguments.vendor.getVendorOrders(), this);
		}
	}
	public void function removeVendor(any vendor) {
		if(!structKeyExists(arguments, "vendor")) {
			arguments.vendor = variables.vendor;
		}
		var index = arrayFind(arguments.vendor.getVendorOrders(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.vendor.getVendorOrders(), index);
		}
		structDelete(variables, "vendor");
	}
	
	// Attribute Values (one-to-many)    
	public void function addAttributeValue(required any attributeValue) {    
		arguments.attributeValue.setVendorOrder( this );    
	}    
	public void function removeAttributeValue(required any attributeValue) {    
		arguments.attributeValue.removeVendorOrder( this );    
	}
	
	// Stock Receivers (one-to-many)
	public void function addStockReceiver(required any stockReceiver) {
		arguments.stockReceiver.setVendorOrder( this );
	}
	public void function removeStockReceiver(required any stockReceiver) {
		arguments.stockReceiver.removeVendorOrder( this );
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// ============== START: Overridden Implicet Getters ===================
	
	public any function getCurrencyCode() {
		if( !structKeyExists(variables, "currencyCode") ) {
			variables.currencyCode = "USD";
		}
		return variables.currencyCode;
	}

	public any function getVendorOrderType() {
		if( !structKeyExists(variables, "vendorOrderType") ) {
			variables.vendorOrderType = getService("typeService").getTypeBySystemCode("votPurchaseOrder");
		}
		return variables.vendorOrderType;
	}
	
	public any function getVendorOrderStatusType() {
		if( !structKeyExists(variables, "vendorOrderStatusType") ) {
			variables.vendorOrderStatusType = getService("typeService").getTypeBySystemCode("vostNew");
		}
		return variables.vendorOrderStatusType;
	}
	
	// ==============  END: Overridden Implicet Getters ====================
	
	// ================== START: Overridden Methods ========================
	
	public string function getSimpleRepresentation() {
		return "#getVendor().getVendorName()# - #getVendorOrderNumber()#";
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	public void function preInsert(){
		super.preInsert();
		
		// Verify Defaults are Set
		getVendorOrderType();
		getVendorOrderStatusType();
	}
	
	// ===================  END:  ORM Event Hooks  =========================
}

