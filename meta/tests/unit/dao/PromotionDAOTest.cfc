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
	}
	 
	public void function getSalePricePromotionRewardsQueryTest(){
		var productData = {
			productID = '',
			productName = 'Test Product Name',
			productCode = #getTickCount()#,
			skus = [
				{
					skuID = '',
					price = 10
				}
			]
		};
		
		var product = createPersistedTestEntity('Product', productData);
		var sku = product.getSkus()[1];
		
		var promotionData = {
			promotionPeriods = [
				{
					promotionPeriodID = '',
					promotionRewards = [
						{
							promotionRewardID='',
							amount = 3,
							amountType = 'amountOff',
							skus = sku.getSkuID()
						}
					]
				}
			]
		};
		
		var promotion = createPersistedTestEntity( 'Promotion' , promotionData);
		var promotionPeriod = promotion.getPromotionPeriods()[1];
		var promotionReward = promotionPeriod.getPromotionRewards()[1];
			
		var salePricePromotionRewardsQuery = variables.dao.getSalePricePromotionRewardsQuery( product.getProductID() );
		
		//assert amount off Price - Amount
		assertEquals(salePricePromotionRewardsQuery.SalePrice, 7.00);
		
		//assert percentage off Price - Price * Amount/100
		promotionReward.setAmountType('percentageOff');
		promotionReward.setAmount(80);
		
		ormflush();
		
		var salePricePromotionRewardsQuery2 = variables.dao.getSalePricePromotionRewardsQuery(product.getProductID());
		
		assertEquals(salePricePromotionRewardsQuery2.SalePrice,2.00);
		
		//assert amount Price = Amount
		promotionReward.setAmountType('amount');
		promotionReward.setAmount(5.55);
		
		ormflush();
		
		salePricePromotionRewardsQuery = variables.dao.getSalePricePromotionRewardsQuery(product.getProductID());
		
		assertEquals(salePricePromotionRewardsQuery.SalePrice,5.55);

	}
	
	//This test is dependent on no pre-exisitng promotionReward data. All promotionReward data is generated for this test
	public void function getActivePromotionRewardsTest(){
		
		//create promotion reward data for the DAO
		
		var promotionCodeData = {
			promotionCode = 'TestPromotionCode'
		};
		var promotionCode = createPersistedTestEntity('promotionCode',promotionCodeData);
		
		var promotionRewardData = {
			rewardType = 'order'
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
		
		promotionPeriod.setPromotion(promotion);
		promotionCode.setPromotion(promotion);
		promotionReward.setPromotionPeriod(promotionPeriod);
		promotionCode.addOrder(order);
		ormflush();
		
		promotionCodeList = variables.dao.getActivePromotionRewards(rewardTypeList="order", 
																				promotionCodeList='TestPromotionCode', 
																				qualificationRequired=true);
	
		//assert that we found our promotion reward by the promotionCode and order rewardType	
		assertEquals(arraylen(promotionCodeList),1);
		assertEquals(promotionCodeList[1].getPromotionRewardID(),promotionReward.getPromotionRewardID());
		
	}
	
	public void function getPromotionPeriodUseCountTest(){
		//requires promotion period
		
		var promotionData = {

		};
		var promotion = createPersistedTestEntity('promotion',promotionData);
		
		var promotionPeriodData = {
			promotion=promotion
		};
		var promotionPeriod = createPersistedTestEntity('promotionPeriod',promotionPeriodData);
		
		promotion.addPromotionPeriod(promotionPeriod);
		
		var PromotionPeriodCount = variables.dao.getPromotionPeriodUseCount(promotionPeriod);
		assertEquals(0,promotionPeriodCount);
		
		var promotionAppliedData = {
			promotion = promotion
		};
		var promotionApplied = createPersistedTestEntity('promotionApplied',promotionAppliedData);
		
		//promotion applied 
		promotion.addAppliedPromotion(promotionApplied);
		ormflush();
		
		//order setup
		var orderData = {
			promotion = promotion
		};
		var order = createPersistedTestEntity('order',orderData);
		
		var orderItemData = {
			order = order,
			promotionApplied = promotionApplied
		};
		var orderItem = createPersistedTestEntity('orderItem',orderItemData);
		
		var orderFulfillmentData = {
			order = order
		};
		var orderFulfillment = createPersistedTestEntity('orderFulfillment',orderFulfillmentData);
		
		
		order.addOrderItem(orderItem);
		promotionApplied.setOrderItem(orderItem);
		
		order.addOrderFulfillment(orderFulfillment);
		
		PromotionPeriodCount = variables.dao.getPromotionPeriodUseCount(promotionPeriod);
		//assert we were able to get our promotionPeriodUseCount
		assertEquals(1,promotionPeriodCount);
		
	}

	public void function getPromotionCodeUseCount(){
		
		//order setup
		var orderData = {
		};
		var order = createPersistedTestEntity('order',orderData);
		
		var orderStatusTypeData = {
			systemCode = 'ostPlaced'
		};
		var orderStatusType = createPersistedTestEntity('Type',orderStatusTypeData);
		
		var promotionCodeData = {};
		var promotionCode = createPersistedTestEntity('promotionCode',promotionCodeData);
		
		
		order.setOrderStatusType(orderStatusType);
		promotionCode.addOrder(order);
		order.addPromotionCode(promotionCode);
		ormflush();
		
		request.debug(order.getOrderStatusType());
		
		PromotionCodeCount = variables.dao.getPromotionCodeUseCount(promotionCode);
		//assert we were able to get our promotionCodeUseCount
		assertEquals(1,PromotionCodeCount);
	}
	
	public void function getPromotionCodeAccountUseCount(){
		//order setup
		
		var orderData = {
			orderid = '',
			orderStatusType = {
				typeid = '444df2b6b8b5d1ccfc14a4ab38aa0a4c'
			}
		};
		var order = createPersistedTestEntity('order',orderData);
		
		var promotionCodeData = {};
		var promotionCode = createPersistedTestEntity('promotionCode',promotionCodeData);
		
		var accountData = {
			
		};
		var account = createPersistedTestEntity('account',accountData);
		
		
		account.addOrder(order);
		order.setAccount(account);
		promotionCode.addOrder(order);
		order.addPromotionCode(promotionCode);
		ormflush();
		
		PromotionCodeAccountCount = variables.dao.getPromotionCodeAccountUseCount(promotionCode,account);
		//assert we were able to get our promotionCodeUseCount
		assertEquals(1,PromotionCodeAccountCount);
	}

}


