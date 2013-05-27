/*

    Slatwall - An Open Source eCommerce Platform
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

Notes:

*/
component displayname="Order Fulfillment" entityname="SlatwallOrderFulfillment" table="SlatwallOrderFulfillment" persistent=true accessors=true output=false extends="HibachiEntity" cacheuse="transactional" hb_serviceName="orderService" hb_permission="order.orderFulfillments" hb_processContexts="fulfillItems" {
	
	// Persistent Properties
	property name="orderFulfillmentID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="fulfillmentCharge" ormtype="big_decimal" default=0;
	property name="currencyCode" ormtype="string" length="3";
	property name="emailAddress" ormtype="string";
	property name="manualFulfillmentChargeFlag" ormtype="boolean" hb_populateEnabled="false";
	
	// Related Object Properties (many-to-one)
	property name="accountAddress" cfc="AccountAddress" fieldtype="many-to-one" fkcolumn="accountAddressID";
	property name="accountEmailAddress" cfc="AccountEmailAddress" fieldtype="many-to-one" fkcolumn="accountEmailAddressID";
	property name="fulfillmentMethod" cfc="FulfillmentMethod" fieldtype="many-to-one" fkcolumn="fulfillmentMethodID";
	property name="order" cfc="Order" fieldtype="many-to-one" fkcolumn="orderID";
	property name="shippingAddress" cfc="Address" fieldtype="many-to-one" fkcolumn="shippingAddressID";
	property name="shippingMethod" cfc="ShippingMethod" fieldtype="many-to-one" fkcolumn="shippingMethodID";
	
	// Related Object Properties (one-to-many)
	property name="orderFulfillmentItems" singularname="orderFulfillmentItem" cfc="OrderItem" fieldtype="one-to-many" fkcolumn="orderFulfillmentID" cascade="all" inverse="true";
	property name="appliedPromotions" singularname="appliedPromotion" cfc="PromotionApplied" fieldtype="one-to-many" fkcolumn="orderFulfillmentID" cascade="all-delete-orphan" inverse="true";
	property name="fulfillmentShippingMethodOptions" singularname="fulfillmentShippingMethodOption" cfc="ShippingMethodOption" fieldtype="one-to-many" fkcolumn="orderFulfillmentID" cascade="all-delete-orphan" inverse="true";

	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (many-to-many - inverse)
	
	// Remote properties
	property name="remoteID" ormtype="string";
	
	// Audit properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties
	property name="accountAddressOptions" type="array" persistent="false";
	property name="chargeAfterDiscount" type="numeric" persistent="false" hb_formatType="currency";
	property name="discountAmount" type="numeric" persistent="false" hb_formatType="currency";
	property name="fulfillmentMethodType" type="numeric" persistent="false";
	property name="orderStatusCode" type="numeric" persistent="false";
	property name="quantityUndelivered" type="numeric" persistent="false";
	property name="quantityDelivered" type="numeric" persistent="false";
	property name="shippingMethodRate" type="array" persistent="false";
	property name="shippingMethodOptions" type="array" persistent="false";
	property name="subtotal" type="numeric" persistent="false" hb_formatType="currency";
	property name="subtotalAfterDiscounts" type="array" persistent="false" hb_formatType="currency";
	property name="subtotalAfterDiscountsWithTax" type="array" persistent="false" hb_formatType="currency";    
	property name="taxAmount" type="numeric" persistent="false" hb_formatType="currency";
	property name="totalShippingWeight" type="numeric" persistent="false" hb_formatType="weight";
	
	public void function removeAccountAddress() {
		structDelete(variables, "AccountAddress");
	}

	public void function removeShippingAddress() {
		structDelete(variables, "ShippingAddress");
	}
	
	public numeric function getDiscountTotal() {
		return precisionEvaluate(getDiscountAmount() + getItemDiscountAmountTotal());
	}
    
	public numeric function getShippingCharge() {
		return getFulfillmentCharge();
	}
	
	public boolean function hasValidShippingMethodRate() {
		return getService("shippingService").verifyOrderFulfillmentShippingMethodRate( this );
	}
	
	// Helper method to return either the shippingAddress or accountAddress to be used
    public any function getAddress(){
    	
    	// If the shipping address is not null, then we can return it
    	if(!isNull(getShippingAddress())){
    		
    		return getShippingAddress();
    		
    	// This is a hook to fix deprecated methodology
    	} else if(!isNull(getAccountAddress())) {
    		
    		// Get the account address, copy it, and save as the shipping address
    		setShippingAddress( getAccountAddress().getAddress().copyAddress( true ) );
    		
    		// Now return the shipping address
    		return getShippingAddress();
    	} else {
    		
    		// If no address, then just return a new one.
    		return getService("addressService").newAddress();
    	}
    }

	// ============ START: Non-Persistent Property Methods =================
	
    public any function getAccountAddressOptions() {
    	if( !structKeyExists(variables, "accountAddressOptions")) {
    		var smartList = getService("accountService").getAccountAddressSmartList();
			smartList.addSelect(propertyIdentifier="accountAddressName", alias="name");
			smartList.addSelect(propertyIdentifier="accountAddressID", alias="value"); 
			smartList.addFilter(propertyIdentifier="account.accountID",value=this.getOrder().getAccount().getAccountID(),fetch="false");
			smartList.addOrder("accountAddressName|ASC");
			variables.accountAddressOptions = smartList.getRecords();
		}
		return variables.accountAddressOptions;
	}
	
	public numeric function getChargeAfterDiscount() {
		return precisionEvaluate(getFulfillmentCharge() - getDiscountAmount());
	}
	
	public numeric function getDiscountAmount() {
		discountAmount = 0;
		for(var i=1; i<=arrayLen(getAppliedPromotions()); i++) {
			discountAmount = precisionEvaluate(discountAmount + getAppliedPromotions()[i].getDiscountAmount());
		}
		return discountAmount;
	}
	
	public any function getFulfillmentMethodType() {
		return getFulfillmentMethod().getFulfillmentMethodType();
	}
	
    public numeric function getFulfillmentTotal() {
    	return precisionEvaluate(getSubtotalAfterDiscountsWithTax() + getChargeAfterDiscount());
    }
        
   	public numeric function getItemDiscountAmountTotal() {
   		if(!structKeyExists(variables, "itemDiscountAmountTotal")) {
   			variables.itemDiscountAmountTotal = 0;
   			for(var i=1; i<=arrayLen(getOrderFulfillmentItems()); i++) {
				variables.itemDiscountAmountTotal = precisionEvaluate(variables.itemDiscountAmountTotal + getOrderFulfillmentItems()[i].getDiscountAmount());
			}
   		}
		return variables.itemDiscountAmountTotal;
	}
    
	public any function getOrderStatusCode() {
		return getOrder().getStatusCode();
	}
	
	public numeric function getQuantityUndelivered() {
    	var quantityUndelivered = 0;
		
		for(var i=1; i<=arrayLen(getOrderFulfillmentItems());i++) {
			quantityUndelivered += getOrderFulfillmentItems()[i].getQuantityUndelivered();
		}
    	
    	return quantityUndelivered;
    }
    
    public numeric function getQuantityDelivered() {
    	var quantityDelivered = 0;
		
		for(var i=1; i<=arrayLen(getOrderFulfillmentItems());i++) {
			quantityDelivered += getOrderFulfillmentItems()[i].getQuantityDelivered();
		}
    	
    	return quantityDelivered;
    }
    
    public any function getShippingMethodOptions() {
    	if( !structKeyExists(variables, "shippingMethodOptions")) {
    		// If there aren't any shippingMethodOptions available, then try to populate this fulfillment
    		if( !arrayLen(getFulfillmentShippingMethodOptions()) ) {
    			getService("shippingService").updateOrderFulfillmentShippingMethodOptions( this );
    		}
    		
    		// At this point they have either been populated just before, or there were already options
    		var oArr = [];
    		var fsmo = getFulfillmentShippingMethodOptions();
    		for(var i=1; i<=arrayLen(fsmo); i++) {
    			arrayAppend(oArr, {name=fsmo[i].getSimpleRepresentation(), value=fsmo[i].getShippingMethodRate().getShippingMethod().getShippingMethodID()});	
    		}
    		if(arrayLen(oArr)) {
    			arrayPrepend(oArr, {name=rbKey('define.select'), value=''});
    		} else {
    			arrayPrepend(oArr, {name=rbKey('define.none'), value=''});
    		}
    		variables.shippingMethodOptions = oArr;
    	}
    	return variables.shippingMethodOptions; 
    }
    
	public any function getShippingMethodRate() {
    	if(!isNull(getSelectedShippingMethodOption())) {
    		return getSelectedShippingMethodOption().getShippingMethodRate();
    	}
    }
    
    public any function getSelectedShippingMethodOption() {
    	if(!structKeyExists(variables, "selectedShippingMethodOption")) {
    		if(!isNull(getShippingMethod())) {
	    		for(var i=1; i<=arrayLen(getFulfillmentShippingMethodOptions()); i++) {
	    			if(getShippingMethod().getShippingMethodID() == getFulfillmentShippingMethodOptions()[i].getShippingMethodRate().getShippingMethod().getShippingMethodID()) {
	    				variables.selectedShippingMethodOption = getFulfillmentShippingMethodOptions()[i];
	    			}		 	
	    		}	
	    	}	
    	}
    	if(structKeyExists(variables, "selectedShippingMethodOption")) {
    		return variables.selectedShippingMethodOption;	
    	}
    }
    
	public numeric function getSubtotal() {
  		if( !structKeyExists(variables,"subtotal") ) {
	    	variables.subtotal = 0;
	    	for( var i=1; i<=arrayLen(getOrderFulfillmentItems()); i++ ) {
	    		variables.subtotal = precisionEvaluate(variables.subtotal + getOrderFulfillmentItems()[i].getExtendedPrice());
	    	}
  		}
    	return variables.subtotal;
    }
    
    public numeric function getSubtotalAfterDiscounts() {
    	return precisionEvaluate(getSubtotal() - getItemDiscountAmountTotal());
    }
    
    public numeric function getSubtotalAfterDiscountsWithTax() {
    	return precisionEvaluate(getSubtotal() - getItemDiscountAmountTotal() + getTaxAmount());
    }
    
    public numeric function getTaxAmount() {
    	if( !structkeyExists(variables, "taxAmount") ) {
    		variables.taxAmount = 0;
	    	for( var i=1; i<=arrayLen(getOrderFulfillmentItems()); i++ ) {
	    		variables.taxAmount = precisionEvaluate(variables.taxAmount + getOrderFulfillmentItems()[i].getTaxAmount());
	    	}
    	}
    	return variables.taxAmount;
    }
    
	public numeric function getTotalShippingWeight() {
    	if( !structKeyExists(variables, "totalShippingWeight") ) {
	    	variables.totalShippingWeight = 0;
	    	for( var i=1; i<=arrayLen(getOrderFulfillmentItems()); i++ ) {
	    		var convertedWeight = getService("measurementService").convertWeightToGlobalWeightUnit(getOrderFulfillmentItems()[i].getSku().setting('skuShippingWeight'), getOrderFulfillmentItems()[i].getSku().setting('skuShippingWeightUnitCode'));
	    		variables.totalShippingWeight = precisionEvaluate(variables.totalShippingWeight + (convertedWeight * getOrderFulfillmentItems()[i].getQuantity()) );
	    	}			
  		}
    	return variables.totalShippingWeight;
    }
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Order (many-to-one)
	public void function setOrder(required any order) {    
		variables.order = arguments.order;    
		if(isNew() or !arguments.order.hasOrderFulfillment( this )) {    
			arrayAppend(arguments.order.getOrderFulfillments(), this);    
		}
	}
	public void function removeOrder(any order) {    
		if(!structKeyExists(arguments, "order")) {    
			arguments.order = variables.order;    
		}    
		var index = arrayFind(arguments.order.getOrderFulfillments(), this);    
		if(index > 0) {    
			arrayDeleteAt(arguments.order.getOrderFulfillments(), index);    
		}    
		structDelete(variables, "order");    
	}
	
	// Fulfillment Method (many-to-one)
	public void function setFulfillmentMethod(required any fulfillmentMethod) {
		variables.fulfillmentMethod = arguments.fulfillmentMethod;
		if(isNew() or !arguments.fulfillmentMethod.hasOrderFulfillment( this )) {
			arrayAppend(arguments.fulfillmentMethod.getOrderFulfillments(), this);
		}
	}
	public void function removeFulfillmentMethod(any fulfillmentMethod) {
		if(!structKeyExists(arguments, "fulfillmentMethod")) {
			arguments.fulfillmentMethod = variables.fulfillmentMethod;
		}
		var index = arrayFind(arguments.fulfillmentMethod.getOrderFulfillments(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.fulfillmentMethod.getOrderFulfillments(), index);
		}
		structDelete(variables, "fulfillmentMethod");
	}
	
	// Fulfillment Shipping Method Options (one-to-many)    
	public void function addFulfillmentShippingMethodOption(required any fulfillmentShippingMethodOption) {    
		arguments.fulfillmentShippingMethodOption.setOrderFulfillment( this );    
	}    
	public void function removeFulfillmentShippingMethodOption(required any fulfillmentShippingMethodOption) {    
		arguments.fulfillmentShippingMethodOption.removeOrderFulfillment( this );    
	}
	
	// Applied Promotions (one-to-many)    
	public void function addAppliedPromotion(required any appliedPromotion) {    
		arguments.appliedPromotion.setOrderFulfillment( this );    
	}    
	public void function removeAppliedPromotion(required any appliedPromotion) {    
		arguments.appliedPromotion.removeOrderFulfillment( this );    
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// =============== START: Custom Validation Methods ====================
	
	// ===============  END: Custom Validation Methods =====================
	
	// =============== START: Custom Formatting Methods ====================
	
	// ===============  END: Custom Formatting Methods =====================
	
	// ================== START: Overridden Methods ========================
	
	public boolean function getManualfulfillmentChargeFlag() {
		if(!structKeyExists(variables, "manualFulfillmentChargeFlag")) {
			variables.manualFulfillmentChargeFlag = 0;
		}
		return variables.manualFulfillmentChargeFlag;
	}
	
	// sets it up so that if an accountAddressID is passed in, then we will automatically copy it as the billing address
	public void function setAccountAddress(required any accountAddress) {
		variables.accountAddress = arguments.accountAddress;
		
		setShippingAddress( variables.accountAddress.getAddress().copyAddress( true ) );
	}
	
	public void function clearShippingMethod(){
		variables.shippingMethod=javaCast("null","");
	}
	
	// sets it up so that the charge for the shipping method is pulled out of the shippingMethodOptions
	public void function setShippingMethod(required any shippingMethod) {
		
		// If there aren't any shippingMethodOptions available, then try to populate this fulfillment
		if( !arrayLen(getFulfillmentShippingMethodOptions()) ) {
			getService("shippingService").updateOrderFulfillmentShippingMethodOptions( this );
		}
		
		// make sure that the shippingMethod exists in the fulfillmentShippingMethodOptions
		for(var i=1; i<=arrayLen(getFulfillmentShippingMethodOptions()); i++) {
			if(arguments.shippingMethod.getShippingMethodID() == getFulfillmentShippingMethodOptions()[i].getShippingMethodRate().getShippingMethod().getShippingMethodID()) {
				
				// Set the method
				variables.shippingMethod = arguments.shippingMethod;
				
				// Set the charge
				if(!getManualfulfillmentChargeFlag()) {
					setFulfillmentCharge( getFulfillmentShippingMethodOptions()[i].getTotalCharge() );	
				}
			}
		}
	}
	
	
	public string function getSimpleRepresentation() {
		var rep = "";
		if(getOrder().getOrderStatusType().getSystemCode() neq "ostNotPlaced") {
			rep &= "#getOrder().getOrderNumber()# - ";
		}
		rep &= "#rbKey('enity.orderFulfillment.orderFulfillmentType.#getFulfillmentMethodType()#')#";
		if(getFulfillmentMethodType() eq "shipping" && !isNull(getAddress()) && !getAddress().isNew() && !isNull(getAddress().getStreetAddress())) {
			rep &= " - #getAddress().getStreetAddress()#";
		}
		if(getFulfillmentMethodType() eq "email" && !isNull(getEmailAddress())) {
			rep &= " - #getEmailAddress()#";
		}
		if(getFulfillmentMethodType() eq "email" && !isNull(getAccountEmailAddress())) {
			rep &= " - #getAccountEmailAddress().getEmailAddress()#";
		}
		return rep;
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}
