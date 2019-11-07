component extends="Slatwall.meta.tests.unit.SlatwallUnitTestBase" {

    public void function setUp() {
        super.setup();
        
        variables.service = variables.mockservice.getIntegrationServiceMock();
	}

	/**
	 * @test
	 */
	 
	public void function testAuthorize() {
		
		//Get Integration and Payment CFC
		var integrationCFC = request.slatwallScope.getBean("IntegrationService").getIntegrationByIntegrationPackage('hyperwallet');
		var paymentIntegrationCFC = createMock(object=request.slatwallScope.getBean("IntegrationService").getPaymentIntegrationCFC(integrationCFC));
	
		//Allowed Transaction types
		var transactionTypes = [
			'generateToken',			// 1
			'authorizeAndCharge',		// 2
			'authorize', 				// 3
			'chargePreAuthorization', 	// 4
			'credit',					// 5
			'void',						// 6
			'balance'
		];
	
		//Mock Payload
		var values = {
			currencyCode = 'USD',
			amount = 10.00,
			transactionType = transactionTypes[3]
		};
	
		// Setup objects
		var paymentTransaction = request.slatwallScope.getBean("paymentService").newPaymentTransaction();
		var payment = createMock(object=request.slatwallScope.getBean("paymentService").newOrderPayment());
		var order = createMock(object=request.slatwallScope.getBean('orderService').newOrder());
		var account = createMock(object=request.slatwallScope.getBean('accountService').getAccount('2c928084699c53da01699c672f82000b'));
		var address = createMock(object=request.slatwallScope.getBean('addressService').newAddress());
		var emailAddress = createMock(object=request.slatwallScope.getBean('accountService').newAccountEmailAddress());
		var site = createMock(object=request.slatwallScope.getBean('siteService').getSite('2c97808468a979b50168a97b20290021'));
		payment.setOrder(order);
		payment.setAmount(values.amount);
		payment.setCurrencyCode(values.currencyCode);
		order.setAccount(account);
		order.setOrderID(request.slatwallScope.getService("hibachiService").createHibachiUUID());
		order.setBillingAddress(address);
		order.setOrderCreatedSite(site);
		emailAddress.setAccount(account);
		emailAddress.setEmailAddress('irta.john@ten24web.com');		
		account.setPrimaryEmailAddress(emailAddress);
		account.setAccountID(request.slatwallScope.getService("hibachiService").createHibachiUUID());
		
		
		var moMoney = request.slatwallScope.getBean('paymentService').getAccountPaymentMethod('2c9280846bd82ef4016be77e88d0005a');

		payment.copyFromAccountPaymentMethod(moMoney);
		paymentTransaction.setOrderPayment(payment);
		
		// Setup requestBean
		var requestBean = request.slatwallScope.getTransient('externalTransactionRequestBean');
		requestBean.setTransactionID(request.slatwallScope.getService("hibachiService").createHibachiUUID());
		requestBean.setTransactionAmount(payment.getAmount());
		requestBean.setTransactionCurrencyCode(payment.getCurrencyCode());
		requestBean.setTransactionType(values.transactionType);
		requestBean.setProviderToken(moMoney.getProviderToken());
		requestBean.populatePaymentInfoWithOrderPayment( paymentTransaction.getPayment() );
		
		// Run transaction
		var responseBean = paymentIntegrationCFC.getAccountBalance(requestBean);
		//writeDump(var = responseBean, top = 2); abort;
		//assertFalse(responseBean.hasErrors());
			
			//Debugging
			debug({errors=responseBean.getErrors(), messages=responseBean.getMessages(), properties=[
				{'avsCode' = responseBean.getAVSCode()},
				{'authorizationCode' = responseBean.getAuthorizationCode()},
				{'amountAuthorized' = responseBean.getAmountAuthorized()},
				{'amountReceived' = responseBean.getAmountReceived()},
				{'amountCredited' = responseBean.getAmountCredited()},
				{'statusCode' = responseBean.getStatusCode()},
				{'providerToken' = responseBean.getProviderToken()},
				{'providerTransactionID' = responseBean.getProviderTransactionID()},
				{'securityCodeMatchFlag' = responseBean.getSecurityCodeMatchFlag()},
			]});
	}
	
	/**
	 * @test
	 */
	//public void function 
	
}