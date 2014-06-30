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
		variables.dao = request.slatwallScope.getDAO("promotionDAO");
		
		transaction{
			//promotion setup
			variables.promotion = variables.dao.new('promotion');
			variables.dao.save(variables.promotion);
			
			//promotion Period setup
			variables.promotionPeriod = variables.dao.new('PromotionPeriod');
			variables.dao.save(variables.promotionPeriod);
			
			//promotionCode
			variables.promotionCode = variables.dao.new('promotionCode');
			variables.dao.save(variables.promotionCode);
			
			//promotionReward
			variables.promotionReward = variables.dao.new('promotionReward');
			variables.dao.save(variables.promotionReward);
			
			//promotionApplied
			variables.promotionApplied = variables.dao.new('promotionApplied');
			variables.dao.save(variables.promotionApplied);
			
			//order
			variables.order = variables.dao.new('order');
			variables.dao.save(variables.order);
			
			//order fulfillment
			variables.orderFulfillment = variables.dao.new('orderFulfillment');
			variables.dao.save(variables.orderFulfillment);
			
			//orderItem
			variables.orderItem = variables.dao.new('orderItem');
			variables.dao.save(variables.orderItem);
			
			//product setup
			variables.product = variables.dao.new('product');
			variables.product.setProductName('TestProductName');
			variables.dao.save(variables.product);
			
			//sku setup
			variables.sku = variables.dao.new('sku');
			variables.dao.save(variables.sku);
			
			//roundingRuleSetup
			variables.roundingRule = variables.dao.new('roundingRule');
			variables.dao.save(variables.roundingRule);
		}
	}
	
	public void function tearDown(){
		//super.tearDown();
		transaction{
			variables.dao.delete(variables.promotion);
			variables.dao.delete(variables.promotionPeriod);
			variables.dao.delete(variables.promotionReward);
			variables.dao.delete(variables.promotionCode);
			variables.dao.delete(variables.promotionApplied);
			variables.dao.delete(variables.order);
			variables.dao.delete(variables.orderFulfillment);
			variables.dao.delete(variables.orderItem);
			variables.dao.delete(variables.product);
			variables.dao.delete(variables.sku);
			variables.dao.delete(variables.roundingRule);
		}
	}
	
	public void function getSalePricePromotionRewardsQueryTest(){
		//sku setup
		transaction{
			variables.product.addSku(variables.sku);
			variables.sku.setProduct(variables.product);
			variables.sku.setPrice(10);
			variables.promotionReward.addSku(variables.sku);
			variables.promotionReward.setAmount(3);
			variables.promotionReward.setRoundingRule(variables.roundingRule);
			variables.promotionReward.setAmountType('amountOff');
			variables.sku.addPromotionReward(variables.promotionReward);
			variables.promotionPeriod.addPromotionReward(variables.promotionReward);
			variables.promotionReward.setPromotionPeriod(variables.promotionPeriod);
			variables.promotion.addPromotionPeriod(variables.promotionPeriod);
			variables.promotionPeriod.setPromotion(variables.promotion);
		}
		
		var salePricePromotionRewardsQuery = variables.dao.getSalePricePromotionRewardsQuery(variables.product.getProductID());
		
		//assert amount off Price - Amount
		assertEquals(salePricePromotionRewardsQuery.SalePrice,7.00);
		
		transaction{
			variables.promotionReward.setAmountType('percentageOff');
			variables.promotionReward.setAmount(80);
		}
		
		salePricePromotionRewardsQuery = variables.dao.getSalePricePromotionRewardsQuery(variables.product.getProductID());
		
		//assert percentage off Price - Price * Amount/100
		assertEquals(salePricePromotionRewardsQuery.SalePrice,2.00);
		
		transaction{
			variables.promotionReward.setAmountType('amount');
			variables.promotionReward.setAmount(5.55);
		}
		
		salePricePromotionRewardsQuery = variables.dao.getSalePricePromotionRewardsQuery(variables.product.getProductID());
		
		//assert amount Price = Amount
		assertEquals(salePricePromotionRewardsQuery.SalePrice,5.55);
		
	}
	
	//This test is dependent on no pre-exisitng promotionReward data. All promotionReward data is generated for this test
	public void function getActivePromotionRewardsTest(){
		
		//create promotion reward data for the DAO
		transaction{
			variables.promotion.setActiveFlag(true);
			variables.promotion.addPromotionPeriod(variables.promotionPeriod);
			variables.promotionPeriod.setPromotion(variables.promotion);
			variables.promotionCode.setPromotionCode('TestPromotionCode');
			variables.promotion.addPromotionCode(variables.promotionCode);
			variables.promotionCode.setPromotion(variables.promotion);
			variables.promotionReward.setRewardType('order');
			variables.promotionReward.setPromotionPeriod(variables.promotionPeriod);
			variables.order.addPromotionCode(variables.promotionCode);
			variables.promotionCode.addOrder(variables.order);
		}
		
		promotionCodeList = variables.dao.getActivePromotionRewards(rewardTypeList="order", 
																				promotionCodeList='TestPromotionCode', 
																				qualificationRequired=true);
	
		//assert that we found our promotion reward by the promotionCode and order rewardType	
		assertEquals(arraylen(promotionCodeList),1);
		assertEquals(promotionCodeList[1].getPromotionRewardID(),variables.promotionReward.getPromotionRewardID());
		
	}
	
	public void function getPromotionPeriodUseCountTest(){
		//requires promotion period
		
		variables.promotionPeriod.setPromotion(variables.promotion);
		variables.promotion.addPromotionPeriod(variables.promotionPeriod);
		
		var PromotionPeriodCount = variables.dao.getPromotionPeriodUseCount(promotionPeriod);
		assertEquals(0,promotionPeriodCount);
		
		//promotion applied 
		transaction{
			variables.promotionApplied.setPromotion(variables.promotion);
			variables.promotion.addAppliedPromotion(variables.promotionApplied);
		}
		
		//order setup
		
		variables.order.addOrderItem(variables.orderItem);
		variables.orderItem.setOrder(variables.order);
		variables.promotionApplied.setOrderItem(variables.orderItem);
		variables.orderItem.addAppliedPromotion(variables.promotionApplied);
		
		variables.order.addOrderFulfillment(variables.orderFulfillment);
		variables.orderFulfillment.setOrder(variables.order);
		
		PromotionPeriodCount = variables.dao.getPromotionPeriodUseCount(promotionPeriod);
		//assert we were able to get our promotionPeriodUseCount
		assertEquals(1,promotionPeriodCount);
		
	}
}


