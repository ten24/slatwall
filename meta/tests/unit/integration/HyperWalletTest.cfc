component extends="Slatwall.meta.tests.unit.SlatwallUnitTestBase" {

    public void function setUp() {
        super.setup();
        
        variables.service = variables.mockservice.getIntegrationServiceMock();
	}

	/**
	 * @test
	 */
	 
	public void function processTransfer() {
		
		var integrationCFC = request.slatwallScope.getBean("IntegrationService").getIntegrationByIntegrationPackage('hyperWallet');
		var paymentIntegrationCFC = createMock(object=request.slatwallScope.getBean("IntegrationService").getPaymentIntegrationCFC(integrationCFC));

		var transactionTypes = [
			'generateToken',			// 1
			'authorizeAndCharge',		// 2
			'authorize', 				// 3
			'chargePreAuthorization', 	// 4
			'credit',					// 5
			'void'						// 6
		];

		var values = {
			currencyCode = 'USD',
			amount = 10.00,
			transactionType = transactionTypes[3]};
	
		// Setup objects
		var paymentTransaction = request.slatwallScope.getBean("paymentService").newPaymentTransaction();
		var payment = createMock(object=request.slatwallScope.getBean("paymentService").newOrderPayment());
		var order = createMock(object=request.slatwallScope.getBean('orderService').newOrder());
		var account = createMock(object=request.slatwallScope.getBean('accountService').getAccount('2c928084699c53da01699c672f82000b'));
		var address = createMock(object=request.slatwallScope.getBean('addressService').newAddress());
		var emailAddress = createMock(object=request.slatwallScope.getBean('accountService').newAccountEmailAddress());
		paymentTransaction.setOrderPayment(payment);
		payment.setOrder(order);
		order.setAccount(account);
		order.setOrderID(request.slatwallScope.getService("hibachiService").createHibachiUUID());
		order.setBillingAddress(address);
		emailAddress.setAccount(account);
		emailAddress.setEmailAddress('irta.john@ten24web.com');		
		account.setPrimaryEmailAddress(emailAddress);
		account.setAccountID(request.slatwallScope.getService("hibachiService").createHibachiUUID());

		payment.copyFromAccountPaymentMethod(account.getAccountPaymentMethods()[1]);
		
		// Setup requestBean
		var requestBean = request.slatwallScope.getTransient('externalTransactionRequestBean');
		requestBean.setTransactionID(request.slatwallScope.getService("hibachiService").createHibachiUUID());
		requestBean.setTransactionAmount(payment.getAmount());
		requestBean.setTransactionCurrencyCode(payment.getCurrencyCode());
		requestBean.setTransactionType(values.transactionType);
		
		// Run transaction
		var responseBean = paymentIntegrationCFC.processTransfer(requestBean);
			
		// 	// Debugging
		// 	debug({errors=responseBean.getErrors(), messages=responseBean.getMessages(), properties=[
		// 		{'avsCode' = responseBean.getAVSCode()},
		// 		{'authorizationCode' = responseBean.getAuthorizationCode()},
		// 		{'amountAuthorized' = responseBean.getAmountAuthorized()},
		// 		{'amountReceived' = responseBean.getAmountReceived()},
		// 		{'amountCredited' = responseBean.getAmountCredited()},
		// 		{'statusCode' = responseBean.getStatusCode()},
		// 		{'providerToken' = responseBean.getProviderToken()},
		// 		{'providerTransactionID' = responseBean.getProviderTransactionID()},
		// 		{'securityCodeMatchFlag' = responseBean.getSecurityCodeMatchFlag()},
		// 	]});
	}
	
	
	/**
	 * @test
	 */
	public void function processAccount() {
		
		var integrationCFC = request.slatwallScope.getBean("IntegrationService").getIntegrationByIntegrationPackage('hyperWallet');
		var paymentIntegrationCFC = createMock(object=request.slatwallScope.getBean("IntegrationService").getPaymentIntegrationCFC(integrationCFC));

		var transactionTypes = [
			'generateToken',			// 1
			'authorizeAndCharge',		// 2
			'authorize', 				// 3
			'chargePreAuthorization', 	// 4
			'credit',					// 5
			'void'						// 6
		];

		var values = {
			currencyCode = 'USD',
			amount = 10.00,
			transactionType = transactionTypes[1]};
	
		// Setup objects
		var account = createMock(object=request.slatwallScope.getBean('accountService').newAccount());
		var address = createMock(object=request.slatwallScope.getBean('addressService').newAddress());
		var emailAddress = createMock(object=request.slatwallScope.getBean('accountService').newAccountEmailAddress());
		emailAddress.setAccount(account);
		emailAddress.setEmailAddress('irta.john@ten24web.com');		
		account.setPrimaryEmailAddress(emailAddress);
		account.setAccountID(request.slatwallScope.getService("hibachiService").createHibachiUUID());
		account.setFirstName("Irta");
		account.setLastName("John");
		address.setStreetAddress("123 ABC St");
		address.setStreet2Address("");
		address.setCity("Worcester");
		address.setStateCode("MA");
		address.setPostalCode("01608");
		address.setCountryCode("US");
		
		// Setup requestBean
		var requestBean = request.slatwallScope.getTransient('externalTransactionRequestBean');
		requestBean.setTransactionID(request.slatwallScope.getService("hibachiService").createHibachiUUID());

		// Run transaction
		var responseBean = paymentIntegrationCFC.processAccount(requestBean);
			
	}
	
}