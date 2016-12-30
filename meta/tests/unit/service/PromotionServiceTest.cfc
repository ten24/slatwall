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
		variables.service = request.slatwallScope.getService("promotionService");
	}

	public void function shouldAddNewPromotionTest(){
		makePublic(variables.service,'shouldAddNewPromotion');

		var discountAmount = 5.55;
		var orderFulfillmentData = {
			orderFulfillmentid = ''

		};
		var orderFulfillment = createPersistedTestEntity('orderFulfillment',orderFulfillmentData);



		var promotionRewardData = {
			promotionRewardid = ''
		};
		var promotionReward = createPersistedTestEntity('promotionReward',promotionRewardData);
		var shouldAddNewPromotion = variables.service.shouldAddNewPromotion(discountAmount,orderFulfillment,promotionReward);
		//if the applied Promotion array is empty then the value is true
		assertTrue(shouldAddNewPromotion);

		var promotionAppliedData = {
			promotionAppliedid = '',
			discountAmount = 2

		};
		var promotionApplied = createPersistedTestEntity('promotionApplied',promotionAppliedData);

		var promotionData = {
			promotionid = '',
			promotionPeriods = [
				{
					promotionPeriodid = '',
					promotionRewards = [
						{
							promotionRewardid = ''
						}
					]

				}
			],
			promotionCodes = [
				{
					promotionCodeid = '',
					promotionCode = generateRandomString(20,20)
				}
			]
		};
		var promotion = createPersistedTestEntity('promotion',promotionData);

		promotionApplied.setPromotion(promotion);

		orderFulfillment.addAppliedPromotion(promotionApplied);

		var shouldAddNewPromotion2 = variables.service.shouldAddNewPromotion(discountAmount,orderFulfillment,promotion.getPromotionPeriods()[1].getPromotionRewards()[1]);
		//if orderFulfillment promotion is the same as the promotion on the promotionReward return false and setDiscount amount
		assertFalse(shouldAddNewPromotion2);
		assertEquals(5.55,orderFulfillment.getAppliedPromotions()[1].getDiscountAmount());

		var promotionData2 = {
			promotionid = '',
			promotionPeriods = [
				{
					promotionPeriodid = ''
				}
			],
			promotionCodes = [
				{
					promotionCodeid = '',
					promotionCode = generateRandomString(20,20)
				}
			]
		};
		var promotion2 = createPersistedTestEntity('promotion',promotionData2);

		promotion2.getPromotionPeriods()[1].addPromotionReward(promotionReward);
		//reset discount amount
		orderFulfillment.getAppliedPromotions()[1].setDiscountAmount(2);
		var shouldAddNewPromotion3 = variables.service.shouldAddNewPromotion(discountAmount,orderFulfillment,promotionReward);
		//if the orderfulfillment discount amount of 2 is less than the discountAmount of 5.55 and the promotion of orderfulfillment is]
		// different then the one on the promotion reward, remove the appliedPromo and return true
		assertTrue(shouldAddNewPromotion3);
		assertEquals(0,arraylen(orderFulfillment.getAppliedPromotions()));

	}

	public void function setupPromotionRewardUsageDetailsTest(){
		makePublic(variables.service,'setupPromotionRewardUsageDetails');

		var promotionData = {
			promotionid = '',
			activeFlag = true,
			promotionPeriods = [
				{
					promotionPeriodID = '',
					promotionRewards = [
						{
							promotionRewardID = '',
							rewardType = 'order'
						}
					]
				}
			],
			promotionCodes = [
				{
					promotionCodeid = '',
					promotionCode = generateRandomString(20,20)
				}
			]
		};
		var promotion = createPersistedTestEntity('promotion',promotionData);

		var promotionReward = promotion.getPromotionPeriods()[1].getPromotionRewards()[1];

		promotionRewardUsageDetails = {};

		variables.service.setupPromotionRewardUsageDetails(promotionReward,promotionRewardUsageDetails);

		//assert Defaults
		assertEquals(promotionRewardUsageDetails[promotionReward.getPromotionRewardID()].MaximumuseperItem,1000000);
		assertEquals(promotionRewardUsageDetails[promotionReward.getPromotionRewardID()].maximumUsePerOrder,1000000);
		assertEquals(promotionRewardUsageDetails[promotionReward.getPromotionRewardID()].MaximumuseperQualification,1000000);
		assertEquals(promotionRewardUsageDetails[promotionReward.getPromotionRewardID()].UsedInOrder,0);
		assertEquals(promotionRewardUsageDetails[promotionReward.getPromotionRewardID()].orderItemsUsage,[]);


		promotionReward.setMaximumUsePerItem(12);
		promotionReward.setMaximumUsePerOrder(7);
		promotionReward.setMaximumUsePerQualification(15);
		ormflush();


		promotionRewardUsageDetails2 = {};
		variables.service.setupPromotionRewardUsageDetails(promotionReward,promotionRewardUsageDetails2);

		//assert Defaults
		assertEquals(promotionRewardUsageDetails2[promotionReward.getPromotionRewardID()].MaximumuseperItem,12);
		assertEquals(promotionRewardUsageDetails2[promotionReward.getPromotionRewardID()].maximumUsePerOrder,7);
		assertEquals(promotionRewardUsageDetails2[promotionReward.getPromotionRewardID()].MaximumuseperQualification,15);
		assertEquals(promotionRewardUsageDetails2[promotionReward.getPromotionRewardID()].UsedInOrder,0);
		assertEquals(promotionRewardUsageDetails2[promotionReward.getPromotionRewardID()].orderItemsUsage,[]);

	}

	public void function clearPreviouslyAppliedPromotionsForOrderItemsTest(){
		makePublic(variables.service,'clearPreviouslyAppliedPromotionsForOrderItems');
		var orderData = {
			orderid = ''

		};
		var order = createPersistedTestEntity('order',orderData);

		var orderItemData = {

			orderItemID = '',
			appliedPromotions = [
				{
					promotionAppliedid = ''
				}
			]

		};
		var orderItem = createPersistedTestEntity('orderItem',orderItemData);
		order.addOrderItem(orderItem);
		orderItem.setOrder(order);

		var promotionAppliedToOrderItem = orderItem.getAppliedPromotions()[1];
		//assert that there is an appliedpromotion
		assertTrue(arraylen(orderItem.getAppliedPromotions()));

		//clear it
		variables.service.clearPreviouslyAppliedPromotionsForOrderItems([orderItem]);

		//assert that the promo was cleared
		assertFalse(arraylen(orderItem.getAppliedPromotions()));

	}

	public void function clearPreviouslyAppliedPromotionForOrderFulfillmentsTest(){
		makePublic(variables.service,'clearPreviouslyAppliedPromotionsForOrderFulfillments');
		//data setup begin
		var orderFulfillmentData = {
			orderFulfillmentid = '',
			appliedPromotions = [
				{
					promotionAppliedid = ''
				}
			]
		};
		var orderFulfillment = createPersistedTestEntity('orderFulfillment',orderFulfillmentData);

		var promotionAppliedToOrderFulfillment = orderFulfillment.getAppliedPromotions()[1];
		//data setup end

		//assert that we have an applied promo to orderFulfillment
		assertTrue(arraylen(orderFulfillment.getAppliedPromotions()));
		//clear it
		variables.service.clearPreviouslyAppliedPromotionsForOrderFulfillments([orderFulfillment]);
		//assert that we have cleared the promo
		assertFalse(arraylen(orderFulfillment.getAppliedPromotions()));

	}

	public void function clearPreviouslyAppledPromotionsForOrderTest(){
		makePublic(variables.service,'clearPreviouslyAppliedPromotionsForOrder');
		//data setup begin

		var promotionAppliedToOrderData = {

		};
		var promotionAppliedToOrder = createPersistedTestEntity('promotionApplied',promotionAppliedToOrderData);

		var orderData = {
		};
		var order = createPersistedTestEntity('order',orderData);

		order.addAppliedPromotion(promotionAppliedToOrder);
		promotionAppliedToOrder.setOrder(order);
		//data setup end

		//assert that we have an applied promo
		assertTrue(arraylen(order.getAppliedPromotions()));

		//clear it
		variables.service.clearPreviouslyAppliedPromotionsForOrder(order);
		//assert that we have cleared the applied promo
		assertFalse(arraylen(order.getAppliedPromotions()));
	}

	public void function getDiscountAmount_amountOff_withRoundingRule_Test(){
		makePublic(variables.service,'getDiscountAmount');
		//args promotionReward, price, quantity
		//data setup begin
		var promotionRewardData = {
			amountType = 'amountOff',
			amount = 5.55

		};
		var promotionReward = createPersistedTestEntity('promotionReward',promotionRewardData);

		var roundingRuleData = {
			roundingRuleDircetion = 'Closest',
			roundingRuleExpression = '.99'
		};
		var roundingRule = createPersistedTestEntity('roundingRule',roundingRuleData);

		promotionReward.setRoundingRule(roundingRule);

		var price = 8;
		var quantity = 7;
		//data setup end
		//amountOff discountAmount = precisionEvaluate(originalAmount - roundedFinalAmount);
		var discountAmount = variables.service.getDiscountAmount(promotionReward,price,quantity);
		assertEquals(discountAmount,39.01);
	}

	public void function getDiscountAmount_amountOff_Test(){
		makePublic(variables.service,'getDiscountAmount');
		//args promotionReward, price, quantity
		//data setup begin
		var promotionRewardData = {
			amountType = 'amountOff',
			amount = 5.55
		};
		var promotionReward = createPersistedTestEntity('promotionReward',promotionRewardData);

		var price = 8;
		var quantity = 7;
		//data setup end
		//amountOff rewardAmount * quantity
		var discountAmount = variables.service.getDiscountAmount(promotionReward,price,quantity);
		assertEquals(discountAmount,38.85);
	}

	public void function getDiscountAmount_percentageOff_Test(){
		makePublic(variables.service,'getDiscountAmount');
		//args promotionReward, price, quantity
		//data setup begin
		var promotionRewardData = {
			amountType = 'percentageOff',
			amount = 20
		};
		var promotionReward = createPersistedTestEntity('promotionReward',promotionRewardData);

		var price = 8;
		var quantity = 7;
		//data setup end
		//percentage off precisionEvaluate(originalAmount * (reward.getAmount()/100))
		var discountAmount = variables.service.getDiscountAmount(promotionReward,price,quantity);
		assertEquals(discountAmount,11.2);
	}

	public void function getDiscountAmount_amount_Test(){
		makePublic(variables.service,'getDiscountAmount');
		//args promotionReward, price, quantity
		//data setup begin
		var promotionRewardData = {
			amountType = 'amount',
			amount = 2
		};
		var promotionReward = createPersistedTestEntity('promotionReward',promotionRewardData);

		var price = 8;
		var quantity = 7;
		//data setup end
		//amount precisionEvaluate((arguments.price - reward.getAmount()) * arguments.quantity)
		var discountAmount = variables.service.getDiscountAmount(promotionReward,price,quantity);
		assertEquals(discountAmount,42);
	}

	public void function getSalePriceDetailsForProductSkusTest(){
		//data setup begin
		var productData = {
			productid = '',
			productName = 'TestProductName',
			productCode = generateRandomString(20,20),
			skus = [
				{
					skuid = '',
					skuCode=generateRandomString(20,20),
					price = 10
				}
			]
		};
		var product = createPersistedTestEntity('product',productData);

		var promotionData = {
			promotionid = '',
			promotionPeriods = [
				{
					promotionPeriodid = '',
					promotionRewards = [
						{
							promotionRewardid = '',
							amount = 3,
							amountType = 'amountOff'
						}
					]
				}

			]
		};
		var promotion = createPersistedTestEntity('promotion',promotionData);
		var sku = product.getSkus()[1];
		var promotionPeriod = promotion.getPromotionPeriods()[1];
		var promotionReward = promotionPeriod.getPromotionRewards()[1];
		sku.addPromotionReward(promotionReward);
		ormflush();
		//data setup end

		var priceDetails = variables.service.getSalePriceDetailsForProductSkus(product.getProductID());

		//assert values are correct
		assertEquals(priceDetails[sku.getSkuID()].discountlevel,'sku');
		assertEquals(priceDetails[sku.getSkuID()].originalPrice,10.00);
		assertEquals(priceDetails[sku.getSkuID()].promotionid,promotion.getPromotionID());
		assertEquals(priceDetails[sku.getSkuID()].roundingRuleid,'');
		assertEquals(priceDetails[sku.getSkuID()].salePrice,7.00);
		assertEquals(priceDetails[sku.getSkuID()].salepriceDiscountType,'amountOff');
		assertEquals(priceDetails[sku.getSkuID()].salepriceexpirationdatetime,'');

		addToDebug(priceDetails);

	}

	public void function applyTop1DiscountsTest(){
		makePublic(variables.service,'applyTop1Discounts');
		//data setup begin

		var orderData = {};
		var order = createPersistedTestEntity('order',orderData);

		var orderItemData = {};
		var orderItem = createPersistedTestEntity('orderItem',orderItemData);

		var orderItemData2 = {};
		var orderItem2 = createPersistedTestEntity('orderItem',orderItemData2);

		var promotionData = {
			promotionid = '',
			promotionPeriods = [
				{
					promotionPeriodid = '',
					promotionRewards = [
						{
							promotionRewardID = '',
							amount = 3,
							amountType = 'amountOff'
						}
					]

				}
			]
		};
		var promotion = createPersistedTestEntity('promotion',promotionData);

		var orderItemQualifiedDiscounts = {

		};

		orderItemQualifiedDiscounts[orderItem.getOrderItemID()] =
			[
				{
					discountAmount = 3,
					promotion = promotion
				},
				{
					discountAmount = 7,
					promotion = promotion
				}
			];

		order.addOrderItem(orderItem);
		orderItem.setOrder(order);
		order.addOrderItem(orderItem2);
		orderItem2.setOrder(order);
		//data setup end

		variables.service.applyTop1Discounts(order, orderItemQualifiedDiscounts);

		//assert order item has correct applied discount
		assertTrue(arraylen(orderItem.getAppliedPromotions()));
		assertEquals(orderItem.getAppliedPromotions()[1].getPromotion().getPromotionID(),promotion.getPromotionID());
		assertEquals(orderItem.getAppliedPromotions()[1].getDiscountAmount(),3);

	}

	public void function applyPromotionToOrderFulfillmentTest(){
		makePublic(variables.service,'applyPromotionToOrderFulfillment');
		//data setup begin

		var orderData = {};
		var order = createPersistedTestEntity('order',orderData);

		var orderFulfillmentData = {};
		var orderFulfillment = createPersistedTestEntity('orderFulfillment',orderFulfillmentData);

		var promotionData = {
			promotionPeriods = [
				{
					promotionPeriodid = '',
					promotionRewards = [
						{
							promotionRewardID = '',
							amount = 3,
							amountType = 'amountOff'
						}
					]
				}
			]
		};
		var promotion = createPersistedTestEntity('promotion',promotionData);

		var orderItemQualifiedDiscounts = {
		};

		var discountAmount = 4;

		order.addOrderFulfillment(orderFulfillment);
		orderFulfillment.setOrder(order);
		//data setup end

		variables.service.applyPromotionToOrderFulfillment(orderFulfillment, promotion, discountAmount);

		//assert order item has correct applied discount
		assertTrue(arraylen(orderFulfillment.getAppliedPromotions()));
		assertEquals(orderFulfillment.getAppliedPromotions()[1].getPromotion().getPromotionID(),promotion.getPromotionID());
		assertEquals(orderFulfillment.getAppliedPromotions()[1].getDiscountAmount(),4);
	}

	public void function applyPromotionToOrderTest(){
		makePublic(variables.service,'applyPromotionToOrder');
		//data setup begin

		var orderData = {};
		var order = createPersistedTestEntity('order',orderData);

		var promotionData = {
			promotionid = '',
			promotionPeriods = [
				{
					promotionPeriodid = '',
					promotionRewards = [
						{
							amount = 3,
							amountType = 'amountOff'
						}
					]
				}
			]
		};
		var promotion = createPersistedTestEntity('promotion',promotionData);

		var discountAmount = 42;

		//data setup end

		variables.service.applyPromotionToOrder(order, promotion, discountAmount);

		//assert order item has correct applied discount
		assertTrue(arraylen(order.getAppliedPromotions()));
		assertEquals(order.getAppliedPromotions()[1].getPromotion().getPromotionID(),promotion.getPromotionID());
		assertEquals(order.getAppliedPromotions()[1].getDiscountAmount(),42);
	}

	public void function removeDiscountsExceedingMaxOrderUseCountsTest(){

		MakePublic(variables.service,'removeDiscountsExceedingMaxOrderUseCounts');
		//args promotionRewardUsageDetails, orderItemQualifiedDiscounts
		//data setup begin
		var promotionData = {
			promotionid = '',
			promotionPeriods = [
				{
					promotionPeriodid = '',
					promotionRewards = [
						{
							promotionRewardID = '',
							amount = 3,
							amountType = 'amountOff'
						}
					]
				}
			]
		};
		var promotion = createPersistedTestEntity('promotion',promotionData);
		var promotionPeriod = promotion.getPromotionPeriods()[1];
		var promotionReward = promotionPeriod.getPromotionRewards()[1];

		var promotionRewardUsageDetails = {

		};

		var orderData = {};
		var order = createPersistedTestEntity('order');

		var orderItemData = {};
		var orderItem = createPersistedTestEntity('orderItem',orderItemData);

		var orderItemData2 = {};
		var orderItem2 = createPersistedTestEntity('orderItem',orderItemData2);

		// order.addOrderItem(orderItem);
		orderItem.setOrder(order);
		// order.addOrderItem(orderItem2);
		orderItem2.setOrder(order);

		promotionRewardUsageDetails[promotionReward.getPromotionRewardID()] = {
			usedInOrder = 5,
			maximumUsePerOrder = 1,
			orderItemsUsage = [
				{
					orderItemID = orderItem.getOrderItemID(),
					discountQuantity = 1
				},
				{
					orderItemID = orderItem2.getOrderItemID(),
					discountQuantity = 5
				}
			]

		};

		var orderItemQualifiedDiscounts = {

		};

		orderItemQualifiedDiscounts[orderItem.getOrderItemID()] = [
			{
				promotionRewardID = promotionReward.getPromotionRewardID(),
				discountAmount = 4.32
			}
		];

		orderItemQualifiedDiscounts[orderItem2.getOrderItemID()] = [
			{
				promotionRewardID = promotionReward.getPromotionRewardID(),
				discountAmount = 5.55
			}
		];

		//data setup end

		variables.service.removeDiscountsExceedingMaxOrderUseCounts(promotionRewardUsageDetails,orderItemQualifiedDiscounts);

		//assert that the discount was removed
		assertEquals(orderItemQualifiedDiscounts[orderItem.getOrderItemID()],[]);
		//assert discount that was calculated
		assertEquals(DecimalFormat(orderItemQualifiedDiscounts[orderItem2.getOrderItemID()][1].discountAmount),2.22);
		assertEquals(orderItemQualifiedDiscounts[orderItem2.getOrderItemID()][1].promotionRewardID,promotionReward.getPromotionRewardID());
	}

	public void function getQualifierQualificationDetailsForOrderTest(){
		makePublic(variables.service,'getQualifierQualificationDetailsForOrder');
		//args qualifier,order
		//data setup begin
		var orderData = {

		};
		var order = createPersistedTestEntity('order',orderData);

		var promotionQualifierData = {
			promotionQualifierid = '',
			QualifierType = 'order'
		};
		var promotionQualifier = createPersistedTestEntity('promotionQualifier',promotionQualifierData);

		var qualifierDetails = {
			qualifier = promotionQualifier,
			qualificationCount = 0,
			qualifiedFulfillmentIDs = [],
			qualifiedOrderItemDetails = []
		};

		//data setup end

		variables.service.getQualifierQualificationDetailsForOrder(promotionQualifier,order,qualifierDetails);
		assertEquals(qualifierDetails.qualificationCount,1);

		promotionQualifier.setMinimumOrderQuantity(2);
		promotionQualifier.setMaximumOrderQuantity(-1);
		promotionQualifier.setMinimumOrderSubtotal(2);
		promotionQualifier.setMaximumOrderSubtotal(-1);

		variables.service.getQualifierQualificationDetailsForOrder(promotionQualifier,order,qualifierDetails);

		assertEquals(qualifierDetails.qualificationCount,0);

	}

	public void function getQualifierQualificationDetailsForOrderFulfillmentsTest(){
		makePublic(variables.service,'getQualifierQualificationDetailsForOrderFulfillments');
		//args qualifier,order, qualifierDetails
		//data setup begin
		var orderData = {

		};
		var order = createPersistedTestEntity('order',orderData);

		var orderFulfillmentData = {
		};
		var orderFulfillment = createPersistedTestEntity('orderFulfillment',orderFulfillmentData);

		var promotionQualifierData = {
			QualifierType = 'orderFulfillment'
		};
		var promotionQualifier = createPersistedTestEntity('promotionQualifier',promotionQualifierData);
		/* TODO: test addressZones
		var addressZoneData = {};
		var addressZone = createPersistedTestEntity('addressZone',addressZoneData);
		*/
		var qualifierDetails = {
			qualifier = promotionQualifier,
			qualificationCount = 0,
			qualifiedFulfillmentIDs = [],
			qualifiedOrderItemDetails = []
		};

		order.addOrderFulfillment(orderFulfillment);
		orderFulfillment.setOrder(order);

		//data setup end

		variables.service.getQualifierQualificationDetailsForOrderFulfillments(promotionQualifier,order,qualifierDetails);

		assertEquals(qualifierDetails.qualificationCount,1);
		assertEquals(qualifierDetails.qualifiedFulfillmentids[1],orderFulfillment.getOrderFulfillmentID());

	}

	public void function getQualifierQualificationDetailsForOrderItemsTest(){

		makePublic(variables.service,'getQualifierQualificationDetailsForOrderItems');
		//args qualifier,order, qualifierDetails
		//data setup begin
		var orderData = {

		};
		var order = createPersistedTestEntity('order',orderData);

		var orderFulfillmentData = {
		};
		var orderFulfillment = createPersistedTestEntity('orderFulfillment',orderFulfillmentData);

		var orderItemData = {

			quantity = 5
		};
		var orderItem = createPersistedTestEntity('orderItem',orderItemData);

		var promotionQualifierData = {
			QualifierType = 'contentAccess'
		};
		var promotionQualifier = createPersistedTestEntity('promotionQualifier',promotionQualifierData);

		var productData = {
			productName = 'TestProductName',
			productCode=generateRandomString(20,20),
			skus = [
				{
					skuid = '',
					skuCode=generateRandomString(20,20)
				}
			],
			productType = {
				productTypeid = ''
			}
		};
		var product = createPersistedTestEntity('product',productData);
		var sku = product.getSkus()[1];
		var productType = product.getProductType();

		var brandData = {};
		var brand = createPersistedTestEntity('brand',brandData);

		var qualifierDetails = {
			qualifier = promotionQualifier,
			qualificationCount = 0,
			qualifiedFulfillmentIDs = [],
			qualifiedOrderItemDetails = []
		};

		orderItem.setSku(sku);
		sku.addOrderItem(orderItem);

		orderItem.setOrder(order);
		order.addOrderItem(orderItem);

		promotionQualifier.addsku(sku);
		//data setup end

		variables.service.getQualifierQualificationDetailsForOrderItems(promotionQualifier,order,qualifierDetails);

		//assert values
		assertEquals(qualifierDetails.qualificationCount,1);
		assertEquals(qualifierDetails.qualifiedOrderItemDetails[1].orderItem.getOrderItemID(),orderItem.getOrderItemID());
		assertEquals(qualifierDetails.qualifiedOrderItemDetails[1].qualificationCount,5);
	}

	//getOrderItemInQualifierTests
	//inclusions
	public void function getOrderItemInQualifier_checkInclusions_hasProduct_Test(){
		//args qualifier, orderItem
		//returns boolean
		//data setup begin
		var orderItemData = {
		};
		var orderItem = createPersistedTestEntity('orderItem',orderItemData);

		var promotionQualifierData = {};
		var promotionQualifier = createPersistedTestEntity('promotionQualifier',promotionQualifierData);

		var productData = {
			productID = '',
			productName = 'TestProductName',
			productCode = generateRandomString(20,20),
			skus = [
				{
					skuid = '',
					skuCode=generateRandomString(20,20)
				}
			],
			productType = {
				productTypeid = ''
			}
		};
		var product = createPersistedTestEntity('product',productData);

		var sku = product.getSkus()[1];

		orderItem.setSku(sku);
		sku.addOrderItem(orderItem);

		promotionQualifier.addProduct(product);

		//data setup end

		var isOrderItemInQualifier = variables.service.getOrderItemInQualifier(promotionQualifier,orderItem);
		assertTrue(isOrderItemInQualifier);
	}

	public void function getOrderItemInQualifier_checkInclusions_hasSku_Test(){
		//args qualifier, orderItem
		//returns boolean
		//data setup begin
		var orderItemData = {
		};
		var orderItem = createPersistedTestEntity('orderItem',orderItemData);

		var promotionQualifierData = {};
		var promotionQualifier = createPersistedTestEntity('promotionQualifier',promotionQualifierData);

		var productData = {
			productID = '',
			productName = 'TestProductName',
			productCode = generateRandomString(20,20),
			skus = [
				{
					skuid = '',
					skuCode = generateRandomString(20,20)
				}
			],
			productType = {
				productTypeid = ''
			}
		};
		var product = createPersistedTestEntity('product',productData);
		var sku = product.getSkus()[1];

		orderItem.setSku(sku);
		sku.addOrderItem(orderItem);

		promotionQualifier.addSku(sku);

		//data setup end

		var isOrderItemInQualifier = variables.service.getOrderItemInQualifier(promotionQualifier,orderItem);
		assertTrue(isOrderItemInQualifier);
	}

	public void function getOrderItemInQualifier_checkInclusions_hasBrand_Test(){
		//args qualifier, orderItem
		//returns boolean
		//data setup begin
		var orderItemData = {
		};
		var orderItem = createPersistedTestEntity('orderItem',orderItemData);

		var promotionQualifierData = {};
		var promotionQualifier = createPersistedTestEntity('promotionQualifier',promotionQualifierData);

		var brandData = {};
		var brand = createPersistedTestEntity('brand',brandData);

		var productData = {
			productName = 'TestProductName',
			productCode = generateRandomString(20,20),
			skus = [
				{
					skuid = '',
					skuCode=generateRandomString(20,20)
				}
			],
			productType = {
				productTypeid = ''
			}
		};

		var product = createPersistedTestEntity('product',productData);

		product.setBrand(brand);
		var sku = product.getSkus()[1];
		var brand = product.getBrand();

		orderItem.setSku(sku);
		sku.addOrderItem(orderItem);

		promotionQualifier.addBrand(brand);
		//data setup end

		var isOrderItemInQualifier = variables.service.getOrderItemInQualifier(promotionQualifier,orderItem);
		assertTrue(isOrderItemInQualifier);
	}

	public void function getOrderItemInQualifier_checkInclusions_hasAnyOption_Test(){
		//args qualifier, orderItem
		//returns boolean
		//data setup begin
		var orderItemData = {
		};
		var orderItem = createPersistedTestEntity('orderItem',orderItemData);

		var promotionQualifierData = {};
		var promotionQualifier = createPersistedTestEntity('promotionQualifier',promotionQualifierData);

		var productData = {
			productID = '',
			productName = 'TestProductName',
			productCode = generateRandomString(20,20),
			skus = [
				{
					skuid = '',
					skuCode = generateRandomString(20,20)
				}
			],
			productType = {
				productTypeid = ''
			}
		};
		var product = createPersistedTestEntity('product',productData);
		var sku = product.getSkus()[1];
		var optionData = {};
		var option = createPersistedTestEntity('option',optionData);

		orderItem.setSku(sku);
		sku.addOrderItem(orderItem);

		sku.addOption(option);
		option.addSku(sku);

		promotionQualifier.addOption(option);

		//data setup end

		var isOrderItemInQualifier = variables.service.getOrderItemInQualifier(promotionQualifier,orderItem);
		assertTrue(isOrderItemInQualifier);
	}

	//exclusions

	public void function getOrderItemInQualifier_hasExcludedProductType_Test(){
		//args qualifier, orderItem
		//returns boolean
		//data setup begin
		var orderItemData = {
			price = 1
		};
		var orderItem = createPersistedTestEntity('orderItem',orderItemData);

		var promotionQualifierData = {};
		var promotionQualifier = createPersistedTestEntity('promotionQualifier',promotionQualifierData);

		var productTypeData = {
		};
		var productType = createPersistedTestEntity('productType',productTypeData);

		var skuData = {
			skuid='',
			skuCOde=generateRandomString(20,20)
		};
		var sku = createPersistedTestEntity('sku',skuData);

		var productData = {
			productid='',
			productCode=generateRandomString(20,20),
			productName = 'TestProductName'
		};
		var product = createPersistedTestEntity('product',productData);

		var brandData = {};
		var brand = createPersistedTestEntity('brand',brandData);

		orderItem.setSku(sku);
		sku.addOrderItem(orderItem);

		sku.setProduct(product);
		product.addsku(sku);

		product.setProductType(productType);
		productType.addProduct(product);

		promotionQualifier.addExcludedProductType(productType);
		promotionQualifier.addSku(sku);
		//data setup end

		var isOrderItemInQualifier = variables.service.getOrderItemInQualifier(promotionQualifier,orderItem);
		assertFalse(isOrderItemInQualifier);

	}

	public void function getOrderItemInQualifier_hasExcludedMinimumItemPriceGreaterThanPrice_Test(){
		//args qualifier, orderItem
		//returns boolean
		//data setup begin
		var orderItemData = {
			price = 1
		};
		var orderItem = createPersistedTestEntity('orderItem',orderItemData);

		var promotionQualifierData = {};
		var promotionQualifier = createPersistedTestEntity('promotionQualifier',promotionQualifierData);

		var productTypeData = {
		};
		var productType = createPersistedTestEntity('productType',productTypeData);

		var skuData = {
			skuid='',
			skuCode=generateRandomString(20,20)

		};
		var sku = createPersistedTestEntity('sku',skuData);

		var productData = {
			productid = '',
			productCode=generateRandomString(20,20),
			productName = 'TestProductName'
		};
		var product = createPersistedTestEntity('product',productData);

		var brandData = {};
		var brand = createPersistedTestEntity('brand',brandData);
		promotionQualifier.addSku(sku);
		promotionQualifier.setMinimumItemPrice(2);
		//data setup end

		var isOrderItemInQualifier = variables.service.getOrderItemInQualifier(promotionQualifier,orderItem);
		assertFalse(isOrderItemInQualifier);
	}

	public void function getOrderItemInQualifier_hasExcludedMaximumItemPriceLessThanPrice_Test(){
		//args qualifier, orderItem
		//returns boolean
		//data setup begin
		var orderItemData = {
			price = 1
		};
		var orderItem = createPersistedTestEntity('orderItem',orderItemData);

		var promotionQualifierData = {};
		var promotionQualifier = createPersistedTestEntity('promotionQualifier',promotionQualifierData);

		var productTypeData = {
		};
		var productType = createPersistedTestEntity('productType',productTypeData);

		var skuData = {
			skuid='',
			skuCode=generateRandomString(20,20)
		};
		var sku = createPersistedTestEntity('sku',skuData);

		var productData = {
			productid='',
			productName = 'TestProductName',
			productCode=generateRandomString(20,20)
		};
		var product = createPersistedTestEntity('product',productData);

		var brandData = {};
		var brand = createPersistedTestEntity('brand',brandData);
		promotionQualifier.addSku(sku);
		promotionQualifier.setMaximumItemPrice(0);
		//data setup end

		var isOrderItemInQualifier = variables.service.getOrderItemInQualifier(promotionQualifier,orderItem);
		assertFalse(isOrderItemInQualifier);
	}

	public void function getOrderItemInQualifier_hasExcludedProduct_Test(){
		//args qualifier, orderItem
		//returns boolean
		//data setup begin
		var orderItemData = {
			price = 1
		};
		var orderItem = createPersistedTestEntity('orderItem',orderItemData);

		var promotionQualifierData = {};
		var promotionQualifier = createPersistedTestEntity('promotionQualifier',promotionQualifierData);

		var productTypeData = {
		};
		var productType = createPersistedTestEntity('productType',productTypeData);

		var skuData = {
			skuid='',
			skuCOde=generateRandomString(20,20)
		};
		var sku = createPersistedTestEntity('sku',skuData);

		var productData = {
			productid='',
			productCode=generateRandomString(20,20),
			productName = 'TestProductName'
		};
		var product = createPersistedTestEntity('product',productData);

		product.addSku(sku);
		sku.setProduct(product);

		orderItem.setSku(sku);
		sku.addOrderItem(orderItem);

		promotionQualifier.addSku(sku);
		promotionQualifier.addExcludedProduct(product);
		//data setup end

		var isOrderItemInQualifier = variables.service.getOrderItemInQualifier(promotionQualifier,orderItem);
		assertFalse(isOrderItemInQualifier);
	}

	public void function getOrderItemInQualifier_hasExcludedBrand_Test(){
		//args qualifier, orderItem
		//returns boolean
		//data setup begin
		var orderItemData = {
			price = 1
		};
		var orderItem = createPersistedTestEntity('orderItem',orderItemData);

		var promotionQualifierData = {};
		var promotionQualifier = createPersistedTestEntity('promotionQualifier',promotionQualifierData);

		var productTypeData = {
		};
		var productType = createPersistedTestEntity('productType',productTypeData);

		var skuData = {
			skuid='',
			skuCode=generateRandomString(20,20)
		};
		var sku = createPersistedTestEntity('sku',skuData);

		var productData = {
			productId = '',
			productCode = generateRandomString(20,20),
			productName = 'TestProductName'
		};
		var product = createPersistedTestEntity('product',productData);

		var brandData = {};
		var brand = createPersistedTestEntity('brand',brandData);

		product.addSku(sku);
		sku.setProduct(product);

		orderItem.setSku(sku);
		sku.addOrderItem(orderItem);
		product.setBrand(brand);
		brand.addProduct(product);

		promotionQualifier.addSku(sku);
		promotionQualifier.addExcludedBrand(brand);
		//data setup end

		var isOrderItemInQualifier = variables.service.getOrderItemInQualifier(promotionQualifier,orderItem);
		assertFalse(isOrderItemInQualifier);
	}

	public void function getOrderItemInQualifier_hasExcludedOption_Test(){
		//args qualifier, orderItem
		//returns boolean
		//data setup begin
		var orderItemData = {
			price = 1
		};
		var orderItem = createPersistedTestEntity('orderItem',orderItemData);

		var promotionQualifierData = {};
		var promotionQualifier = createPersistedTestEntity('promotionQualifier',promotionQualifierData);

		var productTypeData = {
		};
		var productType = createPersistedTestEntity('productType',productTypeData);

		var skuData = {
			skuid='',
			skuCode=generateRandomString(20,20)
		};
		var sku = createPersistedTestEntity('sku',skuData);

		var productData = {
			productid='',
			productCode=generateRandomString(20,20),
			productName = 'TestProductName'
		};
		var product = createPersistedTestEntity('product',productData);

		var optionData = {};
		var option = createPersistedTestEntity('option',optionData);

		product.addSku(sku);
		sku.setProduct(product);

		orderItem.setSku(sku);
		sku.addOrderItem(orderItem);
		sku.addOption(option);
		option.addSku(sku);

		promotionQualifier.addSku(sku);
		promotionQualifier.addExcludedOption(option);
		//data setup end

		var isOrderItemInQualifier = variables.service.getOrderItemInQualifier(promotionQualifier,orderItem);
		assertFalse(isOrderItemInQualifier);
	}

	//getOrderItemInReward Tests

	//inclusions
	public void function getOrderItemInReward_checkInclusions_hasProduct_Test(){
		//args Reward, orderItem
		//returns boolean
		//data setup begin
		var orderItemData = {
		};
		var orderItem = createPersistedTestEntity('orderItem',orderItemData);

		var promotionRewardData = {};
		var promotionReward = createPersistedTestEntity('promotionReward',promotionRewardData);

		var productTypeData = {
		};
		var productType = createPersistedTestEntity('productType',productTypeData);

		var skuData = {
			skuid='',
			skuCode=generateRandomString(20,20)
		};
		var sku = createPersistedTestEntity('sku',skuData);

		var productData = {
			productid='',
			productCode=generateRandomString(20,20),
			productName = 'TestProductName'
		};
		var product = createPersistedTestEntity('product',productData);

		var brandData = {};
		var brand = createPersistedTestEntity('brand',brandData);

		orderItem.setSku(sku);
		sku.addOrderItem(orderItem);

		sku.setProduct(product);
		product.addsku(sku);

		product.setProductType(productType);
		productType.addProduct(product);

		promotionReward.addProduct(product);

		//data setup end

		var isOrderItemInReward = variables.service.getOrderItemInReward(promotionReward,orderItem);
		assertTrue(isOrderItemInReward);
	}

	public void function getOrderItemInReward_checkInclusions_hasSku_Test(){
		//args Reward, orderItem
		//returns boolean
		//data setup begin
		var orderItemData = {
		};
		var orderItem = createPersistedTestEntity('orderItem',orderItemData);

		var promotionRewardData = {};
		var promotionReward = createPersistedTestEntity('promotionReward',promotionRewardData);

		var productTypeData = {
		};
		var productType = createPersistedTestEntity('productType',productTypeData);

		var skuData = {
			skuid='',
			skuCode=generateRandomString(20,20)
		};
		var sku = createPersistedTestEntity('sku',skuData);

		var productData = {
			productid='',
			productCode=generateRandomString(20,20),
			productName = 'TestProductName'
		};
		var product = createPersistedTestEntity('product',productData);

		var brandData = {};
		var brand = createPersistedTestEntity('brand',brandData);

		orderItem.setSku(sku);
		sku.addOrderItem(orderItem);

		sku.setProduct(product);
		product.addsku(sku);

		product.setProductType(productType);
		productType.addProduct(product);

		promotionReward.addSku(sku);

		//data setup end

		var isOrderItemInReward = variables.service.getOrderItemInReward(promotionReward,orderItem);
		assertTrue(isOrderItemInReward);
	}

	public void function getOrderItemInReward_checkInclusions_hasBrand_Test(){
		//args Reward, orderItem
		//returns boolean
		//data setup begin
		var orderItemData = {
		};
		var orderItem = createPersistedTestEntity('orderItem',orderItemData);

		var promotionRewardData = {};
		var promotionReward = createPersistedTestEntity('promotionReward',promotionRewardData);

		var productTypeData = {
		};
		var productType = createPersistedTestEntity('productType',productTypeData);

		var skuData = {
			skuid='',
			skuCode=generateRandomString(20,20)
		};
		var sku = createPersistedTestEntity('sku',skuData);

		var productData = {
			productID = '',
			productName = 'TestProductName',
			productCode = generateRandomString(20,20)
		};
		var product = createPersistedTestEntity('product',productData);

		var brandData = {};
		var brand = createPersistedTestEntity('brand',brandData);

		orderItem.setSku(sku);
		sku.addOrderItem(orderItem);

		sku.setProduct(product);
		product.addsku(sku);

		product.setProductType(productType);
		productType.addProduct(product);

		product.setBrand(brand);
		brand.addProduct(product);

		promotionReward.addBrand(brand);
		//data setup end

		var isOrderItemInReward = variables.service.getOrderItemInReward(promotionReward,orderItem);
		assertTrue(isOrderItemInReward);
	}

	public void function getOrderItemInReward_checkInclusions_hasAnyOption_Test(){
		//args Reward, orderItem
		//returns boolean
		//data setup begin
		var orderItemData = {
		};
		var orderItem = createPersistedTestEntity('orderItem',orderItemData);

		var promotionRewardData = {};
		var promotionReward = createPersistedTestEntity('promotionReward',promotionRewardData);

		var productTypeData = {
		};
		var productType = createPersistedTestEntity('productType',productTypeData);

		var skuData = {
			skuid='',
			skuCode=generateRandomString(20,20)
		};
		var sku = createPersistedTestEntity('sku',skuData);

		var productData = {
			productid='',
			productCode=generateRandomString(20,20),
			productName = 'TestProductName'
		};
		var product = createPersistedTestEntity('product',productData);

		var optionData = {};
		var option = createPersistedTestEntity('option',optionData);

		orderItem.setSku(sku);
		sku.addOrderItem(orderItem);

		sku.setProduct(product);
		product.addsku(sku);

		product.setProductType(productType);
		productType.addProduct(product);

		sku.addOption(option);
		option.addSku(sku);

		promotionReward.addOption(option);

		//data setup end

		var isOrderItemInReward = variables.service.getOrderItemInReward(promotionReward,orderItem);
		assertTrue(isOrderItemInReward);
	}

	//exclusions

	public void function getOrderItemInReward_hasExcludedProductType_Test(){
		//args Reward, orderItem
		//returns boolean
		//data setup begin
		var orderItemData = {
			price = 1
		};
		var orderItem = createPersistedTestEntity('orderItem',orderItemData);

		var promotionRewardData = {};
		var promotionReward = createPersistedTestEntity('promotionReward',promotionRewardData);

		var productTypeData = {
		};
		var productType = createPersistedTestEntity('productType',productTypeData);

		var skuData = {
			skuid='',
			skuCode=generateRandomString(20,20)
		};
		var sku = createPersistedTestEntity('sku',skuData);

		var productData = {
			productName = 'TestProductName',
			productid='',
			productCode=generateRandomString(20,20)
		};
		var product = createPersistedTestEntity('product',productData);

		var brandData = {};
		var brand = createPersistedTestEntity('brand',brandData);

		orderItem.setSku(sku);
		sku.addOrderItem(orderItem);

		sku.setProduct(product);
		product.addsku(sku);

		product.setProductType(productType);
		productType.addProduct(product);

		promotionReward.addExcludedProductType(productType);
		promotionReward.addSku(sku);
		//data setup end

		var isOrderItemInReward = variables.service.getOrderItemInReward(promotionReward,orderItem);
		assertFalse(isOrderItemInReward);

	}

	public void function getOrderItemInReward_hasExcludedProduct_Test(){
		//args Reward, orderItem
		//returns boolean
		//data setup begin
		var orderItemData = {
			price = 1
		};
		var orderItem = createPersistedTestEntity('orderItem',orderItemData);

		var promotionRewardData = {};
		var promotionReward = createPersistedTestEntity('promotionReward',promotionRewardData);

		var productTypeData = {
		};
		var productType = createPersistedTestEntity('productType',productTypeData);

		var skuData = {
			skuid='',
			skuCode=generateRandomString(20,20)
		};
		var sku = createPersistedTestEntity('sku',skuData);

		var productData = {
			productName = 'TestProductName',
			productid='',
			productCode=generateRandomString(20,20)
		};
		var product = createPersistedTestEntity('product',productData);

		product.addSku(sku);
		sku.setProduct(product);

		orderItem.setSku(sku);
		sku.addOrderItem(orderItem);

		promotionReward.addSku(sku);
		promotionReward.addExcludedProduct(product);
		//data setup end

		var isOrderItemInReward = variables.service.getOrderItemInReward(promotionReward,orderItem);
		assertFalse(isOrderItemInReward);
	}

	public void function getOrderItemInReward_hasExcludedBrand_Test(){
		//args Reward, orderItem
		//returns boolean
		//data setup begin
		var orderItemData = {
			price = 1
		};
		var orderItem = createPersistedTestEntity('orderItem',orderItemData);

		var promotionRewardData = {};
		var promotionReward = createPersistedTestEntity('promotionReward',promotionRewardData);

		var productTypeData = {
		};
		var productType = createPersistedTestEntity('productType',productTypeData);

		var skuData = {
			skuid='',
			skuCode=generateRandomString(20,20)
		};
		var sku = createPersistedTestEntity('sku',skuData);

		var productData = {
			productid='',
			productCode=generateRandomString(20,20),
			productName = 'TestProductName'
		};
		var product = createPersistedTestEntity('product',productData);

		var brandData = {};
		var brand = createPersistedTestEntity('brand',brandData);

		product.addSku(sku);
		sku.setProduct(product);

		orderItem.setSku(sku);
		sku.addOrderItem(orderItem);
		product.setBrand(brand);
		brand.addProduct(product);

		promotionReward.addSku(sku);
		promotionReward.addExcludedBrand(brand);
		//data setup end

		var isOrderItemInReward = variables.service.getOrderItemInReward(promotionReward,orderItem);
		assertFalse(isOrderItemInReward);
	}

	public void function getOrderItemInReward_hasExcludedOption_Test(){
		//args Reward, orderItem
		//returns boolean
		//data setup begin
		var orderItemData = {
			price = 1
		};
		var orderItem = createPersistedTestEntity('orderItem',orderItemData);

		var promotionRewardData = {};
		var promotionReward = createPersistedTestEntity('promotionReward',promotionRewardData);

		var productTypeData = {
		};
		var productType = createPersistedTestEntity('productType',productTypeData);

		var skuData = {
			skuid='',
			skuCode=generateRandomString(20,20)
		};
		var sku = createPersistedTestEntity('sku',skuData);

		var productData = {
			productid='',
			productCode=generateRandomString(20,20),
			productName = 'TestProductName'
		};
		var product = createPersistedTestEntity('product',productData);

		var optionData = {};
		var option = createPersistedTestEntity('option',optionData);

		product.addSku(sku);
		sku.setProduct(product);

		orderItem.setSku(sku);
		sku.addOrderItem(orderItem);
		sku.addOption(option);
		option.addSku(sku);

		promotionReward.addSku(sku);
		promotionReward.addExcludedOption(option);
		//data setup end

		var isOrderItemInReward = variables.service.getOrderItemInReward(promotionReward,orderItem);
		assertFalse(isOrderItemInReward);
	}

	public void function getPromotionPeriodQualifiedFulfillmentIDListTest(){
		makePublic(variables.service,'getPromotionPeriodQualifiedFulfillmentIDList');
		//args promotionPeriod, order
		//data setup begin
		var promotionPeriodData = {
			promotionPeriodid = '',
			promotionRewards = [
				{
					promotionRewardid = ''

				}
			],
			promotionQualifiers = [
				{
					promotionQualifierid = '',
					qualifierType = 'fulfillment'
				}
			]
		};
		var promotionPeriod = createPersistedTestEntity('promotionPeriod',promotionPeriodData);

		var orderData = {};
		var order = createPersistedTestEntity('order',orderData);

		var orderFulfillmentData = {
			totalShippingWeight = 4
		};
		var orderFulfillment = createPersistedTestEntity('orderFulfillment',orderFulfillmentData);

		var orderFulfillmentData2 = {
			totalShippingWeight = 44
		};
		var orderFulfillment2 = createPersistedTestEntity('orderFulfillment',orderFulfillmentData2);

		order.addOrderFulfillment(orderFulfillment);
		orderFulfillment.setOrder(order);
		order.addOrderFulfillment(orderFulfillment2);
		orderFulfillment2.setOrder(order);
		//data setup end

		var QualifiedFulfillmentIDList = variables.service.getPromotionPeriodQualifiedFulfillmentIDList(promotionPeriod,order);

		assertEquals(ListLen(QualifiedFulfillmentIDList),2);

		var promotionQualifier = promotionPeriod.getPromotionQualifiers()[1];
		promotionQualifier.setMinimumFulfillmentWeight(7);
		QualifiedFulfillmentIDList = variables.service.getPromotionPeriodQualifiedFulfillmentIDList(promotionPeriod,order);
		assertEquals(listLen(QualifiedFulfillmentIDList),0);
	}

	public void function getPromotionPeriodOrderItemQualificationCountTest(){
		makePublic(variables.service,'getPromotionPeriodOrderItemQualificationCount');
		//args pormotionPeriod, orderItem,order
		//data setup begin

		var promotionPeriodData = {
			promotionPeriodid = '',
			promotionRewards = [
				{
					promotionRewardid = ''

				}
			],
			promotionQualifiers = [
				{
					promotionQualifierid = '',
					qualifierType = 'merchandise'
				}
			]
		};
		var promotionPeriod = createPersistedTestEntity('promotionPeriod',promotionPeriodData);

		var orderData = {
		};
		var order = createPersistedTestEntity('order',orderData);

		var orderItemData = {
			quantity = 7
		};
		var orderItem = createPersistedTestEntity('orderItem',orderItemData);

		var productData = {
			productName = 'TestProductName',
			productCode = generateRandomString(20,20),
			skus = [
				{
					skuid = '',
					skuCode=generateRandomString(20,20)
				}
			],
			productType = {
				productTypeid = ''
			}
		};
		var product = createPersistedTestEntity('product',productData);

		var sku = product.getSkus()[1];

		orderItem.setSku(sku);
		sku.addOrderItem(orderItem);

		var promotionQualifier = promotionPeriod.getPromotionQualifiers()[1];

		var orderItemQualificationCount = variables.service.getPromotionPeriodOrderItemQualificationCount(promotionPeriod,orderItem,order);

		assertEquals(orderItemQualificationCount,0);

		order.addOrderItem(orderItem);
		orderItem.setOrder(order);
		promotionQualifier.addProduct(product);
		//data setup end

		orderItemQualificationCount = variables.service.getPromotionPeriodOrderItemQualificationCount(promotionPeriod,orderItem,order);
		assertEquals(orderItemQualificationCount,7);
	}
}


