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
	//===================== Injected Functions: General ==============================
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
	
	
	//====================== Injected Functions in OrderService.cfc ===================
	private numeric function getOrderPaymentNonNullAmountTotal(){
		return 70;
	} 
	private numeric function getPreviouslyReturnedFulfillmentTotal() {
		return 30;
	}
	
	//====================== Injected Functions in Order.cfc ==========================
	
	
	//====================== Injected Functions in OrderPayment.cfc ==========================
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
		//TODO: Need to deal with persisted test entity in Inject scope
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
	
	public void function getORderPaymentAmountNeededTest_DynamicCreditOrderPaymentNotNull() {
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
	
		// This way also works:
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
//		request.debug(myOrder2.getORderID());
//		mockOrder.getTotal(myMock);
//		request.debug(mockOrder2.getTotal());
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
	
	
}