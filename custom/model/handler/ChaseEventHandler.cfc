component extends="Slatwall.org.Hibachi.HibachiEventHandler" {
	// this method basically hi-jacks the request for orderPayment or while placing an order for token generation.
	public void function beforeOrderPaymentProcess_CreateTransaction(required any slatwallScope, required any orderPayment){
			var orderID = arguments.orderPayment.getOrder().getOrderID();  // getOrderId()
			var orderItemCollectionList = getService('orderService').getOrderItemCollectionList(); // get collection list
			orderItemCollectionList.addFilter("order.orderID",orderID); // filtering by orderID
			orderItemCollectionList.addFilter("sku.product.productType.systemCode","printSubscription", "=", "AND", "", "subscriptionfilters"); // filtering for subscription
			orderItemCollectionList.addFilter("sku.product.productType.systemCode","bundleSubscription", "=", "OR", "", "subscriptionfilters"); // filtering for subscription
			if(orderItemCollectionList.getRecordsCount()==0)
			{
			// if it's no records exists in a printSubscription or bundleSubscription then just return.
			return;
			}
			// this block executes only & only if it is a print/bundle Subscription
			var requestBean = new Slatwall.model.transient.payment.CreditCardTransactionRequestBean();  // Request Bean Object initiation
			var order = arguments.orderPayment.getOrder(); // initiating the Order object.
			var orderPayment = arguments.orderPayment.getOrderPayment(); // initiating an object of orderPayment.
			var account = arguments.orderPayment.getOrder().getAccount(); // initiating an object of Accounts.
			// if credit card is Null exit.
			if(isNull(orderPayment.getCreditCardNumber()))
			{
				return;
			}
			
		requestBean.setTransactionType('generateToken'); // manually passing the transactionType as for token generation
		requestBean.setTransactionCurrencyCode(Order.getCurrencyCode());  //Transaction currency code
		requestBean.setOrderShortReferenceID(order.getShortReferenceID());
		requestBean.setCreditCardNumber(orderPayment.getCreditCardNumber());
		requestBean.setCreditCardType(orderPayment.getCreditCardType());
		requestBean.setSecurityCode(orderPayment.getSecurityCode());
		requestBean.setExpirationMonth(orderPayment.getExpirationMonth());
		requestBean.setExpirationYear(orderPayment.getExpirationYear());
		requestBean.setTransactionAmount(orderPayment.getAmount());
		requestBean.setAccountFirstName(account.getFirstName());
		requestBean.setAccountLastName(account.getLastName());
		requestBean.setBillingCity(orderPayment.getBillingAddress().getCity());
		requestBean.setBillingStateCode(orderPayment.getBillingAddress().getStateCode());
		requestBean.setBillingCountryCode(orderPayment.getBillingAddress().getCountryCode());
		requestBean.setBillingStreetAddress(orderPayment.getBillingAddress().getStreetAddress());
		requestBean.setBillingPostalCode(orderPayment.getBillingAddress().getPostalCode());
		var integration = new Slatwall.integrationServices.chase.Payment();  // initiating the chase integration object to access processCreditCard Method
		var response = integration.processCreditCard(requestBean); // declaring the callback response into a variable
		orderPayment.setChaseProviderToken(response.getProviderToken()); // storing the token in orderPayment entity.
		return;
			

		
	}
	
}