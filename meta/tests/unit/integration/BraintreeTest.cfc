component extends="Slatwall.meta.tests.unit.SlatwallUnitTestBase" {

    public void function setUp() {
        super.setup();

        variables.service = variables.mockservice.getIntegrationServiceMock();
        
        variables.paymentMethodID = '2c9580846bfaeee2016bfaf16f440006';
        variables.accountID = '2c9180866adeb3fc016adeea531b001d';
        variables.orderID = '2c9180856b8e1aeb016b8e9ec98e0133';
        
        variables.braintree_token = "cGF5bWVudG1ldGhvZF9wcF84NDZtc2s";
	}
	
	/**
	 * @test
	 * Test External HTML Method
	 **/
	 public void function testExternalPaymentHTML()
	 {
	 	var order = request.slatwallScope.getService('OrderService').getOrder(orderID);
	 	var integrationCFC = request.slatwallScope.getBean("IntegrationService").getIntegrationByIntegrationPackage('braintree');
 		var paymentIntegrationCFC = createMock(object=request.slatwallScope.getBean("IntegrationService").getPaymentIntegrationCFC(integrationCFC));
 		
        var paymentMethod = request.slatwallScope.getBean("PaymentService").getPaymentMethod(paymentMethodID);
        
        var sdkHTML = paymentIntegrationCFC.getExternalPaymentHTML(paymentMethod, order);
        debug(sdkHTML);
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