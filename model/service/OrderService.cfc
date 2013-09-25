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

	property name="orderDAO";
	
	property name="accountService";
	property name="addressService";
	property name="commentService";
	property name="emailService";
	property name="locationService";
	property name="fulfillmentService";
	property name="paymentService";
	property name="priceGroupService";
	property name="promotionService";
	property name="settingService";
	property name="shippingService";
	property name="skuService";
	property name="stockService";
	property name="subscriptionService";
	property name="taxService";
	
	// ===================== START: Logical Methods ===========================
	
	public string function getOrderRequirementsList(required any order) {
		var orderRequirementsList = "";
		
		// Check if the order still requires a valid account
		if(isNull(arguments.order.getAccount()) || arguments.order.getAccount().hasErrors()) {
			orderRequirementsList = listAppend(orderRequirementsList, "account");
		}
	
		// Check each of the orderFulfillments to see if they are ready to process
		for(var i = 1; i <= arrayLen(arguments.order.getOrderFulfillments()); i++) {
			if(!arguments.order.getOrderFulfillments()[i].isProcessable( context="placeOrder" ) || arguments.order.getOrderFulfillments()[i].hasErrors()) {
				orderRequirementsList = listAppend(orderRequirementsList, "fulfillment");
				break;
			}
		}
		
		// Check each of the orderReturns to see if they are ready to process
		for(var i = 1; i <= arrayLen(arguments.order.getOrderReturns()); i++) {
			if(!arguments.order.getOrderReturns()[i].isProcessable( context="placeOrder" ) || arguments.order.getOrderReturns()[i].hasErrors()) {
				orderRequirementsList = listAppend(orderRequirementsList, "return");
				break;
			}
		}

		// If not enough payments have been defined then 
		if(arguments.order.getPaymentAmountTotal() != arguments.order.getTotal()) {
			orderRequirementsList = listAppend(orderRequirementsList, "payment");
			
		// Otherwise, make sure that the order payments all pass the isProcessable for placeOrder & does not have any errors
		} else {
			
			for(var orderPayment in arguments.order.getOrderPayments()) {
				if(orderPayment.getStatusCode() eq 'opstActive' && (!orderPayment.isProcessable( context="placeOrder" ) || orderPayment.hasErrors())) {
					orderRequirementsList = listAppend(orderRequirementsList, "payment");
					break;
				}
			}
			
		}
		
		return orderRequirementsList;
	}
	
	public void function recalculateOrderAmounts(required any order) {
		
		if(!listFindNoCase("ostCanceled,ostClosed", arguments.order.getOrderStatusType().getSystemCode())) {
			
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
		newOrder.getAccount().setHibachiErrors( originalOrder.getAccount().getHibachiErrors() );
		
		this.saveOrder( newOrder );
		
		return newOrder;
	}
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	public struct function getQuantityPriceSkuAlreadyReturned(required any orderID, required any skuID) {
		return getOrderDAO().getQuantityPriceSkuAlreadyReturned(arguments.orderId, arguments.skuID);
	}
	
	public numeric function getPreviouslyReturnedFulfillmentTotal(required any orderID) {
		return getOrderDAO().getPreviouslyReturnedFulfillmentTotal(arguments.orderId);
	}
	
	public any function getMaxOrderNumber() {
		return getOrderDAO().getMaxOrderNumber();
	}
	
	public numeric function getOrderPaymentNonNullAmountTotal(required string orderID) {
		return getOrderDAO().getOrderPaymentNonNullAmountTotal(argumentcollection=arguments);
	}
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	// Process: Order
	public any function processOrder_addOrderItem(required any order, required any processObject) {
		
		// Setup a boolean to see if we were able to just att this order item to an existing one
		var foundItem = false;
		
		// Make sure that the currencyCode gets set for this order
		if(isNull(arguments.order.getCurrencyCode())) {
			arguments.order.setCurrencyCode( arguments.processObject.getCurrencyCode() );
		}
		
		// If this is a Sale Order Item then we need to setup the fulfillment
		if(arguments.processObject.getOrderItemTypeSystemCode() eq "oitSale") {
			
			// First See if we can use an existing order fulfillment
			var orderFulfillment = processObject.getOrderFulfillment();
			
			// Next if orderFulfillment is still null, then we can check the order to see if there is already an orderFulfillment
			if(isNull(orderFulfillment) && ( isNull(processObject.getOrderFulfillmentID()) || processObject.getOrderFulfillmentID() != 'new' ) && arrayLen(arguments.order.getOrderFulfillments())) {
				for(var f=1; f<=arrayLen(arguments.order.getOrderFulfillments()); f++) {
					if(listFindNoCase(arguments.processObject.getSku().setting('skuEligibleFulfillmentMethods'), arguments.order.getOrderFulfillments()[f].getFulfillmentMethod().getFulfillmentMethodID()) ) {
						var orderFulfillment = arguments.order.getOrderFulfillments()[f];
						break;
					}	
				}
			}
			
			// Last if we can't use an existing one, then we need to create a new one
			if(isNull(orderFulfillment) || orderFulfillment.getOrder().getOrderID() != arguments.order.getOrderID()) {
				
				// get the correct fulfillment method for this new order fulfillment
				var fulfillmentMethod = arguments.processObject.getFulfillmentMethod();
				
				// If the fulfillmentMethod is still null because the above didn't execute, then we can pull it in from the first ID in the sku settings
				if(isNull(fulfillmentMethod) && listLen(arguments.processObject.getSku().setting('skuEligibleFulfillmentMethods'))) {
					var fulfillmentMethod = getFulfillmentService().getFulfillmentMethod( listFirst(arguments.processObject.getSku().setting('skuEligibleFulfillmentMethods')) );
				}
				
				if(!isNull(fulfillmentMethod)) {
					// Setup a new order fulfillment
					var orderFulfillment = this.newOrderFulfillment();
					
					orderFulfillment.setFulfillmentMethod( fulfillmentMethod );
					orderFulfillment.setCurrencyCode( arguments.order.getCurrencyCode() );
					orderFulfillment.setOrder( arguments.order );
					
					// Setup 'Shipping' Values
					if(orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "shipping") {
						
						// Check for an accountAddress
						if(len(arguments.processObject.getShippingAccountAddressID())) {
							
							// Find the correct account address, and set it in the order fulfillment
							var accountAddress = getAccountService().getAccountAddress( arguments.processObject.getShippingAccountAddressID() );
							orderFulfillment.setAccountAddress( accountAddress );
						
						// Otherwise try to setup a new shipping address
						} else {
							
							// Check to see if the new shipping address passes full validation.
							fullAddressErrors = getHibachiValidationService().validate( arguments.processObject.getShippingAddress(), 'full', false );
							
							if(!fullAddressErrors.hasErrors()) {
								// First we need to persist the address from the processObject
								getAddressService().saveAddress( arguments.processObject.getShippingAddress() );
								
								// If we are supposed to save the new address, then we can do that here
								if(arguments.processObject.getSaveShippingAccountAddressFlag() && !isNull(arguments.order.getAccount()) ) {
									
									var newAccountAddress = getAccountService().newAccountAddress();
									newAccountAddress.setAccount( arguments.order.getAccount() );
									newAccountAddress.setAccountAddressName( arguments.processObject.getSaveShippingAccountAddressName() );
									newAccountAddress.setAddress( arguments.processObject.getShippingAddress() );
									orderFulfillment.setAccountAddress( newAccountAddress );
									
								// Otherwise just set then new address in the order fulfillment
								} else {
									
									orderFulfillment.setShippingAddress( arguments.processObject.getShippingAddress() );
								}
							}
						}
						
					// Set 'Pickup' Values
					} else if (orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "pickup") {
						
						// Check for a pickupLocationID
						if(!isNull(arguments.processObject.getPickupLocationID()) && len(arguments.processObject.getPickupLocationID())) {
							
							// Find the pickup location
							var pickupLocation = getLocationService().getLocation(arguments.processObject.getPickupLocationID());
							
							// if found set in the orderFulfillment
							if(!isNull(pickupLocation)) {
								orderFulfillment.setPickupLocation(pickupLocation);
							}
						}
						
					// Set 'Email' Value
					} else if (orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "email") {
						
						// Check for an email address
						if(!isNull(arguments.processObject.getEmailAddress()) && len(arguments.processObject.getEmailAddress())) {
							orderFulfillment.setEmailAddress( arguments.processObject.getEmailAddress() );
						}
						
					}
					
					orderFulfillment = this.saveOrderFulfillment( orderFulfillment );
					
				} else {
					
					arguments.processObject.addError('fulfillmentMethodID', rbKey('validate.processOrder_addOrderitem.orderFulfillmentID.noValidFulfillmentMethod'));
					
				}
				
			}
			
			// Check for the sku in the orderFulfillment already, so long that the order doens't have any errors
			if(!arguments.order.hasErrors()) {
				for(var i=1; i<=arrayLen(orderFulfillment.getOrderFulfillmentItems()); i++) {
					
					var thisItem = orderFulfillment.getOrderFulfillmentItems()[i];
					
					// If the sku, price & stock all match then just increse the quantity
					if( 	thisItem.getSku().getSkuID() == arguments.processObject.getSku().getSkuID()
						  		&&
							thisItem.getPrice() == arguments.processObject.getPrice()
								&&
							((isNull(thisItem.getStock()) && isNull(arguments.processObject.getStock())) || (!isNull(thisItem.getStock()) && !isNull(arguments.processObject.getStock()) && thisItem.getStock().getStockID() == arguments.processObject.getStock().getStockID() ))
						) {

						//We have the same line item, but we need to make sure that we don't have a different set of customizations.
						var customizationsMatch = true;
						if(NOT ArrayIsEmpty(thisItem.getAttributeValues())){
							for(var j=1; j<=arrayLen(thisItem.getAttributeValues()); j++){
								var thisAttribute = thisItem.getAttributeValues()[j];
								if(	StructKeyExists(arguments.data, thisAttribute.getAttribute().getAttributeCode()) 
										&& 
									arguments.data[thisAttribute.getAttribute().getAttributeCode()] != thisAttribute.getAttributeValue()
								){
									customizationsMatch = false;
									break;	
								}
							}
						}
						
						//If both the product data and the customizations match, then increase the quantity.
						if(customizationsMatch){
							foundItem = true;
							orderFulfillment.getOrderFulfillmentItems()[i].setQuantity(orderFulfillment.getOrderFulfillmentItems()[i].getQuantity() + arguments.processObject.getQuantity());
							orderFulfillment.getOrderFulfillmentItems()[i].validate(context='save');
							if(orderFulfillment.getOrderFulfillmentItems()[i].hasErrors()) {
								arguments.order.addError('addOrderItem', orderFulfillment.getOrderFulfillmentItems()[i].getErrors());
							}
							break;
						}
					}
				}
			}
			
		// If this is a return order item, then we need to setup or find the orderReturn
		} else if (arguments.processObject.getOrderItemTypeSystemCode() eq "oitReturn") {
			
			// First see if we can use an existing order return
			var orderReturn = processObject.getOrderReturnID();	
			
			// Next if we can't use an existing one, then we need to create a new one
			if(isNull(orderReturn) || orderReturn.getOrder().getOrderID() neq arguments.order.getOrderID()) {
				
				// Setup a new order return
				var orderReturn = this.newOrderReturn();
				orderReturn.setOrder( arguments.order );
				orderReturn.setCurrencyCode( arguments.order.getCurrencyCode() );
				orderReturn.setReturnLocation( arguments.processObject.getReturnLocation() );
				orderReturn.setFulfillmentRefundAmount( arguments.processObject.getFulfillmentRefundAmount() );
				
				orderReturn = this.saveOrderReturn( orderReturn );
			}
			
		}
		
		// If we didn't already find the item in an orderFulfillment, then we can add it here.
		if(!foundItem && !arguments.order.hasErrors()) {
			// Create a new Order Item
			var newOrderItem = this.newOrderItem();
			
			// Set Header Info
			newOrderItem.setOrder( arguments.order );
			if(arguments.processObject.getOrderItemTypeSystemCode() eq "oitSale") {
				newOrderItem.setOrderFulfillment( orderFulfillment );
				newOrderItem.setOrderItemType( getSettingService().getTypeBySystemCode('oitSale') );
			} else if (arguments.processObject.getOrderItemTypeSystemCode() eq "oitReturn") {
				newOrderItem.setOrderReturn( orderReturn );
				newOrderItem.setOrderItemType( getSettingService().getTypeBySystemCode('oitReturn') );
			}
			
			// Setup the Sku / Quantity / Price details
			newOrderItem.setSku( arguments.processObject.getSku() );
			newOrderItem.setCurrencyCode( arguments.order.getCurrencyCode() );
			newOrderItem.setQuantity( arguments.processObject.getQuantity() );
			newOrderItem.setPrice( arguments.processObject.getPrice() );
			newOrderItem.setSkuPrice( arguments.processObject.getSku().getPriceByCurrencyCode( newOrderItem.getCurrencyCode() ) );
			
			// If a stock was passed in assign it to this new item
			if( !isNull(arguments.processObject.getStock()) ) {
				newOrderItem.setStock( arguments.processObject.getStock() );
			}
			
			// Set any customizations
			newOrderItem.populate( arguments.data );
			
			// Calculate any additional charges based on associated order items
			var additionalCharge = 0;
			var chargesAdded = "";
			for(var i=1; i<=arrayLen(newOrderItem.getAttributeValues()); i++) {
				var thisAttribute = newOrderItem.getAttributeValues()[i];
				if(thisAttribute.getAttributeValue() != "" AND thisAttribute.getAttributeValue() != 'None' AND NOT ListFind(chargesAdded, thisAttribute.getAttribute().getAttributeCode())){
					chargesAdded = ListAppend(chargesAdded, thisAttribute.getAttribute().getAttributeCode());
					additionalCharge += Val(thisAttribute.getAttribute().getAttributeSet().getAdditionalCharge());
				}
			}
			newOrderItem.setPrice(newOrderItem.getPrice() + additionalCharge);

			// Save the new order items
			newOrderItem = this.saveOrderItem( newOrderItem );
			
			if(newOrderItem.hasErrors()) {
				arguments.order.addError('addOrderItem', newOrderItem.getErrors());
			}
		}
		
		// Call save order to place in the hibernate session and re-calculate all of the totals 
		arguments.order = this.saveOrder( arguments.order );
		
		return arguments.order;
	}
	
	public any function processOrder_addOrderPayment(required any order, required any processObject) {
		
		// Get the populated newOrderPayment out of the processObject
		var newOrderPayment = processObject.getNewOrderPayment();
		
		// If this is an existing account payment method, then we can pull the data from there
		if( len(arguments.processObject.getAccountPaymentMethodID()) ) {
			
			// Setup the newOrderPayment from the existing payment method
			var accountPaymentMethod = getAccountService().getAccountPaymentMethod( arguments.processObject.getAccountPaymentMethodID() );
			newOrderPayment.copyFromAccountPaymentMethod( accountPaymentMethod );
			
		// If they just used an exiting account address then we can try that by itself
		} else if(!isNull(arguments.processObject.getAccountAddressID()) && len(arguments.processObject.getAccountAddressID())) {
			var accountAddress = getAccountService().getAccountAddress( arguments.processObject.getAccountAddressID() );
			
			if(!isNull(accountAddress)) {
				newOrderPayment.setBillingAddress( accountAddress.getAddress().copyAddress( true ) );
			}
		}
		
		// Make sure that the payment gets attached to the order 
		if(isNull(newOrderPayment.getOrder())) {
			newOrderPayment.setOrder( arguments.order );
		}
		
		// Make sure that the currencyCode matches the order
		newOrderPayment.setCurrencyCode( arguments.order.getCurrencyCode() );
		
		// If this was a termPayment
		if(!isNull(newOrderPayment.getPaymentMethod()) && newOrderPayment.getPaymentMethod().getPaymentMethodType() eq 'termPayment' && isNull(newOrderPayment.getTermPaymentAccount())) {
			newOrderPayment.setTermPaymentAccount( arguments.order.getAccount() );
		}
		
		// Save the newOrderPayment
		newOrderPayment = this.saveOrderPayment( newOrderPayment );
		
		// Attach 'createTransaction' errors to the order 
		if(newOrderPayment.hasError('createTransaction')) {
			arguments.order.addError('addOrderPayment', newOrderPayment.getError('createTransaction'), true);
			
		// Otherwise if no errors, and we are supposed to save as accountpayment, and an accountPaymentMethodID doesn't already exist then we can create one.
		} else if (!newOrderPayment.hasErrors() && arguments.processObject.getSaveAccountPaymentMethodFlag() && isNull(newOrderPayment.getAccountPaymentMethod())) {
				
			// Create a new Account Payment Method
			var newAccountPaymentMethod = getAccountService().newAccountPaymentMethod();
			
			// Attach to Account
			newAccountPaymentMethod.setAccount( arguments.order.getAccount() );
			
			// Setup name if exists
			if(!isNull(arguments.processObject.getSaveAccountPaymentMethodName())) {
				newAccountPaymentMethod.setAccountPaymentMethodName( arguments.processObject.getSaveAccountPaymentMethodName() );	
			}
			
			// Copy over details
			newAccountPaymentMethod.copyFromOrderPayment( newOrderPayment );
			
			// Save it
			newAccountPaymentMethod = getAccountService().saveAccountPaymentMethod( newAccountPaymentMethod, {runSaveAccountPaymentMethodTransactionFlag=false} );
			
		}
		
		return arguments.order;
	}
	
	public any function processOrder_addPromotionCode(required any order, required any processObject) {
			
		var pc = getPromotionService().getPromotionCodeByPromotionCode(arguments.processObject.getPromotionCode());
		
		if(isNull(pc) || !pc.getPromotion().getActiveFlag()) {
			arguments.processObject.addError("promotionCode", rbKey('validate.promotionCode.invalid'));
		} else if ( (!isNull(pc.getStartDateTime()) && pc.getStartDateTime() > now()) || (!isNull(pc.getEndDateTime()) && pc.getEndDateTime() < now()) || !pc.getPromotion().getCurrentFlag()) {
			arguments.processObject.addError("promotionCode", rbKey('validate.promotionCode.invaliddatetime'));
		} else if (arrayLen(pc.getAccounts()) && !pc.hasAccount(arguments.order.getAccount())) {
			arguments.processObject.addError("promotionCode", rbKey('validate.promotionCode.invalidaccount'));
		} else if( !isNull(pc.getMaximumAccountUseCount()) && !isNull(arguments.order.getAccount()) && pc.getMaximumAccountUseCount() <= getPromotionService().getPromotionCodeAccountUseCount(pc, arguments.order.getAccount()) ) {
			arguments.processObject.addError("promotionCode", rbKey('validate.promotionCode.overMaximumAccountUseCount'));
		} else if( !isNull(pc.getMaximumUseCount()) && pc.getMaximumUseCount() <= getPromotionService().getPromotionCodeUseCount(pc) ) {
			arguments.processObject.addError("promotionCode", rbKey('validate.promotionCode.overMaximumUseCount'));
		} else {
			if(!arguments.order.hasPromotionCode( pc )) {
				arguments.order.addPromotionCode( pc );
				recalculateOrderAmounts(order=arguments.order);
			}
		}		
		
		return arguments.order;
	}
	
	public any function processOrder_cancelOrder(required any order, struct data={}) {
		
		// Set up the comment if someone typed in the box
		if(structKeyExists(arguments.data, "comment") && len(trim(arguments.data.comment))) {
			var comment = getCommentService().newComment();
			comment = getCommentService().saveComment(comment, arguments.data);
		}
		
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
		for(var orderPayment in arguments.order.getOrderPayments()) {
			
			if(orderPayment.getStatusCode() eq "opstActive") {
				var totalReceived = precisionEvaluate(orderPayment.getAmountReceived() - orderPayment.getAmountCredited());
				if(totalReceived gt 0) {
					var transactionData = {
						amount = totalReceived,
						transactionType = 'credit'
					};
					this.processOrderPayment(orderPayment, transactionData, 'createTransaction');
				}
				
				// Set payment amount to 0
				orderPayment.setAmount(0);
			}
		}
		
		// Change the status
		arguments.order.setOrderStatusType( getSettingService().getTypeBySystemCode("ostCanceled") );
		
		return arguments.order;
	}
	
	public any function processOrder_clear(required any order) {
		
		// Remove the cart from the session
		getHibachiScope().getSession().removeOrder( arguments.order );
		
		var hasPaymentTransaction = false;
		
		// Loop over to make sure there are no payment transactions
		for(var orderPayment in arguments.order.getOrderPayments()) {
			if( arrayLen(orderPayment.getPaymentTransactions()) ) {
				hasPaymentTransaction = true;
				break;
			}
		}
		
		// As long as there is no payment transactions, then we can delete the order
		if( !hasPaymentTransaction ) {
			this.deleteOrder( arguments.order );
			
		// Otherwise we can just remove the account so that it isn't remember as an open cart for this account
		} else if(!isNull(order.getAccount())) {
			
			order.removeAccount();
		}
		
		return this.newOrder();
	}
	
	public any function processOrder_create(required any order, required any processObject, required struct data={}) {
		
		// Setup Account
		if(arguments.processObject.getNewAccountFlag()) {
			var account = getAccountService().processAccount(getAccountService().newAccount(), arguments.data, "create");
		} else {
			var account = getAccountService().getAccount(processObject.getAccountID());
		}
		arguments.order.setAccount(account);
		
		// Setup Order Type
		arguments.order.setOrderType( getSettingService().getType( processObject.getOrderTypeID() ) );
		
		// Setup the Order Origin
		if( len(arguments.processObject.getOrderOriginID()) ) {
			arguments.order.setOrderOrigin( getSettingService().getOrderOrigin(arguments.processObject.getOrderOriginID()) );
		}
		
		// Setup the Currency Code
		arguments.order.setCurrencyCode( arguments.processObject.getCurrencyCode() );
		
		// Save the order
		arguments.order = this.saveOrder(arguments.order);
		
		return arguments.order;
	}
	
	public any function processOrder_createReturn(required any order, required any processObject) {
		
		// Create a new return order
		var returnOrder = this.newOrder();
		returnOrder.setAccount( arguments.order.getAccount() );
		returnOrder.setOrderType( getSettingService().getTypeBySystemCode("otReturnOrder") );
		returnOrder.setCurrencyCode( arguments.order.getCurrencyCode() );
		returnOrder.setReferencedOrder( arguments.order );
		
		// Create OrderReturn entity (to save the fulfillment amount)
		var orderReturn = this.newOrderReturn();
		orderReturn.setOrder( returnOrder );
		orderReturn.setFulfillmentRefundAmount( arguments.processObject.getFulfillmentRefundAmount() );
		orderReturn.setReturnLocation( arguments.processObject.getLocation() );
	
		// Look for that orderItem in the data records
		for(var orderItemStruct in arguments.processObject.getOrderItems()) {
			
			// Verify that there was a quantity and that it was GT 0
			if(isNumeric(orderItemStruct.quantity) && orderItemStruct.quantity gt 0) {
				
				var originalOrderItem = this.getOrderItem( orderItemStruct.referencedOrderItem.orderItemID );
				
				// Create a new return orderItem
				if(!isNull(originalOrderItem)) {
					
					// Create a new order item
					var orderItem = this.newOrderItem();
					
					// Setup the details
					orderItem.setOrderItemType( getSettingService().getTypeBySystemCode('oitReturn') );
					orderItem.setOrderItemStatusType( getSettingService().getTypeBySystemCode('oistNew') );
					orderItem.setPrice( orderItemStruct.price );
					orderItem.setSkuPrice( originalOrderItem.getSku().getPrice() );
					orderItem.setCurrencyCode( originalOrderItem.getSku().getCurrencyCode() );
					orderItem.setQuantity( orderItemStruct.quantity );
					orderItem.setSku( originalOrderItem.getSku() );
					
					// Add needed references
					orderItem.setReferencedOrderItem( originalOrderItem );
					orderItem.setOrderReturn( orderReturn );
					orderItem.setOrder( returnOrder );
					
					// Persist the new item
					getHibachiDAO().save( orderItem );
					
				}
				
			}
		}
		
		// Persit the new order
		getHibachiDAO().save( returnOrder );
		
		// Recalculate the order amounts for tax and promotions
		recalculateOrderAmounts( returnOrder );
		
		// Check to see if we are attaching an referenced orderPayment
		if(len(arguments.processObject.getRefundOrderPaymentID())) {
		
			var originalOrderPayment = this.getOrderPayment( arguments.processObject.getRefundOrderPaymentID() );
			
			if(!isNull(originalOrderPayment)) {
				var returnOrderPayment = this.newOrderPayment();
				returnOrderPayment.copyFromOrderPayment( originalOrderPayment );
				returnOrderPayment.setReferencedOrderPayment( originalOrderPayment );
				returnOrderPayment.setOrder( returnOrder );
				returnOrderPayment.setCurrencyCode( returnOrder.getCurrencyCode() );
				returnOrderPayment.setOrderPaymentType( getSettingService().getType( '444df2f1cc40d0ea8a2de6f542ab4f1d' ) );
				returnOrderPayment.setAmount( returnOrder.getTotal() * -1 );
			}
			
		// Otherwise the order needs to have a new orderPayment created
		} else {
			
			arguments.data.newOrderPayment.order.orderID = returnOrder.getOrderID();
			arguments.data.newOrderPayment.amount = returnOrder.getTotal() * -1;
			arguments.data.newOrderPayment.orderPaymentType.typeID = "444df2f1cc40d0ea8a2de6f542ab4f1d";
			
			returnOrder = this.processOrder(returnOrder, arguments.data, 'addOrderPayment');
			
		}
		
		// If the order doesn't have any errors, then we can flush the ormSession
		if(!returnOrder.hasErrors()) {
			getHibachiDAO().flushORMSession();
			returnOrder = this.processOrder(returnOrder, {}, 'placeOrder');
		}
		
		// If the process object was set to automatically receive these items, then we will do that
		if(!returnOrder.hasErrors() && processObject.getReceiveItemsFlag()) {
			var receiveData = {};
			receiveData.locationID = orderReturn.getReturnLocation().getLocationID();
			receiveData.orderReturnItems = [];
			for(var returnItem in orderReturn.getOrderReturnItems()) {
				var thisData = {};
				thisData.orderReturnItem.orderItemID = returnItem.getOrderItemID();
				thisData.quantity = returnItem.getQuantity();
				arrayAppend(receiveData.orderReturnItems, thisData);
			}
			orderReturn = this.processOrderReturn(orderReturn, receiveData, 'receive');
		}
		
		// Return the new order so that the redirect takes users to this new order
		return returnOrder;
	}
	
	public any function processOrder_placeOrder(required any order, required struct data) {
		// First we need to lock the session so that this order doesn't get placed twice.
		lock scope="session" timeout="60" {
		
			// Reload the order in case it was already in cache
			getHibachiDAO().reloadEntity(arguments.order);
		
			// Make sure that the entity is notPlaced before going any further
			if(arguments.order.getOrderStatusType().getSystemCode() == "ostNotPlaced") {
				
				// Call the saveOrder method so that accounts, fulfillments & payments are updated
				arguments.order = this.saveOrder(arguments.order, arguments.data);
				
				// As long as the order doesn't have any errors after updating fulfillment & payments we can continue
				if(!arguments.order.hasErrors()) {
					
					// If the orderTotal is less than the orderPaymentTotal, then we can look in the data for a "newOrderPayment" record, and if one exists then try to add that orderPayment
					if(arguments.order.getTotal() != arguments.order.getPaymentAmountTotal()) {
						arguments.order = this.processOrder(arguments.order, arguments.data, 'addOrderPayment');
					}
					
					// Generate the order requirements list, to see if we still need action to be taken
					var orderRequirementsList = getOrderRequirementsList( arguments.order );
					
					// Verify the order requirements list, to make sure that this order has everything it needs to continue
					if(len(orderRequirementsList)) {
						
						if(listFindNoCase("account", orderRequirementsList)) {
							arguments.order.addError('account',rbKey('entity.order.process.placeOrder.accountRequirementError'));	
						}
						if(listFindNoCase("fulfillment", orderRequirementsList)) {
							arguments.order.addError('fulfillment',rbKey('entity.order.process.placeOrder.fulfillmentRequirementError'));
						}
						if(listFindNoCase("return", orderRequirementsList)) {
							arguments.order.addError('return',rbKey('entity.order.process.placeOrder.returnRequirementError'));
						}
						if(listFindNoCase("payment", orderRequirementsList)) {
							arguments.order.addError('payment',rbKey('entity.order.process.placeOrder.paymentRequirementError'));
						}
						
					} else {
						
						// Setup a value to log the amount received, credited or authorized.  If any of these exists then we need to place the order
						var amountAuthorizeCreditReceive = 0;
						
						// Process All Payments and Save the ones that were successful
						for(var orderPayment in arguments.order.getOrderPayments()) {
							
							// As long as this orderPayment is active then we can run the place order transaction
							if(orderPayment.getStatusCode() == 'opstActive') {
								
								// Call the placeOrderTransactionType for the order payment
								orderPayment = this.processOrderPayment(orderPayment, {}, 'runPlaceOrderTransaction');
							
								amountAuthorizeCreditReceive = precisionEvaluate(amountAuthorizeCreditReceive + orderPayment.getAmountAuthorized() + orderPayment.getAmountReceived() + orderPayment.getAmountCredited());
							}
						}
						
						// After all of the processing, double check that the order does not have errors.  If one of the payments didn't go through, then an error would have been set on the order.
						if(!arguments.order.hasErrors() || amountAuthorizeCreditReceive gt 0) {
							
							if(arguments.order.hasErrors()) {
								arguments.order.addMessage('paymentProcessedMessage', rbKey('entity.order.process.placeOrder.paymentProcessedMessage'));
							}
							
							// Clear this order out of all sessions
							getOrderDAO().removeOrderFromAllSessions(orderID=arguments.order.getOrderID());
							
							if(!isNull(getHibachiScope().getSession().getOrder()) && arguments.order.getOrderID() == getHibachiScope().getSession().getOrder().getOrderID()) {
								getHibachiScope().getSession().setOrder(javaCast("null", ""));
							}
						
							// Update the order status
							order.setOrderStatusType( getSettingService().getTypeBySystemCode("ostNew") );
							
							// Update the orderPlaced
							order.confirmOrderNumberOpenDateCloseDatePaymentAmount();
						
							// Save the order to the database
							getHibachiDAO().save( arguments.order );
						
							// Do a flush so that the order is commited to the DB
							getHibachiDAO().flushORMSession();
						
							// Log that the order was placed
							logHibachi(message="New Order Processed - Order Number: #order.getOrderNumber()# - Order ID: #order.getOrderID()#", generalLog=true);
							
							// Look for 'auto' order fulfillments
							for(var i=1; i<=arrayLen( arguments.order.getOrderFulfillments() ); i++) {
								
								// As long as the amount received for this orderFulfillment is within the treshold of the auto fulfillment setting
								if(arguments.order.getOrderFulfillments()[i].getFulfillmentMethodType() == "auto" && (order.getTotal() == 0 || order.getOrderFulfillments()[i].getFulfillmentMethod().setting('fulfillmentMethodAutoMinReceivedPercentage') <= (order.getPaymentAmountReceivedTotal()*100/order.getTotal())) ) {
									
									var newOrderDelivery = this.newOrderDelivery();
									
									// Setup the processData
									var processData = {};
									processData.order = {};
									processData.order.orderID = arguments.order.getOrderID();
									processData.location.locationID = arguments.order.getOrderFulfillments()[i].getFulfillmentMethod().setting('fulfillmentMethodAutoLocation');
									processData.orderFulfillment.orderFulfillmentID = arguments.order.getOrderFulfillments()[i].getOrderFulfillmentID();
									
									newOrderDelivery = this.processOrderDelivery(newOrderDelivery, processData, 'create');
								}
							}
						}
					}
					
				}
			}
			
		}	// END OF LOCK
		
		return arguments.order;
	}
	
	public any function processOrder_placeOnHold(required any order, struct data={}) {
		
		// Set up the comment if someone typed in the box
		if(structKeyExists(arguments.data, "comment") && len(trim(arguments.data.comment))) {
			var comment = getCommentService().newComment();
			comment = getCommentService().saveComment(comment, arguments.data);
		}
		
		// Change the status
		arguments.order.setOrderStatusType( getSettingService().getTypeBySystemCode("ostOnHold") );
		
		return arguments.order;
	}
	
	public any function processOrder_removeOrderItem(required any order, required struct data) {
		
		// Make sure that an orderItemID was passed in
		if(structKeyExists(arguments.data, "orderItemID")) {
			
			// Loop over all of the items in this order
			for(var i = 1; i <= arrayLen(arguments.order.getOrderItems()); i++)	{
			
				// Check to see if this item is the same ID as the one passed in to remove
				if(arguments.order.getOrderItems()[i].getOrderItemID() == arguments.data.orderItemID) {
				
					// Actually Remove that Item
					arguments.order.removeOrderItem( arguments.order.getOrderItems()[i] );
					break;
				}
			}
			
		}
		
		// Call saveOrder to recalculate all the orderTotal stuff
		arguments.order = this.saveOrder(arguments.order);
		
		return arguments.order;
	}
	
	public any function processOrder_removeOrderPayment(required any order, required struct data) {
		// Make sure that an orderItemID was passed in
		if(structKeyExists(arguments.data, "orderPaymentID")) {
			
			// Loop over all of the items in this order
			for(var orderPayment in arguments.order.getOrderPayments())	{
			
				// Check to see if this item is the same ID as the one passed in to remove
				if(orderPayment.getOrderPaymentID() == arguments.data.orderPaymentID) {
				
					if(orderPayment.isDeletable()) {
						arguments.order.removeOrderPayment( orderPayment );
						this.deleteOrderPayment( orderPayment );
					} else {
						orderPayment.setOrderPaymentStatusType( getSettingService().getTypeBySystemCode('opstRemoved') );
					}
					
					break;
				}
			}
			
		}
		
		return arguments.order;
	}
	
	public any function processOrder_removePromotionCode(required any order, required struct data) {
		
		if(structKeyExists(arguments.data, "promotionCodeID")) {
			var promotionCode = getPromotionService().getPromotionCode( arguments.data.promotionCodeID );
		} else if (structKeyExists(arguments.data, "promotionCode")) {
			var promotionCode = getPromotionService().getPromotionCodeByPromotionCode( arguments.data.promotionCode );	
		}
		
		if(!isNull(promotionCode)) {
			arguments.order.removePromotionCode( promotionCode );
		}
		
		// Call saveOrder to recalculate all the orderTotal stuff
		arguments.order = this.saveOrder(arguments.order);
		
		return arguments.order;
	}
	
	public any function processOrder_takeOffHold(required any order, struct data={}) {
		
		// Set up the comment if someone typed in the box
		if(structKeyExists(arguments.data, "comment") && len(trim(arguments.data.comment))) {
			var comment = getCommentService().newComment();
			comment = getCommentService().saveComment(comment, arguments.data);
		}
		
		// Change the status
		arguments.order.setOrderStatusType( getSettingService().getTypeBySystemCode("ostProcessing") );
		
		// Call the update order status incase this needs to be changed to closed.
		arguments.order = this.processOrder(arguments.order, {}, 'updateStatus');

		return arguments.order;
	}
	
	public any function processOrder_updateStatus(required any order, struct data) {
		param name="arguments.data.updateItems" default="false";
		
		// First we make sure that this order status is not 'closed', 'canceld', 'notPlaced' or 'onHold' because we cannot automatically update those statuses
		if(!listFindNoCase("ostNotPlaced,ostOnHold,ostClosed,ostCanceled", arguments.order.getOrderStatusType().getSystemCode())) {
			
			// We can check to see if all the items have been delivered and the payments have all been received then we can close this order
			if(precisionEvaluate(arguments.order.getPaymentAmountReceivedTotal() - arguments.order.getPaymentAmountCreditedTotal()) == arguments.order.getTotal() && arguments.order.getQuantityUndelivered() == 0 && arguments.order.getQuantityUnreceived() == 0)	{
				arguments.order.setOrderStatusType(  getSettingService().getTypeBySystemCode("ostClosed") );
				
			// The default case is just to set it to processing
			} else {
				arguments.order.setOrderStatusType(  getSettingService().getTypeBySystemCode("ostProcessing") );
			}
			
		}
		
		// If we are supposed to update the items as well, loop over all items and pass to 'updateItemStatus'
		if(arguments.data.updateItems) {
			for(var orderItem in arguments.order.getOrderItems()) {
				this.processOrderItem( orderItem, {}, 'updateStatus');
			}
		}
		
		return arguments.order;
	}
	
	// Process: Order Delivery
	public any function processOrderDelivery_create(required any orderDelivery, required any processObject, struct data={}) {
		
		var amountToBeCaptured = 0;
		
		// If we need to capture payments first, then we do that to make sure the rest of the delivery can take place
		if(arguments.processObject.getCaptureAuthorizedPaymentsFlag()) {
			var amountToBeCaptured = arguments.processObject.getCapturableAmount();
			
			for(var orderPayment in arguments.processObject.getOrder().getOrderPayments()) {
				
				if(orderPayment.getStatusCode() == 'opstActive') {
					if(orderPayment.getPaymentMethod().getPaymentMethodType() eq "creditCard" && orderPayment.getAmountUnreceived() gt 0 && amountToBeCaptured gt 0) {
						var transactionData = {
							transactionType = 'chargePreAuthorization',
							amount = amountToBeCaptured
						};
						
						if(transactionData.amount gt orderPayment.getAmountUnreceived()) {
							transactionData.amount = orderPayment.getAmountUnreceived();
						}
						
						orderPayment = this.processOrderPayment(orderPayment, transactionData, 'createTransaction');
						
						if(!orderPayment.hasErrors()) {
							amountToBeCaptured = precisionEvaluate(amountToBeCaptured - transactionData.amount);
						}
					}
				}
			}
		}
		
		// As long as the amount to be captured is eq 0 then we can continue making the order delivery
		if(amountToBeCaptured eq 0) {
			
			// Setup the header information
			arguments.orderDelivery.setOrder( arguments.processObject.getOrder() );
			arguments.orderDelivery.setLocation( arguments.processObject.getLocation() );
			arguments.orderDelivery.setFulfillmentMethod( arguments.processObject.getOrderFulfillment().getFulfillmentMethod() );
			
			// If this is a shipping fulfillment, then populate the correct values
			if(arguments.orderDelivery.getFulfillmentMethod().getFulfillmentMethodType() eq "shipping") {
				arguments.orderDelivery.setShippingMethod( arguments.processObject.getShippingMethod() );
				arguments.orderDelivery.setShippingAddress( arguments.processObject.getShippingAddress().copyAddress( saveNewAddress=true ) );
			}
			
			// Setup the tracking number
			if(!isNull(arguments.processObject.getTrackingNumber()) && len(arguments.processObject.getTrackingNumber())) {
				arguments.orderDelivery.setTrackingNumber(arguments.processObject.getTrackingNumber());
			}
			
			// If the orderFulfillmentMethod is auto, and there aren't any delivery items then we can just fulfill all that are "undelivered"
			if(arguments.orderDelivery.getFulfillmentMethod().getFulfillmentMethodType() eq "auto" && !arrayLen(arguments.processObject.getOrderDeliveryItems())) {
				
				// Loop over delivery items from processObject and add them with stock to the orderDelivery
				for(var i=1; i<=arrayLen(arguments.processObject.getOrderFulfillment().getOrderFulfillmentItems()); i++) {
					
					// Local pointer to the orderItem
					var thisOrderItem = arguments.processObject.getOrderFulfillment().getOrderFulfillmentItems()[i];
					
					if(thisOrderItem.getQuantityUndelivered()) {
						// Create a new orderDeliveryItem
						var orderDeliveryItem = this.newOrderDeliveryItem();
						
						// Populate with the data
						orderDeliveryItem.setOrderItem( thisOrderItem );
						orderDeliveryItem.setQuantity( thisOrderItem.getQuantityUndelivered() );
						orderDeliveryItem.setStock( getStockService().getStockBySkuAndLocation(sku=orderDeliveryItem.getOrderItem().getSku(), location=arguments.orderDelivery.getLocation()));
						orderDeliveryItem.setOrderDelivery( arguments.orderDelivery );	
					}
					
				}
			} else {
				// Loop over delivery items from processObject and add them with stock to the orderDelivery
				for(var i=1; i<=arrayLen(arguments.processObject.getOrderDeliveryItems()); i++) {
					
					// Create a new orderDeliveryItem
					var orderDeliveryItem = this.newOrderDeliveryItem();
					
					// Populate with the data
					orderDeliveryItem.populate( arguments.processObject.getOrderDeliveryItems()[i] );
					orderDeliveryItem.setStock( getStockService().getStockBySkuAndLocation(sku=orderDeliveryItem.getOrderItem().getSku(), location=arguments.orderDelivery.getLocation()));
					orderDeliveryItem.setOrderDelivery( arguments.orderDelivery );
				}	
			}
			
			// Loop over the orderDeliveryItems to setup subscriptions and contentAccess
			for(var di=1; di<=arrayLen(arguments.orderDelivery.getOrderDeliveryItems()); di++) {
				
				var orderDeliveryItem = arguments.orderDelivery.getOrderDeliveryItems()[di];
				
				// If the sku has a subscriptionTerm, then we can process the item to setupSubscription
				if(!isNull(orderDeliveryItem.getOrderItem().getSku().getSubscriptionTerm())) {
					orderDeliveryItem = this.processOrderDeliveryItem(orderDeliveryItem, {}, 'setupSubscription');
				}
				
				// If there are accessContents associated with this sku, then we can setupContentAccess
				if(arrayLen(orderDeliveryItem.getOrderItem().getSku().getAccessContents())) {
					orderDeliveryItem = this.processOrderDeliveryItem(orderDeliveryItem, {}, 'setupContentAccess');
				}

			}
			
			// Save the orderDelivery
			arguments.orderDelivery = this.saveOrderDelivery(arguments.orderDelivery);
			
			// Update the orderStatus
			this.processOrder(arguments.orderDelivery.getOrder(), {updateItems=true}, 'updateStatus');
			
		} else {
			arguments.processObject.addError('capturableAmount', rbKey('validate.processOrderDelivery_create.captureAmount'));
		}
		
		return arguments.orderDelivery;
	}
	
	// Process: Order Delivery Item
	public any function processOrderDeliveryItem_setupSubscription(required any orderDeliveryItem) {
		
		// check if orderItem is assigned to a subscriptionOrderItem
		var subscriptionOrderItem = getSubscriptionService().getSubscriptionOrderItem({orderItem=arguments.orderDeliveryItem.getOrderItem()});
		
		// If we couldn't fine the subscriptionOrderItem, then setup a new one
		if(isNull(subscriptionOrderItem)) {
			
			// new orderItem, setup subscription
			getSubscriptionService().setupInitialSubscriptionOrderItem( arguments.orderDeliveryItem.getOrderItem() );
			
		} else {
			
			// orderItem already exists in subscription, just setup access and expiration date
			if(isNull(subscriptionOrderItem.getSubscriptionUsage().getExpirationDate())) {
				var startDate = now();
			} else {
				var startDate = subscriptionOrderItem.getSubscriptionUsage().getExpirationDate();
			}
			
			subscriptionOrderItem.getSubscriptionUsage().setExpirationDate( subscriptionOrderItem.getSubscriptionUsage().getRenewalTerm().getEndDate(startDate) );
			
			getSubscriptionService().processSubscriptionUsage( subscriptionOrderItem.getSubscriptionUsage(), {}, 'updateStatus' );
			
			// set renewal benefit if needed
			getSubscriptionService().setupRenewalSubscriptionBenefitAccess( subscriptionOrderItem.getSubscriptionUsage() );
		}
		
		return arguments.orderDeliveryItem;
	}
	
	public any function processOrderDeliveryItem_setupContentAccess(required any orderDeliveryItem) {
		
		for(var accessContent in arguments.orderDeliveryItem.getOrderItem().getSku().getAccessContents()) {
			
			// Setup the new accountContentAccess
			var accountContentAccess = getAccountService().newAccountContentAccess();
			accountContentAccess.setAccount( arguments.orderDeliveryItem.getOrderItem().getOrder().getAccount() );
			accountContentAccess.setOrderItem( arguments.orderDeliveryItem.getOrderItem() );
			accountContentAccess.addAccessContent( accessContent );
			
			// Place new accessContent into hibernate session
			accountContentAccess = getAccountService().saveAccountContentAccess( accountContentAccess );
			
		}
		
		return arguments.orderDeliveryItem;
	}
	
	// Process: Order Fulfillment
	public any function processOrderFulfillment_manualFulfillmentCharge(required any orderFulfillment, struct data={}) {
		
		arguments.orderFulfillment.setManualFulfillmentChargeFlag( true );
		arguments.orderFulfillment = this.saveOrderFulfillment(arguments.orderFulfillment, arguments.data);
		
		if(arguments.orderFulfillment.hasErrors()) {
			arguments.orderFulfillment.setManualFulfillmentChargeFlag( false );
		}
		
		return arguments.orderFulfillment;
	}
	
	// Process: Order Item
	public any function processOrderItem_updateStatus(required any orderItem) {
		// First we make sure that this order item is not already fully fulfilled, or onHold because we cannont automatically update those statuses
		if(!listFindNoCase("oistFulfilled,oistOnHold",arguments.orderItem.getOrderItemStatusType().getSystemCode())) {
			
			// If the quantityUndelivered is set to 0 then we can mark this as fulfilled
			if(arguments.orderItem.getQuantityUndelivered() == 0) {
				arguments.orderItem.setOrderItemStatusType(  getSettingService().getTypeBySystemCode("oistFulfilled") );
				
			// If the sku is setup to track inventory and the qoh is 0 then we can set the status to 'backordered'
			} else if(arguments.orderItem.getSku().setting('skuTrackInventoryFlag') && arguments.orderItem.getSku().getQuantity('qoh') == 0) {
				arguments.orderItem.setOrderItemStatusType(  getSettingService().getTypeBySystemCode("oistBackordered") );
					
			// Otherwise we just set this to 'processing' to show that the item is in limbo
			} else {
				arguments.orderItem.setOrderItemStatusType(  getSettingService().getTypeBySystemCode("oistProcessing") );
				
			}
		}
		
		return arguments.orderItem;
	}
		
	// Process: Order Return
	public any function processOrderReturn_receive(required any orderReturn, required any processObject) {
		
		var stockReceiver = getStockService().newStockReceiver();
		stockReceiver.setReceiverType( "order" );
		stockReceiver.setOrder( arguments.orderReturn.getOrder() );
		
		if(!isNull(processObject.getPackingSlipNumber())) {
			stockReceiver.setPackingSlipNumber( processObject.getPackingSlipNumber() );
		}
		if(!isNull(processObject.getBoxCount())) {
			stockReceiver.setBoxCount( processObject.getBoxCount() );
		}
		
		var location = getLocationService().getLocation( arguments.processObject.getLocationID() );
		
		for(var thisRecord in arguments.data.orderReturnItems) {
			
			if(val(thisRecord.quantity) gt 0) {
				
				var orderReturnItem = this.getOrderItem( thisRecord.orderReturnItem.orderItemID );
				
				if(!isNull(orderReturnItem)) {
					var stock = getStockService().getStockBySkuAndLocation( orderReturnItem.getSku(), location );
				
					var stockReceiverItem = getStockService().newStockReceiverItem();
				
					stockreceiverItem.setQuantity( thisRecord.quantity );
					stockreceiverItem.setStock( stock );
					stockreceiverItem.setOrderItem( orderReturnItem );
					stockreceiverItem.setStockReceiver( stockReceiver );
				}
				
			}
		}
		
		getStockService().saveStockReceiver( stockReceiver );
		
		// Update the orderStatus
		this.processOrder(arguments.orderReturn.getOrder(), {updateItems=true}, 'updateStatus');
		
		return arguments.orderReturn;
	}
	
	// Process: Order Payment
	public any function processOrderPayment_createTransaction(required any orderPayment, required any processObject) {
		
		var uncapturedAuthorizations = getPaymentService().getUncapturedPreAuthorizations( arguments.orderPayment );
		
		// If we are trying to charge multiple pre-authorizations at once we may need to run multiple transacitons
		if(arguments.processObject.getTransactionType() eq "chargePreAuthorization" && arrayLen(uncapturedAuthorizations) gt 1 && arguments.processObject.getAmount() gt uncapturedAuthorizations[1].chargeableAmount) {
			var totalAmountCharged = 0;
			
			for(var a=1; a<=arrayLen(uncapturedAuthorizations); a++) {
				
				var thisToCharge = precisionEvaluate(arguments.processObject.getAmount() - totalAmountCharged);
				
				if(thisToCharge gt uncapturedAuthorizations[a].chargeableAmount) {
					thisToCharge = uncapturedAuthorizations[a].chargeableAmount;
				}
				
				// Create a new payment transaction
				var paymentTransaction = getPaymentService().newPaymentTransaction();
				
				// Setup the orderPayment in the transaction to be used by the 'runTransaction'
				paymentTransaction.setOrderPayment( arguments.orderPayment );
				
				// Setup the transaction data
				transactionData = {
					transactionType = arguments.processObject.getTransactionType(),
					amount = thisToCharge,
					preAuthorizationCode = uncapturedAuthorizations[a].authorizationCode,
					preAuthorizationProviderTransactionID = uncapturedAuthorizations[a].providerTransactionID
				};
				
				// Run the transaction
				paymentTransaction = getPaymentService().processPaymentTransaction(paymentTransaction, transactionData, 'runTransaction');
				
				// If the paymentTransaction has errors, then add those errors to the orderPayment itself
				if(paymentTransaction.hasError('runTransaction')) {
					arguments.orderPayment.addError('createTransaction', paymentTransaction.getError('runTransaction'), true);
				} else {
					precisionEvaluate(totalAmountCharged + paymentTransaction.getAmountReceived());
				}
				
			}
		} else {
			// Create a new payment transaction
			var paymentTransaction = getPaymentService().newPaymentTransaction();
			
			// Setup the orderPayment in the transaction to be used by the 'runTransaction'
			paymentTransaction.setOrderPayment( arguments.orderPayment );
			
			// Setup the transaction data
			transactionData = {
				transactionType = arguments.processObject.getTransactionType(),
				amount = arguments.processObject.getAmount()
			};
			
			if(arguments.processObject.getTransactionType() eq "chargePreAuthorization" && arrayLen(uncapturedAuthorizations)) {
				transactionData.preAuthorizationCode = uncapturedAuthorizations[1].authorizationCode;
				transactionData.preAuthorizationProviderTransactionID = uncapturedAuthorizations[1].providerTransactionID;
			}
			
			// Run the transaction
			paymentTransaction = getPaymentService().processPaymentTransaction(paymentTransaction, transactionData, 'runTransaction');
			
			// If the paymentTransaction has errors, then add those errors to the orderPayment itself
			if(paymentTransaction.hasError('runTransaction')) {
				arguments.orderPayment.addError('createTransaction', paymentTransaction.getError('runTransaction'), true);
			}
		}
			
		// If this order payment has errors & has never had and amount Authorized, Received or Credited... then we can set it as invalid
		if(arguments.orderPayment.hasErrors() && arguments.orderPayment.getAmountAuthorized() == 0 && arguments.orderPayment.getAmountReceived() == 0 && arguments.orderPayment.getAmountCredited() == 0 ) {
			arguments.orderPayment.setOrderPaymentStatusType( getSettingService().getTypeBySystemCode('opstInvalid') );
		} else {
			arguments.orderPayment.setOrderPaymentStatusType( getSettingService().getTypeBySystemCode('opstActive') );
		}
		
		// Flush the statusType for the orderPayment
		getHibachiDAO().flushORMSession();
		
		// If no errors, attempt To Update The Order Status
		if(!arguments.orderPayment.hasErrors()) {
			this.processOrder(arguments.orderPayment.getOrder(), {}, 'updateStatus');	
		}
		
		return arguments.orderPayment;
		
	}
		
	public any function processOrderPayment_runPlaceOrderTransaction(required any orderPayment) {
						
		var transactionType = "";
		
		if(!isNull(arguments.orderPayment.getPaymentMethod().getPlaceOrderChargeTransactionType()) && orderPayment.getOrderPaymentType().getSystemCode() eq "optCharge") {
			var transactionType = arguments.orderPayment.getPaymentMethod().getPlaceOrderChargeTransactionType();
		}
		if(!isNull(arguments.orderPayment.getPaymentMethod().getPlaceOrderCreditTransactionType()) && orderPayment.getOrderPaymentType().getSystemCode() eq "optCredit") {
			var transactionType = arguments.orderPayment.getPaymentMethod().getPlaceOrderCreditTransactionType();
		}
		
		if(transactionType != '' && transactionType != 'none' && arguments.orderPayment.getAmount() > 0) {
			
			// Setup payment processing info
			var processData = {
				transactionType = transactionType,
				amount = arguments.orderPayment.getAmount()
			};
			
			// Clear out any previous 'createTransaction' process objects
			arguments.orderPayment.clearProcessObject( 'createTransaction' );
			
			// Call the processing method
			arguments.orderPayment = this.processOrderPayment(arguments.orderPayment, processData, 'createTransaction');
			
			// If there was expected authorize, receive, or credit
			if( 
				arguments.orderPayment.hasErrors()
					|| 
				(listFindNoCase("authorize", processData.transactionType) && arguments.orderPayment.getAmountAuthorized() lt arguments.orderPayment.getAmount())
					||
				(listFindNoCase("authorizeAndCharge,receive", processData.transactionType) && arguments.orderPayment.getAmountReceived() lt arguments.orderPayment.getAmount())
					||
				(listFindNoCase("credit", processData.transactionType) && arguments.orderPayment.getAmountCredited() lt arguments.orderPayment.getAmount())
			) {
				
				// Add a generic payment processing error and make it persistable
				arguments.orderPayment.getOrder().addError('runPlaceOrderTransaction', rbKey('entity.order.process.placeOrder.paymentProcessingError'), true);
				
				// Add the actual message
				if(arguments.orderPayment.hasError('createTransaction')) {
					arguments.orderPayment.getOrder().addError('runPlaceOrderTransaction', arguments.orderPayment.getError('createTransaction'), true);	
				}
				
			}
			
		}
		
		return arguments.orderPayment;
	}
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	public any function saveOrder(required any order, struct data={}, string context="save") {
	
		// Call the generic save method to populate and validate
		arguments.order = save(entity=arguments.order, data=arguments.data, context=arguments.context);
	
		// If the order has no errors & it has not been placed yet, then we can make necessary implicit updates
		if(!arguments.order.hasErrors() && arguments.order.getStatusCode() == "ostNotPlaced") {
			
			// loop over the orderItems to remove any that have a qty of 0
			for(var i = arrayLen(arguments.order.getOrderItems()); i >= 1; i--) {
				if(arguments.order.getOrderItems()[i].getQuantity() < 1) {
					arguments.order.removeOrderItem(arguments.order.getOrderItems()[i]);
				}
			}
			
			// loop over any fulfillments and update the shippingMethodOptions for any shipping fulfillments
			for(var orderFulfillment in arguments.order.getOrderFulfillments()) {
				
				if(orderFulfillment.getFulfillmentMethodType() eq "shipping") {
					
					// Update the shipping methods
					getShippingService().updateOrderFulfillmentShippingMethodOptions( orderFulfillment );
					
					// Save the accountAddress if needed
					orderFulfillment.checkNewAccountAddressSave();
				}
				
			}
			
			// Loop over any orderPayments that were just populated, and may have previously been marked as invalid.  This is specifically used for the legacy checkouts on repeated attempts
			if(!isNull(arguments.order.getPopulatedSubProperties()) && structKeyExists(arguments.order.getPopulatedSubProperties(), "orderPayments")) {
				for(var orderPayment in arguments.order.getPopulatedSubProperties().orderPayments) {
					if(!orderPayment.hasErrors()) {
						orderPayment.setOrderPaymentStatusType( getSettingService().getTypeBySystemCode('opstActive') );
					}
				}
			}
			
			// Recalculate the order amounts for tax and promotions
			recalculateOrderAmounts(arguments.order);
			
			// Make sure the auto-state stuff gets called.
			arguments.order.confirmOrderNumberOpenDateCloseDatePaymentAmount();
		}
		
		return arguments.order;
	}
	
	public any function saveOrderFulfillment(required any orderFulfillment, struct data={}, string context="save") {
		
		// Call the generic save method to populate and validate
		arguments.orderFulfillment = save(arguments.orderFulfillment, arguments.data, arguments.context);
		
		// If there were no errors, and the order is not placed, then we can make necessary implicit updates
		if(!arguments.orderFulfillment.hasErrors() && arguments.orderFulfillment.getOrder().getStatusCode() == "ostNotPlaced") {
			
			// If this is a shipping fulfillment, then update the shippingMethodOptions and charge
			if(arguments.orderFulfillment.getFulfillmentMethodType() eq "shipping") {
				
				// Update the shipping Methods
				getShippingService().updateOrderFulfillmentShippingMethodOptions( arguments.orderFulfillment );
				
				// Save the accountAddress if needed
				arguments.orderFulfillment.checkNewAccountAddressSave();
			}
			
			// Recalculate the order amounts for tax and promotions
			recalculateOrderAmounts( arguments.orderFulfillment.getOrder() );
			
		}
		
		return arguments.orderFulfillment;
	}
	
	public any function saveOrderItem(required any orderItem, struct data={}, string context="save") {
		
		// Call the generic save method to populate and validate
		arguments.orderItem = save(arguments.orderItem, arguments.data, arguments.context);
		
		// If there were no errors, and the order is not placed, then we can make necessary implicit updates
		if(!arguments.orderItem.hasErrors() && arguments.orderItem.getOrder().getStatusCode() == "ostNotPlaced") {
			
			// If this item was part of a shipping fulfillment then update that fulfillment
			if(!isNull(arguments.orderItem.getOrderFulfillment()) && arguments.orderItem.getOrderFulfillment().getFulfillmentMethodType() eq "shipping" && !isNull(arguments.orderItem.getOrderFulfillment().getShippingMethod())) {
				getShippingService().updateOrderFulfillmentShippingMethodOptions( arguments.orderItem.getOrderFulfillment() );
			}
			
			// Recalculate the order amounts for tax and promotions
			recalculateOrderAmounts( arguments.orderItem.getOrder() );
		}
		
		return arguments.orderItem;
	}
	
	public any function saveOrderPayment(required any orderPayment, struct data={}, string context="save") {
		
		// Call the generic save method to populate and validate
		arguments.orderPayment = save(arguments.orderPayment, arguments.data, arguments.context);
		
		// If the orderPayment doesn't have any errors, then we can update the status to active.  If later a transaction runs, then this payment may get flagged back in inactive in the same request
		if(!arguments.orderPayment.hasErrors()) {
			arguments.orderPayment.setOrderPaymentStatusType( getSettingService().getTypeBySystemCode('opstActive') );
		}
		
		// If the order payment does not have errors, then we can check the payment method for a saveTransaction
		if(!arguments.orderPayment.getSucessfulPaymentTransactionExistsFlag() && !arguments.orderPayment.hasErrors() && isNull(arguments.orderPayment.getAccountPaymentMethod()) && !isNull(arguments.orderPayment.getPaymentMethod().getSaveOrderPaymentTransactionType()) && len(arguments.orderPayment.getPaymentMethod().getSaveOrderPaymentTransactionType()) && arguments.orderPayment.getPaymentMethod().getSaveOrderPaymentTransactionType() neq "none") {
			
			// Setup the transaction data
			var transactionData = {
				amount = arguments.orderPayment.getAmount(),
				transactionType = arguments.orderPayment.getPaymentMethod().getSaveOrderPaymentTransactionType()
			};
			
			// Clear out any previous 'createTransaction' process objects
			arguments.orderPayment.clearProcessObject( 'createTransaction' );
			
			arguments.orderPayment = this.processOrderPayment(arguments.orderPayment, transactionData, 'createTransaction');
			
		}
		
		return arguments.orderPayment;
		
	}
	
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	public any function getOrderSmartList(struct data={}) {
		arguments.entityName = "SlatwallOrder";
	
		var smartList = getHibachiDAO().getSmartList(argumentCollection=arguments);
		
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
	
	public any function getOrderItemSmartList( struct data={} ) {
		arguments.entityName = "SlatwallOrderItem";
	
		var smartList = getHibachiDAO().getSmartList(argumentCollection=arguments);
		
		smartList.joinRelatedProperty("SlatwallOrderItem", "order", "inner", true);
		smartList.joinRelatedProperty("SlatwallOrderItem", "orderItemType", "inner", true);
		smartList.joinRelatedProperty("SlatwallOrderItem", "orderItemStatusType", "inner", true);
		smartList.joinRelatedProperty("SlatwallOrder", "orderOrigin", "left");
		smartList.joinRelatedProperty("SlatwallOrder", "account", "left");
		smartList.joinRelatedProperty("SlatwallAccount", "primaryEmailAddress", "left");
		smartList.joinRelatedProperty("SlatwallAccount", "primaryPhoneNumber", "left");
		
		smartList.addKeywordProperty(propertyIdentifier="order.orderNumber", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="order.account.firstName", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="order.account.lastName", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="order.account.company", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="order.account.primaryEmailAddress.emailAddress", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="order.account.primaryPhoneNumber.phoneNumber", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="order.orderOrigin.orderOriginName", weight=1);
		
		return smartList;
	}
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
	
	// ===================== START: Delete Overrides ==========================
	
	public any function deleteOrder( required any order ) {
		
		// Check delete validation
		if(arguments.order.isDeletable()) {
			
			// If the order is the order in this session, then set this sessions order to null
			if(arguments.order.getOrderID() eq getHibachiScope().getSession().getOrder().getOrderID()) {
				getHibachiScope().getSession().setOrder( javaCast("null", "") );
			}
			
			getOrderDAO().removeOrderFromAllSessions( orderID=arguments.order.getOrderID() );
			
			return delete( arguments.order );
		}
		
		return delete( arguments.order );
	}
	
	public any function deleteOrderItem( required any orderItem ) {
		
		// Check delete validation
		if(arguments.orderItem.isDeletable()) {
			
			// Remove the primary fields so that we can delete this entity
			var order = arguments.orderItem.getOrder();
			
			order.removeOrderItem( arguments.orderItem );
			
			if(!isNull(arguments.orderItem.getOrderFulfillment())) {
				arguments.orderItem.removeOrderFulfillment();
			}
			if(!isNull(arguments.orderItem.getOrderReturn())) {
				arguments.orderItem.removeOrderReturn();	
			}
			
			// Recalculate the order amounts
			recalculateOrderAmounts( order );
			
			// Actually delete the entity
			getHibachiDAO().delete( arguments.orderItem );
			
			return true;
		}
		
		return delete( arguments.orderItem );
	}
	
	// =====================  END: Delete Overrides ===========================
	
}
