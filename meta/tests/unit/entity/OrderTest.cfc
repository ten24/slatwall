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
	
	private any function createMockSkuAboutSalePrice() {	 	
		var promotionRewardData = {
			promotionRewardID = '',
			amount = 3,
			amountType = 'amountOff'
		};
		var mockPromotionReward = createPersistedTestEntity('PromotionReward', promotionRewardData);
		
	 	var skuData = {
	 		skuID = '',
	 		price = 10,
	 		saleprice = 100,
	 		promotionRewards = [{
	 			promotionRewardID = mockPromotionReward.getPromotionRewardID()
	 		}]
	 	};
	 	var mockSku = createPersistedTestEntity('Sku', skuData);
		
		var promotionPeriodData = {
			promotionPeriodID = '',
			promotionRewards = [{
				promotionRewardID = mockPromotionReward.getPromotionRewardID()
			}]
		};
		var mockPromotionPeriod = createPersistedTestEntity('PromotionPeriod', promotionPeriodData);
		
		var promotionData = {
			promotionid = '',
			promotionPeriods = [{
					promotionPeriodID = mockPromotionPeriod.getPRomotionPeriodID()
				}]
		};
		var promotion = createPersistedTestEntity('promotion',promotionData);

		return mockSku;
	 }
	 
	 //TODO: too much mock data
//	 public void function getOrderItemQualifiedDiscountsTest() {
//	 	var mockSku = createMockSkuAboutSalePrice();
//	 	
//	 	var mockOrderItem1 = createMockOrderItem(skuID = mockSku.getSkuID());
//	 	var mockOrderItem2 = createMockOrderItem(skuID = mockSku.getSkuID());
//	 	var mockOrderItem3 = createMockOrderItem(skuID = mockSku.getSkuID());
//		
//		var mockOrder1 = createMockOrderWithOrderItems([mockOrderItem1.getOrderItemID(), 
//														mockOrderItem2.getOrderItemID(),
//														mockOrderItem3.getOrderItemID()]);				
//		var result = mockOrder1.getOrderItemQualifiedDiscounts();
//	 }
	 
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
	 
	 public void function getDynamicChargeOrderPaymentTest() {
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
	 
	 public void function getDynamicCreditOrderPaymentTest() {
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
	
}