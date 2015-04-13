component extends="Slatwall.meta.tests.unit.SlatwallUnitTestBase" {
	public void function setUp() {
		super.setup();
		
		variables.promotionService = request.slatwallScope.getBean("promotionService");
		variables.orderService = request.slatwallScope.getBean("orderService");
		variables.accountService = request.slatwallScope.getBean("accountService");
	}
	
	public void function promotionIntegration(){
		var orderData = {
			orderID = ''
		};
		var order = createTestEntity('order',orderData);
		
		assertTrue(order.hasProcessObject('create'));
		
		var order_Create = order.getProcessObject('create',{});
		
		//get the test runner account
		var account = variables.accountService.getAccountByAccountID('c2ba501df62e4115821cc45ef3ec9502');
		
		var orderProcessData = {
			orderID='',
			preProcessDisplayedFlag=1,
			sRedirectAction='admin=entity.editorder',
			fRenderItem='preprocessorder',
			newAccountFlag=0,
			firstName='',
			lastName='',
			company='',
			phoneNumber='',
			emailAddress='',
			emailAddressConfirm='',
			createAuthenticationFlag=0,
			password='',
			passwordConfirm='',
			accountID=account.getAccountID(),
			orderTypeID='444df2df9f923d6c6fd0942a466e84cc',
			currencyCode='USD',
			orderOriginID='',
			defaultStockLocationID=''
		};
		
		order = variables.orderService.process(order,orderProcessData,'create');
		
		//assert that the order is populated
		assertEquals(order.getCurrencyCode(),'USD');
		
		//submitting user data
		var order_addOrderItemData = {
			orderID=order.getOrderID(),
			preProcessDisplayedFlag=1,
			sRedirectAction='admin=entity.editorder',
			sRenderItem='detailorder',
			fRenderItem='preprocessorder',
			skuID='8a8080834721af1a0147220714810083',
			orderItemTypeSystemCode='oitSale',
			quantity=1,
			price=100.00,
			orderFulfillmentID='new',
			fulfillmentMethodID='444df2fb93d5fa960ba2966ba2017953',
			emailAddress='',
			pickupLocationID='4028288d4b3b616c014b50dff9fa00f6',
			shippingAccountAddressID='73e80f7e799b4c29a1af5d0dab4fb110',
			shippingAddress.addressID='',
			shippingAddress.name='',
			shippingAddress.company='',
			shippingAddress.streetAddress='',
			shippingAddress.street2Address='',
			shippingAddress.city='',
			shippingAddress.stateCode='',
			shippingAddress.postalCode='',
			shippingAddress.countryCode='US',
			saveShippingAccountAddressFlag=1,
			saveShippingAccountAddressName=''
		};
		
		order = variables.orderService.process(order,order_addOrderItemData,'addOrderItem');
		//assert we have added the order item to the order
		assertEquals(arraylen(order.getOrderItems()),1);
		assertEquals(order.getOrderItems()[1].getSku().getSkuID(),'8a8080834721af1a0147220714810083');
		
		//Add Promotion to Order
		var order_addPromotionCode = {
			promotionCodeID = '8a804483472135b6014721625eee0123',
			orderID = order.getOrderID()
		};
		
		//Assert Promotion has been added
		order = variables.orderService.process(order,order_addPromotionCode,'addPromotionCode');
		assertEquals(arrayLen(order.getPromotionCodes()),1);
		
	}

}