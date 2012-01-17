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

Notes:

*/
component extends="BaseService" persistent="false" accessors="true" output="false" {

	property name="accountService";
	property name="addressService";
	property name="locationService";
	property name="paymentService";
	property name="promotionService";
	property name="sessionService";
	property name="taxService";
	property name="utilityFormService";
	property name="utilityTagService";
	property name="utilityService";
	property name="utilityEmailService";
	property name="stockService";
	property name="typeService";
	//property name="SettingService";
	
	public any function getOrderSmartList(struct data={}) {
		arguments.entityName = "SlatwallOrder";
	
		// Set the defaul showing to 25
		if(!structKeyExists(arguments.data, "P:Show")) {
			arguments.data["P:Show"] = 25;
		}
	
		// If nothing was set in the data for a filter on order status, set a default
		if(!structKeyExists(arguments.data, "F:orderStatusType_systemCode") && !structKeyExists(arguments.data, "F:orderStatusType_typeID")) {
			arguments.data["F:orderStatusType_systemCode"] = "ostNew,ostProcessing,ostOnHold";
		}
	
		var smartList = getDAO().getSmartList(argumentCollection=arguments);
		smartList.addKeywordProperty(propertyIdentifier="orderNumber", weight=9);
		smartList.addKeywordProperty(propertyIdentifier="account_lastname", weight=4);
		smartList.addKeywordProperty(propertyIdentifier="account_firstname", weight=3);
		smartList.joinRelatedProperty("SlatwallOrder", "account");
	
		return smartList;
	}
	
	public any function getOrderFulfillmentSmartList(struct data={}) {
		arguments.entityName = "SlatwallOrderFulfillment";
		var smartList = getDAO().getSmartList(argumentCollection=arguments);
		smartList.addOrder("order_orderOpenDateTime|DESC");
		return smartList;
	}
	
	public any function getOrderStatusOptions(struct data={}) {
		arguments.entityName = "SlatwallType";
		var smartlist = getDAO().getSmartList(argumentCollection=arguments);
		smartList.addSelect("systemCode", "id");
		smartList.addSelect("type", "name");
		smartList.addFilter("parentType_systemCode", "orderStatusType");
		smartList.addFilter("systemCode", "ostNew,ostProcessing,ostOnHold,ostClosed,ostCanceled");
		return smartlist.getRecords();
	}
	
	public any function saveOrder(required any order, struct data={}) {
	
		// Call the super.save() method to do the base populate & validate logic
		arguments.order = super.save(entity=arguments.order, data=arguments.data);
	
		// If the order has not been placed yet, loop over the orderItems to remove any that have a qty of 0
		if(arguments.order.getStatusCode() == "ostNotPlaced") {
			for(var i = arrayLen(arguments.order.getOrderItems()); i >= 1; i--) {
				if(arguments.order.getOrderItems()[i].getQuantity() < 1) {
					arguments.order.removeOrderItem(arguments.order.getOrderItems()[i]);
				}
			}
		}
	
		// Recalculate the order amounts for tax and promotions
		recalculateOrderAmounts(arguments.order);
	
		return arguments.order;
	}
	
	public any function searchOrders(struct data={}) {
		//set keyword and orderby
		var params = {keyword=arguments.data.keyword, orderBy=arguments.data.orderBy};
		// pass rc params (for paging) to smartlist
		structAppend(params, arguments.data);
		// if someone tries to filter for carts using URL, override the filter
		if(listFindNoCase(arguments.data.statusCode, "ostNotPlaced")) {
			params.statusCode = "ostNew,ostProcessing";
		} else {
			params['F:orderstatustype_systemcode'] = arguments.data.statusCode;
		}
		
		// date range (start or end) have been submitted
		if(len(trim(arguments.data.orderDateStart)) > 0 || len(trim(arguments.data.orderDateEnd)) > 0) {
			var dateStart = arguments.data.orderDateStart;
			var dateEnd = arguments.data.orderDateEnd;
			// if either the start or end date is blank, default them to a long time ago or now(), respectively 
			if(len(trim(arguments.data.orderDateStart)) == 0) {
				dateStart = createDateTime(30, 1, 1, 0, 0, 0);
			} else if(len(trim(arguments.data.orderDateEnd)) == 0)	{
				dateEnd = now();
			}
			
			if(isDate(dateStart) && isDate(dateEnd))	{
				// since were comparing to datetime objects, I'll add 85,399 seconds to the end date to make 
				//sure we get all orders on the last day of the range (only if it was entered)
				if(len(trim(arguments.data.orderDateEnd)) > 0) {
					dateEnd = dateAdd('s', 85399, dateEnd);
				}
				params['R:orderOpenDateTime'] = "#dateStart#,#dateEnd#";
			} else {
				arguments.data.message = #arguments.data.$.slatwall.rbKey("admin.order.search.invaliddates")#;
				arguments.data.messagetype = "warning";
			}
		}
		return getOrderSmartList(params);
	}
	
	public void function addOrderItem(required any order, required any sku, numeric quantity=1, any orderFulfillment,struct customizatonData)	{
	
		// Check to see if the order has already been closed or canceled
		if(arguments.order.getOrderStatusType().getSystemCode() == "ostClosed" || arguments.order.getOrderStatusType().getSystemCode() == "ostCanceled") {
			throw("You cannot add an item to an order that has been closed or canceled");
		}
	
		// Check for an orderFulfillment in the arguments.  If none, use the orders first.  If none has been setup create a new one
		if(!structKeyExists(arguments, "orderFulfillment"))	{
			var osArray = arguments.order.getOrderFulfillments();
			if(!arrayLen(osArray)) {
				// TODO: This next is a hack... later the type of Fulfillment created should be dynamic
				arguments.orderFulfillment = this.newOrderFulfillmentShipping();
			
				arguments.orderFulfillment.setOrder(arguments.order);
			
				// Push the fulfillment into the hibernate scope
				getDAO().save(arguments.orderFulfillment);
			} else {
				arguments.orderFulfillment = osArray[1];
			}
		}
	
		var orderItems = arguments.order.getOrderItems();
		var itemExists = false;
		
		// If there are no product customizations then we can check for the order item already existing.
		if(!structKeyExists(arguments, "customizatonData") || !structKeyExists(arguments.customizatonData,"attribute"))	{
			// Check the existing order items and increment quantity if possible.
			for(var i = 1; i <= arrayLen(orderItems); i++) {
				if(orderItems[i].getSku().getSkuID() == arguments.sku.getSkuID() && orderItems[i].getOrderFulfillment().getOrderFulfillmentID() == arguments.orderFulfillment.getOrderFulfillmentID()) {
					itemExists = true;
					orderItems[i].setQuantity(orderItems[i].getQuantity() + arguments.quantity);
					orderItems[i].getOrderFulfillment().orderFulfillmentItemsChanged();
				}
			}
		}
	
		// If the sku doesn't exist in the order, then create a new order item and add it
		if(!itemExists)	{
			var newItem = this.newOrderItem();
			newItem.setSku(arguments.sku);
			newItem.setQuantity(arguments.quantity);
			newItem.setOrder(arguments.order);
			newItem.setOrderFulfillment(arguments.orderFulfillment);
			newItem.setPrice(arguments.sku.getLivePrice());
		
			// Check for product customization
			if(structKeyExists(arguments, "customizatonData") && structKeyExists(arguments.customizatonData, "attribute")) {
				var pcas = arguments.sku.getProduct().getAttributeSets(['astProductCustomization']);
				for(var i = 1; i <= arrayLen(pcas); i++) {
					var attributes = pcas[i].getAttributes();
					
					for(var a = 1; a <= arrayLen(attributes); a++) {
						if(structKeyExists(arguments.customizatonData.attribute, attributes[a].getAttributeID())) {
							var av = this.newOrderItemAttributeValue();
							av.setAttribute(attributes[a]);
							av.setAttributeValue(arguments.customizatonData.attribute[attributes[a].getAttributeID()]);
							av.setOrderItem(newItem);
						}
					}
				}
			}
		}
	
		// Recalculate the order amounts for tax and promotions
		recalculateOrderAmounts(arguments.order);
	
		save(arguments.order);
	}
	
	public void function removeOrderItem(required any order, required string orderItemID) {
	
		// Loop over all of the items in this order
		for(var i = 1; i <= arrayLen(arguments.order.getOrderItems()); i++)	{
		
			// Check to see if this item is the same ID as the one passed in to remove
			if(arguments.order.getOrderItems()[i].getOrderItemID() == arguments.orderItemID) {
			
				// Actually Remove that Item
				arguments.order.removeOrderItem(arguments.order.getOrderItems()[i]);
			}
		}
	}
	
	public boolean function updateAndVerifyOrderAccount(required any order, required struct data) {
		var accountOK = true;
		
		if(structKeyExists(data, "account")) {
			var accountData = data.account;
			var account = getAccountService().getAccount(accountData.accountID, true);
			account = getAccountService().saveAccount(account, accountData, data.siteID);
			arguments.order.setAccount(account);
		}
	
		if(isNull(arguments.order.getAccount()) || arguments.order.getAccount().hasErrors()) {
			accountOK = false;
		}
	
		return accountOK;
	}
	
	public boolean function updateAndVerifyOrderFulfillments(required any order, required struct data) {
		var fulfillmentsOK = true;
		
		if(structKeyExists(data, "orderFulfillments")) {
		
			var fulfillmentsDataArray = data.orderFulfillments;
			
			for(var i = 1; i <= arrayLen(fulfillmentsDataArray); i++) {
			
				var fulfillment = this.getOrderFulfillment(fulfillmentsDataArray[i].orderFulfillmentID, true);
				
				if(arguments.order.hasOrderFulfillment(fulfillment)) {
					fulfillment = this.saveOrderFulfillment(fulfillment, fulfillmentsDataArray[i]);
					if(fulfillment.hasErrors())	{
						fulfillmentsOK = false;
					}
				}
			}
		}
	
		// Check each of the fulfillment methods to see if they are complete
		for(var i = 1; i <= arrayLen(arguments.order.getOrderFulfillments()); i++) {
			if(!arguments.order.getOrderFulfillments()[i].isProcessable()) {
				fulfillmentsOK = false;
			}
		}
	
		return fulfillmentsOK;
	}
	
	public boolean function updateAndVerifyOrderPayments(required any order, required struct data) {
		var paymentsOK = true;
		
		if(structKeyExists(data, "orderPayments")) {
			var paymentsDataArray = data.orderPayments;
			for(var i = 1; i <= arrayLen(paymentsDataArray); i++) {
				var payment = this.getOrderPaymentCreditCard(paymentsDataArray[i].orderPaymentID, true);
				
				if((payment.isNew() && order.getPaymentAmountTotal() < order.getTotal()) || !payment.isNew()) {
					if((payment.isNew() || isNull(payment.getAmount()) || payment.getAmount() <= 0) && !structKeyExists(paymentsDataArray[i],"amount"))	{
						paymentsDataArray[i].amount = order.getTotal() - order.getPaymentAmountTotal();
					} else if(!payment.isNew() && (isNull(payment.getAmountAuthorized()) || payment.getAmountAuthorized() == 0) && !structKeyExists(paymentsDataArray[i], "amount")) {
						paymentsDataArray[i].amount = order.getTotal() - order.getPaymentAmountAuthorizedTotal();
					}
					
					// Make sure the payment is attached to the order
					payment.setOrder(arguments.order);
				
					// Attempt to Validate & Save Order Payment
					payment = this.saveOrderPaymentCreditCard(payment, paymentsDataArray[i]);
				
					// Check to see if this payment has any errors and if so then don't proceed
					if(payment.hasErrors() || payment.getBillingAddress().hasErrors() || payment.getCreditCardType() == "Invalid") {
						paymentsOK = false;
					}
				}
			}
		}
	
		// Verify that there are enough payments applied to the order to proceed
		if(order.getPaymentAmountTotal() < order.getTotal()) {
			paymentsOK = false;
		}
	
		return paymentsOK;
	}
	
	private boolean function processOrderPayments(required any order) {
		var allPaymentsProcessed = true;
		
		// Process All Payments and Save the ones that were successful
		for(var i = 1; i <= arrayLen(arguments.order.getOrderPayments()); i++) {
			var transactionType = setting('paymentMethod_#arguments.order.getOrderPayments()[i].getPaymentMethodID()#_checkoutTransactionType');
			
			if(transactionType != 'none') {
				var paymentOK = getPaymentService().processPayment(order.getOrderPayments()[i], transactionType);
				if(!paymentOK) {
					order.getOrderPayments()[i].setAmount(0);
					allPaymentsProcessed = false;
				}
			}
		}
	
		return allPaymentsProcessed;
	}
	
	public boolean function chargeOrderPayment(any orderPayment, required string transactionID) {
		var chargeOK = getPaymentService().processPayment(arguments.orderPayment, 
		                                                  "chargePreAuthorization",
		                                                  arguments.orderPayment.getAmount(),
		                                                  arguments.transactionID);
		if(chargeOK) {
			// set status of the order
			var order = arguments.orderPayment.getOrder();
			if(order.getQuantityUndelivered() gt 0)	{
				order.setOrderStatusType(this.getTypeBySystemCode("ostProcessing"));
			} else {
				order.setOrderStatusType(this.getTypeBySystemCode("ostClosed"));
			}
		}
		return chargeOK;
	}
	
	public any function processOrder(struct data={}) {
		var processOK = false;
		
		// Lock down this determination so that the values getting called and set don't overlap
		lock scope="Session", timeout="60" {
		
			var order = this.getOrder(arguments.data.orderID);
			
			getDAO().reloadEntity(order);
		
			if(order.getOrderStatusType().getSystemCode() != "ostNotPlaced") {
				processOK = true;
			} else {
				// update and validate all aspects of the order
				var validAccount = updateAndVerifyOrderAccount(order=order, data=arguments.data);
				var validPayments = updateAndVerifyOrderPayments(order=order, data=arguments.data);
				var validFulfillments = updateAndVerifyOrderFulfillments(order=order, data=arguments.data);
				
				if(validAccount && validPayments && validFulfillments) {
					// Double check that the order requirements list is blank
					var orderRequirementsList = getOrderRequirementsList(order);
					
					if(!len(orderRequirementsList)) {
						// prepare order for processing
						// copy shipping address if needed
						copyFulfillmentAddress(order=order);
					
						// Process all of the order payments
						var paymentsProcessed = processOrderPayments(order=order);
						
						// If processing was successfull then checkout
						if(paymentsProcessed) {
						
							// If this order is the same as the current cart, then set the current cart to a new order
							if(order.getOrderID() == getSessionService().getCurrent().getOrder().getOrderID()) {
								getSessionService().getCurrent().setOrder(JavaCast("null", ""));
							}
						
							// Update the order status
							order.setOrderStatusType(this.getTypeBySystemCode("ostNew"));
						
							// Save the order to the database
							getDAO().save(order);
						
							// Do a flush so that the order is commited to the DB
							getDAO().flushORMSession();
						
							logSlatwall(message="New Order Processed - Order Number: #order.getOrderNumber()# - Order ID: #order.getOrderID()#", generalLog=true);
						
							// Send out the e-mail
							getUtilityEmailService().sendOrderConfirmationEmail(order=order);
						
							processOK = true;
						}
					}
				}
			}
		}// END OF LOCK
		return processOK;
	}
	
	public any function getOrderRequirementsList(required any order) {
		var orderRequirementsList = "";
		
		// Check if the order still requires a valid account
		if(isNull(arguments.order.getAccount()) || arguments.order.getAccount().hasErrors()) {
			orderRequirementsList = listAppend(orderRequirementsList, "account");
		}
	
		// Check each of the fulfillment methods to see if they are ready to process
		for(var i = 1; i <= arrayLen(arguments.order.getOrderFulfillments()); i++) {
			if(!arguments.order.getOrderFulfillments()[i].isProcessable()) {
				orderRequirementsList = listAppend(orderRequirementsList, "fulfillment");
				orderRequirementsList = listAppend(orderRequirementsList, arguments.order.getOrderFulfillments()[i].getOrderFulfillmentID());
			}
		}
	
		// Make sure that the order total is the same as the total payments applied
		if(arguments.order.getTotal() != arguments.order.getPaymentAmountTotal()) {
			orderRequirementsList = listAppend(orderRequirementsList, "payment");
		}
	
		return orderRequirementsList;
	}
	
	public any function saveOrderFulfillment(required any orderFulfillment, struct data={}) {
	
		// If fulfillment method is shipping do this
		if(arguments.orderFulfillment.getFulfillmentMethod().getFulfillmentMethodID() == "shipping") {
			// define some variables for backward compatibility
			param name="data.saveAccountAddress" default="0";
			param name="data.saveAccountAddressName" default="";
			param name="data.addressIndex" default="0";
			
			// Get Address
			if(data.addressIndex != 0) {
				var address = getAddressService().getAddress(data.accountAddresses[data.addressIndex].address.addressID, true);
				var newAddressDataStruct = data.accountAddresses[data.addressIndex].address;
			} else {
				var address = getAddressService().getAddress(data.shippingAddress.addressID, true);
				var newAddressDataStruct = data.shippingAddress;
			}
		
			// Populate Address And check if it has changed
			var serializedAddressBefore = address.getSimpleValuesSerialized();
			address.populate(newAddressDataStruct);
			var serializedAddressAfter = address.getSimpleValuesSerialized();
			
			if(serializedAddressBefore != serializedAddressAfter) {
				arguments.orderFulfillment.removeShippingMethodAndMethodOptions();
				getTaxService().updateOrderAmountsWithTaxes(arguments.orderFulfillment.getOrder());
			}
		
			// if address needs to get saved in account
			if(data.saveAccountAddress == 1 || data.addressIndex != 0) {
				// new account address
				if(data.addressIndex == 0) {
					var accountAddress = getAddressService().newAccountAddress();
				} else {
					//Existing address
					var accountAddress = getAddressService().getAccountAddress(data.accountAddresses[data.addressIndex].accountAddressID, 
					                                                           true);
				}
				accountAddress.setAddress(address);
				accountAddress.setAccount(arguments.orderFulfillment.getOrder().getAccount());
			
				// Figure out the name for this new account address, or update it if needed
				if(data.addressIndex == 0) {
					if(structKeyExists(data, "saveAccountAddressName") && len(data.saveAccountAddressName)) {
						accountAddress.setAccountAddressName(data.saveAccountAddressName);
					} else {
						accountAddress.setAccountAddressName(address.getname());
					}
				} else if(structKeyExists(data, "accountAddresses") && structKeyExists(data.accountAddresses[data.addressIndex], "accountAddressName")) {
					accountAddress.setAccountAddressName(data.accountAddresses[data.addressIndex].accountAddressName);
				}
			
				arguments.orderFulfillment.removeShippingAddress();
				arguments.orderFulfillment.setAccountAddress(accountAddress);
			} else {
				// Set the address in the order Fulfillment as shipping address
				arguments.orderFulfillment.setShippingAddress(address);
				arguments.orderFulfillment.removeAccountAddress();
			}
		
			// Validate & Save Address
			address.validate(context="full");
		
			address = getAddressService().saveAddress(address);
		
			// Check for a shipping method option selected
			if(structKeyExists(arguments.data, "orderShippingMethodOptionID")) {
				var methodOption = this.getOrderShippingMethodOption(arguments.data.orderShippingMethodOptionID);
				
				// Verify that the method option is one for this fulfillment
				if(!isNull(methodOption) && arguments.orderFulfillment.hasOrderShippingMethodOption(methodOption)) {
					// Update the orderFulfillment to have this option selected
					arguments.orderFulfillment.setShippingMethod(methodOption.getShippingMethod());
					arguments.orderFulfillment.setFulfillmentCharge(methodOption.getTotalCharge());
				}
			}
		
			// Validate the order Fulfillment
			arguments.orderFulfillment.validate();
			if(!getRequestCacheService().getValue("ormHasErrors")) {
				getDAO().flushORMSession();
			}
		}
	
		// Save the order Fulfillment
		return getDAO().save(arguments.orderFulfillment);
	}
	
	public any function copyFulfillmentAddress(required any order) {
		for(var orderFulfillment in order.getOrderFulfillments()) {
			if(orderFulfillment.getFulfillmentMethod().getFulfillmentMethodID() == "shipping") {
				if(!isNull(orderFulfillment.getAccountAddress())) {
					orderFulfillment.setShippingAddress(orderFulfillment.getAccountAddress().getAddress());
					orderFulfillment.removeAccountAddress();
					getDAO().save(orderFulfillment);
				}
			}
		}
	}
	
	public any function processOrderFulfillment(required any orderFulfillment, struct data={}, required any locationID) {
		// Get the Order from the fulfillment
		var order = arguments.orderFulfillment.getOrder();
		
		// Figure out the Fulfillment Method
		var fulfillmentMethodID = arguments.orderFulfillment.getFulfillmentMethodID();
		
		// Create A New Order Delivery Type Based on fulfillment method
		var orderDelivery = this.new("SlatwallOrderDelivery#fulfillmentMethodID#");
		
		// Set the Order As the Order for this Delivery
		orderDelivery.setOrder(order);
		orderDelivery.setDeliveryOpenDateTime(now());
	
		// TODO: change close date to indicate when item was received, downloaded, picked up, etc.
		orderDelivery.setDeliveryCloseDateTime(now());
	
		// Set the location from which this order will be fulfilled. deliverFromLocation is also used when
		// setting the stock on OrderDeliveryItems.
		orderDelivery.setLocation(getLocationService().getLocation(arguments.locationID));
	
		// Per Fulfillment method set whatever other details need to be set
		
		switch(fulfillmentMethodID) {
			case("shipping"): {
				// copy the shipping address from the order fulfillment and set it in the delivery
				orderDelivery.setShippingAddress(getAddressService().copyAddress(arguments.orderFulfillment.getShippingAddress()));
				orderDelivery.setShippingMethod(arguments.orderFulfillment.getShippingMethod());
				break;
			}
			default: {
			}
		}
		
		// set the tracking number
		if(structkeyExists(arguments.data, "trackingNumber") && len(arguments.data.trackingNumber) > 0) {
			orderDelivery.setTrackingNumber(arguments.data.trackingNumber);
		}
	
		var totalQuantity = 0;
		
		// Loop over the items in the fulfillment
		for(var i = 1; i <= arrayLen(arguments.orderFulfillment.getOrderFulfillmentItems()); i++) {
		
			var thisOrderItem = arguments.orderFulfillment.getOrderFulfillmentItems()[i];
			
			// Check to see if this fulfillment item has any quantity passed to it
			if(structKeyExists(arguments.data, thisOrderItem.getOrderItemID())) {
				var thisQuantity = arguments.data[thisOrderItem.getOrderItemID()];
				
				// Make sure that the quantity is greater than 1, and that this fulfillment item needs at least 
				//that many to be delivered
				if(thisQuantity > 0 && thisQuantity <= thisOrderItem.getQuantityUndelivered()) {
					// keep track of the total quantity fulfilled
					totalQuantity += thisQuantity;
				
					// Grab the stock that matches the item and the location from which we are delivering
					var stock = getStockService().getStockBySkuAndLocation(thisOrderItem.getSku(), 
					                                                       orderDelivery.getLocation());
					
					// Create and Populate the delivery item
					var orderDeliveryItem = this.newOrderDeliveryItem();
					orderDeliveryItem.setOrderItem(thisOrderItem);
					orderDeliveryItem.setQuantity(thisQuantity);
					orderDeliveryItem.setOrderDelivery(orderDelivery);
					orderDeliveryItem.setStock(stock);
				
					// change status of the order item
					if(thisQuantity == thisOrderItem.getQuantityUndelivered()) {
						//order item was fulfilled
						thisOrderItem.setOrderItemStatusType( getTypeService().getTypeBySystemCode("oistFulfilled") );
					} else {
						// TODO: create setting to make this flexible according to business rules
						thisOrderItem.setOrderItemStatusType( getTypeService().getTypeBySystemCode("oistBackordered") );
					}
					
					
				}
			}
		}
	
		orderDelivery.validate();
	
		if(!orderDelivery.hasErrors()) {
			// update the status of the order
			if(totalQuantity < order.getQuantityUndelivered()) {
				order.setOrderStatusType(getTypeService().getTypeBySystemCode("ostProcessing"));
			} else if(order.isPaid()) {
				order.setOrderStatusType(getTypeService().getTypeBySystemCode("ostClosed"));
			} else {
				order.setOrderStatusType(getTypeService().getTypeBySystemCode("ostProcessing"));
			}
			arguments.entity = getDAO().save(target=orderDelivery);
		} else {
			getService("requestCacheService").setValue("ormHasErrors", true);
		}
	
		return orderDelivery;
	}
	
	public any function saveOrderPaymentCreditCard(required any orderPayment, struct data={}) {
	
		// Populate Order Payment
		arguments.orderPayment.populate(arguments.data);
	
		// Manually Set the scurity code & Credit Card Number because it isn't a persistent property
		arguments.orderPayment.setSecurityCode(arguments.data.securityCode);
		arguments.orderPayment.setCreditCardNumber(arguments.data.creditCardNumber);
	
		// Validate the order Payment
		arguments.orderPayment.validate();
	
		if(arguments.orderPayment.getCreditCardType() == "Invalid") {
			arguments.orderPayment.addError(errorName="creditCardNumber", errorMessage="Invalid credit card number.");
		}
	
		var address = arguments.orderPayment.getBillingAddress();
		
		// Get Address
		if(isNull(address)) {
			// Set a new address in the order payment
			var address = getAddressService().newAddress();
		}
	
		// Populate Address
		address.populate(arguments.data.billingAddress);
	
		// Validate Address
		address.validate();
	
		arguments.orderPayment.setBillingAddress(address);
	
		if(!arguments.orderPayment.hasErrors() && !address.hasErrors()) {
			getDAO().save(address);
			getDAO().save(arguments.orderPayment);
		} else {
			getRequestCacheService().setValue("ormHasErrors", true);
		}
	
		return arguments.orderPayment;
	}
	
	/********* START: Order Actions ***************/
	
	public any function applyOrderAction(required string orderID, required string orderActionTypeID) {
		var order = this.getOrder(arguments.orderID);
		var orderActionType = this.getType(arguments.orderActionTypeID);
		
		switch(orderActionType.getSystemCode())	{
			case "oatCancel": {
				return cancelOrder(order);
				break;
			}
			case "oatRefund": {
				return refundOrder(order);
				break;
			}
		}
		
	}
	
	public any function cancelOrder(required any order) {
		// see if this action is allowed for this status
		var response = checkStatusAction(arguments.order, "cancel");
		if(!response.hasErrors()) {
			var statusType = this.getTypeBySystemCode("ostCanceled");
			arguments.order.setOrderStatusType(statusType);
		}
		return response;
	}
	
	public any function refundOrder(required any order) {
		// see if this action is allowed for this status
		var response = checkStatusAction(arguments.order, "refund");
		if(!response.hasErrors()) {
			//TODO: logic for refunding order
		}
		return response;
	}
	
	public any function checkStatusAction(required any order, required string action) {
		var response = new com.utility.ResponseBean();
		var actionOptions = arguments.order.getActionOptions();
		var isValid = false;
		for(var i = 1; i <= arrayLen(actionOptions); i++) {
			if(actionOptions[i].getOrderActionType().getSystemCode() == "oat" & arguments.action) {
				isValid = true;
				break;
			}
		}
		if(!isValid) {
			var message = rbKey("entity.order.#arguments.action#_validatestatus");
			var message = replaceNocase(rc.message, "{statusValue}", arguments.order.getStatus());
			response.addError(arguments.action, message);
		}
		return response;
	}
	
	public any function exportOrders(required struct data) {
		var searchQuery = getDAO().getExportQuery(argumentCollection=arguments.data);
		return getService("utilityService").export(searchQuery);
	}
	
	/********* END: Order Actions ***************/
	
	public void function clearCart() {
		var currentSession = getSessionService().getCurrent();
		var cart = currentSession.getOrder();
		
		if(!cart.isNew()) {
			currentSession.removeOrder();
		
			getDAO().delete(cart.getOrderItems());
			getDAO().delete(cart.getOrderFulfillments());
			getDAO().delete(cart.getOrderPayments());
			getDAO().delete(cart);
		}
	}
	
	public void function removeAccountSpecificOrderDetails(required any order) {
	
		// Loop over fulfillments and remove any account specific details
		for(var i = 1; i <= arrayLen(arguments.order.getOrderFulfillments()); i++) {
			if(arguments.order.getOrderFulfillments()[i].getFulfillmentMethodID() == "shipping") {
				arguments.order.getOrderFulfillments()[i].setShippingAddress(javaCast("null", ""));
			}
		}
	
		// TODO: Loop over payments and remove any account specific details
		// Recalculate the order amounts for tax and promotions
		recalculateOrderAmounts(arguments.order);
	}
	
	public void function recalculateOrderAmounts(required any order) {
		
		if(arguments.order.getOrderStatusType().getSystemCode() == "ostClosed") {
			throw("A recalculateOrderAmounts was called for an order that was already closed");
		} else {
			
			// Re-Calculate the 'amounts' based on permotions ext.
			getPromotionService().updateOrderAmountsWithPromotions(arguments.order);
			
			// Re-Calculate tax now that the new promotions have been applied
			getTaxService().updateOrderAmountsWithTaxes(arguments.order);	
		}
	}
	
	public void function addPromotionCode(required any order, required any promotionCode) {
		if(!arguments.order.hasPromotionCode(arguments.promotionCode)) {
			arguments.order.addPromotionCode(arguments.promotionCode);
		}
		getPromotionService().updateOrderAmountsWithPromotions(order=arguments.order);
	}
	
	public void function removePromotionCode(required any order, required any promotionCode) {
		arguments.order.removePromotionCode(arguments.promotionCode);
		getPromotionService().updateOrderAmountsWithPromotions(order=arguments.order);
	}
	
	public struct function getQuantityPriceSkuAlreadyReturned(required any orderID, required any skuID) {
		return getDAO().getQuantityPriceSkuAlreadyReturned(arguments.orderId, arguments.skuID);
	}
	
	public numeric function getPreviouslyReturnedFulfillmentTotal(required any orderID) {
		return getDAO().getPreviouslyReturnedFulfillmentTotal(arguments.orderId);
	}
	
	public boolean function createOrderReturn(required struct data) {
		var originalOrder = this.getOrder(data.orderID);
		
		// Create a new order
		var order = this.newOrder();
		order.setAccount(originalOrder.getAccount());
		order.setOrderType(getTypeService().getTypeBySystemCode("otReturnOrder"));
		order.setOrderStatusType(getTypeService().getTypeBySystemCode("ostNew"));
		order.setReferencedOrder(originalOrder);
		
		var stockReceiver = getStockService().newStockReceiverOrder();
	
		// Create OrderReturn entity (to save the fulfillment amount)
		var orderReturn = this.newOrderReturn();
		var location = getLocationService().getLocation(data.returnToLocationID);
		orderReturn.setOrder(order);
		orderReturn.setFulfillmentRefundAmount(val(data.refundShippingAmount));
		orderReturn.setReturnLocation(location);
		
		// Load order with order items. Loop over all deliveries, then delivered items
		for(var j = 1; j <= ArrayLen(originalOrder.getOrderDeliveries()); j++) {
			var orderDelivery = originalOrder.getOrderDeliveries()[j];
			for(var i = 1; i <= ArrayLen(orderDelivery.getOrderDeliveryItems()); i++) {
				var originalOrderItem = orderDelivery.getOrderDeliveryItems()[i].getOrderItem();
				var quantityReturning = data["quantity_orderItemId(#originalOrderItem.getOrderItemID()#)_orderDeliveryId(#orderDelivery.getOrderDeliveryID()#)"];
				var priceReturning = data["price_orderItemId(#originalOrderItem.getOrderItemID()#)_orderDeliveryId(#orderDelivery.getOrderDeliveryID()#)"];
			
				if(quantityReturning GT 0) {
					// Create a new orderItem and populate it's basic properties from the original order item, and from the user submitted input.
					var orderItem = this.newOrderItem();
					orderItem.setReferencedOrderItem(originalOrderItem);
					orderItem.setReferencedOrderDeliveryItem(orderDelivery.getOrderDeliveryItems()[i]);
					orderItem.setOrder(order);
					orderItem.setPrice(priceReturning);
					orderItem.setQuantity(quantityReturning);
					orderItem.setSku(originalOrderItem.getSku());
					orderItem.setOrderItemStatusType(getTypeService().getTypeBySystemCode('oistReturned'));
					orderItem.setOrderItemType(getTypeService().getTypeBySystemCode('oitReturn'));
				
					// Populate the Tax on this order by creating new tax entities, but using the same rate as the original orderItem.
					//dumpScreen(originalOrderItem.getAppliedTaxes());
					for(var k=1; k <= ArrayLen(originalOrderItem.getAppliedTaxes()); k++) {
						var originalAppliedTax = originalOrderItem.getAppliedTaxes()[k];
						var appliedTax = getTaxService().newOrderItemAppliedTax();
						
						appliedTax.setOrderItem(orderItem);
						appliedTax.setTaxCategoryRate(originalAppliedTax.getTaxCategoryRate());
						appliedTax.setTaxRate(originalAppliedTax.getTaxRate());
						appliedTax.setTaxAmount((originalAppliedTax.getTaxRate() / 100) * (orderItem.getQuantity() * priceReturning));
					}
				
					// Add this order item to the OrderReturns entity
					orderItem.setOrderReturn(orderReturn);
				
					// Add stock receiver item to stock receiver
					var stock = getStockService().getStockBySkuAndLocation(originalOrderItem.getSku(), location);
					var stockReceiverItem = getStockService().newStockReceiverItem();
					stockReceiverItem.setStockReceiver(stockReceiver);
					stockReceiverItem.setOrderItem(orderItem);
					stockReceiverItem.setQuantity(quantityReturning);
					stockReceiverItem.setStock(stock);
				}
			}
		}

		this.saveOrder(order);
		
		if(!order.hasErrors()) {
			// In order to handle the "stock" aspect of this return. Create a StockReceiver, which will be 
			// further populated with StockRecieverItems, one for each item being returned.
			
			stockReceiver.setOrder(order);
			getStockService().saveStockReceiver(stockReceiver);
			
			if(!stockReceiver.hasErrors()) {
				// This must be called AFTER the save or else the type-validation will fail
				order.setOrderStatusType(getTypeService().getTypeBySystemCode("ostClosed"));
			}
		}

		return true;
	}
	
	public any function forceItemQuantityUpdate(required any order, required any messageBean) {
		// Loop over each order Item
		for(var i = arrayLen(arguments.order.getOrderItems()); i >= 1; i--)	{
			if(!arguments.order.getOrderItems()[i].hasQuantityWithinMaxOrderQuantity())	{
				if(arguments.order.getOrderItems()[i].getMaximumOrderQuantity() > 0) {
					arguments.messageBean.addMessage(messageName="forcedItemQuantityAdjusted", message="#arguments.order.getOrderItems()[i].getSku().getProduct().getTitle()# #arguments.order.getOrderItems()[i].getSku().displayOptions()# on your order had the quantity updated from #arguments.order.getOrderItems()[i].getQuantity()# to #arguments.order.getOrderItems()[i].getMaximumOrderQuantity()# because of inventory constraints.");
					arguments.order.getOrderItems()[i].setQuantity(arguments.order.getOrderItems()[i].getMaximumOrderQuantity());
				} else {
					arguments.messageBean.addMessage(messageName="forcedItemRemoved", message="#arguments.order.getOrderItems()[i].getSku().getProduct().getTitle()# #arguments.order.getOrderItems()[i].getSku().displayOptions()# was removed from your order because of inventory constraints");
					arguments.order.getOrderItems()[i].removeOrder();
				}
			}
		}
	}
	
	/**************** LEGACY DEPRECATED METHOD ****************************/
	/*
	 * This method is only called from the cart controller if the data passed in for 'orderItems'
	 * was passed in as orderItems.{orderItemID}.property which is the old format that we no longer 
	use.
	 * Now to accomplish the same task we are calling saveOrder() from the controller and letting 
	populate
	 * and validation take care of it.
	*/
	
	public void function updateOrderItems(required any order, required struct data) {
	
		var dataCollections = arguments.data;
		var orderItems = arguments.order.getOrderItems();
		for(var i = arrayLen(arguments.order.getOrderItems()); i >= 1; i--)	{
			if(structKeyExists(dataCollections.orderItem, arguments.order.getOrderItems()[i].getOrderItemID()))	{
				if(structKeyExists(dataCollections.orderItem["#arguments.order.getOrderItems()[i].getOrderItemID()#"], "quantity")) {
					arguments.order.getOrderItems()[i].getOrderFulfillment().orderFulfillmentItemsChanged();
				
					if(dataCollections.orderItem["#arguments.order.getOrderItems()[i].getOrderItemID()#"].quantity <= 0) {
						arguments.order.getOrderItems()[i].removeOrder(arguments.order);
					} else {
						arguments.order.getOrderItems()[i].setQuantity(dataCollections.orderItem["#arguments.order.getOrderItems()[i].getOrderItemID()#"].quantity);
					}
				}
			}
		}
	
		// Recalculate the order amounts for tax and promotions
		recalculateOrderAmounts(arguments.order);
	}
	
}