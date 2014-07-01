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
		makePublic(variables.service,'clearPreviouslyAppliedPromotions');
		makePublic(variables.service,'clearPreviouslyAppliedPromotionsForOrderItems');
		makePublic(variables.service,'clearPreviouslyAppliedPromotionsForOrderFulfillments');
		makePublic(variables.service,'clearPreviouslyAppliedPromotionsForOrder');
		makePublic(variables.service,'setupPromotionRewardUsageDetails');
		makePublic(variables.service,'getDiscountAmount');
		makePublic(variables.service,'applyTop1Discounts');
		makePublic(variables.service,'applyPromotionToOrderFulfillment');
		makePublic(variables.service,'applyPromotionToOrder');
	}
	
	public void function setupPromotionRewardUsageDetailsTest(){
		var promotionData = {
			activeFlag = true
		};
		var promotion = createPersistedTestEntity('promotion',promotionData);
		
		var promotionRewardData = {
			rewardType = 'order'
		};
		var promotionReward = createPersistedTestEntity('promotionReward',promotionRewardData);
		
		var promotionPeriodData = {
			promotion = promotion,
			promotionReward = promotionReward
		};
		var promotionPeriod = createPersistedTestEntity('promotionPeriod',promotionPeriodData);
		
		var promotionCodeData = {
			promotionCode = 'TestPromotionCode',
			promotion = promotion
		};
		var promotionCode = createPersistedTestEntity('promotionCode',promotionCodeData);
		
		promotion.addPromotionPeriod(promotionPeriod);
		promotion.addPromotionCode(promotionCode);
		promotionReward.setPromotionPeriod(promotionPeriod);
		ormFlush();
		
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
		var promotionAppliedToOrderItemData = {
			
		};
		var promotionAppliedToOrderItem = createPersistedTestEntity('promotionApplied',promotionAppliedToOrderItemData);
		
		var orderData = {
		};
		var order = createPersistedTestEntity('order',orderData);
		
		var orderItemData = {
			
		};
		var orderItem = createPersistedTestEntity('orderItem',orderItemData);
		
		promotionAppliedToOrderItem.setOrderItem(orderItem);
		orderItem.addAppliedPromotion(promotionAppliedToOrderItem);
		//assert that there is an appliedpromotion
		assertTrue(arraylen(orderItem.getAppliedPromotions()));
		
		//clear it
		variables.service.clearPreviouslyAppliedPromotionsForOrderItems([orderItem]);
		
		//assert that the promo was cleared		
		assertFalse(arraylen(orderItem.getAppliedPromotions()));
		
	}
	
	public void function clearPreviouslyAppliedPromotionForOrderFulfillmentsTest(){
		//data setup begin
		var promotionAppliedToOrderFulfillmentData = {
			
		};
		var promotionAppliedToOrderFulfillment = createPersistedTestEntity('promotionApplied',promotionAppliedToOrderFulfillmentData);
		
		var orderFulfillmentData = {
			
		};
		var orderFulfillment = createPersistedTestEntity('orderFulfillment',orderFulfillmentData);
		
		orderFulfillment.addAppliedPromotion(promotionAppliedToOrderFulfillment);
		promotionAppliedToOrderFulfillment.setorderFulfillment(orderFulfillment);
		//data setup end
		
		//assert that we have an applied promo to orderFulfillment
		assertTrue(arraylen(orderFulfillment.getAppliedPromotions()));
		//clear it
		variables.service.clearPreviouslyAppliedPromotionsForOrderFulfillments([orderFulfillment]);
		//assert that we have cleared the promo
		assertFalse(arraylen(orderFulfillment.getAppliedPromotions()));
		
	}
	
	public void function clearPreviouslyAppledPromotionsForOrderTest(){
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
	
	public void function getShippingMethodOptionsDiscountAmountDetailsTest(){
		//args shippingMethodOption
		//data setup begin
		var shippingMethodOptionData = {
			TotalCharge = 9.95
		};
		var shippingMethodOption = createPersistedTestEntity('shippingMethodOption',shippingMethodOptionData);
		
		var promotionCodeData = {
			promotionCode = 'TestPromotionCode'
			
		};
		var promotionCode = createPersistedTestEntity('promotionCode',promotionCodeData);
		
		var promotionRewardData = {
			rewardType = 'fulfillment',
			amountType = 'amountOff',
			amount = 3
		};
		var promotionReward = createPersistedTestEntity('promotionReward',promotionRewardData);
		
		var promotionPeriodData = {
			promotionReward = promotionReward
		};
		var promotionPeriod = createPersistedTestEntity('promotionPeriod',promotionPeriodData);
		
		var promotionData = {
			activeFlag = true,
			promotionPeriod = promotionPeriod,
			promotionCode = promotionCode
		};
		var promotion = createPersistedTestEntity('promotion',promotionData);
		
		var orderData = {
			promotionCode = promotionCode
		};
		var order = createPersistedTestEntity('order',orderData);
		
		var orderFulfillmentData = {
			
		};
		var orderFulfillment = createPersistedTestEntity('orderFulfillment',orderFulfillmentData);
		
		var fulfillmentMethodData = {
			
		};
		var fulfillmentMethod = createPersistedTestEntity('fulfillmentMethod',fulfillmentMethodData);
		
		promotionPeriod.setPromotion(promotion);
		promotionCode.setPromotion(promotion);
		promotionReward.setPromotionPeriod(promotionPeriod);
		promotionCode.addOrder(order);
		order.addOrderfulfillment(orderFulfillment);
		orderFulfillment.setOrder(order);
		orderFulfillment.setFulfillmentMethod(fulfillmentMethod);
		fulfillmentMethod.addOrderFulfillment(orderFulfillment);
		shippingMethodOption.setOrderFulfillment(orderFulfillment);
		ormflush();
		
		//data setup end
		
		var discountAmountStruct = variables.service.getShippingMethodOptionsDiscountAmountDetails(shippingMethodOption);
		
		//assert that we have a struct with the discountamount and the promotion related to it
		assertEquals(discountAmountStruct.discountAmount,3.00);
		assertEquals(discountAmountStruct.promotionID,promotion.getPromotionID());
		
	}
	
	public void function getShippingMethodOptionsDiscountAmountDetails_totalchargeLessThanReward_Test(){
		//args shippingMethodOption
		//data setup begin
		var shippingMethodOptionData = {
			TotalCharge = 1.55
		};
		var shippingMethodOption = createPersistedTestEntity('shippingMethodOption',shippingMethodOptionData);
		
		var promotionCodeData = {
			promotionCode = 'TestPromotionCode'
			
		};
		var promotionCode = createPersistedTestEntity('promotionCode',promotionCodeData);
		
		var promotionRewardData = {
			rewardType = 'fulfillment',
			amountType = 'amountOff',
			amount = 3
		};
		var promotionReward = createPersistedTestEntity('promotionReward',promotionRewardData);
		
		var promotionPeriodData = {
			promotionReward = promotionReward
		};
		var promotionPeriod = createPersistedTestEntity('promotionPeriod',promotionPeriodData);
		
		var promotionData = {
			activeFlag = true,
			promotionPeriod = promotionPeriod,
			promotionCode = promotionCode
		};
		var promotion = createPersistedTestEntity('promotion',promotionData);
		
		var orderData = {
			promotionCode = promotionCode
		};
		var order = createPersistedTestEntity('order',orderData);
		
		var orderFulfillmentData = {
			
		};
		var orderFulfillment = createPersistedTestEntity('orderFulfillment',orderFulfillmentData);
		
		var fulfillmentMethodData = {
			
		};
		var fulfillmentMethod = createPersistedTestEntity('fulfillmentMethod',fulfillmentMethodData);
		
		promotionPeriod.setPromotion(promotion);
		promotionCode.setPromotion(promotion);
		promotionReward.setPromotionPeriod(promotionPeriod);
		promotionCode.addOrder(order);
		order.addOrderfulfillment(orderFulfillment);
		orderFulfillment.setOrder(order);
		orderFulfillment.setFulfillmentMethod(fulfillmentMethod);
		fulfillmentMethod.addOrderFulfillment(orderFulfillment);
		shippingMethodOption.setOrderFulfillment(orderFulfillment);
		ormflush();
		
		//data setup end
		
		var discountAmountStruct = variables.service.getShippingMethodOptionsDiscountAmountDetails(shippingMethodOption);
		
		//assert that we have a struct with the discountamount and the promotion related to it
		assertEquals(discountAmountStruct.discountAmount,1.55);
		assertEquals(discountAmountStruct.promotionID,promotion.getPromotionID());
		
	}
	
	public void function getSalePriceDetailsForProductSkusTest(){
		//data setup begin
		var productData = {
			productName = 'TestProductName'
		};
		var product = createPersistedTestEntity('product',productData);
		
		var promotionData = {
			
		};
		var promotion = createPersistedTestEntity('promotion',promotionData);
		
		var skuData = {
			price = 10,
			product = product
		};
		var sku = createPersistedTestEntity('sku',skuData);
		
		var promotionRewardData = {
			amount = 3,
			amountType = 'amountOff',
			sku = sku
		};
		var promotionReward = createPersistedTestEntity('promotionReward',promotionRewardData);
		
		var promotionPeriodData = {
			promotion = promotion,
			promotionReward = promotionReward
		};
		var promotionPeriod = createPersistedTestEntity('promotionPeriod',promotionPeriodData);
		
		product.addSku(sku);
		sku.addPromotionReward(promotionReward);
		promotionReward.setPromotionPeriod(promotionPeriod);
		promotion.addPromotionPeriod(promotionPeriod);
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
		request.debug(priceDetails);
		
	}
	
	public void function applyTop1DiscountsTest(){
		//data setup begin
		
		var orderData = {};
		var order = createPersistedTestEntity('order',orderData);
		
		var orderItemData = {};
		var orderItem = createPersistedTestEntity('orderItem',orderItemData);
		
		var orderItemData2 = {};
		var orderItem2 = createPersistedTestEntity('orderItem',orderItemData2);
		
		var promotionData = {
			
		};
		var promotion = createPersistedTestEntity('promotion',promotionData);
		
		
		var promotionRewardData = {
			amount = 3,
			amountType = 'amountOff'
		};
		var promotionReward = createPersistedTestEntity('promotionReward',promotionRewardData);
		
		var promotionPeriodData = {
			promotion = promotion,
			promotionReward = promotionReward
		};
		var promotionPeriod = createPersistedTestEntity('promotionPeriod',promotionPeriodData);
		
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
		//data setup begin
		
		var orderData = {};
		var order = createPersistedTestEntity('order',orderData);
		
		var orderFulfillmentData = {};
		var orderFulfillment = createPersistedTestEntity('orderFulfillment',orderFulfillmentData);
		
		var promotionData = {
			
		};
		var promotion = createPersistedTestEntity('promotion',promotionData);
		
		
		var promotionRewardData = {
			amount = 3,
			amountType = 'amountOff'
		};
		var promotionReward = createPersistedTestEntity('promotionReward',promotionRewardData);
		
		var promotionPeriodData = {
			promotion = promotion,
			promotionReward = promotionReward
		};
		var promotionPeriod = createPersistedTestEntity('promotionPeriod',promotionPeriodData);
		
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
		//data setup begin
		
		var orderData = {};
		var order = createPersistedTestEntity('order',orderData);
		
		var promotionData = {
			
		};
		var promotion = createPersistedTestEntity('promotion',promotionData);
		
		
		var promotionRewardData = {
			amount = 3,
			amountType = 'amountOff'
		};
		var promotionReward = createPersistedTestEntity('promotionReward',promotionRewardData);
		
		var promotionPeriodData = {
			promotion = promotion,
			promotionReward = promotionReward
		};
		var promotionPeriod = createPersistedTestEntity('promotionPeriod',promotionPeriodData);
		
		var discountAmount = 42;
		
		//data setup end
		
		variables.service.applyPromotionToOrder(order, promotion, discountAmount);
		
		//assert order item has correct applied discount
		assertTrue(arraylen(order.getAppliedPromotions()));
		assertEquals(order.getAppliedPromotions()[1].getPromotion().getPromotionID(),promotion.getPromotionID());
		assertEquals(order.getAppliedPromotions()[1].getDiscountAmount(),42);
	}
	
}


