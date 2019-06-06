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
		variables.service = request.slatwallScope.getService("ledgerAccountService");
		variables.orderService = request.slatwallScope.getService("orderService");
		variables.vendorOrderService = request.slatwallScope.getService('vendorOrderService');
		variables.locationService = request.slatwallScope.getService('locationService');
	}
	/**
	* @test
	*/
	/*public void function ledgerAccountIntegrationTest(){
		//SET UP TWO LOCATIONS
		var newYorkLocationData = {
			locationID="",
			locationName="New York",
			activeFlag=1
		};
		var newYorkLocation = createTestEntity('location',{});
		newYorkLocation = variables.locationService.saveLocation(newYorkLocation,newYorkLocationData);
		
		var SanDiegoLocationData = {
			locationID="",
			locationName="San Diego",
			activeFlag=1
		};
		var SanDiegoLocation =createTestEntity('location',{});
		SanDiegoLocation = variables.locationService.saveLocation(SanDiegoLocation,SanDiegoLocationData);
		
		//SET UP A VENDOR
		var vendorEmailAddressData = {
			vendorEmailAddressID="",
			activeFlag=1,
			emailAddress="test@test.com"
		};
		var vendorEmailAddress = createPersistedTestEntity('VendorEmailAddress',vendorEmailAddressData);
		
		var testVendorData = {
			vendorID="",
			vendorName="test vendor"&createUUID(),
			accountNumber="123",
			activeFlag=1,
			vendorWebsite="http://test.com",
			primaryEmailAddress={
				vendorEmailAddressID=vendorEmailAddress.getVendorEmailAddressID()
			}
		};
		var testVendor = createPersistedTestEntity('Vendor',testVendorData);
		
		//SET UP STUFF NEEDED FOR ORDERING
		
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
			emailAddress="test1@test.com",
			activeFlag=1
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
			activeFlag=1,
			productCode="testProduct"&createUUID(),
			productType={
				//merchandise
				productTypeID='444df2f7ea9c87e60051f3cd87b435a1'
			}
		};
		var product = createPersistedTestEntity('Product',productData);

		var skuData={
			skuID="",
			activeFlag=1,
			skuCode="testSku"&createUUID(),
			product={
				productID=product.getProductID()
			}
		};
		var sku = createPersistedTestEntity('sku',skuData);

		//SET UP SKU AS TRACKING INVENTORY
		var skuTrackInventorySettingData={
			settingID="",
			settingName="skuTrackInventoryFlag",
			settingValue=1,
			sku={
				skuID=sku.getSkuID()
			}
		};
		var skuTrackInventorySettingEntity = createPersistedTestEntity('Setting',skuTrackInventorySettingData);
		
		//SET UP VENDOR ORDER
		var vendorOrderData = {
			vendorOrderID="",
			currencyCode="USD",
			vendor={
				vendorID=testVendor.getVendorID()
			},
			vendorOrderNumber="123",
			//estimatedReceivalDateTime="Jan 30, 2017 12:00 AM",
			billToLocation={
				locationID=SandiegoLocation.getLocationID()
			},
			shippingAndHandlingCost=10,
			costDistributionType='quantity'
		};
		var vendorOrder = createTestEntity('VendorOrder',{});
		
		vendorOrder = variables.vendorOrderService.saveVendorORder(vendorOrder,vendorOrderData);
		//request.slatwallScope.flushORMSession(true);
		
		//ADD VENDOR ORDER ITEM / PLACE THE VENDOR ORDER
		var vendorOrder_addOrderItemData = {
			skuID=sku.getSkuID(),
			vendorOrderItemTypeSystemCode='voitPurchase',
			vendorOrderID=vendorOrder.getVendorOrderID(),
			deliverToLocationID=sandiegoLocation.getLocationID(),
			quantity=10,
			cost=50
			//,vendorSkuID=1
		};
		vendorOrder = variables.vendorOrderService.process(vendorOrder,vendorOrder_addOrderItemData,'AddVendorOrderItem');
		//request.slatwallScope.flushORMSession(true);
		
		assertEquals(arraylen(vendorOrder.getVendorOrderItems()),1);
		
		//RECEIVE VENDOR ORDER PARTIALLY  / INCREMENT THE STOCK by 2
		var vendorOrder_receiveData={
			vendorOrderID=vendorOrder.getVendorOrderID(),
			preProcessDisplayedFlag=1,
			packingSlipNumber=1,
			boxCount=1,
			locationID=SandiegoLocation.getLocationID(),
			vendorOrder={
				shippingAndHandlingCost=10.00,
				costDistributionType='quantity'				
			},
			vendorOrderItems=[
				{
					vendorOrderItem={
						vendorOrderItemID=vendorOrder.getVendorOrderItems()[1].getVendorOrderItemID()
						
					},
					//partial recieve
					quantity=2
				}
			]
		};
		vendorOrder = variables.vendorOrderService.process(vendorOrder,vendorOrder_receiveData,'Receive');
		request.slatwallScope.flushOrmSession(true);

		for (var entity in request.slatwallScope.getModifiedEntities()) {
			debug(entity.getClassName());
		}
		
		//verify that the vendor order is partially received
		assertEquals(vendorOrder.getVendorOrderStatusType().getSystemCode(),'vostPartiallyReceived');
		assertEquals(vendorOrder.getVendorOrderItems()[1].getQuantityUnreceived(),8);

		//clear the session and reload the entity to get the calculated properties to reflect since there is not multiple requests

		// Manually remove references to any modified entites otherwise they could be referenced in other ORM session and conflict when flushORMSession executes
		request.slatwallScope.clearModifiedEntities();

		//removes first level cache
		ORMClearSession();
		sku = variables.service.getSku(sku.getSkuID());
		
		//make sure the stock recievers, items and inventory were incremented
		assertEquals(sku.getQATS(),2);
		assertEquals(arraylen(vendorOrder.getStockReceivers()),1);
		assertEquals(arraylen(vendorOrder.getStockReceivers()[1].getStockReceiverItems()),1);
		assertEquals(vendorOrder.getStockReceivers()[1].getReceiverType(),'vendororder');
		assertEquals(vendorOrder.getStockReceivers()[1].getStockReceiverItems()[1].getStock().getSku().getSkuID(),sku.getSkuID());
		
		//CUSTOMER CREATES ORDER
		
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
		order = variables.orderService.process(order,orderData,'create');
		request.slatwallScope.flushOrmSession(true);
		

		//SET UP PLACE ORDER
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
		
		//ADD ORDERITEM FROM OUR JUST ADDED INVENTORY

		var addOrderItemData={
			skuID=sku.getSkuID(),
			orderItemTypeSystemCode="oitSale",
			quantity=1,
			price=1.00,
			orderFulfillmentID="new",
			//shipping
			fulfillmentMethodID='444df2fb93d5fa960ba2966ba2017953',
			//default location
			//pickupLocationID='88e6d435d3ac2e5947c81ab3da60eba2',
			shippingAccountAddressID=accountAddress.getAccountAddressID(),
			shippingAddress.countryCode='US',
			saveShippingAccountAddressFlag=1,
			preProcessDisplayedFlag=1
		};
		order = variables.orderService.process(order,addOrderItemData,'addOrderItem');
		debug(order.getErrors());
		variables.orderService.getDao('hibachiDao').flushOrmSession();
		
		//check to make sure and orderfulfillment was created
		assert(arraylen(order.getOrderFulfillments()));


		//CUSTOMER PLACES ORDER
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

		order = variables.orderService.process(order,placeOrderData,'placeOrder');
		variables.orderService.getDao('hibachiDao').flushOrmSession();


		//WAREHOUSE SHIPS ORDER / CREATE ORDER DELIVERY from San Diego
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
				locationID=sandiegoLocation.getLocationID()
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
		orderDelivery = variables.orderService.process(orderDelivery,orderDeliveryData,'create');
		variables.orderService.getDao('hibachiDao').flushOrmSession();
		
		//make sure that the order delivery was Shipped to the customer
		assert(arrayLen(orderDelivery.getOrderDeliveryItems()));
		assertEquals(orderDelivery.getOrderDeliveryItems()[1].getQuantity(),1);
		
		//clear first level cache so we can get new calculations
		ORMCLEARSESSION();
		var sku = variables.service.getSku(sku.getSkuID());
		
		//make sure that an item was removed from inventory when it shipped out
		assertEquals(sku.getQATS(),1);
		
		//SECOND VENDOR ORDER PLACED FROM A SEPERATE LOCATION
		
		//SET UP 2nd VENDOR ORDER
		var secondVendorOrderData = {
			vendorOrderID="",
			currencyCode="USD",
			vendor={
				vendorID=testVendor.getVendorID()
			},
			vendorOrderNumber="123",
			//estimatedReceivalDateTime="Jan 30, 2017 12:00 AM",
			billToLocation={
				locationID=NewYorkLocation.getLocationID()
			},
			shippingAndHandlingCost=10,
			costDistributionType='quantity'
		};
		var secondVendorOrder = createTestEntity('VendorOrder',{});
		
		secondVendorOrder = variables.vendorOrderService.saveVendorORder(secondVendorOrder,secondVendorOrderData);
		request.slatwallScope.flushORMSession(true);
		
		//ADD VENDOR ORDER ITEM to 2nd VENDOR ORDER / PLACE THE VENDOR ORDER
		var secondVendorOrder_addOrderItemData = {
			skuID=sku.getSkuID(),
			vendorOrderItemTypeSystemCode='voitPurchase',
			vendorOrderID=secondVendorOrder.getVendorOrderID(),
			deliverToLocationID=newYorkLocation.getLocationID(),
			quantity=10,
			cost=50
			//,vendorSkuID=1
		};
		
		secondVendorOrder = variables.vendorOrderService.process(secondVendorOrder,secondVendorOrder_addOrderItemData,'AddVendorOrderItem');
		request.slatwallScope.flushORMSession(true);
		assert(arraylen(secondVendorOrder.getVendorOrderItems())==1);
		
		//COMPLETE RECIEVING 1st VENDOR ORDER FULLY  / INCREMENT THE STOCK by 2
		vendorOrder_receiveData={
			vendorOrderID=vendorOrder.getVendorOrderID(),
			preProcessDisplayedFlag=1,
			packingSlipNumber=1,
			boxCount=1,
			locationID=SandiegoLocation.getLocationID(),
			vendorOrder={
				shippingAndHandlingCost=10.00,
				costDistributionType='quantity'				
			},
			vendorOrderItems=[
				{
					vendorOrderItem={
						vendorOrderItemID=vendorOrder.getVendorOrderItems()[1].getVendorOrderItemID()
						
					},
					//partial recieve
					quantity=6
				}
			]
		};
		vendorOrder = variables.service.getVendorOrder(vendorOrder.getVendorOrderID());
		vendorOrder = variables.vendorOrderService.process(vendorOrder,vendorOrder_receiveData,'Receive');
		request.slatwallScope.flushOrmSession(true);
		
		assertEquals(vendorOrder.getVendorOrderStatusType().getSystemCode(),'vostPartiallyReceived');
		assertEquals(vendorOrder.getVendorOrderItems()[1].getQuantityUnreceived(),2);
		
		//2nd Customer placed Order
		
		//RECEIVE 2nd VENDOR ORDER / INCREMENT THE STOCK
//		var secondVendorOrder_receiveData={
//			vendorOrderID=vendorOrder.getVendorOrderID(),
//			preProcessDisplayedFlag=1,
//			packingSlipNumber=1,
//			boxCount=1,
//			locationID=SandiegoLocation.getLocationID(),
//			vendorOrder={
//				shippingAndHandlingCost=10.00,
//				costDistributionType='quantity'				
//			},
//			vendorOrderItems=[
//				{
//					vendorOrderItem={
//						vendorOrderItemID=vendorOrder.getVendorOrderItems()[1].getVendorOrderItemID()
//						
//					},
//					//partial recieve
//					quantity=2
//				}
//			]
//		};
//		vendorOrder = variables.vendorOrderService.process(vendorOrder,vendorOrder_receiveData,'Receive');
//		request.slatwallScope.flushOrmSession(true);
	}*/
}
