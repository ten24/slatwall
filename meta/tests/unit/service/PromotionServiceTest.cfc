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
	
}


