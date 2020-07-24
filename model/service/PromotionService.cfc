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
component extends="HibachiService" persistent="false" accessors="true" output="false" {
	property name="promotionDAO" type="any";
	property name="addressService" type="any";
	property name="roundingRuleService" type="any";
	property name="skuService" type="any";

	private void function clearPreviouslyAppliedPromotionsForOrderItems(required array orderItems){
		// Clear all previously applied promotions for order items
		for(var oi=1; oi<=arrayLen(arguments.orderItems); oi++) {
			var orderItem = arguments.orderItems[oi];
			var appliedPromotions = orderItem.getAppliedPromotions();
			for(var appliedPromotion in appliedPromotions){
				appliedPromotion.removeOrderItem(reciprocateFlag=false);
			}
			ArrayClear(orderItem.getAppliedPromotions());
		}
	}

	private void function clearPreviouslyAppliedPromotionsForOrderFulfillments(required array orderFulfillments){
		// Clear all previously applied promotions for fulfillment
		for(var of=1; of<=arrayLen(arguments.orderFulfillments); of++) {
			for(var pa=arrayLen(arguments.orderFulfillments[of].getAppliedPromotions()); pa >= 1; pa--) {
				if(!arguments.orderFulfillments[of].getAppliedPromotions()[pa].getManualDiscountAmountFlag()){
					arguments.orderFulfillments[of].getAppliedPromotions()[pa].removeOrderFulfillment();
				}
			}
		}
	}

	private void function clearPreviouslyAppliedPromotionsForOrder(required any order){
		// Clear all previously applied promotions for order
		for(var pa=arrayLen(arguments.order.getAppliedPromotions()); pa >= 1; pa--) {
			if(!arguments.order.getAppliedPromotions()[pa].getManualDiscountAmountFlag()){
				arguments.order.getAppliedPromotions()[pa].removeOrder();
			}
		}
	}

	private void function clearPreviouslyAppliedPromotions(required any order){
		clearPreviouslyAppliedPromotionsForOrderItems(arguments.order.getOrderItems());
		clearPreviouslyAppliedPromotionsForOrderFulfillments(arguments.order.getOrderFulfillments());
		clearPreviouslyAppliedPromotionsForOrder(arguments.order);
	}

	private void function setupPromotionRewardUsageDetails(required any promotionReward, required any promotionRewardUsageDetails){
		// Setup the promotionReward usage Details. This will be used for the maxUsePerQualification & and maxUsePerItem up front, and then later to remove discounts that violate max usage
		if(!structKeyExists(arguments.promotionRewardUsageDetails, arguments.promotionReward.getPromotionRewardID())) {
			arguments.promotionRewardUsageDetails[ arguments.promotionReward.getPromotionRewardID() ] = {
				usedInOrder = 0,
				potentialUsedInOrder=0,
				maximumUsePerOrder = 1000000,
				maximumUsePerItem = 1000000,
				maximumUsePerQualification = 1000000,
				orderItemsUsage = [],
				totalDiscountAmount=0,
				priority = arguments.promotionReward.getPromotionPeriod().getPromotion().getPriority(),
				amountType = arguments.promotionReward.getAmountType()
			};

			if( !isNull(arguments.promotionReward.getMaximumUsePerOrder()) && arguments.promotionReward.getMaximumUsePerOrder() > 0) {
				arguments.promotionRewardUsageDetails[ arguments.promotionReward.getPromotionRewardID() ].maximumUsePerOrder = arguments.promotionReward.getMaximumUsePerOrder();
			}
			if( !isNull(arguments.promotionReward.getMaximumUsePerItem()) && arguments.promotionReward.getMaximumUsePerItem() > 0 ) {
				arguments.promotionRewardUsageDetails[ arguments.promotionReward.getPromotionRewardID() ].maximumUsePerItem = arguments.promotionReward.getMaximumUsePerItem();
			}
			if( !isNull(arguments.promotionReward.getMaximumUsePerQualification()) && arguments.promotionReward.getMaximumUsePerQualification() > 0 ) {
				arguments.promotionRewardUsageDetails[ arguments.promotionReward.getPromotionRewardID() ].maximumUsePerQualification = arguments.promotionReward.getMaximumUsePerQualification();
			}
		}
	}

	private void function setupOrderItemQualifiedDiscounts(required any order, required struct orderItemQualifiedDiscounts){
		
		// Loop over orderItems and add Sale Prices to the qualified discounts

		for(var orderItem in arguments.order.getOrderItems()) {
			
			//If the price was overriden by the admin, we're skipping that item
			if( isNull(orderItem.getUserDefinedPriceFlag()) || !orderItem.getUserDefinedPriceFlag() ){
				var salePriceDetails = orderItem.getSalePrice();
	
				for(var key in salePriceDetails) {
					if(structKeyExists(salePriceDetails[key], "salePrice") && salePriceDetails[key].salePrice < orderItem.getSkuPrice()) {
	
						var discountAmount = val(getService('HibachiUtilityService').precisionCalculate((orderItem.getSkuPrice() * orderItem.getQuantity()) - (salePriceDetails[key].salePrice * orderItem.getQuantity())));
	
						arguments.orderItemQualifiedDiscounts[ orderItem.getOrderItemID() ] = [];
	
						// Insert this value into the potential discounts array
						arrayAppend(arguments.orderItemQualifiedDiscounts[ orderItem.getOrderItemID() ], {
							promotionRewardID = "",
							promotion = this.getPromotion(salePriceDetails[key].promotionID),
							discountAmount = discountAmount
						});
					}
				}
			}
			
		}
	}

	private boolean function shouldAddNewPromotion(numeric discountAmount, any orderFulfillment, any promotionReward){

		// First we make sure that the discountAmount is > 0 before we check if we should add more discount
		if(arguments.discountAmount > 0) {

			// If there aren't any promotions applied to this order fulfillment yet, then we can add this one
			if(!arrayLen(arguments.orderFulfillment.getAppliedPromotions())) {
				return true;

			// If one has already been set then we just need to check if this new discount amount is greater
			} else if ( arguments.orderFulfillment.getAppliedPromotions()[1].getDiscountAmount() < arguments.discountAmount ) {

				// If the promotion is the same, then we just update the amount
				if(arguments.orderFulfillment.getAppliedPromotions()[1].getPromotion().getPromotionID() == arguments.promotionReward.getPromotionPeriod().getPromotion().getPromotionID()) {
					arguments.orderFulfillment.getAppliedPromotions()[1].setDiscountAmount(discountAmount);

				// If the promotion is a different then remove the original and set addNew to true
				} else {
					arguments.orderFulfillment.getAppliedPromotions()[1].removeOrderFulfillment();
					return true;
				}
			}
		}
		return false;
	}

	private void function processOrderFulfillmentRewards(required any order, required any promotionPeriodQualifications, required any promotionReward){
		// Loop over all the fulfillments
		for(var orderFulfillment in arguments.order.getOrderFulfillments()) {
			// Verify that this fulfillment is in the list & the methods match
			if( arrayFind(arguments.promotionPeriodQualifications[arguments.promotionReward.getPromotionPeriod().getPromotionPeriodID()].qualifiedFulfillmentIDs, orderFulfillment.getOrderFulfillmentID())
				&&
				( !arrayLen(arguments.promotionReward.getFulfillmentMethods()) || arguments.promotionReward.hasFulfillmentMethod(orderFulfillment.getFulfillmentMethod()) )
				&&
				( !arrayLen(arguments.promotionReward.getShippingMethods()) || (!isNull(orderFulfillment.getShippingMethod()) && arguments.promotionReward.hasShippingMethod(orderFulfillment.getShippingMethod()) ) ) ) {
				var addressIsInZone = true;
				if(arrayLen(arguments.promotionReward.getShippingAddressZones())) {
					addressIsInZone = false;
					if(!isNull(orderFulfillment.getAddress()) && !orderFulfillment.getAddress().isNew()) {
						for(var az=1; az<=arrayLen(arguments.promotionReward.getShippingAddressZones()); az++) {
							if(getAddressService().isAddressInZone(address=orderFulfillment.getAddress(), addressZone=arguments.promotionReward.getShippingAddressZones()[az])) {
								addressIsInZone = true;
								break;
							}
						}
					}
				}
				// Address In Zone
				if(addressIsInZone) {
					var discountAmount = getDiscountAmount(arguments.promotionReward, orderFulfillment.getFulfillmentCharge(), 1);
					var addNew = shouldAddNewPromotion(discountAmount,orderFulfillment,arguments.promotionReward);
					// Add the new appliedPromotion
					if(addNew) {
						applyPromotionToOrderFulfillment(orderFulfillment,arguments.promotionReward,discountAmount);
					}

				} // END: Address In Zone

			} // END: Method Match

		} // Loop
	}
	
	private boolean function rewardSortFunction( required struct a, required struct b ){
		if(arguments.a.priority < arguments.b.priority){
			return -1;
		}else if( arguments.a.priority > arguments.b.priority ){
			return 1;
		}else{
			return arguments.a.discountAmount < arguments.b.discountAmount ? 1 : -1;
		}
	}

	private void function processOrderItemRewards(required any order, required any promotionPeriodQualifications, required any promotionRewardUsageDetails, required any orderItemQualifiedDiscounts, required any promotionReward){
		var promotionRewardUsageDetail = arguments.promotionRewardUsageDetails[ arguments.promotionReward.getPromotionRewardID() ];
		var promotionPeriodQualification = arguments.promotionPeriodQualifications[arguments.promotionReward.getPromotionPeriod().getPromotionPeriodID()];
		
		//Get all orderitems in descending order of price
		var orderItems = arguments.order.getOrderItems();
		orderItems.sort(function(a,b){
			if(arguments.a.getExtendedUnitPriceAfterDiscount() >= arguments.b.getExtendedUnitPriceAfterDiscount()){
				return -1;
			}else{
				return 1;
			}
		});
		
		if(arguments.order.hasOrderTemplate() && !arrayLen(orderItems) ){
			logHibachi('NO order items in array, bailing');
		}
		
		// Loop over all the orderItems
		for(var orderItem in orderItems) {
			// Verify that this is an item being sold
			if(orderItem.getOrderItemType().getSystemCode() == "oitSale") {
				// Make sure that this order item is in the acceptable fulfillment list
				if(arrayFind(promotionPeriodQualification.qualifiedFulfillmentIDs, orderItem.getOrderFulfillment().getOrderFulfillmentID())) {
					if(arguments.order.hasOrderTemplate()){
						logHibachi('Order fulfillment in acceptable fulfillment list');
					}
					
					// Now that we know the fulfillment is ok, lets check and cache then number of times this orderItem qualifies based on the promotionPeriod
					if(!structKeyExists(promotionPeriodQualification.orderItems, orderItem.getOrderItemID())) {
						promotionPeriodQualification.orderItems[ orderItem.getOrderItemID() ] = getPromotionPeriodOrderItemQualificationCount(promotionPeriod=arguments.promotionReward.getPromotionPeriod(), orderItem=orderItem, order=arguments.order);
					}

					// If the qualification count for this order item is > 0 then we can try to apply the reward
					if(promotionPeriodQualification.orderItems[ orderItem.getOrderItemID() ]) {
						if(arguments.order.hasOrderTemplate()){
							logHibachi('Order Item qualified');
						}
						// Check the reward settings to see if this orderItem applies
						if( getOrderItemInReward(arguments.promotionReward, orderItem) ) {
							if(arguments.order.hasOrderTemplate()){
								logHibachi('Order item in reward');
							}
							var qualificationQuantity = promotionPeriodQualification.orderItems[ orderItem.getOrderItemID() ];
							var maxUsages = qualificationQuantity * promotionRewardUsageDetail.maximumUsePerQualification;
							
							if(maxUsages lt promotionRewardUsageDetail.maximumUsePerOrder) {
								promotionRewardUsageDetail.maximumUsePerOrder = maxUsages;
							}else{
								maxUsages = promotionRewardUsageDetail.maximumUsePerOrder;
							}
							// setup the discountQuantity based on the qualification quantity.  If there were no qualification constrints than this will just be the orderItem quantity
							// Subtract the number of times this promotion reward has already been used in this order
							var discountQuantity = maxUsages;
							var potentialDiscountQuantity = maxUsages - promotionRewardUsageDetail.potentialUsedInOrder;
							// If the discountQuantity is > the orderItem quantity then just set it to the orderItem quantity
							if(discountQuantity > orderItem.getQuantity()) {
								discountQuantity = orderItem.getQuantity();
							}
							// If the discountQuantity is > than maximumUsePerItem then set it to maximumUsePerItem
							if(discountQuantity > promotionRewardUsageDetail.maximumUsePerItem) {
								discountQuantity = promotionRewardUsageDetail.maximumUsePerItem;
							}
							if(discountQuantity < potentialDiscountQuantity){
								potentialDiscountQuantity = discountQuantity;
							}
							if(discountQuantity != 0){
								// If there is not applied Price Group, or if this reward has the applied pricegroup as an eligible one then use priceExtended... otherwise use skuPriceExtended and then adjust the discount.
								if( isNull(orderItem.getAppliedPriceGroup()) || arguments.promotionReward.hasEligiblePriceGroup( orderItem.getAppliedPriceGroup() ) || getService('SettingService').getSettingValue('globalPromotionIgnorePriceGroupEligibility') ) {
									// Calculate based on price, which could be a priceGroup price
									var discountAmount = getDiscountAmount(reward=arguments.promotionReward, price=orderItem.getPrice(), quantity=discountQuantity, currencyCode=orderItem.getCurrencyCode(), sku=orderItem.getSku(), account=arguments.order.getAccount());
	
								} else {
									// Calculate based on skuPrice because the price on this item is a priceGroup price and we need to adjust the discount by the difference
									var originalDiscountAmount = getDiscountAmount(reward=arguments.promotionReward, price=orderItem.getSkuPrice(), quantity=discountQuantity, sku=orderItem.getSku(), account=arguments.order.getAccount());
	
									// Take the original discount they were going to get without a priceGroup and subtract the difference of the discount that they are already receiving
									var discountAmount = val(getService('HibachiUtilityService').precisionCalculate(originalDiscountAmount - (orderItem.getExtendedSkuPrice() - orderItem.getExtendedPrice())));
	
								}
							}else{
								var discountAmount = 0;
							}
							// If the discountAmount is gt 0 then we can add the details in order to the potential orderItem discounts
							if(discountAmount > 0) {

								// First thing that we are going to want to do is add this orderItem to the orderItemQualifiedDiscounts if it doesn't already exist
								if(!structKeyExists(arguments.orderItemQualifiedDiscounts, orderItem.getOrderItemID())) {
									// Set it as a blank array
									arguments.orderItemQualifiedDiscounts[ orderItem.getOrderItemID() ] = {};
								}
								var promotion = arguments.promotionReward.getPromotionPeriod().getPromotion();
								
								var rewardStruct = {
									promotionReward = arguments.promotionReward,
									promotion = promotion,
									discountAmount = discountAmount,
									priority=promotion.getPriority(),
									discountQuantity=discountQuantity
								}
								
								// Insert this value into the potential discounts struct
								arguments.orderItemQualifiedDiscounts[ orderItem.getOrderItemID() ][arguments.promotionReward.getPromotionRewardID()]=rewardStruct;


								// Increment the number of times this promotion reward has been used
								promotionRewardUsageDetail.potentialUsedInOrder += potentialDiscountQuantity;
								
								var discountPerUseValue = val(getService('HibachiUtilityService').precisionCalculate(discountAmount / discountQuantity));
								promotionRewardUsageDetail.totalDiscountAmount += potentialDiscountQuantity * discountPerUseValue;

								var usageAdded = false;

								// loop over any previous orderItemUsage of this reward an place it in ASC order based on discountPerUseValue
								for(var oiu=1; oiu<=arrayLen(promotionRewardUsageDetail.orderItemsUsage) ; oiu++) {
									if(promotionRewardUsageDetail.orderItemsUsage[oiu].discountPerUseValue > discountPerUseValue) {
										// Insert this value into the potential discounts array
										arrayInsertAt(promotionRewardUsageDetail.orderItemsUsage, oiu, {
											orderItemID = orderItem.getOrderItemID(),
											discountQuantity = discountQuantity,
											discountPerUseValue = discountPerUseValue
										});

										usageAdded = true;
										break;
									}
								}
								if(!usageAdded) {

									// Insert this value into the potential discounts array

									arrayAppend(promotionRewardUsageDetail.orderItemsUsage, {
										orderItemID = orderItem.getOrderItemID(),
										discountQuantity = discountQuantity,
										discountPerUseValue = discountPerUseValue
									});

								}
							}else{
								if(arguments.order.hasOrderTemplate()){
									logHibachi('Discount amount 0, not applying #arguments.promotionReward.getPromotionPeriod().getPromotion().getPromotionName()#');
								}
							}

						} // End OrderItem in reward IF

					} // End orderItem qualification count > 0

				} // End orderItem fulfillment in qualifiedFulfillment list
				
			} // END Sale Item If
			
		} // End Order Item For Loop
	}

	private void function processOrderRewards(required any order, required array orderQualifiedDiscounts, required any promotionReward){
		var totalDiscountableAmount = arguments.order.getSubtotalAfterItemDiscounts();

		var discountAmount = getDiscountAmount(arguments.promotionReward, totalDiscountableAmount, 1, arguments.order.getCurrencyCode());

		// First we make sure that the discountAmount is > 0 before we check if we should add more discount
		if(discountAmount > 0) {

			var promotion = arguments.promotionReward.getPromotionPeriod().getPromotion();
								
			var rewardStruct = {
				promotionReward = arguments.promotionReward,
				promotion = promotion,
				discountAmount = discountAmount,
				priority=promotion.getPriority()
			}
			
			// Insert this value into the potential discounts array
			arrayAppend(arguments.orderQualifiedDiscounts, rewardStruct);
		}
	}
	
	public void function processRewardSkuPromotionReward(required any order, required array itemsToBeAdded, required any promotionReward){
		
		if(arguments.promotionReward.getPromoHasRan()){
			return;
		}
		
		arguments.promotionReward.setPromoHasRan(true);
		
		//skus to be added 
		var rewardSkusCollection = arguments.promotionReward.getIncludedSkusCollection();
		
		//the quantity of free skus that we should add
		var skuRewardQuantity = arguments.promotionReward.getRewardSkuQuantity() ?: 0;
		
		//if this promo reward has already been processed in the request, or it has no reward sku's /quantity return
		if( isNull(rewardSkusCollection) || skuRewardQuantity <= 0 ){
			return;
		}
		
		//the skus to be added to the order
		rewardSkusCollection = rewardSkusCollection.getRecords();
		var orderService = getService("OrderService");
		
		for(var skuRecord in rewardSkusCollection){
			var addOrderItemData = {
				quantity: skuRewardQuantity,
				skuID: skuRecord.skuID,
				orderID: arguments.order.getOrderID(),
				userDefinedPriceFlag: true,
				price:0
			}
			arrayAppend(arguments.itemsToBeAdded, addOrderItemData);
		}
		
	}
	
	public void function updateOrderAmountsWithPromotions(required any order) {
		//Save before flushing 
		if(arguments.order.getNewFlag()){
			getService('hibachiService').saveOrder(arguments.order);
		}

		if(arguments.order.isOrderPaidFor()){
			return;
		}

		// Set up a promotionEffectiveDateTime in case this is an order that has already been placed
		var promotionEffectiveDateTime = now();
		if(arguments.order.getOrderStatusType().getSystemCode() != "ostNotPlaced" && !isNull(arguments.order.getOrderOpenDateTime())) {
			promotionEffectiveDateTime = arguments.order.getOrderOpenDateTime();
		}
		
		var orderItemIDList="";
 		for(var orderItem in arguments.order.getOrderItems()){
 			orderItemIDList = listAppend(orderItemIDList,orderItem.getSku().getSkuID()&orderItem.getQuantity()&orderItem.getPrice());
 		}
 		for(var promotionCode in arguments.order.getPromotionCodes()){
 			orderItemIDList = listAppend(orderItemIDList,promotionCode.getPromotionCodeID());
 		}

 		var orderFulfillmentList ="";
 		for(var orderFulfillment in arguments.order.getOrderFulfillments()){
 			if(!isNull(orderFulfillment.getShippingAddress())){
 				orderFulfillmentList = listAppend(orderFulfillmentList,orderFulfillment.getShippingAddress().getFullAddress());
 				if(!isNull(orderFulfillment.getSelectedShippingMethodOption())){
 					orderFulfillmentList = listAppend(orderFulfillmentList,orderFulfillment.getSelectedShippingMethodOption().getShippingMethodOptionID());
 				}
 			}
 			if(!isNull(orderFulfillment.getPickupLocation())){
 				orderFulfillmentList = listAppend(orderFulfillmentList,orderFulfillment.getPickupLocation().getLocationID());
 			}
 		}
 		var accountID = '';
 		if(!isNull(arguments.order.getAccount())){
 			accountID = arguments.order.getAccount().getAccountID();
 		}
 		
 		var promotionCacheKey = hash(orderItemIDList&orderFulfillmentList&arguments.order.getTotalItemQuantity()&accountID,'md5');

		if(isNull(arguments.order.getPromotionCacheKey()) || arguments.order.getPromotionCacheKey() != promotionCacheKey){
			arguments.order.setPromotionCacheKey(promotionCacheKey);
			// Sale & Exchange Orders
			if( listFindNoCase("otSalesOrder,otExchangeOrder", arguments.order.getOrderType().getSystemCode()) ) {
				
				clearPreviouslyAppliedPromotions(arguments.order);
				clearPreviouslyAppliedPromotionMessages(arguments.order);
				getHibachiScope().flushOrmSession();
				for(var orderItem in arguments.order.getOrderItems()){
					orderItem.updateCalculatedProperties(runAgain=true,cascadeCalculateFlag=false);
				}
				arguments.order.updateCalculatedProperties(runAgain=true,cascadeCalculateFlag=false);
				try{
					getHibachiDAO().flushOrmSession();
				}catch(any e){
					logHibachi('Pre-promotion: #e.message#');
				}
				
				// This is a structure of promotionPeriods that will get checked and cached as to if we are still within the period use count, and period account use count
				var promotionPeriodQualifications = {};
	
				// This is a structure of promotionRewards that will hold information reguarding maximum usages, and the amount of usages applied
				var promotionRewardUsageDetails = {};
	
				// This is a structure of orderItems with all of the potential discounts that apply to them
				var orderItemQualifiedDiscounts = {};
				
				// This is an array of qualified order rewards
				var orderQualifiedDiscounts = [];
				
				// This is an array of qualifier messages for qualifiers not met by the order
				var orderQualifierMessages = [];
				
				//Promotional items to be added at the end of the loop
				var itemsToBeAdded = [];
				
				setupOrderItemQualifiedDiscounts(arguments.order, orderItemQualifiedDiscounts);

				// Loop over all Potential Discounts that require qualifications
				var promotionRewards = getPromotionDAO().getActivePromotionRewards(rewardTypeList="merchandise,subscription,contentAccess,order,fulfillment,rewardSku", promotionCodeList=arguments.order.getPromotionCodeList(), qualificationRequired=true, promotionEffectiveDateTime=promotionEffectiveDateTime, site=arguments.order.getOrderCreatedSite());
				var orderRewards = false;
				for(var pr=1; pr<=arrayLen(promotionRewards); pr++) {
					var reward = promotionRewards[pr];
					
					if(arguments.order.hasOrderTemplate() && ((!orderRewards && reward.getRewardType() != 'order') || (orderRewards && reward.getRewardType() == 'order') ) ){
						logHibachi('Checking #reward.getRewardType()# reward for #reward.getPromotionPeriod().getPromotion().getPromotionName()#');
					}
					// Setup the promotionReward usage Details. This will be used for the maxUsePerQualification & and maxUsePerItem up front, and then later to remove discounts that violate max usage
					setupPromotionRewardUsageDetails(reward,promotionRewardUsageDetails);
					// Setup the boolean for if the promotionPeriod is okToApply based on general use count
					if(!structKeyExists(promotionPeriodQualifications, reward.getPromotionPeriod().getPromotionPeriodID())) {
						promotionPeriodQualifications[ reward.getPromotionPeriod().getPromotionPeriodID() ] = getPromotionPeriodQualificationDetails(promotionPeriod=reward.getPromotionPeriod(), order=arguments.order, orderQualifierMessages=orderQualifierMessages);
					}
					// If this promotion period is ok to apply based on general useCount
					if(promotionPeriodQualifications[ reward.getPromotionPeriod().getPromotionPeriodID() ].qualificationsMeet) {
						if(arguments.order.hasOrderTemplate() && ((!orderRewards && reward.getRewardType() != 'order') || (orderRewards && reward.getRewardType() == 'order') ) ){
							logHibachi('Qualifications met for #reward.getPromotionPeriod().getPromotion().getPromotionName()#');
						}
						// =============== Order Item Reward ==============
						if( !orderRewards and listFindNoCase("merchandise,subscription,contentAccess", reward.getRewardType()) ) {

							processOrderItemRewards(arguments.order, promotionPeriodQualifications, promotionRewardUsageDetails, orderItemQualifiedDiscounts, reward);
							
						// =============== Fulfillment Reward ======================
						} else if (!orderRewards and reward.getRewardType() eq "fulfillment" ) {
							processOrderFulfillmentRewards(arguments.order, promotionPeriodQualifications, Reward);
						// ================== Order Reward =========================
						} else if (orderRewards and reward.getRewardType() eq "order" ) {
							processOrderRewards(arguments.order, orderQualifiedDiscounts, reward);
						}else if(orderRewards and reward.getRewardType() eq "rewardSku"){
							processRewardSkuPromotionReward(arguments.order, itemsToBeAdded, reward)
						}// ============= END ALL REWARD TYPES
	
					} // END Promotion Period OK IF
	
					// This forces the loop to repeat looking for "order" discounts
					// Only runs on last iteration of loop before looking for orders
					if(!orderRewards and pr == arrayLen(promotionRewards)) {
						// Loop over the orderItems one last time, and look for the discounts that can be applied
						applyOrderItemDiscounts(arguments.order,orderItemQualifiedDiscounts, promotionRewardUsageDetails, orderQualifierMessages);
						pr = 0;
						orderRewards = true;
					}
					
				} // END of PromotionReward Loop
				getHibachiScope().flushORMSession();
									
				ArraySort(orderQualifiedDiscounts, rewardSortFunction);
				applyOrderDiscounts(arguments.order, orderQualifiedDiscounts, orderQualifierMessages);
				
				if( arraylen(itemsToBeAdded) && arrayLen(arguments.order.getFirstShippingFulfillmentArray()) ){
					var fulfillmentArray = arguments.order.getFirstShippingFulfillmentArray();
									
					for(var item in itemsToBeAdded){
						var sku = getService('skuService').getSku(item.skuID);
						if(isNull(sku)){
							continue;
						}
						
						var newOrderItem = getService("OrderService").newOrderItem();
						newOrderItem.setPrice(0);
						newOrderItem.setSkuPrice(0);
						newOrderItem.setUserDefinedPriceFlag(true);
						newOrderItem.setOrderItemType( getService('typeService').getTypeBySystemCode('oitSale') );
						newOrderItem.setOrderFulfillment( fulfillmentArray[1] );
						newOrderItem.setQuantity( item.quantity );
						newOrderItem.setSku(sku);
						newOrderItem.setOrder(arguments.order);
						getService('orderService').saveOrderItem(newOrderItem);
						if(!newOrderItem.hasErrors() && !arguments.order.hasErrors()){
							getHibachiScope().flushORMSession();
						}
					}
					
					itemsToBeAdded = [];
				}
				
				if(arrayLen(orderQualifierMessages)){
					getHibachiScope().flushOrmSession();
					applyPromotionQualifierMessagesToOrder(arguments.order,orderQualifierMessages);
				}
			} // END of Sale or Exchange Loop
	
			// Return & Exchange Orders
			if( listFindNoCase("otReturnOrder,otExchangeOrder", arguments.order.getOrderType().getSystemCode()) ) {
				// TODO [issue #1766]: In the future allow for return Items to have negative promotions applied.  This isn't import right now because you can determine how much you would like to refund ordersItems
			}
		}
	}

	private void function applyPromotionToOrderFulfillment(required any orderFulfillment, required any promotionReward, required numeric discountAmount){
		var newAppliedPromotion = this.newPromotionApplied();
		newAppliedPromotion.setAppliedType('orderFulfillment');
		newAppliedPromotion.setPromotion( arguments.promotionReward.getPromotionPeriod().getPromotion() );
		newAppliedPromotion.setPromotionReward( arguments.promotionReward );
		newAppliedPromotion.setOrderFulfillment( arguments.orderFulfillment );
		newAppliedPromotion.setDiscountAmount( arguments.discountAmount );
	}

	private void function applyPromotionToOrder(required any order,required any rewardStruct){
		var newAppliedPromotion = this.newPromotionApplied();
		newAppliedPromotion.setAppliedType('order');
		newAppliedPromotion.setPromotion( arguments.rewardStruct.promotion );
		newAppliedPromotion.setPromotionReward( arguments.rewardStruct.promotionReward );
		newAppliedPromotion.setOrder( arguments.order );
		newAppliedPromotion.setDiscountAmount( arguments.rewardStruct.discountAmount );
	}
	
	private void function applyPromotionToOrderItem( required any orderItem, required struct rewardStruct ){
		var newAppliedPromotion = this.newPromotionApplied();
		newAppliedPromotion.setAppliedType('orderItem');
		newAppliedPromotion.setPromotion( arguments.rewardStruct.promotion );
		newAppliedPromotion.setPromotionReward( arguments.rewardStruct.promotionReward );
		newAppliedPromotion.setOrderItem( arguments.orderItem );
		newAppliedPromotion.setDiscountAmount( arguments.rewardStruct.discountAmount );
	}
	
	private void function clearPreviouslyAppliedPromotionMessages(required any order){
		// Clear all previously applied promotions for order
		var len=arrayLen(arguments.order.getAppliedPromotionMessages());
		
		for(var i = len; i >= 1; i--) {
			arguments.order.getAppliedPromotionMessages()[i].removeOrder();
		}

	}
	
	private void function applyPromotionQualifierMessagesToOrder(required any order, required array orderQualifierMessages){
		
		ArraySort(arguments.orderQualifierMessages,function(a,b){
			if(arguments.a.getPriority() <= arguments.b.getPriority()){
				return -1;
			}else{
				return 1;
			}
		});
		
		var maxMessages = getService('SettingService').getSettingValue('globalMaximumPromotionMessages');

		var messagesApplied = 0;
		for(var promotionQualifierMessage in arguments.orderQualifierMessages){
			if( promotionQualifierMessage.hasOrderByOrderID(arguments.order.getOrderID()) ){
				var newAppliedPromotionMessage = this.newPromotionMessageApplied();
				newAppliedPromotionMessage.setOrder( arguments.order );
			
				newAppliedPromotionMessage.setPromotionQualifierMessage( promotionQualifierMessage );
				newAppliedPromotionMessage.setPromotionPeriod(promotionQualifierMessage.getPromotionQualifier().getPromotionPeriod());
				newAppliedPromotionMessage.setPromotion(newAppliedPromotionMessage.getPromotionPeriod().getPromotion());
				newAppliedPromotionMessage.setMessage( promotionQualifierMessage.getInterpolatedMessage( arguments.order ) );
				
				this.savePromotionMessageApplied(newAppliedPromotionMessage);
				messagesApplied++;
			}
			
			if(messagesApplied == maxMessages){
				break;
			}
		}

	}

	private void function removeDiscountsExceedingMaxOrderUseCounts(required any promotionRewardUsageDetails, required any orderItemQualifiedDiscounts){


		for(var prID in arguments.promotionRewardUsageDetails) {

			// If this promotion reward was used more than it should have been, then lets start stripping out from the arrays in the correct order
			if(arguments.promotionRewardUsageDetails[ prID ].usedInOrder > arguments.promotionRewardUsageDetails[ prID ].maximumUsePerOrder) {
				var needToRemove = arguments.promotionRewardUsageDetails[ prID ].usedInOrder - arguments.promotionRewardUsageDetails[ prID ].maximumUsePerOrder;
				// Loop over the items it was applied to an remove the quantity necessary to meet the total needToRemoveQuantity
				for(var x=1; x<=arrayLen(arguments.promotionRewardUsageDetails[ prID ].orderItemsUsage); x++) {
					var orderItemID = arguments.promotionRewardUsageDetails[ prID ].orderItemsUsage[x].orderItemID;
					var thisDiscountQuantity = arguments.promotionRewardUsageDetails[ prID ].orderItemsUsage[x].discountQuantity;

					if(needToRemove < thisDiscountQuantity) {

						// Loop over to find promotionReward
						for(var y=arrayLen(arguments.orderItemQualifiedDiscounts[ orderItemID ]); y>=1; y--) {
							if(arguments.orderItemQualifiedDiscounts[ orderItemID ][y].promotionRewardID == prID) {

								// Set the discountAmount as some fraction of the original discountAmount
								arguments.orderItemQualifiedDiscounts[ orderItemID ][y].discountAmount = val(getService('HibachiUtilityService').precisionCalculate(getService('HibachiUtilityService').precisionCalculate(arguments.orderItemQualifiedDiscounts[ orderItemID ][y].discountAmount / thisDiscountQuantity) * getService('HibachiUtilityService').precisionCalculate(thisDiscountQuantity - needToRemove)));

								// Update the needToRemove
								needToRemove = 0;

								// Break out of the item discount loop
								break;
							}
						}
					} else {

						// Loop over to find promotionReward
						for(var y=arrayLen(arguments.orderItemQualifiedDiscounts[ orderItemID ]); y>=1; y--) {
							if(arguments.orderItemQualifiedDiscounts[ orderItemID ][y].promotionRewardID == prID) {
								// Remove from the array
								arrayDeleteAt(arguments.orderItemQualifiedDiscounts[ orderItemID ], y);

								// update the needToRemove
								needToRemove = needToRemove - thisDiscountQuantity;

								// Break out of the item discount loop
								break;
							}
						}
					}

					// If we don't need to remove any more
					if(needToRemove == 0) {
						break;
					}
				}

			}

		} // End Promotion Reward loop for removing anything that was overused

	}
	
	private void function applyOrderDiscounts(required any order, required array orderQualifiedDiscounts, array orderQualifierMessages){
		
		var itemAppliedPromotions = getPromotionDAO().getAppliedPromotionsForOrderItemsByOrder(arguments.order);
		for(var rewardStruct in arguments.orderQualifiedDiscounts ){
			if( !getUpdatedQualificationStatus( arguments.order, rewardStruct.promotionReward.getPromotionRewardID(), arguments.orderQualifierMessages ) ){
				continue;
			}
			var appliedPromotions = arguments.order.getAppliedPromotions();
			
			if( rewardCanStack( appliedPromotions, rewardStruct.promotionReward )
				&& rewardCanStack( itemAppliedPromotions, rewardStruct.promotionReward )
			){
				applyPromotionToOrder( arguments.order, rewardStruct );
				arguments.order.updateCalculatedProperties(true);
			}
			
		}
		//making sure calculated props run
		getHibachiScope().addModifiedEntity(arguments.order);
		
	}

	private void function applyOrderItemDiscounts(required any order, required struct orderItemQualifiedDiscounts, required struct promotionRewardUsageDetails, array orderQualifierMessages){
		if(arguments.order.hasOrderTemplate()){
			logHibachi('Applying Order Item discounts for order #arguments.order.getOrderID()#');
		}
		var promotionRewardUsageArray = getPromotionRewardUsageArray( arguments.promotionRewardUsageDetails );
		var length = arrayLen(promotionRewardUsageArray);
		
		for(var i = 1; i <= length; i++){
			if(arguments.order.hasOrderTemplate()){
				logHibachi('Discount #i#');
			}
			var promotionRewardUsage = promotionRewardUsageArray[i];
			var promotionRewardID = promotionRewardUsage.promotionRewardID;

			if( i > 1 &&
				!getUpdatedQualificationStatus( arguments.order, promotionRewardID, arguments.orderQualifierMessages, arguments.orderItemQualifiedDiscounts ) ){
				if(arguments.order.hasOrderTemplate()){
					logHibachi('Reward #promotionRewardID# no longer qualified');
				}
				continue;
			}
			
			var orderItems = arguments.order.getOrderItems();
			if(promotionRewardUsage.amountType == 'percentageOff'){
				orderItems.sort(function(a,b){
					if(arguments.a.getExtendedUnitPriceAfterDiscount() >= arguments.b.getExtendedUnitPriceAfterDiscount()){
						return -1;
					}else{
						return 1;
					}
				});
			}

			for(var orderItem in orderItems) {
				if(promotionRewardUsage.usedInOrder == promotionRewardUsage.maximumUsePerOrder){
					if(arguments.order.hasOrderTemplate()){
						logHibachi('Reward #promotionRewardID# at max usage');
					}
					break;
				}
				var orderItemID = orderItem.getOrderItemID();
				// If order item exists in discounts struct and has this reward, apply
				if(structKeyExists( arguments.orderItemQualifiedDiscounts, orderItemID )
					&& structKeyExists( arguments.orderItemQualifiedDiscounts[orderItemID], promotionRewardID)
				) {
					var rewardStruct = arguments.orderItemQualifiedDiscounts[orderItemID][promotionRewardID];
					//Update quantity and amount to not exeed max usages
					if(promotionRewardUsage.maximumUsePerOrder < promotionRewardUsage.usedInOrder + rewardStruct.discountQuantity){
						var newDiscountQuantity = promotionRewardUsage.maximumUsePerOrder - promotionRewardUsage.usedInOrder;
						var newDiscountAmount = getHibachiUtilityService().precisionCalculate(rewardStruct.discountAmount * newDiscountQuantity / rewardStruct.discountQuantity);
						rewardStruct.discountQuantity = newDiscountQuantity;
						rewardStruct.discountAmount = newDiscountAmount;
					}
					
					var applied = applyPromotionToOrderItemIfValid( orderItem,rewardStruct );
					if(applied){
						promotionRewardUsage.usedInOrder += rewardStruct.discountQuantity;
						orderItem.updateCalculatedProperties(runAgain=true,cascadeCalculateFlag=false);
					}
				}
			}
			getHibachiScope().flushORMSession();
			arguments.order.updateCalculatedProperties(runAgain=true,cascadeCalculateFlag=false)
			getHibachiScope().flushORMSession();
		}
	}
	
	private array function getPromotionRewardUsageArray( required struct promotionRewardUsageDetails ){
		var promotionRewardUsageArray = [];
		
		for( var promotionRewardID in arguments.promotionRewardUsageDetails ){
			var promotionRewardUsage = arguments.promotionRewardUsageDetails[promotionRewardID];
			if(promotionRewardUsage.totalDiscountAmount == 0){
				logHibachi('Reward #promotionRewardID# totalDiscountAMount = 0, skipping');
				continue;
			}else{
				logHibachi('ADDING Reward #promotionRewardID# TO PROMOTIONREWARDUSAGEARRAY');
			}
			promotionRewardUsage['promotionRewardID'] = promotionRewardID;
			var length = ArrayLen(promotionRewardUsageArray);
			var found = false;
			for(var i = 1; i <= length; i++){
				// Variables to determine ordering
				var higherPriority = promotionRewardUsage['priority'] < promotionRewardUsageArray[i].priority;
				var samePriority = promotionRewardUsage['priority'] == promotionRewardUsageArray[i].priority;
				var samePriorityHigherDiscount = samePriority
					&& (promotionRewardUsage['totalDiscountAmount'] > promotionRewardUsageArray[i].totalDiscountAmount);
				

				if( higherPriority 
				|| samePriorityHigherDiscount ){
					arrayInsertAt(promotionRewardUsageArray, i, promotionRewardUsage);
					found=true;
					break;
				}
			}
			if(!found){
				arrayAppend(promotionRewardUsageArray, promotionRewardUsage);
			}
		}

		return promotionRewardUsageArray;
	}
	
	private boolean function applyPromotionToOrderItemIfValid( required any orderItem, required struct rewardStruct ){
		var appliedPromotions = arguments.orderItem.getAppliedPromotions();
		var order = arguments.orderItem.getOrder();

		if( rewardCanStack( appliedPromotions, arguments.rewardStruct.promotionReward )){
			if(len(appliedPromotions) && arguments.rewardStruct.promotionReward.getAmountType() == 'percentageOff'){
					//Recalculate discount amount based on new price
					arguments.rewardStruct.discountAmount = getDiscountAmount(reward=arguments.rewardStruct.promotionReward, price=arguments.orderItem.getExtendedUnitPriceAfterDiscount(), quantity=arguments.rewardStruct.discountQuantity, currencyCode=arguments.orderItem.getCurrencyCode(), sku=arguments.orderItem.getSku(), account=order.getAccount());
			}

			applyPromotionToOrderItem( arguments.orderItem, arguments.rewardStruct );
			return true;
		}
		return false;
	}
	
	private boolean function getUpdatedQualificationStatus( required any order, required string promotionRewardID, array orderQualifierMessages, struct qualifiedDiscountsStruct ){
		var promotionReward = this.getPromotionReward( arguments.promotionRewardID );
		var cacheKey = arguments.promotionRewardID;
		
		if(structKeyExists(arguments, 'qualifiedDiscountsStruct')){
			if( !structKeyExists( arguments.qualifiedDiscountsStruct, 'updatedQualifications' ) ){
				arguments.qualifiedDiscountsStruct['updatedQualifications'] = {};
			}
			// If we've already requalified the order at this stage, we can return that value
			if( structKeyExists( arguments.qualifiedDiscountsStruct.updatedQualifications, cacheKey ) ){
				return arguments.qualifiedDiscountsStruct.updatedQualifications[cacheKey];
			}
		}
		
		//Flush to make sure we're working with updated values
		getHibachiScope().flushORMSession();
		// Recheck qualification for order qualifiers only; merchandise / fulfillment qualifiers will not have changed
		var promotionPeriod = promotionReward.getPromotionPeriod();
		
		var qualificationDetails = getPromotionPeriodQualificationDetails(promotionPeriod, arguments.order, arguments.orderQualifierMessages);
		
		var qualified = qualificationDetails.qualificationsMeet;
		
		if(structKeyExists(arguments, 'qualifiedDiscountsStruct')){
			arguments.qualifiedDiscountsStruct.updatedQualifications[cacheKey] = qualified;
		}
		return qualified;
	}
	
	private boolean function rewardCanStack( required array appliedPromotions, required any promotionReward ){
		
		if( !ArrayLen(arguments.appliedPromotions) ){
			return true;
		}
		var rewardType = arguments.promotionReward.getRewardType();
		
		var rewardCanStack = true;
		
		for( var appliedPromotion in arguments.appliedPromotions ){
			if( isNull(appliedPromotion.getPromotionReward()) ){
				continue;
			}
			var appliedRewardID = appliedPromotion.getPromotionRewardID();
			var appliedRewardType = appliedPromotion.getPromotionReward().getRewardType();

			
			if( appliedRewardType == rewardType ){
				
				if( !listContains(arguments.promotionReward.getIncludedStackableRewardsIDList( true ), appliedRewardID) ){
					rewardCanStack = false;
					break;
				}
			}else{
				
				if( listContains(arguments.promotionReward.getExcludedStackableRewardsIDList( true ), appliedRewardID) ){
					rewardCanStack = false;
					break;
				}
			}
		}
		return rewardCanStack;
	}

	private struct function getPromotionPeriodQualificationDetails(required any promotionPeriod, required any order, array orderQualifierMessages) {
		
		if(!structKeyExists(arguments,'orderQualifierMessages')){
			arguments['orderQualifierMessages'] = [];
		}
		// Create a return struct
		var qualificationDetails = {
			qualificationsMeet = true,
			qualifiedFulfillmentIDs = [],
			qualifierDetails = [],
			orderItems = {}
		};

		for(var orderFulfillment in arguments.order.getOrderFulfillments()) {
			arrayAppend(qualificationDetails.qualifiedFulfillmentIDs, orderFulfillment.getOrderFulfillmentID());
		}

		var explicitlyQualifiedFulfillmentIDs = [];

		// Check the max use count for the promotionPeriod
		if(arguments.promotionPeriod.hasMaximumUseCount()) {
			var periodUseCount = getPromotionDAO().getPromotionPeriodUseCount(promotionPeriod = arguments.promotionPeriod);
			if(periodUseCount >= arguments.promotionPeriod.getMaximumUseCount()) {
				qualificationDetails.qualificationsMeet = false;
			}
		}

		// Check the max account use count for the promotionPeriod
		if(arguments.promotionPeriod.hasMaximumAccountUseCount()) {
			if(!isNull(arguments.order.getAccount())) {
				var periodAccountUseCount = getPromotionDAO().getPromotionPeriodAccountUseCount(promotionPeriod = arguments.promotionPeriod, account=arguments.order.getAccount());
				if(periodAccountUseCount >= arguments.promotionPeriod.getMaximumAccountUseCount()) {
					qualificationDetails.qualificationsMeet = false;
				}
			}
		}

		// If the above two conditions are ok, then we can find out the rest of the details
		if(qualificationDetails.qualificationsMeet) {
			var hasQualifiedQualifier = false;
			var qualifiers = arguments.promotionPeriod.getPromotionQualifiers();
			var qualifierLogicalOperator = arguments.promotionPeriod.getQualifierLogicalOperator();
			if(!arrayLen(qualifiers)){
				hasQualifiedQualifier=true;
			}else{
				// Loop over each of the qualifiers
				for(var qualifier in qualifiers) {
	
					// Get the details for this qualifier
					var thisQualifierDetails = getQualifierQualificationDetails(qualifier, arguments.order, arguments.orderQualifierMessages);
	
					// As long as there is a qualification count that is > 0 we can append the details
					if(thisQualifierDetails.qualificationCount) {
						hasQualifiedQualifier = true;
						
						// If this was a fulfillment qualifier, then we can define it as an explicily qualified fulfillment
						if(qualifier.getQualifierType() == "fulfillment") {
	
							// Loop over all fulfillments that were passed back
							for(var orderFulfillmentID in thisQualifierDetails.qualifiedFulfillmentIDs) {
	
								// If the explicit list doesn't have this one, then we can add it
								if(!arrayFind(explicitlyQualifiedFulfillmentIDs, orderFulfillmentID)) {
									arrayAppend(explicitlyQualifiedFulfillmentIDs, orderFulfillmentID);
								}
							}
						}
	
						// Attach the qualification details
						arrayAppend(qualificationDetails.qualifierDetails, thisQualifierDetails);
					
					}else if(qualifierLogicalOperator == 'AND'){
						if(arguments.order.hasOrderTemplate()){
							logHibachi('Failed due to AND qualifier logical operator.');
						}
						hasQualifiedQualifier = false;
						break;
					}
				}
			}
			
			if(!hasQualifiedQualifier){
				qualificationDetails.qualificationsMeet = false;
				qualificationDetails.qualifiedFulfillmentIDs = [];
				qualificationDetails.qualifierDetails = [];
				return qualificationDetails;
			}
		}

		if(arrayLen(explicitlyQualifiedFulfillmentIDs)) {
			qualificationDetails.qualifiedFulfillments = explicitlyQualifiedFulfillmentIDs;
		}

		// Return the results
		return qualificationDetails;
	}

	private void function getQualifierQualificationDetailsForOrder(required any qualifier, required any order, required struct qualifierDetails, array orderQualifierMessages){
		// Set the qualification count to 1 because that is the max for an order qualifier
		arguments.qualifierDetails.qualificationCount = 0;

		if( arguments.qualifier.hasOrderByOrderID( arguments.order.getOrderID() ) ){
			arguments.qualifierDetails.qualificationCount = 1;
		}else if(structKeyExists(arguments,'orderQualifierMessages')){
			for(var promoQualifierMessage in arguments.qualifier.getPromotionQualifierMessages()){

				if(promoQualifierMessage.hasOrderByOrderID( arguments.order.getOrderID() )){
					arrayAppend(arguments.orderQualifierMessages, promoQualifierMessage);
				}
			}
		}
	}

	private void function getQualifierQualificationDetailsForOrderFulfillments(required any qualifier, required any order, required struct qualifierDetails){
		// Set the qualification count to the total fulfillments
		arguments.qualifierDetails.qualificationCount = 0;
		arguments.qualifierDetails.qualifiedFulfillmentIDs = [];

		// Loop over each of the fulfillments to see if it qualifies
		for(var orderFulfillment in arguments.order.getOrderFulfillments()) {

			arguments.qualifierDetails.qualificationCount++;
			arrayAppend(arguments.qualifierDetails.qualifiedFulfillmentIDs, orderFulfillment.getOrderFulfillmentID());

			// Temp variable to be used by the next loop
			var addressZoneOK = true;

			// Because it requires a bit more logic, we check the shipping address zones first
			if(arrayLen(arguments.qualifier.getShippingAddressZones())) {

				// By default if there were address zones then we need to set to false
				addressZoneOk = false;

				// As long as this is a shipping fulfillment, and we have a real address, then we should be good to loop over each address zone
				if(orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "shipping" && !orderFulfillment.getAddress().getNewFlag()) {

					// Loop over each address zone, and check if this address is in one.
					for(var shippingAddressZone in arguments.qualifier.getShippingAddressZones()) {

						// If found set to true and stop looping
						if(getAddressService().isAddressInZone(orderFulfillment.getAddress(), shippingAddressZone) ) {
							addressZoneOk = true;
							break;
						}
					}
				}
			}

			// Now that we know about the address zone info, we can check everything else
			if( !addressZoneOk
				||
				( !isNull(arguments.qualifier.getMinimumFulfillmentWeight()) && arguments.qualifier.getMinimumFulfillmentWeight() > orderFulfillment.getTotalShippingWeight() )
				||
				( !isNull(arguments.qualifier.getMaximumFulfillmentWeight()) && arguments.qualifier.getMaximumFulfillmentWeight() < orderFulfillment.getTotalShippingWeight() )
				||
				( arrayLen(arguments.qualifier.getFulfillmentMethods()) && !arguments.qualifier.hasFulfillmentMethod(orderFulfillment.getFulfillmentMethod()) )
				||
				( arrayLen(arguments.qualifier.getShippingMethods()) && (isNull(orderFulfillment.getShippingMethod()) || !arguments.qualifier.hasShippingMethod(orderFulfillment.getShippingMethod())) )
				||
				( arrayLen(arguments.qualifier.getShippingAddressZones()) && (orderFulfillment.getAddress().getNewFlag() || !arguments.qualifier.hasShippingMethod(orderFulfillment.getShippingMethod())) )
				) {

				// Set the qualification count to the total fulfillments
				arguments.qualifierDetails.qualificationCount--;
				var di = arrayFind(arguments.qualifierDetails.qualifiedFulfillmentIDs, orderFulfillment.getOrderFulfillmentID());
				arrayDeleteAt(arguments.qualifierDetails.qualifiedFulfillmentIDs, di);
			}
		}
	}

	private void function getQualifierQualificationDetailsForOrderItems(required any qualifier, required any order, required struct qualifierDetails, array orderQualifierMessages){
		// Set the qualification count to the total fulfillments
		arguments.qualifierDetails.qualificationCount = 0;
		var qualifiedItemsQuantity = 0;

		for(var orderItem in arguments.order.getOrderItems()) {

			var qualifiedOrderItemDetails = {
				orderItem = orderItem,
				qualificationCount = 0
			};

			if( getOrderItemInQualifier(qualifier=arguments.qualifier, orderItem=orderItem) ){
				qualifiedOrderItemDetails.qualificationCount = orderItem.getQuantity();
				qualifiedItemsQuantity += orderItem.getQuantity();

				// Add this orderItem to the array
				arrayAppend(arguments.qualifierDetails.qualifiedOrderItemDetails, qualifiedOrderItemDetails);

			}

		}

		// As long as the above leaves this as still > 0
		if(qualifiedItemsQuantity gt 0) {
			// Lastly if there was a minimumItemQuantity then we can make this qualification based on the quantity ordered divided by minimum
			if( !isNull(arguments.qualifier.getMinimumItemQuantity()) && arguments.qualifier.getMinimumItemQuantity() != 0) {

				arguments.qualifierDetails.qualificationCount = int(qualifiedItemsQuantity / arguments.qualifier.getMinimumItemQuantity() );
			}else if(isNull(arguments.qualifier.getMinimumItemQuantity()) || arguments.qualifier.getMinimumItemQuantity() == 0){
				arguments.qualifierDetails.qualificationCount++;
			}
		}else if(structKeyExists(arguments,'orderQualifierMessages')){
			for(var promoQualifierMessage in arguments.qualifier.getPromotionQualifierMessages()){
				if(promoQualifierMessage.hasOrderByOrderID( arguments.order.getOrderID() )){
					arrayAppend(arguments.orderQualifierMessages, promoQualifierMessage);
				}
			}
		}

	}

	private struct function getQualifierQualificationDetails(required any qualifier, required any order, array orderQualifierMessages) {
		
		if(!structKeyExists(arguments,'orderQualifierMessages')){
			arguments['orderQualifierMessages'] = [];
		}
		
		var qualifierDetails = {
			qualifier = arguments.qualifier,
			qualificationCount = 0,
			qualifiedFulfillmentIDs = [],
			qualifiedOrderItemDetails = []
		};

		// ORDER
		if(arguments.qualifier.getQualifierType() == "order") {
			getQualifierQualificationDetailsForOrder(arguments.qualifier, arguments.order, qualifierDetails, arguments.orderQualifierMessages);

		// FULFILLMENT
		} else if (arguments.qualifier.getQualifierType() == "fulfillment") {
			getQualifierQualificationDetailsForOrderFulfillments(arguments.qualifier, arguments.order, qualifierDetails);

		// ORDER ITEM
		} else if (listFindNoCase("contentAccess,merchandise,subscription", arguments.qualifier.getQualifierType())) {
			getQualifierQualificationDetailsForOrderItems(arguments.qualifier,arguments.order,qualifierDetails, arguments.orderQualifierMessages);

		}

		return qualifierDetails;
	}

	private string function getPromotionPeriodQualifiedFulfillmentIDList(required any promotionPeriod, required any order) {
		var qualifiedFulfillmentIDs = "";

		for(var f=1; f<=arrayLen(arguments.order.getOrderFulfillments()); f++) {
			qualifiedFulfillmentIDs = listAppend(qualifiedFulfillmentIDs, arguments.order.getOrderFulfillments()[f].getOrderFulfillmentID());
		}

		// Loop over Qualifiers looking for fulfillment qualifiers
		for(var q=1; q<=arrayLen(arguments.promotionPeriod.getPromotionQualifiers()); q++) {

			var qualifier = arguments.promotionPeriod.getPromotionQualifiers()[q];

			if(qualifier.getQualifierType() == "fulfillment") {

				// Loop over fulfillments to see if it qualifies, and if so add to the list
				for(var f=1; f<=arrayLen(arguments.order.getOrderFulfillments()); f++) {
					var orderFulfillment = arguments.order.getOrderFulfillments()[f];
					if( (!isNull(qualifier.getMinimumFulfillmentWeight()) && qualifier.getMinimumFulfillmentWeight() > orderFulfillment.getTotalShippingWeight() )
						||
						(!isNull(qualifier.getMaximumFulfillmentWeight()) && qualifier.getMaximumFulfillmentWeight() < orderFulfillment.getTotalShippingWeight() )
						) {

						qualifiedFulfillmentIDs = ListDeleteAt(qualifiedFulfillmentIDs, listFindNoCase(qualifiedFulfillmentIDs, orderFulfillment.getOrderFulfillmentID()) );
					}
				}
			}
		}

		return qualifiedFulfillmentIDs;
	}

	private numeric function getPromotionPeriodOrderItemQualificationCount(required any promotionPeriod, required any orderItem, required any order) {
		// Setup the allQualifiersCount to the totalSaleQuantity, that way if there are no item qualifiers then every item quantity qualifies
		var allQualifiersCount = arguments.order.getTotalSaleQuantity();

		// Loop over Qualifiers looking for fulfillment qualifiers
		for(var q=1; q<=arrayLen(arguments.promotionPeriod.getPromotionQualifiers()); q++) {

			var qualifier = arguments.promotionPeriod.getPromotionQualifiers()[q];
			var qualifierCount = 0;

			// Check to make sure that this is an orderItem type of qualifier
			if(listFindNoCase("merchandise,subscription,contentAccess", qualifier.getQualifierType())) {
				
				// Loop over the orderItems and see how many times this item has been qualified
				var orderItemCollectionList = arguments.order.getOrderItemsCollectionList();
				orderItemCollectionList.setDisplayProperties('quantity,price,sku.skuID,sku.product.productID,sku.product.productType.productTypeID,sku.product.brand.brandID');
				var orderItems = orderItemCollectionList.getRecords(formatRecords=false);
				var numRecords = arrayLen(orderItems);
				
				for(var i=1; i<=numRecords; i++) {

					// Setup a local var for this orderItem
					
					var thisOrderItem = orderItems[i];
					var orderItemQualifierCount = thisOrderItem['quantity'];

					// First we run an "if" to see if this doesn't qualify for any reason and if so then set the count to 0
					if(
						!getOrderItemInQualifier(qualifier=qualifier, orderItem=thisOrderItem)
						||
						// Then check the match type of based on the current orderitem, and the orderItem we are getting a count for
						( qualifier.getRewardMatchingType() == "sku" && thisOrderItem['sku_skuID'] != arguments.orderItem.getSku().getSkuID() )
						||
						( qualifier.getRewardMatchingType() == "product" && thisOrderItem['sku_product_productID'] != arguments.orderItem.getSku().getProduct().getProductID() )
						||
						( qualifier.getRewardMatchingType() == "productType" && thisOrderItem['sku_product_productType_productTypeID'] != arguments.orderItem.getSku().getProduct().getProductType().getProductTypeID() )
						||
						( qualifier.getRewardMatchingType() == "brand" && isNull(thisOrderItem['sku_product_brand_brandID']))
						||
						( qualifier.getRewardMatchingType() == "brand" && isNull(arguments.orderItem.getSku().getProduct().getBrand()))
						||
						( qualifier.getRewardMatchingType() == "brand" && thisOrderItem['sku_product_brand_brandID'] != arguments.orderItem.getSku().getProduct().getBrand().getBrandID() )
						) {

						orderItemQualifierCount = 0;

					}

					qualifierCount += orderItemQualifierCount;

				}
				
				// Lastly if there was a minimumItemQuantity then we can make this qualification based on the quantity ordered divided by minimum
				if( !isNull(qualifier.getMinimumItemQuantity()) && qualifier.getMinimumItemQuantity() != 0 ) {
					qualifierCount = int(qualifierCount / qualifier.getMinimumItemQuantity() );
				}

				// If this particular qualifier has less qualifications than the previous, well use the lower of the two qualifier counts
				if(qualifierCount < allQualifiersCount) {
					allQualifiersCount = qualifierCount;
				}

				// If after this qualifier we show that it amounted to 0, then we return 0 because the item doesn't meet all qualifiacitons
				if(allQualifiersCount <= 0) {
					return 0;
				}

			}

		}

		return allQualifiersCount;
	}


	public boolean function getOrderItemInQualifier(required any qualifier, required any orderItem) {
		if(!isObject(arguments.orderItem)){
			var qualifierHasSku = arguments.qualifier.hasSkuBySkuID(arguments.orderItem['sku_skuID']);
			var price = arguments.orderItem['price'];
		}else{
			var qualifierHasSku = arguments.qualifier.hasOrderItemSku(arguments.orderItem);
			var price = arguments.orderItem.getPrice();
		}
		return (
			qualifierHasSku 
			&&
			( isNull(arguments.qualifier.getMinimumItemPrice()) || arguments.qualifier.getMinimumItemPrice() <= price )
			&&
			( isNull(arguments.qualifier.getMaximumItemPrice()) || arguments.qualifier.getMaximumItemPrice() >= price )
		);
		
	}

	public boolean function getOrderItemInReward(required any reward, required any orderItem) {
		return arguments.reward.hasOrderItemSku(arguments.orderItem);
	}

	private numeric function getDiscountAmount(required any reward, numeric price=0, required numeric quantity, string currencyCode, any sku, any account) {
		var discountAmountPreRounding = 0;
		var roundedFinalAmount = 0;
		var originalAmount = val(getService('HibachiUtilityService').precisionCalculate(arguments.price * arguments.quantity));

		var amountMethod = 'getAmount';
		var amountParams = {
			quantity:arguments.quantity
		};

		if(structKeyExists(arguments,'currencyCode') && len(arguments.currencyCode)){
			amountMethod &= 'ByCurrencyCode';
			amountParams['currencyCode'] = arguments.currencyCode;
		}
		if(structKeyExists(arguments,'sku')){
			amountParams['sku'] = arguments.sku;
		}
		if(structKeyExists(arguments,'account')){
			amountParams['account'] = arguments.account;
		}
		
		var rewardAmount = arguments.reward.invokeMethod(amountMethod,amountParams);

		if(!isNull(rewardAmount)){
			switch(reward.getAmountType()) {
				case "percentageOff" :
					discountAmountPreRounding = val(getService('HibachiUtilityService').precisionCalculate(originalAmount * (rewardAmount/100)));
					break;
				case "amountOff" :
					discountAmountPreRounding = rewardAmount * arguments.quantity;
					break;
				case "amount" :
					discountAmountPreRounding = val(getService('HibachiUtilityService').precisionCalculate((arguments.price - rewardAmount) * arguments.quantity));
					break;
	        }
		}else{
			discountAmountPreRounding = 0;
		}

		if(!isNull(reward.getRoundingRule())) {
			roundedFinalAmount = getRoundingRuleService().roundValueByRoundingRule(value=val(getService('HibachiUtilityService').precisionCalculate(originalAmount - discountAmountPreRounding)), roundingRule=arguments.reward.getRoundingRule());
			var discountAmount = val(getService('HibachiUtilityService').precisionCalculate(originalAmount - roundedFinalAmount));
		} else {
			var discountAmount = discountAmountPreRounding;
		}

		// This makes sure that the discount never exceeds the original amount
		if(discountAmountPreRounding > originalAmount) {
			discountAmount = originalAmount;
		}

		return numberFormat(discountAmount, "0.00");
	}

	// ----------------- END: Apply Promotion Logic -------------------------

	public struct function getSalePriceDetailsForProductSkus(required string productID, string currencyCode) {
		var args = {productID=arguments.productID};
		if(!isNull(arguments.currencyCode)){
			args.currencyCode = arguments.currencyCode;
		}

		var priceDetails = getProductSkuSalePricesByPromoRewardSkuCollection( argumentCollection=args );

		priceDetails = getRoundedPriceDetails(priceDetails);

		return priceDetails;
	}

	public struct function getSalePriceDetailsForOrderItem(required any orderItem) {

		var priceDetails = getOrderItemSalePricesByPromoRewardSkuCollection( arguments.orderItem );

		priceDetails = getRoundedPriceDetails(priceDetails);

		return priceDetails;
	}

	public struct function getRoundedPriceDetails(required struct priceDetails){
		for(var key in arguments.priceDetails) {
			if(arguments.priceDetails[key].roundingRuleID != "") {
				arguments.priceDetails[key].salePrice = getRoundingRuleService().roundValueByRoundingRuleID(value=arguments.priceDetails[key].salePrice, roundingRuleID=arguments.priceDetails[key].roundingRuleID);
			}
		}
		return arguments.priceDetails;
	}

	public struct function getProductSkuSalePricesByPromoRewardSkuCollection( required string productID, string currencyCode ){
		var product = getService('productService').getProduct( arguments.productID );
		var activePromotionRewardsWithSkuCollection = getPromotionDAO().getActivePromotionRewards( rewardTypeList="merchandise,subscription,contentAccess,rewardSku", promotionCodeList="", onlyRewardsWithSkuCollections=true, excludeRewardsWithQualifiers=true, site=getHibachiScope().getCart().getOrderCreatedSite() );

		var skus = product.getSkus();
		var priceDetails = {};
		
		for(var sku in skus){
			var currencyCode = arguments.currencyCode;
			if(!isNull(currencyCode)){
				var originalPrice = sku.getPriceByCurrencyCode(arguments.currencyCode);
			}else{
				var originalPrice = sku.getPrice();
				currencyCode = '';
			}
			var skuPriceDetails = getPriceDetailsForPromoRewards(
														promoRewards=activePromotionRewardsWithSkuCollection,
														sku=sku,
														originalPrice=originalPrice,
														currencyCode=currencyCode);
			structAppend(priceDetails,{'#sku.getSkuID()#':skuPriceDetails});
		}
		return priceDetails;
	}

	public struct function getOrderItemSalePricesByPromoRewardSkuCollection(required any orderItem){
		
		var activePromotionRewardsWithSkuCollection = getPromotionDAO().getActivePromotionRewards( rewardTypeList="merchandise,subscription,contentAccess,rewardSku", promotionCodeList="", excludeRewardsWithQualifiers=true, site=arguments.orderItem.getOrder().getOrderCreatedSite());
		var originalPrice = arguments.orderItem.getSkuPrice();
		var currencyCode = arguments.orderItem.getCurrencyCode();
		if(isNull(currencyCode)){
			currencyCode = arguments.orderItem.getOrder().getCurrencyCode();
		}
        
		if(isNull(originalPrice)){
			
			var account = arguments.orderItem.getOrder().getAccount();	
	        
	        /*
	            Price group is prioritized as so: 
	                1. Order price group
	                2. Price group passed in as argument, TODO ??
	                3. Price group on account
	                4. Default to 2
	        
	        */
	        
	        if(!isNull(arguments.orderItem.getOrder().getPriceGroup())){ 
	            var priceGroup = arguments.orderItem.getOrder().getPriceGroup(); //order price group
	        }else if(!isNull(account) && !isNull(account.getPriceGroups()) && arrayLen(account.getPriceGroups())){ 
	            var priceGroup = account.getPriceGroups()[1]; //account price group
	        }else{
	        	var priceGroup = getService('priceGroupService').getPriceGroupByPriceGroupCode(2) // default to retail
	        }
        
			originalPrice = arguments.orderItem.getSku().getPriceByCurrencyCode(currencyCode= currencyCode, priceGroups=[priceGroup]);
		} 


		var priceDetails = getPriceDetailsForPromoRewards( promoRewards=activePromotionRewardsWithSkuCollection,
														sku=arguments.orderItem.getSku(),
														originalPrice=originalPrice,
														currencyCode=currencyCode );

		return {'#arguments.orderItem.getOrderItemID()#':priceDetails};
	}

	public any function getOrderTemplateItemSalePricesByPromoRewardSkuCollection(required any orderTemplateItem){
		var orderTemplate = arguments.orderTemplateItem.getOrderTemplate();
		var activePromotionRewardsWithSkuCollection = getPromotionDAO().getActivePromotionRewards( rewardTypeList="merchandise,subscription,contentAccess,rewardSku", promotionCodeList="", excludeRewardsWithQualifiers=true, site=orderTemplate.getSite());
		
		var currencyCode = orderTemplate.getCurrencyCode();
		
		if(!isNull(orderTemplate.getAccount())){
			var originalPrice = arguments.orderTemplateItem.getSku().getPriceByCurrencyCode(currencyCode=currencyCode,accountID=orderTemplate.getAccount().getAccountID());
			if( isNull(originalPrice) ) return;
			var priceDetails = getPriceDetailsForPromoRewards( promoRewards=activePromotionRewardsWithSkuCollection,
															sku=arguments.orderTemplateItem.getSku(),
															originalPrice=originalPrice,
															currencyCode=currencyCode );
		}else if(!isNull(orderTemplate.getPriceGroup())){
			var originalPrice = arguments.orderTemplateItem.getSku().getPriceByCurrencyCode(currencyCode=currencyCode,priceGroups=[orderTemplate.getPriceGroup()] );
			if( isNull(originalPrice) ) return;
			var priceDetails = getPriceDetailsForPromoRewards( promoRewards=activePromotionRewardsWithSkuCollection,
															sku=arguments.orderTemplateItem.getSku(),
															originalPrice=originalPrice,
															currencyCode=currencyCode );
		}
		return {'#arguments.orderTemplateItem.getOrderTemplateItemID()#':priceDetails};
	}
	
	public struct function getPriceDetailsForPromoRewards(required array promoRewards, 
															required any sku,
															required string originalPrice,
															string currencyCode = ''){
		var priceDetails = {
			originalPrice:arguments.originalPrice,
			promotionID:'',
			roundingRuleID:'',
			salePrice:arguments.originalPrice,
			salePriceDiscountType:'',
			salePriceExpirationDateTime:''
		};
		var discountAmount = 0;
		for( var promoReward in arguments.promoRewards ){
			if( promoReward.hasSkuBySkuID( arguments.sku.getSkuID() ) ){
				var promoDiscountAmount = getDiscountAmount( promoReward, 
															arguments.originalPrice, 
															1,
															arguments.currencyCode,
															arguments.sku);
				if(promoDiscountAmount > discountAmount){
					discountAmount = promoDiscountAmount;
					priceDetails.promotionID = promoReward.getPromotionPeriod().getPromotion().getPromotionID();
					priceDetails.salePriceExpirationDateTime = promoReward.getPromotionPeriod().getEndDateTime();
					if(isNull(priceDetails.salePriceExpirationDateTime)){
						priceDetails.salePriceExpirationDateTime = '';
					}

					if(!isNull(promoReward.getRoundingRule())){
						priceDetails.roundingRuleID = promoReward.getRoundingRule().getRoundingRuleID();
					}

					var amountType = promoReward.getAmountType();
					priceDetails.salePriceDiscountType = amountType;
					priceDetails.salePrice = originalPrice - discountAmount;
				}
			}
		}

		return priceDetails;
	}

	public struct function getShippingMethodOptionsDiscountAmountDetails(required any shippingMethodOption) {
		var details = {
			promotionID="",
			discountAmount=0
		};

		var promotionPeriodQualifications = {};

		var promotionRewards = getPromotionDAO().getActivePromotionRewards( rewardTypeList="fulfillment", promotionCodeList=arguments.shippingMethodOption.getOrderFulfillment().getOrder().getPromotionCodeList(), site=arguments.shippingMethodOption.getOrderFulfillment().getOrder().getOrderCreatedSite() );

		// Loop over the Promotion Rewards to look for the best discount
		for(var i=1; i<=arrayLen(promotionRewards); i++) {

			var reward = promotionRewards[i];

			// Setup the boolean for if the promotionPeriod is okToApply based on general use count
			if(!structKeyExists(promotionPeriodQualifications, reward.getPromotionPeriod().getPromotionPeriodID())) {
				promotionPeriodQualifications[ reward.getPromotionPeriod().getPromotionPeriodID() ] = getPromotionPeriodQualificationDetails(promotionPeriod=reward.getPromotionPeriod(), order=arguments.shippingMethodOption.getOrderFulfillment().getOrder());
			}

			// If this promotion period is ok to apply based on general useCount
			if(promotionPeriodQualifications[ reward.getPromotionPeriod().getPromotionPeriodID() ].qualificationsMeet) {

				if( ( !arrayLen(reward.getFulfillmentMethods()) || reward.hasFulfillmentMethod(arguments.shippingMethodOption.getOrderFulfillment().getFulfillmentMethod()) )
					&&
					( !arrayLen(reward.getShippingMethods()) || reward.hasShippingMethod(arguments.shippingMethodOption.getShippingMethodRate().getShippingMethod()) ) ) {

					var addressIsInZone = true;
					if(arrayLen(reward.getShippingAddressZones())) {
						addressIsInZone = false;
						for(var az=1; az<=arrayLen(reward.getShippingAddressZones()); az++) {
							if(getAddressService().isAddressInZone(address=arguments.shippingMethodOption.getOrderFulfillment().getAddress(), addressZone=reward.getShippingAddressZones()[az])) {
								addressIsInZone = true;
								break;
							}
						}
					}

					if(addressIsInZone) {
						var discountAmount = getDiscountAmount(reward, arguments.shippingMethodOption.getTotalCharge(), 1);

						if(discountAmount > details.discountAmount) {
							details.discountAmount = discountAmount;
							details.promotionID = reward.getPromotionPeriod().getPromotion().getPromotionID();
						}
					}

				}

			}

		}

		return details;
	}
	
	public boolean function getOrderQualifiesForCanPlaceOrderReward( required any order ){
		return getOrderQualifierDetailsForCanPlaceOrderReward( argumentCollection=arguments )['canPlaceOrder'];
	}

	public struct function getOrderQualifierDetailsForCanPlaceOrderReward( required any order ){
		var canPlaceOrderDetails = {
			'canPlaceOrder':true,
			'activePromotionRewards':[]
		};
		var promotionRewards = getPromotionDAO().getActivePromotionRewards(rewardTypeList="canPlaceOrder", qualificationRequired=true,promotionCodeList=arguments.order.getPromotionCodeList(), promotionEffectiveDateTime=now(),site=arguments.order.getOrderCreatedSite());
		var qualifierMessages = [];
		
		if(arraylen(promotionRewards)){
			
			canPlaceOrderDetails['canPlaceOrder'] = false;
			
			for(var promoReward in promotionRewards){
				
				arrayAppend(canPlaceOrderDetails['activePromotionRewards'], promoReward.getPromotionRewardID());
				
				var qualificationDetails = getPromotionPeriodQualificationDetails(promotionPeriod=promoReward.getPromotionPeriod(), order=arguments.order, orderQualifierMessages=qualifierMessages);
				if(qualificationDetails.qualificationsMeet){
					qualificationDetails['canPlaceOrder'] = true;
					return qualificationDetails; 
				}
			}
			
			if(arrayLen(qualifierMessages)){
				getHibachiScope().flushOrmSession();
				applyPromotionQualifierMessagesToOrder(arguments.order,qualifierMessages);
			}
		}
		return canPlaceOrderDetails; 
	}
	
	public array function getQualifiedPromotionRewardsForOrder( required any order ){
		var qualifiedPromotionRewards = [];
		var promotionEffectiveDateTime = now();
		if(arguments.order.getOrderStatusType().getSystemCode() != "ostNotPlaced" && !isNull(arguments.order.getOrderOpenDateTime())) {
			promotionEffectiveDateTime = arguments.order.getOrderOpenDateTime();
		}
		// Loop over all Potential Discounts that require qualifications
		var promotionRewards = getPromotionDAO().getActivePromotionRewards(rewardTypeList="merchandise,subscription,contentAccess,order,fulfillment,rewardSku", promotionCodeList=arguments.order.getPromotionCodeList(), qualificationRequired=true, promotionEffectiveDateTime=promotionEffectiveDateTime, site=arguments.order.getOrderCreatedSite());
		for(var promoReward in promotionRewards){
			var promoPeriod = promoReward.getPromotionPeriod();
			var qualificationDetails = getPromotionPeriodQualificationDetails( promoPeriod, arguments.order );
			if(qualificationDetails.qualificationsMeet){
				arrayAppend(qualifiedPromotionRewards,promoReward);
			}
		}
		return qualifiedPromotionRewards;
	}
	
	public array function getQualifiedPromotionRewardSkusForOrder( required any order, numeric pageRecordsShow=25, boolean formatRecords=false){
		var rewardSkus = [];
		var qualifiedPromotionRewards = this.getQualifiedPromotionRewardsForOrder( arguments.order );
		for(var promotionReward in qualifiedPromotionRewards){
			var skuCollection = promotionReward.getSkuCollection();
			if(!isNull(skuCollection)){
				skuCollection.setPageRecordsShow(arguments.pageRecordsShow);
				var skus = skuCollection.getPageRecords(formatRecords=arguments.formatRecords, refresh=true);
				var promoRewardStruct = {
					promotionRewardID=promotionReward.getPromotionRewardID(),
					amountType=promotionReward.getAmountType(),
					amount=promotionReward.getAmount()
				};
				for(var sku in skus){
					sku.promotionReward = promoRewardStruct;
				}
				arrayAppend(rewardSkus,skus,true);
			}
		}
		return rewardSkus;
	}

	public string function getQualifiedFreePromotionRewardSkuIDs( required any order ){
		var qualifiedFreePromotionRewardSkuIDList = '';	
		var qualifiedPromotionRewards = this.getQualifiedPromotionRewardsForOrder( arguments.order );
		
		for(var promotionReward in qualifiedPromotionRewards){
			var skuCollection = promotionReward.getSkuCollection();
		
			if(isNull(skuCollection)){
				continue; 
			}
			
			if( promotionReward.getAmountType() == 'percentageOff' && 
			    promotionReward.getAmount() != 100
			){
				continue; 
			}
	
			if( promotionReward.getAmountType() == 'amount' && 
			    promotionReward.getAmount() > 0
			){
				continue; 
			} 
			
			qualifiedFreePromotionRewardSkuIDList = listAppend(qualifiedFreePromotionRewardSkuIDList, skuCollection.getPrimaryIDList())	
		}
		return qualifiedFreePromotionRewardSkuIDList;  
	}

	public struct function getQualifiedPromotionRewardSkuCollectionConfigForOrder( required any order ){ 
		var masterSkuCollection = getSkuService().getSkuCollectionList(); 
		var qualifiedPromotionRewards = this.getQualifiedPromotionRewardsForOrder( arguments.order );
	
		var filterGroupIndex = 1; 
	
		for(var promotionReward in qualifiedPromotionRewards){
			if(isNull(promotionReward.getSkuCollection())){
				continue; 
			} 

			var skuCollectionConfig = promotionReward.getSkuCollection().getCollectionConfigStruct();
	
			filterGroupIndex = masterSkuCollection.addFilterGroupWithAlias('promoReward' & promotionReward.getPromotionRewardID(), 'OR');
			
			var innerFiltersOrFilterGroups = skuCollectionConfig['filterGroups'][1]['filterGroup'];
	
			for(var innerFilterOrFilterGroup in innerFiltersOrFilterGroups){
				this.logHibachi('promotion reward #promotionReward.getPromotionRewardID()# innerFilterGroup #serializeJson(innerFilterOrFilterGroup)#');
				arrayAppend(masterSkuCollection.getCollectionConfigStruct()['filterGroups'][filterGroupIndex]['filterGroup'], innerFilterOrFilterGroup);
			} 
		} 

		return masterSkuCollection.getCollectionConfigStruct();
	}  
	
	public any function getQualifiedPromotionRewardSkuIDsForOrder( required any order, numeric pageRecordsShow=25, boolean formatRecords=false){
		var rewardSkuIDs = "";
		var qualifiedPromotionRewards = this.getQualifiedPromotionRewardsForOrder( arguments.order );
		for(var promotionReward in qualifiedPromotionRewards){
			var skuCollection = promotionReward.getSkuCollection();
			if(!isNull(skuCollection)){
				skuCollection.setPageRecordsShow(arguments.pageRecordsShow);
				var skus = skuCollection.getPageRecords(formatRecords=arguments.formatRecords, refresh=true);
				
				if (isArray(skus)){
					for(var sku in skus){
						rewardSkuIDs = listAppend(rewardSkuIDs, sku['skuID']);
					}
				}else if (isStruct(skus)){
					rewardSkuIDs = listAppend(rewardSkuIDs, skus['skuID']);
				}
				
			}
		}
		
		return rewardSkuIDs;
	}
	
	public void function processAfterAddOrderItemPromotions(required any order, required boolean ormHasflushed){

		var freeItemsPromoHasRan = getHibachiScope().hasValue('afterOrderItemPromoHasRan') && getHibachiScope().getValue('afterOrderItemPromoHasRan');
		var orderHasErrors = arguments.order.hasErrors();
		
		if(freeItemsPromoHasRan || orderHasErrors || getHibachiScope().ORMHasErrors()){
			return;
		}else{
			arguments.order.clearProcessObject("addOrderItem");
			getHibachiScope().setValue('afterOrderItemPromoHasRan', true);
		}
		
		if(!arguments.ormHasflushed){
			getHibachiScope().flushORMSession();
		}
		
		for(var item in getHibachiScope().getValue('promoItemsToBeAdded')){
			if(item.orderID != arguments.order.getOrderID()){
				continue;
			}
			
	        arguments.order = getService("OrderService").processOrder( arguments.order, item, 'addOrderItem');
        	getHibachiScope().addActionResult( "public:cart.addOrderItem", arguments.order.hasErrors() );
			if(!arguments.order.hasErrors()){
				getHibachiScope().flushORMSession();
				arguments.order.clearProcessObject("addOrderItem");
			}
		}
	}
	
	// ===================== START: Logical Methods ===========================

	// =====================  END: Logical Methods ============================

	// ===================== START: DAO Passthrough ===========================

	public boolean function getPromotionCodeUseCount(required any promotionCode) {
		return getPromotionDAO().getPromotionCodeUseCount(argumentcollection=arguments);
	}

	public boolean function getPromotionCodeAccountUseCount(required any promotionCode, required any account) {
		return getPromotionDAO().getPromotionCodeAccountUseCount(argumentcollection=arguments);
	}

	public any function getPromotionCodeByPromotionCode(required string promotionCode) {
		return getPromotionDAO().getPromotionCodeByPromotionCode(argumentcollection=arguments);
	}

	// ===================== START: DAO Passthrough ===========================

	// ===================== START: Process Methods ===========================

	public any function processPromotionPeriod_duplicatePromotionPeriod(required any promotionPeriod, required any processObject){

		// Duplicate promotion period and set new values from process object
		var newPromotionPeriod = this.newPromotionPeriod();
		var newMessages = [];
		newPromotionPeriod.setPromotionPeriodName(arguments.processObject.getPromotionPeriodName());
		if(!isNull(arguments.processObject.getStartDateTime()) && len(arguments.processObject.getStartDateTime())) {
			newPromotionPeriod.setStartDateTime(arguments.processObject.getStartDateTime());
		}
		if(!isNull(arguments.processObject.getEndDateTime()) && len(arguments.processObject.getEndDateTime())) {
			newPromotionPeriod.setEndDateTime(arguments.processObject.getEndDateTime());
		}
		if(!isNull(arguments.processObject.getMaximumUseCount()) && len(arguments.processObject.getMaximumUseCount())) {
			newPromotionPeriod.setMaximumUseCount(arguments.processObject.getMaximumUseCount());
		}
		if(!isNull(arguments.processObject.getMaximumAccountUseCount()) && len(arguments.processObject.getMaximumAccountUseCount())) {
			newPromotionPeriod.setMaximumAccountUseCount(arguments.processObject.getMaximumAccountUseCount());
		}
		newPromotionPeriod.setPromotion(arguments.promotionPeriod.getPromotion());
		var newPromotionPeriod = this.savePromotionPeriod(newPromotionPeriod);

		// Duplicate promotionRewards
		for(var promotionReward in arguments.promotionPeriod.getPromotionRewards()){
			var newPromotionReward = this.newPromotionReward();
			newPromotionReward.setAmount(promotionReward.getAmount());
			newPromotionReward.setCurrencyCode(promotionReward.getCurrencyCode());
			newPromotionReward.setAmountType(promotionReward.getAmountType());
			newPromotionReward.setRewardType(promotionReward.getRewardType());
			newPromotionReward.setApplicableTerm(promotionReward.getApplicableTerm());
			newPromotionReward.setMaximumUsePerOrder(promotionReward.getMaximumUsePerOrder());
			newPromotionReward.setMaximumUsePerItem(promotionReward.getMaximumUsePerItem());
			newPromotionReward.setMaximumUsePerQualification(promotionReward.getMaximumUsePerQualification());
			if(!isNull(promotionReward.getRoundingRule())) {
				newPromotionReward.setRoundingRule(promotionReward.getRoundingRule());
			}
			if(arrayLen(promotionReward.getPromotionRewardCurrencies())) {
				for(var promotionRewardCurrency in promotionReward.getPromotionRewardCurrencies()) {
					newPromotionReward.addPromotionRewardCurrency(promotionRewardCurrency);
				}
			}
			if(arrayLen(promotionReward.getEligiblePriceGroups())) {
				for(var eligiblePriceGroup in promotionReward.getEligiblePriceGroups()) {
					newPromotionReward.addEligiblePriceGroup(eligiblePriceGroup);
				}
			}
			if(arrayLen(promotionReward.getFulfillmentMethods())) {
				for(var fulfillmentMethod in promotionReward.getFulfillmentMethods()) {
					newPromotionReward.addFulfillmentMethod(fulfillmentMethod);
				}
			}
			if(arrayLen(promotionReward.getShippingAddressZones())) {
				for(var shippingAddressZone in promotionReward.getShippingAddressZones()) {
					newPromotionReward.addShippingAddressZone(shippingAddressZone);
				}
			}
			if(arrayLen(promotionReward.getShippingMethods())) {
				for(var shippingMethod in promotionReward.getShippingMethods()) {
					newPromotionReward.addShippingMethod(shippingMethod);
				}
			}
			if(arrayLen(promotionReward.getBrands())) {
				for(var brand in promotionReward.getBrands()) {
					newPromotionReward.addBrand(brand);
				}
			}
			if(arrayLen(promotionReward.getOptions())) {
				for(var option in promotionReward.getOptions()) {
					newPromotionReward.addOption(option);
				}
			}
			if(arrayLen(promotionReward.getSkus())) {
				for(var sku in promotionReward.getSkus()) {
					newPromotionReward.addSku(sku);
				}
			}
			if(arrayLen(promotionReward.getProducts())) {
				for(var product in promotionReward.getProducts()) {
					newPromotionReward.addProduct(product);
				}
			}
			if(arrayLen(promotionReward.getProductTypes())) {
				for(var productType in promotionReward.getProductTypes()) {
					newPromotionReward.addProductType(productType);
				}
			}
			if(arrayLen(promotionReward.getExcludedBrands())) {
				for(var excludedBrand in promotionReward.getExcludedBrands()) {
					newPromotionReward.addExcludedBrand(excludedBrand);
				}
			}
			if(arrayLen(promotionReward.getExcludedOptions())) {
				for(var excludedOption in promotionReward.getExcludedOptions()) {
					newPromotionReward.addExcludedOption(excludedOption);
				}
			}
			if(arrayLen(promotionReward.getExcludedSkus())) {
				for(var excludedSkus in promotionReward.getExcludedSkus()) {
					newPromotionReward.addExcludedSkus(excludedSkus);
				}
			}
			if(arrayLen(promotionReward.getExcludedProducts())) {
				for(var excludedProduct in promotionReward.getExcludedProducts()) {
					newPromotionReward.addExcludedProduct(excludedProduct);
				}
			}
			if(arrayLen(promotionReward.getExcludedProductTypes())) {
				for(var excludedProductType in promotionReward.getExcludedProductTypes()) {
					newPromotionReward.addExcludedProductType(excludedProductType);
				}
			}
			
			if( !isNull( promotionReward.getExcludedSkusCollectionConfig() ) 
				&& len( promotionReward.getExcludedSkusCollectionConfig() ) ){
					newPromotionReward.setExcludedSkusCollectionConfig( promotionReward.getExcludedSkusCollectionConfig() );	
				} 
			if( !isNull(promotionReward.getIncludedSkusCollectionConfig() )
				&& len( promotionReward.getIncludedSkusCollectionConfig() ) ){
					newPromotionReward.setIncludedSkusCollectionConfig( promotionReward.getIncludedSkusCollectionConfig() );
				}
		
			newPromotionPeriod.addPromotionReward(newPromotionReward);
		}

		// Duplicate promotionQualifiers
		for(var promotionQualifier in arguments.promotionPeriod.getPromotionQualifiers()){
			var newpromotionQualifier = this.newpromotionQualifier();
			newpromotionQualifier.setQualifierType(promotionQualifier.getQualifierType());
			newpromotionQualifier.setMinimumOrderQuantity(promotionQualifier.getMinimumOrderQuantity());
			newpromotionQualifier.setMaximumOrderQuantity(promotionQualifier.getMaximumOrderQuantity());
			newpromotionQualifier.setMinimumOrderSubtotal(promotionQualifier.getMinimumOrderSubtotal());
			newpromotionQualifier.setMaximumOrderSubtotal(promotionQualifier.getMaximumOrderSubtotal());
			newpromotionQualifier.setMinimumItemQuantity(promotionQualifier.getMinimumItemQuantity());
			newpromotionQualifier.setMaximumItemQuantity(promotionQualifier.getMaximumItemQuantity());
			newpromotionQualifier.setMinimumItemPrice(promotionQualifier.getMinimumItemPrice());
			newpromotionQualifier.setMaximumItemPrice(promotionQualifier.getMaximumItemPrice());
			newpromotionQualifier.setMinimumFulfillmentWeight(promotionQualifier.getMinimumFulfillmentWeight());
			newpromotionQualifier.setMaximumFulfillmentWeight(promotionQualifier.getMaximumFulfillmentWeight());
			newpromotionQualifier.setRewardMatchingType(promotionQualifier.getRewardMatchingType());
			if(arrayLen(promotionQualifier.getFulFillmentMethods())) {
				for(var fulFillmentMethod in promotionQualifier.getFulFillmentMethods()) {
					newpromotionQualifier.addFulFillmentMethod(fulFillmentMethod);
				}
			}
			if(arrayLen(promotionQualifier.getShippingMethods())) {
				for(var shippingMethod in promotionQualifier.getShippingMethods()) {
					newpromotionQualifier.addShippingMethod(shippingMethod);
				}
			}
			if(arrayLen(promotionQualifier.getShippingAddressZones())) {
				for(var shippingAddressZone in promotionQualifier.getShippingAddressZones()) {
					newpromotionQualifier.addShippingAddressZone(shippingAddressZone);
				}
			}
			if(arrayLen(promotionQualifier.getBrands())) {
				for(var brand in promotionQualifier.getBrands()) {
					newpromotionQualifier.addBrand(brand);
				}
			}
			if(arrayLen(promotionQualifier.getOptions())) {
				for(var option in promotionQualifier.getOptions()) {
					newpromotionQualifier.addOption(option);
				}
			}
			if(arrayLen(promotionQualifier.getSkus())) {
				for(var sku in promotionQualifier.getSkus()) {
					newpromotionQualifier.addSku(sku);
				}
			}
			if(arrayLen(promotionQualifier.getProducts())) {
				for(var product in promotionQualifier.getProducts()) {
					newpromotionQualifier.addProduct(product);
				}
			}
			if(arrayLen(promotionQualifier.getProductTypes())) {
				for(var productType in promotionQualifier.getProductTypes()) {
					newpromotionQualifier.addProductType(productType);
				}
			}
			if(arrayLen(promotionQualifier.getExcludedBrands())) {
				for(var excludedBrand in promotionQualifier.getExcludedBrands()) {
					newpromotionQualifier.addExcludedBrand(excludedBrand);
				}
			}
			if(arrayLen(promotionQualifier.getExcludedOptions())) {
				for(var excludedOption in promotionQualifier.getExcludedOptions()) {
					newpromotionQualifier.addExcludedOption(excludedOption);
				}
			}
			if(arrayLen(promotionQualifier.getExcludedSkus())) {
				for(var excludedSku in promotionQualifier.getExcludedSkus()) {
					newpromotionQualifier.addExcludedSku(excludedSku);
				}
			}
			if(arrayLen(promotionQualifier.getExcludedProducts())) {
				for(var excludedProduct in promotionQualifier.getExcludedProducts()) {
					newpromotionQualifier.addExcludedProduct(excludedProduct);
				}
			}
			if(arrayLen(promotionQualifier.getExcludedProductTypes())) {
				for(var excludedProductType in promotionQualifier.getExcludedProductTypes()) {
					newpromotionQualifier.addExcludedProductType(excludedProductType);
				}
			}
			
			if(arrayLen(promotionQualifier.getPromotionQualifierMessages())) {
				for(var originalMessage in promotionQualifier.getPromotionQualifierMessages()) {
					var newMessage = this.newPromotionQualifierMessage();
					newMessage.setMessage(originalMessage.getMessage());
					newMessage.setMessageRequirementsCollectionConfig(originalMessage.getMessageRequirementsCollectionConfig());
					newMessage.setPriority(originalMessage.getPriority());
					newMessage.setQualifierProgressTemplate(originalMessage.getQualifierProgressTemplate());
					newMessage.setPromotionQualifier(newpromotionQualifier);
					arrayAppend(newMessages, newMessage);
				}
			}			
			if(!isNull(promotionQualifier.getIncludedOrdersCollectionConfig()) && len(promotionQualifier.getIncludedOrdersCollectionConfig()) ) newpromotionQualifier.setIncludedOrdersCollectionConfig(promotionQualifier.getIncludedOrdersCollectionConfig());
			if(!isNull(promotionQualifier.getExcludedOrdersCollectionConfig()) && len(promotionQualifier.getExcludedOrdersCollectionConfig())  ) newpromotionQualifier.setExcludedOrdersCollectionConfig(promotionQualifier.getExcludedOrdersCollectionConfig());
			if(!isNull(promotionQualifier.getExcludedSkusCollectionConfig()) && len(promotionQualifier.getExcludedSkusCollectionConfig()) ) newpromotionQualifier.setExcludedSkusCollectionConfig(promotionQualifier.getExcludedSkusCollectionConfig());
			if(!isNull(promotionQualifier.getIncludedSkusCollectionConfig()) && len(promotionQualifier.getIncludedSkusCollectionConfig()) ) newpromotionQualifier.setIncludedSkusCollectionConfig(promotionQualifier.getIncludedSkusCollectionConfig());
			newPromotionPeriod.addPromotionQualifier(newpromotionQualifier);
		}
		
		if(!newPromotionPeriod.hasErrors()){
			this.savePromotionPeriod(newPromotionPeriod);
			for(var message in newMessages){
				this.savePromotionQualifierMessage(message);
			}
			getHibachiScope().flushOrmSession();
			var copyFromList = [];
			var index = 1;
			
			for(var reward in arguments.promotionPeriod.getPromotionRewards()){
				arrayAppend(copyFromList, reward.getPromotionRewardID());
			}

			for(var reward in newPromotionPeriod.getPromotionRewards()){
				getPromotionDAO().cloneAndInsertIncludedStackableRewards(copyFromID = copyFromList[index], newPromoRewardID = reward.getPromotionRewardID());
				index++;
			}
			
		}

		return newPromotionPeriod;
	}

	public any function processPromotionPeriod_endPromotionPeriod(required any promotionPeriod, required any processObject){

		if(!isNull(arguments.processObject.getEndDateTime()) && len(arguments.processObject.getEndDateTime())) {
			arguments.promotionPeriod.setEndDateTime(arguments.processObject.getEndDateTime());
		}
		
		this.savePromotionPeriod(arguments.promotionPeriod);

		return arguments.promotionPeriod;
	}

	// =====================  END: Process Methods ============================

	// ====================== START: Status Methods ===========================

	// ======================  END: Status Methods ============================

	// ====================== START: Save Overrides ===========================

	// ======================  END: Save Overrides ============================

	// ==================== START: Smart List Overrides =======================

	// ====================  END: Smart List Overrides ========================

	// ====================== START: Get Overrides ============================

	// ======================  END: Get Overrides =============================

}
