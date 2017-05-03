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

	private void function clearPreviouslyAppliedPromotionsForOrderItems(required array orderItems){
		// Clear all previously applied promotions for order items
		for(var oi=1; oi<=arrayLen(arguments.orderItems); oi++) {
			for(var pa=arrayLen(arguments.orderItems[oi].getAppliedPromotions()); pa >= 1; pa--) {
				arguments.orderItems[oi].getAppliedPromotions()[pa].removeOrderItem();
			}
		}
	}

	private void function clearPreviouslyAppliedPromotionsForOrderFulfillments(required array orderFulfillments){
		// Clear all previously applied promotions for fulfillment
		for(var of=1; of<=arrayLen(arguments.orderFulfillments); of++) {
			for(var pa=arrayLen(arguments.orderFulfillments[of].getAppliedPromotions()); pa >= 1; pa--) {
				arguments.orderFulfillments[of].getAppliedPromotions()[pa].removeOrderFulfillment();
			}
		}
	}

	private void function clearPreviouslyAppliedPromotionsForOrder(required any order){
		// Clear all previously applied promotions for order
		for(var pa=arrayLen(arguments.order.getAppliedPromotions()); pa >= 1; pa--) {
			arguments.order.getAppliedPromotions()[pa].removeOrder();
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
				maximumUsePerOrder = 1000000,
				maximumUsePerItem = 1000000,
				maximumUsePerQualification = 1000000,
				orderItemsUsage = []
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
			var salePriceDetails = orderItem.getSalePrice();

			for(var key in salePriceDetails) {
				if(structKeyExists(salePriceDetails[key], "salePrice") && salePriceDetails[key].salePrice < orderItem.getSkuPrice()) {

					var discountAmount = getService('HibachiUtilityService').precisionCalculate((orderItem.getSkuPrice() * orderItem.getQuantity()) - (salePriceDetails[key].salePrice * orderItem.getQuantity()));

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
						applyPromotionToOrderFulfillment(orderFulfillment,arguments.promotionReward.getPromotionPeriod().getPromotion(),discountAmount);
					}

				} // END: Address In Zone

			} // END: Method Match

		} // Loop
	}

	private void function processOrderItemRewards(required any order, required any promotionPeriodQualifications, required any promotionRewardUsageDetails, required any orderItemQualifiedDiscounts, required any promotionReward){
		// Loop over all the orderItems
		for(var orderItem in arguments.order.getOrderItems()) {

			// Verify that this is an item being sold
			if(orderItem.getOrderItemType().getSystemCode() == "oitSale") {

				// Make sure that this order item is in the acceptable fulfillment list
				if(arrayFind(arguments.promotionPeriodQualifications[arguments.promotionReward.getPromotionPeriod().getPromotionPeriodID()].qualifiedFulfillmentIDs, orderItem.getOrderFulfillment().getOrderFulfillmentID())) {

					// Now that we know the fulfillment is ok, lets check and cache then number of times this orderItem qualifies based on the promotionPeriod
					if(!structKeyExists(arguments.promotionPeriodQualifications[arguments.promotionReward.getPromotionPeriod().getPromotionPeriodID()].orderItems, orderItem.getOrderItemID())) {
						arguments.promotionPeriodQualifications[arguments.promotionReward.getPromotionPeriod().getPromotionPeriodID()].orderItems[ orderItem.getOrderItemID() ] = getPromotionPeriodOrderItemQualificationCount(promotionPeriod=arguments.promotionReward.getPromotionPeriod(), orderItem=orderItem, order=arguments.order);
					}

					// If the qualification count for this order item is > 0 then we can try to apply the reward
					if(arguments.promotionPeriodQualifications[arguments.promotionReward.getPromotionPeriod().getPromotionPeriodID()].orderItems[ orderItem.getOrderItemID() ]) {

						// Check the reward settings to see if this orderItem applies
						if( getOrderItemInReward(arguments.promotionReward, orderItem) ) {
							var qualificationQuantity = arguments.promotionPeriodQualifications[arguments.promotionReward.getPromotionPeriod().getPromotionPeriodID()].orderItems[ orderItem.getOrderItemID() ];
							if((qualificationQuantity * arguments.promotionRewardUsageDetails[ arguments.promotionReward.getPromotionRewardID() ].maximumUsePerQualification) lt arguments.promotionRewardUsageDetails[ arguments.promotionReward.getPromotionRewardID() ].maximumUsePerOrder) {
								arguments.promotionRewardUsageDetails[ arguments.promotionReward.getPromotionRewardID() ].maximumUsePerOrder = (qualificationQuantity * arguments.promotionRewardUsageDetails[ arguments.promotionReward.getPromotionRewardID() ].maximumUsePerQualification);
							}

							// setup the discountQuantity based on the qualification quantity.  If there were no qualification constrints than this will just be the orderItem quantity
							var discountQuantity = qualificationQuantity * arguments.promotionRewardUsageDetails[ arguments.promotionReward.getPromotionRewardID() ].maximumUsePerQualification;
							// If the discountQuantity is > the orderItem quantity then just set it to the orderItem quantity
							if(discountQuantity > orderItem.getQuantity()) {
								discountQuantity = orderItem.getQuantity();
							}

							// If the discountQuantity is > than maximumUsePerItem then set it to maximumUsePerItem
							if(discountQuantity > arguments.promotionRewardUsageDetails[ arguments.promotionReward.getPromotionRewardID() ].maximumUsePerItem) {
								discountQuantity = arguments.promotionRewardUsageDetails[ arguments.promotionReward.getPromotionRewardID() ].maximumUsePerItem;
							}
							// If there is not applied Price Group, or if this reward has the applied pricegroup as an eligible one then use priceExtended... otherwise use skuPriceExtended and then adjust the discount.
							if( isNull(orderItem.getAppliedPriceGroup()) || arguments.promotionReward.hasEligiblePriceGroup( orderItem.getAppliedPriceGroup() ) ) {

								// Calculate based on price, which could be a priceGroup price
								var discountAmount = getDiscountAmount(arguments.promotionReward, orderItem.getPrice(), discountQuantity,orderItem.getCurrencyCode());

							} else {

								// Calculate based on skuPrice because the price on this item is a priceGroup price and we need to adjust the discount by the difference
								var originalDiscountAmount = getDiscountAmount(arguments.promotionReward, orderItem.getSkuPrice(), discountQuantity);

								// Take the original discount they were going to get without a priceGroup and subtract the difference of the discount that they are already receiving
								var discountAmount = getService('HibachiUtilityService').precisionCalculate(originalDiscountAmount - (orderItem.getExtendedSkuPrice() - orderItem.getExtendedPrice()));

							}

							// If the discountAmount is gt 0 then we can add the details in order to the potential orderItem discounts

							if(discountAmount > 0) {

								// First thing that we are going to want to do is add this orderItem to the orderItemQualifiedDiscounts if it doesn't already exist
								if(!structKeyExists(orderItemQualifiedDiscounts, orderItem.getOrderItemID())) {
									// Set it as a blank array
									orderItemQualifiedDiscounts[ orderItem.getOrderItemID() ] = [];
								}

								// If there are already values in the array then figure out where to insert
								var discountAdded = false;
								// loop over any discounts that might be already in assigned and pick an index where the discount amount is best
								for(var d=1; d<=arrayLen(orderItemQualifiedDiscounts[ orderItem.getOrderItemID() ]) ; d++) {
									if(orderItemQualifiedDiscounts[ orderItem.getOrderItemID() ][d].discountAmount < discountAmount) {
										// Insert this value into the potential discounts array
										arrayInsertAt(orderItemQualifiedDiscounts[ orderItem.getOrderItemID() ], d, {
											promotionRewardID = arguments.promotionReward.getPromotionRewardID(),
											promotion = arguments.promotionReward.getPromotionPeriod().getPromotion(),
											discountAmount = discountAmount
										});

										discountAdded = true;
										break;
									}
								}

								if(!discountAdded) {
									// Insert this value into the potential discounts array
									arrayAppend(orderItemQualifiedDiscounts[ orderItem.getOrderItemID() ], {
										promotionRewardID = arguments.promotionReward.getPromotionRewardID(),
										promotion = arguments.promotionReward.getPromotionPeriod().getPromotion(),
										discountAmount = discountAmount
									});

								}

								// Increment the number of times this promotion reward has been used

								arguments.promotionRewardUsageDetails[ arguments.promotionReward.getPromotionRewardID() ].usedInOrder += discountQuantity;
								var discountPerUseValue = getService('HibachiUtilityService').precisionCalculate(discountAmount / discountQuantity);

								var usageAdded = false;

								// loop over any previous orderItemUsage of this reward an place it in ASC order based on discountPerUseValue
								for(var oiu=1; oiu<=arrayLen(arguments.promotionRewardUsageDetails[ arguments.promotionReward.getPromotionRewardID() ].orderItemsUsage) ; oiu++) {
									if(arguments.promotionRewardUsageDetails[ arguments.promotionReward.getPromotionRewardID() ].orderItemsUsage[oiu].discountPerUseValue > discountPerUseValue) {
										// Insert this value into the potential discounts array
										arrayInsertAt(arguments.promotionRewardUsageDetails[ arguments.promotionReward.getPromotionRewardID() ].orderItemsUsage, oiu, {
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

									arrayAppend(arguments.promotionRewardUsageDetails[ arguments.promotionReward.getPromotionRewardID() ].orderItemsUsage, {
										orderItemID = orderItem.getOrderItemID(),
										discountQuantity = discountQuantity,
										discountPerUseValue = discountPerUseValue
									});

								}

							}

						} // End OrderItem in reward IF

					} // End orderItem qualification count > 0

				} // End orderItem fulfillment in qualifiedFulfillment list

			} // END Sale Item If

		} // End Order Item For Loop
	}

	private void function processOrderRewards(required any order, required any promotionReward){
		var totalDiscountableAmount = arguments.order.getSubtotalAfterItemDiscounts() + arguments.order.getFulfillmentChargeAfterDiscountTotal();

		var discountAmount = getDiscountAmount(arguments.promotionReward, totalDiscountableAmount, 1, order.getCurrencyCode());

		var addNew = false;

		// First we make sure that the discountAmount is > 0 before we check if we should add more discount
		if(discountAmount > 0) {

			// If there aren't any promotions applied to this order fulfillment yet, then we can add this one
			if(!arrayLen(arguments.order.getAppliedPromotions())) {
				addNew = true;

			// If one has already been set then we just need to check if this new discount amount is greater
			} else if ( arguments.order.getAppliedPromotions()[1].getDiscountAmount() < discountAmount ) {

				// If the promotion is the same, then we just update the amount
				if(arguments.order.getAppliedPromotions()[1].getPromotion().getPromotionID() == arguments.promotionReward.getPromotionPeriod().getPromotion().getPromotionID()) {
					arguments.order.getAppliedPromotions()[1].setDiscountAmount(discountAmount);

				// If the promotion is a different then remove the original and set addNew to true
				} else {
					arguments.order.getAppliedPromotions()[1].removeOrder();
					addNew = true;
				}
			}
		}

		// Add the new appliedPromotion
		if(addNew) {
			applyPromotionToOrder(arguments.order,arguments.promotionReward.getPromotionPeriod().getPromotion(),discountAmount);
		}

	}

	public void function updateOrderAmountsWithPromotions(required any order) {

		// Set up a promotionEffectiveDateTime in case this is an order that has already been placed
		var promotionEffectiveDateTime = now();
		if(arguments.order.getOrderStatusType().getSystemCode() != "ostNotPlaced" && !isNull(arguments.order.getOrderOpenDateTime())) {
			promotionEffectiveDateTime = arguments.order.getOrderOpenDateTime();
		}

		// Sale & Exchange Orders
		if( listFindNoCase("otSalesOrder,otExchangeOrder", arguments.order.getOrderType().getSystemCode()) ) {

			clearPreviouslyAppliedPromotions(arguments.order);

			// This is a structure of promotionPeriods that will get checked and cached as to if we are still within the period use count, and period account use count
			var promotionPeriodQualifications = {};

			// This is a structure of promotionRewards that will hold information reguarding maximum usages, and the amount of usages applied
			var promotionRewardUsageDetails = {};

			// This is a structure of orderItems with all of the potential discounts that apply to them
			var orderItemQualifiedDiscounts = {};

			setupOrderItemQualifiedDiscounts(arguments.order, orderItemQualifiedDiscounts);

			// Loop over all Potential Discounts that require qualifications
			var promotionRewards = getPromotionDAO().getActivePromotionRewards(rewardTypeList="merchandise,subscription,contentAccess,order,fulfillment", promotionCodeList=arguments.order.getPromotionCodeList(), qualificationRequired=true, promotionEffectiveDateTime=promotionEffectiveDateTime);
			var orderRewards = false;

			for(var pr=1; pr<=arrayLen(promotionRewards); pr++) {
				var reward = promotionRewards[pr];
				// Setup the promotionReward usage Details. This will be used for the maxUsePerQualification & and maxUsePerItem up front, and then later to remove discounts that violate max usage
				setupPromotionRewardUsageDetails(reward,promotionRewardUsageDetails);

				// Setup the boolean for if the promotionPeriod is okToApply based on general use count
				if(!structKeyExists(promotionPeriodQualifications, reward.getPromotionPeriod().getPromotionPeriodID())) {
					promotionPeriodQualifications[ reward.getPromotionPeriod().getPromotionPeriodID() ] = getPromotionPeriodQualificationDetails(promotionPeriod=reward.getPromotionPeriod(), order=arguments.order);
				}

				// If this promotion period is ok to apply based on general useCount
				if(promotionPeriodQualifications[ reward.getPromotionPeriod().getPromotionPeriodID() ].qualificationsMeet) {
					// =============== Order Item Reward ==============
					if( !orderRewards and listFindNoCase("merchandise,subscription,contentAccess", reward.getRewardType()) ) {
						processOrderItemRewards(arguments.order, promotionPeriodQualifications, promotionRewardUsageDetails, orderItemQualifiedDiscounts, reward);

					// =============== Fulfillment Reward ======================
					} else if (!orderRewards and reward.getRewardType() eq "fulfillment" ) {
						processOrderFulfillmentRewards(arguments.order, promotionPeriodQualifications, Reward);
					// ================== Order Reward =========================
					} else if (orderRewards and reward.getRewardType() eq "order" ) {
						processOrderRewards(arguments.order, reward);
					} // ============= END ALL REWARD TYPES

				} // END Promotion Period OK IF

				// This forces the loop to repeat looking for "order" discounts
				if(!orderRewards and pr == arrayLen(promotionRewards)) {
					pr = 0;
					orderRewards = true;
				}

			} // END of PromotionReward Loop

			// Now that we has setup all the potential discounts for orderItems sorted by best price, we want to strip out any of the discounts that would exceed the maximum order use counts.
			removeDiscountsExceedingMaxOrderUseCounts(promotionRewardUsageDetails,orderItemQualifiedDiscounts);

			// Loop over the orderItems one last time, and look for the top 1 discounts that can be applied
			applyTop1Discounts(arguments.order,orderItemQualifiedDiscounts);

		} // END of Sale or Exchange Loop

		// Return & Exchange Orders
		if( listFindNoCase("otReturnOrder,otExchangeOrder", arguments.order.getOrderType().getSystemCode()) ) {
			// TODO [issue #1766]: In the future allow for return Items to have negative promotions applied.  This isn't import right now because you can determine how much you would like to refund ordersItems
		}

	}

	private void function applyPromotionToOrderFulfillment(required any orderFulfillment, required any promotion, required numeric discountAmount){
		var newAppliedPromotion = this.newPromotionApplied();
		newAppliedPromotion.setAppliedType('orderFulfillment');
		newAppliedPromotion.setPromotion( arguments.promotion );
		newAppliedPromotion.setOrderFulfillment( arguments.orderFulfillment );
		newAppliedPromotion.setDiscountAmount( arguments.discountAmount );
	}

	private void function applyPromotionToOrder(required any order,required any promotion, required numeric discountAmount){
		var newAppliedPromotion = this.newPromotionApplied();
		newAppliedPromotion.setAppliedType('order');
		newAppliedPromotion.setPromotion( arguments.promotion );
		newAppliedPromotion.setOrder( arguments.order );
		newAppliedPromotion.setDiscountAmount( arguments.discountAmount );
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
								arguments.orderItemQualifiedDiscounts[ orderItemID ][y].discountAmount = getService('HibachiUtilityService').precisionCalculate(getService('HibachiUtilityService').precisionCalculate(arguments.orderItemQualifiedDiscounts[ orderItemID ][y].discountAmount / thisDiscountQuantity) * getService('HibachiUtilityService').precisionCalculate(thisDiscountQuantity - needToRemove));

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

	private void function applyTop1Discounts(required any order, required any orderItemQualifiedDiscounts){
		// Loop over the orderItems one last time, and look for the top 1 discounts that can be applied
		for(var i=1; i<=arrayLen(arguments.order.getOrderItems()); i++) {

			var orderItem = arguments.order.getOrderItems()[i];
			// If the orderItemID exists in the qualifiedDiscounts, and the discounts have at least 1 value we can apply that top 1 discount

			if(structKeyExists(arguments.orderItemQualifiedDiscounts, orderItem.getOrderItemID()) && arrayLen(arguments.orderItemQualifiedDiscounts[ orderItem.getOrderItemID() ]) ) {
				var newAppliedPromotion = this.newPromotionApplied();
				newAppliedPromotion.setAppliedType('orderItem');
				newAppliedPromotion.setPromotion( arguments.orderItemQualifiedDiscounts[ orderItem.getOrderItemID() ][1].promotion );
				newAppliedPromotion.setOrderItem( orderItem );
				newAppliedPromotion.setDiscountAmount( arguments.orderItemQualifiedDiscounts[ orderItem.getOrderItemID() ][1].discountAmount );
			}

		}
	}

	private struct function getPromotionPeriodQualificationDetails(required any promotionPeriod, required any order) {

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

			// Loop over each of the qualifiers
			for(var qualifier in arguments.promotionPeriod.getPromotionQualifiers()) {

				// Get the details for this qualifier
				var thisQualifierDetails = getQualifierQualificationDetails(qualifier, arguments.order);

				// As long as there is a qualification count that is > 0 we can append the details
				if(thisQualifierDetails.qualificationCount) {

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

				// Otherwise just set as false and return
				} else {
					qualificationDetails.qualificationsMeet = false;
					qualificationDetails.qualifiedFulfillmentIDs = [];
					qualificationDetails.qualifierDetails = [];
					return qualificationDetails;
				}
			}
		}

		if(arrayLen(explicitlyQualifiedFulfillmentIDs)) {
			qualificationDetails.qualifiedFulfillments = explicitlyQualifiedFulfillmentIDs;
		}

		// Return the results
		return qualificationDetails;
	}

	private void function getQualifierQualificationDetailsForOrder(required any qualifier, required any order, required struct qualifierDetails){
		// Set the qualification count to 1 because that is the max for an order qualifier
		arguments.qualifierDetails.qualificationCount = 1;

		// Minimum Order Quantity
		if(	( !isNull(arguments.qualifier.getMinimumOrderQuantity()) && arguments.qualifier.getMinimumOrderQuantity() > arguments.order.getTotalSaleQuantity() )
			||
			( !isNull(arguments.qualifier.getMaximumOrderQuantity()) && arguments.qualifier.getMaximumOrderQuantity() < arguments.order.getTotalSaleQuantity() )
			||
			( !isNull(arguments.qualifier.getMinimumOrderSubtotal()) && arguments.qualifier.getMinimumOrderSubtotal() > arguments.order.getSubtotal() )
			||
			( !isNull(arguments.qualifier.getMaximumOrderSubtotal()) && arguments.qualifier.getMaximumOrderSubtotal() < arguments.order.getSubtotal() )
		) {
			arguments.qualifierDetails.qualificationCount = 0;
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

	private void function getQualifierQualificationDetailsForOrderItems(required any qualifier, required any order, required struct qualifierDetails){
		// Set the qualification count to the total fulfillments
		arguments.qualifierDetails.qualificationCount = 0;
		var qualifiedItemsQuantity = 0;

		for(var orderItem in arguments.order.getOrderItems()) {

			var qualifiedOrderItemDetails = {
				orderItem = orderItem,
				qualificationCount = 0
			};

			if( getOrderItemInQualifier(qualifier=qualifier, orderItem=orderItem) ){

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

				arguments.qualifierDetails.qualificationCount = int(qualifiedItemsQuantity / qualifier.getMinimumItemQuantity() );
			}else if(isNull(arguments.qualifier.getMinimumItemQuantity()) || arguments.qualifier.getMinimumItemQuantity() == 0){
				arguments.qualifierDetails.qualificationCount++;
			}
		}

	}

	private struct function getQualifierQualificationDetails(required any qualifier, required any order) {
		var qualifierDetails = {
			qualifier = arguments.qualifier,
			qualificationCount = 0,
			qualifiedFulfillmentIDs = [],
			qualifiedOrderItemDetails = []
		};

		// ORDER
		if(arguments.qualifier.getQualifierType() == "order") {

			getQualifierQualificationDetailsForOrder(arguments.qualifier,arguments.order,qualifierDetails);

		// FULFILLMENT
		} else if (arguments.qualifier.getQualifierType() == "fulfillment") {

			getQualifierQualificationDetailsForOrderFulfillments(arguments.qualifier, arguments.order, qualifier);

		// ORDER ITEM
		} else if (listFindNoCase("contentAccess,merchandise,subscription", arguments.qualifier.getQualifierType())) {

			getQualifierQualificationDetailsForOrderItems(arguments.qualifier,arguments.order,qualifierDetails);

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
				for(var o=1; o<=arrayLen(arguments.order.getOrderItems()); o++) {

					// Setup a local var for this orderItem
					var thisOrderItem = arguments.order.getOrderItems()[o];
					var orderItemQualifierCount = thisOrderItem.getQuantity();

					// First we run an "if" to see if this doesn't qualify for any reason and if so then set the count to 0
					if(
						!getOrderItemInQualifier(qualifier=qualifier, orderItem=thisOrderItem)
						||
						// Then check the match type of based on the current orderitem, and the orderItem we are getting a count for
						( qualifier.getRewardMatchingType() == "sku" && thisOrderItem.getSku().getSkuID() != arguments.orderItem.getSku().getSkuID() )
						||
						( qualifier.getRewardMatchingType() == "product" && thisOrderItem.getSku().getProduct().getProductID() != arguments.orderItem.getSku().getProduct().getProductID() )
						||
						( qualifier.getRewardMatchingType() == "productType" && thisOrderItem.getSku().getProduct().getProductType().getProductTypeID() != arguments.orderItem.getSku().getProduct().getProductType().getProductTypeID() )
						||
						( qualifier.getRewardMatchingType() == "brand" && isNull(thisOrderItem.getSku().getProduct().getBrand()))
						||
						( qualifier.getRewardMatchingType() == "brand" && isNull(arguments.orderItem.getSku().getProduct().getBrand()))
						||
						( qualifier.getRewardMatchingType() == "brand" && thisOrderItem.getSku().getProduct().getBrand().getBrandID() != arguments.orderItem.getSku().getProduct().getBrand().getBrandID() )
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
				if(qualifierCount lt allQualifiersCount) {
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

		// START: Check Exclusions

		var hasExcludedProductType = false;
		// Check all of the exclusions for an excluded product type
		if(arrayLen(arguments.qualifier.getExcludedProductTypes())) {
			var excludedProductTypeIDList = "";
			for(var i=1; i<=arrayLen(arguments.qualifier.getExcludedProductTypes()); i++) {
				excludedProductTypeIDList = listAppend(excludedProductTypeIDList, arguments.qualifier.getExcludedProductTypes()[i].getProductTypeID());
			}

			for(var ptid=1; ptid<=listLen(arguments.orderItem.getSku().getProduct().getProductType().getProductTypeIDPath()); ptid++) {
				if(listFindNoCase(excludedProductTypeIDList, listGetAt(arguments.orderItem.getSku().getProduct().getProductType().getProductTypeIDPath(), ptid))) {
					hasExcludedProductType = true;
					break;
				}
			}
		}
		// If anything is excluded then we return false
		if(	hasExcludedProductType
			||
			( !isNull(qualifier.getMinimumItemPrice()) && qualifier.getMinimumItemPrice() > arguments.orderItem.getPrice() )
			||
			( !isNull(qualifier.getMaximumItemPrice()) && qualifier.getMaximumItemPrice() < arguments.orderItem.getPrice() )
			||
			!isNull(arguments.orderItem.getSku()) && (
				arguments.qualifier.hasExcludedSku( arguments.orderItem.getSku() )
				||
				!isnull(arguments.orderItem.getSku().getProduct()) && (
					( arguments.qualifier.hasExcludedProduct( arguments.orderItem.getSku().getProduct() ))
					||
					( arrayLen( arguments.qualifier.getExcludedBrands() ) && ( isNull( arguments.orderItem.getSku().getProduct().getBrand() ) || arguments.qualifier.hasExcludedBrand( arguments.orderItem.getSku().getProduct().getBrand() ) ) )

				)
				||
				( arguments.qualifier.hasAnyExcludedOption( arguments.orderItem.getSku().getOptions() ))

			 )
			) {
			return false;
		}

		// START: Check Inclusions

		if(arrayLen(arguments.qualifier.getProductTypes())) {
			var includedPropertyTypeIDList = "";

			for(var i=1; i<=arrayLen(arguments.qualifier.getProductTypes()); i++) {
				includedPropertyTypeIDList = listAppend(includedPropertyTypeIDList, arguments.qualifier.getProductTypes()[i].getProductTypeID());
			}

			for(var ptid=1; ptid<=listLen(arguments.orderItem.getSku().getProduct().getProductType().getProductTypeIDPath()); ptid++) {
				if(listFindNoCase(includedPropertyTypeIDList, listGetAt(arguments.orderItem.getSku().getProduct().getProductType().getProductTypeIDPath(), ptid))) {
					return true;
				}
			}
		}
		if(!isNull(arguments.orderItem.getSku())){
			if(arguments.qualifier.hasSku( arguments.orderItem.getSku() )) {
				return true;
			}
			if(!isNull(arguments.orderItem.getSku().getProduct())){
				if(arguments.qualifier.hasProduct( arguments.orderItem.getSku().getProduct() )) {
					return true;
				}
				if(!isNull(arguments.orderItem.getSku().getProduct().getBrand()) && arguments.qualifier.hasBrand( arguments.orderItem.getSku().getProduct().getBrand() )) {
					return true;
				}
			}
			if(arguments.qualifier.hasAnyOption( arguments.orderItem.getSku().getOptions() )) {
				return true;
			}
		}


		return false;
	}

	public boolean function getOrderItemInReward(required any reward, required any orderItem) {

		// START: Check Exclusions
		var hasExcludedProductType = false;
		// Check all of the exclusions for an excluded product type
		if(arrayLen(arguments.reward.getExcludedProductTypes())) {
			var excludedProductTypeIDList = "";
			for(var i=1; i<=arrayLen(arguments.reward.getExcludedProductTypes()); i++) {
				excludedProductTypeIDList = listAppend(excludedProductTypeIDList, arguments.reward.getExcludedProductTypes()[i].getProductTypeID());
			}

			for(var ptid=1; ptid<=listLen(arguments.orderItem.getSku().getProduct().getProductType().getProductTypeIDPath()); ptid++) {
				if(listFindNoCase(excludedProductTypeIDList, listGetAt(arguments.orderItem.getSku().getProduct().getProductType().getProductTypeIDPath(), ptid))) {
					hasExcludedProductType = true;
					break;
				}
			}
		}

		// If anything is excluded then we return false
		if(	hasExcludedProductType
			||
			arguments.reward.hasExcludedProduct( arguments.orderItem.getSku().getProduct() )
			||
			arguments.reward.hasExcludedSku( arguments.orderItem.getSku() )
			||
			( arrayLen( arguments.reward.getExcludedBrands() ) && ( isNull( arguments.orderItem.getSku().getProduct().getBrand() ) || arguments.reward.hasExcludedBrand( arguments.orderItem.getSku().getProduct().getBrand() ) ) )
			||
			( arguments.reward.hasAnyExcludedOption( arguments.orderItem.getSku().getOptions() ) )
			) {
			return false;
		}

		// START: Check Inclusions
		if(arrayLen(arguments.reward.getProductTypes())) {
			var includedPropertyTypeIDList = "";

			var productTypes = [];

			for(var i=1; i<=arrayLen(arguments.reward.getProductTypes()); i++) {
				includedPropertyTypeIDList = listAppend(includedPropertyTypeIDList, arguments.reward.getProductTypes()[i].getProductTypeID());
			}

			for(var ptid=1; ptid<=listLen(arguments.orderItem.getSku().getProduct().getProductType().getProductTypeIDPath()); ptid++) {
				if(listFindNoCase(includedPropertyTypeIDList, listGetAt(arguments.orderItem.getSku().getProduct().getProductType().getProductTypeIDPath(), ptid))) {
					return true;
				}
			}
		}

		if(arguments.reward.hasProduct( arguments.orderItem.getSku().getProduct() )) {
			return true;
		}
		if(arguments.reward.hasSku( arguments.orderItem.getSku() )) {
			return true;
		}
		if(!isNull(arguments.orderItem.getSku().getProduct().getBrand()) && arguments.reward.hasBrand( arguments.orderItem.getSku().getProduct().getBrand() )) {
			return true;
		}
		if(arguments.reward.hasAnyOption( arguments.orderItem.getSku().getOptions() )) {
			return true;
		}

		return false;
	}

	private numeric function getDiscountAmount(required any reward, required numeric price, required numeric quantity, string currencyCode) {
		var discountAmountPreRounding = 0;
		var roundedFinalAmount = 0;
		var originalAmount = getService('HibachiUtilityService').precisionCalculate(arguments.price * arguments.quantity);

		if(structKeyExists(arguments, "currencyCode") && len(arguments.currencyCode)){
			switch(reward.getAmountType()) {
				case "percentageOff" :
					discountAmountPreRounding = getService('HibachiUtilityService').precisionCalculate(originalAmount * (reward.getAmountByCurrencyCode(arguments.currencyCode)/100));
					break;
				case "amountOff" :
					discountAmountPreRounding = reward.getAmountByCurrencyCode(arguments.currencyCode) * quantity;
					break;
				case "amount" :
					discountAmountPreRounding = getService('HibachiUtilityService').precisionCalculate((arguments.price - reward.getAmountByCurrencyCode(arguments.currencyCode)) * arguments.quantity);
					break;
			}

		}else{
			switch(reward.getAmountType()) {
				case "percentageOff" :
					discountAmountPreRounding = getService('HibachiUtilityService').precisionCalculate(originalAmount * (reward.getAmount()/100));
					break;
				case "amountOff" :
					discountAmountPreRounding = reward.getAmount() * quantity;
					break;
				case "amount" :
					discountAmountPreRounding = getService('HibachiUtilityService').precisionCalculate((arguments.price - reward.getAmount()) * arguments.quantity);
					break;
			}
		}

		if(!isNull(reward.getRoundingRule())) {
			roundedFinalAmount = getRoundingRuleService().roundValueByRoundingRule(value=getService('HibachiUtilityService').precisionCalculate(originalAmount - discountAmountPreRounding), roundingRule=reward.getRoundingRule());
			discountAmount = getService('HibachiUtilityService').precisionCalculate(originalAmount - roundedFinalAmount);
		} else {
			discountAmount = discountAmountPreRounding;
		}

		// This makes sure that the discount never exceeds the original amount
		if(discountAmountPreRounding > originalAmount) {
			discountAmount = originalAmount;
		}

		return numberFormat(discountAmount, "0.00");
	}

	// ----------------- END: Apply Promotion Logic -------------------------

	public struct function getSalePriceDetailsForProductSkus(required string productID, string currencyCode='') {
		var priceDetails = getHibachiUtilityService().queryToStructOfStructures(getPromotionDAO().getSalePricePromotionRewardsQuery(productID = arguments.productID,currencyCode = arguments.currencyCode), "skuID");

		for(var key in priceDetails) {
			if(priceDetails[key].roundingRuleID != "") {
				priceDetails[key].salePrice = getRoundingRuleService().roundValueByRoundingRuleID(value=priceDetails[key].salePrice, roundingRuleID=priceDetails[key].roundingRuleID);
			}
			priceDetails[key].salePrice=round(priceDetails[key].salePrice*100)/100; //Round to 2 decimals
		}
		return priceDetails;
	}

	public struct function getSalePriceDetailsForOrderItem(required any orderItem) {
		var priceDetails = getHibachiUtilityService().queryToStructOfStructures(getPromotionDAO().getOrderItemSalePricePromotionRewardsQuery(orderItem = arguments.orderItem), "orderItemID");

		for(var key in priceDetails) {
			if(priceDetails[key].roundingRuleID != "") {
				priceDetails[key].salePrice = getRoundingRuleService().roundValueByRoundingRuleID(value=priceDetails[key].salePrice, roundingRuleID=priceDetails[key].roundingRuleID);
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

		var promotionRewards = getPromotionDAO().getActivePromotionRewards( rewardTypeList="fulfillment", promotionCodeList=arguments.shippingMethodOption.getOrderFulfillment().getOrder().getPromotionCodeList() );

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
