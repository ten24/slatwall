component extends="Slatwall.meta.tests.unit.SlatwallUnitTestBase" {

    public void function setUp() {
        super.setup();

        variables.service = variables.mockservice.getIntegrationServiceMock();
        variables.accountID = '2c9180846d25c254016d25c3aeb8000d';
        variables.paymentMethodID = '2c948084703439470170349c5458006a';
        variables.accountPaymentMethodID = "2c948084703439470170349c5458006a";
		variables.orderID = "2c91808270310aa3017034d04e8800ab";

        variables.paymentNonce = "a10fdd08-c132-08c8-72d7-1956e65cd610"; //One Time Use
        //3eeadf19-43c8-010d-676e-65d664f71072
        variables.token = "cGF5bWVudG1ldGhvZF9wcF82ZjY3dHY";

        //Allowed Transaction types
		variables.transactionTypes = [
			'generateToken',			// 1
			'authorizeAndCharge',		// 2
			'authorize', 				// 3
			'chargePreAuthorization', 	// 4
			'credit',					// 5
			'void',						// 6
			'authorizeAccount',		    // 7
			'externalHTML',				// 8
			'authorizePayment'			// 9
		];

		variables.integrationCFC = request.slatwallScope.getBean("IntegrationService").getIntegrationByIntegrationPackage('braintree');
		variables.paymentIntegrationCFC = createMock(object=request.slatwallScope.getBean("IntegrationService").getPaymentIntegrationCFC(integrationCFC));
	}

	/**
	 * @test
	 * Test Account Authorize Method
	 **/
	 public void function testAuthorizeAccount()
	 {
	     var requestBean = request.slatwallScope.getTransient('externalTransactionRequestBean');
	     requestBean.setTransactionType(variables.transactionTypes[7]);

	     var account = createMock(object=request.slatwallScope.getBean('accountService').getAccount('#variables.accountID#'));
	     requestBean.setAccount(account);

	     var responseBean = variables.paymentIntegrationCFC.processExternal(requestBean);

	     if(responseBean.hasErrors())
	     {
	         dump(responseBean.getErrors());
	     }
	     else{
	         dump(responseBean);
	     }
	 }

	/**
	 * @test
	 * Test External HTML Method
	 **/
	 public void function testExternalPaymentHTML()
	 {
        var requestBean = request.slatwallScope.getTransient('externalTransactionRequestBean');
        requestBean.setTransactionType(variables.transactionTypes[8]);

        var account = createMock(object=request.slatwallScope.getBean('accountService').getAccount('#variables.accountID#'));
        requestBean.setAccount(account);
        //Mock Payload
		var values = {
			currencyCode = 'USD',
			amount = 1.00
		};
		requestBean.setTransactionAmount(values.amount);
		requestBean.setTransactionCurrencyCode(values.currencyCode);

        var responseBean = variables.paymentIntegrationCFC.processExternal(requestBean);
        if(isObject(responseBean) && responseBean.hasErrors())
        {
            dump(responseBean.getErrors());
        }
        else{
            dump(responseBean);
        }
	 }

	 /**
      * @test
      * Test Authorize Payment Method
      **/  
    public void function testAuthorizePayment()
    {
    	var requestBean = request.slatwallScope.getTransient('externalTransactionRequestBean');
    	requestBean.setProviderToken(variables.paymentNonce);
 		requestBean.setTransactionType(variables.transactionTypes[9]);
		var responseBean = variables.paymentIntegrationCFC.processExternal(requestBean);
		writeDump(responseBean); abort;
    }

    /**
      * @test
      * Test Authorize Payment Method
      **/  
    public void function testAddNewPaymentMethod()
    {
        //var paymentMethod = request.slatwallScope.getService('paymentService').getPaymentMethodByPaymentIntegration(variables.integrationCFC);
		// writeDump(var = paymentMethod.getPaymentMethodID(), top = 2); abort;

    	var account = request.slatwallScope.getAccount('#variables.accountID#');
    	if(!isNull(account.getPaymentMethod()) && !isNull(account.getPaymentMethod().getPaymentIntegration()) && account.getPaymentMethod().getPaymentIntegration().getIntegrationPackage() == 'braintree')
    	{
    		//get existing payment method
    		var accountPaymentMethod = "";
    	}
    	else
    	{
    		var paymentIntegration = request.slatwallScope.getService('integrationService').getIntegrationByIntegrationPackage('braintree');
    		var paymentMethod = request.slatwallScope.getService('paymentService').getPaymentMethodByPaymentIntegration(paymentIntegration);

    		//Create a New One
            var accountPaymentMethod = request.slatwallScope.getService('accountService').newAccountPaymentMethod();
            accountPaymentMethod.setAccountPaymentMethodName("PayPal - Braintree");
            accountPaymentMethod.setAccount( account );
            accountPaymentMethod.setPaymentMethod( paymentMethod );
    	}


    	//Update / Save provider Token
    	accountPaymentMethod.setProviderToken(variables.token);

    	//Save method in account.
        request.slatwallScope.getService('accountService').saveAccountPaymentMethod(accountPaymentMethod);
        ormFlush();
    }

	 /**
	 * @test
	 * Test Create Transaction Method
	 **/
	 public void function testCreateTransaction()
	 {
	 	var order = request.slatwallScope.getService('OrderService').getOrder(variables.orderID);
	 	var requestBean = request.slatwallScope.getTransient('externalTransactionRequestBean');
    	var accountPaymentMethod = request.slatwallScope.getBean('paymentService').getAccountPaymentMethod(variables.accountPaymentMethodID);
    	
    	requestBean.setProviderToken(accountPaymentMethod.getProviderToken());
 		requestBean.setTransactionType(variables.transactionTypes[2]);
 		requestBean.setOrder(order);
 		
		var responseBean = variables.paymentIntegrationCFC.processExternal(requestBean);
		writeDump(responseBean); abort;
	 }

	 /**
	 * 
	 * Test Create Transaction Method
	 **/
	 public void function testRefundTransaction()
	 {
	    var transactionID = "dHJhbnNhY3Rpb25fbjJ6ZGtuNmM";
	 	var integrationCFC = request.slatwallScope.getBean("IntegrationService").getIntegrationByIntegrationPackage('braintree');
 		var paymentIntegrationCFC = createMock(object=request.slatwallScope.getBean("IntegrationService").getPaymentIntegrationCFC(integrationCFC));

        var paymentMethod = request.slatwallScope.getBean("PaymentService").getPaymentMethod(paymentMethodID);

        var response = paymentIntegrationCFC.refundTransaction(paymentMethod, transactionID);
        writeDump(response);
	 }


} 