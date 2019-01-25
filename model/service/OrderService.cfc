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
	- Your custom code must not alter or
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
	property name="productDAO";

	property name="accountService";
	property name="addressService";
	property name="commentService";
	property name="emailService";
	property name="eventRegistrationService";
	property name="fulfillmentService";
	property name="giftCardService";
	property name="hibachiUtilityService";
	property name="hibachiAuthenticationService";
	property name="integrationService";
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

	public string function getOrderRequirementsList(required any order, struct data = {}) {
		var orderRequirementsList = "";


		// Check if the order still requires a valid account
		if(isNull(arguments.order.getAccount()) || arguments.order.getAccount().hasErrors()) {
			orderRequirementsList = listAppend(orderRequirementsList, "account");
		}

		// Check each of the orderFulfillments to see if they are ready to process
		var orderFulfillmentsCount = arrayLen(arguments.order.getOrderFulfillments());
		for(var i = 1; i <= orderFulfillmentsCount; i++) {
			if(!arguments.order.getOrderFulfillments()[i].isProcessable( context="placeOrder" )
				|| arguments.order.getOrderFulfillments()[i].hasErrors()) {
				orderRequirementsList = listAppend(orderRequirementsList, "fulfillment");
				break;
			}
		}

		// Check each of the orderReturns to see if they are ready to process
		var orderReturnsCount = arrayLen(arguments.order.getOrderReturns());
		for(var i = 1; i <= orderReturnsCount; i++) {
			if(!arguments.order.getOrderReturns()[i].isProcessable( context="placeOrder" ) || arguments.order.getOrderReturns()[i].hasErrors()) {
				orderRequirementsList = listAppend(orderRequirementsList, "return");
				break;
			}
		}

		if(arguments.order.getPaymentAmountTotal() == 0 && this.isAllowedToPlaceOrderWithoutPayment(arguments.order, arguments.data)){
			//If is allowed to place order without payment and there is no payment, skip payment order
			return orderRequirementsList;
		}

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

		//only do this check if no payment has been added yet.
		if (!listFindNoCase(orderRequirementsList, "payment")){
			//Check if there is subscription with autopay flag without order payment with account payment method.
			if (this.validateHasNoSavedAccountPaymentMethodAndSubscriptionWithAutoPay(arguments.order)){
				orderRequirementsList = listAppend(orderRequirementsList, "payment");
			}
		}
		return orderRequirementsList;
	}
	
	public string function getProductsScheduledForDelivery(required any currentDateTime){
		
		//get all products that are scheduled for a delivery if the nextDeliveryScheduleDate is ready
		var productsScheduledForDeliveryCollectionList = getService('productService').getProductsScheduledForDeliveryCollectionList(arguments.currentDateTime);
		productsScheduledForDeliveryCollectionList.setDisplayProperties('productID,startInCurrentPeriodFlag');
		
		return productsScheduledForDeliveryCollectionList.getPrimaryIDList();
	}
	
	public any function getSubscriptionOrderItemRecordsByProductsScheduledForDelivery(required any currentDateTime, required string productsScheduledForDelivery){
		//find all order items that require delivery based on the term
		var subscriptionOrderItemCollectionList = this.getSubscriptionOrderItemCollectionList();
		subscriptionOrderItemCollectionList.setDisplayProperties('subscriptionOrderItemID,subscriptionUsage.subscriptionTerm.itemsToDeliver,orderItem.calculatedExtendedPrice,orderItem.calculatedTaxAmount');
		subscriptionOrderItemCollectionList.addDisplayAggregate('subscriptionOrderDeliveryItems.quantity','SUM','subscriptonOrderDeliveryItemsQuantitySum');
		subscriptionOrderItemCollectionList.addFilter('orderItem.sku.product.productID',arguments.productsScheduledForDelivery,'IN');
		//TODO: subscriptionUsage doesn't have an activeFlag but we need to figure out if it is active
		subscriptionOrderItemCollectionList.addFilter('subscriptionUsage.calculatedCurrentStatus.effectiveDateTime',arguments.currentDateTime,'<=');
		subscriptionOrderItemCollectionList.addFilter('subscriptionUsage.calculatedCurrentStatus.subscriptionStatusType.systemCode','sstActive','=');
		
		subscriptionOrderItemCollectionList.addFilter('orderItem.sku.subscriptionTerm.itemsToDeliver','NULL','IS NOT');
		
		return subscriptionOrderItemCollectionList.getRecords();
		
	}
	
	public any function createSubscriptionOrderDeliveries(any currentDateTime=now()){
	
		transaction{
			//list of productIDs based on the nextDeliveryScheduleDate
			var productsScheduledForDelivery = getProductsScheduledForDelivery(currentDateTime);
			//subscription order item data for creating 
			var subscriptionOrderItemRecords = getSubscriptionOrderItemRecordsByProductsScheduledForDelivery(arguments.currentDateTime,productsScheduledForDelivery);
			
			//create a delivery for each subscription Order Item 
			for(var subscriptionOrderItemRecord in subscriptionOrderItemRecords){
				//insert a single subscriptionOrderDeliveryItem if we haven't completed delivering all the items in the subscription
				if(subscriptionOrderItemRecord['subscriptonOrderDeliveryItemsQuantitySum'] < subscriptionOrderItemRecord['subscriptionUsage_subscriptionTerm_itemsToDeliver']){
					getOrderDao().insertSubscriptionOrderDeliveryItem(
						trim(subscriptionOrderItemRecord['subscriptionOrderItemID']),1,subscriptionOrderItemRecord['orderItem_calculatedExtendedPrice'],subscriptionOrderItemRecord['orderItem_calculatedTaxAmount']
					);
				}
			}
			//update NextDeliveryDate
			var productsScheduledForDeliveryCollectionList = getService('productService').getProductsScheduledForDeliveryCollectionList(arguments.currentDateTime);
			productsScheduledForDeliveryCollectionList.setDisplayProperties('productID,startInCurrentPeriodFlag');
			var productsScheduledForDeliveryRecords = productsScheduledForDeliveryCollectionList.getRecords(formatRecords=false);
			
			for(var productsScheduledForDeliveryRecord in productsScheduledForDeliveryRecords){
				var deliveryScheduleDateCollectionList = this.getDeliveryScheduleDateCollectionList();
				deliveryScheduleDateCollectionList.setDisplayProperties('deliveryScheduleDateValue');
				deliveryScheduleDateCollectionList.addFilter('product.productID',productsScheduledForDeliveryRecord['productID']);
				
				//if start in current period flag is set then get the closest previous date in the past otherwise closest in the future
				if(structKeyExists(productsScheduledForDeliveryRecord,'startInCurrentPeriodFlag') && productsScheduledForDeliveryRecord['startInCurrentPeriodFlag']){
					deliveryScheduleDateCollectionList.addFilter('deliveryScheduleDateValue',arguments.currentDateTime,'<');
					deliveryScheduleDateCollectionList.addOrderBy('deliveryScheduleDateValue|DESC');
				}else{
					deliveryScheduleDateCollectionList.addFilter('deliveryScheduleDateValue',arguments.currentDateTime,'>');
					deliveryScheduleDateCollectionList.addOrderBy('deliveryScheduleDateValue');
				}
				//make sure the date has not been completed
				//deliveryScheduleDateCollectionList.addFilter('completedFlag',1,'!=');
				
				deliveryScheduleDateCollectionList.setPageRecordsShow(1);
				var deliveryScheduleDateRecords = deliveryScheduleDateCollectionList.getPageRecords(formatRecords=false);
				
				if(arrayLen(deliveryScheduleDateRecords)){
					getProductDAO().updateNextDeliveryScheduleDate(trim(productsScheduledForDeliveryRecord['productID']),trim(deliveryScheduleDateRecords[1]['deliveryScheduleDateValue']));
				}
			}
		}
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

	public boolean function getPeerOrderPaymentNullAmountExistsFlag(required string orderID, required string orderPaymentID) {
		return getOrderDAO().getPeerOrderPaymentNullAmountExistsFlag(argumentcollection=arguments);
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
	public any function processOrder_addOrderItem(required any order, required any processObject){

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
						
						
						if(!isNull(arguments.processObject.getThirdPartyShippingAccountIdentifier()) && len(arguments.processObject.getThirdPartyShippingAccountIdentifier())){
							orderFulfillment.setThirdPartyShippingAccountIdentifier(arguments.processObject.getThirdPartyShippingAccountIdentifier());
						} 
						// Check for an accountAddress
						if(len(arguments.processObject.getShippingAccountAddressID())) {

							// Find the correct account address, and set it in the order fulfillment
							var accountAddress = getAccountService().getAccountAddress( arguments.processObject.getShippingAccountAddressID() );
							orderFulfillment.setAccountAddress( accountAddress );
							var address = getAddressService().saveAddress(arguments.processObject.getShippingAddress());
							if(!address.hasErrors()){
								orderFulfillment.setShippingAddress(address);
							}else{
								orderFulfillment.addErrors(address.getErrors());
							}
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
					
					//Sets the status type
					orderFulfillment.setOrderFulfillmentInvStatType(orderFulfillment.getOrderFulfillmentInvStatType());
					orderFulfillment = this.saveOrderFulfillment( orderFulfillment );
                    //check the fulfillment and display errors if needed.
                    if (orderFulfillment.hasErrors()){
                        arguments.order.addError('addOrderItem', orderFulfillment.getErrors());
                    }

				} else {

					arguments.processObject.addError('fulfillmentMethodID', rbKey('validate.processOrder_addOrderitem.orderFulfillmentID.noValidFulfillmentMethod'));

				}

			}
			
			// Set Stock reference, check the fullfillment for a pickup location
			if (!isNull(orderFulfillment.getPickupLocation())){
				// The item being added to the cart should have its stockID added based on that location
				var location = orderFulfillment.getPickupLocation();
				var stock = getService("StockService").getStockBySkuAndLocation(sku=arguments.processObject.getSku(), location=location);
				
				//If we found a stock for that location, then set the stock to the process.
				if (!isNull(stock)){
					arguments.processObject.setStock(stock);
				}
			}

			// Check for the sku in the orderFulfillment already, so long that the order doens't have any errors
			if(!arguments.order.hasErrors()) {
				for(var i=arraylen(orderFulfillment.getOrderFulfillmentItems());i>0; i--  ){
				
					var orderItem = orderFulfillment.getOrderFulfillmentItems()[i];
					//evaluate existing stockHold
					if(arraylen(orderItem.getStockHolds())){
						//currently only supporting singular stockholds
						var stockHold = orderItem.getStockHolds()[1];
						if(stockHold.isExpired()){
							getService('stockService').deleteStockHold(stockHold);
							arguments.order.removeOrderItem(orderItem);
							continue;
						}
					}
					// If the sku, price, attributes & stock all match then just increase the quantity if and only if the match parent orderitem is null.
					if(
						arguments.processObject.matchesOrderItem( orderItem ) 
						&& isNull(orderItem.getParentOrderItem())
					){
						foundItem = true;
						var foundOrderItem = orderItem;
						foundOrderItem.setQuantity(orderItem.getQuantity() + arguments.processObject.getQuantity());
						if(!isNull(arguments.processObject.getSellOnBackOrderFlag()) && arguments.processObject.getSellOnBackorderFlag()){
							foundOrderItem.setSellOnBackOrderFlag(arguments.processObject.getSellOnBackorderFlag());
						}
						foundOrderItem.validate(context='save');
						
						if(foundOrderItem.hasErrors()) {
							//String replace the max order qty to give user feedback (with 0 as the minimum)
							var messageReplaceKeys = {
								quantityAvailable =  foundOrderItem.getMaximumOrderQuantity(),
								maxQuantity = foundOrderItem.getSku().setting('skuOrderMaximumQuantity')
							};
							
							for (var error in foundOrderItem.getErrors()){
								for (var errorMessage in foundOrderItem.getErrors()[error]){
									var message = getHibachiUtilityService().replaceStringTemplate( errorMessage , messageReplaceKeys);
									message = foundOrderItem.stringReplace(message);
								
									foundOrderItem.addError('addOrderItem', message, true);
									arguments.order.addError('addOrderItem', message, true);
								}

							}
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

			if (!isNull(arguments.processObject.getStock())){
				newOrderItem.setStock(arguments.processObject.getStock());
			}

			if (processObject.getSellOnBackOrderFlag() == true){
				newOrderItem.setSellOnBackOrderFlag(true); //used at the line item level to show it was sold out of stock.
			}
			
			
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
			newOrderItem.setSkuPrice( arguments.processObject.getSku().getPriceByCurrencyCode( arguments.order.getCurrencyCode(), arguments.processObject.getQuantity() ) );

			// If the sku is allowed to have a user defined price OR the current account has permissions to edit price
			if(
				(
					(!isNull(newOrderItem.getSku().getUserDefinedPriceFlag()) && newOrderItem.getSku().getUserDefinedPriceFlag())
					  ||
					(getHibachiScope().getLoggedInAsAdminFlag() && getHibachiAuthenticationService().authenticateEntityPropertyCrudByAccount(crudType='update', entityName='orderItem', propertyName='price', account=getHibachiScope().getAccount()))
				) && isNumeric(arguments.processObject.getPrice()) ) {
				newOrderItem.setPrice( arguments.processObject.getPrice() );
			} else {
				newOrderItem.setPrice( arguments.processObject.getSku().getPriceByCurrencyCode( arguments.order.getCurrencyCode(), arguments.processObject.getQuantity() ) );
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

			if(arguments.order.isNew()){
				this.saveOrder(arguments.order);
			}

			// Save the new order items
			newOrderItem = this.saveOrderItem( newOrderItem );

			if(newOrderItem.hasErrors()) {
				//String replace the max order qty to give user feedback with the minimum of 0
				var messageReplaceKeys = {
					quantityAvailable = newOrderItem.getMaximumOrderQuantity(),
					maxQuantity = newOrderItem.getSku().setting('skuOrderMaximumQuantity')
				};
				
 				for (var error in newOrderItem.getErrors()){
					for (var errorMessage in newOrderItem.getErrors()[error]){
						var message = getHibachiUtilityService().replaceStringTemplate( errorMessage , messageReplaceKeys);
						message = newOrderItem.stringReplace(message);
					
						arguments.order.addError('addOrderItem', message, true);
						newOrderItem.addError("addOrderItem", message, true);
					}
				}
			}else{
				//begin stock hold logic
				if(arguments.processObject.getSku().setting('skuStockHold')){
					var stockHold = getService('stockService').newStockHold();
					stockHold.setSku(arguments.processObject.getSku());
					stockHold.setOrderItem(newOrderItem);
					stockHold.setStock(arguments.processObject.getStock());
					stockHold.setStockHoldExpirationDateTime(dateAdd('n',arguments.processObject.getSku().setting('skuStockHoldTime'),now()));
					
					stockHold = getService('stockService').saveStockHold(stockHold);
				}
			}
		}

		// Applies only to order items for gift card skus
		if(arguments.processObject.getSku().isGiftCardSku()){
			
			var orderItem = "";
			if(foundItem){
				orderItem = foundOrderItem;
			} else {
				orderItem = newOrderItem;
			}

			// Additional processing when gift card codes manually provided or gift gard recipient(s) required
			if (!arguments.processObject.getSku().getGiftCardAutoGenerateCodeFlag() || arguments.processObject.getSku().getGiftCardRecipientRequiredFlag()) {

				// Retrieve gift card recipient data from order_addOrderItem process object
				var orderItemGiftCardRecipientData = arguments.processObject.getRecipients();

				if (!isNull(orderItemGiftCardRecipientData)) {

					// Loop over all gift card recipient data.
					for (var data in orderItemGiftCardRecipientData){
						
						// Note: OrderItemGiftRecipient entity is used to handle a couple use cases.
						// A small subset of its properties might used depending on the context, sku settings, order item fulfillment type
						// Entity may contain all recipient detail email/contact or simply for storage of manually provided gift card codes

						// Populate using the orderItemGiftRecipient data provided
						var orderItemGiftRecipient = this.newOrderItemGiftRecipient();
						orderItemGiftRecipient.populate(data);
						orderItemGiftRecipient.setOrderItem(orderItem);

						// Set values using process object
						// This process should really be done using a process like processOrderItem_AddGiftRecipient(..., {orderItemGiftRecipient=...}, 'create') so a new process object for each
						// Because same instance of a process object will be used for entire life of the order object
						// TODO: Refactor later
						addOrderItemGiftRecipientProcessObject = arguments.order.getProcessObject('addOrderItemGiftRecipient', {
							orderItem = orderItem,
							recipient = orderItemGiftRecipient
						});
						// Allows subproperty validation to occur on these objects
						addOrderItemGiftRecipientProcessObject.addPopulatedSubProperty('orderItem', orderItem);
						addOrderItemGiftRecipientProcessObject.addPopulatedSubProperty('recipient', orderItemGiftRecipient);
						
						// Run process to associate gift recipient with orderItem
						this.processOrder(arguments.order, {}, 'addOrderItemGiftRecipient');

						if (addOrderItemGiftRecipientProcessObject.hasErrors()) {
							if (addOrderItemGiftRecipientProcessObject.getRecipient().hasErrors()) {
								orderItem.addErrors(addOrderItemGiftRecipientProcessObject.getRecipient().getErrors());
								arguments.order.addErrors(addOrderItemGiftRecipientProcessObject.getRecipient().getErrors());
							}
						}
					}
				}
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

						eventRegistration.setEventRegistrationStatusType(getTypeService().getTypeBySystemCode("erstNotPlaced"));
						eventRegistration.generateAndSetAttendanceCode();

						if(depositsOnlyFlag) {
							eventRegistration.setOrderItem(depositOrderItem);
							eventRegistration.setSku(depositOrderItem.getSku());
						} else {
							eventRegistration.setOrderItem(newOrderItem);
							eventRegistration.setSku(newOrderItem.getSku());
						}

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

						if( depositsOnlyFlag || registrant.toWaitlistFlag == "1" ) {
							depositsCount++;

						}else {
								if( (arguments.processObject.getSku().getEventCapacity() > (currentRegistrantCount + salesCount) )  ) {
									salesCount++;

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

	public any function processOrderItem_AddRecipientsToOrderItem(required any orderItem, required any processObject){
		var recipients = arguments.processObject.getRecipients();
		if(!isNull(recipients)){
	        for(var i=1; i<=ArrayLen(recipients);i++){
				var recipientProcessObject = arguments.orderitem.getOrder().getProcessObject("addOrderItemGiftRecipient");
				var recipient = this.newOrderItemGiftRecipient();
				recipient = this.saveOrderItemGiftRecipient(recipient.populate(recipients[i]));
				recipientProcessObject.setOrderItem(arguments.orderitem);
				recipientProcessObject.setRecipient(recipient);
				this.processOrder_addOrderItemGiftRecipient(arguments.orderitem.getOrder(), recipientProcessObject);
			}
		}
        return arguments.orderItem;
	}

	// @hint Process to associate orderItem and orderItemGiftRecipient
	public any function processOrder_addOrderItemGiftRecipient(required any order, required any processObject){
		var orderItem = arguments.processObject.getOrderItem();
		var orderItemGiftRecipient = arguments.processObject.getRecipient();

		// Associate account if the recipient's email address matches an existing account email address
		if(orderItem.getSku().getGiftCardRecipientRequiredFlag() && isNull(orderItemGiftRecipient.getAccount())){
            if(!getDAO("AccountDAO").getPrimaryEmailAddressNotInUseFlag(orderItemGiftRecipient.getEmailAddress())){
				orderItemGiftRecipient.setAccount(getAccountService().getAccount(getDAO("AccountDAO").getAccountIDByPrimaryEmailAddress(orderItemGiftRecipient.getEmailAddress())));
            }
		}

		// Persist relationship between orderItem and orderItemGiftRecipient
        orderItemGiftRecipient = this.saveOrderItemGiftRecipient(orderItemGiftRecipient);

		// Save order
		if (!orderItemGiftRecipient.hasErrors()) {
			arguments.order = this.saveOrder(arguments.order);
		// Add any orderItemGiftRecipient errors to order
		} else {
			arguments.order.addErrors(orderItemGiftRecipient.getErrors());
		}

		return arguments.order;
	}

	public any function processOrder_addOrderPayment(required any order, required any processObject) {
		// Get the populated newOrderPayment out of the processObject
		var newOrderPayment = processObject.getNewOrderPayment();
		
		
		// If this is an existing account payment method, then we can pull the data from there
		if( arguments.processObject.getCopyFromType() == 'accountPaymentMethod' && len(arguments.processObject.getAccountPaymentMethodID())) {
			// Setup the newOrderPayment from the existing payment method
			var accountPaymentMethod = getAccountService().getAccountPaymentMethod( arguments.processObject.getAccountPaymentMethodID() );
			if ( accountPaymentMethod.getAccount().getAccountID() == arguments.order.getAccount().getAccountID() ){
				newOrderPayment.copyFromAccountPaymentMethod( accountPaymentMethod );
			} else {
				newOrderPayment.addError('orderPaymentID', "An issue occured while adding your Order Payment.");
			}
		// If they just used an exiting account address then we can try that by itself
		}else if(arguments.processObject.getCopyFromType() == 'previousOrderPayment' && len(arguments.processObject.getPreviousOrderPaymentID())){
			// Setup the newOrderPayment from the existing payment method
			var orderPayment = getService('OrderService').getOrderPayment(arguments.processObject.getPreviousOrderPaymentID());
			if ( orderPayment.getOrder().getOrderID() == arguments.order.getOrderID() ){
				newOrderPayment.copyFromOrderPayment( orderPayment );
			} else {
				newOrderPayment.addError('orderPaymentID', "An issue occured while adding your Order Payment.");
			}

		}else if(!isNull(arguments.processObject.getAccountAddressID()) && len(arguments.processObject.getAccountAddressID())) {
			var accountAddress = getAccountService().getAccountAddress( arguments.processObject.getAccountAddressID() );

			if(!isNull(accountAddress)) {
				newOrderPayment.setBillingAccountAddress(accountAddress);
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

        // If this was a giftCard payment
        if(!isNull(newOrderPayment.getPaymentMethod()) && newOrderPayment.getPaymentMethod().getPaymentMethodType() eq 'giftCard'){
            if((!len(arguments.processObject.getCopyFromType()) || arguments.processObject.getCopyFromType()=="accountGiftCard")
            	&& !isNull(arguments.processObject.getGiftCard())
            ){
	            var giftCard = arguments.processObject.getGiftCard();
            } else if(len(arguments.processObject.getAccountPaymentMethodID()) && getAccountService().getAccountPaymentMethod(arguments.processObject.getAccountPaymentMethodID()).isGiftCardAccountPaymentMethod()) {
            	var giftCard = getAccountService().getAccountPaymentMethod(arguments.processObject.getAccountPaymentMethodID()).getGiftCard();
            }
  			if(!isNull(giftCard)){
            	newOrderPayment.setGiftCardNumberEncrypted(giftCard.getGiftCardCode());
            	if( arguments.order.getPaymentAmountDue() > giftCard.getBalanceAmount() ){
					newOrderPayment.setAmount(giftCard.getBalanceAmount());
				} else {
					newOrderPayment.setAmount(arguments.order.getPaymentAmountDue());
				}
            } else {
            	newOrderPayment.addError('giftCard', rbKey('validate.giftCardCode.invalid'));
  			}
        }

		//Save the newOrderPayment
        this.saveOrderPayment(newOrderPayment);

        if(!newOrderPayment.hasErrors()){
			// We need to call updateOrderAmounts so that if the tax is updated from the billingAddress that change is put in place.
			getHibachiScope().flushORMSession();
			arguments.order = this.processOrder( arguments.order, 'updateOrderAmounts');

			// Save the newOrderPayment
			newOrderPayment = this.saveOrderPayment( newOrderPayment );

			//check if the order payments paymentMethod is set to allow account to save. if true set the saveAccountPaymentMethodFlag to true
			if (arguments.order.hasSavableOrderPaymentAndSubscriptionWithAutoPay()){
				for (var orderPayment in arguments.processObject.getOrder().getOrderPayments() ){
					if ((orderPayment.getStatusCode() == 'opstActive')
						&& !isNull(orderPayment.getPaymentMethod())
						&& !isNull(orderPayment.getPaymentMethod().getAllowSaveFlag())
						&& orderPayment.getPaymentMethod().getAllowSaveFlag()){
						arguments.processObject.setSaveAccountPaymentMethodFlag( true );
						break;
					}
				}
			}
		}
		// Attach 'createTransaction' errors to the order
		if(newOrderPayment.hasError('createTransaction')) {
			arguments.order.addError('addOrderPayment', newOrderPayment.getError('createTransaction'), true);

		} else if(newOrderPayment.hasErrors()) {
			
			
			arguments.order.addError('addOrderPayment', newOrderPayment.getErrors());
		// Otherwise if no errors, and we are supposed to save as accountpayment, and an accountPaymentMethodID doesn't already exist then we can create one.
		} else if (!newOrderPayment.hasErrors()
				&& ( arguments.processObject.getSaveAccountPaymentMethodFlag()
				|| (arguments.processObject.getSaveGiftCardToAccountFlag()
				&& (!isNull(giftCard) && isNull(giftCard.getOwnerAccount())) ))
				&& isNull(newOrderPayment.getAccountPaymentMethod())) {
			
			// Create a new Account Payment Method
			var newAccountPaymentMethod = getAccountService().newAccountPaymentMethod();
			// Attach to Account
			newAccountPaymentMethod.setAccount( arguments.order.getAccount() );

			// Setup name if exists
			if(!isNull(arguments.processObject.getSaveAccountPaymentMethodName())) {
				newAccountPaymentMethod.setAccountPaymentMethodName( arguments.processObject.getSaveAccountPaymentMethodName() );
			} else if (arguments.processObject.getSaveGiftCardToAccountFlag() && !isNull(giftCard)){
				newAccountPaymentMethod.setAccountPaymentMethodName( "Gift Card Ending " & left(giftCard.getGiftCardCode(), 4) );
			}

			// Attach Account To Gift Card
			if(arguments.processObject.getSaveGiftCardToAccountFlag()){
				var giftCardRedeemProcessObject = giftCard.getProcessObject("RedeemToAccount");
				giftCardRedeemProcessObject.setAccount( arguments.order.getAccount() );
				giftCard = this.getService("GiftCardService").processGiftCard(giftCard, giftCardRedeemProcessObject, "redeemToAccount");
			}

			// Copy over details
			newAccountPaymentMethod.copyFromOrderPayment( newOrderPayment );

			// Save it
			newAccountPaymentMethod = getAccountService().saveAccountPaymentMethod( newAccountPaymentMethod, {runSaveAccountPaymentMethodTransactionFlag=false} );

			newOrderPayment.setAccountPaymentMethod(newAccountPaymentMethod);
			if(newAccountPaymentMethod.hasErrors()){
				newOrderPayment.addErrors(newAccountPaymentMethod.getErrors());
			}
		}

		if(!newOrderPayment.hasErrors() && arguments.order.getOrderStatusType().getSystemCode() != 'ostNotPlaced' && newOrderPayment.getPaymentMethodType() == 'termPayment' && !isNull(newOrderPayment.getPaymentTerm())) {
			newOrderPayment.setPaymentDueDate( newOrderPayment.getPaymentTerm().getTerm().getEndDate() );
		}

		return arguments.order;
	}

	public any function processOrder_addPromotionCode(required any order, required any processObject) {
		var pc = getPromotionService().getPromotionCodeByPromotionCode(arguments.processObject.getPromotionCode());
		//if we can't find a promotion or the promotion is no longer active then show the invalid promo message
		if(isNull(pc) || !pc.getPromotion().getActiveFlag()) {
			arguments.processObject.addError("promotionCode", rbKey('validate.promotionCode.invalid'), true);
		//if we have a promotion but it doesn't fall within the promos startData end date show invalid datetime message
		} else if ( (!isNull(pc.getStartDateTime()) && pc.getStartDateTime() > now()) || (!isNull(pc.getEndDateTime()) && pc.getEndDateTime() < now()) || !pc.getPromotion().getCurrentFlag()) {
			arguments.processObject.addError("promotionCode", rbKey('validate.promotionCode.invaliddatetime'), true);
		//if we find an promocode is only valid for specific accounts and the order account is not in the list then show invalid account message
		} else if (arrayLen(pc.getAccounts()) && !pc.hasAccount(arguments.order.getAccount())) {
			arguments.processObject.addError("promotionCode", rbKey('validate.promotionCode.invalidaccount'), true);
		//if promo has a max account use and account related to order has used it more than the max account use, show over max account use message
		} else if( !isNull(pc.getMaximumAccountUseCount()) && !isNull(arguments.order.getAccount()) && pc.getMaximumAccountUseCount() <= getPromotionService().getPromotionCodeAccountUseCount(pc, arguments.order.getAccount()) ) {
			arguments.processObject.addError("promotionCode", rbKey('validate.promotionCode.overMaximumAccountUseCount'), true);
		//if promo has a max use and the promo has been used more than the max use than display the over max use message
		} else if( !isNull(pc.getMaximumUseCount()) && pc.getMaximumUseCount() <= getPromotionService().getPromotionCodeUseCount(pc) ) {
			arguments.processObject.addError("promotionCode", rbKey('validate.promotionCode.overMaximumUseCount'), true);
		//If promo site does not match order site, display incorrect site message
		} else if( 
			!isNull(pc.getPromotion().getSite())
			&& !isNull(arguments.order.getOrderCreatedSite())
			&& pc.getPromotion().getSite().getSiteID() != arguments.order.getOrderCreatedSite().getSiteID() 
		) {
			arguments.processObject.addError("promotionCode", rbKey('validate.promotionCode.incorrectSite'), true);
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
				var totalReceived = getService('HibachiUtilityService').precisionCalculate(orderPayment.getAmountReceived() - orderPayment.getAmountCredited());
				if(totalReceived gt 0) {
					var transactionData = {
						amount = totalReceived,
						transactionType = 'credit'
					};
					this.processOrderPayment(orderPayment, transactionData, 'createTransaction');
					
					if (orderPayment.hasErrors() && !isNull(orderPayment.getError('createTransaction'))){
						order.addError("cancelOrder", orderPayment.getErrors());
						return orderPayment; //stop processing this cancel on error.
					}
				}
			}
		}
				
		for(var orderItem in arguments.order.getOrderItems()){
			if(!isNull(orderItem.getStock())){
				getHibachiScope().addModifiedEntity(orderItem.getStock());
				getHibachiScope().addModifiedEntity(orderItem.getStock().getSkuLocationQuantity());
			}
		}

		// Change the status
		arguments.order.setOrderStatusType( getTypeService().getTypeBySystemCode("ostCanceled") );
		arguments.order.setOrderCanceledDateTime(now());
		
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
		if( !hasPaymentTransaction  && !arguments.order.isNew()) {
			this.deleteOrder( arguments.order );

		// Otherwise we can just remove the account so that it isn't remember as an open cart for this account
		} else if(!isNull(order.getAccount())) {

			order.removeAccount();
		}

		return this.newOrder();
	}

	public any function processOrder_create(required any order, required any processObject, required struct data={}) {
		//Setup Site Origin if using slatwall cms
		if(!isNull(getHibachiScope().getCurrentRequestSite()) && getHibachiScope().getCurrentRequestSite().isSlatwallCMS()){
			arguments.order.setOrderCreatedSite(getHibachiScope().getCurrentRequestSite());
		}else if ( !isNull(arguments.processObject.getOrderCreatedSite()) ) {
			arguments.order.setOrderCreatedSite(arguments.processObject.getOrderCreatedSite());
		}

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
			//set up as Test Order if account is a test account
			if(!isNull(account.getTestAccountFlag()) && account.getTestAccountFlag()){
				arguments.order.setTestOrderFlag(true);
			}
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

			// Generate Short Reference for Quote Number
			arguments.order.getShortReferenceID(true);

		}


		return arguments.order;
	}

	public any function processOrder_createReturn(required any order, required any processObject) {
		// Create a new return order
		var returnOrder = this.newOrder();
		returnOrder.setAccount( arguments.order.getAccount() );
		returnOrder.setOrderType( getTypeService().getTypeBySystemCode(arguments.processObject.getOrderTypeCode()));
		returnOrder.setCurrencyCode( arguments.order.getCurrencyCode() );
		returnOrder.setOrderCreatedSite( arguments.order.getOrderCreatedSite() );
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
		var originalOrderPayment = "";
		if (len(arguments.processObject.getRefundOrderPaymentID())) {
			originalOrderPayment = this.getOrderPayment( arguments.processObject.getRefundOrderPaymentID() );
		}

		
		var returnOrderPayment = this.newOrderPayment();
		var placeOrderData = {};

		// Referencing original order payment
		if (isObject(originalOrderPayment)) {
			var returnOrderPayment = this.newOrderPayment();
				returnOrderPayment.copyFromOrderPayment( originalOrderPayment );
				returnOrderPayment.setReferencedOrderPayment( originalOrderPayment );
				returnOrderPayment.setOrder( returnOrder );
				returnOrderPayment.setCurrencyCode( returnOrder.getCurrencyCode() );
				returnOrderPayment.setOrderPaymentType( getTypeService().getTypeBySystemCode( 'optCredit' ) );
				returnOrderPayment.setAmount( getService('HibachiUtilityService').precisionCalculate(returnOrder.getTotal() * -1) );

		// New return order payment, provided order payment information is not related to any previous order payments
		} else {

			// Manually populate for 'placeOrder' data, and set payment type as 'credit' rather than the default 'charge'
			placeOrderData.newOrderPayment = {};
			if (structKeyExists(arguments.data, 'newOrderPayment')) {
				placeOrderData.newOrderPayment = arguments.data.newOrderPayment;
			}
			placeOrderData.newOrderPayment.orderPaymentID = "";
			placeOrderData.newOrderPayment.order = { orderID = returnOrder.getOrderID() };
			placeOrderData.newOrderPayment.currencyCode = returnOrder.getCurrencyCode();
			placeOrderData.newOrderPayment.orderPaymentType = { typeID = getTypeService().getTypeBySystemCode( 'optCredit' ).getTypeID() };
			placeOrderData.newOrderPayment.amount = getService('HibachiUtilityService').precisionCalculate(returnOrder.getTotal() * -1);
			
			placeOrderData.accountPaymentMethodID = arguments.processObject.getAccountPaymentMethodID();
			placeOrderData.accountAddressID = arguments.processObject.getAccountAddressID();
			placeOrderData.saveAccountPaymentMethodFlag = arguments.processObject.getSaveAccountPaymentMethodFlag();
			placeOrderData.saveAccountPaymentMethodName = arguments.processObject.getSaveAccountPaymentMethodName();

			// For some unknown reason, without explicitly setting this to empty '' when null
			// The processOrder_addOrderPayment method will use 'accountPaymentMethod' and not be null instead, which is not desired
			if (!isNull(arguments.processObject.getCopyFromType())) {
				placeOrderData.copyFromType = arguments.processObject.getCopyFromType();
			} else {
				placeOrderData.copyFromType = '';
			}
		}
		
		// If the order doesn't have any errors, then we can flush the ormSession
		if(!returnOrder.hasErrors()) {
			getHibachiDAO().flushORMSession();
			if(arguments.processObject.getOrderTypeCode() eq "otReturnOrder" && orderItemFoundFlag) {
				// 'placeOrder' process will handle logic for the order payment
				returnOrder = this.processOrder(returnOrder, placeOrderData, 'placeOrder');

				if(!returnOrder.hasErrors()) {
					//if no errors and the order has a product with deferred revenue then check if we need to record a subscriptionOrderDeliveryItem
					for(var orderItem in returnOrder.getOrderItems()){
						if(orderItem.getSku().getProduct().getDeferredRevenueFlag()){
							var subscriptionOrderItem = orderItem.getReferencedOrderItem().getSubscriptionOrderItem();
							if(!isNull(subscriptionOrderItem)){
								var refundBalance = orderItem.getPrice() - subscriptionOrderItem.getDeferredRevenue();
								var refundTaxBalance = orderItem.getTaxAmount() - subscriptionOrderItem.getDeferredTaxAmount();
								//if refundBalance is greater than the deferredRevenue then we are balanceing previous deliveries, prorating, 
								//or providing a courteous refund greater than a single delivery
								if(refundBalance != 0 || refundTaxBalance != 0){
									var subscriptionOrderDeliveryItem = this.newSubscriptionOrderDeliveryItem();
									var subscriptionOrderDeliveryItemType = getService('TypeService').getTypeBySystemCode('soditRefunded');
									subscriptionOrderDeliveryItem.setSubscriptionOrderDeliveryItemType(subscriptionOrderDeliveryItemType);
									subscriptionOrderDeliveryItem.setEarned(refundBalance);
									subscriptionOrderDeliveryItem.setTaxAmount(refundTaxBalance);
									subscriptionOrderDeliveryItem.setQuantity(1);
									subscriptionOrderDeliveryItem.setSubscriptionOrderItem(subscriptionOrderItem);
									subscriptionOrderDeliveryItem = getService('subscriptionService').saveSubscriptionOrderDeliveryItem(subscriptionOrderDeliveryItem);
								}
							}
						}
					}
					
					// If the process object was set to automatically receive these items, then we will do that
					if((arguments.processObject.getReceiveItemsFlag() || arguments.processObject.getStockLossFlag())){
						var receiveData = {};
						receiveData.locationID = orderReturn.getReturnLocation().getLocationID();
						receiveData.orderReturnItems = [];
						receiveData.stockLossFlag = arguments.processObject.getStockLossFlag();
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

        //set the site placed so that it is available on return orders.
        if (!isNull( arguments.order.getOrderPlacedSite()) && isObject( arguments.order.getOrderPlacedSite())){
            newOrder.setOrderPlacedSite( arguments.order.getOrderPlacedSite() );
        }
        
        //set the site created so that it is available on return orders.
        if (!isNull( arguments.order.getOrderCreatedSite()) && isObject( arguments.order.getOrderCreatedSite())){
            newOrder.setOrderCreatedSite( arguments.order.getOrderCreatedSite() );
        }

		if (referencedOrderFlag == true){
			newOrder.setReferencedOrder(arguments.order);
			newOrder.setReferencedOrderType('duplicate');
		}

		//Copy Order Attribtes
		for(var attributeValue in arguments.order.getAttributeValues()) {
			newOrder.setAttributeValue( attributeValue.getAttribute().getAttributeCode(), attributeValue.getAttributeValue() );
		}

		// Copy Order Items
		for(var i=1; i<=arrayLen(arguments.order.getRootOrderItems()); i++) {

			var orderItemToDuplicate = arguments.order.getRootOrderItems()[i];

			var newOrderItem = this.copyToNewOrderItem(orderItemToDuplicate);

			var orderFulfillmentFound = false;

			// check if there is a fulfillment method of this type in the order
			for(var fulfillment in newOrder.getOrderFulfillments()) {
				if(orderItemToDuplicate.getOrderFulfillment().getFulfillmentMethod().getFulfillmentMethodID() == fulfillment.getFulfillmentMethod().getFulfillmentMethodID()) {
					var newOrderFulfillment = fulfillment;
					orderFulfillmentFound = true;
					break;
				}
			}

			// Duplicate Order Fulfillment
			if(!orderFulfillmentFound && !isNull(orderItemToDuplicate.getOrderFulfillment())) {
				var newOrderFulfillment = this.newOrderFulfillment();
				newOrderFulfillment.setFulfillmentMethod( orderItemToDuplicate.getOrderFulfillment().getFulfillmentMethod() );
				newOrderFulfillment.setOrder( newOrder );
				newOrderFulfillment.setCurrencyCode( orderItemToDuplicate.getOrderFulfillment().getCurrencyCode() );
				if(!isNull(orderItemToDuplicate.getOrderFulfillment().getShippingMethod())) {
					newOrderFulfillment.setShippingMethod( orderItemToDuplicate.getOrderFulfillment().getShippingMethod() );
				}

				// Personal Info
				if(copyPersonalDataFlag){
					if(!isNull(orderItemToDuplicate.getOrderFulfillment().getShippingAddress())) {
						newOrderFulfillment.setShippingAddress( orderItemToDuplicate.getOrderFulfillment().getShippingAddress().copyAddress( saveNewFlag ) );
					}
					if(!isNull(orderItemToDuplicate.getOrderFulfillment().getAccountAddress())) {
						newOrderFulfillment.setAccountAddress( orderItemToDuplicate.getOrderFulfillment().getAccountAddress() );
					}
					if(!isNull(orderItemToDuplicate.getOrderFulfillment().getEmailAddress())) {
						newOrderFulfillment.setEmailAddress( orderItemToDuplicate.getOrderFulfillment().getEmailAddress() );
					}
				}

			}
			newOrderItem.setOrder( newOrder );

			///bypass fulfillment for return orders
			if(!isNull(newOrderFulfillment)){
				newOrderItem.setOrderFulfillment( newOrderFulfillment );
			}

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

	public any function copyToNewOrderItem(required any orderItem){
		var newOrderItem = this.newOrderItem();

		newOrderItem.setPrice( arguments.orderItem.getPrice() );
		newOrderItem.setSkuPrice( arguments.orderItem.getSkuPrice() );
		newOrderItem.setCurrencyCode( arguments.orderItem.getCurrencyCode() );
		if(!isNull(arguments.orderItem.getBundleItemQuantity())){
			newOrderItem.setBundleItemQuantity(arguments.orderItem.getBundleItemQuantity());
		}
		newOrderItem.setQuantity(arguments.orderItem.getQuantity());
		newOrderItem.setOrderItemType( arguments.orderItem.getOrderItemType() );
		newOrderItem.setOrderItemStatusType( arguments.orderItem.getOrderItemStatusType() );
		newOrderItem.setSku( arguments.orderItem.getSku() );

		if(!isNull(arguments.orderItem.getStock())) {
			newOrderItem.setStock( arguments.orderItem.getStock() );
		}
		for(var attributeValue in arguments.orderItem.getAttributeValues()) {
			newOrderItem.setAttributeValue( attributeValue.getAttribute().getAttributeCode(), attributeValue.getAttributeValue() );
		}
		for(var recipient in arguments.orderItem.getOrderItemGiftRecipients()){
            var newRecipient = this.newOrderItemGiftRecipient();
            newRecipient.setFirstName(recipient.getFirstName());
            newRecipient.setLastName(recipient.getLastName());
            newRecipient.setEmailAddress(recipient.getEmailAddress());
            newRecipient.setGiftMessage(recipient.getGiftMessage());
            newRecipient.setQuantity(recipient.getQuantity());
            if(!isNull(recipient.getAccount())){
                newRecipient.setAccount(recipient.getAccount());
            }
            newRecipient.setOrderItem(newOrderItem);
        }
        for(var j=1; j<arrayLen(orderItem.getChildOrderItems()); j++){
			var newChildOrderItem = this.copyToNewOrderItem(orderItem.getChildOrderItems()[j]);
			newOrderItem.addChildOrderItem(newChildOrderItem);

		}

        return newOrderItem;
	}

	public boolean function hasQuantityWithinMaxOrderQuantity(any orderItem){
		return getDao('OrderDao').hasQuantityWithinMaxOrderQuantity(arguments.orderItem);
	}

	public boolean function hasQuantityWithinMinOrderQuantity(any orderItem) {
		return getDao('OrderDao').hasQuantityWithinMinOrderQuantity(arguments.orderItem);
	}

	public boolean function getOrderItemQuantitySumOnOrder(required any orderItem){
		return getDao('OrderDao').getOrderItemQuantitySumOnOrder(arguments.orderItem);
	}

    public boolean function getOrderItemCountOnOrder(required any orderItem){
        return getDao('OrderDao').getOrderItemCountOnOrder(arguments.orderItem);
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

	public boolean function isAllowedToPlaceOrderWithoutPayment(required any order, struct data = {}){

		if(getHibachiScope().getAccount().getAdminAccountFlag() && structKeyExists(arguments.data, 'newOrderPayment.paymentMethod.paymentMethodID') && arguments.data['newOrderPayment.paymentMethod.paymentMethodID'] == 'none'){
			return true;
		}

		for(var i=1; i<=arrayLen(arguments.order.getOrderItems()); i++) {
			//If the setting is null, or the setting is an empty string, or it has a value and the value is greater then 0...
			var settingValue = arguments.order.getOrderItems()[i].getSku().setting("skuMinimumPercentageAmountRecievedRequiredToPlaceOrder");
			if(isNull(settingValue) || len(settingValue) == 0 || val(settingValue) > 0){
				return false;
			}
		}
		return true;
	}

	public any function processOrder_placeOrder(required any order, struct data={}) {
		
		// First we need to lock the session so that this order doesn't get placed twice.
		lock scope="session" timeout="60" {
			arguments.order.setPlaceOrderFlag(true);
			// Reload the order in case it was already in cache
			getHibachiDAO().reloadEntity(arguments.order);
			// Make sure that the entity is notPlaced before going any further
			if(arguments.order.getOrderStatusType().getSystemCode() == "ostNotPlaced") {

				// Call the saveOrder method so that accounts, fulfillments & payments are updated
				arguments.order.validate('save');
				if(!arguments.order.hasErrors()){
					arguments.order = this.saveOrder(arguments.order, arguments.data);

					// As long as the order doesn't have any errors after updating fulfillment & payments we can continue
					if(!arguments.order.hasErrors()) {

						//Setup Site Origin if using slatwall cms
						if(!isNull(getHibachiScope().getSite()) && getHibachiScope().getSite().isSlatwallCMS()){
							arguments.order.setOrderPlacedSite(getHibachiScope().getSite());
						}

						//check if is payment is needed to place order and addPayment
						if(!this.isAllowedToPlaceOrderWithoutPayment(arguments.order, arguments.data) ||
							( arguments.order.isAllowedToPlaceOrderWithoutPayment(arguments.order, arguments.data) && arguments.order.getPaymentAmountTotal() > 0)
						){
							// If the orderTotal is less than the orderPaymentTotal, then we can look in the data for a "newOrderPayment" record, and if one exists then try to add that orderPayment
							if ((arguments.order.getTotal() != arguments.order.getPaymentAmountTotal() && structKeyExists(arguments.data, 'newOrderPayment'))
							|| (
								arguments.order.hasSavableOrderPaymentAndSubscriptionWithAutoPay()
								&& !arguments.order.hasSavedAccountPaymentMethod()
							)
							) {
								arguments.order = this.processOrder(arguments.order, arguments.data, 'addOrderPayment');
							}
						}



						//set an error
						if (this.validateHasNoSavedAccountPaymentMethodAndSubscriptionWithAutoPay(arguments.order)){
							arguments.order.addError('placeOrder',rbKey('entity.order.process.placeOrder.hasSubscriptionWithAutoPayFlagWithoutOrderPaymentWithAccountPaymentMethod_info'));
						}

						// Generate the order requirements list, to see if we still need action to be taken
						var orderRequirementsList = getOrderRequirementsList( arguments.order, arguments.data );
						
						// Verify the order requirements list, to make sure that this order has everything it needs to continue
						if(len(orderRequirementsList)) {

							if(listFindNoCase(orderRequirementsList, "account")) {
								arguments.order.addError('account',rbKey('entity.order.process.placeOrder.accountRequirementError'));
							}
							if(listFindNoCase(orderRequirementsList, "fulfillment")) {
								arguments.order.addError('fulfillment',rbKey('entity.order.process.placeOrder.fulfillmentRequirementError'));
							}
							if(listFindNoCase(orderRequirementsList, "return")) {
								arguments.order.addError('return',rbKey('entity.order.process.placeOrder.returnRequirementError'));
							}
							if(listFindNoCase(orderRequirementsList, "payment")) {

								arguments.order.addError('payment',rbKey('entity.order.process.placeOrder.paymentRequirementError'));

							}


						} else {

							// Setup a value to log the amount received, credited or authorized.  If any of these exists then we need to place the order
							var amountAuthorizeCreditReceive = 0;

							// Process All Payments and Save the ones that were successful
							if(!order.hasItemsQuantityWithinMaxOrderQuantity()){
								arguments.order.addError('orderItem','an orderitem is out of stock');	
							}
							
							//Sets the payment processing flag
							var orderDAO = getDAO("OrderDao");
							orderDAO.turnOnPaymentProcessingFlag(arguments.order.getOrderID()); 
							
							if(order.hasErrors()){
								
								arguments.order.setPaymentProcessingInProgressFlag(false);
								
							} else {
								// Process All Payments and Save the ones that were successful
								for(var orderPayment in arguments.order.getOrderPayments()) {
									// As long as this orderPayment is active then we can run the place order transaction
									if(orderPayment.getStatusCode() == 'opstActive') {
										orderPayment = this.processOrderPayment(orderPayment, {}, 'runPlaceOrderTransaction');
										amountAuthorizeCreditReceive = val(getService('HibachiUtilityService').precisionCalculate(amountAuthorizeCreditReceive + orderPayment.getAmountAuthorized() + orderPayment.getAmountReceived() + orderPayment.getAmountCredited()));
									}
								}

								arguments.order.setPaymentProcessingInProgressFlag(false);
								// Loop over the orderItems looking for any skus that are 'event' skus, and setting their registration value
								for(var orderitem in arguments.order.getOrderItems()) {
									var errors = orderItem.validate('save').getErrors();
									if(StructCount(errors)){
										for(var errorKey in errors){
											for(var message in errors[errorKey]){
												arguments.order.addError('orderItem',message);
											}
										}
									}
									
									if(orderitem.getSku().getBaseProductType() == "event") {
										if(!orderItem.getSku().getAvailableForPurchaseFlag() OR !orderItem.getSku().allowWaitlistedRegistrations() ){
											arguments.order.addError('payment','Event: #orderItem.getSku().getProduct().getProductName()# is unavailable for registration. The registration period has closed.');
										}
										if(!orderItem.hasEventRegistration()){
											arguments.order.addError('orderItem','Error when trying to register for: #orderItem.getSku().getProduct().getProductName()#. Please verify your registration details.');
										}
	
										if (!arguments.order.hasErrors()){
											for ( var eventRegistration in orderItem.getEventRegistrations() ) {
												// Set registration status - Should this be done when order is placed instead?
												if (orderItem.getOrderItemType().getSystemCode() == 'oitDeposit'){
													eventRegistration.setEventRegistrationStatusType(getTypeService().getTypeBySystemCode("erstWaitlisted"));
												}else if( orderitem.getSku().setting('skuRegistrationApprovalRequiredFlag')) {
													eventRegistration.setEventRegistrationStatusType(getTypeService().getTypeBySystemCode("erstPendingApproval"));
												}else if (orderitem.getSku().getAvailableSeatCount() > 0) {
													eventRegistration.setEventRegistrationStatusType(getTypeService().getTypeBySystemCode("erstRegistered"));
												}else{
													eventRegistration.setEventRegistrationStatusType(getTypeService().getTypeBySystemCode("erstWaitlisted"));
												}
											}
										}
									}
								}
							}

							// After all of the processing, double check that the order does not have errors.  If one of the payments didn't go through, then an error would have been set on the order.
							if((!arguments.order.hasErrors() || amountAuthorizeCreditReceive gt 0) && (arguments.order.getOrderPaymentAmountNeeded() == 0 || (arguments.order.getPaymentAmountTotal() == 0 && this.isAllowedToPlaceOrderWithoutPayment(arguments.order, arguments.data)))) {
	
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
									if((orderPayment.getStatusCode() == 'opstActive') && orderPayment.getPaymentMethodType() == 'termPayment' && !isNull(orderPayment.getPaymentTerm())) {
										orderPayment.setPaymentDueDate( orderPayment.getPaymentTerm().getTerm().getEndDate() );
									}
								}

								// Update the order status
								order.setOrderStatusType( getTypeService().getTypeBySystemCode("ostNew") );

								// Update the orderPlaced
								order.confirmOrderNumberOpenDateCloseDatePaymentAmount();

								// Save the order to the database
								getHibachiDAO().save( arguments.order );


								// if order had error but payment was captured, clear error and log to hibachi
								if(arguments.order.hasErrors()) {
									arguments.order.addMessage('paymentProcessedMessage', rbKey('entity.order.process.placeOrder.paymentProcessedMessage'));
									for(var errorName in arguments.order.getErrors()) {
										for(var i=1; i<=arrayLen(arguments.order.getErrors()[errorName]); i++) {
											logHibachi(message="Order was placed but it had an error with an errorName: #errorName# and errorMessage: #arguments.order.getErrors()[errorName][i]#", generalLog=true);
										}
									}
									arguments.order.getHibachiErrors().setErrors(structnew());
								}

								// Do a flush so that the order is commited to the DB
								getHibachiDAO().flushORMSession();

								// Log that the order was placed
								logHibachi(message="New Order Processed - Order Number: #order.getOrderNumber()# - Order ID: #order.getOrderID()#", generalLog=true);
	
								// Look for 'auto' order fulfillments
								createOrderDeliveriesForAutoFulfillmentMethod(arguments.order);

								// Flush again to really lock in that order status change
								getHibachiDAO().flushORMSession();
								
								for(var orderItem in arguments.order.getOrderItems()){
									if(!isNull(orderItem.getStock())){
										//via cascade calculate stock should update sku then product 
										getHibachiScope().addModifiedEntity(orderItem.getStock());
										getHibachiScope().addModifiedEntity(orderItem.getStock().getSkuLocationQuantity());
										getHibachiScope().flushORMSession();
									}else{
										//via cascade calculate stock should update product 
										getHibachiScope().addModifiedEntity(orderItem.getSku());
									}
								}
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

	public any function validateHasNoSavedAccountPaymentMethodAndSubscriptionWithAutoPay(order){
		if(!arguments.order.hasSavedAccountPaymentMethod() && arguments.order.hasSubscriptionWithAutoPay()){
			return true;
		}
		return false;
	}
	
	public any function createOrderDeliveriesForAutoFulfillmentMethod(required any order){
		for(var i=1; i<=arrayLen( order.getOrderFulfillments() ); i++) {
			//don't auto fulfill if the deposit has been paid but not the full amount.
			if (order.getOrderFulfillments()[i].isAutoFulfillment()) {
				var orderDelivery = createOrderDeliveryForAutoFulfillmentMethod(order.getOrderFulfillments()[i]);
				if (!isNull(orderDelivery) && orderDelivery.hasMessage('autoFulfillmentMessage')) {
					order.addMessage('autoFulfillmentMessage', orderDelivery.getMessages()['autoFulfillmentMessage'][1]);
				}
			}
		}
			//if already closed then no need to updateStatus
		if(arguments.order.getOrderStatusType().getSystemCode() neq 'ostClosed'){
			order = getService('orderService').processOrder(order,{},'updateStatus');
		}
	}
	
	
	
	public any function createOrderDeliveryForAutoFulfillmentMethod(required any orderFulfillment){
		// As long as the amount received for this orderFulfillment is within the treshold of the auto fulfillment setting
		if(
		    arguments.orderFulfillment.isAutoFulfillmentReadyToBeFulfilled()
		){
			// Setup the processData
			var newOrderDelivery = this.newOrderDelivery();
			var processData = {};
			processData.order = {};
			processData.order.orderID = arguments.orderFulfillment.getOrder().getOrderID();
			processData.location.locationID = arguments.orderFulfillment.getFulfillmentMethod().setting('fulfillmentMethodAutoLocation');
			processData.orderFulfillment.orderFulfillmentID = arguments.orderFulfillment.getOrderFulfillmentID();

			newOrderDelivery = this.processOrderDelivery(newOrderDelivery, processData, 'create');
			return newOrderDelivery;
		}
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
	/**
	 * The process method allows passing in 1 or more orderitems to remove as a batch.
	 *  Example: processOrder_removeOrderItem(order, {orderItemIDList="#id#,#id2#"})
	 */
	public any function processOrder_removeOrderItem(required any order, required struct data) {

		var orderItemsToRemove = [];
		var orderItemRemoved = false;

		// Make sure that an orderItemID was passed in
		if(structKeyExists(arguments.data, "orderItemIDList")) {
			orderItemsToRemove = listToArray(arguments.data.orderItemIDList);
		} else if(structKeyExists(arguments.data, "orderItemID")) {
			arrayAppend(orderItemsToRemove, arguments.data.orderItemID);
		}

		// Make sure there is something in the array
		if(arrayLen(orderItemsToRemove)) {

			// Loop over all of the items in this order - this loop happens in reverse to avoid a
			// concurrent invocation error caused by reading and modifying the array in the same request.
			for(var n = ArrayLen(orderItemsToRemove); n >=1; n--)	{
				var orderItem = this.getOrderItem(orderItemsToRemove[n]);
				if(arraylen(orderItem.getStockHolds())){
					//currently only supporting singular stockholds
					var stockHold = orderItem.getStockHolds()[1];
					if(stockHold.isExpired()){
						getService('stockService').deleteStockHold(stockHold);
						arguments.order.removeOrderItem(orderItem);
						continue;
					}
				}
				// Check to see if this item is the same ID as the one passed in to remove
				if(!isNull(orderItem) && arrayFindNoCase(orderItemsToRemove, orderItem.getOrderItemID())) {

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
							arguments.order.addError('removeOrderItem', rbKey('entity.order.process.removeOrderItem.parentFailsValidationError'));
						}
					}

					if(okToRemove) {
						// Delete this item
						this.deleteOrderItem( orderItem );
						orderItemRemoved = true;

					}
				}
			}

			// Call saveOrder to recalculate all the orderTotal stuff
			if(orderItemRemoved) {
				arguments.order = this.saveOrder(arguments.order);
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
			var  isOrderPaidFor = arguments.order.isOrderPaidFor();
			
			var isOrderFullyDelivered = arguments.order.isOrderFullyDelivered();
			
			if(!isOrderPaidFor){
				logHibachi('order is not fully paid for');
			}
			
			if(!isOrderFullyDelivered){
				logHibachi('order is not fully delivered #arguments.order.getQuantityUndelivered()# vs #arguments.order.getQuantityUnreceived()#');
			}
			
			if(isOrderPaidFor && isOrderFullyDelivered)	{
				arguments.order.setOrderStatusType(  getTypeService().getTypeBySystemCode("ostClosed") );
			// The default case is just to set it to processing if only one thing is done
			} else if(
				!arguments.order.getPlaceOrderFlag()
			){
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
		
		//Update the inventory Status Type
		orderFulfillment.setOrderFulfillmentInvStatusType(orderFulfillment.getOrderFulfillmentInvStatusType());
		
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

			
			if(arguments.order.getOrderStatusType().getSystemCode() == "ostNotPlaced") {
				//quote logic should freeze the price based on the expiration therefore short circuiting the logic
				if(
 					!arguments.order.getQuoteFlag() 
 					|| (
 						arguments.order.getQuoteFlag() && arguments.order.isQuotePriceExpired()
 					)
 				){
 					// Loop over the orderItems to see if the skuPrice Changed
					for(var orderItem in arguments.order.getOrderItems()){
						var skuPrice = val(orderItem.getSkuPrice());
						var SkuPriceByCurrencyCode = val(orderItem.getSku().getPriceByCurrencyCode(orderItem.getCurrencyCode(), orderItem.getQuantity()));
	 					
	 					if(
	 						listFindNoCase("oitSale,oitDeposit",orderItem.getOrderItemType().getSystemCode()) && skuPrice != SkuPriceByCurrencyCode
	 					){
	 						if(!orderItem.getSku().getUserDefinedPriceFlag()) {
	 							orderItem.setPrice(SkuPriceByCurrencyCode);
	 							orderItem.setSkuPrice(SkuPriceByCurrencyCode);
	 						}
						}
					}
 				}
			}

			// First Re-Calculate the 'amounts' base on price groups
			getPriceGroupService().updateOrderAmountsWithPriceGroups( arguments.order );

			// Then Re-Calculate the 'amounts' based on permotions ext.  This is done second so that the order already has priceGroup specific info added
			getPromotionService().updateOrderAmountsWithPromotions( arguments.order );

			// Re-Calculate tax now that the new promotions and price groups have been applied
		    	if(arguments.order.getPaymentAmountDue() != 0){
				getTaxService().updateOrderAmountsWithTaxes( arguments.order );
		    	}

			//update the calculated properties
			getHibachiScope().addModifiedEntity(arguments.order);

		}
		return arguments.order;
	}

	public numeric function getAmountToBeCapturedByCaptureAuthorizationPayments(required any orderDelivery, required any processObject){
		var amountToBeCaptured = arguments.processObject.getCapturableAmount();
		for(var orderPayment in arguments.processObject.getOrder().getOrderPayments()) {
			if(
				orderPayment.getStatusCode() == 'opstActive'
				&& orderPayment.getPaymentMethod().getPaymentMethodType() == "creditCard"
				&& orderPayment.getAmountUnreceived() > 0
				&& amountToBeCaptured > 0
			) {
				var transactionData = {
					transactionType = 'chargePreAuthorization',
					amount = amountToBeCaptured
				};

				if(transactionData.amount > orderPayment.getAmountUnreceived()) {
					transactionData.amount = orderPayment.getAmountUnreceived();
				}

				orderPayment = this.processOrderPayment(orderPayment, transactionData, 'createTransaction');

				if(!orderPayment.hasErrors()) {
					amountToBeCaptured = val(getService('HibachiUtilityService').precisionCalculate(amountToBeCaptured - transactionData.amount));
				}
			}
		}
		return amountToBeCaptured;
	}



	public any function addOrderFulfillmentItemsToOrderDelivery(required any orderDelivery, required any processObject){
		// Gift card OrderItems that are not eligible for auto-fulfillment
		var ineligibleGiftCardOrderItems = [];

		// Loop over delivery items from processObject and add them with stock to the orderDelivery
		for(var i=1; i<=arrayLen(arguments.processObject.getOrderFulfillment().getOrderFulfillmentItems()); i++) {

			// Local pointer to the orderItem
			var thisOrderItem = arguments.processObject.getOrderFulfillment().getOrderFulfillmentItems()[i];

			// Edge case, we can't assume all manual gift cards have been assigned
			// This exception occurs when gift card information doesn't exist yet for an orderItem which requires gift recipient and using manual gift card codes
			// This could be eliminated by updating a requirement that gift card code must be entered when adding the recipient to orderItem
			// Determine if gift card orderDeliveryItems are ineligible for auto-fulfillment
			var giftCardOrderItemIneligibleFlag = false;
			if (thisOrderItem.isGiftCardOrderItem() && thisOrderItem.getSku().getGiftCardRecipientRequiredFlag() && !thisOrderItem.getSku().getGiftCardAutoGenerateCodeFlag()) {
				giftCardOrderItemIneligibleFlag = true;
				arrayAppend(ineligibleGiftCardOrderItems, thisOrderItem);
			}

			if(thisOrderItem.getQuantityUndelivered() && !giftCardOrderItemIneligibleFlag) {
				// Create a new orderDeliveryItem
				var orderDeliveryItem = this.newOrderDeliveryItem();

				// Populate with the data
				orderDeliveryItem.setOrderItem( thisOrderItem );
				orderDeliveryItem.setQuantity( thisOrderItem.getQuantityUndelivered() );
				orderDeliveryItem.setStock( getStockService().getStockBySkuAndLocation(sku=orderDeliveryItem.getOrderItem().getSku(), location=arguments.orderDelivery.getLocation()));
				orderDeliveryItem.setOrderDelivery( arguments.orderDelivery );
			}

			// Add a message to the orderDelivery to inform that items were skipped. It was not an error with intial gift card functionality, and allows other orderItems to auto-fulfill
			if (arrayLen(ineligibleGiftCardOrderItems)) {
				orderDelivery.addMessage('autoFulfillmentMessage', rbKey('validate.create.OrderDelivery_Create.giftCardCodes.missingGiftCardCode'));
			}

		}
		return arguments.orderDelivery;
	}

	public any function addOrderDeliveryItemToOrderDeliveryStruct(
		required any orderDelivery,
		required struct orderDeliveryItemStuct
	){
		// Create a new orderDeliveryItem
		var newOrderDeliveryItem = this.newOrderDeliveryItem();

		// Populate with the data
		newOrderDeliveryItem.setOrderItem(
			this.getOrderItem(
				orderDeliveryItemStuct.orderItem.orderItemID
			)
		);
		newOrderDeliveryItem.setQuantity( orderDeliveryItemStuct.quantity );

		var stock = getStockService().getStockBySkuAndLocation(
			sku=newOrderDeliveryItem.getOrderItem().getSku(),
			location=arguments.orderDelivery.getLocation()
		);
		newOrderDeliveryItem.setStock(
			stock
		);
		newOrderDeliveryItem.setOrderDelivery( arguments.orderDelivery );
		return arguments.orderDelivery;
	}

	public any function addOrderDeliveryItemsToOrderDelivery(required any orderDelivery, required any processObject){
		// Loop over delivery items from processObject and add them with stock to the orderDelivery
		for(var i=1; i<=arrayLen(arguments.processObject.getOrderDeliveryItems()); i++) {
			var orderDeliveryItem = arguments.processObject.getOrderDeliveryItems()[i];
			if (orderDeliveryItem.quantity > 0) {
				addOrderDeliveryItemToOrderDeliveryStruct(arguments.orderDelivery,orderDeliveryItem);
			}
		}
		return arguments.orderDelivery;
	}
	
	private any function generateInvoiceNumber(required any processObject){
		var orderDeliveryCollectionList = this.getOrderDeliveryCollectionList();

		orderDeliveryCollectionList.addFilter("order.orderID", arguments.processObject.getOrder().getOrderID());
		
		var orderDeliveriesCount = orderDeliveryCollectionList.getRecordsCount();
		var invoiceNumber = "#arguments.processObject.getOrder().getOrderNumber()#-#orderDeliveriesCount#";
		
		return invoiceNumber;
	}
	
	public any function processOrderDelivery_generateShippingLabel(required any orderDelivery, required any processObject, struct data){
		//prevent overwriting existing labels

		if (
			(
				isNull(arguments.orderDelivery.getTrackingNumber())
				|| !len(arguments.orderDelivery.getTrackingNumber())
			)
			&& arguments.orderDelivery.getOrderFulfillment().hasShippingIntegration()
		) {

			//get the shipping integration from the previously attempting label generation 
			var shippingIntegrationCFC = getIntegrationService().getShippingIntegrationCFC(arguments.orderDelivery.getOrderFulfillment().getShippingIntegration());

			// Populates processObject trackingNumber and generates containerLabel if shipping.cfc has 'processShipmentRequest' method
			if(structKeyExists(shippingIntegrationCFC, 'processShipmentRequest')){
				shippingIntegrationCFC.processShipmentRequestWithOrderDelivery_generateShippingLabel(arguments.processObject);
			}
		}
		return arguments.orderDelivery;
	}

	// Process: Order Delivery
	public any function processOrderDelivery_create(required any orderDelivery, required any processObject, struct data={}) {
		var amountToBeCaptured = 0;

		// If we need to capture payments first, then we do that to make sure the rest of the delivery can take place
		if(arguments.processObject.getCaptureAuthorizedPaymentsFlag()) {
			 amountToBeCaptured = getAmountToBeCapturedByCaptureAuthorizationPayments(arguments.orderDelivery,arguments.processObject);
		}

		// As long as the amount to be captured is eq 0 then we can continue making the order delivery
		if(amountToBeCaptured == 0) {

			// Setup the header information
			arguments.orderDelivery.setOrder( arguments.processObject.getOrder() );
			arguments.orderDelivery.setLocation( arguments.processObject.getLocation() );
			arguments.orderDelivery.setFulfillmentMethod( arguments.processObject.getOrderFulfillment().getFulfillmentMethod() );

			// If this is a shipping fulfillment, then populate the correct values
			if(
				arguments.orderDelivery.getFulfillmentMethod().getFulfillmentMethodType() == "shipping"
			) {

				
				if (!isNull(arguments.processObject.getShippingMethod())){
 					arguments.orderDelivery.setShippingMethod( arguments.processObject.getShippingMethod() );
 				}

 				if (!isNull(arguments.processObject.getShippingAddress())){
 					arguments.orderDelivery.setShippingAddress( arguments.processObject.getShippingAddress().copyAddress( saveNewAddress=true ) );
 				}



				 // Setup the tracking number using shipping integration if trackingNumber not manually provided
				if (
					arguments.processObject.getUseShippingIntegrationForTrackingNumber()
					&& (
						isNull(arguments.processObject.getTrackingNumber())
						|| !len(arguments.processObject.getTrackingNumber())
					)
				) {
					var shippingIntegrationCFC = getIntegrationService().getShippingIntegrationCFC(arguments.processObject.getShippingIntegration());

					// Populates processObject trackingNumber and generates containerLabel if shipping.cfc has 'processShipmentRequest' method
					if(structKeyExists(shippingIntegrationCFC, 'processShipmentRequest')){
						shippingIntegrationCFC.processShipmentRequestWithOrderDelivery_Create(arguments.processObject);
					}
				}

				if(
					!isNull(arguments.processObject.getTrackingNumber())
					&& len(arguments.processObject.getTrackingNumber())
				) {
					arguments.orderDelivery.setTrackingNumber(arguments.processObject.getTrackingNumber());
				}

				if(
					!isNull(arguments.processObject.getContainerLabel())
					&& len(arguments.processObject.getContainerLabel())
				){
					arguments.orderDelivery.setContainerLabel(arguments.processObject.getContainerLabel());
				}
			}

			// If the orderFulfillmentMethod is auto, and there aren't any delivery items then we can just fulfill all that are "undelivered"
			if(
				(
					arguments.orderDelivery.getFulfillmentMethod().getFulfillmentMethodType() == "auto"
				|| (
					!isNull(arguments.orderDelivery.getFulfillmentMethod().getAutoFulfillFlag())
					&& arguments.orderDelivery.getFulfillmentMethod().getAutoFulfillFlag()
					)
				)
				&& !arrayLen(arguments.processObject.getOrderDeliveryItems())
			) {
				// Prepare orderDelivery to auto-fulfill all "undelivered" orderItems from orderFulfillment
				addOrderFulfillmentItemsToOrderDelivery(arguments.orderDelivery,arguments.processObject);

			} else {
				// Prepare orderDelivery to fulfill subset of "undelivered" orderItems using provided orderDeliveryItems
				addOrderDeliveryItemsToOrderDelivery(arguments.orderDelivery,arguments.processObject);
			}

			// Beyond this point orderDelivery.getOrderDeliveryItems() has populated with orderDeliveryItem data from the processObject

			// Manually populating arguments.data.giftCardCodes, necessary when gift card codes were provided using processOrder_addOrderItem() prior to this processOrderDelivery_create()
			// arguments.data.giftCardCodes will be used for orderDeliveryItem_createGiftCards() process
			if (!structKeyExists(arguments.data, 'giftCardCodes')) {
				arguments.data.giftCardCodes = [];
			}
			
			// Normalizing manual gift cards into arguments.data.giftCardCodes as they may be provided directly or need to be looked up from the OrderItemGiftRecipient
			for (var orderDeliveryItem in orderDelivery.getOrderDeliveryItems()) {
				var orderItem = orderDeliveryItem.getOrderItem();

				// Need to populate gift card code data needed later during gift card processing (orderItem with recipient will have giftCardCode stored in OrderItemGiftRecipient)
				if (orderItem.isGiftCardOrderItem() && !orderItem.getSku().getGiftCardAutoGenerateCodeFlag() && !orderItem.getSku().getGiftCardRecipientRequiredFlag()) {
					var giftCardCreateCount = 1;
					// Could be partial fulfillment
					for (var orderItemGiftRecipient in orderItem.getOrderItemGiftRecipients()) {

						// Check to make sure gift card code has not already been fulfilled and assigned
						if (!orderItemGiftRecipient.hasAllAssignedGiftCards() && giftCardCreateCount <= orderDeliveryItem.getQuantity()) {
							arrayAppend(arguments.data.giftCardCodes, {giftCardCode=orderItemGiftRecipient.getManualGiftCardCode(), orderItemID=orderItem.getOrderItemID()});
							giftCardCreateCount++;
						}
					}
				}
			}
			
			// Clean up if not needed
			if (!arrayLen(arguments.data.giftCardCodes)) {
				structDelete(arguments.data, 'giftCardCodes');
			}

			// Used to maintain state for gift card code processing and validation
			var orderDeliveryGiftCardCodes = [];
			var orderDeliveryGiftCardCodesPopulatedFlag = false;

			// Loop over the orderDeliveryItems to setup subscriptions and contentAccess
			for(var orderDeliveryItem in arguments.orderDelivery.getOrderDeliveryItems()) {
				
				// If the sku has a subscriptionTerm, then we can process the item to setupSubscription
				if(!isNull(orderDeliveryItem.getOrderItem().getSku().getSubscriptionTerm())) {
					orderDeliveryItem = this.processOrderDeliveryItem(orderDeliveryItem, {}, 'setupSubscription');
				}

				// If there are accessContents associated with this sku, then we can setupContentAccess
				if(arrayLen(orderDeliveryItem.getOrderItem().getSku().getAccessContents())) {
					orderDeliveryItem = this.processOrderDeliveryItem(orderDeliveryItem, {}, 'setupContentAccess');
				}
				
				// Create gift cards
				if (orderDeliveryItem.getOrderItem().isGiftCardOrderItem()) {
					
					// Manual gift card code orderDeliveryItems require special setup to use provided gift card codes
					var orderDeliveryItemGiftCardCodes = [];
					if (!orderDeliveryItem.getOrderItem().getSku().getGiftCardAutoGenerateCodeFlag()) {
							
						// find all gift card codes for the specific orderItem
						for (var giftCardCodeData in arguments.data.giftCardCodes) {
							if (!isNull(giftCardCodeData.giftCardCode)) {
								// Note: need to manage two arrays of gift card codes
								// 1. all gift card codes to be used for processObject validation to ensure no duplicates
								// 2. the subset of gift card codes associated with each orderDeliveryItem for giftCard creation

								// Keeping references of all gift card codes to be created for processObject validation
								// Population should only need to execute once and be used for all orderDeliveryItems
								if (!orderDeliveryGiftCardCodesPopulatedFlag) {
									arrayAppend(orderDeliveryGiftCardCodes, giftCardCodeData.giftCardCode);
								}

								// Gift card codes subset for those with this orderItem, matching on orderItemID
								if (orderDeliveryItem.getOrderItem().getOrderItemID() == giftCardCodeData.orderItemID) {
									// Add giftCardCode to array for further processing
									arrayAppend(orderDeliveryItemGiftCardCodes, giftCardCodeData.giftCardCode);
								}
							}
						}

						if (!orderDeliveryGiftCardCodesPopulatedFlag) {
							orderDeliveryGiftCardCodesPopulatedFlag = true;
						}
					}

					// The two gift card structures are not the same (ie. giftCardCodes is a subset of orderDeliveryGiftCardCodes)
					// It provides more data for the gift card code validation process during processOrderDeliveryItem_createGiftCards
					var orderDeliveryItemCreateGiftCardsData = {
						giftCardCodes = orderDeliveryItemGiftCardCodes, // gift card codes that only apply to order deliver item
						orderDeliveryGiftCardCodes = orderDeliveryGiftCardCodes // all gift card codes for entire order delivery
					};
					
					// Create the actual gift cards whether gift card code is auto generated or manually provided
					this.processOrderDeliveryItem(orderDeliveryItem, orderDeliveryItemCreateGiftCardsData, 'createGiftCards');

					// Add any gift card generation errors to the orderDelivery
					if (orderDeliveryItem.getProcessObject('createGiftCards').hasError('giftCardCodes')) {
						arguments.orderDelivery.addErrors(orderDeliveryItem.getProcessObject('createGiftCards').getErrors());
						// Halt further processing of orderDeliveryItems
						break;
					}
				}

			}

			// Save the orderDelivery
			arguments.orderDelivery = this.saveOrderDelivery(arguments.orderDelivery);
			this.saveOrderFulfillment( arguments.processObject.getOrderFulfillment() );
			
			//must flush otherwise the dao won't get the correct amount.
			if (!arguments.processObject.getOrderFulfillment().hasErrors()){
				ormFlush();
			}
			
			// generate invoice number for this order delivery
			arguments.orderDelivery.setInvoiceNumber(generateInvoiceNumber(arguments.processObject));
			
			// Update the orderFulfillmentStatus
			if (arguments.processObject.getOrderFulfillment().getQuantityUnDelivered() == 0) {
				arguments.processObject.getOrderFulfillment().setOrderFulfillmentStatusType( getTypeService().getTypeBySystemCode("ofstFulfilled") );
				
				for (var item in arguments.processObject.getOrderFulfillment().getOrderFulfillmentItems()){
					item.setOrderItemStatusType( getTypeService().getTypeBySystemCode("oistFulfilled"));
				}
			}
			
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

			// Loop over the orderDeliveryItems to setup subscriptions and contentAccess
			for(var orderDeliveryItem in arguments.orderDelivery.getOrderDeliveryItems()) {
				
				if(arguments.orderDelivery.getOrderFulfillment().getFulfillmentMethodType() == "email"){
					emailFulfillOrderDeliveryItem(orderDeliveryItem, arguments.orderDelivery);
				}

				// If the order picked up any erros when trying to process giftCard stuff, add those errors to the delivery
				if(arguments.processObject.getOrder().hasErrors()){
                	arguments.orderDelivery.addErrors(arguments.processObject.getOrder().getErrors());
              	}
			}

			saveOrderFulfillment( orderFulfillment );
		}
		return arguments.orderDelivery;
	}

	private any function emailFulfillOrderDeliveryItem(required any orderDeliveryItem, required any orderDelivery){
		if(orderDeliveryItem.getOrderItem().isGiftCardOrderItem()){
			for(var recipient in orderDeliveryItem.getOrderItem().getOrderItemGiftRecipients()){
				for(var giftCard in recipient.getGiftCards()){
					sendEmail(giftCard.getOwnerEmailAddress(), getSettingService().getSettingValue(settingname="skuGiftCardEmailFulfillmentTemplate", object=orderDeliveryItem.getSku()), giftCard);
				}
			}
		} else {
			sendEmail(arguments.orderDelivery.getOrderFulfillment().getEmailAddress(), getSettingService().getSettingValue(settingName='skuEmailFulfillmentTemplate', object=orderDeliveryItem.getSku()), orderDeliveryItem.getSku());
		}
	}

	private any function sendEmail(required any emailAddress, required any emailTemplateID, required any emailTemplateObject){
		var email = getEmailService().newEmail();
		var emailData = {
			emailTemplateID = emailTemplateID
		};
		emailData[emailTemplateObject.getClassName()] = emailTemplateObject;
		var email = getEmailService().processEmail_createFromTemplate(email, emailData);
		email.setEmailTo(emailAddress);
		email = getEmailService().sendEmail(email);
	}

	public any function processOrderDeliveryItem_createGiftCards(required any orderDeliveryItem, struct data={}, required any processObject) {
		var orderItem = arguments.orderDeliveryItem.getOrderItem();
		var term = orderItem.getSku().getGiftCardExpirationTerm();
		var giftCardCodes = arguments.data.giftCardCodes;
		
		if (!orderItem.getSku().getGiftCardRecipientRequiredFlag() && !orderItem.getSku().getGiftCardAutoGenerateCodeFlag()) {
			
			// Creates a simple lookup of the orderItemGiftRecipient by using giftCardCode as the key
			var orderItemGiftRecipientsByGiftCardCodeStruct = {};
			for (var orderItemGiftRecipient in orderItem.getOrderItemGiftRecipients()) {
				orderItemGiftRecipientsByGiftCardCodeStruct[orderItemGiftRecipient.getManualGiftCardCode()] = orderItemGiftRecipient;
			}

			for (var giftCardCode in giftCardCodes) {
				
				var giftCard = this.newGiftCard();
				var giftCard_create = giftCard.getProcessObject('create');
				
				// Expecting a one-to-one relationship between orderItem and orderItemGiftRecipient when manual gift card codes are required
				// However more refactoring with gift card validation could be done standardize and eliminate these sort of checks
				if (structKeyExists(orderItemGiftRecipientsByGiftCardCodeStruct, giftCardCode)) {
					giftCard_create.setOrderItemGiftRecipient(orderItemGiftRecipientsByGiftCardCodeStruct[giftCardCode]);
				}
				giftCard_create.setOriginalOrderItem(orderItem);
				giftCard_create.setGiftCardCode(giftCardCode);
				giftCard_create.setGiftCardPin("");
				giftCard_create.setOrderPayments(orderItem.getOrder().getOrderPayments());
				giftCard_create.setOwnerAccount(orderItem.getOrder().getAccount());
				giftCard_create.setOwnerEmailAddress(orderItem.getOrder().getAccount().getEmailAddress());
				giftCard_create.setOwnerFirstName(orderItem.getOrder().getAccount().getFirstName());
				giftCard_create.setOwnerLastName(orderItem.getOrder().getAccount().getLastName());
				giftCard_create.setCreditGiftCardFlag(true);
				giftCard_create.setCurrencyCode(orderItem.getOrder().getCurrencyCode());
				if (!isNull(term)) {
					giftCard_create.setGiftCardExpirationTerm(term);
				}

				// Create the gift card
				giftCard = getService("giftCardService").process(giftCard, giftCard_create, 'create');

				if(giftCard.hasErrors()){
					orderItem.getOrder().addErrors(giftCard.getErrors());
				}
			}
		} else if(!orderItem.getSku().getGiftCardRecipientRequiredFlag() && orderItem.getSku().getGiftCardAutoGenerateCodeFlag()){
			var totalGiftCardsNeeded = arguments.orderDeliveryItem.getQuantity();
			for(var i=1; i <= totalGiftCardsNeeded; i++){
				var giftCard = this.newGiftCard();
				var giftCard_create = giftCard.getProcessObject('create');
 				giftCard_create.setOriginalOrderItem(orderItem);
				giftCard_create.setGiftCardPin("");
				giftCard_create.setOrderPayments(orderItem.getOrder().getOrderPayments());
				giftCard_create.setOwnerAccount(orderItem.getOrder().getAccount());
				giftCard_create.setOwnerEmailAddress(orderItem.getOrder().getAccount().getEmailAddress());
				giftCard_create.setOwnerFirstName(orderItem.getOrder().getAccount().getFirstName());
				giftCard_create.setOwnerLastName(orderItem.getOrder().getAccount().getLastName());
				giftCard_create.setCreditGiftCardFlag(true);
				giftCard_create.setCurrencyCode(orderItem.getOrder().getCurrencyCode());
				if (!isNull(term)) {
					giftCard_create.setGiftCardExpirationTerm(term);
				}
 				// Create the gift card
				giftCard = getService("giftCardService").process(giftCard, giftCard_create, 'create');
 				if(giftCard.hasErrors()){
					orderItem.getOrder().addErrors(giftCard.getErrors());
				}
			}
		} else {

			// Possible one-to-many relationship between orderItemGiftRecipient and quantity of gift cards to create
			// Also need to consider case with partial fulfillments existing

			// Gift cards needs may fully or partially span across multiple OrderItemGiftRecipients attached to orderItem depending on quantities allocated to each
			var totalGiftCardsNeeded = arguments.orderDeliveryItem.getQuantity();
			var totalGiftCardsCreated = 0;

			// Helps keep track of which provided gift card codes have been allocated during the process
			var giftCardCodeIndex = 0;


			for(var orderItemGiftRecipient in orderItem.getOrderItemGiftRecipients()) {
				// Make sure orderItemGiftRecipient still needs gift cards created, it is possible it does not if prior orderDelivery occurred in partial fulfillment scenario
				if (totalGiftCardsCreated < totalGiftCardsNeeded && orderItemGiftRecipient.getNumberOfUnassignedGiftCards()) {

					// Determine how many of the total gift cards needed for this orderDeliveryItem can be allocated to this orderItemGiftRecipient
					var maxGiftCardsForOrderItemGiftRecipient = min(orderItemGiftRecipient.getNumberOfUnassignedGiftCards(), arguments.orderDeliveryItem.getQuantity());

					for(var i = 0; i < maxGiftCardsForOrderItemGiftRecipient; i++){
						var giftCard = this.newGiftCard();
						var giftCard_create = giftCard.getProcessObject('create');
	
						giftCard_create.setOrderItemGiftRecipient(orderItemGiftRecipient);
						giftCard_create.setOriginalOrderItem(orderItem);
	
						// Manual gift card code
						if(!orderItem.getSku().getGiftCardAutoGenerateCodeFlag()){
							giftCardCodeIndex++;
							giftCard_create.setGiftCardCode(giftCardCodes[giftCardCodeIndex]);
							giftCard_create.setGiftCardPin("");
						}
	
						giftCard_create.setOrderPayments(orderItem.getOrder().getOrderPayments());
	
						if(!isNull(orderItemGiftRecipient.getAccount())){
							giftCard_create.setOwnerAccount(orderItemGiftRecipient.getAccount());
							giftCard_create.setOwnerEmailAddress(orderItemGiftRecipient.getEmailAddress());
						} else {
							if(getDAO("AccountDAO").getPrimaryEmailAddressNotInUseFlag(orderItemGiftRecipient.getEmailAddress())) {
								giftCard_create.setOwnerAccount(getAccountService().getAccount(getDAO("AccountDAO").getAccountIDByPrimaryEmailAddress(orderItemGiftRecipient.getEmailAddress())));
								giftCard_create.setOwnerEmailAddress(orderItemGiftRecipient.getEmailAddress());
							} else {
								giftCard_create.setOwnerEmailAddress(orderItemGiftRecipient.getEmailAddress());
							}
						}
						giftCard_create.setOwnerFirstName(orderItemGiftRecipient.getFirstName());
						giftCard_create.setOwnerLastName(orderItemGiftRecipient.getLastName());
						giftCard_create.setCreditGiftCardFlag(true);
						giftCard_create.setCurrencyCode(orderItem.getOrder().getCurrencyCode());
						if(!isNull(term)){
							giftCard_create.setGiftCardExpirationTerm(term);
						}
	
						giftCard = getService("giftCardService").process(giftCard, giftCard_create, 'create');
						totalGiftCardsCreated++;
	
						if(giftCard.hasErrors()){
							arguments.order.addErrors(giftCard.getErrors());
						}
					}
				}
			}
		}
		
		return arguments.orderDeliveryItem;
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
			if(isNull(arguments.childOrderItem.getBundleItemQuantity())){
				arguments.childOrderItem.setBundleItemQuantity(arguments.childOrderItem.getQuantity());
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
	
	public any function processOrderFulfillment_changeFulfillmentMethod(required any orderFulfillment, required any processObject){
		
		if(isNull(arguments.processObject.getFulfillmentMethod())){
			return arguments.orderFulfillment;
		}
		//Set new fulfillment method
		arguments.orderFulfillment.setFulfillmentMethod(arguments.processObject.getFulfillmentMethod());
		
		var newFulfillmentMethodType = arguments.processObject.getFulfillmentMethod().getFulfillmentMethodType();
		
		//Clear unnecessary information
		if(newFulfillmentMethodType != 'shipping'){
			arguments.orderFulfillment.removeShippingAddress();
			arguments.orderFulfillment.removeShippingMethod();
		}
		if(newFulfillmentMethodType != 'pickup'){
			arguments.orderFulfillment.removePickupLocation();
		}
		if(newFulfillmentMethodType != 'email'){
			arguments.orderFulfillment.removeEmailAddress();
		}
		
		//Set Necessary information
		if(newFulfillmentMethodType == 'shipping'){
			//Try to get address from accountAddress
			var accountAddress = arguments.processObject.getShippingAccountAddress();
			if(!isNull(accountAddress)){
				arguments.orderFulfillment.setAccountAddress(accountAddress);
				arguments.orderFulfillment.setShippingAddress(accountAddress.getAddress());
				arguments.orderFulfillment.getOrder().setShippingAccountAddress(accountAddress);
				arguments.orderFulfillment.getOrder().setShippingAddress(accountAddress.getAddress());
			//Else try to get address from new address form
			}else if(!isNull(arguments.processObject.getShippingAddress())){
				var shippingAddress = arguments.processObject.getShippingAddress();
				getService('addressService').saveAddress(shippingAddress);
				if(!shippingAddress.hasErrors()){
					arguments.orderFulfillment.setShippingAddress(shippingAddress);
					arguments.orderFulfillment.getOrder().setShippingAddress(shippingAddress);
					if(arguments.processObject.getSaveShippingAccountAddressFlag()){
						//Create/save account address
						var accountAddress = getService('addressService').newAccountAddress();
						accountAddress.setAccountAddressName(arguments.processObject.getSaveShippingAccountAddressName());
						accountAddress.setAddress(shippingAddress);
						accountAddress.setAccount(arguments.orderFulfillment.getOrder().getAccount());
						getService('addressService').saveAccountAddress(accountAddress);
						if(!accountAddress.hasErrors()){
							arguments.orderFulfillment.setAccountAddress(accountAddress);
							arguments.orderFulfillment.getOrder().setShippingAccountAddress(accountAddress);
						}else{
							arguments.orderFulfillment.addErrors(accountAddress.getErrors());
						}
					}
				}else{
					arguments.orderFulfillment.addErrors(shippingAddress.getErrors());
				}
			}
		}
		if(newFulfillmentMethodType == 'pickup'){
			if(!isNull(arguments.processObject.getPickupLocation())){
				arguments.orderFulfillment.setPickupLocation(arguments.processObject.getPickupLocation());
			}
		}
		if(newFulfillmentMethodType == 'email'){
			var emailAddress = arguments.processObject.getEmailAddress();
			if(!isNull(emailAddress)){
				arguments.orderFulfillment.setEmailAddress(emailAddress);
				if(arguments.processObject.getSaveAccountEmailAddressFlag() && isNull(arguments.processObject.getAccountEmailAddress())){
					var accountEmailAddress = getService('accountService').newAccountEmailAddress();
					accountEmailAddress.setAccount(arguments.orderFulfillment.getOrder().getAccount());
					accountEmailAddress.setEmailAddress(emailAddress);
					getService('accountService').saveAccountEmailAddress(accountEmailAddress);
					if(accountEmailAddress.hasErrors()){
						arguments.orderFulfillment.addErrors(accountEmailAddress.getErrors());
					}
				}
			}
		}
		this.saveOrderFulfillment(arguments.orderFulfillment);
		return arguments.orderFulfillment;
		
	}

	// Process: Order Item
	public any function processOrderItem_updateEventRegistrationQuantity(required any orderItem,struct data={}) {

		// We need LESS event registrations due to order adjustment before order has been placed
		if( orderItem.getActiveEventRegistrations().getRecordsCount() > orderItem.getQuantity() && arguments.orderItem.getOrder().getStatusCode() == "ostNotPlaced" ) {

			var removableEvents = [];
			var numberToRemove = orderItem.getActiveEventRegistrations().getRecordsCount() - orderItem.getQuantity();

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
		if(orderItem.getActiveEventRegistrations().getRecordsCount() > orderItem.getQuantity()) {
			orderItem.addError('updateRegistrationQuantity', rbKey('validate.orderItem.quantity.tooManyEventRegistrations'));
		}

		// We need MORE event registrations due to order adjustment before order has been placed
		if(orderItem.getActiveEventRegistrations().getRecordsCount() < orderItem.getQuantity()) {
			for(var i=1; i <= orderItem.getQuantity() - orderItem.getActiveEventRegistrations().getRecordsCount(); i++ ) {
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
		var stockAdjustments = [];

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
					stockreceiverItem.setCurrencyCode(orderReturnItem.getCurrencyCode());

				}
				//create a stock adjustment with a comment for items that were added back in
				if(arguments.processObject.getStockLossFlag()){
					var newStockAdjustment = getStockService().newStockAdjustment();
					//stockadjustmentType:manual out
					var stockAdjustmentType = getStockService().getType('444df2e7dba550b7a24a03acbb37e717');
					newStockAdjustment.setStockAdjustmentType(stockAdjustmentType);
					newStockAdjustment.setFromLocation(location);
					var addStockAdjustmentItemData = {
						skuID=orderReturnItem.getSku().getSkuID(),
						quantity=thisRecord.quantity,
						stockAdjustment=newStockAdjustment
					};
					newStockAdjustment = getStockService().processStockAdjustment(newStockAdjustment,addStockAdjustmentItemData,'addStockAdjustmentItem');

					var comment = getCommentService().newComment();
					comment.setPublicFlag(false);
					comment.setComment(getHibachiScope().getRbKey('define.stockloss'));
					var commentRelationship = getCommentService().newCommentRelationship();
					commentRelationship.setStockAdjustment(newStockAdjustment);
					commentRelationship.setComment(comment);
					commentRelationship.setStockAdjustment(newStockAdjustment);
					commentRelationship = getCommentService().saveCommentRelationship(commentRelationship);
					comment = getCommentService().saveComment(comment,{});

					newStockAdjustment = getStockService().saveStockAdjustment(newStockAdjustment);
					arrayAppend(stockAdjustments,newStockAdjustment);
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

			// If there was one or more accountContentAccess associated with the referenced orderItem then we need to remove them.
			if(!isnull(stockReceiverItem.getOrderItem().getReferencedOrderItem())){
				var accountContentAccessSmartList = getAccountService().getAccountContentAccessSmartList();
				accountContentAccessSmartList.addFilter("OrderItem.orderItemID", stockReceiverItem.getOrderItem().getReferencedOrderItem().getOrderItemID());
				var accountContentAccesses = accountContentAccessSmartList.getRecords();
				for (var accountContentAccess in accountContentAccesses){

    				getAccountService().deleteAccountContentAccess( accountContentAccess );

				}
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

		for(var stockAdjustment in stockAdjustments) {
			getStockService().processStockAdjustment(stockAdjustment,{},'processAdjustment');
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

				var thisToCharge = val(getService('HibachiUtilityService').precisionCalculate(arguments.processObject.getAmount() - totalAmountCharged));

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
					val(getService('HibachiUtilityService').precisionCalculate(totalAmountCharged + paymentTransaction.getAmountReceived()));
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
				transactionData.preAuthorizationProvirederTransactionID = uncapturedAuthorizations[1].providerTransactionID;
			}

			// Run the transaction only if it hasn't already been processed or if it's an order cancellation
            if(!arguments.orderPayment.getGiftCardPaymentProcessedFlag() || transactionData.transactionType == 'credit'){
                paymentTransaction = getPaymentService().processPaymentTransaction(paymentTransaction, transactionData, 'runTransaction');
			}

            // If the paymentTransaction has errors, then add those errors to the orderPayment itself
			if(paymentTransaction.hasError('runTransaction')) {
				arguments.orderPayment.addError('createTransaction', paymentTransaction.getError('runTransaction'), true);
			} else {
                if(!isNull(arguments.orderPayment.getPaymentMethod().getPaymentMethodType()) && arguments.orderPayment.getPaymentMethodType() eq "giftCard"){
                    if(paymentTransaction.getAmountReceived() gt 0){
                         arguments.orderPayment.setGiftCardPaymentProcessedFlag("True");
                         arguments.orderPayment.setAmount(paymentTransaction.getAmountReceived());
                    } else if(paymentTransaction.getAmountCredited() gt 0){
                         arguments.orderPayment.setGiftCardPaymentProcessedFlag("True");
                         arguments.orderPayment.setAmount(paymentTransaction.getAmountCredited());
                    } else if (!arguments.orderPayment.getGiftCardPaymentProcessedFlag()){
                         arguments.orderPayment.setOrderPaymentStatusType( getTypeService().getTypeBySystemCode('opstInvalid') );
                         arguments.orderPayment.setAmount(0);
                    }
                    arguments.orderPayment = this.saveOrderPayment(arguments.OrderPayment);
                }
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
			transactionType = arguments.orderPayment.getPaymentMethod().getPlaceOrderChargeTransactionType();
		}
		if(!isNull(arguments.orderPayment.getPaymentMethod().getPlaceOrderCreditTransactionType()) && orderPayment.getOrderPaymentType().getSystemCode() eq "optCredit") {
			transactionType = arguments.orderPayment.getPaymentMethod().getPlaceOrderCreditTransactionType();
		}
		if(
			!isNull(arguments.orderPayment.getPaymentMethod().getSubscriptionRenewalTransactionType())
			&& structKeyExists(arguments.data,'isSubscriptionRenewal')
			&& arguments.data.isSubscriptionRenewal == true
		){
			transactionType = arguments.orderPayment.getPaymentMethod().getSubscriptionRenewalTransactionType();
		}
        if(arguments.orderPayment.getPaymentMethod().getPaymentMethodType() eq "giftCard"){
            transactionType = arguments.orderPayment.getOrderPaymentType().getTypeName();
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


			// Call the method below if getPlaceOrderChargeTransactionType = "Authorize"
			// then do another call for create transaction with transactionType = AuthAndCharge and amount = deposit amount
			// if the getPlaceOrderChargeTransactionType = "AuthandCharge", set the amount to deposit amount
			if (arguments.orderPayment.getOrder().hasDepositItemsOnOrder()){

				//if this is authorize and there is a deposit amount needed.
				/*if (arguments.orderPayment.getPaymentMethod().getPlaceOrderChargeTransactionType() == 'authorize'){
					//Only authorize for the deposit amount instead of the full amount.
					//processData.amount = arguments.orderPayment.getOrder().getTotalDepositAmount();

					//call the method below if getPlaceOrderChargeTransactionType = "Authorize"
					arguments.orderPayment = this.createTransactionAndCheckErrors(arguments.orderPayment, processData);

					// then do another call for create transaction with transactionType = AuthAndCharge and amount = deposit amount
					//set the transaction type and amount.
					if (!arguments.orderPayment.hasErrors()){
						arguments.orderPayment.clearProcessObject( 'createTransaction' );
						processData.transactionType = "authorizeAndCharge";
						processData.amount = arguments.orderPayment.getOrder().getTotalDepositAmount();
						arguments.orderPayment = this.createTransactionAndCheckErrors(arguments.orderPayment, processData);
					}
				// if the getPlaceOrderChargeTransactionType = "AuthandCharge", set the amount to deposit amount
				}else */
				if(arguments.orderPayment.getPaymentMethod().getPlaceOrderChargeTransactionType() == 'authorizeAndCharge'){

					//auth the full amount.
					/*	arguments.orderPayment.clearProcessObject( 'createTransaction' );
						processData.transactionType = "authorize";
						processData.amount = arguments.orderPayment.getOrder().getTotal();
						arguments.orderPayment = this.createTransactionAndCheckErrors(arguments.orderPayment, processData);
					*/
					// then do another call for create transaction with transactionType = auth and amount = payment amount due.
					//charge the partial amount.
					//if (!arguments.orderPayment.hasErrors()){
						//arguments.orderPayment.clearProcessObject( 'createTransaction' );
						//just set the deposit amount
						processData.transactionType = "authorizeAndCharge";
						processData.amount = arguments.orderPayment.getOrder().getTotalDepositAmount();
						arguments.orderPayment = this.createTransactionAndCheckErrors(arguments.orderPayment, processData);

					//}

				}

			}else{
				arguments.orderPayment = this.createTransactionAndCheckErrors(arguments.orderPayment, processData);
			}
		}
		return arguments.orderPayment;
	}

	public any function createTransactionAndCheckErrors(required any orderPayment, required any processData){
  		// Call the processing method
  		arguments.orderPayment = this.processOrderPayment(arguments.orderPayment, processData, 'createTransaction');

  		// If there was expected authorize, receive, or credit
  		/*
  		(arguments.orderPayment.getOrder().hasDepositItemsOnOrder() == true && listFindNoCase("authorize", processData.transactionType) && arguments.orderPayment.getAmountAuthorized() lt arguments.orderPayment.getOrder().getTotalDepositAmount())
  				||
  		*/
  		if(arguments.orderPayment.hasErrors()
  				||
  			(arguments.orderPayment.getOrder().hasDepositItemsOnOrder() == false && listFindNoCase("authorize", processData.transactionType) && arguments.orderPayment.getAmountAuthorized() lt arguments.orderPayment.getAmount())
  				||
  			(arguments.orderPayment.getOrder().hasDepositItemsOnOrder() == false && listFindNoCase("authorizeAndCharge,receive", processData.transactionType) && arguments.orderPayment.getAmountReceived() lt arguments.orderPayment.getAmount())
  				||
  			(arguments.orderPayment.getOrder().hasDepositItemsOnOrder() == true && listFindNoCase("authorizeAndCharge,receive", processData.transactionType) && arguments.orderPayment.getAmountReceived() lt arguments.orderPayment.getOrder().getTotalDepositAmount())
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
				var orderItem = arguments.order.getOrderItems()[i];
				//evaluate existing stockHold
				if(arraylen(orderItem.getStockHolds())){
					//currently only supporting singular stockholds
					var stockHold = orderItem.getStockHolds()[1];
					if(stockHold.isExpired()){
						getService('stockService').deleteStockHold(stockHold);
						getHibachiScope().addMessage('stockHoldExpired', rbKey('define.stockhold.stockHoldExpired') & ' ' & orderItem.getSku().getSkuDefinition());
						arguments.order.removeOrderItem(orderItem);
						continue;
					}
				}
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
		//if we have a new account address then override shippingaddress data. This must happen before populate
		if(
			(
				structKeyExists(arguments.data,'accountAddress.accountAddressID')
				&& len(arguments.data['accountAddress.accountAddressID'])
			)
			&& (
				isNull(arguments.orderFulfillment.getShippingAddress())
				|| arguments.data['accountAddress.accountAddressID'] != arguments.orderFulfillment.getShippingAddress().getAddressID()
			)
		) {
			var keyPrefix = 'shippingAddress';
			for(var key in arguments.data){
				if((left(key,len(keyPrefix)) == keyPrefix)){
					structDelete(arguments.data,key);
				}
			}
		}
		
		// We need to get the thirdPartyShippingAccountIdentifier from the data struct and set it on the orderFulfillment
		if(structKeyExists(arguments.data, 'thirdPartyShippingAccountIdentifier')){
			var thirdPartyShippingAccountIdentifier = arguments.data.thirdPartyShippingAccountIdentifier;
			arguments.orderfulfillment.setThirdPartyShippingAccountIdentifier(thirdPartyShippingAccountIdentifier);
		}
		
		// Call the generic save method to populate and validate
		arguments.orderFulfillment = save(arguments.orderFulfillment, arguments.data, arguments.context);

 		//Update the pickup location on the orderItem if the pickup location was updated on the orderFulfillment.
 		if(arguments.orderFulfillment.getFulfillmentMethodType() eq "pickup") {
 			if (!isNull(data.pickupLocation.locationID)){
 				var location = getService("LocationService").getLocation(data.pickupLocation.locationID);
 				if (!isNull(location)){
 					for (var orderItem in orderFulfillment.getOrderFulfillmentItems()){
 						//set the stock based on location.
 						var stock = getService("StockService").getStockBySkuAndLocation(sku=orderItem.getSku(), location=location);

 						if (!isNull(stock)){
 							orderItem.setStock(stock);
 							getService("OrderService").saveOrderItem(orderItem);
 						}
 					}
 				}
 			}
 		}

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
			&& (isNull(arguments.orderPayment.getAccountPaymentMethod()) || (!isNull(arguments.orderPayment.getAccountPaymentMethod()) && ListFindNoCase('authorize,authorizeAndCharge',arguments.orderPayment.getPaymentMethod().getSaveOrderPaymentTransactionType())))
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
		smartList.addKeywordProperty(propertyIdentifier="orderItemStatusType.typeName", weight=1);

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
			getHibachiScope().addModifiedEntity(order);

			getHibachiEventService().announceEvent("afterOrderItemDelete", arguments);
			getHibachiEventService().announceEvent("afterOrderItemDeleteSuccess", arguments);

			return true;
		}

		getHibachiEventService().announceEvent("afterOrderItemDelete", arguments);
		getHibachiEventService().announceEvent("afterOrderItemDeleteFailure", arguments);

		return false;
	}

	public any function deleteOrderPayment(required any orderPayment ) {

		// Check delete validation
		if(arguments.orderPayment.isDeletable()) {

			// Remove the primary fields so that we can delete this entity
			arguments.orderPayment.getOrder().removeOrderPayment( arguments.orderPayment );

			// Actually delete the entity
			getHibachiDAO().delete( arguments.orderPayment );

			return true;
		}

		return false;
	}
	public any function deleteShippingAddress( required any shippingAddress ) {

		// Check delete validation
		if(arguments.shippingAddress.isDeletable()) {

			// Remove the primary fields so that we can delete this entity
			var order = arguments.shippingAddress.getOrder();

			order.removeShippingAddress( arguments.shippingAddress );

			// Actually delete the entity
			getHibachiDAO().delete( arguments.shippingAddress );

			return true;
		}

		return false;
	}
	public any function deleteBillingAddress( required any billingAddress ) {

		// Check delete validation
		if(arguments.billingAddress.isDeletable()) {

			// Remove the primary fields so that we can delete this entity
			var order = arguments.billingAddress.getOrder();

			order.removeBillingAddress( arguments.billingAddress );

			// Actually delete the entity
			getHibachiDAO().delete( arguments.billingAddress );

			return true;
		}

		return false;
	}
	// =====================  END: Delete Overrides ===========================

	/** Given an orderfulfillment, this will return the shipping method options. */
	public any function getShippingMethodOptions(any orderFulfillment) {
		//update the shipping method options with the shipping service to insure qualifiers are re-evaluated    		
		getService("shippingService").updateOrderFulfillmentShippingMethodOptions( arguments.orderFulfillment );

		// At this point they have either been populated just before, or there were already options
		var optionsArray = [];
		var sortType = arguments.orderFulfillment.getFulfillmentMethod().setting('fulfillmentMethodShippingOptionSortType');
		
		for(var shippingMethodOption in arguments.orderFulfillment.getFulfillmentShippingMethodOptions()) {

			var thisOption = {};
			if(!isNull(arguments.orderFulfillment.getHandlingFee()) && arguments.orderFulfillment.getHandlingFee() > 0){
				thisOption['name'] = shippingMethodOption.getShippingMethodRate().getShippingMethod().getShippingMethodName();
			}else{
				thisOption['name'] = shippingMethodOption.getSimpleRepresentation();
			}
			thisOption['value'] = shippingMethodOption.getShippingMethodRate().getShippingMethod().getShippingMethodID();
			thisOption['totalCharge'] = shippingMethodOption.getTotalCharge();
			thisOption['totalChargeAfterDiscount'] = shippingMethodOption.getTotalChargeAfterDiscount();
			thisOption['shippingMethodSortOrder'] = shippingMethodOption.getShippingMethodRate().getShippingMethod().getSortOrder();
			if( !isNull(shippingMethodOption.getShippingMethodRate().getShippingMethod().getShippingMethodCode()) ){
				thisOption['shippingMethodCode'] = shippingMethodOption.getShippingMethodRate().getShippingMethod().getShippingMethodCode();
			}
			thisOption['publishedFlag'] = shippingMethodOption.getShippingMethodRate().getShippingMethod().getPublishedFlag();

			var inserted = false;

			arrayAppend(optionsArray, thisOption);
				}
		var sortProperty = "";
		if(sortType == 'price'){
			sortProperty = 'totalCharge';
		}else if(sortType == 'sortOrder'){
			sortProperty = 'shippingMethodSortOrder';
			}

		optionsArray = getService('hibachiUtilityService').arrayOfStructsSort(optionsArray,sortProperty);

		if(!arrayLen(optionsArray)) {
			arrayPrepend(optionsArray, {name=rbKey('define.select'), value=''});
		}
    	return optionsArray;
    }

	public any function hasOption(optionsArray, option){
		var found = false;
		for(var i=1; i<=arrayLen(optionsArray); i++) {
			var thisExistingOption = optionsArray[i];
			if (option.value == thisExistingOption.value){
				found = true;
				break;
			}
		}
		return found;
	}

	public any function getOrderAttributePropertylist(){
		var propertyList = '';
		if(structKeyExists(getService('AttributeService').getAttributeModel(),'Order')){
			var orderAttributeModel = getService('AttributeService').getAttributeModel().Order;
			if(!isNull(orderAttributeModel)){
				for(var attributeSetName in orderAttributeModel){
					var attributeSet = orderAttributeModel[attributeSetName];
					for(var attribute in attributeSet.attributes){
						propertyList = listAppend(propertyList, attribute, ',');
					}
				}
			}
		}

		return propertyList;
	}
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
		
		for(var stockHold in arguments.orderItem.getStockHolds()){
			getService('stockService').deleteStockHold(stockHold);
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
	
	public any function processOrder_reopenOrder(required any order, struct data={}) {
		arguments.order.setOrderStatusType(  getTypeService().getTypeBySystemCode("ostProcessing") );
		return arguments.order;
	}

	// ===================  END: Deprecated Functions =========================

}
