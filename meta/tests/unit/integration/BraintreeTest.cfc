component extends="Slatwall.meta.tests.unit.SlatwallUnitTestBase" {

    public void function setUp() {
        super.setup();
        
        //bc6e5629-23c7-0bf7-7137-da11e4e58355

        variables.service = variables.mockservice.getIntegrationServiceMock();
        
        variables.paymentMethodID = '2c9580846bfaeee2016bfaf16f440006';
        variables.accountID = '2c9180846d25c254016d25c3aeb8000d';
        variables.orderID = '2c9180856b8e1aeb016b8e9ec98e0133';
        
        variables.braintree_token = "cGF5bWVudG1ldGhvZF9wcF84NDZtc2s";
        
        //Allowed Transaction types
		variables.transactionTypes = [
			'generateToken',			// 1
			'authorizeAndCharge',		// 2
			'authorize', 				// 3
			'chargePreAuthorization', 	// 4
			'credit',					// 5
			'void',						// 6
			'authorizeAccount',		    // 7
			'externalHTML'				// 8
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
            
        }
	 }
	 
	 /**
      * @test
      * Test Authorize Payment Method
      **/  
    public void function testAuthorizePayment()
    {
        var paymentMethod = request.slatwallScope.getBean("PaymentService").getPaymentMethod(paymentMethodID);
        
        //configureAccountPaymentMethod
	 	var integrationCFC = request.slatwallScope.getBean("IntegrationService").getIntegrationByIntegrationPackage('braintree');
 		var paymentIntegrationCFC = createMock(object=request.slatwallScope.getBean("IntegrationService").getPaymentIntegrationCFC(integrationCFC));
 		var response = paymentIntegrationCFC.authorizePayment(paymentMethod, variables.braintree_token);
 		debug(response);
    }
	 
	/**
    * @test
    * Account Payment Method Assignment
    **/
    public void function testConfigureAccountPaymentMethod()
    {
        var paymentMethod = request.slatwallScope.getBean("PaymentService").getPaymentMethod(paymentMethodID);
	 	var integrationCFC = request.slatwallScope.getBean("IntegrationService").getIntegrationByIntegrationPackage('braintree');
 		var paymentIntegrationCFC = createMock(object=request.slatwallScope.getBean("IntegrationService").getPaymentIntegrationCFC(integrationCFC));
 		
 		var cart = request.slatwallScope.getService('OrderService').getOrder(orderID = "2c9180856b8e1aeb016b8e6d511f00b4");
 		
        paymentIntegrationCFC.configureAccountPaymentMethod(variables.braintree_token, cart.getAccount(), paymentMethod);
        ormFlush();
    }
    
    
    /**
    * @test
    * Test Account Payment Token Assignment
    **/
    public void function testAccountPaymentToken()
    {
        var paymentMethod = request.slatwallScope.getBean("PaymentService").getPaymentMethod(paymentMethodID);
	 	var integrationCFC = request.slatwallScope.getBean("IntegrationService").getIntegrationByIntegrationPackage('braintree');
 		var paymentIntegrationCFC = createMock(object=request.slatwallScope.getBean("IntegrationService").getPaymentIntegrationCFC(integrationCFC));
 		
 		var cart = request.slatwallScope.getService('OrderService').getOrder(orderID = "2c9180856b8e1aeb016b8e6d511f00b4");
 		
        var response = paymentIntegrationCFC.getAccountPaymentToken(cart.getAccount(), paymentMethod);
        
        debug(response);
    }
    
	 /**
	 * @test
	 * Test Create Transaction Method
	 **/
	 public void function testCreateTransaction()
	 {
	 	var order = request.slatwallScope.getService('OrderService').getOrder(orderID);
	 	var integrationCFC = request.slatwallScope.getBean("IntegrationService").getIntegrationByIntegrationPackage('braintree');
 		var paymentIntegrationCFC = createMock(object=request.slatwallScope.getBean("IntegrationService").getPaymentIntegrationCFC(integrationCFC));
 		
        var paymentMethod = request.slatwallScope.getBean("PaymentService").getPaymentMethod(paymentMethodID);
        
        var response = paymentIntegrationCFC.createTransaction(paymentMethod, order);
        writeDump(response);
	 }
	 
	 /**
	 * @test
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