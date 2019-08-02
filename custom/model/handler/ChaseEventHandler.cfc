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
			var account = arguments.orderPayment.getOrder().getAccount(); // initiating an object of Accounts.
			// if credit card is Null exit.
			if(isNull(arguments.orderPayment.getCreditCardNumber()))
			{
				return;
			}
			
		requestBean.setTransactionType('generateToken'); // manually passing the transactionType as for token generation
		requestBean.setTransactionCurrencyCode(Order.getCurrencyCode());  //Transaction currency code
		requestBean.setOrderShortReferenceID(order.getShortReferenceID());
		requestBean.setCreditCardNumber(arguments.orderPayment.getCreditCardNumber());
		requestBean.setCreditCardType(arguments.orderPayment.getCreditCardType());
		requestBean.setSecurityCode(arguments.orderPayment.getSecurityCode());
		requestBean.setExpirationMonth(arguments.orderPayment.getExpirationMonth());
		requestBean.setExpirationYear(arguments.orderPayment.getExpirationYear());
		requestBean.setTransactionAmount(arguments.orderPayment.getAmount());
		requestBean.setAccountFirstName(account.getFirstName());
		requestBean.setAccountLastName(account.getLastName());
		requestBean.setBillingCity(arguments.orderPayment.getBillingAddress().getCity());
		requestBean.setBillingStateCode(arguments.orderPayment.getBillingAddress().getStateCode());
		requestBean.setBillingCountryCode(arguments.orderPayment.getBillingAddress().getCountryCode());
		requestBean.setBillingStreetAddress(arguments.orderPayment.getBillingAddress().getStreetAddress());
		requestBean.setBillingPostalCode(arguments.orderPayment.getBillingAddress().getPostalCode());
		var integration = new Slatwall.integrationServices.chase.Payment();  // initiating the chase integration object to access processCreditCard Method
		var response = integration.processCreditCard(requestBean); // declaring the callback response into a variable
		arguments.orderPayment.setChaseProviderToken(response.getProviderToken()); // storing the token in orderPayment entity.
		return;
			

		
	}
	
}