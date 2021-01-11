component extends="Slatwall.model.service.OrderService" {

	property name="hibachiDAO";
	property name="orderDAO";
	property name="productDAO";
	property name="promotionDAO";

	property name="accountService";
	property name="addressService";
	property name="commentService";
	property name="emailService";
	property name="eventRegistrationService";
	property name="fulfillmentService";
	property name="giftCardService";
	property name="hibachiUtilityService";
	property name="hibachiEntityQueueService";
	property name="hibachiAuthenticationService";
	property name="integrationService";
	property name="locationService";
	property name="paymentService";
	property name="priceGroupService";
	property name="promotionService";
	property name="settingService";
	property name="shippingService";
	property name="siteService";
	property name="skuService";
	property name="stockService";
	property name="subscriptionService";
	property name="taxService";
	property name="typeService";

	// ====================== START: Save Overrides ===========================

	public any function saveOrder(required any order, struct data={}, string context="save", boolean updateOrderAmounts=false, boolean updateShippingMethodOptions=false, boolean checkNewAccountAddressSave=true) {

		// Call the generic save method to populate and validate
		arguments.order = save(entity=arguments.order, data=arguments.data, context=arguments.context);
		
		if(structKeyExists(arguments.data, 'updateOrderAmounts')){
			arguments.updateOrderAmounts = arguments.data.updateOrderAmounts;
		}
		
		if(structKeyExists(arguments.data, 'updateShippingMethodOptions')){
			arguments.updateShippingMethodOptions = arguments.data.updateShippingMethodOptions;
		}
		
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
				// if(!arrayFind(orderFulfillmentsInUse, orderFulfillment.getOrderFulfillmentID())) {
				// 	orderFulfillment.removeOrder();

				// // If is is still in use, and a shipping fulfillment then we need to update some stuff.
				// } else 
				if(orderFulfillment.getFulfillmentMethodType() eq "shipping") {

					if(arguments.updateShippingMethodOptions){
						// Update the shipping methods
						getShippingService().updateOrderFulfillmentShippingMethodOptions( orderFulfillment );
					}
					
					if(arguments.checkNewAccountAddressSave){
						// Save the accountAddress if needed
						orderFulfillment.checkNewAccountAddressSave();
					}
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
		if(!arguments.order.hasErrors() && arguments.updateOrderAmounts) {
			this.logHibachi('saveOrder updateOrderAmounts');
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

	public any function saveOrderFulfillment(required any orderFulfillment, struct data={}, string context="save", boolean updateOrderAmounts=false, boolean updateShippingMethodOptions=false) {
		super.saveOrderFulfillment(argumentCollection=arguments);
	}

	public any function saveOrderItem(required any orderItem, struct data={}, string context="save", boolean updateOrderAmounts=false,boolean updateCalculatedProperties=false, boolean updateShippingMethodOptions=true) {
		super.saveOrderItem(argumentCollection=arguments);
	}
}
