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

		// 	var cards = [
		// 		'4111111111111111', // 1. Visa
		// 	];
	
		var transactionTypes = [
			'transfer',			// 1
		];

		var values = {
		// selectedMerchant = '100161',
			currencyCode = 'USD',
		// 	testMode = true,
			amount = 10.00,
		// 	expMonth = '03',
		// 	expYear = '20',
		// 	cvn = '111', // 222 to invoke Failure
		// 	cardNumber = cards[1],
			transactionType = transactionTypes[1],
		// 	providerToken = '', // token_ex
		// 	originalAuthorizationProviderTransactionID = '', // authorizationID
		// 	originalChargeProviderTransactionID = '' // chargeID
		};
	
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
		// account.setFirstName("Jane");
		// account.setLastName("Smith");
		// address.setStreetAddress("123 ABC Street");
		// address.setStreet2Address("2nd Floor");
		// address.setCity("Worcester");
		// address.setStateCode("MA");
		// address.setPostalCode("01602");
		// address.setCountryCode("US");
		
		//writeDump(var=account.getAccountPaymentMethods()[1].getAccountPaymentMethodName(), top=1);
		//writeDump(var=account.getAccountPaymentMethods()[1].getCurrencyCode(), top=1);
		//writeDump(var=account.getAccountPaymentMethods()[1], top=1, abort=true);
	
		payment.copyFromAccountPaymentMethod(account.getAccountPaymentMethods()[1]);
		
		//writeDump(var=payment.getAmount(), top=1, abort=true)

		// Setup requestBean
		var requestBean = request.slatwallScope.getTransient('externalTransactionRequestBean');
		requestBean.setTransactionID(request.slatwallScope.getService("hibachiService").createHibachiUUID());
		requestBean.setTransactionAmount(payment.getAmount());
		requestBean.setTransactionCurrencyCode(payment.getCurrencyCode());
		requestBean.setTransactionType(values.transactionType);
		
		//writeDump(var=requestBean, top=1, abort=true);
		// 	// Token from generateToken
		// 	if (len(values.providerToken)) {
		// 		requestBean.setProviderToken(values.providerToken);
		// 	}
	
		// 	// AuthorizationID to use for 'chargePreAuthorization'
		// 	if (len(values.originalAuthorizationProviderTransactionID)) {
		// 		requestBean.setOriginalAuthorizationProviderTransactionID(values.originalAuthorizationProviderTransactionID);
		// 	}
	
		// 	// ChargeID to use for 'credit' or 'void'
		// 	if (len(values.originalChargeProviderTransactionID)) {
		// 		requestBean.setOriginalChargeProviderTransactionID(values.originalChargeProviderTransactionID);
		// 	}
	
		// 	requestBean.populatePaymentInfoWithOrderPayment( paymentTransaction.getPayment() );
	
		// 	// Verfify that we don't execute a transaction larger than 1.10 cents in live mode
		// 	if (!values.testMode && requestBean.getTransactionAmount() > 1.10) {
		// 		requestBean.setTransactionAmount(.05);
		// 	}
	
		// 	// Manual test override without needed to set integration testMode=false
		// 	// requestBean.getOrder().setTestOrderFlag(values.testMode);
		// 	writeDump("***Test mode: ");
		// 	writeDump({testMode = paymentIntegrationCFC.getTestModeFlag(requestBean, 'testMode'), transactionAmount = requestBean.getTransactionAmount()});
			
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
	
}