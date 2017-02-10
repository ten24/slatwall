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
component extends="Slatwall.meta.tests.unit.entity.SlatwallEntityTestBase" {
	
	// @hint put things in here that you want to run befor EACH test
	public void function setUp() {
		super.setup();
		variables.entity = request.slatwallScope.newEntity( 'Order' );
	}

	// Orders are alowed to be saved with no data
	public void function validate_as_save_for_a_new_instance_doesnt_pass() {
		variables.entity.validate(context="save");
		assertFalse( variables.entity.hasErrors() );
	}
	
	public void function hasCreditCardPaymentMethodTest(){
		var orderData ={
			orderID=""
		};
		var order = createPersistedTestEntity('Order',orderData);
		assertFalse(order.hasCreditCardPaymentMethod());
		
		var orderPaymentData = {
			orderPaymentID="",
			paymentMethod={
				//credit card
				paymentMethodID="444df303dedc6dab69dd7ebcc9b8036a"
			}
		};
		var orderPayment= createPersistedTestEntity('OrderPayment',orderPaymentData);
		
		order.addOrderPayment(orderPayment);
		orderPayment.setOrder(order);
		
		assert(arraylen(order.getOrderPayments()));
		
		assert(order.hasCreditCardPaymentMethod());
		
		order.removeOrderPayment(orderPayment);
		assertFalse(order.hasCreditCardPaymentMethod());
	}

	public void function validate_billingAddress_as_full_fails_when_not_fully_populated() {
		var populateData = {
			billingAddress = {
				addressID = '',
				name="Example Name",
				countryCode="US"
			}
		};

		variables.entity.populate( populateData );

		variables.entity.validate( context="save" );

		assert( !isNull(variables.entity.getBillingAddress()), "The orders address was never populated in the first place" );
		assertEquals( "Example Name", variables.entity.getBillingAddress().getName(), "The orders address was never populated in the first place" );
		assert( variables.entity.hasErrors(), "The order doesn't show that it has errors when it should because the billing address was not fully populated" );
	}

	public void function validate_billingAddress_as_full_passes_when_fully_populated() {
		var populateData = {
			billingAddress = {
				addressID = '',
				name="Example Name",
				streetAddress="123 Main Street",
				city="Encinitas",
				stateCode="CA",
				postalCode="92024",
				countryCode="US"
			}
		};

		variables.entity.populate( populateData );

		variables.entity.validate( context="save" );

		assert( !isNull(variables.entity.getBillingAddress()), "The orders address was never populated in the first place" );
		assertEquals( "Example Name", variables.entity.getBillingAddress().getName(), "The orders address was never populated in the first place" );
		assertFalse( variables.entity.hasErrors(), "The order shows that it has errors event when it was populated" );
	}

	public void function validate_shippingAddress_as_full_fails_when_not_fully_populated() {
		var populateData = {
			shippingAddress = {
				addressID = '',
				name="Example Name",
				countryCode="US"
			}
		};

		variables.entity.populate( populateData );

		variables.entity.validate( context="save" );

		assert( !isNull(variables.entity.getShippingAddress()), "The orders address was never populated in the first place" );
		assertEquals( "Example Name", variables.entity.getShippingAddress().getName(), "The orders address was never populated in the first place" );
		assert( variables.entity.hasErrors(), "The order doesn't show that it has errors when it should because the billing address was not fully populated" );
	}

	public void function validate_shippingAddress_as_full_passes_when_fully_populated() {
		var populateData = {
			shippingAddress = {
				addressID = '',
				name="Example Name",
				streetAddress="123 Main Street",
				city="Encinitas",
				stateCode="CA",
				postalCode="92024",
				countryCode="US"
			}
		};

		variables.entity.populate( populateData );

		variables.entity.validate( context="save" );

		assert( !isNull(variables.entity.getShippingAddress()), "The orders address was never populated in the first place" );
		assertEquals( "Example Name", variables.entity.getShippingAddress().getName(), "The orders address was never populated in the first place" );
		assertFalse( variables.entity.hasErrors(), "The order shows that it has errors event when it was populated" );
	}

	public void function setBillingAccountAddress_updates_billingAddress() {

		var accountAddressDataOne = {
			address = {
				addressID = "",
				streetAddress = "123 Main Street"
			}
		};
		var accountAddressDataTwo = {
			address = {
				addressID = "",
				streetAddress = "456 Main Street"
			}
		};
		var accountAddressOne = createPersistedTestEntity( 'AccountAddress', accountAddressDataOne );
		var accountAddressTwo = createPersistedTestEntity( 'AccountAddress', accountAddressDataTwo );

		variables.entity.setBillingAccountAddress( accountAddressOne );

		assertEquals( accountAddressDataOne.address.streetAddress, variables.entity.getBillingAddress().getStreetAddress() );

		variables.entity.setBillingAccountAddress( accountAddressTwo );

		assertEquals( accountAddressDataTwo.address.streetAddress, variables.entity.getBillingAddress().getStreetAddress() );

	}

	public void function setBillingAccountAddress_updates_billingAddress_without_creating_a_new_one() {
		addressDataOne = {
			streetAddress = '123 Main Street'
		};
		var accountAddressDataOne = {
			address = {
				addressID = "",
				streetAddress = "456 Main Street"
			}
		};
		var billingAddress = createPersistedTestEntity( 'Address', addressDataOne );
		var accountAddress = createPersistedTestEntity( 'AccountAddress', accountAddressDataOne );

		variables.entity.setBillingAddress( billingAddress );

		assertEquals( addressDataOne.streetAddress, variables.entity.getBillingAddress().getStreetAddress() );
		assertEquals( billingAddress.getAddressID(), variables.entity.getBillingAddress().getAddressID() );

		variables.entity.setBillingAccountAddress( accountAddress );

		assertEquals( accountAddressDataOne.address.streetAddress, variables.entity.getBillingAddress().getStreetAddress() );
		assertEquals( billingAddress.getAddressID(), variables.entity.getBillingAddress().getAddressID() );
	}

	public void function setBillingAccountAddress_doesnt_updates_billingAddress_when_same_aa_as_before() {
		var accountAddressDataOne = {
			address = {
				addressID = "",
				streetAddress = "456 Main Street"
			}
		};

		var accountAddress = createPersistedTestEntity( 'AccountAddress', accountAddressDataOne );

		variables.entity.setBillingAccountAddress( accountAddress );

		assertEquals( accountAddressDataOne.address.streetAddress, variables.entity.getBillingAddress().getStreetAddress() );

		variables.entity.getBillingAddress().setStreetAddress('123 Main Street');

		variables.entity.setBillingAccountAddress( accountAddress );

		assertEquals( '123 Main Street', variables.entity.getBillingAddress().getStreetAddress() );

	}

	public void function setShippingAccountAddress_updates_shippingAddress() {

		var accountAddressDataOne = {
			address = {
				addressID = "",
				streetAddress = "123 Main Street"
			}
		};
		var accountAddressDataTwo = {
			address = {
				addressID = "",
				streetAddress = "456 Main Street"
			}
		};
		var accountAddressOne = createPersistedTestEntity( 'AccountAddress', accountAddressDataOne );
		var accountAddressTwo = createPersistedTestEntity( 'AccountAddress', accountAddressDataTwo );

		variables.entity.setShippingAccountAddress( accountAddressOne );

		assertEquals( accountAddressDataOne.address.streetAddress, variables.entity.getShippingAddress().getStreetAddress() );

		variables.entity.setShippingAccountAddress( accountAddressTwo );

		assertEquals( accountAddressDataTwo.address.streetAddress, variables.entity.getShippingAddress().getStreetAddress() );

	}

	public void function setShippingAccountAddress_updates_shippingAddress_without_creating_a_new_one() {
		addressDataOne = {
			streetAddress = '123 Main Street'
		};
		var accountAddressDataOne = {
			address = {
				addressID = "",
				streetAddress = "456 Main Street"
			}
		};
		var shippingAddress = createPersistedTestEntity( 'Address', addressDataOne );
		var accountAddress = createPersistedTestEntity( 'AccountAddress', accountAddressDataOne );

		variables.entity.setShippingAddress( shippingAddress );

		assertEquals( addressDataOne.streetAddress, variables.entity.getShippingAddress().getStreetAddress() );
		assertEquals( shippingAddress.getAddressID(), variables.entity.getShippingAddress().getAddressID() );

		variables.entity.setShippingAccountAddress( accountAddress );

		assertEquals( accountAddressDataOne.address.streetAddress, variables.entity.getShippingAddress().getStreetAddress() );
		assertEquals( shippingAddress.getAddressID(), variables.entity.getShippingAddress().getAddressID() );
	}

	public void function setShippingAccountAddress_doesnt_updates_shippingAddress_when_same_aa_as_before() {
		var accountAddressDataOne = {
			address = {
				addressID = "",
				streetAddress = "456 Main Street"
			}
		};

		var accountAddress = createPersistedTestEntity( 'AccountAddress', accountAddressDataOne );

		variables.entity.setShippingAccountAddress( accountAddress );

		assertEquals( accountAddressDataOne.address.streetAddress, variables.entity.getShippingAddress().getStreetAddress() );

		variables.entity.getShippingAddress().setStreetAddress('123 Main Street');

		variables.entity.setShippingAccountAddress( accountAddress );

		assertEquals( '123 Main Street', variables.entity.getShippingAddress().getStreetAddress() );

	}
	
	
	private any function createMockOrder(string orderTypeID='', string orderStatusTypeID='') {
		var orderData = {
			orderID = ""
		};
		if(len(arguments.orderTypeID)){
			orderData.orderType = {
				typeID = arguments.orderTypeID
			};
		}
		if(len(arguments.orderStatusTypeID)){
			orderData.orderStatusType = {
				typeID = arguments.orderStatusTypeID
			};
		}
		return createPersistedTestEntity('Order', orderData);
	}
	
	
	/**
	* This function is exactly same with the one in OrderItemTest.cfc
	*/
	private any function createMockOrderItem(string orderItemTypeID='', numeric quantity, string skuID='') {
		var orderItemData = {
			orderItemID = ""
		};
		if(len(arguments.orderItemTypeID)){
			orderItemData.orderItemType = {
				typeID = arguments.orderItemTypeID
			};
		}
		if(!isNull(arguments.quantity)) {
			orderItemData.quantity = arguments.quantity;
		}
		if(len(arguments.skuID)){
			orderItemData.sku = {
				skuID = arguments.skuID
			};
		}
		return createPersistedTestEntity('OrderItem', orderItemData);
	}
	
	private any function createMockOrderWithOrderItems(required array orderItemArray, string orderTypeID='') {
		var orderData = {
			orderID = "",
			orderItems = []
		};
		for (var i = 1; i <= arrayLen(orderItemArray); i++) {
			orderData.orderItems[i] = {
				orderItemID = orderItemArray[i]
			};
		}
		if(len(arguments.orderTypeID)){
			orderData.orderType = {
				typeID = arguments.orderTypeID
			};
		}
		return createPersistedTestEntity('Order', orderData);
	}
	
	private any function createMockOrderPayment(string orderID='', string orderPaymentTypeID='', numeric amount, string orderPaymentMethodID='') {
	 	var orderPaymentData = {
	 		orderPaymentID = ''
	 	};
	 	if(len(arguments.orderID)) {
	 		orderPaymentData.order = {
	 			orderID = arguments.orderID
	 		};
	 	}
	 	if(len(arguments.orderPaymentTypeID)) {
	 		orderPaymentData.orderPaymentType = {
	 			typeID = arguments.orderPaymentTypeID
	 		};
	 	}
	 	if(!isNull(arguments.amount)) {
	 		orderPaymentData.amount = arguments.amount;
	 	}
	 	if(len(arguments.orderPaymentMethodID)) {
	 		orderPaymentData.orderPaymentMethod = {
	 			orderPaymentMethodID = arguments.orderPaymentMethodID
	 		};
	 	}
	 	return createPersistedTestEntity('OrderPayment', orderPaymentData);
	 }
	 
	 //===================== START: Injected Functions: General ===============================
	private numeric function returnSevenHundred() {
		return 700;
	}
	private numeric function returnTen() {
		return 10;
	}
	private numeric function returnZero() {
		return 0;
	}
	private numeric function returnMinusTen() {
		return -10;
	}
	private boolean function returnTrue() {
		return TRUE;
	}
	private boolean function returnFalse() {
		return FALSE;
	}
	private string function returnOneString() {
		return 'OneString';
	}
	//===================== END: Injected Functions: General =================================
	
	//====================== START: Injected Functions in OrderService.cfc ===================
	private numeric function getOrderPaymentNonNullAmountTotal(){
		return 70;
	} 
	private numeric function getPreviouslyReturnedFulfillmentTotal() {
		return 30;
	}
	private array function getMaxOrderNumberTen() {
		return [10];
	}
	//====================== END: Injected Functions in OrderService.cfc =====================
	
	//====================== START: Injected Functions in OrderPayment.cfc ===================
	private string function returnOpstInvalid() {
		return 'opstInvalid';
	}
	
	private any function getDynamicChargeOrderPaymentNotNull() {
		var orderPaymentData = { 
			orderPaymentID = '',
			orderPaymentType = {
				typeID = '444df2f0fed139ff94191de8fcd1f61b'//optCharge
			}
			//getDynamicAmountFlag() returns TRUE 
			// getStatusCode() set to 'opstActive' by default
		};
		var mockOrderPayment= request.slatwallScope.newEntity('OrderPayment');
		
		mockOrderPayment.populate(orderPaymentData);
		return mockOrderPayment;
	}
	
	private any function getDynamicCreditOrderPaymentNotNull() {
		var orderPaymentData = { 
			orderPaymentID = '',
			orderPaymentType = {
				typeID = '444df2f1cc40d0ea8a2de6f542ab4f1d'//optCredit
			}
			//getDynamicAmountFlag() returns TRUE 
			// getStatusCode() set to 'opstActive' by default
		};

		return createPersistedTestEntity('OrderPayment', orderPaymentData);
		//TODO: This scope should throw error CREATEPERSISTEDTESTENTITY undefined, but didn't
	}
	//====================== END: Injected Functions in OrderPayment.cfc =================== 

	
	 
	
	public void function getOrderTypeTest() {
		var mockOrder = createMockOrder();
		
		var result = mockOrder.getOrderType();
		assertEquals('444df2df9f923d6c6fd0942a466e84cc', result.getTypeID());
		assertEquals('sales order', result.getTypeName());
	}
	
	public void function getOrderStatusType() {
		var mockOrder = createMockOrder();
		
		var result = mockOrder.getOrderStatusType();
		assertEquals('444df2b498de93b4b33001593e96f4be', result.getTypeID());
		assertEquals('not placed', result.getTypeName());
	}
	
	public void function getStatusTest() {
		var mockOrder = createMockOrder();
		
		var result = mockOrder.getStatus();
		assertEquals('not placed', result);
	}
	
	public void function getStatusCodeTest() {
		var mockOrder = createMockOrder();
		
		var result = mockOrder.getStatusCode();
		assertEquals('ostNotPlaced', result);
	}
	
	public void function getTypeTest() {
		var mockOrder = createMockOrder();
		
		var result = mockOrder.getType();
		assertEquals('Sales Order', result);
	}
	
	public void function getTypeCodeTest() {
		var mockOrder = createMockOrder();
		
		var result = mockOrder.getTypeCode();
		assertEquals('otSalesOrder', result);
	}
	
	
	public void function getSaleItemSmartListTest() {
		var mockOrderItem1 = createMockOrderItem('444df2e9a6622ad1614ea75cd5b982ce');//oitSale
		var mockOrderItem2 = createMockOrderItem('444df2eac18fa589af0f054442e12733');//oitReturn
		var mockOrderItem3 = createMockOrderItem('d98bbd66f5dfafd0eb8c727cc4053b46');//oitDeposit
		var mockOrderItem4 = createMockOrderItem('444df2e9a6622ad1614ea75cd5b982ce');//oitSales
		var mockOrderItem5 = createMockOrderItem('444df2eac18fa589af0f054442e12733');//oitReturn
		
		var mockOrder1 = createMockOrderWithOrderItems([mockOrderItem1.getOrderItemID(), 
														mockOrderItem2.getOrderItemID(),
														mockOrderItem3.getOrderItemID()]);
		var mockOrder2 = createMockOrderWithOrderItems([mockOrderItem4.getOrderItemID(), 
														mockOrderItem5.getOrderItemID()]);
		
		//Testing the filter on orderItemType
		var resultOrderItemSmartList1 = mockOrder1.getSaleItemSmartList().getRecords(refresh = true);
		assertTrue(arrayFind(resultOrderItemSmartList1, mockOrderItem1) != 0);
		assertTrue(arrayFind(resultOrderItemSmartList1, mockOrderItem2) == 0);
		assertTrue(arrayFind(resultOrderItemSmartList1, mockOrderItem3) == 0);
		
		//Testing the filter on OrderID
		var resultOrderItemSmartList2 = mockOrder2.getSaleItemSmartList().getRecords(refresh = true);
		assertTrue(arrayFind(resultOrderItemSmartList2, mockOrderItem4) != 0);
	}
	
	public void function getReturnItemSmartListTest() {
		var mockOrderItem1 = createMockOrderItem('444df2e9a6622ad1614ea75cd5b982ce');//oitSale
		var mockOrderItem2 = createMockOrderItem('444df2eac18fa589af0f054442e12733');//oitReturn
		var mockOrderItem3 = createMockOrderItem('d98bbd66f5dfafd0eb8c727cc4053b46');//oitDeposit
		var mockOrderItem4 = createMockOrderItem('444df2e9a6622ad1614ea75cd5b982ce');//oitSales
		var mockOrderItem5 = createMockOrderItem('444df2eac18fa589af0f054442e12733');//oitReturn
		
		var mockOrder1 = createMockOrderWithOrderItems([mockOrderItem1.getOrderItemID(), 
														mockOrderItem2.getOrderItemID(),
														mockOrderItem3.getOrderItemID()]);
		var mockOrder2 = createMockOrderWithOrderItems([mockOrderItem4.getOrderItemID(), 
														mockOrderItem5.getOrderItemID()]);
		
		//Testing the filter on orderItemType
		var resultOrderItemSmartList1 = mockOrder1.getReturnItemSmartList().getRecords(refresh = true);
		assertTrue(arrayFind(resultOrderItemSmartList1, mockOrderItem1) == 0);
		assertTrue(arrayFind(resultOrderItemSmartList1, mockOrderItem2) != 0);
		assertTrue(arrayFind(resultOrderItemSmartList1, mockOrderItem3) == 0);
		
		//Testing the filter on OrderID
		var resultOrderItemSmartList2 = mockOrder2.getReturnItemSmartList().getRecords(refresh = true);
		assertTrue(arrayFind(resultOrderItemSmartList2, mockOrderItem5) != 0);
	}
	
	public void function getDepositItemSmartListTest() {
		var mockOrderItem1 = createMockOrderItem('444df2e9a6622ad1614ea75cd5b982ce');//oitSale
		var mockOrderItem2 = createMockOrderItem('444df2eac18fa589af0f054442e12733');//oitReturn
		var mockOrderItem3 = createMockOrderItem('d98bbd66f5dfafd0eb8c727cc4053b46');//oitDeposit
		var mockOrderItem4 = createMockOrderItem('d98bbd66f5dfafd0eb8c727cc4053b46');//oitDeposit
		
		var mockOrder1 = createMockOrderWithOrderItems([mockOrderItem1.getOrderItemID(), 
														mockOrderItem2.getOrderItemID(),
														mockOrderItem3.getOrderItemID()]);
		var mockOrder2 = createMockOrderWithOrderItems([mockOrderItem4.getOrderItemID()]);
		
		//Testing the filter on orderItemType
		var resultOrderItemSmartList1 = mockOrder1.getDepositItemSmartList().getRecords(refresh = true);
		assertTrue(arrayFind(resultOrderItemSmartList1, mockOrderItem1) == 0);
		assertTrue(arrayFind(resultOrderItemSmartList1, mockOrderItem2) == 0);
		assertTrue(arrayFind(resultOrderItemSmartList1, mockOrderItem3) != 0);
		
		//Testing the filter on OrderID
		var resultOrderItemSmartList2 = mockOrder2.getDepositItemSmartList().getRecords(refresh = true);
		assertTrue(arrayFind(resultOrderItemSmartList2, mockOrderItem4) != 0);
	}
	
	public void function getOrderTypeOptionsTest_OrderTypeFilter() {
		var mockOrderItem1 = createMockOrderItem('444df2e9a6622ad1614ea75cd5b982ce');//oitSale
		var mockOrderItem2 = createMockOrderItem('444df2eac18fa589af0f054442e12733');//oitReturn
		var mockOrderItem3 = createMockOrderItem('d98bbd66f5dfafd0eb8c727cc4053b46');//oitDeposit
		
		var mockOrder1 = createMockOrderWithOrderItems([mockOrderItem1.getOrderItemID(), 
														mockOrderItem2.getOrderItemID(),
														mockOrderItem3.getOrderItemID()],
														'444df2e00b455a2bae38fb55f640c204');//otExchangeOrder
		var mockOrder2 = createMockOrder();
		
		//Testing when the inFilter only have otExchangeOrder
		var resultOrder1 = mockOrder1.getOrderTypeOptions();
		assertEquals('Exchange Order', resultOrder1[1]['name']);
		
		//Testing when the inFilter have all three types
		var SaleStruct = {
			name = 'Sales Order',
			value = '444df2df9f923d6c6fd0942a466e84cc'
		};
		var ReturnStruct = {
			name = 'Return Order',
			value = '444df2dd05a67eab0777ba14bef0aab1'
		};
		var ExchangeStruct = {
			name = 'Exchange Order',
			value = '444df2e00b455a2bae38fb55f640c204'
		};
		
		var resultOrder2 = mockOrder2.getOrderTypeOptions();
		assertTrue(arrayFind(resultOrder2, saleStruct) != 0);
		assertTrue(arrayFind(resultOrder2, ReturnStruct) != 0);
		assertTrue(arrayFind(resultOrder2, ExchangeStruct) != 0);
	}
	
	public void function getOrderTypeOptionsTest_IfStatements() {
		var mockOrderItem1 = createMockOrderItem('444df2e9a6622ad1614ea75cd5b982ce');//oitSale
		var mockOrderItem2 = createMockOrderItem('444df2eac18fa589af0f054442e12733');//oitReturn
		var mockOrderItem3 = createMockOrderItem('d98bbd66f5dfafd0eb8c727cc4053b46');//oitDeposit
		
		var mockOrder1 = createMockOrderWithOrderItems([mockOrderItem1.getOrderItemID(), 
														mockOrderItem2.getOrderItemID(),
														mockOrderItem3.getOrderItemID()]);
		
		var mockOrderItem4 = createMockOrderItem('444df2e9a6622ad1614ea75cd5b982ce');//oitSale
		var mockOrderItem5 = createMockOrderItem('d98bbd66f5dfafd0eb8c727cc4053b46');//oitDeposit
		
		var mockOrder2 = createMockOrderWithOrderItems([mockOrderItem5.getOrderItemID(), 
														mockOrderItem4.getOrderItemID()]);
														
		var mockOrderItem6 = createMockOrderItem('444df2eac18fa589af0f054442e12733');//oitReturn
		var mockOrderItem7 = createMockOrderItem('d98bbd66f5dfafd0eb8c727cc4053b46');//oitDeposit
		
		var mockOrder3 = createMockOrderWithOrderItems([mockOrderItem6.getOrderItemID(), 
														mockOrderItem7.getOrderItemID()]);
		
		//Three Expected Structures in the result
		var SaleStruct = {
			name = 'Sales Order',
			value = '444df2df9f923d6c6fd0942a466e84cc'
		};
		var ReturnStruct = {
			name = 'Return Order',
			value = '444df2dd05a67eab0777ba14bef0aab1'
		};
		var ExchangeStruct = {
			name = 'Exchange Order',
			value = '444df2e00b455a2bae38fb55f640c204'
		};
		
		//Testing when both if logics work
		var resultOrder1 = mockOrder1.getOrderTypeOptions();
		assertEquals('Exchange Order', resultOrder1[1]['name']);
		
		//Testing when only getSaleItemSmartList() > 0
		var resultOrder2 = mockOrder2.getOrderTypeOptions();
		assertTrue(arrayFind(resultOrder2, saleStruct) != 0);
		assertTrue(arrayFind(resultOrder2, ReturnStruct) == 0);
		assertTrue(arrayFind(resultOrder2, ExchangeStruct) != 0);
		
		//Testing when only getReturnItemSmartList() > 0
		var resultOrder3 = mockOrder3.getOrderTypeOptions();
		assertTrue(arrayFind(resultOrder3, saleStruct) == 0);
		assertTrue(arrayFind(resultOrder3, ReturnStruct) != 0);
		assertTrue(arrayFind(resultOrder3, ExchangeStruct) != 0);
	}
	
	public void function hasItemsQuantityWithinMaxOrderQuantityTest() {
		var skuData = {
			skuID = ''
		};
		var mockSku = createPersistedTestEntity('Sku', skuData);
		
		var productData = {
			productID = '',
			skus = [{
				skuID = mockSku.getSkuID()
			}]
		};
		var mockProduct = createPersistedTestEntity('Product', productData);
		
		//Testing the oitSale type with more than maximum quantity
		var mockOrderItemWithSaleType = createMockOrderItem('444df2e9a6622ad1614ea75cd5b982ce', 1500, mockSku.getSkuID()); 
		var mockOrderWithSaleType = createMockOrderWithOrderItems([mockOrderItemWithSaleType.getOrderItemID()]);
											
		var resultWithType = mockOrderWithSaleType.hasItemsQuantityWithinMaxOrderQuantity();
		assertFalse(resultWithType, 'The quantity of this order is 1500, more than maximum');
		
		//Testing when no type defined
		var mockOrderItemNoType = createMockOrderItem(quantity=10, skuID=mockSku.getSkuID());
		var mockOrderNoType = createMockOrderWithOrderItems([mockOrderItemNoType.getOrderItemID()]);
		
		var resultNoType = mockOrderNoType.hasItemsQuantityWithinMaxOrderQuantity();
		assertTrue(resultNoType, 'The types except oitSale should return true');
		
		//Testing the type oitReturn
		var mockOrder = createMockOrder();
		
		var resultNoOrderItem = mockOrder.hasItemsQuantityWithinMaxOrderQuantity();
		assertTrue(resultNoOrderItem, 'If no OrderItem involved with the order, shoulds return true');
	}
	
	 public void function getAddPaymentRequirementDetailsTest_ChargeAmount() {
	 	var mockOrder = createSimpleMockEntityByEntityName('Order');
	 	
	 	injectMethod(mockOrder, this, 'returnSevenHundred', 'getTotal');
	 	injectMethod(mockOrder, this, 'returnTen', 'getPaymentAmountTotal');
	 	
	 	var resultCharge = mockOrder.getAddPaymentRequirementDetails();
	 	assertEquals('optCharge', resultCharge.orderPaymentType.getSystemCode(), 'The requiredAmount > 0 logic returns wrong type');
	 	assertEquals(690, resultCharge.amount, 'The requiredAmount > 0 logic returns incorrect amount');
	 	
	 	restoreMethod(mockOrder, 'getTotal');
	 	restoreMethod(mockOrder, 'getPaymentAmountTotal');	 	
	 }
	 
	 public void function getAddPaymentRequirementDetailsTest_CreditAmount() {
	 	var mockOrder = createSimpleMockEntityByEntityName('Order');
	 	
	 	injectMethod(mockOrder, this, 'returnTen', 'getTotal');
	 	injectMethod(mockOrder, this, 'returnSevenHundred', 'getPaymentAmountTotal');
	 	
	 	var resultCredit = mockOrder.getAddPaymentRequirementDetails();
	 	assertEquals(690, resultCredit.amount, 'The requiredAmount < 0 logic returns incorrect amount');
	 	assertEquals('optCredit', resultCredit.orderPaymentType.getSystemCode(), 'The requiredAmount < 0 logic returns wrong type');
	 	
	 }
	 public void function getAddPaymentRequirementDetailsTest_AmountZero() {
	 	var mockOrder = createSimpleMockEntityByEntityName('Order');
	 	
	 	//This function is called when order.getPaymentAmountTotal() NEQ order.getTotal() in preprocessorder_placeorder.cfm
	 	var result = mockOrder.getAddPaymentRequirementDetails();
	 	assertEquals({}, result, 'When requiredAmount == 0 should return an empty struct');
	 }
	 
	 public void function confirmOrderNumberOpenDateCloseDatePaymentAmountTest_ProcessingAndInternal_testAllSetters() {
	 	var mockOrderPayment1 = createMockOrderPayment(amount = 1);
	 	var mockOrderPayment2 = createMockOrderPayment(amount = 2);
	 	
	 	injectMethod(mockOrderPayment2, this, 'returnTen', 'getAmount');
	 	
	 	var orderData = {
	 		orderID = '',
	 		orderStatusType = {
	 			typeID = '444df2b6b8b5d1ccfc14a4ab38aa0a4c'//ostProcessing
	 		},
	 		orderPayments = [
	 			{
	 				orderPaymentID = mockOrderPayment1.getOrderPaymentID()
	 			}, {
	 				orderPaymentID = mockOrderPayment2.getOrderPaymentID()
	 			}
	 		]
	 	};
	 	var mockOrder = createTestEntity('Order', orderData);
		
	 	var orderService = new Slatwall.model.service.OrderService();
	 	injectMethod(orderService, this, 'getMaxOrderNumberTen', 'getMaxOrderNumber');
	 	mockOrder.setOrderService(orderService);
	 	
	 	mockOrder.confirmOrderNumberOpenDateCloseDatePaymentAmount();
		assertEquals(11, mockOrder.getOrderNumber(), 'The OrderNumber should be 10 + 1 = 11, the test fails');
	 	assertEquals(now(), mockOrder.getOrderOpenDateTime(), 'OpenDateTime should be now()');
	 	assertEquals(CGI.REMOTE_ADDR, mockOrder.getOrderOpenIPAddress(), 'The address should be 127.0.0.1');
	 	
	 	assertEquals(1, mockOrder.getOrderPayments()[1].getAmount(), 'The orderPayment.setAmount() return an incorrect amount');
	 	assertEquals(10, mockOrder.getOrderPayments()[2].getAmount(), 'The orderPayment.setAmount() should return 10 same with the injected function returns');
	 	assertTrue(!isDefined(mockORder.getOrderCloseDateTime()), 'The ostProcessing status type should not have OrderCloseDateTime()');
	 }
	 
	 public void function confirmOrderNumberOpenDateCloseDatePaymentAmountTest_ostClosed() {
	 	var orderData = {
	 		orderID = '',
	 		orderStatusType = {
	 			typeID = '444df2b8b98441f8e8fc6b5b4266548c'//ostClosed
	 		}
	 	};
	 	var mockOrder = createTestEntity('Order', orderData);
	 	
	 
	 	
	 	mockOrder.confirmOrderNumberOpenDateCloseDatePaymentAmount();
		assertEquals(now(), mockORder.getOrderCloseDateTime(), 'The ostClosed status type should have OrderCloseDateTime()');
	 }
	 
	 public void function isPaidTest() {
	 	var mockOrder = createSimpleMockEntityByEntityName('Order');
	 	
	 	injectMethod(mockOrder, this, 'returnTen', 'getPaymentAmountReceivedTotal');
	 	var resultPaid = mockOrder.isPaid();
	 	assertTrue(resultPaid, '10 > getTotal() should return TRUE');
	 	
	 	injectMethod(mockOrder, this, 'returnSevenHundred', 'getTotal');
	 	var resultUnpaid = mockOrder.isPaid();
	 	assertFalse(resultUnpaid, '10 < 700 should return FALSE');
	 }

	 public void function getDeliveredOrderItemsTest() {
	 	var mockOrder 		   = createSimpleMockEntityByEntityName('Order', FALSE);
	 	var orderDelivery 	   = createSimpleMockEntityByEntityName('orderDelivery', False);
	 	var orderDeliveryItem1 = createSimpleMockEntityByEntityName('orderDeliveryItem', False);
	 	var orderDeliveryItem2 = createSimpleMockEntityByEntityName('orderDeliveryItem', False);
	 	
	 	var orderItemData={
	 		orderItemID="",
	 		price=5
	 	};
	 	var orderItem = createTestEntity('orderItem',orderItemData);
	 	
	 	mockOrder.addOrderDelivery(orderDelivery); 	
	 	orderDelivery.addOrderDeliveryItem(orderDeliveryItem1);	
	 	orderDelivery.addOrderDeliveryItem(orderDeliveryItem2);	
	 	orderDeliveryItem1.setOrderItem(orderItem);
	 	orderDeliveryItem2.setOrderItem(orderItem);
	 	
	 	var result = mockOrder.getDeliveredOrderItems();
	 	assertEquals(orderItem.getPrice(), result[1].getPrice());
	 	assertEquals(orderItem.getPrice(), result[2].getPrice());
	 }
	 
	 public void function canCancelTest() {
	 	var mockOrder = createSimpleMockEntityByEntityName('Order');
	 	injectMethod(mockOrder, this, 'returnTrue', 'hasGiftCardOrderItems');
	 	assertFalse(mockOrder.canCancel(), 'when hasGiftCardorderItems == TRUE, should return false');
	 	
	 	injectMethod(mockOrder, this, 'returnFalse', 'hasGiftCardOrderItems');
	 	assertTRUE(mockOrder.canCancel(), 'when hasGiftCardorderItems == FALSE, should return true');
	 }
	 
	 private array function returnOrderItems() {
	 	var mockOrderItem1 = createObejct('component', Slatwall.model.entity.OrderItem);
	 	populate(mockOrderItem1);
	 	return [mockOrderItem1];
	 }
	 
	 private array function returnNonPersistedOrderItems() {
	 	var mockOrderItem1 = createObejct('component', Slatwall.model.entity.OrderItem);
	 	populate(mockOrderItem1);
	 	var mockOrderItem2 = createObejct('component', Slatwall.model.entity.OrderItem);
	 	populate(mockOrderItem2);
	 	
	 	return [mockOrderItem1, mockOrderItem2];
	 }
	 
	 public void function hasGiftCardOrderItemsTest_WithArgu() {
	 	//Mocking data is same with the orderDAO.cfc getGiftCardOrderItemsTest() function
	 	var productData = {
			productID = '',
			productType = {
				productTypeID = '50cdfabbc57f7d103538d9e0e37f61e4'//giftcard
			}
		};
		var mockProduct = createPersistedTestEntity('Product', productData);
		
		var mockTerm = createSimpleMockEntityByEntityName('Term');
		
		var skuData = {
			skuID = '',
			product = {
				productID = mockProduct.getProductID()
			},
			giftCardExpirationTerm = {
				termID = mockTerm.getTermID()
			}
			
		};
		var mockSku = createPersistedTestEntity('Sku', skuData);
		
		var orderItemData = {
			orderItem = '',
			sku = {
				skuID = mockSku.getSkuID()
			},
			quantity = 50
			
		};
		var mockOrderItem = createPersistedTestEntity('OrderItem', orderItemData);
		
		var orderData = {
			orderID = '',
			orderItems=[
				{
					orderItemID=mockOrderItem.getOrderItemID()
				}
			]
		};
		var mockOrder = createPersistedTestEntity('Order', orderData);
	 	
	 	var result = mockOrder.hasGiftCardOrderItems(mockOrderItem.getOrderItemID());
	 	assertTrue(result, 'The function should return TRUE for the oi accordence with the argument');
	 	
	 	var resultFakeOIid = mockOrder.hasGiftCardOrderItems('somefakeOrderitemID');
	 	assertFalse(resultFakeOIid, 'If the giftCardOrderItem is not same with the arguments, should return False');
	 	
	 }
	 
	 public void function hasGiftCardOrderItemsTest_NoArgu() {
	 	//Mocking data is same with the orderDAO.cfc getGiftCardOrderItemsTest() function
	 	var productData = {
			productID = '',
			productType = {
				productTypeID = '50cdfabbc57f7d103538d9e0e37f61e4'//giftcard
			}
		};
		var mockProduct = createPersistedTestEntity('Product', productData);
		
		var mockTerm = createSimpleMockEntityByEntityName('Term');
		
		var skuData = {
			skuID = '',
			product = {
				productID = mockProduct.getProductID()
			},
			giftCardExpirationTerm = {
				termID = mockTerm.getTermID()
			}
			
		};
		var mockSku = createPersistedTestEntity('Sku', skuData);
		
		var orderItemData = {
			orderItem = '',
			sku = {
				skuID = mockSku.getSkuID()
			},
			quantity = 50
			
		};
		var mockOrderItem = createPersistedTestEntity('OrderItem', orderItemData);
		
		var orderData = {
			orderID = '',
			orderItems=[
				{
					orderItemID=mockOrderItem.getOrderItemID()
				}
			]
		};
		var mockOrderWithOrderItem = createPersistedTestEntity('Order', orderData);
		
	 	var result = mockOrderWithOrderItem.hasGiftCardOrderItems();
	 	assertTrue(result, 'If exist giftCardOrderItem, should return true');
	 	
	 	var orderData = {
			orderID = ''
		};
		var mockOrderWithNoOrderItem = createPersistedTestEntity('Order', orderData);
		
	 	var resultNoGiftCardOI = mockOrderWithNoOrderItem.hasGiftCardOrderItems();
	 	assertFalse(resultNoGiftCardOI, 'If there is no giftCardOrderItem returns, should return false');
	 	
	 	
	 }
	 
	 public void function getAllOrderItemGiftRecipientsSmartListTest() {
	 	var mockOrder = createSimpleMockEntityByEntityName('Order');
	 	
	 	var mockOrderItem1 = createSimpleMockEntityByEntityName('OrderItem');
	 	var mockOrderItem2 = createSimpleMockEntityByEntityName('OrderItem');
	 	mockOrderItem1.setOrder(mockOrder);
	 	
	 	var orderItemGiftRecipientData1 = {
	 		orderItemGiftRecipientID = '',
	 		orderItem = {
	 			orderItemID = mockOrderItem1.getOrderItemID()
	 		}
	 	};
	 	var mockOrderItemGiftRecepient1 = createPersistedTestEntity('OrderItemGiftRecipient', OrderItemGiftRecipientData1);
	 	
	 	var orderItemGiftRecipientData2 = {
	 		orderItemGiftRecipientID = '',
	 		orderItem = {
	 			orderItemID = mockOrderItem1.getOrderItemID()
	 		}
	 	};
	 	var mockOrderItemGiftRecepient2 = createPersistedTestEntity('OrderItemGiftRecipient', OrderItemGiftRecipientData2);
	 	
	 	var orderItemGiftRecipientData3 = {
	 		orderItemGiftRecipientID = '',
	 		orderItem = {
	 			orderItemID = mockOrderItem2.getOrderItemID()
	 		}
	 	};
	 	var mockOrderItemGiftRecepient3 = createPersistedTestEntity('OrderItemGiftRecipient', OrderItemGiftRecipientData3);
	 	
	 	var mockOrderItemGiftRecepient4 = createSimpleMockEntityByEntityName('OrderItemGiftRecipient');
	 	
	 	var result = mockOrder.getAllOrderItemGiftRecipientsSmartList().getRecords(refresh = true);
	 	assertFalse(arrayContains(result, mockOrderItemGiftRecepient4), 'The left join with orderItem fails');
	 	assertFalse(arrayContains(result, mockOrderItemGiftRecepient3), 'The where condition of orderID fails');
	 	assertTrue(arrayContains(result, mockOrderItemGiftRecepient1), 'The object should be added in the smartlist but fails');
	 	assertTrue(arrayContains(result, mockOrderItemGiftRecepient2), 'The object should be added in the smartlist but fails');
	 }
	 
	 public void function getDynamicChargeOrderPaymentTest_general() {
	 	//Testing the systemCode
	 	var mockOrderPayment2 = createMockOrderPayment(orderPaymentTypeID='444df2f1cc40d0ea8a2de6f542ab4f1d'); //optCredit
	 	
	 	var orderData = {
	 		orderID = '',
	 		orderPayments = [{
	 			orderPaymentID = mockOrderPayment2.getOrderPaymentID()
	 		}]
	 	};
	 	var mockOrderSystemCode = createPersistedTestEntity('Order', orderData);
	 	
	 	var resultSystemCode = mockOrderSystemCode.getDynamicChargeOrderPayment();
	 	assertTrue(isNull(resultSystemCode), 'The orderPaymentTYpe.systemCode fails ');
	 	
	 	//Testing the getDynamicAmountFlag()
	 	var mockOrderPayment3 = createMockOrderPayment(orderPaymentTypeID='444df2f0fed139ff94191de8fcd1f61b', amount = 500); //optCharge
	 	
	 	var orderData = {
	 		orderID = '',
	 		orderPayments = [{
	 			orderPaymentID = mockOrderPayment3.getOrderPaymentID()
	 		}]
	 	};
	 	var mockOrderFlag = createPersistedTestEntity('Order', orderData);
	 	
	 	var resultFlag = mockOrderFlag.getDynamicChargeOrderPayment();
	 	assertTrue(isNull(resultFlag), 'The orderPayment.getDynamicAmountFlag() fails ');
	 	
	 	//Testing the condition statements
	 	var mockOrderPayment1 = createMockOrderPayment(orderPaymentTypeID='444df2f0fed139ff94191de8fcd1f61b'); //optCharge
	 	
	 	var orderData = {
	 		orderID = '',
	 		orderPayments = [{
	 			orderPaymentID = mockOrderPayment1.getOrderPaymentID()
	 		}]
	 	};
	 	var mockOrderOnePayment = createPersistedTestEntity('Order', orderData);
	 	
	 	var resultGeneral = mockOrderOnePayment.getDynamicChargeOrderPayment();
	 	assertEquals(mockOrderPayment1.getOrderPaymentID(), resultGeneral.getOrderPaymentID(), 'General test did not pass, one of the conditions fails');
	 	
	 	//Testing on two orderPayments isNull(returnOrderPayment)
	 	var mockOrderPayment4 = createMockOrderPayment(orderPaymentTypeID='444df2f0fed139ff94191de8fcd1f61b'); //optCharge
	 	
	 	var orderData = {
	 		orderID = '',
	 		orderPayments = [
		 		{
		 			orderPaymentID = mockOrderPayment1.getOrderPaymentID()
		 		},
		 		{
		 			orderPaymentID = mockOrderPayment4.getOrderPaymentID()
		 		}
	 		]
	 	};
	 	var mockOrderTwoPayments = createPersistedTestEntity('Order', orderData);
	 	
	 	var resultTwoPayments = mockOrderTwoPayments.getDynamicChargeOrderPayment();
	 	assertEquals(mockOrderPayment4.getOrderPaymentID(), resultTwoPayments.getOrderPaymentID(), 'When two orderPayments involved, the second should be returned');
	 	
	 	//Testing on the order without orderPayment
	 	var mockOrderNoPayment = createMockOrder();
	 	
	 	var resultNoOrderPayment = 	mockOrderNoPayment.getDynamicChargeOrderPayment();
	 	assertTrue(isNULL(resultNoOrderPayment),'The mockOrder without orderPayment should return nulls');
	 }
	 
	 public void function getDynamicCreditOrderPaymentTest_general() {
	 	//Testing the systemCode
	 	var mockOrderPayment2 = createMockOrderPayment(orderPaymentTypeID='444df2f0fed139ff94191de8fcd1f61b'); //optCharge
	 	
	 	var orderData = {
	 		orderID = '',
	 		orderPayments = [{
	 			orderPaymentID = mockOrderPayment2.getOrderPaymentID()
	 		}]
	 	};
	 	var mockOrderSystemCode = createPersistedTestEntity('Order', orderData);
	 	
	 	var resultSystemCode = mockOrderSystemCode.getDynamicCreditOrderPayment();
	 	assertTrue(isNull(resultSystemCode), 'The orderPaymentTYpe.systemCode fails ');
	 	
	 	//Testing the getDynamicAmountFlag()
	 	var mockOrderPayment3 = createMockOrderPayment(orderPaymentTypeID='444df2f1cc40d0ea8a2de6f542ab4f1d', amount = 500); //optCredit
	 	
	 	var orderData = {
	 		orderID = '',
	 		orderPayments = [{
	 			orderPaymentID = mockOrderPayment3.getOrderPaymentID()
	 		}]
	 	};
	 	var mockOrderFlag = createPersistedTestEntity('Order', orderData);
	 	
	 	var resultFlag = mockOrderFlag.getDynamicCreditOrderPayment();
	 	assertTrue(isNull(resultFlag), 'The orderPayment.getDynamicAmountFlag() should return False ');
	 	
	 	//Testing the condition statements
	 	var mockOrderPayment1 = createMockOrderPayment(orderPaymentTypeID='444df2f1cc40d0ea8a2de6f542ab4f1d'); //optCredit
	 	
	 	var orderData = {
	 		orderID = '',
	 		orderPayments = [{
	 			orderPaymentID = mockOrderPayment1.getOrderPaymentID()
	 		}]
	 	};
	 	var mockOrderOnePayment = createPersistedTestEntity('Order', orderData);
	 	
	 	var resultGeneral = mockOrderOnePayment.getDynamicCreditOrderPayment();
	 	assertEquals(mockOrderPayment1.getOrderPaymentID(), resultGeneral.getOrderPaymentID(), 'General test did not pass, one of the conditions fails');
	 	
	 	//Testing on two orderPayments isNull(returnOrderPayment)
	 	var mockOrderPayment4 = createMockOrderPayment(orderPaymentTypeID='444df2f1cc40d0ea8a2de6f542ab4f1d'); //optCredit
	 	
	 	var orderData = {
	 		orderID = '',
	 		orderPayments = [
		 		{
		 			orderPaymentID = mockOrderPayment1.getOrderPaymentID()
		 		},
		 		{
		 			orderPaymentID = mockOrderPayment4.getOrderPaymentID()
		 		}
	 		]
	 	};
	 	var mockOrderTwoPayments = createPersistedTestEntity('Order', orderData);
	 	
	 	var resultTwoPayments = mockOrderTwoPayments.getDynamicCreditOrderPayment();
	 	assertEquals(mockOrderPayment4.getOrderPaymentID(), resultTwoPayments.getOrderPaymentID(), 'When two orderPayments involved, the second should be returned');
	 	
	 	//Testing on the order without orderPayment
	 	var mockOrderNoPayment = createMockOrder();
	 	
	 	var resultNoOrderPayment = 	mockOrderNoPayment.getDynamicCreditOrderPayment();
	 	assertTrue(isNULL(resultNoOrderPayment),'The mockOrder without orderPayment should return nulls');
	 }
	 
	 public void function getPaymentMethodOptionsSmartListTest_DefaultPaymentMethods() {
	 	var mockOrderPayment = createMockOrderPayment();
	 	
	 	var orderData = {
	 		orderID = '',
	 		orderPayments=[
	 			{
	 				orderPaymentID = mockOrderPayment.getOrderPaymentID()
	 			}
	 		]
	 	};
	 	var mockOrder = createPersistedTestEntity('Order', orderData);
	 	
	 	var resultSL = mockOrder.getPaymentMethodOptionsSmartList();
	 	assertTrue(resultSL.getRecordsCount() == 2);
	 	var resultSLRecords = mockOrder.getPaymentMethodOptionsSmartList().getRecords(refresh = true);
	 	assertEquals('Credit Card', resultSLRecords[1].getPaymentMethodName(),'The first default paymentMethod should be Credit Card');
	 	assertEquals('Gift Card', resultSLRecords[2].getPaymentMethodName(),'The second default paymentMethod should be Gift Card');
	 }
	 
	 public void function getPaymentMethodOptionsSmartListTest_AddPaymentMethods() {
	 	var paymentMethodData1 = {
	 		paymentMethodID = '',
	 		paymentMethodname = 'MyPaymentMethod1',
	 		activeFlag = 1
	 	};
	 	var mockPaymentMethodFlagTrue = createPersistedTestEntity('PaymentMethod', paymentMethodData1);
	 	
	 	var paymentMethodData2 = {
	 		paymentMethodID = '',
	 		paymentMethodname = 'MyPaymentMethod2',
	 		activeFlag = 0
	 	};
	 	var mockPaymentMethodFlagFalse = createPersistedTestEntity('PaymentMethod', paymentMethodData2);
	 	
	 	var mockOrderPaymentTrueFlag = createMockOrderPayment(orderPaymentMethodID = mockPaymentMethodFlagTrue.getPaymentMethodID());
	 	var mockOrderPaymentFalseFlag = createMockOrderPayment(orderPaymentMethodID = mockPaymentMethodFlagFalse.getPaymentMethodID());
	 	
	 	var orderData = {
	 		orderID = '',
	 		orderPayments=[
	 			{
	 				orderPaymentID = mockOrderPaymentTrueFlag.getOrderPaymentID()
	 			},
	 			{
	 				orderPaymentID = mockOrderPaymentFalseFlag.getOrderPaymentID()
	 			}
	 		]
	 	};
	 	var mockOrder = createPersistedTestEntity('Order', orderData);
	 	
	 	//Testing the activeFlag filter at the same time
	 	var resultSL = mockOrder.getPaymentMethodOptionsSmartList(refresh = true);
	 	assertTrue(resultSL.getRecordsCount() == 3);
	 	
	 	var resultSLRecords = mockOrder.getPaymentMethodOptionsSmartList().getRecords(refresh = true);
	 	var resultPaymentNameList = '';
	 	for (payment in resultSLRecords) {
	 		resultPaymentNameList = listAppend(resultPaymentNameList, payment.getPaymentMethodName());
	 	}
	 	assertTrue(listFind(resultPaymentNameList, 'MyPaymentMethod1') != 0,'The added mockPaymentMethodFlagTrue should be in the smartlist');
	 	assertTrue(listFind(resultPaymentNameList, 'MyPaymentMethod2') == 0,'The added mockPaymentMethodFlagFalse should not be in the smartlist');
	 }
	 
	 public void function removeAllOrderItemsTest() {
	 	var mockOrderItem1 = createMockOrderItem();
	 	var mockOrderItem2 = createMockOrderItem();
	 	
	 	var orderData = {
	 		orderID = '',
	 		orderItems=[
	 			{
	 				orderItemID = mockOrderItem1.getOrderItemID()
	 			},
	 			{
	 				orderItemID = mockOrderItem2.getOrderItemID()
	 			}
	 		]
	 	};
	 	var mockOrder = createPersistedTestEntity('Order', orderData);

	 	var result = mockOrder.removeAllOrderItems();
	 	assertTrue(isNull(mockOrderItem1.getOrder()));
	 	assertTrue(isNull(mockOrderItem2.getOrder()));
	 }
	
	
	public void function getPreviouslyReturnedFulfillmentTotalTest() {
		var orderData = {
			orderID = ''
		};
		var mockOrder = createTestEntity('Order', orderData);
		
		var mockOrderService = new Slatwall.model.service.orderService();
		mockOrderService.getPreviouslyReturnedFulfillmentTotal = getPreviouslyReturnedFulfillmentTotal;//returns 30
		mockOrder.setOrderService(mockOrderService);
		
		var result = mockOrder.getPreviouslyReturnedFulfillmentTotal();
		assertEquals(30, result, 'The dependency function result is not returned properly.');
	}
	
	public void function hasGiftCardOrderPaymentAmountTest() {
		var mockOrder = createSimpleMockEntityByEntityName('Order');
		
		var orderDAO = new Slatwall.model.dao.OrderDAO();
		
		//Testing when amount > 0
		injectMethod(orderDAO, this, 'returnSevenHundred', 'getGiftCardOrderPaymentAmount');
		mockOrder.setOrderDAO(orderDAO);
		
		var resultGreatThanZero = mockOrder.hasGiftCardOrderPaymentAmount();
		assertTrue(resultGreatThanZero, 'The condition that amount get from orderDAO > 0 fails');
		
		//Testing when amount == 0
		injectMethod(orderDAO, this, 'returnZero', 'getGiftCardOrderPaymentAmount');
		mockOrder.setOrderDAO(orderDAO);
		
		var resultEqualsZero = mockOrder.hasGiftCardOrderPaymentAmount();
		assertFalse(resultEqualsZero, 'The condition that amount get from orderDAO == 0 fails');
		
		//Testing when amount < 0
		injectMethod(orderDAO, this, 'returnMinusTen', 'getGiftCardOrderPaymentAmount');
		mockOrder.setOrderDAO(orderDAO);
		
		var resultLessThanZero = mockOrder.hasGiftCardOrderPaymentAmount();
		assertFalse(resultLessThanZero, 'The condition that amount get from orderDAO < 0 fails');
	}
	
	public void function getOrderPaymentAmountNeededTest_DynamicCreditOrderPaymentNotNull() {
		var orderData = {
			orderID = ''
		};
		var mockOrder = createTestEntity('Order',orderData);
		
		var orderService = new Slatwall.model.service.OrderService();
		injectMethod(orderService, this, 'returnTen','getOrderPaymentNonNullAmountTotal');
		mockOrder.setOrderService(orderService);
		
		injectMethod(mockOrder, this, 'returnSevenHundred', 'getTotal'); 
		
		injectMethod(mockOrder, this, 'getDynamicCreditOrderPaymentNotNull', 'getDynamicCreditOrderPayment'); //returns OrderPayment entity
		
		var resultZero = mockOrder.getOrderPaymentAmountNeeded();
	}
	
	public void function getORderPaymentAmountNeededTest_DynamicChargeOrderPaymentNotNull() {
		var orderData = {
			orderID = ''
		};
		var mockOrder = createTestEntity('Order',orderData);
		
		var orderService = new Slatwall.model.service.OrderService();
		injectMethod(orderService, this, 'returnTen','getOrderPaymentNonNullAmountTotal');
		mockOrder.setOrderService(orderService);
		
		injectMethod(mockOrder, this, 'returnSevenHundred', 'getTotal'); 
		
		injectMethod(mockOrder, this, 'getDynamicChargeOrderPaymentNotNull', 'getDynamicChargeOrderPayment'); //returns OrderPayment entity
		
		
		var resultZero = mockOrder.getOrderPaymentAmountNeeded();
	}
	
	public void function getOrderPaymentAmountNeededTest() {
		var orderData = {
			orderID = ''
		};
		var mockOrder = createTestEntity('Order',orderData);
		
		var orderService = new Slatwall.model.service.OrderService();
		injectMethod(orderService,this,'returnTen','getOrderPaymentNonNullAmountTotal');
		mockOrder.setOrderService(orderService);
		
		injectMethod(mockOrder, this, 'returnSevenHundred', 'getTotal');
		
		var result = mockOrder.getOrderPaymentAmountNeeded();
		assertEquals(690, result, 'Calculation of the default order fails');
	
		// This way also works (example of injectMethod):
//		var mockOrderService = new Slatwall.model.service.orderService();
//		mockOrderService.getOrderPaymentNonNullAmountTotal = returnTen;
//		mockOrder.setOrderService(mockOrderService);


	
		//InjectProperty() example, receiver is as follows
//		InjectProperty(mockOrder,'orderService',myMightyMock);
			
		//Deal with getTotal() function
//		var myMock = mock('Slatwall.model.entity.Order', 'typeSafe');
//		myMock.getTotal().returns(100);
//		mockOrder.getTotal(myMock);
//		
		
//		var myOrder2 = new Slatwall.model.entity.order();
//		var myOrder2 = createObject('component', 'Slatwall.model.entity.Order').getTotal(myMock);
//		mockOrder.getTotal(myMock);
	}
	
	
	public void function getDynamicChargeOrderPaymentAmountTest() {
		var orderData = {
			orderID = ''
		};
		var mockOrder = createTestEntity('Order', orderData);

		var orderService = new Slatwall.model.service.OrderService();
		
		//Testing when orderPaymenAmountNeeded > 0
		injectMethod(orderService, this, 'returnTen','getOrderPaymentNonNullAmountTotal');
		mockOrder.setOrderService(orderService);
		
		injectMethod(mockOrder, this, 'returnSevenHundred', 'getTotal');
		
		var result = mockOrder.getDynamicChargeOrderPaymentAmount();
		assertEquals(690, result, 'The circumstance of orderPaymentAmountNeeded > 0 fails');
		
		//Testing when orderPaymentAmountNeeded <= 0
		injectMethod(orderService, this, 'returnSevenHundred','getOrderPaymentNonNullAmountTotal');
		mockOrder.setOrderService(orderService);
		
		injectMethod(mockOrder, this, 'returnTen', 'getTotal');
		
		var resultNegativeNumber = mockOrder.getDynamicChargeOrderPaymentAmount();
		assertEquals(0, resultNegativeNumber, 'The case when orderPaymentAmountNeeded is -690 fails');
	}
	
	public void function getDynamicCreditOrderPaymentAmountTest() {
		var orderData = {
			orderID = ''
		};
		var mockOrder = createTestEntity('Order', orderData);

		var orderService = new Slatwall.model.service.OrderService();
		
		//Testing when orderPaymentAmountNeeded >= 0
		injectMethod(orderService, this, 'returnTen','getOrderPaymentNonNullAmountTotal');
		mockOrder.setOrderService(orderService);
		
		injectMethod(mockOrder, this, 'returnSevenHundred', 'getTotal');
		
		var result = mockOrder.getDynamicCreditOrderPaymentAmount();
		assertEquals(0, result, 'The circumstance of orderPaymentAmountNeeded is 690 fails');
		
		//Testing when orderPaymentAmountNeeded < 0
		injectMethod(orderService, this, 'returnSevenHundred','getOrderPaymentNonNullAmountTotal');
		mockOrder.setOrderService(orderService);
		
		injectMethod(mockOrder, this, 'returnTen', 'getTotal');
		
		var resultNegativeNumber = mockOrder.getDynamicCreditOrderPaymentAmount();
		assertEquals(690, resultNegativeNumber, 'The case when orderPaymentAmountNeeded is -690 fails');
	}
	
	public void function getDynamicChargeOrderPaymentTest_ifsInForLoop() {
		// These mock entities, getStatusCode() is set to 'opstActive' by default
		var orderPaymentData1 = {
			orderPaymentID = '',
			orderPaymentType = {
				typeID = '444df2f0fed139ff94191de8fcd1f61b'//optCharge
			},
			amount = 100 //getDynamicAmountFlag() FALSE
		};
		var MockOrderPayment1 = createPersistedTestEntity('OrderPayment', orderPaymentData1); //testing dynamicAmountFlag
		
		var orderPaymentData2 = {
			orderPaymentID = '',
			orderPaymentType = {
				typeID = '444df2f0fed139ff94191de8fcd1f61b'//optCharge
			}
			//getDynamicAmountFlag() TRUE
		};
		var MockOrderPayment2 = createPersistedTestEntity('OrderPayment', orderPaymentData2); //testing normal case
		
		var orderPaymentData3 = {
			orderPaymentID = '',
			orderPaymentType = {
				typeID = '444df2f1cc40d0ea8a2de6f542ab4f1d'//optCredit
			}
			//getDynamicAmountFlag() TRUE
		};
		var MockOrderPayment3 = createPersistedTestEntity('OrderPayment', orderPaymentData3); //Testing orderPaymentType
		
		var orderData = {
			orderID = '',
			orderPayments = [
				{
					orderPaymentID = mockOrderPayment1.getOrderPaymentID()
				},
				{
					orderPaymentID = mockOrderPayment2.getOrderPaymentID()
				},
				{
					orderPaymentID = mockOrderPayment3.getOrderPaymentID()
				}
			]
		};
		var mockOrder = createPersistedTestEntity('Order', orderData);
		
		var result = mockOrder.getDynamicChargeOrderPayment();
		assertFalse(isNull(result));
		assertEquals(mockOrderPayment2.getOrderPaymentID(), result.getOrderPaymentID(), 'The filter of orderPayments fails');
		
	}
	
	public void function getDynamicChargeOrderPaymentTest_emptyReturn() {
		var orderPaymentData = {
			orderPaymentID = '',
			orderPaymentType = {
				typeID = '444df2f0fed139ff94191de8fcd1f61b'//optCharge
			}
			//getDynamicAmountFlag() TRUE
		};
		var MockOrderPayment = createPersistedTestEntity('OrderPayment', orderPaymentData);
		
		var orderData = {
			orderID = '',
			orderPayments = [
				{
					orderPaymentID = mockOrderPayment.getOrderPaymentID()
				}
			]
		};
		var mockOrder = createPersistedTestEntity('Order', orderData);
		
		//inject the getStatusCode() method
		injectMethod(mockOrderPayment, this, 'returnOpstInvalid', 'getStatusCode');
		
		var result = mockOrder.getDynamicChargeOrderPayment();
		assertTrue(isNull(result));
	}
	
	public void function getDynamicCreditOrderPaymentTest_ifsInForLoop() {
		// These mock entities, getStatusCode() is set to 'opstActive' by default
		var orderPaymentData1 = {
			orderPaymentID = '',
			orderPaymentType = {
				typeID = '444df2f1cc40d0ea8a2de6f542ab4f1d'//optCredit
			},
			amount = 100 //getDynamicAmountFlag() FALSE
		};
		var MockOrderPayment1 = createPersistedTestEntity('OrderPayment', orderPaymentData1); //testing dynamicAmountFlag
		
		var orderPaymentData2 = {
			orderPaymentID = '',
			orderPaymentType = {
				typeID = '444df2f1cc40d0ea8a2de6f542ab4f1d'//optCredit
			}
			//getDynamicAmountFlag() TRUE
		};
		var MockOrderPayment2 = createPersistedTestEntity('OrderPayment', orderPaymentData2); //testing normal case
		
		var orderPaymentData3 = {
			orderPaymentID = '',
			orderPaymentType = {
				typeID = '444df2f0fed139ff94191de8fcd1f61b'//optCharge
			}
			//getDynamicAmountFlag() TRUE
		};
		var MockOrderPayment3 = createPersistedTestEntity('OrderPayment', orderPaymentData3); //Testing orderPaymentType
		
		var orderData = {
			orderID = '',
			orderPayments = [
				{
					orderPaymentID = mockOrderPayment1.getOrderPaymentID()
				},
				{
					orderPaymentID = mockOrderPayment2.getOrderPaymentID()
				},
				{
					orderPaymentID = mockOrderPayment3.getOrderPaymentID()
				}
			]
		};
		var mockOrder = createPersistedTestEntity('Order', orderData);
		
		var result = mockOrder.getDynamicCreditOrderPayment();
		assertFalse(isNull(result));
		assertEquals(mockOrderPayment2.getOrderPaymentID(), result.getOrderPaymentID(), 'The filter of orderPayments fails');
		
	}
	
	public void function getDynamicCreditOrderPaymentTest_emptyReturn() {
		var orderPaymentData = {
			orderPaymentID = '',
			orderPaymentType = {
				typeID = '444df2f1cc40d0ea8a2de6f542ab4f1d'//optCredit
			}
			//getDynamicAmountFlag() TRUE
		};
		var MockOrderPayment = createPersistedTestEntity('OrderPayment', orderPaymentData);
		
		var orderData = {
			orderID = '',
			orderPayments = [
				{
					orderPaymentID = mockOrderPayment.getOrderPaymentID()
				}
			]
		};
		var mockOrder = createPersistedTestEntity('Order', orderData);
		
		//inject the getStatusCode() method
		injectMethod(mockOrderPayment, this, 'returnOpstInvalid', 'getStatusCode');
		
		var result = mockOrder.getDynamicCreditOrderPayment();
		assertTrue(isNull(result));
	}
	
	public void function getPaymentAmountTotalTest() {
		// These mock entities, getStatusCode() == 'opstActive' by default
		var orderPaymentData1 = {
			orderPaymentID = '',
			orderPaymentType = {
				typeID = '444df2f0fed139ff94191de8fcd1f61b'//optCharge
			},
			amount = 10 
		};
		var MockOrderPayment1 = createPersistedTestEntity('OrderPayment', orderPaymentData1);
		
		var orderPaymentData2 = {
			orderPaymentID = '',
			orderPaymentType = {
				typeID = '444df2f1cc40d0ea8a2de6f542ab4f1d'//optCredit
			},
			amount = 0.5 
		};
		var MockOrderPayment2 = createPersistedTestEntity('OrderPayment', orderPaymentData2); 
		
		var orderPaymentData3 = {
			orderPaymentID = '',
			orderPaymentType = {
				typeID = '444df2f0fed139ff94191de8fcd1f61b'//optCharge
			},
			amount = 4 
		};
		var MockOrderPayment3 = createPersistedTestEntity('OrderPayment', orderPaymentData3); 
		
		injectMethod(mockOrderPayment3, this, 'returnTrue', 'hasErrors');
		
		
		var orderData = {
			orderID = '',
			orderPayments = [
				{
					orderPaymentID = mockOrderPayment1.getOrderPaymentID()
				},
				{
					orderPaymentID = mockOrderPayment2.getOrderPaymentID()
				},
				{
					orderPaymentID = mockOrderPayment3.getOrderPaymentID()
				}
			]
		};
		var mockOrder = createPersistedTestEntity('Order', orderData);
		
		var result = mockOrder.getPaymentAmountTotal(); 
		assertEquals(9.5, result, 'The result should be 10 - 0.5 = 9.5');
	}
	
	public void function getPaymentAmountDueTest() {
		var orderData1 = {
			orderID = '',
			orderStatusType = {
				typeID = '444df2b90f62f72711eb5b3c90848e7e' //ostCanceled
			}
		};
		var mockOrder1 = createPersistedTestEntity('Order', orderData1);
		
		var resultZero = mockOrder1.getPaymentAmountDue();
		assertEquals(0, resultZero, 'THe ostCanceled type fails');
		
		var orderData2 = {
			orderID = '',
			orderStatusType = {
				typeID = '444df2b6b8b5d1ccfc14a4ab38aa0a4c'//ostProcessing
			}
		};
		var mockOrder2 = createPersistedTestEntity('Order', orderData2);
		
		injectMethod(mockOrder2, this, 'returnSevenHundred', 'getTotal');
		injectMethod(mockOrder2, this, 'returnTen', 'getPaymentAmountReceivedTotal');
		injectMethod(mockOrder2, this, 'returnMinusTen', 'getPaymentAmountCreditedTotal');
		
		var resultNotCanceled = mockOrder2.getPaymentAmountDue();
		assertEquals(680, resultNotCanceled, 'Calculation of not ostCanceled types fails');
		
	}
	
	public void function getPaymentAmountAuthorizedTotalTest() {
		//Testing when the statusCode == opstActive
		var mockOrderPayment = createSimpleMockEntityByEntityName('OrderPayment');
		injectMethod(mockOrderPayment, this, 'returnTen', 'getAmountAuthorized');
		
		var orderData = {
			orderID = '',
			orderPayments = [{
				orderPaymentID = mockOrderPayment.getOrderPaymentID()
			}]
		};
		var mockOrder = createPersistedTestEntity('Order', orderData);
		
		var result = mockOrder.getPaymentAmountAuthorizedTotal();
		assertEquals(10, result, 'Condition default type opstActive should do calculation');
		
		//Testing the statusCode <> active
		var mockOrderPayment2 = createSimpleMockEntityByEntityName('OrderPayment');
		injectMethod(mockOrderPayment2, this, 'returnTen', 'getAmountAuthorized');
		injectMethod(mockOrderPayment2, this, 'returnOpstInvalid', 'getStatusCode');
		
		var orderData2 = {
			orderID = '',
			orderPayments = [{
				orderPaymentID = mockOrderPayment2.getOrderPaymentID()
			}]
		};
		var mockOrder2 = createPersistedTestEntity('Order', orderData2);
		
		var result = mockOrder2.getPaymentAmountAuthorizedTotal();
		assertEquals(0, result, 'When status type not opstActive, should return 0');
	}
	
	public void function getPaymentAmountReceivedTotalTest() {
		//Testing when the statusCode == opstActive
		var mockOrderPayment = createSimpleMockEntityByEntityName('OrderPayment');
		injectMethod(mockOrderPayment, this, 'returnTen', 'getAmountReceived');
		
		var orderData = {
			orderID = '',
			orderPayments = [{
				orderPaymentID = mockOrderPayment.getOrderPaymentID()
			}]
		};
		var mockOrder = createPersistedTestEntity('Order', orderData);
		
		var result = mockOrder.getPaymentAmountReceivedTotal();
		assertEquals(10, result, 'Condition default type opstActive should do calculation');
		
		//Testing the statusCode <> active
		var mockOrderPayment2 = createSimpleMockEntityByEntityName('OrderPayment');
		injectMethod(mockOrderPayment2, this, 'returnTen', 'getAmountReceived');
		injectMethod(mockOrderPayment2, this, 'returnOpstInvalid', 'getStatusCode');
		
		var orderData2 = {
			orderID = '',
			orderPayments = [{
				orderPaymentID = mockOrderPayment2.getOrderPaymentID()
			}]
		};
		var mockOrder2 = createPersistedTestEntity('Order', orderData2);
		
		var result = mockOrder2.getPaymentAmountReceivedTotal();
		assertEquals(0, result, 'When status type not opstActive, should return 0');
	}
	
	public void function getPaymentAmountTotalByPaymentMethodTest_ifLogic() {
		// These mock entities, getStatusCode() == 'opstActive' by default
		var paymentMethodData = {
			paymentMethodID = ''
		};
		var mockPaymentMethod = createPersistedTestEntity('PaymentMethod', paymentMethodData);
		
		//testing getOrderPaymentType() & Calculation
		var orderPaymentData1 = {
			orderPaymentID = '',
			paymentMethod = {
				paymentMethodID = mockPaymentMethod.getPaymentMethodId()
			},
			orderPaymentType = {
				typeID = '444df2f0fed139ff94191de8fcd1f61b'//optCharge
			},
			amount = 10 
		};
		var MockOrderPayment1 = createPersistedTestEntity('OrderPayment', orderPaymentData1);

		//Testing getStatusCode() != 'opstActive'
		var orderPaymentData2 = {
			orderPaymentID = '',
			paymentMethod = {
				paymentMethodID = mockPaymentMethod.getPaymentMethodId()
			},
			orderPaymentType = {
				typeID = '444df2f0fed139ff94191de8fcd1f61b'//optCharge
			},
			amount = 0.5 
		};
		var MockOrderPayment2 = createPersistedTestEntity('OrderPayment', orderPaymentData2); 
		injectMethod(mockOrderPayment2, this, 'returnOpstInvalid', 'getStatusCode');
		
		//testing hasErrors()
		var orderPaymentData3 = {
			orderPaymentID = '',
			paymentMethod = {
				paymentMethodID = mockPaymentMethod.getPaymentMethodID()
			},
			orderPaymentType = {
				typeID = '444df2f0fed139ff94191de8fcd1f61b'//optCharge
			},
			amount = 4 
		};
		var MockOrderPayment3 = createPersistedTestEntity('OrderPayment', orderPaymentData3); 
		injectMethod(mockOrderPayment3, this, 'returnTrue', 'hasErrors');
		
		//testing getOrderPaymentType() & Calculation
		var orderPaymentData4 = {
			orderPaymentID = '',
			paymentMethod = {
				paymentMethodID = mockPaymentMethod.getPaymentMethodID()
			},
			orderPaymentType = {
				typeID = '444df2f1cc40d0ea8a2de6f542ab4f1d'//optCredit 
			},
			amount = 2 
		};
		var MockOrderPayment4 = createPersistedTestEntity('OrderPayment', orderPaymentData4); 
		
		var orderData = {
			orderID = '',
			orderPayments = [
				{
					orderPaymentID = mockOrderPayment1.getOrderPaymentID()
				},
				{
					orderPaymentID = mockOrderPayment2.getOrderPaymentID()
				},
				{
					orderPaymentID = mockOrderPayment3.getOrderPaymentID()
				},
				{
					orderPaymentID = mockOrderPayment4.getOrderPaymentID()
				}
			]
		};
		var mockOrder = createPersistedTestEntity('Order', orderData);
		
		var result = mockOrder.getPaymentAmountTotalByPaymentMethod(mockPaymentMethod, mockOrderPayment2); 
		assertEquals(8, result, 'The result should be 10 - 2 = 8');
	}
	
	public void function getPaymentAmountTotalByPaymentMethodTest_Arguments() {
		var mockPaymentMethod1 = createSimpleMockEntityByEntityName('PaymentMethod');
		var mockPaymentMethod2 = createSimpleMockEntityByEntityName('PaymentMethod');
		
		var orderPaymentData1 = {
			orderPaymentID = '',
			paymentMethod = {
				paymentMethodID = mockPaymentMethod1.getPaymentMethodId()
			},
			orderPaymentType = {
				typeID = '444df2f0fed139ff94191de8fcd1f61b'//optCharge
			},
			amount = 1
		};
		var MockOrderPayment1 = createPersistedTestEntity('OrderPayment', orderPaymentData1);
		
		var orderPaymentData2 = {
			orderPaymentID = '',
			paymentMethod = {
				paymentMethodID = mockPaymentMethod1.getPaymentMethodId()
			},
			orderPaymentType = {
				typeID = '444df2f0fed139ff94191de8fcd1f61b'//optCharge
			},
			amount = 2
		};
		var MockOrderPayment2 = createPersistedTestEntity('OrderPayment', orderPaymentData2);
		
		var orderPaymentData3 = {
			orderPaymentID = '',
			paymentMethod = {
				paymentMethodID = mockPaymentMethod2.getPaymentMethodId()
			},
			orderPaymentType = {
				typeID = '444df2f0fed139ff94191de8fcd1f61b'//optCharge
			},
			amount = 4 
		};
		var MockOrderPayment3 = createPersistedTestEntity('OrderPayment', orderPaymentData3);
		
		var orderPaymentData4 = {
			orderPaymentID = '',
			paymentMethod = {
				paymentMethodID = mockPaymentMethod1.getPaymentMethodId()
			},
			orderPaymentType = {
				typeID = '444df2f0fed139ff94191de8fcd1f61b'//optCharge
			},
			amount = 8 
		};
		var MockOrderPayment4 = createPersistedTestEntity('OrderPayment', orderPaymentData4);
		
		var orderData = {
			orderID = '',
			orderPayments = [
				{
					orderPaymentID = mockOrderPayment1.getOrderPaymentID()
				},
				{
					orderPaymentID = mockOrderPayment2.getOrderPaymentID()
				},
				{
					orderPaymentID = mockOrderPayment3.getOrderPaymentID()
				},
				{
					orderPaymentID = mockOrderPayment4.getOrderPaymentID()
				}
			]
		};
		var mockOrder = createPersistedTestEntity('Order', orderData);
		
		var result = mockOrder.getPaymentAmountTotalByPaymentMethod(mockPaymentMethod1, MockOrderPayment2); 
		assertEquals(9, result, 'The result should be 1 + 8 = 9');
	}
	
	public void function checkNewBillingAccountAddressSaveTest_SkipSecondIf() {
		//Mocking data is same with checkNewBillingAccountAddressSaveTest_SecondIf()
		var mockAccountAuthentication = createSimpleMockEntityByEntityName('accountAuthentication');
		
		var accountData = {
			accountID = '',
			accountAuthentications = [{
				accountAuthenticationID = mockAccountAuthentication.getAccountAuthenticationID()
			}],
			GuestAccountFlag = TRUE
		};
		var mockAccount = createPersistedTestEntity('Account', accountData);
		
		
		var addressData = {
			addressID = '',
			name = 'checkNewBillingAccountAddressSaveTest'
		};
		var mockAddress = createPersistedTestEntity('address', addressData);
		
		var orderData = {
			orderID = '',
			account = {
				accountID = mockAccount.getAccountID()
			},
			billingAddress = {
				addressID = mockAddress.getAddressID()
			}
		};
		var mockOrder = createPersistedTestEntity('Order', orderData);
		
		injectMethod(mockOrder, this, 'returnTrue', 'getSaveBillingAccountAddressFlag');
		
		mockOrder.checkNewBillingAccountAddressSave();
		var resultAddressID = mockOrder.getBillingAccountAddress().getAddress().getName();
		assertEquals(mockAddress.getName(), resultAddressID, 'The address Name should be same eventhough the ID is not');
		var resultAccountID = mockOrder.getBillingAccountAddress().getAccount().getAccountID();
		assertEquals(mockAccount.getAccountID(), resultAccountID, 'The account should be the same account');
	}
	
	public void function checkNewBillingAccountAddressSaveTest_secondIf() {
		//Mocking data is same with checkNewBillingAccountAddressSaveTest_SkipSecondIf()
		var mockAccountAuthentication = createSimpleMockEntityByEntityName('accountAuthentication');
		
		var accountData = {
			accountID = '',
			accountAuthentications = [{
				accountAuthenticationID = mockAccountAuthentication.getAccountAuthenticationID()
			}],
			GuestAccountFlag = TRUE
		};
		var mockAccount = createPersistedTestEntity('Account', accountData);
		
		
		var addressData = {
			addressID = '',
			name = 'checkNewBillingAccountAddressSaveTest'
		};
		var mockAddress = createPersistedTestEntity('address', addressData);
		
		var orderData = {
			orderID = '',
			account = {
				accountID = mockAccount.getAccountID()
			},
			billingAddress = {
				addressID = mockAddress.getAddressID()
			}
		};
		var mockOrder = createPersistedTestEntity('Order', orderData);
		
		injectMethod(mockOrder, this, 'returnTrue', 'getSaveBillingAccountAddressFlag');
		injectMethod(mockOrder, this, 'returnOneString', 'getSaveBillingAccountAddressName');
		
		mockOrder.checkNewBillingAccountAddressSave();
		var resultAddressName = mockOrder.getBillingAccountAddress().getAccountAddressName();
		assertEquals('OneString', resultAddressName, 'when getSaveBillingAccountAddressName() exists, should return the addressName');
	}
	
	public void function checkNewShippingAccountAddressSaveTest_SkipSecondIf() {
		//Mocking data is same with checkNewShippingAccountAddressSaveTest_SkipSecondIf()
		var mockAccountAuthentication = createSimpleMockEntityByEntityName('accountAuthentication');
		
		var accountData = {
			accountID = '',
			accountAuthentications = [{
				accountAuthenticationID = mockAccountAuthentication.getAccountAuthenticationID()
			}],
			GuestAccountFlag = TRUE
		};
		var mockAccount = createPersistedTestEntity('Account', accountData);
		
		
		var addressData = {
			addressID = '',
			name = 'checkNewShippingAccountAddressSaveTest'
		};
		var mockAddress = createPersistedTestEntity('address', addressData);
		
		var orderData = {
			orderID = '',
			account = {
				accountID = mockAccount.getAccountID()
			},
			shippingAddress = {
				addressID = mockAddress.getAddressID()
			}
		};
		var mockOrder = createPersistedTestEntity('Order', orderData);
		injectMethod(mockOrder, this, 'returnTrue', 'getSaveShippingAccountAddressFlag');
		
		var result = mockOrder.checkNewShippingAccountAddressSave();
		
		var resultAddressID = mockOrder.getShippingAccountAddress().getAddress().getName();
		assertEquals(mockAddress.getName(), resultAddressID, 'The address Name should be same eventhough the ID is not');
		var resultAccountID = mockOrder.getShippingAccountAddress().getAccount().getAccountID();
		assertEquals(mockAccount.getAccountID(), resultAccountID, 'The account should be the same account');
	}
	
	public function checkNewShippingAccountAddressSaveTest_SecondIf() {
		//Mocking data is same with checkNewShippingAccountAddressSaveTest_SecondIf()
		var mockAccountAuthentication = createSimpleMockEntityByEntityName('accountAuthentication');
		
		var accountData = {
			accountID = '',
			accountAuthentications = [{
				accountAuthenticationID = mockAccountAuthentication.getAccountAuthenticationID()
			}],
			GuestAccountFlag = TRUE
		};
		var mockAccount = createPersistedTestEntity('Account', accountData);
		
		var addressData = {
			addressID = '',
			name = 'checkNewShippingAccountAddressSaveTest'
		};
		var mockAddress = createPersistedTestEntity('address', addressData);
		
		var orderData = {
			orderID = '',
			account = {
				accountID = mockAccount.getAccountID()
			},
			shippingAddress = {
				addressID = mockAddress.getAddressID()
			}
		};
		var mockOrder = createPersistedTestEntity('Order', orderData);
		
		injectMethod(mockOrder, this, 'returnTrue', 'getSaveShippingAccountAddressFlag');
		injectMethod(mockOrder, this, 'returnOneString', 'getSaveShippingAccountAddressName');
		
		mockOrder.checkNewShippingAccountAddressSave();
		var resultAddressName = mockOrder.getShippingAccountAddress().getAccountAddressName();
		assertEquals('OneString', resultAddressName, 'when getSaveShippingAccountAddressName() exists, should return the addressName');
	}
	
	public void function getAddOrderItemSkuOptionsSmartListTest() {
		
	}
	
}