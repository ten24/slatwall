component extends="Slatwall.meta.tests.unit.SlatwallUnitTestBase" {

    public void function setUp() {
        super.setup();
        
        variables.service = variables.mockservice.getIntegrationServiceMock();
        /**
         * usr-2a1b0086-538d-4125-82f4-b16a3d26e37b
         **/
        variables.accountPaymentMethodID = '2c9280846bd82ef4016be77e88d0005a';
        variables.accountID = '2c928084699c53da01699c672f82000b';
        variables.orderID = '2c9180856b8e1aeb016b8e9ec98e0133';
        
        //Allowed Transaction types
		variables.transactionTypes = [
			'generateToken',			// 1
			'authorizeAndCharge',		// 2
			'authorize', 				// 3
			'chargePreAuthorization', 	// 4
			'credit',					// 5
			'void',						// 6
			'balance',					// 7
			'receive',					// 8
			'vendorBalance'				// 9
		];
		
		variables.integrationCFC = request.slatwallScope.getBean("IntegrationService").getIntegrationByIntegrationPackage('hyperwallet');
		variables.paymentIntegrationCFC = createMock(object=request.slatwallScope.getBean("IntegrationService").getPaymentIntegrationCFC(integrationCFC));
	}

	/**
	 * @test
	 */
	public void function testPayment() {
		
		//Mock Payload
		var values = {
			currencyCode = 'USD',
			amount = 1.00,
			transactionType = variables.transactionTypes[2]
		};
	
		// Setup objects
		var paymentTransaction = request.slatwallScope.getBean("paymentService").newPaymentTransaction();
		var payment = createMock(object=request.slatwallScope.getBean("paymentService").newOrderPayment());
		var order = createMock(object=request.slatwallScope.getBean('orderService').newOrder());
		var account = createMock(object=request.slatwallScope.getBean('accountService').getAccount(variables.accountID));
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
		emailAddress.setEmailAddress('gaurav.singh@ten24web.com');
		account.setPrimaryEmailAddress(emailAddress);
		account.setAccountID(request.slatwallScope.getService("hibachiService").createHibachiUUID());
		
		var moMoney = request.slatwallScope.getBean('paymentService').getAccountPaymentMethod(variables.accountPaymentMethodID);
		//2c9280846bd82ef4016be77e88d0005a
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
		var responseBean = variables.paymentIntegrationCFC.processExternal(requestBean);
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
	public void function testPaymentRefund() {
		//Mock Payload
		var values = {
			currencyCode = 'USD',
			amount = 1.00,
			transactionType = variables.transactionTypes[5]
		};
		
		var moMoney = request.slatwallScope.getBean('paymentService').getAccountPaymentMethod(variables.accountPaymentMethodID);
		
		// Setup requestBean
		var requestBean = request.slatwallScope.getTransient('externalTransactionRequestBean');
		requestBean.setTransactionID(request.slatwallScope.getService("hibachiService").createHibachiUUID());
		requestBean.setTransactionAmount(values.amount);
		requestBean.setTransactionCurrencyCode(values.currencyCode);
		requestBean.setTransactionType(values.transactionType);
		requestBean.setProviderToken(moMoney.getProviderToken());
		
		// Run transaction
		var responseBean = variables.paymentIntegrationCFC.processExternal(requestBean);
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
	public void function testGetBalance() {
		var requestBean = request.slatwallScope.getTransient('externalTransactionRequestBean');
		
		var moMoney = request.slatwallScope.getBean('paymentService').getAccountPaymentMethod('#variables.accountPaymentMethodID#');
		requestBean.setProviderToken(moMoney.getProviderToken()); //Set Provider Token
		requestBean.setTransactionType(variables.transactionTypes[7]);
		var responseBean = variables.paymentIntegrationCFC.processExternal(requestBean);
		writeDump("Account Balance : #responseBean.getAmountAuthorized()#");
		
		requestBean = request.slatwallScope.getTransient('externalTransactionRequestBean');
		requestBean.setTransactionType(variables.transactionTypes[9]);
		var responseBean = variables.paymentIntegrationCFC.processExternal(requestBean);
		writeDump("Vendor Balance : #responseBean.getAmountAuthorized()#");
	}
}