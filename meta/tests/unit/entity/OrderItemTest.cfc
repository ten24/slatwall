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

		variables.entity = request.slatwallScope.newEntity( 'OrderItem' );
	}

	public void function getProductBundlePrice_fixed_none(){
		var productData = {
			productName="productBundleName",
			productCode=createUUID(),
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
					skuCode = createUUID(),
					productBundleGroups=[
						{
							productBundleGroupid:"",
							amount=4.25,
							amountType="fixed"
						},
						{
							productBundleGroupid:"",
							amount=2.12,
							amountType="none"
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

		////addToDebug(product.getSkus()[1].getProductBundleGroups()[1].getAmount());

		var orderItemData = {
			orderitemid='',
			skuPrice=5,
			sku=product.getSkus()[1],
			quantity=1,
			childOrderItems=[
				{
					orderItemid='',
					skuPrice=4.25,
					quantity=1,
					bundleItemQuantity=1

				},
				{
					orderItemid='',
					skuPrice=2.12,
					quantity=1,
					bundleItemQuantity=1
				}
			]
		};
		var orderItem = createPersistedTestEntity('orderItem',orderItemData);
		orderItem.getChildOrderItems()[1].setProductBundleGroup(product.getSkus()[1].getProductBundleGroups()[1]);
		orderItem.getChildOrderItems()[2].setProductBundleGroup(product.getSkus()[1].getProductBundleGroups()[2]);
		assertEquals(orderItem.getProductBundlePrice(),9.25);
	}

	public void function getProductBundlePrice_increase_decrease_skuPrice(){
		var productData = {
			productName="productBundleName",
			productCode="#createUUID()#",
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
					skuCode = createUUID(),
					productBundleGroups=[
						{
							productBundleGroupid:"",
							amount=10,
							amountType="skuPricePercentageIncrease"
						},
						{
							productBundleGroupid:"",
							amount=25,
							amountType="skuPricePercentageDecrease"
						},
						{
							productBundleGroupid:"",
							amount=11,
							amountType="skuPrice"
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

		////addToDebug(product.getSkus()[1].getProductBundleGroups()[1].getAmount());

		var orderItemData = {
			orderitemid='',
			price=5,
			skuPrice=5,
			sku=product.getSkus()[1],
			quantity=1,
			childOrderItems=[
				{
					orderItemid='',
					quantity=1,
					bundleItemQuantity=1,
					skuPrice=100
				},
				{
					orderItemid='',
					quantity=1,
					bundleItemQuantity=1,
					skuPrice=200
				},
				{
					orderItemid='',
					quantity=1,
					bundleItemQuantity=1,
					skuPrice=30
				}
			]
		};
		var orderItem = createPersistedTestEntity('orderItem',orderItemData);
		orderItem.getChildOrderItems()[1].setProductBundleGroup(product.getSkus()[1].getProductBundleGroups()[1]);
		orderItem.getChildOrderItems()[2].setProductBundleGroup(product.getSkus()[1].getProductBundleGroups()[2]);
		orderItem.getChildOrderItems()[3].setProductBundleGroup(product.getSkus()[1].getProductBundleGroups()[3]);
		//5 + 110 + 150 + 30
		assertEquals(orderItem.getProductBundlePrice(),295);
		//addToDebug(orderItem.getProductBundlePrice());

	}

	public void function getProductBundlePrice_package_quantity() {
		var productData = {
			productName="productBundleName",
			productCode="#createUUID()#",
			productid="",
			activeflag=1,
			price=1,
			currencycode="USD",
			skus=[
				{
					currencycode="USD",
					skuid="",
					price=0,
					activeflag=1,
					skuCode = createUUID(),
					productBundleGroups=[
						{
							productBundleGroupid:"",
							amount=0,
							amountType="skuPrice"
						},
						{
							productBundleGroupid:"",
							amount=0,
							amountType="skuPrice"
						},
						{
							productBundleGroupid:"",
							amount=0,
							amountType="skuPrice"
						}
					]
				}
			],
			//product Bundle type from SlatwallProductType.xml
			productType:{
				productTypeid:"ad9bb5c8f60546e0adb428b7be17673e"
			}
		};

		var product = createPersistedTestEntity('product', productData);

		var	orderItemData = {
			orderItemid='',
			price=0,
			skuPrice=0,
			quantity=2,
			childOrderItems=[
				{
					orderItemid='',
					quantity=6,
					bundleItemQuantity=3,
					skuPrice=5
				},
				{
					orderItemid='',
					quantity=4,
					bundleItemQuantity=2,
					skuPrice=10
				},
				{
					orderItemid='',
					quantity=8,
					bundleItemQuantity=4,
					skuPrice=15
				}
			]
		};

		var orderItem = createPersistedTestEntity('orderItem', orderItemData);

		orderItem.setSku(product.getSkus()[1]);

		orderItem.getChildOrderItems()[1].setProductBundleGroup(product.getSkus()[1].getProductBundleGroups()[1]);
		orderItem.getChildOrderItems()[2].setProductBundleGroup(product.getSkus()[1].getProductBundleGroups()[2]);
		orderItem.getChildOrderItems()[3].setProductBundleGroup(product.getSkus()[1].getProductBundleGroups()[3]);

		assertEquals(5, orderItem.getProductBundleGroupPrice(orderItem.getChildOrderItems()[1]));
		assertEquals(10, orderItem.getProductBundleGroupPrice(orderItem.getChildOrderItems()[2]));
		assertEquals(15, orderItem.getProductBundleGroupPrice(orderItem.getChildOrderItems()[3]));

		assertEquals('productBundle', orderItem.getSku().getProduct().getProductType().getSystemCode());

		assertEquals(190, orderItem.getExtendedPrice());
		orderItem.setQuantity(1);
		assertEquals(95, orderItem.getExtendedPrice());
		orderItem.setQuantity(4);
		assertEquals(380, orderItem.getExtendedPrice());

		//test ignore child order item quantity
		orderItem.getChildOrderItems()[1].setQuantity(5);
		orderItem.getChildOrderItems()[2].setQuantity(4);
		orderItem.getChildOrderItems()[3].setQuantity(3);

		orderItem.setQuantity(2);
		assertEquals(190, orderItem.getExtendedPrice());
		orderItem.setQuantity(1);
		assertEquals(95, orderItem.getExtendedPrice());
		orderItem.setQuantity(4);
		assertEquals(380, orderItem.getExtendedPrice());
	}
	
	public void function getExtendedPriceTest(){
		var productData = {
			productID="",
			productName="productTest",
			productType={
				productTypeID='444df2f7ea9c87e60051f3cd87b435a1'
			}
		};
		var product = createPersistedTestEntity('product',productData);
		
		var skuData = {
			skuID="",
			product={
				productID=product.getProductID()
			}
		};
		var sku = createPersistedTestEntity('sku',skuData);
		
		var orderItemData = {
			orderItemID="",
			quantity=2,
			price=99.99,
			sku={
				skuID=sku.getSkuID()
			}
		};
		var orderItem = createPersistedTestEntity('OrderItem',orderItemData);
		assertEquals(orderItem.getExtendedPrice(),199.98);
	}

	public void function test_quantity_and_bundleItemQuantity() {
		var	orderItemData = {
			orderItemid='',
			price=0,
			skuPrice=0,
			quantity=2,
			childOrderItems=[
				{
					orderItemid='',
					quantity=6,
					bundleItemQuantity=3,
					skuPrice=5
				},
				{
					orderItemid='',
					quantity=4,
					bundleItemQuantity=2,
					skuPrice=10
				},
				{
					orderItemid='',
					quantity=8,
					bundleItemQuantity=4,
					skuPrice=15
				}
			]
		};
		var orderItem = createPersistedTestEntity('orderItem', orderItemData);

		orderItem.getChildOrderItems()[1].setBundleItemQuantity(4);
		assertEquals(8, orderItem.getChildOrderItems()[1].getQuantity());
		orderItem.getChildOrderItems()[2].setBundleItemQuantity(1);
		assertEquals(2, orderItem.getChildOrderItems()[2].getQuantity());
		orderItem.getChildOrderItems()[3].setBundleItemQuantity(10);
		assertEquals(20, orderItem.getChildOrderItems()[3].getQuantity());
		orderItem.setQuantity(3);
		assertEquals(12, orderItem.getChildOrderItems()[1].getQuantity());
		assertEquals(3, orderItem.getChildOrderItems()[2].getQuantity());
		assertEquals(30, orderItem.getChildOrderItems()[3].getQuantity());
		orderItem.setQuantity(1);
		assertEquals(4, orderItem.getChildOrderItems()[1].getQuantity());
		assertEquals(1, orderItem.getChildOrderItems()[2].getQuantity());
		assertEquals(10, orderItem.getChildOrderItems()[3].getQuantity());
	}


	public void function validate_as_save_for_a_new_instance_doesnt_pass() {

	}


	public void function getSimpleRepresentation_exists_and_is_simple() {

	}

	public void function test_set_and_remove_gift_card() {

		var orderItemData = {
			orderItemID='',
			price='5'
		};
		var orderItem = createPersistedTestEntity('orderItem',orderItemData);

		var giftCardData = {
			giftCardID='',
			giftCardPin='1111'
		};
		var giftCard = createPersistedTestEntity('giftCard', giftCardData);

		orderItem.addGiftCard(giftCard);

		assertTrue(orderItem.hasGiftCard(giftCard));

		orderItem.removeGiftCard(giftCard);

		assertFalse(orderItem.hasGiftCard(giftCard));

	}


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

	/**
	* Put the orderItemID string in array, the entity will associated with all of them
	*/
	private any function createMockOrderWithOrderItems(required array orderItemIDArray, string orderTypeID='') {
		var orderData = {
			orderID = "",
			orderItems = []
		};
		for (var i = 1; i <= arrayLen(arguments.orderItemIDArray); i++) {
			orderData.orderItems[i] = {
				orderItemID = arguments.orderItemIDArray[i]
			};
		}
		if(len(arguments.orderTypeID)){
			orderData.orderType = {
				typeID = arguments.orderTypeID
			};
		}
		return createPersistedTestEntity('Order', orderData);
	}

	private any function createMockSku() {
		var skuData = {
			skuID = '',
			skuCode = createUUID()
		};
		return createPersistedTestEntity('Sku', skuData);
	}

	public void function hasQuantityWithinMaxOrderQuantityTest_OrderItemType() {
		var mockSku = createMockSku();

		var productData = {
			productID = '',
			skus = [{
				skuID = mockSku.getSkuID(),
				skuCode = createUUID()
			}]
		};
		var mockProduct = createPersistedTestEntity('Product', productData);

		var mockOrderItemOITSale = createMockOrderItem('444df2e9a6622ad1614ea75cd5b982ce', 100, mockSku.getSkuID());
		var mockOrderItemOITReturn = createMockOrderItem('444df2eac18fa589af0f054442e12733', 100, mockSku.getSkuID());

		var mockOrder1 = createMockOrderWithOrderItems([mockOrderItemOITSale.getOrderItemID()]);

		var resultOITSale = mockOrderITemOITSale.hasQuantityWithinmaxOrderQuantity();
		assertTrue(resultOITSale, 'oitSale should go into the if statements and do calculation');

		var resultOITReturn = mockOrderItemOITReturn.hasQuantityWithinmaxOrderQuantity();
		assertTrue(resultOITReturn, 'For orderITem types other than oitSale, should return the TRUE after the if statements');
	}

	public void function hasQuantityWithinMaxOrderQuantityTest_QuantityComparision() {
		var mockSku = createMockSku();

		var productData = {
			productID = '',
			skus = [{
				skuID = mockSku.getSkuID(),
				skuCode = createUUID()
			}]
		};
		var mockProduct = createPersistedTestEntity('Product', productData);

		var mockOrderItemSale1 = createMockOrderItem('444df2e9a6622ad1614ea75cd5b982ce', 100, mockSku.getSkuID());
		var mockOrderItemSale2 = createMockOrderItem('444df2e9a6622ad1614ea75cd5b982ce', 1000, mockSku.getSkuID());
		var mockOrderItem1 = createMockOrderItem(quantity = 10, skuID = mockSku.getSkuID());
		var mockOrderItem2 = createMockOrderItem(quantity = 20, skuID = mockSku.getSkuID());
		var mockOrderItem3 = createMockOrderItem(quantity = 40, skuID = mockSku.getSkuID());

		var mockOrder1 = createMockOrderWithOrderItems([mockOrderItem1.getOrderItemID(),
														mockOrderItem2.getOrderItemID(),
														mockOrderItemSale1.getOrderItemID()]);
		var mockOrder2 = createMockOrderWithOrderItems([mockOrderItem3.getOrderItemID(),
														mockOrderItemSale2.getOrderItemID()]);

		var resultSale1 = mockOrderItemSale1.hasQuantityWithinmaxOrderQuantity();
		assertTrue(resultSale1, 'The quantity of mockOrder1 should be 130 in total, which is less than getMaximumOrderQuantity()');

		var resultSale2 = mockOrderItemSale2.hasQuantityWithinmaxOrderQuantity();
		assertFalse(resultSale2, 'The quantity of mockOrder2 should be 1040 in total, which is more than getMaximumOrderQuantity(), should return false');
	}

	public void function hasQuantityWithinMaxOrderQuantityTest_getSkuIsNull() {
		var mockSku = createMockSku();

		var productData = {
			productID = '',
			skus = [{
				skuID = mockSku.getSkuID(),
				skuCode = createUUID()
			}]
		};
		var mockProduct = createPersistedTestEntity('Product', productData);

		var mockOrderItemRunFunction1 = createMockOrderItem('444df2e9a6622ad1614ea75cd5b982ce', 1000, mockSku.getSkuID());
		var mockOrderItemRunFunction2 = createMockOrderItem('444df2e9a6622ad1614ea75cd5b982ce', 1000, mockSku.getSkuID());
		var mockOrderItemNoSku 		  = createMockOrderItem(quantity = 10);

		var mockOrderHasSku 	  = createMockOrderWithOrderItems([mockOrderItemRunFunction1.getOrderItemID()]);
		var mockOrderOneSkuOneNot = createMockOrderWithOrderItems([mockOrderItemRunFunction2.getOrderItemID(),
															 	   mockOrderItemNoSku.getOrderItemID()]);

		var resultOrderHasSku = mockOrderItemRunFunction1.hasQuantityWithinmaxOrderQuantity();
		assertTrue(resultOrderHasSku, '1000 <= getMaximumOrderQuantity()');

		var resultOrderOneSkuOneNot = mockOrderItemRunFunction2.hasQuantityWithinmaxOrderQuantity();
		assertTrue(resultOrderOneSkuOneNot, 'quantity should still be 1000, the mockOrderItemNoSku should not be added in quantity formula');
	}

	public void function hasQuantityWithinMinOrderQuantityTest_OrderItemType() {
		var mockSku = createMockSku();

		var productData = {
			productID = '',
			skus = [{
				skuID = mockSku.getSkuID(),
				skuCode = createUUID()
			}]
		};
		var mockProduct = createPersistedTestEntity('Product', productData);

		var mockOrderItemOITSale = createMockOrderItem('444df2e9a6622ad1614ea75cd5b982ce', 100, mockSku.getSkuID());
		var mockOrderItemOITReturn = createMockOrderItem('444df2eac18fa589af0f054442e12733', 100, mockSku.getSkuID());

		var mockOrder1 = createMockOrderWithOrderItems([mockOrderItemOITSale.getOrderItemID()]);

		var resultOITSale = mockOrderITemOITSale.hasQuantityWithinMinOrderQuantity();
		assertTrue(resultOITSale, 'oitSale should go into the if statements and do calculation');

		var resultOITReturn = mockOrderItemOITReturn.hasQuantityWithinMinOrderQuantity();
		assertTrue(resultOITReturn, 'For orderITem types other than oitSale, should return the TRUE after the if statements');

	}

	public void function hasQuantityWithinMinOrderQuantityTest_QuantityComparision() {
		var mockSku = createMockSku();

		var productData = {
			productID = '',
			skus = [{
				skuID = mockSku.getSkuID(),
				skuCode = createUUID()
			}]
		};
		var mockProduct = createPersistedTestEntity('Product', productData);

		var mockOrderItem1 = createMockOrderItem(quantity = 10, skuID = mockSku.getSkuID());
		var mockOrderItem2 = createMockOrderItem(quantity = 20, skuID = mockSku.getSkuID());
		var mockOrderItemSale1 = createMockOrderItem('444df2e9a6622ad1614ea75cd5b982ce', 0, mockSku.getSkuID());


		var mockOrderItem3 = createMockOrderItem(quantity = -100, skuID = mockSku.getSkuID());
		var mockOrderItemSale2 = createMockOrderItem('444df2e9a6622ad1614ea75cd5b982ce', 0, mockSku.getSkuID());



		var mockOrder1 = createMockOrderWithOrderItems([mockOrderItem1.getOrderItemID(),
														mockOrderItem2.getOrderItemID(),
														mockOrderItemSale1.getOrderItemID()]);

		var mockOrder2 = createMockOrderWithOrderItems([mockOrderItem3.getOrderItemID(),
														mockOrderItemSale2.getOrderItemID()]);

		var resultSale1 = mockOrderItemSale1.hasQuantityWithinMinOrderQuantity();
		assertTrue(resultSale1, 'The quantity of mockOrder1 should be 30 in total, which is more than 1');

		var resultSale2 = mockOrderItemSale2.hasQuantityWithinMinOrderQuantity();
		assertFalse(resultSale2, 'The quantity of mockOrder2 should be 0 in total, which is less than min, should return false');
	}

	public void function hasQuantityWithinMinOrderQuantityTest_getSkuIsNull() {
		var mockSku = createMockSku();

		var productData = {
			productID = '',
			skus = [{
				skuID = mockSku.getSkuID(),
				skuCode = createUUID()
			}]
		};
		var mockProduct = createPersistedTestEntity('Product', productData);

		var mockOrderItemRunFunction1 = createMockOrderItem('444df2e9a6622ad1614ea75cd5b982ce', 0, mockSku.getSkuID());
		var mockOrderItemRunFunction2 = createMockOrderItem('444df2e9a6622ad1614ea75cd5b982ce', 0, mockSku.getSkuID());
		var mockOrderItemNoSku 		  = createMockOrderItem(quantity = 10);

		var mockOrderHasSku 	  = createMockOrderWithOrderItems([mockOrderItemRunFunction1.getOrderItemID()]);
		var mockOrderOneSkuOneNot = createMockOrderWithOrderItems([mockOrderItemRunFunction2.getOrderItemID(),
															 	   mockOrderItemNoSku.getOrderItemID()]);

		var resultOrderHasSku = mockOrderItemRunFunction1.hasQuantityWithinMinOrderQuantity();
		assertFalse(resultOrderHasSku, '0 < defaultMin 1, should return false');

		var resultOrderOneSkuOneNot = mockOrderItemRunFunction2.hasQuantityWithinMinOrderQuantity();
		assertFalse(resultOrderOneSkuOneNot, 'quantity should still be 0, the mockOrderItemNoSku should not be added in quantity formula');
	}
}
