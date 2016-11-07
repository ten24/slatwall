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
		variables.service = request.slatwallScope.getService("orderService");

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
	public void function processOrder_addAndRemoveOrderItem_addOrderItems(){
		//set up data

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
	}

	public void function process_order_add_gift_card_order_item(){
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
	}

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
}
