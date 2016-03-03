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

	// @hint put things in here that you want to run befor EACH test
	public void function setUp() {
		super.setup();

	}
	public void function matchesOrderItem(){

		//Testing adding child order items.
		var psku = getTestSku('TestSku#createUUID()#');
		var pstock = getTestStock();
		var pstock2 = getTestStock();
		var porderItem = request.slatwallScope.newEntity( 'orderItem' );
		porderItem.setSku(psku);
		porderItem.setOrderItemID("parentOrderItemasdfasdf99");
		porderItem.setPrice(11);
		porderItem.setStock(pstock);
		porderItem.setProductBundleGroup("PBG1");

		var sku = getTestSku('TestSku#createUUID()#');
		var stock = getTestStock();
		var stock2 = getTestStock();
		var orderItem = request.slatwallScope.newEntity( 'orderItem' );
		orderItem.setSku(sku);
		orderItem.setOrderItemID("childOrderItemasdfasdf");
		orderItem.setPrice(11);
		orderItem.setStock(stock);
		orderItem.setParentOrderItem(porderItem);
		orderItem.setProductBundleGroup(pOrderItem);

		var sku2 = getTestSku('TestSku#createUUID()#');
		var stock3 = getTestStock();
		var stock4 = getTestStock();
		var orderItem2 = request.slatwallScope.newEntity( 'orderItem' );

		orderItem2.setSku(sku2);
		orderItem2.setOrderItemID("childOrderItemasdfasdf2");
		orderItem2.setPrice(11);
		orderItem2.setStock(stock3);
		orderItem2.setParentOrderItem(porderItem);
		orderItem2.setProductBundleGroup("PBG1");

		//Has child orderItems
		porderitem.addChildOrderItem(orderItem);
		porderitem.addChildOrderItem(orderItem2);
		assertEquals(porderitem.hasChildOrderItem(), true);
		assertEquals(2, arrayLen(porderItem.getChildOrderItems()));

		var order = request.slatwallScope.newEntity( 'order' );
		var processOrderItem = order.getProcessObject( 'AddOrderItem' );
		processOrderItem.setSku(sku);
		processOrderItem.setPrice(11);
		processOrderItem.setStock(stock);
		processOrderItem.setChildOrderItems(porderItem.getChildOrderItems());
		var hasMatchingChildren = processOrderItem.getChildOrderItems();
		assertEquals(porderitem.getChildOrderItems(), hasMatchingChildren);

		//different becuse of children as orderitem
		var order = request.slatwallScope.newEntity( 'order' );
		processOrderItem = order.getProcessObject( 'AddOrderItem' );
		processOrderItem.setSku(sku);
		processOrderItem.setPrice(11);
		processOrderItem.setStock(stock);
		var foundMatch = processOrderItem.matchesOrderItem(porderItem);
		assertFalse(foundMatch);

		//same as orderitem
		var order = request.slatwallScope.newEntity( 'order' );
		processOrderItem = order.getProcessObject( 'AddOrderItem' );
		processOrderItem.setSku(sku);
		processOrderItem.setPrice(11);
		processOrderItem.setStock(stock);
		var foundMatch = processOrderItem.matchesOrderItem(orderItem);
		assertTrue(foundMatch);

		//different sku as orderitem
		var sku2 = getTestSku('TestSku2#createUUID()#');
		processOrderItem.setSku(sku2);
		processOrderItem.setPrice(11);
		processOrderItem.setStock(stock);
		var foundMatch = processOrderItem.matchesOrderItem(orderItem);
		assertFalse(foundMatch);

		//different stock as orderitem
		processOrderItem.setSku(sku);
		processOrderItem.setPrice(11);
		processOrderItem.setStock(stock2);
		var foundMatch = processOrderItem.matchesOrderItem(orderItem);
		assertFalse(foundMatch);

		//different price as orderitem
		processOrderItem.setSku(sku);
		processOrderItem.setPrice(12);
		processOrderItem.setStock(stock);
		var foundMatch = processOrderItem.matchesOrderItem(orderItem);
		assertFalse(foundMatch);

	}

	public void function test_gift_card_add_order_item(){

		var giftProduct = getTestProduct("TestGiftProduct");

		var giftSku = getTestSku('TestGiftSku');
		giftSku.setCurrencyCode('USD');
		giftSku.setPrice('10.00');

		var giftExpirationTerm = getTestTerm("expirationTerm");

		giftSku.setGiftCardExpirationTerm(giftExpirationTerm);

		giftProduct.addSku(giftSku);

		var giftOrderItem = request.slatwallScope.newEntity( 'orderItem' );
		giftOrderItem.setSku(giftProduct.getSkus()[1]);
		giftOrderItem.setPrice('10.00');
		giftOrderItem.setQuantity(2);

		var order = request.slatwallScope.newEntity( 'order' );
		var processOrderItem = order.getProcessObject( 'AddOrderItem' );
		processOrderItem.setSku(giftProduct.getSkus()[1]);
		processOrderItem.setPrice('10.00');
		processOrderItem.setQuantity(2);

		assertTrue(processOrderItem.getSku().getGiftCardExpirationTerm().getTermID() == giftExpirationTerm.getTermID());
		assertTrue(giftOrderItem.getSku().getGiftCardExpirationTerm().getTermID() == giftExpirationTerm.getTermID());

		var foundMatch = processOrderItem.matchesOrderItem(giftOrderItem);
		assertTrue(foundMatch);

	}

	private any function getTestTerm(string testterm){
		var termData = {
			termID="",
			termName=arguments.testterm,
			termHours="1",
			termDays="2",
			termMonths="3",
			termYears="4"
		};

		var giftExpirationTerm = createPersistedTestEntity("Term", termData);

		return giftExpirationTerm;
	}

	private any function getTestProduct(string testproduct){

		var productData = {
			productID="",
			productName=arguments.testproduct,
			productType={
				productTypeID="50cdfabbc57f7d103538d9e0e37f61e4"
			}
		};

		var product = createPersistedTestEntity('Product', productData);
		
		return product;
	}

	private any function getTestSku(string testsku){

		var skuData = {
			skuID="",
			skuName=arguments.testsku,
			skuCode=arguments.testsku
		};

		var sku = createPersistedTestEntity('Sku', skuData);

		return sku;
	}

	private any function getTestStock(){

		var stockData = {
			stockID=""
		};

		var stock = createPersistedTestEntity('Stock', stockData);

		return stock;
	}

}
