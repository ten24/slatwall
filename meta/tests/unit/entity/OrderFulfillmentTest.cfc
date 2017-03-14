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
		
		variables.entity = request.slatwallScope.newEntity( 'OrderFulfillment' );
	}
	
	private numeric function getDiscountAmountFake(){
		return 75.42;
	}
	
	public void function getChargeAfterDiscountTest(){
		var orderfulfillment = createTestEntity('orderFulfillment',{
			fulfillmentCharge=7
		});
		injectMethod(orderfulfillment,this,'getDiscountAmountFake','getDiscountAmount');
		assertEquals(-68.42,orderfulfillment.getChargeAfterDiscount());
	}
	
	public void function getDiscountAmountTest(){
		var orderfulfillment = createPersistedTestEntity('orderFulfillment',{
			orderFulfillmentID=""
		});
		var promotionAppliedData = {
			promotionAppliedID="",
			discountAmount=7,
			orderFulfillment={
				orderFulfillmentID=orderFulfillment.getOrderFulfillmentID()
			}
		};
		var promotionApplied = createPersistedTestEntity('PromotionApplied',promotionAppliedData);
		
		var promotionAppliedData2 = {
			promotionAppliedID="",
			discountAmount=3.43,
			orderFulfillment={
				orderFulfillmentID=orderFulfillment.getOrderFulfillmentID()
			}
		};
		var promotionApplied2 = createPersistedTestEntity('PromotionApplied',promotionAppliedData2);
		
		assertEquals(10.43,orderfulfillment.getDiscountAmount());
	}
	
	private numeric function getSubtotalAfterDiscountsWithTaxFake(){
		return 123.123;
	}
	
	private numeric function getChargeAfterDiscountFake(){
		return 12.23123;
	}
	
	public void function getFulfillmentTotalTest(){
		var orderfulfillment = createPersistedTestEntity('orderFulfillment',{
			orderFulfillmentID=""
		});
		injectMethod(orderfulfillment,this,'getChargeAfterDiscountFake','getChargeAfterDiscount');
		injectMethod(orderfulfillment,this,'getSubtotalAfterDiscountsWithTaxFake','getSubtotalAfterDiscountsWithTax');
		
		assertEquals(135.35,orderFulfillment.getFulfillmentTotal());
	}
	
	public void function getItemDiscountAmountTotalTest(){
		var orderfulfillment = createPersistedTestEntity('orderFulfillment',{
			orderFulfillmentID=""
		});
		
		var orderFulfillmentItemData = {
			orderFulfillmentItemID="",
			orderFulfillment={
				orderFulfillmentID=orderFulfillment.getOrderFulfillmentID()	
			}
		};
		var orderFulfillmentItem = createPersistedTestEntity('OrderItem',orderFulfillmentItemData);
		injectMethod(orderFulfillmentItem,this,'getDiscountAmountFake','getDiscountAmount');
		
		var orderFulfillmentItemData2 = {
			orderFulfillmentItemID="",
			orderFulfillment={
				orderFulfillmentID=orderFulfillment.getOrderFulfillmentID()	
			}
		};
		var orderFulfillmentItem2 = createPersistedTestEntity('OrderItem',orderFulfillmentItemData2);
		injectMethod(orderFulfillmentItem2,this,'getDiscountAmountFake','getDiscountAmount');
		
		assertEquals(150.84,orderfulfillment.getItemDiscountAmountTotal());
	}
	
	public void function getSubtotalTest(){
		var orderfulfillment = createPersistedTestEntity('orderFulfillment',{
			orderFulfillmentID=""
		});
		
		var orderFulfillmentItemData = {
			orderFulfillmentItemID="",
			orderFulfillment={
				orderFulfillmentID=orderFulfillment.getOrderFulfillmentID()	
			}
		};
		var orderFulfillmentItem = createPersistedTestEntity('OrderItem',orderFulfillmentItemData);
		injectMethod(orderFulfillmentItem,this,'getExtendedPriceFake','getExtendedPrice');
		
		var orderFulfillmentItemData2 = {
			orderFulfillmentItemID="",
			orderFulfillment={
				orderFulfillmentID=orderFulfillment.getOrderFulfillmentID()	
			}
		};
		var orderFulfillmentItem2 = createPersistedTestEntity('OrderItem',orderFulfillmentItemData2);
		injectMethod(orderFulfillmentItem2,this,'getExtendedPriceFake','getExtendedPrice');
		
		assertEquals(6424.64,orderFulfillment.getSubtotal());
	}
	
	public void function getSubtotalAfterDiscountsTest(){
		var orderfulfillment = createPersistedTestEntity('orderFulfillment',{
			orderFulfillmentID=""
		});
		injectMethod(orderfulfillment,this,'getItemDiscountAmountTotalFake','getItemDiscountAmountTotal');
		injectMethod(orderfulfillment,this,'getSubtotalFake','getSubtotal');
		assertEquals(85950.20,orderfulfillment.getSubtotalAfterDiscounts());
	}
	
	private numeric function getTaxAmountFake(){
		return 898734.4398;
	}
	
	public void function getSubtotalAfterDiscountsWithTaxTest(){
		var orderfulfillment = createPersistedTestEntity('orderFulfillment',{
			orderFulfillmentID=""
		});
		injectMethod(orderfulfillment,this,'getSubtotalFake','getSubtotal');
		injectMethod(orderfulfillment,this,'getItemDiscountAmountTotalFake','getItemDiscountAmountTotal');
		injectMethod(orderfulfillment,this,'getTaxAmountFake','getTaxAmount');
		assertEquals(984684.64,orderfulfillment.getSubtotalAfterDiscountsWithTax());
	}
	
	public void function getTaxAmountTest(){
		var orderfulfillment = createPersistedTestEntity('orderFulfillment',{
			orderFulfillmentID=""
		});
		
		var orderFulfillmentItemData = {
			orderFulfillmentItemID="",
			orderFulfillment={
				orderFulfillmentID=orderFulfillment.getOrderFulfillmentID()	
			}
		};
		var orderFulfillmentItem = createPersistedTestEntity('OrderItem',orderFulfillmentItemData);
		injectMethod(orderFulfillmentItem,this,'getTaxAmountFake','getTaxAmount');
		
		var orderFulfillmentItemData2 = {
			orderFulfillmentItemID="",
			orderFulfillment={
				orderFulfillmentID=orderFulfillment.getOrderFulfillmentID()	
			}
		};
		var orderFulfillmentItem2 = createPersistedTestEntity('OrderItem',orderFulfillmentItemData2);
		injectMethod(orderFulfillmentItem2,this,'getTaxAmountFake','getTaxAmount');
		
		assertEquals(1797468.88,orderFulfillment.getTaxAmount());
	}
	
	public void function getTotalShippingWeightTest(){
		var orderfulfillment = createPersistedTestEntity('orderFulfillment',{
			orderFulfillmentID=""
		});
	}
	
	private numeric function getPaymentAmountReceivedTotalFake(){
		return 12.1231;
	}
	
	private numeric function getTotalFake(){
		return 875.34;
	}
	
	public void function hasOrderWithMinAmountRecievedRequiredForFulfillmentTest(){
		var orderfulfillment = createPersistedTestEntity('orderFulfillment',{
			orderFulfillmentID=""
		});
		
		var orderData = {
			orderID="",
			orderFulfillment={
				orderFulfillmentID=orderFulfillment.getOrderFulfillmentID()
			}
		};
		var order = createPersistedTestEntity('Order',orderData);
		
		injectMethod(order,this,'getTotalFake','getTotal');
		injectMethod(order,this,'getPaymentAmountReceivedTotalFake','getPaymentAmountReceivedTotal');
		orderFulfillment.setOrder(order);
		var fulfillmentMethodData={
			fulfillmentMethodID="",
			orderFulfillment={
				orderFulfillmentID=orderFulfillment.getOrderFulfillmentID()
			}
		};
		var fulfillmentMethod = createPersistedTestEntity('fulfillmentMethod',fulfillmentMethodData);
		orderFulfillment.setFulfillmentMethod(fulfillmentMethod);
		
		var settingData = {
			settingID="",
			settingName="fulfillmentMethodAutoMinReceivedPercentage",
			settingValue="1",
			fulfillmentMethod={
				fulfillmentMethodID=fulfillmentMethod.getfulfillmentMethodID()
			}
		};
		var settingEntity = createPersistedTestEntity('setting',settingData);
		
		assert(orderfulfillment.hasOrderWithMinAmountRecievedRequiredForFulfillment());
	}
	
	private numeric function getItemDiscountAmountTotalFake(){
		return 3523.23;
	}
	
	private numeric function getSubtotalFake(){
		return 89473.43;
	}
	
	private numeric function getExtendedPriceFake(){
		return 3212.32;
	}
	
	public void function populate_accountAddress_updates_shippingAddress() {
		
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
		
		var data = {
			accountAddress = {
				accountAddressID = accountAddressOne.getAccountAddressID()
			}
		};
		
		variables.entity.populate( data );
		
		assertEquals( accountAddressDataOne.address.streetAddress, variables.entity.getShippingAddress().getStreetAddress() );
		
		var data = {
			accountAddress = {
				accountAddressID = accountAddressTwo.getAccountAddressID()
			}
		};
		
		variables.entity.populate(data);
		
		assertEquals( accountAddressDataTwo.address.streetAddress, variables.entity.getShippingAddress().getStreetAddress() );
	}
	
	public void function setAccountAddress_updates_shippingAddress() {
		
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
		
		variables.entity.setAccountAddress( accountAddressOne );
		
		assertEquals( accountAddressDataOne.address.streetAddress, variables.entity.getShippingAddress().getStreetAddress() );
		
		variables.entity.setAccountAddress( accountAddressTwo );
		
		assertEquals( accountAddressDataTwo.address.streetAddress, variables.entity.getShippingAddress().getStreetAddress() );

	}
	
	public void function setAccountAddress_updates_shippingAddress_without_creating_a_new_one() {
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
		
		variables.entity.setAccountAddress( accountAddress );
		
		assertEquals( accountAddressDataOne.address.streetAddress, variables.entity.getShippingAddress().getStreetAddress() );
		assertEquals( shippingAddress.getAddressID(), variables.entity.getShippingAddress().getAddressID() );
	}
	
	public void function setAccountAddress_doesnt_updates_shippingAddress_when_same_aa_as_before() {
		var accountAddressDataOne = {
			address = {
				addressID = "",
				streetAddress = "456 Main Street"
			}
		};
		
		var accountAddress = createPersistedTestEntity( 'AccountAddress', accountAddressDataOne );
		
		variables.entity.setAccountAddress( accountAddress );
		
		assertEquals( accountAddressDataOne.address.streetAddress, variables.entity.getShippingAddress().getStreetAddress() );
		
		variables.entity.getShippingAddress().setStreetAddress('123 Main Street');
		
		variables.entity.setAccountAddress( accountAddress );
		
		assertEquals( '123 Main Street', variables.entity.getShippingAddress().getStreetAddress() );
		
	}
	
	// getRequiredShippingInfoExistsFlag()
	public void function getRequiredShippingInfoExistsFlag_returns_false_by_default() {
		assertFalse(variables.entity.getRequiredShippingInfoExistsFlag());
	}
}
