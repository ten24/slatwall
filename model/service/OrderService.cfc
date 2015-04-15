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
	property name="eventRegistrationService";
	property name="fulfillmentService";
	property name="hibachiUtilityService";
	property name="locationService";
	property name="paymentService";
	property name="priceGroupService";
	property name="promotionService";
	property name="settingService";
	property name="shippingService";
	property name="skuService";
	property name="stockService";
	property name="subscriptionService";
	property name="taxService";
	property name="typeService";
	
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
	
	
	public any function duplicateOrderWithNewAccount(required any originalOrder, required any newAccount) {
		
		var data = {
				saveNewFlag=true,
				copyPersonalDataFlag=false,
				referencedOrderFlag=false
			};
			
		var newOrder = this.processOrder(arguments.originalOrder,data,"duplicateOrder" );
		
		// Update Account
		newOrder.setAccount( arguments.newAccount );
		
		// Update any errors from the previous account to the new account
		newOrder.getAccount().setHibachiErrors( originalOrder.getAccount().getHibachiErrors() );
		
		this.saveOrder( newOrder );
		
		return newOrder;
	}
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	public any function getMostRecentNotPlacedOrderByAccountID(required any accountID) {
		return getOrderDAO().getMostRecentNotPlacedOrderByAccountID(argumentcollection=arguments);
	}
	
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
	
	public numeric function getOrderItemDBQuantity(required any orderItemID) {
		return getOrderDAO().getOrderItemDBQuantity(argumentcollection=arguments);
	}
		
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	// Process: Order
	public any function processOrder_addOrderItem(required any order, required any processObject) {
		
		// Setup a boolean to see if we were able to just add this order item to an existing one
		var foundItem = false;
		
		// Make sure that the currencyCode gets set for this order
		if(isNull(arguments.order.getCurrencyCode())) {
			arguments.order.setCurrencyCode( arguments.processObject.getCurrencyCode() );
		}
		
		// If this is a Sale Order Item then we need to setup the fulfillment
		if(listFindNoCase("oitSale,oitDeposit",arguments.processObject.getOrderItemTypeSystemCode())) {
			
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
				for(orderItem in orderFulfillment.getOrderFulfillmentItems()){
					// If the sku, price, attributes & stock all match then just increase the quantity
					
					if(arguments.processObject.matchesOrderItem( orderItem ) ){
						foundItem = true;
						orderItem.setQuantity(orderItem.getQuantity() + arguments.processObject.getQuantity());
						orderItem.validate(context='save');
						if(orderItem.hasErrors()) {
							arguments.order.addError('addOrderItem', orderItem.getErrors());
						}
						break;
					}
				}
			}
			
		// If this is a return order item, then we need to setup or find the orderReturn
		} else if (arguments.processObject.getOrderItemTypeSystemCode() eq "oitReturn") {
			
			// First see if we can use an existing order return
			var orderReturn = processObject.getOrderReturn();	
			
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
			newOrderItem.setPublicRemoteID( arguments.processObject.getPublicRemoteID() );
			if(arguments.processObject.getOrderItemTypeSystemCode() eq "oitSale") {
				newOrderItem.setOrderFulfillment( orderFulfillment );
				newOrderItem.setOrderItemType( getTypeService().getTypeBySystemCode('oitSale') );
			} else if (arguments.processObject.getOrderItemTypeSystemCode() eq "oitReturn") {
				newOrderItem.setOrderReturn( orderReturn );
				newOrderItem.setOrderItemType( getTypeService().getTypeBySystemCode('oitReturn') );
			} else if (arguments.processObject.getOrderItemTypeSystemCode() eq "oitDeposit") {
				newOrderItem.setOrderItemType( getTypeService().getTypeBySystemCode('oitDeposit') );
			}
			
			// Setup child items for a bundle
			//Need to also check child order items for child order items.
			if( arguments.processObject.getSku().getBaseProductType() == 'productBundle' ) {
				if(arraylen(arguments.processObject.getChildOrderItems())){
					for(var childOrderItemData in arguments.processObject.getChildOrderItems()) {
						var childOrderItem = this.newOrderItem();
						populateChildOrderItems(newOrderItem,childOrderItem,childOrderItemData,arguments.order,orderFulfillment);
					}
				}
				
			}
			
			// Setup the Sku / Quantity / Price details
			newOrderItem.setSku( arguments.processObject.getSku() );
			newOrderItem.setCurrencyCode( arguments.order.getCurrencyCode() );
			newOrderItem.setQuantity( arguments.processObject.getQuantity() );
			newOrderItem.setSkuPrice( arguments.processObject.getSku().getPriceByCurrencyCode( newOrderItem.getCurrencyCode() ) );
			
			
			if(len(newOrderItem.getSku().getUserDefinedPriceFlag()) && newOrderItem.getSku().getUserDefinedPriceFlag() && isNumeric(arguments.processObject.getPrice()) ) {
				newOrderItem.setPrice( arguments.processObject.getPrice() );	
			} else {
				newOrderItem.setPrice( newOrderItem.getSkuPrice() );
			}
			
			// If a stock was passed in assign it to this new item
			if( !isNull(arguments.processObject.getStock()) ) {
				newOrderItem.setStock( arguments.processObject.getStock() );
			}
			
			// If attributeValues were passed in set them
			if( !isNull(arguments.processObject.getAttributeValuesByCodeStruct()) ) {
				for(var attributeCode in arguments.processObject.getAttributeValuesByCodeStruct() ) {
					newOrderItem.setAttributeValue( attributeCode, arguments.processObject.getAttributeValuesByCodeStruct()[attributeCode] );
				}	
			}
			
			// Save the new order items
			newOrderItem = this.saveOrderItem( newOrderItem );
			
			if(newOrderItem.hasErrors()) {
				arguments.order.addError('addOrderItem', newOrderItem.getErrors());
			}
		}
		
		// If this is an event then we need to attach accounts and registrations to match the quantity of the order item. 		
		if(arguments.processObject.getSku().getBaseProductType() == "event" && !isNull(arguments.processObject.getRegistrants())) {
			
			var depositsOnlyFlag = false;
			var salesOnlyFlag = false;
			var orderItemsToCreateCount = 1;
			var salesCount = 0;
			var depositsCount = 0;
			var currentRegistrantCount = arguments.processObject.getSku().getRegistrantCount();
			var hasSaleFlag = false;
			var hasDepositFlag = false;
			
			// If order item contains both sales orders AND deposits we'll create the sale order item, then we'll create a separate deposit order item.	
			for(var registrant in arguments.processObject.getRegistrants()) {
				if(registrant.toWaitlistFlag == "1")	{
					hasDepositFlag = true;
				} else {
					hasSaleFlag = true;
				}
				if(hasDepositFlag && hasSaleFlag) {
					// Setup iterator to make 2 passes, the first for sales only
					orderItemsToCreateCount = 2;
					salesOnlyFlag = true;
					break;
				}
			}
			
			for( var i=1;i<=orderItemsToCreateCount;i++) {
				
				if(i==2) {
					// If we're here it means we had to split the order item into two and we're done with the first.
					
					// Create a separate order Item for deposits
					var depositOrderItem = this.newOrderItem();
					
					// Set Header Info
					depositOrderItem.setOrder( arguments.order );
					depositOrderItem.setOrderItemType( getTypeService().getTypeBySystemCode('oitDeposit') );
					
					// Setup the Sku / Quantity / Price details
					depositOrderItem.setSku( arguments.processObject.getSku() );
					depositOrderItem.setCurrencyCode( arguments.order.getCurrencyCode() );
					depositOrderItem.setQuantity( arguments.processObject.getQuantity() );
					depositOrderItem.setPrice( arguments.processObject.getPrice() );
					depositOrderItem.setSkuPrice( arguments.processObject.getSku().getPriceByCurrencyCode( depositOrderItem.getCurrencyCode() ) );
					
					// Set any customizations
					depositOrderItem.populate( arguments.data );
					
					// Save the deposit order items
					depositOrderItem = this.saveOrderItem( depositOrderItem );
					
					if(depositOrderItem.hasErrors()) {
						arguments.order.addError('addOrderItem', depositOrderItem.getErrors());
					}
				
					// Update the quantities to reflect the sales/deposit split.
					newOrderItem.setQuantity( salesCount );
					depositOrderItem.setQuantity( arguments.processObject.getQuantity() - salesCount );
					
					// Update the flags that drive sales/deposit related specifics
					salesOnlyFlag = false;
					depositsOnlyFlag = true;
				}
				
				// ProcessObject should contain account info in registrants array	
				for(var registrant in arguments.processObject.getRegistrants()) {
					
					// Make sure we put the registrants in the right order item
					if( (orderItemsToCreateCount == 1) || (salesOnlyFlag && registrant.toWaitlistFlag == "0") || (depositsOnlyFlag && registrant.toWaitlistFlag == "1") ) {
						
						// Create new event registration	 record
						var eventRegistration = this.newEventRegistration();
						if(depositsOnlyFlag) {
							eventRegistration.setOrderItem(depositOrderItem);
							eventRegistration.setSku(depositOrderItem.getSku());
						} else {
							eventRegistration.setOrderItem(newOrderItem);
							eventRegistration.setSku(newOrderItem.getSku());
						}
						eventRegistration.generateAndSetAttendanceCode();
						
						// If newAccount registrant should contain an accountID otherwise should contain first, last, email, phone
						if(registrant.newAccountFlag == 0) {
							eventRegistration.setAccount( getAccountService().getAccount(registrant.accountID) );
						} else {
							//Create new account to associate with registration
							var newAccount = getAccountService().newAccount();
							if(isDefined("registrant.firstName") && len(registrant.firstName)) {
								newAccount.setFirstName(registrant.firstName);
							}
							if(isDefined("registrant.lastName") && len(registrant.lastName)) {
								newAccount.setLastName(registrant.lastName);
							}
							if(isDefined("registrant.emailAddress") && len(registrant.emailAddress)) {
								var newEmailAddress = getAccountService().newAccountEmailAddress();
								newEmailAddress.setEmailAddress(registrant.emailAddress);
								newAccount.setPrimaryEmailAddress(newEmailAddress);
								
							}
							if(isDefined("registrant.phoneNumber") && len(registrant.phoneNumber)) {
								var newPhoneNumber = getAccountService().newAccountPhoneNumber();
								newPhoneNumber.setPhoneNumber(registrant.phoneNumber);
								newAccount.setPrimaryPhoneNumber(newPhoneNumber);
							}
							newAccount = getAccountService().saveAccount(newAccount);
							eventRegistration.setAccount(newAccount);
							
						}
						
						// Set registration status - Should this be done when order is placed instead?
						if(arguments.processObject.getSku().setting('skuRegistrationApprovalRequiredFlag')) {
							eventRegistration.setEventRegistrationStatusType(getTypeService().getTypeBySystemCode("erstPendingApproval"));
						} else {
							if( depositsOnlyFlag || registrant.toWaitlistFlag == "1" ) {
								depositsCount++;
								eventRegistration.setEventRegistrationStatusType(getTypeService().getTypeBySystemCode("erstWaitlisted"));
							} else {
								if( (arguments.processObject.getSku().getEventCapacity() > (currentRegistrantCount + salesCount) )  ) {
									salesCount++;
									eventRegistration.setEventRegistrationStatusType(getTypeService().getTypeBySystemCode("erstRegistered"));
									
								} else {
									// If we have an unexprected waitlister due to event filling before order item was created
									// check to see if there were any sales that went through. If there were then move the registrant
									// to a waitlist/deposit order item. If not then change the order item type to deposit and waitlist registrant. 
									if( !salesOnlyFlag && salesCount > 0 ) {
										registrant.toWaitlistFlag = "1";
										orderItemsToCreateCount = 2;
										salesOnlyFlag = true;
									} else {
										newOrderItem.setOrderItemType( getTypeService().getTypeBySystemCode('oitDeposit') );
										eventRegistration.setEventRegistrationStatusType(getTypeService().getTypeBySystemCode("erstWaitlisted"));
									}
										
								}
							}
							
						}
						
						eventRegistration = getEventRegistrationService().saveEventRegistration( eventRegistration );
							
					}
				
				
				}
				
				
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
		if( arguments.processObject.getCopyFromType() == 'accountPaymentMethod' && len(arguments.processObject.getAccountPaymentMethodID())) {
			
			// Setup the newOrderPayment from the existing payment method
			var accountPaymentMethod = getAccountService().getAccountPaymentMethod( arguments.processObject.getAccountPaymentMethodID() );
			newOrderPayment.copyFromAccountPaymentMethod( accountPaymentMethod );
			
		// If they just used an exiting account address then we can try that by itself
		}else if(arguments.processObject.getCopyFromType() == 'previousOrderPayment' && len(arguments.processObject.getPreviousOrderPaymentID())){ 
			// Setup the newOrderPayment from the existing payment method
			var orderPayment = getService('OrderService').getOrderPayment(arguments.processObject.getPreviousOrderPaymentID());
			newOrderPayment.copyFromOrderPayment(orderPayment);
			
		}else if(!isNull(arguments.processObject.getAccountAddressID()) && len(arguments.processObject.getAccountAddressID())) {
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
		
		// We need to call updateOrderAmounts so that if the tax is updated from the billingAddress that change is put in place.
		arguments.order = this.processOrder( arguments.order, 'updateOrderAmounts');
		
		// Save the newOrderPayment
		newOrderPayment = this.saveOrderPayment( newOrderPayment );
		
		// Attach 'createTransaction' errors to the order 
		if(newOrderPayment.hasError('createTransaction')) {
			arguments.order.addError('addOrderPayment', newOrderPayment.getError('createTransaction'), true);
			
		} else if(newOrderPayment.hasErrors()) {
			arguments.order.addError('addOrderPayment', newOrderPayment.getErrors());
			
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
		
		// WriteDump(var=arguments.order.getOrderStatusType(), top=3, abort=true);

		if(!newOrderPayment.hasErrors() && arguments.order.getOrderStatusType().getSystemCode() != 'ostNotPlaced' && newOrderPayment.getPaymentMethodType() == 'termPayment' && !isNull(newOrderPayment.getPaymentTerm())) {
			newOrderPayment.setPaymentDueDate( newOrderpayment.getPaymentTerm().getTerm().getEndDate() );
		}
		
		return arguments.order;
	}
	
	public any function processOrder_addPromotionCode(required any order, required any processObject) {
		var pc = getPromotionService().getPromotionCodeByPromotionCode(arguments.processObject.getPromotionCode());
		//if we can't find a promotion or the promotion is no longer active then show the invalid promo message
		if(isNull(pc) || !pc.getPromotion().getActiveFlag()) {
			arguments.processObject.addError("promotionCode", rbKey('validate.promotionCode.invalid'));
		//if we have a promotion but it doesn't fall within the promos startData end date show invalid datetime message
		} else if ( (!isNull(pc.getStartDateTime()) && pc.getStartDateTime() > now()) || (!isNull(pc.getEndDateTime()) && pc.getEndDateTime() < now()) || !pc.getPromotion().getCurrentFlag()) {
			arguments.processObject.addError("promotionCode", rbKey('validate.promotionCode.invaliddatetime'));
		//if we find an promocode is only valid for specific accounts and the order account is not in the list then show invalid account message
		} else if (arrayLen(pc.getAccounts()) && !pc.hasAccount(arguments.order.getAccount())) {
			arguments.processObject.addError("promotionCode", rbKey('validate.promotionCode.invalidaccount'));
		//if promo has a max account use and account related to order has used it more than the max account use, show over max account use message
		} else if( !isNull(pc.getMaximumAccountUseCount()) && !isNull(arguments.order.getAccount()) && pc.getMaximumAccountUseCount() <= getPromotionService().getPromotionCodeAccountUseCount(pc, arguments.order.getAccount()) ) {
			arguments.processObject.addError("promotionCode", rbKey('validate.promotionCode.overMaximumAccountUseCount'));
		//if promo has a max use and the promo has been used more than the max use than display the over max use message
		} else if( !isNull(pc.getMaximumUseCount()) && pc.getMaximumUseCount() <= getPromotionService().getPromotionCodeUseCount(pc) ) {
			arguments.processObject.addError("promotionCode", rbKey('validate.promotionCode.overMaximumUseCount'));
		} else {
			//check if whether the promo has been added already, if not then add it and update the ordr amounts
			if(!arguments.order.hasPromotionCode( pc )) {
				arguments.order.addPromotionCode( pc );
				this.processOrder( arguments.order, {}, 'updateOrderAmounts' );
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
		
		// Loop over all the payments and credit for any charges
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
			}
		}
		
		// Change the status
		arguments.order.setOrderStatusType( getTypeService().getTypeBySystemCode("ostCanceled") );
		
		return arguments.order;
	}
	
	public any function processOrder_changeCurrencyCode( required any order, required any processObject) {
		// Update the order
		arguments.order.setCurrencyCode( arguments.processObject.getCurrencyCode() );
		
		// Update order promotions
		for(var appliedPromotion in arguments.order.getAppliedPromotions()) {
			appliedPromotion.setCurrencyCode( arguments.processObject.getCurrencyCode() );
		}
		
		// Update the orderItems
		for(var orderItem in arguments.order.getOrderItems()) {
			
			// Update the orderItem itself
			orderItem.setCurrencyCode( arguments.processObject.getCurrencyCode() );
			
			// Update order item promotions
			for(var appliedPromotion in orderItem.getAppliedPromotions()) {
				appliedPromotion.setCurrencyCode( arguments.processObject.getCurrencyCode() );
			}
		}
		
		// Update the orderFulfillments
		for(var orderFulfillment in arguments.order.getOrderFulfillments()) {
			
			// update the fulfillment itself
			orderFulfillment.setCurrencyCode( arguments.processObject.getCurrencyCode() );
			
			// Update fulfillment promotions
			for(var appliedPromotion in orderFulfillment.getAppliedPromotions()) {
				appliedPromotion.setCurrencyCode( arguments.processObject.getCurrencyCode() );
			}
		}
		
		// Update the orderPayments
		for(var orderPayment in arguments.order.getOrderPayments()) {
			orderFulfillment.setCurrencyCode( arguments.processObject.getCurrencyCode() );
		}
		
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
		
		if(account.hasErrors()) {
			arguments.order.addError('create', account.getErrors());
		} else {
			arguments.order.setAccount(account);
		
			// Setup Order Type
			arguments.order.setOrderType( getTypeService().getType( processObject.getOrderTypeID() ) );
			
			// Setup the Order Origin
			if( len(arguments.processObject.getOrderOriginID()) ) {
				arguments.order.setOrderOrigin( getSettingService().getOrderOrigin(arguments.processObject.getOrderOriginID()) );
			}
			
			// Setup the Default Stock Location
			if( len(arguments.processObject.getDefaultStockLocationID()) ) {
				arguments.order.setDefaultStockLocation( getSettingService().getLocation(arguments.processObject.getDefaultStockLocationID()) );
			}
			
			// Setup the Currency Code
			arguments.order.setCurrencyCode( arguments.processObject.getCurrencyCode() );
			
			// Save the order
			arguments.order = this.saveOrder(arguments.order);

		}
		
		
		return arguments.order;
	}
	
	public any function processOrder_createReturn(required any order, required any processObject) {
		// Create a new return order
		var returnOrder = this.newOrder();
		returnOrder.setAccount( arguments.order.getAccount() );
		returnOrder.setOrderType( getTypeService().getTypeBySystemCode(arguments.processObject.getOrderTypeCode()));
		returnOrder.setCurrencyCode( arguments.order.getCurrencyCode() );
		returnOrder.setReferencedOrder( arguments.order );
		returnOrder.setReferencedOrderType('return');
		
		// Create OrderReturn entity (to save the fulfillment amount)
		var orderReturn = this.newOrderReturn();
		orderReturn.setOrder( returnOrder );
		orderReturn.setFulfillmentRefundAmount( arguments.processObject.getFulfillmentRefundAmount() );
		orderReturn.setReturnLocation( arguments.processObject.getLocation() );
	
		var orderItemFoundFlag = false;
		// Look for that orderItem in the data records
		for(var orderItemStruct in arguments.processObject.getOrderItems()) {
			
			// Verify that there was a quantity
			if(isNumeric(orderItemStruct.quantity) && orderItemStruct.quantity gt 0) {
				
				orderItemFoundFlag = true; 
				var originalOrderItem = this.getOrderItem( orderItemStruct.referencedOrderItem.orderItemID );
				
				// Create a new return orderItem
				if(!isNull(originalOrderItem)) {
					
					// Create a new order item
					var orderItem = this.newOrderItem();
					
					// Setup the details
					orderItem.setOrderItemType( getTypeService().getTypeBySystemCode('oitReturn') );
					orderItem.setOrderItemStatusType( getTypeService().getTypeBySystemCode('oistNew') );
					orderItem.setPrice( orderItemStruct.price );
					orderItem.setSkuPrice( originalOrderItem.getSku().getPrice() );
					orderItem.setCurrencyCode( originalOrderItem.getSku().getCurrencyCode() );
					orderItem.setQuantity( orderItemStruct.quantity );
					orderItem.setSku( originalOrderItem.getSku() );
					
					// Add needed references
					orderItem.setReferencedOrderItem( originalOrderItem );
					orderItem.setOrderReturn( orderReturn );
					orderItem.setOrder( returnOrder );

					if(originalOrderItem.getSku().getBaseProductType() == "event") {
						// If necessary, initiate the registration cancellation process. 
						if( !structKeyExists(orderItemStruct, "cancelRegistrationFlag") || (structKeyExists(orderItemStruct, "cancelRegistrationFlag") && orderItemStruct.cancelRegistrationFlag) ) {
							// Inform cancel process that the return has already been processed
							originalOrderItem.getEventRegistration().createReturnOrderFlag = true;
							getEventService().processEventRegistration( originalOrderItem.getEventRegistration(), {}, 'cancel');
						}
					}
					
					// Persist the new item
					getHibachiDAO().save( orderItem );
					
				}
				
			}
		}
		
		// Persist the new order
		getHibachiDAO().save( returnOrder );
		
		// Recalculate the order amounts for tax and promotions
		this.processOrder( returnOrder, {}, 'updateOrderAmounts' );
		
		// Check to see if we are attaching an referenced orderPayment
		if(len(arguments.processObject.getRefundOrderPaymentID())) {
		
			var originalOrderPayment = this.getOrderPayment( arguments.processObject.getRefundOrderPaymentID() );
			
			if(!isNull(originalOrderPayment)) {
				var returnOrderPayment = this.newOrderPayment();
				returnOrderPayment.copyFromOrderPayment( originalOrderPayment );
				returnOrderPayment.setReferencedOrderPayment( originalOrderPayment );
				returnOrderPayment.setOrder( returnOrder );
				returnOrderPayment.setCurrencyCode( returnOrder.getCurrencyCode() );
				returnOrderPayment.setOrderPaymentType( getTypeService().getTypeBySystemCode( 'optCredit' ) );
				returnOrderPayment.setAmount( precisionEvaluate(returnOrder.getTotal() * -1) );
			}
			
		}
		
		// If the order doesn't have any errors, then we can flush the ormSession
		if(!returnOrder.hasErrors()) {
			getHibachiDAO().flushORMSession();
			
			if(arguments.processObject.getOrderTypeCode() eq "otReturnOrder" && orderItemFoundFlag) {
				returnOrder = this.processOrder(returnOrder, {}, 'placeOrder');
				
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
			}
		}
		
		
		
		// Return the new order so that the redirect takes users to this new order
		return returnOrder;
	}
	
	public any function processOrder_duplicateOrder (required any order, struct data={}) {
		var saveNewFlag = false;
		var copyPersonalDataFlag = false;
		var referencedOrderFlag = true;
		
		if (structKeyExists(data,'saveNewFlag')){
			saveNewFlag = data.saveNewFlag ;
		}
		
		if (structKeyExists(data,'copyPersonalDataFlag')){
			copyPersonalDataFlag = data.copyPersonalDataFlag ;
		}
		
		if (structKeyExists(data,'referencedOrderFlag')){
			referencedOrderFlag = data.referencedOrderFlag ;
		}

		var newOrder = this.newOrder(); 
		
		newOrder.setCurrencyCode( arguments.order.getCurrencyCode() );
		
		if (referencedOrderFlag == true){
			newOrder.setReferencedOrder(arguments.order);
			newOrder.setReferencedOrderType('duplicate');
		}
		
		//Copy Order Attribtes
		for(var attributeValue in arguments.order.getAttributeValues()) {
			newOrder.setAttributeValue( attributeValue.getAttribute().getAttributeCode(), attributeValue.getAttributeValue() );
		}
		
		// Copy Order Items
		for(var i=1; i<=arrayLen(arguments.order.getOrderItems()); i++) {
			var newOrderItem = this.newOrderItem();
			
			newOrderItem.setPrice( arguments.order.getOrderItems()[i].getPrice() );
			newOrderItem.setSkuPrice( arguments.order.getOrderItems()[i].getSkuPrice() );
			newOrderItem.setCurrencyCode( arguments.order.getOrderItems()[i].getCurrencyCode() );
			newOrderItem.setQuantity( arguments.order.getOrderItems()[i].getQuantity() );
			newOrderItem.setOrderItemType( arguments.order.getOrderItems()[i].getOrderItemType() );
			newOrderItem.setOrderItemStatusType( arguments.order.getOrderItems()[i].getOrderItemStatusType() );
			newOrderItem.setSku( arguments.order.getOrderItems()[i].getSku() );
			if(!isNull(arguments.order.getOrderItems()[i].getStock())) {
				newOrderItem.setStock( arguments.order.getOrderItems()[i].getStock() );
			}
			
			// copy order item customization
			for(var attributeValue in arguments.order.getOrderItems()[i].getAttributeValues()) {
				newOrderItem.setAttributeValue( attributeValue.getAttribute().getAttributeCode(), attributeValue.getAttributeValue() );
			}

			var orderFulfillmentFound = false;
			
			// check if there is a fulfillment method of this type in the order
			for(var fulfillment in newOrder.getOrderFulfillments()) {
				if(arguments.order.getOrderItems()[i].getOrderFulfillment().getFulfillmentMethod().getFulfillmentMethodID() == fulfillment.getFulfillmentMethod().getFulfillmentMethodID()) {
					var newOrderFulfillment = fulfillment;
					orderFulfillmentFound = true;
					break;
				}
			}
			
			// Duplicate Order Fulfillment
			if(!orderFulfillmentFound) {
				var newOrderFulfillment = this.newOrderFulfillment();
				newOrderFulfillment.setFulfillmentMethod( arguments.order.getOrderItems()[i].getOrderFulfillment().getFulfillmentMethod() );
				newOrderFulfillment.setOrder( newOrder );
				newOrderFulfillment.setCurrencyCode( arguments.order.getOrderItems()[i].getOrderFulfillment().getCurrencyCode() );
				if(!isNull(arguments.order.getOrderItems()[i].getOrderFulfillment().getShippingMethod())) {
					newOrderFulfillment.setShippingMethod( arguments.order.getOrderItems()[i].getOrderFulfillment().getShippingMethod() );	
				}
				
				// Personal Info
				if(copyPersonalDataFlag){
					if(!isNull(arguments.order.getOrderItems()[i].getOrderFulfillment().getShippingAddress())) {
						newOrderFulfillment.setShippingAddress( arguments.order.getOrderItems()[i].getOrderFulfillment().getShippingAddress().copyAddress( saveNewFlag ) );
					}
					if(!isNull(arguments.order.getOrderItems()[i].getOrderFulfillment().getAccountAddress())) {
						newOrderFulfillment.setAccountAddress( arguments.order.getOrderItems()[i].getOrderFulfillment().getAccountAddress() );
					}
					if(!isNull(arguments.order.getOrderItems()[i].getOrderFulfillment().getEmailAddress())) {
						newOrderFulfillment.setEmailAddress( arguments.order.getOrderItems()[i].getOrderFulfillment().getEmailAddress() );
					}
				}
				
			}
			newOrderItem.setOrder( newOrder );
			newOrderItem.setOrderFulfillment( newOrderFulfillment );

		}
		
		// Duplicate Account if copyPersonalDataFlag and accountExists
		if(copyPersonalDataFlag && !isNull(arguments.order.getAccount())) {
			newOrder.setAccount( arguments.order.getAccount() );
		}
		
		// Personal Info
		// Dupliace Shipping & Billing Addresses
		if(copyPersonalDataFlag){
			if(!isNull(arguments.order.getShippingAddress())) {
				newOrder.setShippingAddress( arguments.order.getShippingAddress().copyAddress( saveNewFlag ) );
			}
			if(!isNull(arguments.order.getShippingAccountAddress())) {
				newOrder.setShippingAccountAddress( arguments.order.getShippingAccountAddress() );
			}
			if(!isNull(arguments.order.getBillingAddress())) {
				newOrder.setBillingAddress( arguments.order.getBillingAddress().copyAddress( saveNewFlag ) );
			}
			if(!isNull(arguments.order.getBillingAccountAddress())) {
				newOrder.setBillingAccountAddress( arguments.order.getBillingAccountAddress() );
			}
		}
		
		this.saveOrder( newOrder );
		
		return newOrder;
	}
		
	public any function processOrder_forceItemQuantityUpdate(required any order) {
		
		var itemFound = false;
		
		// Loop over each order Item
		for(var i = arrayLen(arguments.order.getOrderItems()); i >= 1; i--)	{
			
			var orderItem = arguments.order.getOrderItems()[i];
			
			// If this orderItem is higher than the maximum order quantity
			if(!orderItem.hasQuantityWithinMaxOrderQuantity())	{
				
				itemFound = true;
				
				// If the max order quantity is gt 0 then just adjust the quantity of the item
				if(orderItem.getMaximumOrderQuantity() > 0) {
					
					
					var messageReplaceKeys = {
						oldQuantity = orderItem.getQuantity(),
						newQuantity = orderItem.getMaximumOrderQuantity()
					};
					orderItem.setQuantity( orderItem.getMaximumOrderQuantity() );
					
					var message = getHibachiUtilityService().replaceStringTemplate(rbKey('validate.processOrder_forceItemQuantityUpdate.forcedItemQuantityAdjusted'), messageReplaceKeys);
					message = orderItem.stringReplace(message);
					
					// Add the error to both the order and the orderItem
					orderItem.addError('forcedItemQuantityAdjusted', message, true);
					arguments.order.addError('forceItemQuantityUpdate', message, true);
					
				// Otherwise remove it from the order
				} else {
					
					orderItem.removeOrder();
					var message = orderItem.stringReplace(rbKey('validate.processOrder_forceItemQuantityUpdate.forcedItemRemoved'));
					 
					// Add the error to both the order and the orderItem
					orderItem.addError('forcedItemRemoved', message, true);
					arguments.order.addError('forceItemQuantityUpdate', message, true);
				}
			}
		}
		
		if(itemFound) {
			arguments.order.addError('forceItemQuantityUpdate', rbKey('validate.processOrder_forceItemQuantityUpdate'), true);
		}
		
		return arguments.order;
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
						
							// Loop over all orderPayments and if it's a term payment set the payment due date
							for(var orderPayment in order.getOrderPayments()) {
								if(orderPayment.getStatusCode() == 'opstActive' && orderPayment.getPaymentMethodType() == 'termPayment' && !isNull(orderPayment.getPaymentTerm())) {
									orderPayment.setPaymentDueDate( orderPayment.getPaymentTerm().getTerm().getEndDate() );
								}
							}
					
							// Update the order status
							order.setOrderStatusType( getTypeService().getTypeBySystemCode("ostNew") );
							
							// Update the orderPlaced
							order.confirmOrderNumberOpenDateCloseDatePaymentAmount();
						
							// Save the order to the database
							getHibachiDAO().save( arguments.order );
						
							// Do a flush so that the order is commited to the DB
							getHibachiDAO().flushORMSession();
						
							// Log that the order was placed
							logHibachi(message="New Order Processed - Order Number: #order.getOrderNumber()# - Order ID: #order.getOrderID()#", generalLog=true);
							
							// Loop over the orderItems looking for any skus that are 'event' skus, and setting their registration value 
							/*for(var orderitem in arguments.order.getOrderItems()) {
								if(orderitem.getSku().getBaseProductType() == "event") {
									for(var eventRegistration in orderitem.getEventRegistrations()) {
										if(orderItem.getSku().setting('skuAllowWaitlistingFlag')) {
											eventRegistration.setEventRegistrationStatusType(getTypeService().getTypeBySystemCode("erstPending"));
										} else {
											eventRegistration.setEventRegistrationStatusType(getTypeService().getTypeBySystemCode("erstRegistered"));	
										}
									}
								}
							}*/
							
							// Look for 'auto' order fulfillments
							for(var i=1; i<=arrayLen( arguments.order.getOrderFulfillments() ); i++) {
								
								
								createOrderDeliveryForAutoFulfillmentMethod(arguments.order.getOrderFulfillments()[i]);
							}
						}
					}
					
				}
				
			} else {
				arguments.order.addError('duplicate', rbKey('validate.processOrder_PlaceOrder.duplicate'));
			}
			
		}	// END OF LOCK
		
		
		
		return arguments.order;
	}
	
	public any function createOrderDeliveryForAutoFulfillmentMethod(required any orderFulfillment){
		
		var order = arguments.orderFulfillment.getOrder();
		
		var newOrderDelivery = this.newOrderDelivery();
		
		// As long as the amount received for this orderFulfillment is within the treshold of the auto fulfillment setting
		if(
			arguments.orderFulfillment.getFulfillmentMethodType() == "auto" 
			&& (
				order.getTotal() == 0 
				|| orderFulfillment.getFulfillmentMethod().setting('fulfillmentMethodAutoMinReceivedPercentage') <= precisionEvaluate( order.getPaymentAmountReceivedTotal() * 100 / order.getTotal() ) 
			) 
		){
												
			// Setup the processData
			var processData = {};
			processData.order = {};
			processData.order.orderID = order.getOrderID();
			processData.location.locationID = arguments.orderFulfillment.getFulfillmentMethod().setting('fulfillmentMethodAutoLocation');
			processData.orderFulfillment.orderFulfillmentID = arguments.orderFulfillment.getOrderFulfillmentID();
			
			newOrderDelivery = this.processOrderDelivery(newOrderDelivery, processData, 'create');
		}
		return newOrderDelivery;
	}
	
	public any function processOrder_placeOnHold(required any order, struct data={}) {
		
		// Set up the comment if someone typed in the box
		if(structKeyExists(arguments.data, "comment") && len(trim(arguments.data.comment))) {
			var comment = getCommentService().newComment();
			comment = getCommentService().saveComment(comment, arguments.data);
		}
		
		// Change the status
		arguments.order.setOrderStatusType( getTypeService().getTypeBySystemCode("ostOnHold") );
		
		return arguments.order;
	}
	
	public any function processOrder_removeOrderItem(required any order, required struct data) {
		
		// Make sure that an orderItemID was passed in
		if(structKeyExists(arguments.data, "orderItemID")) {
			
			// Loop over all of the items in this order
			for(var orderItem in arguments.order.getOrderItems())	{
			
				// Check to see if this item is the same ID as the one passed in to remove
				if(orderItem.getOrderItemID() == arguments.data.orderItemID) {
				
					var okToRemove = true;
					
					// If there was a parentOrderItem, then we need to run some logic to test that this child item can be removed
					if(!isNull(orderItem.getParentOrderItem())) {
						
						var parentItem = orderItem.getParentOrderItem();
						
						// First remove the orderItem to check if the parentItem still validated
						orderItem.removeParentOrderItem();
						
						// Make sure that the parentOrderItem still passes validation (to check for bundle rules)
						parentItem.validate(context='save');
						
						// If there were errors
						if(parentItem.hasErrors()) {
							
							okToRemove = false;
							
							// Put the parentItem back
							orderItem.setParentOrderItem( parentItem );
							
							// Add an error to the order so that this process fails
							argument.order.addError('removeOrderItem', rbKey('entity.order.process.removeOrderItem.parentFailsValidationError'));
						}
					}
					
					if(okToRemove) {
						// Delete this item
						this.deleteOrderItem( orderItem );
						
						// Call saveOrder to recalculate all the orderTotal stuff
						arguments.order = this.saveOrder(arguments.order);
					}
					
					break;
				}
			}
			
		}
		
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
						orderPayment.setOrderPaymentStatusType( getTypeService().getTypeBySystemCode('opstRemoved') );
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
		arguments.order.setOrderStatusType( getTypeService().getTypeBySystemCode("ostProcessing") );
		
		// Call the update order status incase this needs to be changed to closed.
		arguments.order = this.processOrder(arguments.order, {}, 'updateStatus');

		return arguments.order;
	}
	
	public any function processOrder_updateStatus(required any order, struct data) {
		param name="arguments.data.updateItems" default="false";
		
		// Get the original order status code
		var originalOrderStatus = arguments.order.getOrderStatusType().getSystemCode();
		
		// First we make sure that this order status is not 'closed', 'canceled', 'notPlaced' or 'onHold' because we cannot automatically update those statuses
		if(!listFindNoCase("ostNotPlaced,ostOnHold,ostClosed,ostCanceled", arguments.order.getOrderStatusType().getSystemCode())) {
			
			// We can check to see if all the items have been delivered and the payments have all been received then we can close this order
			if(precisionEvaluate(arguments.order.getPaymentAmountReceivedTotal() - arguments.order.getPaymentAmountCreditedTotal()) == arguments.order.getTotal() && arguments.order.getQuantityUndelivered() == 0 && arguments.order.getQuantityUnreceived() == 0)	{
				arguments.order.setOrderStatusType(  getTypeService().getTypeBySystemCode("ostClosed") );
			// The default case is just to set it to processing
			} else {
				arguments.order.setOrderStatusType(  getTypeService().getTypeBySystemCode("ostProcessing") );
			}
			
		}
		
		// If we are supposed to update the items as well, loop over all items and pass to 'updateItemStatus'
		if(arguments.data.updateItems) {
			for(var orderItem in arguments.order.getOrderItems()) {
				this.processOrderItem( orderItem, {}, 'updateStatus');
			}
		}
		
		// If the original order status is not 'closed', and now the order is closed, then we can run the promotion logics
		if( originalOrderStatus neq "ostClosed" and arguments.order.getOrderStatusType().getSystemCode() eq "ostClosed" ) {
			
			// Loop over the loyalties that the account on the order has and call the processAccountLoyalty with context of 'orderClosed'
			for(var accountLoyalty in arguments.order.getAccount().getAccountLoyalties()) {
				var orderClosedData = {
					order = arguments.order
				};
				
				// Call the process method with 'orderClosed' as context
				getAccountService().processAccountLoyalty(accountLoyalty, orderClosedData, 'orderClosed');
			}

		}
		return arguments.order;
	}
	
	public any function processOrder_updateOrderFulfillment(required any order, required any processObject) {
		var orderFulfillment = processObject.getOrderFulfillment();
		
		if(orderFulfillment.getNewFlag()) {
			orderFulfillment.setOrder( arguments.order );
		}
		
		for(var orderItem in arguments.processObject.getOrderItems()) {
			if(!isNull(orderItem.getOrderFulfillment())) {
				orderItem.removeOrderFulfillment();
			}
			orderItem.setOrderFulfillment( orderFulfillment );
		}
		
		orderFulfillment = this.saveOrderFulfillment( orderFulfillment );
		
		if(!orderFulfillment.hasErrors()) {
			arguments.order = this.saveOrder(arguments.order);	
		} else {
			arguments.order.addError('updateOrderFulfillment', orderFulfillment.getErrors());
		}
		
		return arguments.order;
	}
	
	public any function processOrder_removePersonalInfo(required any order) {
		
		// Remove order level info
		if(!isNull(arguments.order.getAccount())){
			arguments.order.removeAccount();
		}
		arguments.order.setShippingAddress(javaCast('null', ''));
		arguments.order.setShippingAccountAddress(javaCast('null', ''));
		arguments.order.setBillingAddress(javaCast('null', ''));
		arguments.order.setBillingAccountAddress(javaCast('null', ''));
		
		// loop over orderFulfillments and remove any shipping info or emailAddress
		for(var orderFulfillment in arguments.order.getOrderFulfillments()) {
			
			orderFulfillment.setShippingAddress(javaCast('null', ''));
			orderFulfillment.setAccountAddress(javaCast('null', ''));
			orderFulfillment.setEmailAddress(javaCast('null', ''));
			
		}
		
		// loop over and remove all orderPayments
		for(var p=arrayLen(arguments.order.getOrderPayments()); p>=1; p--) {
			arguments.order.getOrderPayments()[p].removeOrder();
		}
		
		return this.saveOrder(arguments.order);	
	}
	
	public any function processOrder_updateOrderAmounts(required any order, struct data) {
		//only allow promos to be applied to orders that have not been closed or canceled
		if(!listFindNoCase("ostCanceled,ostClosed", arguments.order.getOrderStatusType().getSystemCode())) {
			
			// Loop over the orderItems to see if the skuPrice Changed
			if(arguments.order.getOrderStatusType().getSystemCode() == "ostNotPlaced") {
				for(orderItem in arguments.order.getOrderItems()){
					var skuPrice = val(orderItem.getSkuPrice());
					var SkuPriceByCurrencyCode = val(orderItem.getSku().getPriceByCurrencyCode(orderItem.getCurrencyCode()));
 					if(listFindNoCase("oitSale,oitDeposit",orderItem.getOrderItemType().getSystemCode()) && skuPrice != SkuPriceByCurrencyCode){
 						if(!orderItem.getSku().getUserDefinedPriceFlag()) {
 							orderItem.setPrice(SkuPriceByCurrencyCode);	
 							orderItem.setSkuPrice(SkuPriceByCurrencyCode);
 						}
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
					orderDeliveryItem.setOrderItem( this.getOrderItem( arguments.processObject.getOrderDeliveryItems()[i].orderItem.orderItemID ) );
					orderDeliveryItem.setQuantity( arguments.processObject.getOrderDeliveryItems()[i].quantity );
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

		
		// Make sure the orderDelivery doesn't have errors
		if (!arguments.orderDelivery.hasErrors()) {
			
			// Loop over the accounts loyalty programs
			for(var accountLoyalty in arguments.orderDelivery.getOrder().getAccount().getAccountLoyalties()) {
				var itemsFulfilledData = {
					orderDelivery = arguments.orderDelivery
				};
				
				// Call the process method with 'itemsFulfilled' as context
				getAccountService().processAccountLoyalty(accountLoyalty, itemsFulfilledData, 'itemFulfilled');
			}
			
			// Check to see if this orderFulfillment is complete and fully 'fulfilled'
			var allOrderItemsFulfilled = true;
			var orderFulfillment = arguments.orderDelivery.getOrderDeliveryItems()[1].getOrderItem().getOrderFulfillment();
			
			for(var orderfulfillmentItem in orderFulfillment.getOrderFulfillmentItems()) {
				
				if(!listFindNoCase("oistFulfilled",orderFulfillmentItem.getOrderItemStatusType().getSystemCode())){
					allOrderItemsFulfilled = false;
					break;
				}
			}

			// If all items in an order have been fulfilled 
			if( allOrderItemsFulfilled ){
				
				for(var accountLoyalty in arguments.orderDelivery.getOrder().getAccount().getAccountLoyalties()) {
					var fulfillmentMethodUsedData = {
						orderFulfillment = orderFulfillment
					};
					// Call the process method with 'fulfillmentMethodUsed' as context
					getAccountService().processAccountLoyalty(accountLoyalty, fulfillmentMethodUsedData, 'fulfillmentMethodUsed'); 
				}
			}
			
			saveOrderFulfillment( orderFulfillment );
		}
		
		return arguments.orderDelivery;
	}
	
	private any function populateChildOrderItems(required parentOrderItem, required childOrderItem, required childOrderItemData, required order, required orderFulfillment){
		// Populate the childOrderItem with the data
		arguments.childOrderItem.populate( arguments.childOrderItemData );
		if(!isNull(arguments.childOrderItem.getSku())
			&& !isNull(arguments.childOrderItem.getProductBundleGroup())
		) {
			
			// Set quantity if needed
			if(isNull(arguments.childOrderItem.getQuantity())) {
				arguments.childOrderItem.setQuantity( 1 );
			}
			// Set orderFulfillment if needed
			if(isNull(arguments.childOrderItem.getOrderFulfillment())) {
				arguments.childOrderItem.setOrderFulfillment( arguments.orderFulfillment );
			}
			// Set fulfillmentMethod if needed
			if(isNull(arguments.childOrderItem.getOrderFulfillment().getFulfillmentMethod())) {
				arguments.childOrderItem.getOrderFulfillment().setFulfillmentMethod( listFirst(arguments.childOrderItem.getSku().setting('skuEligibleFulfillmentMethods')) );
			}
			arguments.childOrderItem.setCurrencyCode( arguments.order.getCurrencyCode() );
			if(arguments.childOrderItem.getSku().getUserDefinedPriceFlag() && structKeyExists(arguments.childOrderItemData, 'price') && isNumeric(arguments.childOrderItemData.price)) {
				arguments.childOrderItem.setPrice( arguments.childOrderItemData.price );
			} else {
				// TODO: calculate price base on adjustment type rule of bundle group
				arguments.childOrderItem.setPrice( arguments.childOrderItem.getSku().getPriceByCurrencyCode( arguments.order.getCurrencyCode() ) );
			}
			arguments.childOrderItem.setSkuPrice( arguments.childOrderItem.getSku().getPriceByCurrencyCode( arguments.order.getCurrencyCode() ) );
			arguments.childOrderItem.setParentOrderItem( arguments.parentOrderItem );
			arguments.childOrderItem.setOrder( arguments.order );
			if(structKeyExists(childOrderItemData,'childOrderItems')){
				for(var childOfChildOrderItemData in arguments.childOrderItemData.childOrderItems) {
					var childOfChildOrderItem = this.newOrderItem();
					populateChildOrderItems(arguments.childOrderItem,childOfChildOrderItem,childOfChildOrderItemData,arguments.order,orderFulfillment);
				}
			}
			if(arguments.childOrderItem.hasErrors()) {
				arguments.order.addError('addOrderItem', arguments.childOrderItem.getErrors());
			}
			
		}
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
	public any function processOrderItem_updateEventRegistrationQuantity(required any orderItem,struct data={}) {
		
		// We need LESS event registrations due to order adjustment before order has been placed
		if( arrayLen(orderItem.getActiveEventRegistrations()) > orderItem.getQuantity() && arguments.orderItem.getOrder().getStatusCode() == "ostNotPlaced" ) {
			
			var removableEvents = [];
			var numberToRemove = arrayLen(orderItem.getEventRegistrations()) - orderItem.getQuantity();
			
			// Create an array of registrations we can safely remove, i.e. not associated with an account
			for(var eventRegistration in orderItem.getEventRegistrations()) {
				if(isNull(eventRegistration.getFirstName()) && isNull(eventRegistration.getLastName()) && isNull(eventRegistration.getEmailAddress()) && isNull(eventRegistration().getPhoneNumber())) {
					arrayAppend(removableEvents, eventRegistration);
					// Break from loop when we have enough registrations
					if(arrayLen(removableEvents) == numberToRemove) {
						break;
					}
				}
			}
			
			// Delete extra event registrations
			if(arrayLen(removableEvents) >= numberToRemove) {
				for(var eventRegistration in eventsToRemove) {
					eventRegistration.removeOrderItem();
				}
			}
		
		}
		
		// We need less event registration, but couldn't do it... add error
		if(arrayLen(orderItem.getEventRegistrations()) > orderItem.getQuantity()) {
			orderItem.addError('updateRegistrationQuantity', rbKey('validate.orderItem.quantity.tooManyEventRegistrations'));
		}
		
		// We need MORE event registrations due to order adjustment before order has been placed
		if(arrayLen(orderItem.getEventRegistrations()) < orderItem.getQuantity()) {
			for(var i=1; i <= orderItem.getQuantity() - arrayLen(orderItem.getEventRegistrations()); i++ ) {
				var eventRegistration = this.newEventRegistration();
				eventRegistration.setOrderItem(orderitem);
				eventRegistration.seteventRegistrationStatusType( getTypeService().getTypeBySystemCode("erstNotPlaced") );
				eventRegistration.setAccount(arguments.order.getAccount());
				eventRegistration = getEventRegistrationService().saveEventRegistration( eventRegistration );	
			}
		}
		
		return arguments.orderItem;
	}

	public any function processOrderItem_updateStatus(required any orderItem) {

		// First we make sure that this order item is not already fully fulfilled, or onHold because we cannont automatically update those statuses
		if(!listFindNoCase("oistFulfilled,oistOnHold,oistReturned",arguments.orderItem.getOrderItemStatusType().getSystemCode())) {
			
			//Dealing with a return item.
			if(arguments.orderItem.getOrderItemType().getSystemCode() eq 'oitReturn'){
				
				if(arguments.orderItem.getQuantityUnreceived() == 0){
					arguments.orderItem.setOrderItemStatusType(  getTypeService().getTypeBySystemCode("oistReturned") );
				} else{
					arguments.orderItem.setOrderItemStatusType(  getTypeService().getTypeBySystemCode("oistProcessing") );
				}

			//Dealing with a Sale or Depost item
			} else {
				
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
				
					stockReceiverItem.setQuantity( thisRecord.quantity );
					stockReceiverItem.setStock( stock );
					stockReceiverItem.setOrderItem( orderReturnItem );
					stockReceiverItem.setStockReceiver( stockReceiver );
				}
				
			}
		}
		
		
		// Loop over the stockReceiverItems to remove subscriptions and contentAccess
		for(var stockReceiverItem in stockReceiver.getStockReceiverItems()) {
			
			// If there was a subscriptionOrderItem attached to referenced order item, we can cancel that subscription usage
			var subscriptionOrderItem = getSubscriptionService().getSubscriptionOrderItem({orderItem=stockReceiverItem.getOrderItem().getReferencedOrderItem()}); 
			if(!isNull(subscriptionOrderItem)) {
				var errorBean = getHibachiValidationService().validate( subscriptionOrderItem.getSubscriptionUsage(), 'cancel', false );
				if(!errorBean.hasErrors()) {
					getSubscriptionService().processSubscriptionUsage(subscriptionOrderItem.getSubscriptionUsage(), {}, 'cancel');	
				}
			}
			
			// If there was an accountContentAccess associated with the referenced orderItem then we need to remove it.
			var accountContentAccess = getAccountService().getAccountContentAccess({orderItem=stockReceiverItem.getOrderItem().getReferencedOrderItem()});
			if(!isNull(accountContentAccess)) {
				getAccountService().deleteAccountContentAccess( accountContentAccess );
			}
		}
		
		
		stockReceiver = getStockService().saveStockReceiver( stockReceiver );
		
		for(var accountLoyalty in arguments.orderReturn.getOrder().getAccount().getAccountLoyalties()) {
			var orderItemReceivedData = {
				stockReceiver = stockReceiver
			};
			// Call the process method with 'orderItemReceived' as context
			getAccountService().processAccountLoyalty(accountLoyalty, orderItemReceivedData, 'orderItemReceived'); 
		}

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
			arguments.orderPayment.setOrderPaymentStatusType( getTypeService().getTypeBySystemCode('opstInvalid') );
		} else {
			arguments.orderPayment.setOrderPaymentStatusType( getTypeService().getTypeBySystemCode('opstActive') );
		}
		
		// Flush the statusType for the orderPayment
		getHibachiDAO().flushORMSession();
		
		// If no errors, attempt To Update The Order Status
		if(!arguments.orderPayment.hasErrors()) {
			this.processOrder(arguments.orderPayment.getOrder(), {}, 'updateStatus');	
		}
		
		return arguments.orderPayment;
		
	}
		
	public any function processOrderPayment_runPlaceOrderTransaction(required any orderPayment, struct data) {
						
		var transactionType = "";
		
		if(!isNull(arguments.orderPayment.getPaymentMethod().getPlaceOrderChargeTransactionType()) && orderPayment.getOrderPaymentType().getSystemCode() eq "optCharge") {
			var transactionType = arguments.orderPayment.getPaymentMethod().getPlaceOrderChargeTransactionType();
		}
		if(!isNull(arguments.orderPayment.getPaymentMethod().getPlaceOrderCreditTransactionType()) && orderPayment.getOrderPaymentType().getSystemCode() eq "optCredit") {
			var transactionType = arguments.orderPayment.getPaymentMethod().getPlaceOrderCreditTransactionType();
		}
		if(
			!isNull(arguments.orderPayment.getPaymentMethod().getSubscriptionRenewalTransactionType()) 
			&& structKeyExists(arguments.data,'isSubscriptionRenewal') 
			&& arguments.data.isSubscriptionRenewal == true
		){
			var transactionType = arguments.orderPayment.getPaymentMethod().getSubscriptionRenewalTransactionType();
		}
		
		//need subscription transactiontype
		
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
			
			// Save Billing & Shipping Account Addresses if needed
			arguments.order.checkNewBillingAccountAddressSave();
			arguments.order.checkNewShippingAccountAddressSave();
			
			// setup a variable to keep all of the orderFulfillments used by orderItems
			var orderFulfillmentsInUse = [];
			var orderReturnsInUse = [];
			
			// loop over the orderItems to remove any that have a qty of 0
			for(var i = arrayLen(arguments.order.getOrderItems()); i >= 1; i--) {
				if(arguments.order.getOrderItems()[i].getQuantity() < 1) {
					arguments.order.removeOrderItem(arguments.order.getOrderItems()[i]);
				} else if( !isNull(arguments.order.getOrderItems()[i].getOrderFulfillment()) && !arrayFind(orderFulfillmentsInUse, arguments.order.getOrderItems()[i].getOrderFulfillment().getOrderFulfillmentID())) {
					arrayAppend(orderFulfillmentsInUse, arguments.order.getOrderItems()[i].getOrderFulfillment().getOrderFulfillmentID());
				} else if( !isNull(arguments.order.getOrderItems()[i].getOrderReturn()) && !arrayFind(orderReturnsInUse, arguments.order.getOrderItems()[i].getOrderReturn().getOrderReturnID())) {
					arrayAppend(orderReturnsInUse, arguments.order.getOrderItems()[i].getOrderReturn().getOrderReturnID());
				}
			}
			
			// loop over any fulfillments, remove any that aren't in use and update the shippingMethodOptions for any shipping fulfillments
			for(var ofi=arrayLen(arguments.order.getOrderFulfillments()); ofi>=1; ofi--) {
			
				var orderFulfillment = arguments.order.getOrderFulfillments()[ofi];
			
				// If that orderFulfillment isn't in use anymore, then we need to remove it from the order
				if(!arrayFind(orderFulfillmentsInUse, orderFulfillment.getOrderFulfillmentID())) {
					orderFulfillment.removeOrder();
					
				// If is is still in use, and a shipping fulfillment then we need to update some stuff.
				} else if(orderFulfillment.getFulfillmentMethodType() eq "shipping") {
				
					// Update the shipping methods
					getShippingService().updateOrderFulfillmentShippingMethodOptions( orderFulfillment );
					
					// Save the accountAddress if needed
					orderFulfillment.checkNewAccountAddressSave();
				}
			
			}
			
			// loop over any order return and remove any that aren't in use
			for(var ori=arrayLen(arguments.order.getOrderReturns()); ori>=1; ori--) {
			
				var orderReturn = arguments.order.getOrderReturns()[ori];
			
				// If that orderFulfillment isn't in use anymore, then we need to remove it from the order
				if(!arrayFind(orderReturnsInUse, orderReturn.getOrderReturnID())) {
					orderReturn.removeOrder();
				}
			
			}
			
			// Loop over any orderPayments that were just populated, and may have previously been marked as invalid.  This is specifically used for the legacy checkouts on repeated attempts
			if(!isNull(arguments.order.getPopulatedSubProperties()) && structKeyExists(arguments.order.getPopulatedSubProperties(), "orderPayments")) {
				for(var orderPayment in arguments.order.getPopulatedSubProperties().orderPayments) {
					if(!orderPayment.hasErrors()) {
						orderPayment.setOrderPaymentStatusType( getTypeService().getTypeBySystemCode('opstActive') );
					}
				}
			}
			
			// Make sure the auto-state stuff gets called.
			arguments.order.confirmOrderNumberOpenDateCloseDatePaymentAmount();
		}
		
		// Recalculate the order amounts for tax and promotions
		if(!arguments.order.hasErrors()) {
			arguments.order = this.processOrder( order, {}, 'updateOrderAmounts');	
		}
		
		// Check for updateEventRegistrationQuantity Needs
		if(!arguments.order.hasErrors() && !listFindNoCase("ostClosed,ostCanceled", arguments.order.getStatusCode())) {
			
			var updateEventRegistrationQuantityError = false;
			
			// Loop over the orderItems looking for any skus that are 'event' skus. 
			for(var orderitem in arguments.order.getOrderItems()) {

				// The number of reg & quantity don't match
				if(orderItem.getSku().getBaseProductType() == "event" && arrayLen(orderItem.getEventRegistrations()) > orderItem.getQuantity()) {

					orderItem = this.processOrderItem(orderItem, {}, 'updateEventRegistrationQuantity');
					
					if(orderItem.hasError('updateEventRegistrationQuantity')) {
						updateEventRegistrationQuantityError = true;
					}
				}
			}
			
			if(updateEventRegistrationQuantityError) {
				order.addError('orderItems', rbKey('validate.order.orderItems.tooManyEventRegistrations') );
			}
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
			
		}
		
		// Recalculate the order amounts for tax and promotions
		if(!arguments.orderFulfillment.hasErrors()) {
			this.processOrder( arguments.orderFulfillment.getOrder(), {}, 'updateOrderAmounts' );
		}
		
		// if there are orderFulfillments
		if (arrayLen(arguments.orderFulfillment.getOrderFulfillmentItems())) {
			var fulfilledFlag = true;
			var partiallyFulfilledFlag = false;
			
			for(var fulfillmentItem in arguments.orderFulfillment.getOrderFulfillmentItems()) {
				if(fulfillmentItem.getQuantityUndelivered() > 0) {
					fulfilledFlag = false;
				}
				if(fulfillmentItem.getQuantityDelivered() > 0) {
					partiallyFulfilledFlag = true;
				}
			}
			// Change the status depending on value of fulfilledFlag or partiallyFulfilledFlag, status defaults to "ofstUnfulfilled"
			if(fulfilledFlag){
				arguments.orderFulfillment.setOrderFulfillmentStatusType( getTypeService().getTypeBySystemCode("ofstFulfilled") );
			} else if(partiallyFulfilledFlag) {
				arguments.orderFulfillment.setOrderFulfillmentStatusType( getTypeService().getTypeBySystemCode("ofstPartiallyFulfilled") );
			}
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
			
		}
		
		// Recalculate the order amounts for tax and promotions
		if(!arguments.orderItem.hasErrors()){
			this.processOrder( arguments.orderItem.getOrder(), {}, 'updateOrderAmounts' );
		}
		
		return arguments.orderItem;
	}
	
	public any function saveOrderPayment(required any orderPayment, struct data={}, string context="save") {
		
		var oldPaymentTermID = "";
		var newPaymentTermID = "";
		
		if(!isNull(arguments.orderPayment.getPaymentTerm())) {
			var oldPaymentTermID = arguments.orderPayment.getPaymentTerm().getPaymentTermID();	
		}
		
		// Call the generic save method to populate and validate
		arguments.orderPayment = save(arguments.orderPayment, arguments.data, arguments.context);
		
		if(!isNull(arguments.orderPayment.getPaymentTerm())) {
			var newPaymentTermID = arguments.orderPayment.getPaymentTerm().getPaymentTermID();
		}

		// Only do this check if the order has already been placed, and this a term payment
		if(orderPayment.getPaymentMethodType() == 'termPayment' && orderPayment.getOrder().getOrderStatusType().getSystemCode() != 'ostNotPlaced' && oldPaymentTermID != newPaymentTermID && !isNull(orderPayment.getPaymentTerm())) {
			if(orderPayment.getCreatedDateTime() > orderPayment.getOrder().getOrderOpenDateTime()) {
				orderPayment.setPaymentDueDate( orderPayment.getPaymentTerm().getTerm().getEndDate ( startDate=orderPayment.getCreatedDateTime() ) );
			} else {
				orderPayment.setPaymentDueDate( orderPayment.getPaymentTerm().getTerm().getEndDate ( startDate=orderPayment.getOrder().getOrderOpenDateTime() ) );
			}
		}
		
		// If the orderPayment doesn't have any errors, then we can update the status to active.  If later a transaction runs, then this payment may get flagged back in inactive in the same request
		if(!arguments.orderPayment.hasErrors()) {
			arguments.orderPayment.setOrderPaymentStatusType( getTypeService().getTypeBySystemCode('opstActive') );
		}
		
		// If the order payment does not have errors, then we can check the payment method for a saveTransaction
		if(
			!arguments.orderPayment.getSucessfulPaymentTransactionExistsFlag()
			&& !arguments.orderPayment.hasErrors()
			&& isNull(arguments.orderPayment.getAccountPaymentMethod())
			&& isNull(arguments.orderPayment.getReferencedOrderPayment())
			&& !isNull(arguments.orderPayment.getPaymentMethod().getSaveOrderPaymentTransactionType())
			&& len(arguments.orderPayment.getPaymentMethod().getSaveOrderPaymentTransactionType())
			&& arguments.orderPayment.getPaymentMethod().getSaveOrderPaymentTransactionType() neq "none") {
			
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
		smartList.joinRelatedProperty("SlatwallOrderItem", "sku", "left", true);
		smartList.joinRelatedProperty("SlatwallSku", "product", "left", true);
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
		smartList.addKeywordProperty(propertyIdentifier="sku.skuCode", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="sku.product.calculatedTitle", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="orderItemStatusType.type", weight=1);
		
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
		getHibachiEventService().announceEvent("beforeOrderItemDelete", arguments);
		
		// Check delete validation
		if(arguments.orderItem.isDeletable()) {
			
			// Remove the primary fields so that we can delete this entity
			var order = arguments.orderItem.getOrder();
			
			removeOrderItemAndChildItemRelationshipsAndDelete( arguments.orderItem );
			
			// Recalculate the order amounts
			this.processOrder( order, {}, 'updateOrderAmounts' );
			order.updateCalculatedProperties();
			
			getHibachiEventService().announceEvent("afterOrderItemDelete", arguments);
			getHibachiEventService().announceEvent("afterOrderItemDeleteSuccess", arguments);
			
			return true;
		}
		
		getHibachiEventService().announceEvent("afterOrderItemDelete", arguments);
		getHibachiEventService().announceEvent("afterOrderItemDeleteFailure", arguments);
		
		return false;
	}
	
	public any function deleteOrderPayment( required any orderPayment ) {
		
		// Check delete validation
		if(arguments.orderPayment.isDeletable()) {
			
			// Remove the primary fields so that we can delete this entity
			var order = arguments.orderPayment.getOrder();
			
			order.removeOrderPayment( arguments.orderPayment );
			
			// Actually delete the entity
			getHibachiDAO().delete( arguments.orderPayment );
			
			return true;
		}
		
		return false;
	}
	
	
	// =====================  END: Delete Overrides ===========================
	
	// ================== START: Private Helper Functions =====================
	
	private void function removeOrderItemAndChildItemRelationshipsAndDelete( required any orderItem ) {
		
		// Call on all ChildItems First
		for(var ci=arrayLen(arguments.orderItem.getChildOrderItems()); ci >= 1; ci--) {
			removeOrderItemAndChildItemRelationshipsAndDelete( arguments.orderItem.getChildOrderItems()[ci] );
		}
		
		// Remove relationships
		arguments.orderItem.removeOrder();
		
		if(!isNull(arguments.orderItem.getParentOrderItem())) {
			arguments.orderItem.removeParentOrderItem();
		}
		if(!isNull(arguments.orderItem.getOrderFulfillment())) {
			arguments.orderItem.removeOrderFulfillment();
		}
		if(!isNull(arguments.orderItem.getOrderReturn())) {
			arguments.orderItem.removeOrderReturn();	
		}
		
		// Actually delete the entity
		getHibachiDAO().delete( arguments.orderItem );
		
	}
	
	// ==================  END:  Private Helper Functions =====================
	
	// =================== START: Deprecated Functions ========================
	
	public any function forceItemQuantityUpdate(required any order, required any messageBean) {
		arguments.order = this.processOrder(order, 'forceItemQuantityUpdate');
		
		if(arguments.order.hasError('forceItemQuantityUpdate')) {
			for(var errorMessage in arguments.order.getErrors()['forceItemQuantityUpdate']) {
				arguments.messageBean.addMessage(messageName="forcedItemQuantityAdjusted", message=errorMessage);
			}	
		}
	}
	
	// ===================  END: Deprecated Functions =========================
	
}
