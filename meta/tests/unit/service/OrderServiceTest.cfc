/*

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.

    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms
    of your choice, provided that you follow these specific guidelines:

	- You also meet the terms and conditions of the license of each
	  independent module
	- You must not alter the default display of the Slatwall name or logo from
	  any part of the application
	- Your custom code must not alter or create any files inside Slatwall,
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets
	the above guidelines as a combined work under the terms of GPL for this program,
	provided that you include the source code of that other code when and as the
	GNU GPL requires distribution of source code.

    If you modify this program, you may extend this exception to your version
    of the program, but you are not obligated to do so.

Notes:

*/
component extends="Slatwall.meta.tests.unit.SlatwallUnitTestBase" {

	public void function setUp() {
		super.setup();
		//variables.service = request.slatwallScope.getService("orderService");
		variables.service = variables.mockService.getOrderServiceMock();

	}
	//can delete order without standard validation because it was created with a test account
	public void function deleteOrder_canDeleteTestOrder(){
		var orderData = {
			orderID="",
			testOrderFlag=0,
			//ostClosed
			orderStatusType={
				typeID="444df2b8b98441f8e8fc6b5b4266548c"
			}
		};
		var order = createPersistedTestEntity('order',orderData);
		assertFalse(order.isDeletable());
		assertEquals(order.getStatusCode(),'ostClosed');
		var deleteOK = variables.service.deleteOrder(order);
		assertFalse(deleteOK);

		var testOrderData = {
			orderID="",
			testOrderFlag=1,
			//ostClosed
			orderStatusType={
				typeID="444df2b8b98441f8e8fc6b5b4266548c"
			}
		};
		var testOrder = createPersistedTestEntity('order',testOrderData);

		assert(testOrder.isDeletable());
		deleteOK = variables.service.deleteOrder(testOrder);
		assert(deleteOK);

	}

	//test account will create test orders
	public void function processOrder_createTest_testAccountCreatesTestOrder(){
		var accountData = {
			accountID="",
			testAccountFlag=1
		};
		var account = createPersistedTestEntity('account',accountData);

		var orderData = {
			orderID=""
		};
		var order = createTestEntity('order',orderData);

		var processData={
			accountID=account.getAccountID(),
			newAccountFlag=0
		};

		order = variables.service.process(order,processData,'create');
		assert(order.getTestOrderFlag());
	}

	//test is incomplete as it bypasses the currencyconverions,promotion, and tax intergration update amounts code
	/**
	* @test
	*/
	/*public void function processOrder_addAndRemoveOrderItem_addOrderItems(){
		
		//set up productBundle
		var productData = {
			productName="productBundleName",
			productid="",
			activeflag=1,
			price=1,
			currencycode="USD",
			skus=[
				{
					currencycode="USD",
					skuid="",
					price=1,
					activeflag=1,
					skuCode = 'productBundle-1ABCDDdd' & RandRange(1, 1000),
					productBundleGroups=[
						{
							productBundleGroupid:""
						},
						{
							productBundleGroupid:""
						}
					]
				}
			],
			//product Bundle type from SlatwallProductType.xml
			productType:{
				productTypeid:"ad9bb5c8f60546e0adb428b7be17673e"
			}
		};
		var product = createPersistedTestEntity('product',productData);

		var productData2 = {
			productName="childSku111",
			productid="",
			activeflag=1,
			price=1,
			currencycode="USD",
			skus=[
				{
					currencycode="USD",
					skuid="",
					price=1,
					activeflag=1,
					skuCode = 'childsku-11' & RandRange(1, 1000)
				}
			],
			//product Bundle type from SlatwallProductType.xml
			productType={
				productTypeid="ad9bb5c8f60546e0adb428b7be17673e"
			}
		};
		var product2 = createPersistedTestEntity('product',productData2);


		//set up order
		var orderData = {
			orderid="",
			activeflag=1,
			currencycode="USD"
		};
		var order = createPersistedTestEntity('Order',orderData);
		//var orderFulfillmentData = variables.service.getOrderFulfillment();

		

		//add orderfulfillment
		var processObjectData = {
			quantity=1,
			price=1,
			skuid=product.getSkus()[1].getSkuID()
		};
		//Second orderitem
		//add orderfulfillment
		var processObjectDataTwo = {
			quantity=1,
			price=1,
			skuid=product2.getSkus()[1].getSkuID()
		};
		
		var settingData2={
			settingID="",
			settingName="skuOrderMaximumQuantity",
			settingValue=1000,
			sku={
				skuID=product.getSkus()[1].getSkuID()
			}
		};
		var settingEntity2 = createPersistedTestEntity('Setting',settingData2);
		
		var settingData3={
			settingID="",
			settingName="skuTrackInventoryFlag",
			settingValue=0,
			
			sku={
				skuID=product.getSkus()[1].getSkuID()
			}
		};
		var settingEntity3 = createPersistedTestEntity('Setting',settingData3);
		
		var settingData4={
			settingID="",
			settingName="skuOrderMaximumQuantity",
			settingValue=1000,
			sku={
				skuID=product2.getSkus()[1].getSkuID()
			}
		};
		var settingEntity4 = createPersistedTestEntity('Setting',settingData4);
		
		var settingData4={
			settingID="",
			settingName="skuTrackInventoryFlag",
			settingValue=0,
			sku={
				skuID=product2.getSkus()[1].getSkuID()
			}
		};
		var settingEntity4 = createPersistedTestEntity('Setting',settingData4);

		var processObject = order.getProcessObject('AddOrderItem',processObjectData);
		var processObjectTwo = order.getProcessObject('AddOrderItem',processObjectDataTwo);
		//Check that the items were added.
		var orderReturn = variables.service.processOrder_addOrderItem(order, processObject);
		orderReturn = variables.service.processOrder_addOrderItem(order, processObjectTwo);
		var orderItemsAdded = orderReturn.getOrderItems();
		//assertEquals("This will fail", orderItemsAdded[1].getOrderItemID());
		assertEquals(2, arraylen(orderItemsAdded));//This works because we have two order items.


		//Get the orderItem ID of the added item and use it to remove an item.
		var orderItemsToRemove = {
			orderItemID = "#orderItemsAdded[1].getOrderItemID()#"
		};
		var id = orderItemsAdded[1].getOrderItemID();
		var id2 = orderItemsAdded[2].getOrderItemID();
		addToDebug(ArrayLen(order.getOrderItems()));
		//assertEquals("123", id2);//This should fail and it does.
		//variables.service.processOrder_removeOrderItem(order, {orderItemID="#id#"});

		variables.service.processOrder_removeOrderItem(order, {orderItemIDList="#id#,#id2#"});//Removes multiple
		addToDebug(ArrayLen(order.getOrderItems()));
		//addToDebug(arraylen(orderReturn.getOrderItems()[1].getChildOrderItems()));
		//addToDebug(orderReturn.getOrderItems()[1].getChildOrderItems()[1].getQuantity());
		//addToDebug(orderReturn.getOrderID());
		//addToDebug(orderReturn.getOrderItems()[1].getChildOrderItems()[1].getChildOrderItems()[1].getQuantity());
		//addToDebug(orderReturn.getOrderItems()[1].getChildOrderItems()[1].getChildOrderItems()[1].getChildOrderItems()[1].getQuantity());
	}*/

	/**
	* @test
	*/
	/*public void function process_order_add_gift_card_order_item(){
		var productData = {
			productName="AGiftCardProductName",
			productid="",
			activeflag=1,
			price=10,
			currencycode="USD",
			skus=[
				{
					currencycode="USD",
					skuid="",
					price=10,
					activeflag=1,
					skuCode = '',
					redemptionAmountType='fixedAmount',
					redemptionAmount=5
				}
			],
			productType={
				productTypeID="50cdfabbc57f7d103538d9e0e37f61e4"
			}
		};
		var product = createPersistedTestEntity('product',productData);
		
		var settingData4={
			settingID="",
			settingName="skuOrderMaximumQuantity",
			settingValue=1000,
			sku={
				skuID=product.getSkus()[1].getSkuID()
			}
		};
		var settingEntity4 = createPersistedTestEntity('Setting',settingData4);
		
		var settingData4={
			settingID="",
			settingName="skuTrackInventoryFlag",
			settingValue=0,
			sku={
				skuID=product.getSkus()[1].getSkuID()
			}
		};
		var settingEntity4 = createPersistedTestEntity('Setting',settingData4);

		var termData = {
			termID=""
		};

		var term = createPersistedTestEntity('term', termData);

		product.getSkus()[1].setGiftCardExpirationTerm(term);

		assertTrue(product.getSkus()[1].isGiftCardSku());

		//set up order
		var orderData = {
			orderID="",
			activeflag=1,
			currencycode="USD"
		};
		accountData={
			accountID=""
		};
		var account = createPersistedTestEntity('Account', accountData);
		var order = createPersistedTestEntity('Order',orderData);
		addToDebug(order.getHibachiErrors());

		order.setAccount(account);

		var processObjectData = {
			quantity=1,
			price=1,
			skuid=product.getSkus()[1].getSkuID()
		};
		var processObject = order.getProcessObject('AddOrderItem',processObjectData);

		var orderReturn = variables.service.processOrder_addOrderItem(order, processObject);

		var orderItemsAdded = orderReturn.getOrderItems();

		assertEquals(1, arraylen(orderItemsAdded));

		var orderItemGiftRecipientData = {
			orderItemGiftRecipientID="",
			firstName="Bobby",
			lastName="Bot",
			quantity=1
		};

		var recipient1 = createPersistedTestEntity("orderItemGiftRecipient", orderItemGiftRecipientData);

		var numOfUnassignedGiftCards = orderItemsAdded[1].getNumberOfUnassignedGiftCards();

		assertEquals(1, numOfUnassignedGiftCards);

		orderItemsAdded[1].addOrderItemGiftRecipient(recipient1);

		numOfUnassignedGiftCards = orderItemsAdded[1].getNumberOfUnassignedGiftCards();
		assertEquals(0, numOfUnassignedGiftCards);
	}*/

	/**
	* @test
	*/
	public void function duplicate_order_with_child_order_items(){
		//set up order
		var orderData = {
			orderid=CreateUUID(),
			activeflag=1,
			currencycode="USD"
		};
		accountData={
			accountID=""
		};
		var account = createPersistedTestEntity('Account', accountData);
		var order = createPersistedTestEntity('Order', orderData);
		order.setAccount(account);
		var skudata = {
			skuID=CreateUUID(),
			skuPrice=10,
			product={
				productID=CreateUUID()
			}
		};
		var sku = createPersistedTestentity('Sku', skudata);
		var orderItemData1 = {
			orderItemID=CreateUUID(),
			price=10,
			skuprice=10,
			currencyCode="USD",
			quantity=1,
			orderItemTypeID=""
		};
		var orderItemData2 = {
			orderItemID=CreateUUID(),
			quantity=1,
			bundleItemQuantity=1
		};
		var orderItemData3 = {
			orderItemID=CreateUUID(),
			quantity=1,
			bundleItemQuantity=1
		};
		var orderItem1 = createPersistedTestEntity('OrderItem', orderItemData1);
		var orderItem2 = createPersistedTestEntity('OrderItem', orderItemData2);
		var orderItem3 = createPersistedTestEntity('OrderItem', orderItemData3);

		orderItem1.setSku(sku);
		orderItem2.setSku(sku);
		orderItem3.setSku(sku);

		orderItem1.addChildOrderItem(orderItem2);
		orderItem1.addChildOrderItem(orderItem3);
		order.addOrderItem(orderItem1);
		orderItem2.setOrder(order);
		orderItem3.setOrder(order);

		var data = {
			saveNewFlag=true,
			copyPersonalDataFlag=true,
			referencedOrderFlag=false
		};

		//addToDebug(order);

		var duplicateorderitem = variables.service.copyToNewOrderItem(orderItem1);

		//addToDebug(order);

		assertTrue(ArrayLen(duplicateorderitem.getChildOrderItems()));

	}

	/**
	* @test
	*/
	/*public void function processOrder_placeOrder_TermPayment(){
		//adding a test shippingMethod
		var shippingMethodData ={
			shippingMethodID="",
			fulfillementMethod={
				//shipping
				fulfillmentMethodID='444df2fb93d5fa960ba2966ba2017953'
			},
			activeFlag=1,
			shippingMethodName="testShippingMethod"&createUUID(),
			shippingMethodCode="testShippingMethod"&createUUID()
		};
		var shippingMethod = createPersistedTestEntity('ShippingMethod',shippingMethodData);

		var shippingMethodRateData={
			shippingMethodRateID="",
			shippingMethod={
				shippingMethodID=shippingMethod.getShippingMethodID()
			},
			activeFlag=1
		};
		var shippingMethodRate = createPersistedTestEntity('ShippingMethodRate',shippingMethodRateData);

		var accountData={
			accountID="",
			firstName="test",
			lastName="test",
			emailAddress="test@test.com"
		};
		var account = createPersistedTestEntity('account',accountData);


		//create Term Payment Method
		var termPaymentMethodData={
			paymentMethodID="",
			activeFlag=1,
			paymentMethodName="testTermPaymentMethod"&createUUID(),
			allowSaveFlag=1,
			placeOrderChargeTransactionType="",
			placeOrderCreditTransactionType="",
			subscriptionRenewalTransactionType=""
		};
		var termPaymentMethod = createPersistedTestEntity('PaymentMethod',termPaymentMethodData);

		var accountPaymentMethodData={
			accountPaymentMethodID="",
			activeFlag=1,
			account={
				accountID=account.getAccountID()
			},
			paymentMethod={
				paymentMethodID=termPaymentMethod.getPaymentMethodID()
			}

		};
		var accountPaymentMethod = createPersistedTestEntity('AccountPaymentMethod',accountPaymentMethodData);

		//set up an orderable product
		var productData = {
			productID="",
			productCode="testProduct"&createUUID(),
			productType={
				//merchandise
				productTypeID='444df2f7ea9c87e60051f3cd87b435a1'
			},
			activeFlag=1
		};
		var product = createPersistedTestEntity('Product',productData);

		var skuData={
			skuID="",
			skuCode="testSku"&createUUID(),
			product={
				productID=product.getProductID()
			},
			activeFlag=1
		};
		var sku = createPersistedTestEntity('sku',skuData);
		
		//SET UP SKU SETTINGS
		//set up eligible sku payment methods
		var settingData={
			settingID="",
			settingName="skuEligiblePaymentMethods",
			settingValue=termPaymentMethod.getPaymentMethodID(),
			sku={
				skuID=sku.getSkuID()
			}
		};
		var settingEntity = createPersistedTestEntity('Setting',settingData);
		
		var settingData2={
			settingID="",
			settingName="skuOrderMaximumQuantity",
			settingValue=1000,
			sku={
				skuID=sku.getSkuID()
			}
		};
		var settingEntity2 = createPersistedTestEntity('Setting',settingData2);
		
		var settingData3={
			settingID="",
			settingName="skuTrackInventoryFlag",
			settingValue=0,
			sku={
				skuID=sku.getSkuID()
			}
		};
		var settingEntity3 = createPersistedTestEntity('Setting',settingData3);


		//CREATE ORDER
		var orderData = {
			orderID="",
			accountID=account.getAccountID(),
			currencyCode='USD',
			orderType={
				//sales order
				typeID='444df2df9f923d6c6fd0942a466e84cc'
			},
			newAccountFlag=0

		};
		var order = createTestEntity('order',{});
		order = variables.service.process(order,orderData,'create');

		request.slatwallScope.getDao('hibachiDao').flushOrmSession();

		var shippingAddressData={
			addressID="",
			firstName="test",
			lastName="test",
			streetAddress="test st",
			company="",
			city="test",
			stateCode="MA",
			countryCode="US",
			postalCode="01757"
		};
		var shippingAddress = createPersistedTestEntity('Address',shippingAddressData);

		var accountAddressData = {
			accountAddressID="",
			address={
				addressID=shippingAddress.getAddressID()
			},
			account={
				accountID=account.getAccountID()
			}
		};
		var accountAddress = createPersistedTestEntity('AccountAddress',accountAddressData);

		//ADD ORDERITEM
		var addOrderItemData={
			skuID=sku.getSkuID(),
			orderItemTypeSystemCode="oitSale",
			quantity=1,
			price=1.00,
			orderFulfillmentID="new",
			//shipping
			fulfillmentMethodID='444df2fb93d5fa960ba2966ba2017953',
			//default location
			pickupLocationID='88e6d435d3ac2e5947c81ab3da60eba2',

			shippingAccountAddressID=accountAddress.getAccountAddressID(),
			shippingAddress.countryCode='US',
			saveShippingAccountAddressFlag=1,
			preProcessDisplayedFlag=1
		};
		order = variables.service.process(order,addOrderItemData,'addOrderItem');
		
		request.slatwallScope.getDao('hibachiDao').flushOrmSession();
		assert(arraylen(order.getOrderFulfillments()));

		var placeOrderData={
			orderID=order.getOrderID(),
			preProcessDisplayedFlag=1,
			orderFulfillments={
				orderFulfillmentID=order.getOrderFulfillments()[1].getOrderFulfillmentID(),
				shippingMethod={
					shippingMethodID=shippingMethod.getShippingMethodID()
				}
			},
			newOrderPayment={
				orderPaymentID="",
				order={
					orderID=order.getOrderID()
				},
				orderPaymentType={
					//charge
					typeID="444df2f0fed139ff94191de8fcd1f61b"
				},
				paymentMethod={
					paymentMethodID=termPaymentMethod.getPaymentMethodID()
				},
				creditCardNumber="4111111111111111",
				nameOnCreditCard="Ryan Marchand",
				expirationMonth="01",
				expirationYear="19",
				securityCode="111",
				companyPaymentMethodFlag="0"
			},
			copyFromType="",
			saveGiftCardToAccountFlag=0,
			accountAddressID=accountAddress.getAccountAddressID(),
			saveAccountPaymentMethodFlag=0
		};

		order = variables.service.process(order,placeOrderData,'placeOrder');
		request.slatwallScope.getDao('hibachiDao').flushOrmSession();

		var orderDeliveryData={
			orderDeliveryID="",
			preProcessDisplayedFlag=1,
			order={
				orderID=order.getOrderID()
			},
			orderFulfillment={
				orderFulfillmentID=order.getOrderFulfillments()[1].getOrderFulfillmentID()
			},
			location={
				locationID='88e6d435d3ac2e5947c81ab3da60eba2'
			},
			shippingMethod={
				shippingMethodID=shippingMethod.getShippingMethodID()
			},
			shippingAddress={
				addressID=shippingAddress.getAddressID()
			},
			orderDeliveryItems=[
				{
					orderDeliveryID="",
					quantity=1,
					orderItem={
						orderItemID=order.getOrderITems()[1].getOrderItemID()
					}
				}
			]
		};
		var orderDelivery = createTestEntity('OrderDelivery',{});
		orderDelivery = variables.service.process(orderDelivery,orderDeliveryData,'create');
		variables.service.getDao('hibachiDao').flushOrmSession();

		assert(arrayLen(orderDelivery.getOrderDeliveryItems()));

		assertEquals(orderDelivery.getOrderDeliveryItems()[1].getQuantity(),1);
	}*/
	
	/**
	* @test
	*/
	public void function getProductsScheduledForDeliveryTest(){
		//create a product that is for deferredRevenue
		var productData = {
			productID="",
			productName="deferredRevenueTest"&createUUID(),
			deferredRevenueFlag=1
		};
		var product = createPersistedTestEntity('product',productData);
		
		var skuData = {
			skuID="",
			product={
				productID=product.getProductID()
			}
		};
		var sku = createPersistedTestEntity('sku',skuData);
		
		var subscriptionTermData = {
			subscritpionTermID="",
			itemsToDeliver=12,
			skus=[
				{
					skuID=sku.getSkuID()
				}
			]
		};
		var subscriptionTerm = createPersistedTestEntity('subscriptionTerm',subscriptionTermData);
		
		assert(arraylen(subscriptionTerm.getSKus()));
		
		//make sure flag is set
		assert(product.getDeferredRevenueFlag());
		
		//set up a delivery schedule
		
		var DeliveryScheduleDateData = {
			deliveryScheduleDateID="",
			deliveryScheduleDateValue="12/12/2018",
			completedFlag=0,
			product={
				productID=product.getProductID()
			}
		};
		var deliveryScheduleDate = createPersistedTestEntity('DeliveryScheduleDate',DeliveryScheduleDateData);
		
		var NextDeliveryScheduleDateData = {
			deliveryScheduleDateID="",
			deliveryScheduleDateValue="1/12/2019",
			completedFlag=0,
			product={
				productID=product.getProductID()
			}
		};
		var nextDeliveryScheduleDate = createPersistedTestEntity('DeliveryScheduleDate',NextDeliveryScheduleDateData);
		
		var orderService = variables.mockService.getOrderServiceMock();
		var productIDList = orderService.getProductsScheduledForDelivery("12/13/2018");
		assert(listFind(productIDList,product.getProductID()));
		
	}
	
	/**
	* @test
	* @description this function should look for all subscriptions that require a delivery based on the DeliverySchedule
	*/
	/*public void function createSubscriptionOrderDeliveriestest(){
	
		//MOCK DATA BEGIN
	
		//create a product that is for deferredRevenue
		var productData = {
			productID="",
			productName="deferredRevenueTest"&createUUID(),
			deferredRevenueFlag=1
		};
		var product = createPersistedTestEntity('product',productData);
		
		//make sure flag is set
		assert(product.getDeferredRevenueFlag());
		
		var skuData = {
			skuID="",
			product={
				productID=product.getProductID()
			}
		};
		var sku = createPersistedTestEntity('sku',skuData);
		
		var subscriptionTermData = {
			subscritpionTermID="",
			itemsToDeliver=12,
			skus=[
				{
					skuID=sku.getSkuID()
				}
			]
		};
		var subscriptionTerm = createPersistedTestEntity('subscriptionTerm',subscriptionTermData);
		
		assert(arraylen(subscriptionTerm.getSkus()));
		
		assertEquals(subscriptionTerm.getItemsToDeliver(),12);
		
		//set up a delivery schedule
		
		var DeliveryScheduleDateData = {
			deliveryScheduleDateID="",
			deliveryScheduleDateValue="12/12/2018",
			completedFlag=0,
			product={
				productID=product.getProductID()
			}
		};
		var deliveryScheduleDate = createPersistedTestEntity('DeliveryScheduleDate',DeliveryScheduleDateData);
		
		var NextDeliveryScheduleDateData = {
			deliveryScheduleDateID="",
			deliveryScheduleDateValue="1/12/2019",
			completedFlag=0,
			product={
				productID=product.getProductID()
			}
		};
		var nextDeliveryScheduleDate = createPersistedTestEntity('DeliveryScheduleDate',NextDeliveryScheduleDateData);
		
		var FinalDeliveryScheduleDateData = {
			deliveryScheduleDateID="",
			deliveryScheduleDateValue="1/12/2019",
			completedFlag=0,
			product={
				productID=product.getProductID()
			}
		};
		var finalDeliveryScheduleDate = createPersistedTestEntity('DeliveryScheduleDate',FinalDeliveryScheduleDateData);
		
		var subscriptionStatusData = {
			subscriptionStatusID="",
			effectiveDateTime="11/11/2018",
			subscriptionStatusType={
				//sstActive
				typeID="444df31fa8adde8d71c5ca279e42a00d"
			}
		};
		var subscriptionStatus = createPersistedTestEntity('subscriptionStatus',subscriptionStatusData);
		
		assert(subscriptionStatus.getEffectiveDateTime()<='12/12/2018');
		
		var subscriptionUsageData = {
			subscriptionUsageID="",
			subscriptionTerm={
				subscriptionTermID=subscriptionTerm.getSubscriptionTermID()
			},
			calculatedCurrentStatus={
				subscriptionStatusID=subscriptionStatus.getSubscriptionStatusID()
			}
		};
		var subscriptionUsage = createPersistedTestEntity('subscriptionUsage',subscriptionUsageData);
		
		assert(!isNull(subscriptionUsage.getCalculatedCurrentStatus()));
		assertEquals(subscriptionUsage.getCalculatedCurrentStatus().getSubscriptionStatusType().getSystemCode(),'sstActive');
		assert(!isNull(subscriptionUsage.getSubscriptionTerm()));
		
		var orderItemData = {
			orderItemID="",
			sku={
				skuID=sku.getSkuID()
			},
			calculatedExtendedPrice=777.12,
			calculatedTaxAmount=12.12,
			currencyCode='USD'
		};
		var orderItem = createPersistedTestEntity('orderItem',orderItemData);
		
		assert(!isNull(orderItem.getSku()));
		
		var subscriptionOrderItemData = {
			subscritpionOrderItemID="",
			subscriptionUsage={
				subscriptionUsageID=subscriptionUsage.getSubscriptionUsageID()
			}
		};
		var subscriptionOrderItem = createTestEntity('subscriptionOrderItem',subscriptionOrderItemData);
		
		subscriptionOrderItem.setOrderItem(orderItem);
		product.setNextDeliveryScheduleDate(deliveryScheduleDate);
		
		ormflush();
		
		assert(!isNull(subscriptionOrderItem.getOrderItem()));
		
		assertEquals(subscriptionOrderItem.getOrderItem().getSku().getProduct().getProductID(),product.getProductID());
		assert(!isNull(subscriptionOrderItem.getSubscriptionUsage()));
		
		//MOCK DATA END
		
		
		//MOCK SERVICE BEGIN
		var orderService = variables.mockService.getOrderServiceMock();
		var productDao = variables.mockService.getProductDAOMock();
		orderService.setProductDAO(productDao);
		var orderDAO = variables.mockService.getOrderDAOMock();
		orderService.setOrderDAO(orderDAO);
		
		//MOCK SERVICE END
		
		orderService.createSubscriptionOrderDeliveries('12/13/2018');
		
		//reload since sql updated product value
		entityReload(product);
		entityReload(subscriptionOrderItem);
		
		//make sure that the schedule updated
		assertEquals(product.getNextDeliveryScheduleDate().getDeliveryScheduleDateValue(),NextDeliveryScheduleDate.getDeliveryScheduleDateValue());
		assertEquals(1,arraylen(subscriptionOrderItem.getSubscriptionOrderDeliveryItems()));
		
		//if schedule is run again and make sure we don't deliver unnecessarily
		orderService.createSubscriptionOrderDeliveries('12/13/2018');
		
		//reload since sql updated product value
		entityReload(product);
		
		//make sure that the schedule stayed the same and no extra deliveries are made
		assertEquals(product.getNextDeliveryScheduleDate().getDeliveryScheduleDateValue(),NextDeliveryScheduleDate.getDeliveryScheduleDateValue());
		assertEquals(1,arraylen(subscriptionOrderItem.getSubscriptionOrderDeliveryItems()));
		
		//future date arrives make sure we get to we progress to next date
		orderService.createSubscriptionOrderDeliveries('1/13/2019');
		
		//reload since sql updated product value
		entityReload(product);
		
		//make sure that the schedule moved forward and a new deliver was made
		assertEquals(product.getNextDeliveryScheduleDate().getDeliveryScheduleDateValue(),FinalDeliveryScheduleDate.getDeliveryScheduleDateValue());
		assertEquals(2,subscriptionOrderItem.getSubscriptionOrderDeliveryItemsCount());
		
	}*/
	
	/**
	* @test
	*/
	/*public void function processOrder_placeOrder_TermPayment_QNDOOupdates(){
		//adding a test shippingMethod
		var shippingMethodData ={
			shippingMethodID="",
			fulfillmentMethod={
				//shipping
				fulfillmentMethodID='444df2fb93d5fa960ba2966ba2017953'
			},
			activeFlag=1,
			shippingMethodName="testShippingMethod"&createUUID(),
			shippingMethodCode="testShippingMethod"&createUUID()
		};
		var shippingMethod = createPersistedTestEntity('ShippingMethod',shippingMethodData);

		var shippingMethodRateData={
			shippingMethodRateID="",
			shippingMethod={
				shippingMethodID=shippingMethod.getShippingMethodID()
			},
			activeFlag=1
		};
		var shippingMethodRate = createPersistedTestEntity('ShippingMethodRate',shippingMethodRateData);

		var accountData={
			accountID="",
			firstName="test",
			lastName="test",
			emailAddress="test@test.com"
		};
		var account = createPersistedTestEntity('account',accountData);


		//create Term Payment Method
		var termPaymentMethodData={
			paymentMethodID="",
			activeFlag=1,
			paymentMethodName="testTermPaymentMethod"&createUUID(),
			allowSaveFlag=1,
			placeOrderChargeTransactionType="",
			placeOrderCreditTransactionType="",
			subscriptionRenewalTransactionType=""
		};
		var termPaymentMethod = createPersistedTestEntity('PaymentMethod',termPaymentMethodData);

		var accountPaymentMethodData={
			accountPaymentMethodID="",
			activeFlag=1,
			account={
				accountID=account.getAccountID()
			},
			paymentMethod={
				paymentMethodID=termPaymentMethod.getPaymentMethodID()
			}

		};
		var accountPaymentMethod = createPersistedTestEntity('AccountPaymentMethod',accountPaymentMethodData);

		//set up eligible sku payment methods
		var settingData={
			settingID="",
			settingName="skuEligiblePaymentMethods",
			settingValue=termPaymentMethod.getPaymentMethodID()
		};
		var settingEntity = createPersistedTestEntity('Setting',settingData);

		//set up an orderable product
		var productData = {
			productID="",
			productCode="testProduct"&createUUID(),
			productType={
				//merchandise
				productTypeID='444df2f7ea9c87e60051f3cd87b435a1'
			}
		};
		var product = createPersistedTestEntity('Product',productData);

		var skuData={
			skuID="",
			skuCode="testSku"&createUUID(),
			product={
				productID=product.getProductID()
			}
		};
		var sku = createPersistedTestEntity('sku',skuData);

//		set up tracking on sku
		settingData={
			settingID="",
			settingName="skuTrackInventoryFlag",
			settingValue="1",
			sku={
				skuID=sku.getSkuID()
			}
		};
		settingEntity = createPersistedTestEntity('Setting',settingData);

		var locationData = {
			locationID=""
		};
		var locationEntity = createPersistedTestEntity('Location',locationData);

		var stockData = {
			stockID="",
			location={
				locationID=locationEntity.getLocationID()
			}
		};
		var stock = createPersistedTestEntity('Stock',stockData);
		arrayAppend(locationEntity.getStocks(),stock);
		arrayAppend(sku.getStocks(),stock);
		stock.setSku(sku);
		//add an item in the warehouse
		var inventoryData = {
			inventoryID="",
			quantityIn=1,
			stock={
				stockID=stock.getStockID()
			}
		};
		var inventory = createPersistedTestEntity('Inventory',inventoryData);
		inventory.setStock(stock);
		stock.addInventory(inventory);

		variables.service.getDao('hibachiDao').flushOrmSession();
		//verify we are cool at all levels
		assert(arraylen(stock.getInventory()));
		assert(arraylen(sku.getStocks()));
		assert(!isNull(stock.getSku()));
		assert(!isNull(stock.getlocation()));
		assert(arraylen(locationEntity.getStocks()));
		assertEquals(sku.getQuantity('QATS'),1);
		//assume nothing is here before place order
		assertEquals(sku.getQuantity('QNDOO'),0);
		var orderData = {
			orderID="",
			accountID=account.getAccountID(),
			currencyCode='USD',
			orderType={
				//sales order
				typeID='444df2df9f923d6c6fd0942a466e84cc'
			},
			newAccountFlag=0

		};
		var order = createTestEntity('order',{});
		order = variables.service.process(order,orderData,'create');

		variables.service.getDao('hibachiDao').flushOrmSession();

		var shippingAddressData={
			addressID="",
			firstName="test",
			lastName="test",
			streetAddress="test st",
			company="",
			city="test",
			stateCode="MA",
			countryCode="US",
			postalCode="01757"
		};
		var shippingAddress = createPersistedTestEntity('Address',shippingAddressData);

		var accountAddressData = {
			accountAddressID="",
			address={
				addressID=shippingAddress.getAddressID()
			},
			account={
				accountID=account.getAccountID()
			}
		};
		var accountAddress = createPersistedTestEntity('AccountAddress',accountAddressData);

		var addOrderItemData={
			skuID=sku.getSkuID(),
			orderItemTypeSystemCode="oitSale",
			quantity=1,
			price=1.00,
			orderFulfillmentID="new",
			//shipping
			fulfillmentMethodID='444df2fb93d5fa960ba2966ba2017953',
			//default location
			pickupLocationID='88e6d435d3ac2e5947c81ab3da60eba2',

			shippingAccountAddressID=accountAddress.getAccountAddressID(),
			shippingAddress.countryCode='US',
			saveShippingAccountAddressFlag=1,
			preProcessDisplayedFlag=1
		};
		order = variables.service.process(order,addOrderItemData,'addOrderItem');
		variables.service.getDao('hibachiDao').flushOrmSession();

		assert(arraylen(order.getOrderFulfillments()));

		var placeOrderData={
			orderID=order.getOrderID(),
			preProcessDisplayedFlag=1,
			orderFulfillments={
				orderFulfillmentID=order.getOrderFulfillments()[1].getOrderFulfillmentID(),
				shippingMethod={
					shippingMethodID=shippingMethod.getShippingMethodID()
				}
			},
			newOrderPayment={
				orderPaymentID="",
				order={
					orderID=order.getOrderID()
				},
				orderPaymentType={
					//charge
					typeID="444df2f0fed139ff94191de8fcd1f61b"
				},
				paymentMethod={
					paymentMethodID=termPaymentMethod.getPaymentMethodID()
				},
				creditCardNumber="4111111111111111",
				nameOnCreditCard="Ryan Marchand",
				expirationMonth="01",
				expirationYear="19",
				securityCode="111",
				companyPaymentMethodFlag="0"
			},
			copyFromType="",
			saveGiftCardToAccountFlag=0,
			accountAddressID=accountAddress.getAccountAddressID(),
			saveAccountPaymentMethodFlag=0
		};

		order = variables.service.process(order,placeOrderData,'placeOrder');
		variables.service.getDao('hibachiDao').flushOrmSession();
		//assertEquals(sku.getQuantity('QNDOO'),request.slatwallScope.getDao('inventoryDao').getQNDOO(product.getProductID())[1]['QNDOO']);
		var orderDeliveryData={
			orderDeliveryID="",
			preProcessDisplayedFlag=1,
			order={
				orderID=order.getOrderID()
			},
			orderFulfillment={
				orderFulfillmentID=order.getOrderFulfillments()[1].getOrderFulfillmentID()
			},
			location={
				locationID='88e6d435d3ac2e5947c81ab3da60eba2'
			},
			shippingMethod={
				shippingMethodID=shippingMethod.getShippingMethodID()
			},
			shippingAddress={
				addressID=shippingAddress.getAddressID()
			},
			orderDeliveryItems=[
				{
					orderDeliveryID="",
					quantity=1,
					orderItem={
						orderItemID=order.getOrderITems()[1].getOrderItemID()
					}
				}
			]
		};
		var orderDelivery = createTestEntity('OrderDelivery',{});
		orderDelivery = variables.service.process(orderDelivery,orderDeliveryData,'create');
		variables.service.getDao('hibachiDao').flushOrmSession();

		assert(arrayLen(orderDelivery.getOrderDeliveryItems()));

		assertEquals(orderDelivery.getOrderDeliveryItems()[1].getQuantity(),1);

	}*/

	private numeric function getQATSFake(){
		return 0;
	}

	private numeric function getQATSFakeWithQuantity(){
		return 100;
	}



	/**
	* @test
	*/
	
	/**
	* @test
	* @description make sure that when we do an exchange that we can add return order items even if we track inventory
	*/
	public void function processOrder_addOrderItem_ReturnExchangeTest(){
		//adding a test shippingMethod
		var shippingMethodData ={
			shippingMethodID="",
			fulfillementMethod={
				//shipping
				fulfillmentMethodID='444df2fb93d5fa960ba2966ba2017953'
			},
			activeFlag=1,
			shippingMethodName="testShippingMethod"&createUUID(),
			shippingMethodCode="testShippingMethod"&createUUID()
		};
		var shippingMethod = createPersistedTestEntity('ShippingMethod',shippingMethodData);

		var shippingMethodRateData={
			shippingMethodRateID="",
			shippingMethod={
				shippingMethodID=shippingMethod.getShippingMethodID()
			},
			activeFlag=1
		};
		var shippingMethodRate = createPersistedTestEntity('ShippingMethodRate',shippingMethodRateData);

		var accountData={
			accountID="",
			firstName="test",
			lastName="test",
			emailAddress="test@test.com"
		};
		var account = createPersistedTestEntity('account',accountData);


		//set up an orderable product
		var productData = {
			productID="",
			productCode="testProduct"&createUUID(),
			productType={
				//merchandise
				productTypeID='444df2f7ea9c87e60051f3cd87b435a1'
			}
		};
		var product = createPersistedTestEntity('Product',productData);

		var skuData={
			skuID="",
			skuCode="testSku"&createUUID(),
			product={
				productID=product.getProductID()
			}
		};
		var sku = createPersistedTestEntity('sku',skuData);

		//set up track inventory on  sku
		var settingData={
			settingID="",
			settingName="skuTrackInventoryFlag",
			settingValue=1,
			sku={
				skuID=sku.getSkuID()
			}
		};
		var settingEntity = createPersistedTestEntity('Setting',settingData);


		var orderData = {
			orderID="",
			accountID=account.getAccountID(),
			currencyCode='USD',
			orderType={
				//exchange order
				typeID='444df2e00b455a2bae38fb55f640c204'
			},
			newAccountFlag=0

		};
		var order = createTestEntity('order',{});
		order = variables.service.process(order,orderData,'create');

		variables.service.getDao('hibachiDao').flushOrmSession();

		var shippingAddressData={
			addressID="",
			firstName="test",
			lastName="test",
			streetAddress="test st",
			company="",
			city="test",
			stateCode="MA",
			countryCode="US",
			postalCode="01757"
		};
		var shippingAddress = createPersistedTestEntity('Address',shippingAddressData);

		var accountAddressData = {
			accountAddressID="",
			address={
				addressID=shippingAddress.getAddressID()
			},
			account={
				accountID=account.getAccountID()
			}
		};
		var accountAddress = createPersistedTestEntity('AccountAddress',accountAddressData);

		var addOrderItemData={
			skuID=sku.getSkuID(),
			orderItemTypeSystemCode="oitReturn",
			quantity=1,
			price=1.00,
			orderFulfillmentID="new",
			//shipping
			fulfillmentMethodID='444df2fb93d5fa960ba2966ba2017953',
			//default location
			pickupLocationID='88e6d435d3ac2e5947c81ab3da60eba2',

			shippingAccountAddressID=accountAddress.getAccountAddressID(),
			shippingAddress.countryCode='US',
			saveShippingAccountAddressFlag=1,
			preProcessDisplayedFlag=1
		};
		order = variables.service.process(order,addOrderItemData,'addOrderItem');
		assert(!order.hasErrors());

	}

	/**
	* @test
	*/
	public void function getOrderRequirementsListTest_failsOrderfulfillment(){
		var accountData = {
			accountID=""
		};
		var account = createPersistedTestEntity('account',accountData);
		var orderData = {
			orderID="",
			account={
				accountID=account.getAccountID()
			}
		};
		var order = createPersistedTestEntity('Order',orderData);

		//adding an invalid orderFulfillment
		var orderFulfillmentData = {
			orderFulfillmentID="",
			//shipping
			fulfillmentMethod={
				fulfillmentMethodID="444df2fb93d5fa960ba2966ba2017953"
			}
		};
		var orderFulfillment = createPersistedTestEntity('OrderFulfillment',orderFulfillmentData);

		order.addOrderFulfillment(orderFulfillment);
		orderFulfillment.setOrder(order);

		assert(arraylen(order.getOrderFulfillments()));

		orderRequirementsList = variables.service.getOrderRequirementsList(order);
		assertEquals(orderRequirementsList,'fulfillment');
	}

	/**
	* @test
	*/
	public void function getOrderRequirementsListTest_failsOrderReturn(){
		var accountData = {
			accountID=""
		};
		var account = createPersistedTestEntity('account',accountData);
		var orderData = {
			orderID="",
			account={
				accountID=account.getAccountID()
			}
		};
		var order = createPersistedTestEntity('Order',orderData);

		//check if each of the orderReturn is ready to process
		var orderReturnData={
			orderReturnID=""
		};
		var orderReturn = createPersistedTestEntity('OrderReturn',orderReturnData);
		orderReturn.addError('testerror','testerror');

		order.addOrderReturn(orderReturn);
		orderReturn.setOrder(order);

		orderRequirementsList = variables.service.getOrderRequirementsList(order);
		assertEquals(orderRequirementsList,'return');
	}

	/**
	* @test
	*/
	public void function getOrderRequirementsListTest_failsPayment(){
		var accountData = {
			accountID=""
		};
		var account = createPersistedTestEntity('account',accountData);

		var orderPaymentData1 = {
			orderPaymentID = '',
			orderPaymentType = {
				typeID = '444df2f0fed139ff94191de8fcd1f61b'//optCharge
			},
			amount = 10
		};
		var orderPayment = createPersistedTestEntity('OrderPayment', orderPaymentData1);

		var orderData = {
			orderID="",
			account={
				accountID=account.getAccountID()
			}

		};
		var order = createPersistedTestEntity('Order',orderData);

		orderPayment.setOrder(order);
		order.addOrderPayment(orderPayment);

		//checks if arguments.order.getPaymentAmountTotal() != arguments.order.getTotal()
		//or // Otherwise, make sure that the order payments all pass the isProcessable for placeOrder & does not have any errors

		orderRequirementsList = variables.service.getOrderRequirementsList(order);
		assertEquals(orderRequirementsList,'payment');
	}

	/**
	* @test
	*/
	public void function getOrderRequirementsListTest_failsAccount(){
		var orderData = {
			orderID=""
		};
		var order = createPersistedTestEntity('Order',orderData);

		//will complain that it needs a valid account
		var orderRequirementsList = variables.service.getOrderRequirementsList(order);
		assertEquals(orderRequirementsList,'account');





	}
}
