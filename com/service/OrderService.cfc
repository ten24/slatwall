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
component extends="BaseService" persistent="false" accessors="true" output="false" {

	property name="accountService";
	property name="addressService";
	property name="emailService";
	property name="locationService";
	property name="fulfillmentService";
	property name="paymentService";
	property name="priceGroupService";
	property name="promotionService";
	property name="shippingService";
	property name="sessionService";
	property name="taxService";
	property name="utilityFormService";
	property name="utilityTagService";
	property name="utilityService";
	property name="utilityEmailService";
	property name="stockService";
	property name="subscriptionService";
	property name="typeService";

	// ===================== START: Logical Methods ===========================

	public void function addOrderItem(required any order, required any sku, any stock, numeric quantity=1, any orderFulfillment, struct customizatonData, struct data = {})	{

		// Check to see if the order has already been closed or canceled
		if(arguments.order.getOrderStatusType().getSystemCode() == "ostClosed" || arguments.order.getOrderStatusType().getSystemCode() == "ostCanceled") {
			throw("You cannot add an item to an order that has been closed or canceled");
		}

		// If the currency code was not passed in, then set it to the sku default
		if(!structKeyExists(arguments.data, "currencyCode")) {
			if( !isNull(arguments.order.getCurrencyCode()) && listFindNoCase(arguments.sku.setting('skuEligibleCurrencies'), arguments.order.getCurrencyCode()) && arrayLen(arguments.order.getOrderItems()) ) {
				arguments.data.currencyCode = arguments.order.getCurrencyCode();
			} else {
				arguments.data.currencyCode = arguments.sku.setting('skuCurrency');
			}
		}

		// Make sure the order has a currency code
		if( isNull(arguments.order.getCurrencyCode()) || !arrayLen(arguments.order.getOrderItems()) ) {
			arguments.order.setCurrencyCode( arguments.data.currencyCode );
		}

		// Verify the order has the same currency as the one being added
		if(arguments.order.getCurrencyCode() eq arguments.data.currencyCode) {

			// Make sure the item is in stock
			if(arguments.sku.getQuantity('qats') gt 0) {

				// Update the quantity to add to whatever the qats is if trying to add more.
				if(arguments.sku.getQuantity('qats') lt arguments.quantity) {
					arguments.quantity = arguments.sku.getQuantity('qats');
				}

				// save order so it's added to the hibernate scope
				save( arguments.order );

				// if a filfillmentMethodID is passed in the data, set orderfulfillment to that
				if(structKeyExists(arguments.data, "fulfillmentMethodID") && !structKeyExists(arguments, "orderFulfillment")) {
					// make sure this is eligible fulfillment method
					if(listFindNoCase(arguments.sku.setting('skuEligibleFulfillmentMethods'), arguments.data.fulfillmentMethodID)) {
						var fulfillmentMethod = this.getFulfillmentService().getFulfillmentMethod(arguments.data.fulfillmentMethodID);
						if(!isNull(fulfillmentMethod)) {
							arguments.orderFulfillment = this.getOrderFulfillment({order=arguments.order,fulfillmentMethod=fulfillmentMethod},true);
							if(arguments.orderFulfillment.isNew()) {
								if(structKeyExists(arguments.data, "orderFulfillment"))	{
									arguments.orderFulfillment.populate( arguments.data.orderFulfillment );
								}
								arguments.orderFulfillment.setFulfillmentMethod( fulfillmentMethod );
								arguments.orderFulfillment.setOrder( arguments.order );
								arguments.orderFulfillment.setCurrencyCode( arguments.order.getCurrencyCode() ) ;
								// Push the fulfillment into the hibernate scope
								getDAO().save(arguments.orderFulfillment);
							}
						}
					}

				}

				// Check for an orderFulfillment in the arguments.  If none, use the orders first.  If none has been setup create a new one
				if(!structKeyExists(arguments, "orderFulfillment"))	{

					var thisFulfillmentMethodType = getFulfillmentService().getFulfillmentMethod(listGetAt(arguments.sku.setting('skuEligibleFulfillmentMethods'),1)).getFulfillmentMethodType();

					// check if there is a fulfillment method of this type in the order
					for(var fulfillment in arguments.order.getOrderFulfillments()) {
						if(listFindNoCase(arguments.sku.setting('skuEligibleFulfillmentMethods'), fulfillment.getFulfillmentMethod().getFulfillmentMethodID())) {
							arguments.orderFulfillment = fulfillment;
							break;
						}
					}

					// if no fulfillment of this type found then create a new one
					if(!structKeyExists(arguments, "orderFulfillment")) {

						var fulfillmentMethodOptions = arguments.sku.getEligibleFulfillmentMethods();

						// If there are at least 1 options, then we create the new method, otherwise stop and just return the order
						if(arrayLen(fulfillmentMethodOptions)) {
							arguments.orderFulfillment = this.newSlatwallOrderFulfillment();
							arguments.orderFulfillment.setFulfillmentMethod( fulfillmentMethodOptions[1] );
							arguments.orderFulfillment.setOrder( arguments.order );
							arguments.orderFulfillment.setCurrencyCode( arguments.order.getCurrencyCode() ) ;
						} else {
							return arguments.order;
						}

						// Push the fulfillment into the hibernate scope
						getDAO().save(arguments.orderFulfillment);
					}
				}

				var orderItems = arguments.order.getOrderItems();
				var itemExists = false;

				// If there are no product customizations then we can check for the order item already existing.
				if(!structKeyExists(arguments, "customizatonData") || !structKeyExists(arguments.customizatonData,"attribute"))	{
					// Check the existing order items and increment quantity if possible.
					for(var i = 1; i <= arrayLen(orderItems); i++) {

						// This is a simple check inside of the loop to find any sku that matches
						if(orderItems[i].getSku().getSkuID() == arguments.sku.getSkuID() && orderItems[i].getOrderFulfillment().getOrderFulfillmentID() == arguments.orderFulfillment.getOrderFulfillmentID()) {

							// This verifies that the stock being passed in matches the stock on the order item, or that both are null
							if( ( !isNull(arguments.stock) && !isNull(orderItems[i].getStock()) && arguments.stock.getStockID() == orderItems[i].getStock().getStockID() ) || ( isNull(arguments.stock) && isNull(orderItems[i].getStock()) ) ) {

								itemExists = true;
								// do not increment quantity for content access product
								if(orderItems[i].getSku().getBaseProductType() != "contentAccess") {

									// Verify that this item now that it has a greater quantity isn't bigger than the qats
									if((orderItems[i].getQuantity() + arguments.quantity) gt orderItems[i].getSku().getQuantity('qats')) {
										orderItems[i].setQuantity(orderItems[i].getSku().getQuantity('qats'));
									} else {
										orderItems[i].setQuantity(orderItems[i].getQuantity() + arguments.quantity);
									}

									if( structKeyExists(arguments.data, "price") && arguments.sku.getUserDefinedPriceFlag() ) {
										orderItems[i].setPrice( arguments.data.price );
										orderItems[i].setSkuPrice( arguments.data.price );
									} else {
										orderItems[i].setPrice( arguments.sku.getPriceByCurrencyCode( arguments.data.currencyCode ) );
										orderItems[i].setSkuPrice( arguments.sku.getPriceByCurrencyCode( arguments.data.currencyCode ) );
									}
								}
								break;

							}
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
					newItem.setCurrencyCode( arguments.order.getCurrencyCode() );

					// All new items have the price and skuPrice set to the current price of the sku being added.  Later the price may be changed by the recalculateOrderAmounts() method
					if( structKeyExists(arguments.data, "price") && arguments.sku.getUserDefinedPriceFlag() ) {
						newItem.setPrice( arguments.data.price );
						newItem.setSkuPrice( arguments.data.price );
					} else {
						newItem.setPrice( arguments.sku.getPriceByCurrencyCode( arguments.data.currencyCode ) );
						newItem.setSkuPrice( arguments.sku.getPriceByCurrencyCode( arguments.data.currencyCode ) );
					}

					// If a stock was passed in, then assign it to this new item
					if(!isNull(arguments.stock)) {
						newItem.setStock(arguments.stock);
					}

					// Check for product customization
					if(structKeyExists(arguments, "customizationData") && structKeyExists(arguments.customizationData, "attribute")) {
						var pcas = arguments.sku.getProduct().getAttributeSets(['astOrderItem']);
						for(var i = 1; i <= arrayLen(pcas); i++) {
							var attributes = pcas[i].getAttributes();

							for(var a = 1; a <= arrayLen(attributes); a++) {
								if(structKeyExists(arguments.customizationData.attribute, attributes[a].getAttributeID())) {
									var av = this.newAttributeValue();
									av.setAttributeValueType("orderItem");
									av.setAttribute(attributes[a]);
									av.setAttributeValue(arguments.customizationData.attribute[attributes[a].getAttributeID()]);
									av.setOrderItem(newItem);
									// Push the attribute value
									getDAO().save(av);
								}
							}
						}
					}

					// Push the order Item into the hibernate scope
					getDAO().save(newItem);
				}

				// Recalculate the order amounts for tax and promotions and priceGroups
				recalculateOrderAmounts( arguments.order );


			} else {
				order.addError("quantity", rbKey('validate.order.orderitemoutofstock'));
			}
		} else {
			order.addError("currency", rbKey('validate.order.orderitemwrongcurrency'));
		}

	}

	public void function removeOrderItem(required any order, required string orderItemID) {

		// Loop over all of the items in this order
		for(var i = 1; i <= arrayLen(arguments.order.getOrderItems()); i++)	{

			// Check to see if this item is the same ID as the one passed in to remove
			if(arguments.order.getOrderItems()[i].getOrderItemID() == arguments.orderItemID) {

				// Actually Remove that Item
				arguments.order.removeOrderItem(arguments.order.getOrderItems()[i]);
				break;
			}
		}

		// Recalculate the order amounts for tax and promotions
		recalculateOrderAmounts(arguments.order);
	}

	public boolean function updateAndVerifyOrderAccount(required any order, required struct data) {
		var accountOK = true;
		if(structKeyExists(data, "account")) {
			var accountData = data.account;
			var account = getAccountService().getAccount(accountData.accountID, true);
			account = getAccountService().saveAccount(account, accountData, data.siteID);

			// If the account has changed, then we need to duplicate the cart
			if(!isNull(arguments.order.getAccount()) && arguments.order.getAccount().getAccountID() != account.getAccountID()) {
				arguments.order = duplicateOrderWithNewAccount( arguments.order, account );
				getSlatwallScope().getCurrentSession().setOrder( arguments.order );
				getSlatwallScope().setCurrentCart( arguments.order );
			} else {
				arguments.order.setAccount(account);
			}

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
			if(!arguments.order.getOrderFulfillments()[i].isProcessable( context="placeOrder" )) {
				fulfillmentsOK = false;
			}
		}

		return fulfillmentsOK;
	}

	public boolean function updateAndVerifyOrderPayments(required any order, required struct data) {
		var paymentsOK = true;
		var requirePayment = false;

		// check if payment method is required for subscription order, even if the amount is 0
		// require payment if renewal price is not 0 and autoPayFlag is true
		if(!arrayLen(order.getOrderPayments())) {
			for(var orderItem in arguments.order.getOrderItems()) {
				if(!isNull(orderItem.getSku().getSubscriptionTerm()) && orderItem.getSku().getRenewalPrice() != 0 && !isNull(orderItem.getSku().getSubscriptionTerm().getAutoPayFlag()) && orderItem.getSku().getSubscriptionTerm().getAutoPayFlag()) {
					requirePayment = true;
					break;
				}
			}
		}

		if(structKeyExists(data, "orderPayments")) {
			var paymentsDataArray = data.orderPayments;
			for(var i = 1; i <= arrayLen(paymentsDataArray); i++) {

				if(!structKeyExists(data, "newOrderPaymentIndex") || data.newOrderPaymentIndex == i) {

					var payment = this.getOrderPayment(paymentsDataArray[i].orderPaymentID, true);

					if(requirePayment || (payment.isNew() && order.getPaymentAmountTotal() < order.getTotal()) || !payment.isNew()) {
						if((payment.isNew() || isNull(payment.getAmount()) || payment.getAmount() <= 0) && !structKeyExists(paymentsDataArray[i],"amount"))	{
							paymentsDataArray[i].amount = order.getTotal() - order.getPaymentAmountTotal();
						} else if(!payment.isNew() && (isNull(payment.getAmountAuthorized()) || payment.getAmountAuthorized() == 0) && !structKeyExists(paymentsDataArray[i], "amount")) {
							paymentsDataArray[i].amount = order.getTotal() - order.getPaymentAmountAuthorizedTotal();
						}

						// Make sure the payment is attached to the order
						payment.setOrder(arguments.order);

						// Make sure the payment currency matches the order
						payment.setCurrencyCode( arguments.order.getCurrencyCode() );

						// Attempt to Validate & Save Order Payment
						payment = this.saveOrderPayment(payment, paymentsDataArray[i]);

						// Check to see if this payment has any errors and if so then don't proceed
						if(payment.hasErrors()) {
							paymentsOK = false;
						}
					}
				}
			}
		}

		// Verify that there are enough payments applied to the order to proceed
		if(order.getPaymentAmountTotal() < order.getTotal()) {
			paymentsOK = false;
		}

		// Verify that payment method is provided for subscription order, even if the amount is 0
		if(!arrayLen(order.getOrderPayments()) && requirePayment) {
			paymentsOK = false;
		}

		return paymentsOK;
	}

	private boolean function processOrderPayments(required any order) {
		var allPaymentsProcessed = true;

		// Process All Payments and Save the ones that were successful
		for(var i = 1; i <= arrayLen(arguments.order.getOrderPayments()); i++) {
			var transactionType = order.getOrderPayments()[i].getPaymentMethod().setting('paymentMethodCheckoutTransactionType');

			if(transactionType != '' && transactionType != 'none' && order.getOrderPayments()[i].getAmount() > 0) {

				var paymentOK = true;

				if(transactionType eq "authorize" && order.getOrderPayments()[i].getAmountAuthorized() < order.getOrderPayments()[i].getAmount()) {
					paymentOK = getPaymentService().processPayment(order.getOrderPayments()[i], transactionType, order.getOrderPayments()[i].getAmount()-order.getOrderPayments()[i].getAmountAuthorized());
				} else if (transactionType eq "authorizeAndCharge" && order.getOrderPayments()[i].getAmountReceived() < order.getOrderPayments()[i].getAmount()) {
					paymentOK = getPaymentService().processPayment(order.getOrderPayments()[i], transactionType, order.getOrderPayments()[i].getAmount()-order.getOrderPayments()[i].getAmountReceived());
				}

				if(!paymentOK) {
					order.getOrderPayments()[i].setAmount(0);
					order.getOrderPayments()[i].setCreditCardNumber("");
					allPaymentsProcessed = false;
				}
			}
		}

		return allPaymentsProcessed;
	}

	public void function setupOrderItemContentAccess(required any orderItem) {
		for(var accessContent in arguments.orderItem.getSku().getAccessContents()) {
			var accountContentAccess = getAccountService().newAccountContentAccess();
			accountContentAccess.setAccount(arguments.orderItem.getOrder().getAccount());
			accountContentAccess.setOrderItem(arguments.orderItem);
			accountContentAccess.addAccessContent(accessContent);
			getAccountService().saveAccountContentAccess(accountContentAccess);
		}
	}

	public any function getOrderRequirementsList(required any order) {
		var orderRequirementsList = "";

		// Check if the order still requires a valid account
		if(isNull(arguments.order.getAccount()) || arguments.order.getAccount().hasErrors()) {
			orderRequirementsList = listAppend(orderRequirementsList, "account");
		}

		// Check each of the fulfillment methods to see if they are ready to process
		for(var i = 1; i <= arrayLen(arguments.order.getOrderFulfillments()); i++) {
			if(!arguments.order.getOrderFulfillments()[i].isProcessable( context="placeOrder" )) {
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

	public any function copyFulfillmentAddress(required any order) {
		for(var orderFulfillment in order.getOrderFulfillments()) {
			if(orderFulfillment.getFulfillmentMethodType() == "shipping") {
				if(!isNull(orderFulfillment.getAccountAddress())) {
					var shippingAddress = orderFulfillment.getAccountAddress().getAddress().copyAddress();
					orderFulfillment.setShippingAddress( shippingAddress );
					orderFulfillment.removeAccountAddress();
					// since copy address creates a new address, call save for persistence
					getAddressService().saveAddress(shippingAddress);
					getDAO().save(orderFulfillment);
				}
			}
		}
	}

	public void function clearCart() {
		var currentSession = getSlatwallScope().getCurrentSession();
		var cart = currentSession.getOrder();

		if(!isNull(cart) && !cart.isNew()) {
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

			// Loop over the orderItems to see if the skuPrice Changed
			if(arguments.order.getOrderStatusType().getSystemCode() == "ostNotPlaced") {
				for(var i=1; i<=arrayLen(arguments.order.getOrderItems()); i++) {
					if(arguments.order.getOrderItems()[i].getOrderItemType().getSystemCode() == "oitSale" && arguments.order.getOrderItems()[i].getSkuPrice() != arguments.order.getOrderItems()[i].getSku().getPriceByCurrencyCode( arguments.order.getOrderItems()[i].getCurrencyCode() )) {
						arguments.order.getOrderItems()[i].setPrice( arguments.order.getOrderItems()[i].getSku().getPriceByCurrencyCode( arguments.order.getOrderItems()[i].getCurrencyCode() ) );
						arguments.order.getOrderItems()[i].setSkuPrice( arguments.order.getOrderItems()[i].getSku().getPriceByCurrencyCode( arguments.order.getOrderItems()[i].getCurrencyCode() ) );
					}
				}
			}

			// First Re-Calculate the 'amounts' base on price groups
			getPriceGroupService().updateOrderAmountsWithPriceGroups( arguments.order );

			// Then Re-Calculate the 'amounts' based on permotions ext.  This is done second so that the order already has priceGroup specific info added
			getPromotionService().updateOrderAmountsWithPromotions( arguments.order );

			// Re-Calculate tax now that the new promotions and price groups have been applied
			getTaxService().updateOrderAmountsWithTaxes( arguments.order );
		}
	}

	public any function addPromotionCode(required any order, required string promotionCode) {
		var pc = getPromotionService().getPromotionCodeByPromotionCode(arguments.promotionCode);

		if(isNull(pc) || !pc.getPromotion().getActiveFlag()) {
			arguments.order.addError("promotionCode", rbKey('validate.promotionCode.invalid'));
		} else if ( (!isNull(pc.getStartDateTime()) && pc.getStartDateTime() > now()) || (!isNull(pc.getEndDateTime()) && pc.getEndDateTime() < now()) || !pc.getPromotion().getCurrentFlag()) {
			arguments.order.addError("promotionCode", rbKey('validate.promotionCode.invaliddatetime'));
		} else if (arrayLen(pc.getAccounts()) && !pc.hasAccount(getSlatwallScope().getCurrentAccount())) {
			arguments.order.addError("promotionCode", rbKey('validate.promotionCode.invalidaccount'));
		} else {
			if(!arguments.order.hasPromotionCode( pc )) {
				arguments.order.addPromotionCode( pc );
			}
			getPromotionService().updateOrderAmountsWithPromotions(order=arguments.order);
		}

		return arguments.order;
	}

	public void function removePromotionCode(required any order, required any promotionCode) {
		arguments.order.removePromotionCode(arguments.promotionCode);
		getPromotionService().updateOrderAmountsWithPromotions(order=arguments.order);
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

	public any function duplicateOrderWithNewAccount(required any originalOrder, required any newAccount) {

		var newOrder = this.newOrder();
		newOrder.setCurrencyCode( arguments.originalOrder.getCurrencyCode() );

		// Copy Order Items
		for(var i=1; i<=arrayLen(arguments.originalOrder.getOrderItems()); i++) {
			var newOrderItem = this.newOrderItem();

			newOrderItem.setPrice( arguments.originalOrder.getOrderItems()[i].getPrice() );
			newOrderItem.setSkuPrice( arguments.originalOrder.getOrderItems()[i].getSkuPrice() );
			newOrderItem.setCurrencyCode( arguments.originalOrder.getOrderItems()[i].getCurrencyCode() );
			newOrderItem.setQuantity( arguments.originalOrder.getOrderItems()[i].getQuantity() );
			newOrderItem.setOrderItemType( arguments.originalOrder.getOrderItems()[i].getOrderItemType() );
			newOrderItem.setOrderItemStatusType( arguments.originalOrder.getOrderItems()[i].getOrderItemStatusType() );
			newOrderItem.setSku( arguments.originalOrder.getOrderItems()[i].getSku() );
			if(!isNull(arguments.originalOrder.getOrderItems()[i].getStock())) {
				newOrderItem.setStock( arguments.originalOrder.getOrderItems()[i].getStock() );
			}

			// copy order item customization
			for(var attributeValue in arguments.originalOrder.getOrderItems()[i].getAttributeValues()) {
				var av = this.newAttributeValue();
				av.setAttributeValueType(attributeValue.getAttributeValueType());
				av.setAttribute(attributeValue.getAttribute());
				av.setAttributeValue(attributeValue.getAttributeValue());
				av.setOrderItem(newOrderItem);
			}

			// check if there is a fulfillment method of this type in the order
			for(var fulfillment in newOrder.getOrderFulfillments()) {
				if(arguments.originalOrder.getOrderItems()[i].getOrderFulfillment().getFulfillmentMethod().getFulfillmentMethodID() == fulfillment.getFulfillmentMethod().getFulfillmentMethodID()) {
					var newOrderFulfillment = fulfillment;
					break;
				}
			}
			if(isNull(newOrderFulfillment)) {
				var newOrderFulfillment = this.newOrderFulfillment();
				newOrderFulfillment.setFulfillmentMethod( arguments.originalOrder.getOrderItems()[i].getOrderFulfillment().getFulfillmentMethod() );
				newOrderFulfillment.setOrder( newOrder );
				newOrderFulfillment.setCurrencyCode( arguments.originalOrder.getOrderItems()[i].getOrderFulfillment().getCurrencyCode() );
			}
			newOrderItem.setOrder( newOrder );
			newOrderItem.setOrderFulfillment( newOrderFulfillment );

		}

		newOrder.setAccount( arguments.newAccount );

		// Update any errors from the previous account to the new account
		newOrder.getAccount().getErrorBean( originalOrder.getAccount().getErrorBean() );
		newOrder.getAccount().getVTResult( originalOrder.getAccount().getVTResult() );

		this.saveOrder( newOrder );

		return newOrder;
	}

	// =====================  END: Logical Methods ============================

	// ===================== START: DAO Passthrough ===========================

	public struct function getQuantityPriceSkuAlreadyReturned(required any orderID, required any skuID) {
		return getDAO().getQuantityPriceSkuAlreadyReturned(arguments.orderId, arguments.skuID);
	}

	public numeric function getPreviouslyReturnedFulfillmentTotal(required any orderID) {
		return getDAO().getPreviouslyReturnedFulfillmentTotal(arguments.orderId);
	}

	public any function getMaxOrderNumber() {
		return getDAO().getMaxOrderNumber();
	}

	// ===================== START: DAO Passthrough ===========================

	// ===================== START: Process Methods ===========================

	// Process: Order
	public any function processOrder(required any order, struct data={}, string processContext="process") {

		// CONTEXT: placeOrder
		if(arguments.processContext == "placeOrder") {

			// First we need to lock the session so that this order doesn't get placed twice.
			lock scope="session" timeout="60" {

				// Make sure that the orderID passed in to the data is what we use because this could be a double click senario so we don't want to rely on the order passed in as the cart
				arguments.order = this.getOrder(arguments.data.orderID);

				// Reload the order in case it was already in cache
				getDAO().reloadEntity(arguments.order);

				// Make sure that the entity is notPlaced before going any further
				if(arguments.order.getOrderStatusType().getSystemCode() == "ostNotPlaced") {

					// update and validate all aspects of the order

					// populate extended attributes
					if(structKeyExists(arguments.data, "attributeValues")) {
						var extendedAttributeData = {};
						extendedAttributeData.attributeValues = arguments.data.attributeValues;
						arguments.order.populate( extendedAttributeData );
					}

					// Update account
					var validAccount = updateAndVerifyOrderAccount(order=arguments.order, data=arguments.data);
					if(!validAccount) {
						arguments.order.addError("processing", "The order account was invalid for one reason or another.");
					}

					// Update payments
					var validPayments = updateAndVerifyOrderPayments(order=arguments.order, data=arguments.data);
					if(!validPayments) {
						arguments.order.addError("processing", "One or more of the order payments were invalid for one reason or another.");
					}

					// Update fulfillments
					var validFulfillments = updateAndVerifyOrderFulfillments(order=arguments.order, data=arguments.data);
					if(!validFulfillments) {
						arguments.order.addError("processing", "One or more of the order fulfillments were invalid for one reason or another.");
					}

					if(!arguments.order.hasErrors()) {

						// Double check that the order requirements list is blank
						var orderRequirementsList = getOrderRequirementsList( arguments.order );

						if(len(orderRequirementsList)) {
							arguments.order.addError("processing", "More information is required before we can process this order.");

						} else {
							// Process all of the order payments
							var paymentsProcessed = processOrderPayments(order=arguments.order);

							// If processing was successfull then checkout
							if(!paymentsProcessed) {
								arguments.order.addError("processing", "One or more of the payments could not be processed.");
							} else {
								// copy shipping address if needed
								copyFulfillmentAddress(order=arguments.order);

								// If this order is the same as the current cart, then set the current cart to a new order
								if(!isNull(getSlatwallScope().getCurrentSession().getOrder()) && order.getOrderID() == getSlatwallScope().getCurrentSession().getOrder().getOrderID()) {
									getSlatwallScope().getCurrentSession().setOrder(JavaCast("null", ""));
								}

								// Update the order status
								order.setOrderStatusType(this.getTypeBySystemCode("ostNew"));
								order.confirmOrderNumberOpenDateCloseDate();

								// Save the order to the database
								getDAO().save(order);

								// Do a flush so that the order is commited to the DB
								getDAO().flushORMSession();

								logSlatwall(message="New Order Processed - Order Number: #order.getOrderNumber()# - Order ID: #order.getOrderID()#", generalLog=true);

								// Send out the e-mail
								if(!structKeyExists(arguments.data,"doNotSendOrderConfirmationEmail") || !arguments.data.doNotSendOrderConfirmationEmail) {
									getEmailService().sendEmailByEvent("orderPlaced", order);
								}

								// save account payment if needed (for renewal), do this only 1 orderpayment exists
								// if there are multiple orderPayment, logic needs to get added for user to defined the paymentMethod for renewals
								if(arrayLen(order.getOrderPayments()) == 1 && isNull(order.getOrderPayments()[1].getAccountPaymentMethod())) {
									// if there is any subscription item, save the account payment for use in renewal
									for(var orderItem in order.getOrderItems()) {
										if(!isNull(orderItem.getSku().getSubscriptionTerm())) {
											// TODO: change to find the appripriate order payment
											var accountPaymentMethod = getAccountService().getAccountPaymentMethod({creditCardNumberEncrypted=order.getOrderPayments()[1].getCreditCardNumberEncrypted(),account=order.getAccount()},true);
											if(accountPaymentMethod.isNew()) {
												accountPaymentMethod.setAccount(order.getAccount());
												accountPaymentMethod.copyFromOrderPayment(order.getOrderPayments()[1]);
												accountPaymentMethod.setAccountPaymentMethodName(accountPaymentMethod.getNameOnCreditCard() & " " & accountPaymentMethod.getCreditCardType());
												getAccountService().saveAccountPaymentMethod(accountPaymentMethod);
											}
											order.getOrderPayments()[1].setAccountPaymentMethod(accountPaymentMethod);
											break;
										}
									}
								}

								// Look for 'auto' order fulfillments
								for(var i=1; i<=arrayLen(order.getOrderFulfillments()); i++) {
									// As long as the amount received for this orderFulfillment is within the treshold of the auto fulfillment setting
									if(order.getOrderFulfillments()[i].getFulfillmentMethodType() == "auto" && (order.getTotal() == 0 || order.getOrderFulfillments()[i].getFulfillmentMethod().setting('fulfillmentMethodAutoMinReceivedPercentage') <= (order.getPaymentAmountReceivedTotal()*100/order.getTotal())) ) {
										processOrderFulfillment(order.getOrderFulfillments()[i], {locationID=order.getOrderFulfillments()[i].setting('fulfillmentMethodAutoLocation')}, "fulfillItems");
									}
								}

								processOK = true;
							}
						}
					} else {
						getSlatwallScope().setORMHasErrors( true );
					}
				}

			}	// END OF LOCK

		// CONTEXT: createReturn
		} else if (arguments.processContext == "createReturn") {

			var hasAtLeastOneItemToReturn = false;
			for(var i=1; i<=arrayLen(arguments.data.records); i++) {
				if(isNumeric(arguments.data.records[i].returnQuantity) && arguments.data.records[i].returnQuantity gt 0) {
					var hasAtLeastOneItemToReturn = true;
				}
			}

			if(!hasAtLeastOneItemToReturn) {
				arguments.order.addError('processing', 'You need to specify at least 1 item to be returned');
			} else {

				// Create a new return order
				var returnOrder = this.newOrder();
				returnOrder.setAccount( arguments.order.getAccount() );
				returnOrder.setOrderType( getTypeService().getTypeBySystemCode("otReturnOrder") );
				returnOrder.setOrderStatusType( getTypeService().getTypeBySystemCode("ostNew") );
				returnOrder.setReferencedOrder( arguments.order );

				var returnLocation = getLocationService().getLocation( arguments.data.returnLocationID );

				// Create OrderReturn entity (to save the fulfillment amount)
				var orderReturn = this.newOrderReturn();
				orderReturn.setOrder( returnOrder );
				if(isNumeric(arguments.data.fulfillmentChargeRefundAmount) && arguments.data.fulfillmentChargeRefundAmount gt 0) {
					orderReturn.setFulfillmentRefundAmount( arguments.data.fulfillmentChargeRefundAmount );
				} else {
					orderReturn.setFulfillmentRefundAmount( 0 );
				}
				orderReturn.setReturnLocation( returnLocation );

				// Loop over delivery items in each delivery
				for(var i = 1; i <= arrayLen(arguments.order.getOrderItems()); i++) {

					var originalOrderItem = arguments.order.getOrderItems()[i];

					// Look for that orderItem in the data records
					for(var r=1; r <= arrayLen(arguments.data.records); r++) {
						if(originalOrderItem.getOrderItemID() == arguments.data.records[r].orderItemID && isNumeric(arguments.data.records[r].returnQuantity) && arguments.data.records[r].returnQuantity > 0 && isNumeric(arguments.data.records[r].returnPrice) && arguments.data.records[r].returnPrice >= 0) {

							// Create a new return orderItem
							var orderItem = this.newOrderItem();
							orderItem.setOrderItemType( getTypeService().getTypeBySystemCode('oitReturn') );
							orderItem.setOrderItemStatusType( getTypeService().getTypeBySystemCode('oistNew') );

							orderItem.setReferencedOrderItem( originalOrderItem );
							orderItem.setOrder( returnOrder );
							orderItem.setPrice( arguments.data.records[r].returnPrice );
							orderItem.setSkuPrice( originalOrderItem.getSku().getPrice() );
							orderItem.setCurrencyCode( originalOrderItem.getSku().getCurrencyCode() );
							orderItem.setQuantity( arguments.data.records[r].returnQuantity );
							orderItem.setSku( originalOrderItem.getSku() );

							// Add this order item to the OrderReturns entity
							orderItem.setOrderReturn( orderReturn );

						}
					}
				}

				// Recalculate the order amounts for tax and promotions
				recalculateOrderAmounts( returnOrder );

				// Setup a payment to refund
				var referencedOrderPayment = this.getOrderPayment(arguments.data.referencedOrderPaymentID);
				if(!isNull(referencedOrderPayment)) {
					var newOrderPayment = referencedOrderPayment.duplicate();
					newOrderPayment.setOrderPaymentType( getTypeService().getTypeBySystemCode('optCredit') );
					newOrderPayment.setReferencedOrderPayment( referencedOrderPayment );
					newOrderPayment.setAmount( returnOrder.getTotal()*-1 );
					newOrderPayment.setOrder( returnOrder );
				}

				// Persit the new order
				getDAO().save( returnOrder );

				// If the end-user has choosen to auto-receive the return order && potentially
				if(arguments.data.autoProcessReceiveReturnFlag) {

					var autoProcessReceiveReturnData = {
						locationID = arguments.data.returnLocationID,
						boxCount = 1,
						packingSlipNumber = 'auto',
						autoProcessReturnPaymentFlag = arguments.data.autoProcessReturnPaymentFlag,
						records = arguments.data.records
					};

					for(var r=1; r <= arrayLen(autoProcessReceiveReturnData.records); r++) {
						for(var n=1; n<=arrayLen(returnOrder.getOrderItems()); n++) {
							if(autoProcessReceiveReturnData.records[r].orderItemID == returnOrder.getOrderItems()[n].getReferencedOrderItem().getOrderItemID()) {
								autoProcessReceiveReturnData.records[r].orderItemID = returnOrder.getOrderItems()[n].getOrderItemID();
							}
						}
						autoProcessReceiveReturnData.records[r].receiveQuantity = autoProcessReceiveReturnData.records[r].returnQuantity;
					}

					processOrderReturn(orderReturn, autoProcessReceiveReturnData, "receiveReturn");

				// If we are only auto-processing the payment, but not receiving then we need to call the processPayment from here
				} else if (arguments.data.autoProcessReturnPaymentFlag && arrayLen(returnOrder.getOrderPayments())) {

					// Setup basic processing data
					var processData = {
						amount = returnOrder.getOrderPayments()[1].getAmount(),
						providerTransactionID = returnOrder.getOrderPayments()[1].getMostRecentChargeProviderTransactionID()
					};

					processOrderPayment(returnOrder.getOrderPayments()[1], processData, 'credit');

				}

			}

		// CONTEXT: placeOnHold
		} else if (arguments.processContext == "placeOnHold") {

			arguments.order.setOrderStatusType( getTypeService().getTypeBySystemCode("ostOnHold") );

		// CONTEXT: takeOffHold
		} else if (arguments.processContext == "takeOffHold") {

			arguments.order.setOrderStatusType( getTypeService().getTypeBySystemCode("ostProcessing") );
			updateOrderStatus(arguments.order);

		// CONTEXT: closeOrder
		} else if (arguments.processContext == "cancelOrder") {

			// Loop over all the orderItems and set them to 0
			for(var i=1; i<=arrayLen(arguments.order.getOrderItems()); i++) {
				arguments.order.getOrderItems()[i].setQuantity(0);

				// Remove any promotionsApplied
				for(var p=arrayLen(arguments.order.getOrderItems()[i].getAppliedPromotions()); p>=1; p--) {
					arguments.order.getOrderItems()[i].getAppliedPromotions()[p].removeOrderItem();
				}

				// Remove any taxApplied
				for(var t=arrayLen(arguments.order.getOrderItems()[i].getAppliedTaxes()); t>=1; t--) {
					arguments.order.getOrderItems()[i].getAppliedTaxes()[t].removeOrderItem();
				}
			}

			// Loop over all the fulfillments and remove any fulfillmentCharges, and promotions applied
			for(var i=1; i<=arrayLen(arguments.order.getOrderFulfillments()); i++) {
				arguments.order.getOrderFulfillments()[i].setFulfillmentCharge(0);
				// Remove over any promotionsApplied
				for(var p=arrayLen(arguments.order.getOrderFulfillments()[i].getAppliedPromotions()); p>=1; p--) {
					arguments.order.getOrderFulfillments()[i].getAppliedPromotions()[p].removeOrderFulfillment();
				}
			}

			// Loop over all of the order discounts and remove them
			for(var p=arrayLen(arguments.order.getAppliedPromotions()); p>=1; p--) {
				arguments.order.getAppliedPromotions()[p].removeOrder();
			}

			// Loop over all the payments and credit for any charges, and set paymentAmount to 0
			for(var p=1; p<=arrayLen(arguments.order.getOrderPayments()); p++) {
				var totalReceived = precisionEvaluate(arguments.order.getOrderPayments()[p].getAmountReceived() - arguments.order.getOrderPayments()[p].getAmountCredited());
				if(totalReceived gt 0) {
					var paymentOK = getPaymentService().processPayment(arguments.order.getOrderPayments()[p], "credit", totalReceived, arguments.order.getOrderPayments()[p].getMostRecentChargeProviderTransactionID());
				}
				// Set payment amount to 0
				arguments.order.getOrderPayments()[p].setAmount(0);
			}

			// Set the status code to canceld
			arguments.order.setOrderStatusType( getTypeService().getTypeBySystemCode("ostCanceled") );

		// CONTEXT: cancelOrder
		} else if (arguments.processContext == "closeOrder") {

			updateOrderStatus(arguments.order);


		// CONTEXT: Add Promotion Code
		} else if (arguments.processContext == "addPromotionCode") {

			var pc = getPromotionService().getPromotionCodeByPromotionCode(arguments.data.promotionCode);

			if(isNull(pc) || !pc.getPromotion().getActiveFlag()) {
				arguments.order.addError("promotionCode", rbKey('validate.promotionCode.invalid'));
			} else if ( (!isNull(pc.getStartDateTime()) && pc.getStartDateTime() > now()) || (!isNull(pc.getEndDateTime()) && pc.getEndDateTime() < now()) || !pc.getPromotion().getCurrentFlag()) {
				arguments.order.addError("promotionCode", rbKey('validate.promotionCode.invaliddatetime'));
			} else if (arrayLen(pc.getAccounts()) && !pc.hasAccount(getSlatwallScope().getCurrentAccount())) {
				arguments.order.addError("promotionCode", rbKey('validate.promotionCode.invalidaccount'));
			} else {
				if(!arguments.order.hasPromotionCode( pc )) {
					arguments.order.addPromotionCode( pc );
				}
				recalculateOrderAmounts(order=arguments.order);
			}

		} else {

			// Do Notion
		}

		return arguments.order;
	}

	// Process: Order Fulfillment
	public any function processOrderFulfillment(required any orderFulfillment, struct data={}, string processContext="process") {

		// CONTEXT: fulfillItems
		if(arguments.processContext == "fulfillItems") {
			// Make sure that a location was passed in
			if(structKeyExists(arguments.data, "locationID")) {
				var location = getLocationService().getLocation(  arguments.data.locationID );

				// Make sure that the location is not Null
				if(!isNull(location)) {

					// Create a new Order Delivery and set the relevent values
					var orderDelivery = this.newOrderDelivery();
					orderDelivery.setFulfillmentMethod( arguments.orderFulfillment.getFulfillmentMethod() );
					orderDelivery.setLocation( location );

					// Attach this delivery to the order
					orderDelivery.setOrder( arguments.orderFulfillment.getOrder() );

					// Per Fulfillment Method Type set whatever other details need to be set
					switch(arguments.orderFulfillment.getFulfillmentMethodType()) {

						case "auto": {
							// With an 'auto' type of setup, if no records exist in the data, then we can just create deliveryItems for the unfulfilled quantities of each item
							if(!structKeyExists(arguments.data, "records")) {
								arguments.data.records = [];
								for(var i=1; i<=arrayLen(arguments.orderFulfillment.getOrderFulfillmentItems()); i++) {
									arrayAppend(arguments.data.records, {orderItemID=arguments.orderFulfillment.getOrderFulfillmentItems()[i].getOrderItemID(), quantity=arguments.orderFulfillment.getOrderFulfillmentItems()[i].getQuantityUndelivered()});
								}
							}
							break;
						}
						case "shipping": {
							// Set the shippingAddress, shippingMethod & potentially tracking number
							orderDelivery.setShippingAddress( arguments.orderFulfillment.getShippingAddress().copyAddress( saveNewAddress=true ) );
							orderDelivery.setShippingMethod(arguments.orderFulfillment.getShippingMethod());
							if(structkeyExists(arguments.data, "trackingNumber") && len(arguments.data.trackingNumber)) {
								orderDelivery.setTrackingNumber(arguments.data.trackingNumber);
							}
							break;
						}
						default: {

							break;
						}
					}

					// Setup a total item value delivered so we can charge the proper amount for the payment later
					var totalItemValueDelivered = 0;

					// Loop over the records in the data to set the quantity for the delivery
					if(structKeyExists(arguments.data, "records")) {
						for(var i=1; i<=arrayLen(arguments.data.records); i++) {

							// Only add this orderItem to the delivery if it has an orderItemID, a quantity is defined, and the quantity is numeric and gt 1
							if(structKeyExists(arguments.data.records[i], "orderItemID") && isSimpleValue(arguments.data.records[i].orderItemID) && structKeyExists(arguments.data.records[i], "quantity") && isNumeric(arguments.data.records[i].quantity) && arguments.data.records[i].quantity > 0) {

								var orderItem = this.getOrderItem(arguments.data.records[i].orderItemID);
								if(!isNull(orderItem)) {

									// Make sure that we aren't trying to deliver more than was ordered
									if(orderItem.getQuantityUndelivered() >= arguments.data.records[i].quantity) {

										// Grab the stock that matches the item and the location from which we are delivering
										var stock = getStockService().getStockBySkuAndLocation(orderItem.getSku(), orderDelivery.getLocation());

										// Create and Populate a new delivery item
										var orderDeliveryItem = this.newOrderDeliveryItem();
										orderDeliveryItem.setOrderDelivery( orderDelivery );
										orderDeliveryItem.setOrderItem( orderItem );
										orderDeliveryItem.setStock( stock );
										orderDeliveryItem.setQuantity( arguments.data.records[i].quantity );

										// Add the value of this item to the total charge
										totalItemValueDelivered = precisionEvaluate(totalItemValueDelivered + (orderItem.getExtendedPriceAfterDiscount() + orderItem.getTaxAmount()) * ( arguments.data.records[i].quantity / orderItem.getQuantity() ) );

										// setup subscription data if this was subscriptionOrder item
										getSubscriptionService().setupSubscriptionOrderItem( orderItem );

										// setup content access if this was content purchase
										setupOrderItemContentAccess( orderItem );

									} else {
										arguments.orderFulfillment.addError('orderFulfillmentItem', 'You are trying to fulfill a quantity of #arguments.data.records[i].quantity# for #orderItem.getSku().getProduct().getTitle()# - #orderItem.getSku().displayOptions()# and that item only has an undelivered quantity of #orderItem.getQuantityUndelivered()#');

									}

								} else {
									arguments.orderFulfillment.addError('orderFulfillmentItem', 'An orderItem with the ID: #arguments.data.records[i].orderItemID# was trying to be processed with this fulfillment, but that orderItem does not exist');
								}
							}
						}
					}

					// Validate the orderDelivery
					orderDelivery.validate();

					if(!orderDelivery.hasErrors()) {

						// Call save on the orderDelivery so that it is persisted
						getDAO().save( orderDelivery );

						// Update the Order Status
						updateOrderStatus( arguments.orderFulfillment.getOrder(), true );

						// Look to charge orderPayments
						if(structKeyExists(arguments.data, "processCreditCard") && isBoolean(arguments.data.processCreditCard) && arguments.data.processCreditCard) {
							var totalAmountToCharge = arguments.orderFulfillment.getOrder().getDeliveredItemsPaymentAmountUnreceived();
							var totalAmountCharged = 0;

							for(var p=1; p<=arrayLen(arguments.orderFulfillment.getOrder().getOrderPayments()); p++) {

								var orderPayment = arguments.orderFulfillment.getOrder().getOrderPayments()[p];

								// Make sure that this is a credit card, and that it is a charge type of payment
								if(orderPayment.getPaymentMethodType() == "creditCard" && orderPayment.getOrderPaymentType().getSystemCode() == "optCharge") {

									// Check to make sure this payment hasn't been fully received
									if(orderPayment.getAmount() > orderPayment.getAmountReceived()) {

										var thisAmountToCharge = 0;

										// Attempt to capture preAuthorizations first
										if(orderPayment.getAmountAuthorized() > orderPayment.getAmountReceived()) {
											var thisAmountToCharge = orderPayment.getAmountAuthorized() - orderPayment.getAmountReceived();
											if(thisAmountToCharge > (totalAmountToCharge - totalAmountCharged)) {
												thisAmountToCharge = totalAmountToCharge - totalAmountCharged;
											}

											orderPayment = processOrderPayment(orderPayment, {amount=thisAmountToCharge}, "chargePreAuthorization");
											if(!orderPayment.hasErrors()) {
												totalAmountCharged = precisionEvaluate(totalAmountCharged + thisAmountToCharge);

												// Set the new payment transaction into the orderDelivery for later use
												var pts = orderPayment.getPaymentTransactions();
												orderDelivery.setPaymentTransaction( pts[arrayLen(pts)] );
											} else {
												structDelete(orderPayment.getErrors(), "processing");
											}
										}

										// Attempt to authorizeAndCharge now
										if(orderPayment.getAmountReceived() < orderPayment.getAmount() && totalAmountToCharge > totalAmountCharged) {
											var thisAmountToCharge = orderPayment.getAmount() - orderPayment.getAmountReceived();
											if(thisAmountToCharge > (totalAmountToCharge - totalAmountCharged)) {
												thisAmountToCharge = totalAmountToCharge - totalAmountCharged;
											}
											orderPayment = processOrderPayment(orderPayment, {amount=thisAmountToCharge}, "authorizeAndCharge");
											if(!orderPayment.hasErrors()) {
												totalAmountCharged = precisionEvaluate(totalAmountCharged + thisAmountToCharge);

												// Set the new payment transaction into the orderDelivery for later use
												var pts = orderPayment.getPaymentTransactions();
												orderDelivery.setPaymentTransaction( pts[arrayLen(pts)] );
											} else {
												structDelete(orderPayment.getErrors(), "processing");
											}
										}

										// Stop trying to charge payments, if we have charged everything we need to
										if(totalAmountToCharge == totalAmountCharged) {
											break;
										}
									}
								}
							}
						}

					} else {

						getSlatwallScope().setORMHasErrors( true );

						arguments.orderFulfillment.addError('location', 'The delivery that would have been created had errors');
					}

				} else {
					arguments.orderFulfillment.addError('location', 'The Location id that was passed in does not represent a valid location');

				}
			} else {
				arguments.orderFulfillment.addError('location', 'No Location was passed in');

			}

			// if this fulfillment had error then we don't want to persist anything
			if(arguments.orderFulfillment.hasErrors()) {

				getSlatwallScope().setORMHasErrors( true );

			}
		}

		return arguments.orderFulfillment;
	}


	// Process: Order Return
	public any function processOrderReturn(required any orderReturn, struct data={}, string processContext="process") {
		if(arguments.processContext eq "receiveReturn") {

			var hasAtLeastOneItemToReturn = false;
			for(var i=1; i<=arrayLen(arguments.data.records); i++) {
				if(isNumeric(arguments.data.records[i].receiveQuantity) && arguments.data.records[i].receiveQuantity gt 0) {
					var hasAtLeastOneItemToReturn = true;
				}
			}

			if(!hasAtLeastOneItemToReturn) {
				arguments.orderReturn.addError('processing', 'You need to specify at least 1 item to be returned');
			} else {
				// Set this up to calculate how much credit to process if that flag is set later
				var totalAmountToCredit = 0;

				// If this is the first Stock Receiver, then we should add the fulfillmentRefund to the total received amount
				if(!arrayLen(arguments.orderReturn.getOrder().getStockReceivers()) && !isNull(arguments.orderReturn.getFulfillmentRefundAmount()) && arguments.orderReturn.getFulfillmentRefundAmount() > 0) {
					totalAmountReceived = arguments.orderReturn.getFulfillmentRefundAmount();
				}

				// Setup the received location
				var receivedLocation = getLocationService().getLocation(arguments.data.locationID);

				// Create a new Stock Receiver
				var newStockReceiver = getStockService().newStockReceiver();
				newStockReceiver.setReceiverType( 'order' );
				newStockReceiver.setOrder( arguments.orderReturn.getOrder() );
				newStockReceiver.setBoxCount( arguments.data.boxcount );
				newStockReceiver.setPackingSlipNumber( arguments.data.packingSlipNumber );

				for(var i=1; i<=arrayLen(arguments.data.records); i++) {
					if(isNumeric(arguments.data.records[i].receiveQuantity) && arguments.data.records[i].receiveQuantity gt 0) {

						var orderItemReceived = this.getOrderItem( arguments.data.records[i].orderItemID );
						var stockReceived = getStockService().getStockBySkuAndLocation(orderItemReceived.getSku(), receivedLocation);

						totalAmountToCredit = precisionEvaluate(totalAmountToCredit + (orderItemReceived.getExtendedPriceAfterDiscount() + orderItemReceived.getTaxAmount()) * ( arguments.data.records[i].receiveQuantity / orderItemReceived.getQuantity() ) );

						var newStockReceiverItem = getStockService().newStockReceiverItem();
						newStockReceiverItem.setStockReceiver( newStockReceiver );
						newStockReceiverItem.setOrderItem( orderItemReceived );
						newStockReceiverItem.setStock( stockReceived );
						newStockReceiverItem.setQuantity( arguments.data.records[i].receiveQuantity );
						newStockReceiverItem.setCost( 0 );

						// Cancel a subscription if returned item has a subscriptionUsage
						if(!isNull(orderItemReceived.getReferencedOrderItem())) {
							var subscriptionOrderItem = getSubscriptionService().getSubscriptionOrderItem({orderItem=orderItemReceived.getReferencedOrderItem()});
							if(!isNull(subscriptionOrderItem)) {
								getSubscriptionService().processSubscriptionUsage(subscriptionUsage=subscriptionOrderItem.getSubscriptionUsage(), processContext="cancel");
							}
						}

						// TODO: Cancel Content Access

					}
				}

				getStockService().saveStockReceiver( newStockReceiver );

				// Update the Order Status
				updateOrderStatus( arguments.orderReturn.getOrder(), true );

				// Look to credit any order payments
				if(arguments.data.autoProcessReturnPaymentFlag) {

					var totalAmountCredited = 0;

					for(var p=1; p<=arrayLen(arguments.orderReturn.getOrder().getOrderPayments()); p++) {

						var orderPayment = arguments.orderReturn.getOrder().getOrderPayments()[p];

						// Make sure that this is a credit card, and that it is a charge type of payment
						if(orderPayment.getPaymentMethodType() == "creditCard" && orderPayment.getOrderPaymentType().getSystemCode() == "optCredit") {

							// Check to make sure this payment hasn't been fully received
							if(orderPayment.getAmount() > orderPayment.getAmountCredited()) {

								var potentialCredit = precisionEvaluate(orderPayment.getAmount() - orderPayment.getAmountCredited());
								if(potentialCredit > precisionEvaluate(totalAmountToCredit - totalAmountCredited)) {
									var thisAmountToCredit = precisionEvaluate(totalAmountToCredit - totalAmountCredited);
								} else {
									var thisAmountToCredit = potentialCredit;
								}

								orderPayment = processOrderPayment(orderPayment, {amount=thisAmountToCredit, providerTransactionID=orderPayment.getMostRecentChargeProviderTransactionID()}, "credit");
								if(!orderPayment.hasErrors()) {
									totalAmountCredited = precisionEvaluate(totalAmountCredited + thisAmountToCredit);
								} else {
									structDelete(orderPayment.getErrors(), "processing");
								}

								// Stop trying to charge payments, if we have charged everything we need to
								if(totalAmountToCredit == totalAmountCredited) {
									break;
								}
							}
						}
					}
				}

			}
		}

		return arguments.orderReturn;
	}

	// Process: Order Payment

	public any function processOrderPayment(required any orderPayment, struct data={}, string processContext="process") {

		param name="arguments.data.amount" default="0";

		// CONTEXT: authorize, authorizeAndCharge, credit
		if( (arguments.processContext == "authorize" && arguments.data.amount <= arguments.orderPayment.getAmountUnauthorized())
			||
			(arguments.processContext == "authorizeAndCharge" && arguments.data.amount <= arguments.orderPayment.getAmountUnreceived())
			||
			(arguments.processContext == "credit" && arguments.data.amount <= arguments.orderPayment.getAmountUncredited()) ) {

			// Standard Payment Process
			getPaymentService().processPayment(arguments.orderPayment, arguments.processContext, arguments.data.amount);

		// CONTEXT: chargePreAuthorization
		} else if (arguments.processContext == "chargePreAuthorization" && arguments.data.amount <= arguments.orderPayment.getAmountUncaptured()) {

			// We can loop over previous transactions for authroization codes to capture the amount we need.
			var totalCaptured = 0;

			for(var i=1; i<=arrayLen(arguments.orderPayment.getPaymentTransactions()); i++) {

				var originalTransaction = arguments.orderPayment.getPaymentTransactions()[i];

				if( originalTransaction.getAmountAuthorized() > 0 && originalTransaction.getAmountAuthorized() > originalTransaction.getAmountReceived() ) {

					var capturableAmount = originalTransaction.getAmountAuthorized() - originalTransaction.getAmountReceived();
					var leftToCapture = arguments.data.amount - totalCaptured;
					var captureAmount = 0;

					if(leftToCapture < capturableAmount) {
						captureAmount = leftToCapture;
					} else {
						captureAmount = capturableAmount;
					}

					arguments.data.providerTransactionID = originalTransaction.getProviderTransactionID();

					var paymentOK = getPaymentService().processPayment(arguments.orderPayment, "chargePreAuthorization", captureAmount, originalTransaction);

					if(paymentOK) {
						totalCaptured = precisionEvaluate(totalCaptured + capturableAmount);
					}

					// If some payments failed but the total was finally captured, then we can can remove any processing errors
					if(totalCaptured == arguments.data.amount) {
						structDelete(arguments.orderPayment.getErrors(), 'processing');
						break;
					}
				}
			}

		// CONTEXT: offlineTransaction
		} else if (arguments.processContext == "offlineTransaction") {

			var newPaymentTransaction = getPaymentService().newPaymentTransaction();
			newPaymentTransaction.setTransactionType( "offline" );
			newPaymentTransaction.setOrderPayment( arguments.orderPayment );
			newPaymentTransaction = getPaymentService().savePaymentTransaction(newPaymentTransaction, arguments.data);

			if(newPaymentTransaction.hasErrors()) {
				arguments.orderPayment.addError('processing', 'There was an unknown error trying to add an offline transaction for this order payment.');
			}

		} else {

			arguments.orderPayment.addError('processing', 'You attempted to process an order payment but either a transactionType or an amount was not defined.');

		}

		if(!arguments.orderPayment.hasErrors()) {
			// Update the Order Status
			updateOrderStatus( arguments.orderPayment.getOrder() );
		}

		return arguments.orderPayment;
	}

	// =====================  END: Process Methods ============================

	// ====================== START: Status Methods ===========================

	public void function updateOrderStatus( required any order, updateItemStatus=false ) {
		// First we make sure that this order status is not 'closed', 'canceld', 'notPlaced' or 'onHold' because we cannot automatically update those statuses
		if(!listFindNoCase("ostNotPlaced,ostOnHold,ostClosed,ostCanceled", arguments.order.getOrderStatusType().getSystemCode())) {

			// We can check to see if all the items have been delivered and the payments have all been received then we can close this order
			if(arguments.order.getPaymentAmountReceivedTotal() == arguments.order.getTotal() && arguments.order.getQuantityUndelivered() == 0 && arguments.order.getQuantityUnreceived() == 0)	{
				arguments.order.setOrderStatusType(  getTypeService().getTypeBySystemCode("ostClosed") );

			// The default case is just to set it to processing
			} else {
				arguments.order.setOrderStatusType(  getTypeService().getTypeBySystemCode("ostProcessing") );
			}
		}

		// If we are supposed to update the items as well, loop over all items and pass to 'updateItemStatus'
		if(arguments.updateItemStatus) {
			for(var i=1; i<=arrayLen(arguments.order.getOrderItems()); i++) {
				updateOrderItemStatus( arguments.order.getOrderItems()[i] );
			}
		}
	}

	public void function updateOrderItemStatus( required any orderItem ) {

		// First we make sure that this order item is not already fully fulfilled, or onHold because we cannont automatically update those statuses
		if(!listFindNoCase("oistFulfilled,oistOnHold",arguments.orderItem.getOrderItemStatusType().getSystemCode())) {

			// If the quantityUndelivered is set to 0 then we can mark this as fulfilled
			if(arguments.orderItem.getQuantityUndelivered() == 0) {
				arguments.orderItem.setOrderItemStatusType(  getTypeService().getTypeBySystemCode("oistFulfilled") );

			// If the sku is setup to track inventory and the qoh is 0 then we can set the status to 'backordered'
			} else if(arguments.orderItem.getSku().setting('skuTrackInventoryFlag') && arguments.orderItem.getSku().getQuantity('qoh') == 0) {
				arguments.orderItem.setOrderItemStatusType(  getTypeService().getTypeBySystemCode("oistBackordered") );

			// Otherwise we just set this to 'processing' to show that the item is in limbo
			} else {
				arguments.orderItem.setOrderItemStatusType(  getTypeService().getTypeBySystemCode("oistProcessing") );

			}
		}

	}

	// ======================  END: Status Methods ============================

	// ====================== START: Save Overrides ===========================

	public any function saveOrder(required any order, struct data={}, string context="save") {

		// Call the super.save() method to do the base populate & validate logic
		arguments.order = super.save(entity=arguments.order, data=arguments.data, context=arguments.context);

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

	public any function saveOrderFulfillment(required any orderFulfillment, struct data={}) {

		// If fulfillment method is shipping do this
		if(arguments.orderFulfillment.getFulfillmentMethodType() == "shipping") {
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

			// If it has changed we need to update Taxes and Shipping Options
			if(serializedAddressBefore != serializedAddressAfter) {
				getService("ShippingService").updateOrderFulfillmentShippingMethodOptions( arguments.orderFulfillment );
				getTaxService().updateOrderAmountsWithTaxes( arguments.orderFulfillment.getOrder() );
			}

			// USING ACCOUNT ADDRESS
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

				// If there was previously a shipping Address we need to remove it and recalculate
				if(!isNull(arguments.orderFulfillment.getShippingAddress())) {
					arguments.orderFulfillment.removeShippingAddress();
					arguments.orderFulfillment.setAccountAddress(accountAddress);
					getService("ShippingService").updateOrderFulfillmentShippingMethodOptions( arguments.orderFulfillment );
					getTaxService().updateOrderAmountsWithTaxes(arguments.orderFulfillment.getOrder());
				// If there was previously an account address and we switch it, then we need to recalculate
				} else if (!isNull(arguments.orderFulfillment.getAccountAddress()) && arguments.orderFulfillment.getAccountAddress().getAccountAddressID() != accountAddress.getAccountAddressID()) {
					arguments.orderFulfillment.setAccountAddress(accountAddress);
					getTaxService().updateOrderAmountsWithTaxes(arguments.orderFulfillment.getOrder());
					getService("ShippingService").updateOrderFulfillmentShippingMethodOptions( arguments.orderFulfillment );
				// Else just set the account address
				} else {
					arguments.orderFulfillment.setAccountAddress(accountAddress);
				}


			// USING SHIPPING ADDRESS
			} else {

				// If there was previously an account address we need to remove and recalculate
				if(!isNull(arguments.orderFulfillment.getAccountAddress())) {
					arguments.orderFulfillment.removeAccountAddress();
					getTaxService().updateOrderAmountsWithTaxes(arguments.orderFulfillment.getOrder());
					getService("ShippingService").updateOrderFulfillmentShippingMethodOptions( arguments.orderFulfillment );
				}

				// Set the address in the order Fulfillment as shipping address
				arguments.orderFulfillment.setShippingAddress(address);
			}

			// Validate & Save Address
			address.validate(context="full");

			address = getAddressService().saveAddress(address);

			// Check for a shippingMethodOptionID selected
			if(structKeyExists(arguments.data, "fulfillmentShippingMethodOptionID")) {
				var methodOption = getShippingService().getShippingMethodOption(arguments.data.fulfillmentShippingMethodOptionID);

				// Verify that the method option is one for this fulfillment
				if(!isNull(methodOption) && arguments.orderFulfillment.hasFulfillmentShippingMethodOption(methodOption)) {
					// Update the orderFulfillment to have this option selected
					arguments.orderFulfillment.setShippingMethod(methodOption.getShippingMethodRate().getShippingMethod());
					arguments.orderFulfillment.setFulfillmentCharge(methodOption.getTotalCharge());
				}

			// If no shippingMethodOption, then just check for a shippingMethodID that was passed in
			} else if (structKeyExists(arguments.data, "shippingMethodID")) {

				var shippingMethod = getShippingService().getShippingMethod(arguments.data.shippingMethodID);

				// If this is a valid shipping method, then we can loop over all of the shippingMethodOptions and make sure this one exists
				if(!isNull(shippingMethod)) {
					for(var i=1; i<=arrayLen(arguments.orderFulfillment.getShippingMethodOptions()); i++) {
						if(shippingMethod.getShippingMethodID() == arguments.orderFulfillment.getShippingMethodOptions()[i].getShippingMethodRate().getShippingMethod().getShippingMethodID()) {
							arguments.orderFulfillment.setShippingMethod( arguments.orderFulfillment.getShippingMethodOptions()[i].getShippingMethodRate().getShippingMethod() );
							arguments.orderFulfillment.setFulfillmentCharge( arguments.orderFulfillment.getShippingMethodOptions()[i].getTotalCharge() );
						}
					}
				}
			}

			// Validate the order Fulfillment
			arguments.orderFulfillment.validate();

			// Set ORMHasErrors if the orderFulfillment has errors
			if(arguments.orderFulfillment.hasErrors()) {
				getSlatwallScope().setORMHasErrors( true );
			}

			if(!getSlatwallScope().getORMHasErrors()) {
				getDAO().flushORMSession();
			}
		}

		// Save the order Fulfillment
		return getDAO().save(arguments.orderFulfillment);
	}

	// ======================  END: Save Overrides ============================

	// ==================== START: Smart List Overrides =======================

	public any function getOrderSmartList(struct data={}) {
		arguments.entityName = "SlatwallOrder";

		var smartList = getDAO().getSmartList(argumentCollection=arguments);

		smartList.joinRelatedProperty("SlatwallOrder", "account", "left", true);
		smartList.joinRelatedProperty("SlatwallOrder", "orderType", "left", true);
		smartList.joinRelatedProperty("SlatwallOrder", "orderStatusType", "left", true);
		smartList.joinRelatedProperty("SlatwallOrder", "orderOrigin", "left", true);
		smartList.joinRelatedProperty("SlatwallAccount", "primaryEmailAddress", "left", true);
		smartList.joinRelatedProperty("SlatwallAccount", "primaryPhoneNumber", "left", true);

		smartList.addKeywordProperty(propertyIdentifier="orderNumber", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="account.firstName", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="account.lastName", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="account.company", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="account.primaryEmailAddress.emailAddress", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="account.primaryPhoneNumber.phoneNumber", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="orderOrigin.orderOriginName", weight=1);

		return smartList;
	}

	// ====================  END: Smart List Overrides ========================

	// ====================== START: Get Overrides ============================

	// ======================  END: Get Overrides =============================

}
