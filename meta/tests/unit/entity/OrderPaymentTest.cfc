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
		
		variables.entity = request.slatwallScope.getService("orderService").newOrderPayment();
	}
	
	public void function defaults_are_correct() {
		super.defaults_are_correct();
		assertEquals(variables.entity.getPaymentTransactions(), []);
		assertEquals(variables.entity.getReferencingOrderPayments(), []);
	}
	
	public void function getSucessfulPaymentTransactionExistsFlag_returns_false_by_default() {
		assertFalse(variables.entity.getSucessfulPaymentTransactionExistsFlag());
	}
	
	public void function getSucessfulPaymentTransactionExistsFlag_returns_true_when_should() {
		var paymentTransaction = request.slatwallScope.newEntity('paymentTransaction');
		paymentTransaction.setTransactionSuccessFlag(true);
		paymentTransaction.setOrderPayment( variables.entity );
		
		assert(variables.entity.getSucessfulPaymentTransactionExistsFlag());
	}
	
	public void function getPeerOrderPaymentNullAmountExistsFlag_returns_true_when_should(){ 
		var orderTrueData = { 
			orderID = '',
			orderPayments=[
				{
					orderPaymentID='',
					orderPaymentStatusType={
						orderPaymentStatusTypeID = '5accbf57dcf5bb3eb71614febe83a31d'	
					}
				},
				{ 
					orderPaymentID='', 
					orderPaymentStatusType={
						orderPaymentStatusTypeID = '5accbf57dcf5bb3eb71614febe83a31d'	
					}
				}
			]
		}; 
		
		var orderFalseData = { 
			orderID = '',
			orderPayments=[
				{
					orderPaymentID='',
					orderPaymentStatusType={
						orderPaymentStatusTypeID = '5accbf58a94b61fe031f854ffb220f4b'	
					}
				}
			]
		};
		
		var order1 = createPersistedTestEntity('order', orderTrueData);
		var order2 = createPersistedTestEntity('order', orderFalseData);
		
		assertTrue(order1.getOrderPayments()[2].getPeerOrderPaymentNullAmountExistsFlag()); 
		assertFalse(order1.getOrderPayments()[1].getPeerOrderPaymentNullAmountExistsFlag()); 
		assertFalse(order2.getOrderPayments()[1].getPeerOrderPaymentNullAmountExistsFlag()); 
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
	
	public void function test_gift_card_transaction_relation(){ 
		var orderPaymentData = { 
			orderPaymentID="",
			amount="100.00"
		};
		
		var giftCardTransactionData = { 
			giftCardTransactionID="",
			credit="100.00"
		};
		
		var orderPayment = createPersistedTestEntity('orderPayment', orderPaymentData); 
		var giftCardTransaction = createPersistedTestEntity('giftCardTransaction', giftCardTransactionData);
		
		orderPayment.addGiftCardTransaction(giftCardTransaction); 
		
		assertTrue(orderPayment.hasGiftCardTransaction(giftCardTransaction)); 
		
		orderPayment.removeGiftCardTransaction(giftCardTransaction); 
		
		assertFalse(orderPayment.hasGiftCardTransaction(giftCardTransaction)); 
	}
	
	private any function createMockOrderPayment(string orderID='', string orderTypeID='', numeric amount) {
	 	var orderPaymentData = {
	 		orderPaymentID = ''
	 	};
	 	if(len(arguments.orderID)) {
	 		orderPaymentData.order = {
	 			orderID = arguments.orderID
	 		};
	 	}
	 	if(len(arguments.orderTypeID)) {
	 		orderPaymentType = {
	 			typeID = arguments.orderTypeID
	 		};
	 	}
	 	if(!isNull(arguments.amount)) {
	 		orderPaymentData.amount = arguments.amount;
	 	}
	 	return createPersistedTestEntity('OrderPayment', orderPaymentData);
	 }
	 
	public void function getDynamicAmountFlagTest() {
		//Testing the true
		var mockOrderPayment = createMockOrderPayment(amount = 100);
		
		var resultAmountFlag1 = mockOrderPayment.getDynamicAmountFlag();
		assertFalse(resultAmountFlag1);
		
		//Testing the false
		var mockOrderPayment2 = createMockOrderPayment();
		
		var resultAmountFlag2 = mockorderPayment2.getDynamicAmountFlag();
		assertTrue(resultAmountFlag2);
	}
}


