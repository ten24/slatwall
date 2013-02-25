/*

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC

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
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

*/
component extends="Slatwall.com.service.BaseService" persistent="false" accessors="true" output="false" {

	property name="addressService" type="any";
	property name="roundingRuleService" type="any";
	property name="utilityService" type="any";

		
	// ----------------- START: Apply Promotion Logic ------------------------- 
	public void function updateOrderAmountsWithPromotions(required any order) {
		
		// Sale & Exchange Orders
		if( listFindNoCase("otSalesOrder,otExchangeOrder", arguments.order.getOrderType().getSystemCode()) ) {
			
			// Clear all previously applied promotions for order items
			for(var oi=1; oi<=arrayLen(arguments.order.getOrderItems()); oi++) {
				for(var pa=arrayLen(arguments.order.getOrderItems()[oi].getAppliedPromotions()); pa >= 1; pa--) {
					arguments.order.getOrderItems()[oi].getAppliedPromotions()[pa].removeOrderItem();
				}
			}
			
			// Clear all previously applied promotions for fulfillment
			for(var of=1; of<=arrayLen(arguments.order.getOrderFulfillments()); of++) {
				for(var pa=arrayLen(arguments.order.getOrderFulfillments()[of].getAppliedPromotions()); pa >= 1; pa--) {
					arguments.order.getOrderFulfillments()[of].getAppliedPromotions()[pa].removeOrderFulfillment();
				}
			}
			
			// Clear all previously applied promotions for order
			for(var pa=arrayLen(arguments.order.getAppliedPromotions()); pa >= 1; pa--) {
				arguments.order.getAppliedPromotions()[pa].removeOrder();
			}
			
			/*
			This is the data structure for the below structs to keep some information about what has & hasn't been applied as well as what can be applied	
																																							
			promotionPeriodQualifications = {																												
				promotionPeriodID = {																														
					promotionPeriodQualifies = true | false,																								
					orderQulifies = true | false,																											
					qualifiedFulfillmentIDList = "comma seperated list of ID's"																				
					orderItems = {																															
						orderItemID = x (number of times it qualifies),																						
						orderItemID = y (number of times it qualifies)																						
					}																																		
				}																																			
			};																																				
																																							
			promotionRewardUsageDetails = {																													
				promotionRewardID1 = {																														
					usedInOrder = 0,																														
					maximumUsePerOrder = 1000000,																											
					maximumUsePerItem = 1000000,																											
					maximumUsePerQualification = 1000000,																									
					orderItemsUsage = [   			Array is sorted by discountPerUseValue ASC so that we know what items to strip from if we go over		
						{																																	
							orderItemID = x,																												
							discountQuantity = 0,																											
							discountPerUseValue = 0,																										
						}																																	
					]																																		
				}																																			
			};																																				
																																							
			orderItemQulifiedDiscounts = {																													
				orderItemID1 = [									Array is sorted by discountAmount DESC so we know which is best to apply				
					{																																		
						promotionRewardID = x,																												
						promotion = promotionEntity																											
						discountAmount = 0,																													
						discountQuantity = 0,																												
						discountPerUseValue = 0,																											
					}																																		
				]													Array is sorted by discountAmount DESC so we know which is best to apply				
			};																																				
																																							
			*/
			
			
			// This is a structure of promotionPeriods that will get checked and cached as to if we are still within the period use count, and period account use count
			var promotionPeriodQualifications = {};
			
			// This is a structure of promotionRewards that will hold information reguarding maximum usages, and the amount of usages applied
			var promotionRewardUsageDetails = {};
			
			// This is a structure of orderItems with all of the potential discounts that apply to them
			var orderItemQulifiedDiscounts = {};
			
			// Loop over orderItems and add Sale Prices to the qualified discounts
			for(var oi=1; oi<=arrayLen(arguments.order.getOrderItems()); oi++) {
				var orderItem = arguments.order.getOrderItems()[oi];
				var salePriceDetails = orderItem.getSku().getSalePriceDetails();

				if(structKeyExists(salePriceDetails, "salePrice") && salePriceDetails.salePrice < orderItem.getSku().getPrice()) {
					
					var discountAmount = precisionEvaluate((orderItem.getSku().getPrice() * orderItem.getQuantity()) - (salePriceDetails.salePrice * orderItem.getQuantity()));
					
					orderItemQulifiedDiscounts[ orderItem.getOrderItemID() ] = [];
					
					// Insert this value into the potential discounts array
					arrayAppend(orderItemQulifiedDiscounts[ orderItem.getOrderItemID() ], {
						promotionRewardID = "",
						promotion = this.getPromotion(salePriceDetails.promotionID),
						discountAmount = discountAmount
					});
					
				}
			}
			
			// Loop over all Potential Discounts that require qualifications
			var promotionRewards = getDAO().getActivePromotionRewards(rewardTypeList="merchandise,subscription,contentAccess,order,fulfillment", promotionCodeList=arguments.order.getPromotionCodeList(), qualificationRequired=true);
			var orderRewards = false;
			for(var pr=1; pr<=arrayLen(promotionRewards); pr++) {
				
				var reward = promotionRewards[pr];
				
				// Setup the promotionReward usage Details. This will be used for the maxUsePerQualification & and maxUsePerItem up front, and then later to remove discounts that violate max usage
				promotionRewardUsageDetails[ reward.getPromotionRewardID() ] = {
					usedInOrder = 0,
					maximumUsePerOrder = 1000000,
					maximumUsePerItem = 1000000,
					maximumUsePerQualification = 1000000,
					orderItemsUsage = []
				};
				if( !isNull(reward.getMaximumUsePerOrder()) && reward.getMaximumUsePerOrder() > 0) {
					promotionRewardUsageDetails[ reward.getPromotionRewardID() ].maximumUsePerOrder = reward.getMaximumUsePerOrder();
				}
				if( !isNull(reward.getMaximumUsePerItem()) && reward.getMaximumUsePerItem() > 0 ) {
					promotionRewardUsageDetails[ reward.getPromotionRewardID() ].maximumUsePerItem = reward.getMaximumUsePerItem();
				}
				if( !isNull(reward.getMaximumUsePerQualification()) && reward.getMaximumUsePerQualification() > 0 ) {
					promotionRewardUsageDetails[ reward.getPromotionRewardID() ].maximumUsePerQualification = reward.getMaximumUsePerQualification();
				}
				
				// Setup the boolean for if the promotionPeriod is okToApply based on general use count
				if(!structKeyExists(promotionPeriodQualifications, reward.getPromotionPeriod().getPromotionPeriodID())) {
					promotionPeriodQualifications[ reward.getPromotionPeriod().getPromotionPeriodID() ] = {
						orderItems = {}
					};
					promotionPeriodQualifications[ reward.getPromotionPeriod().getPromotionPeriodID() ].promotionPeriodQualifies = getPromotionPeriodOKToApply(promotionPeriod=reward.getPromotionPeriod(), order=arguments.order);
				}
				
				// If this promotion period is ok to apply based on general useCount
				if(promotionPeriodQualifications[ reward.getPromotionPeriod().getPromotionPeriodID() ].promotionPeriodQualifies) {
					
					// Now that we know the period is ok, lets check and cache if the order qualifiers
					if(!structKeyExists(promotionPeriodQualifications[reward.getPromotionPeriod().getPromotionPeriodID()], "orderQulifies")) {
						promotionPeriodQualifications[reward.getPromotionPeriod().getPromotionPeriodID()].orderQulifies = getPromotionPeriodOkToApplyByOrderQualifiers(promotionPeriod=reward.getPromotionPeriod(), order=arguments.order);
					}
					
					// If order qualifies for the rewards promotion period
					if(promotionPeriodQualifications[reward.getPromotionPeriod().getPromotionPeriodID()].orderQulifies) {
						
						// Now that we know the order is ok, lets check and cache if at least one of the fulfillment qualifies
						if(!structKeyExists(promotionPeriodQualifications[reward.getPromotionPeriod().getPromotionPeriodID()], "qualifiedFulfillmentIDList")) {
							promotionPeriodQualifications[reward.getPromotionPeriod().getPromotionPeriodID()].qualifiedFulfillmentIDList = getPromotionPeriodQualifiedFulfillmentIDList(promotionPeriod=reward.getPromotionPeriod(), order=arguments.order);
						}
						
						// Check to make sure that at least one of the fulfillents is in the list of qualified fulfillments
						if(len(promotionPeriodQualifications[reward.getPromotionPeriod().getPromotionPeriodID()].qualifiedFulfillmentIDList)) {
							
							
							// =============== Order Item Reward ==============
							if( !orderRewards and listFindNoCase("merchandise,subscription,contentAccess", reward.getRewardType()) ) {

								// Loop over all the orderItems
								for(var i=1; i<=arrayLen(arguments.order.getOrderItems()); i++) {
									
									// Get The order Item
									var orderItem = arguments.order.getOrderItems()[i];
									
									// Verify that this is an item being sold
									if(orderItem.getOrderItemType().getSystemCode() == "oitSale") {
										
										// Make sure that this order item is in the acceptable fulfillment list
										if(listFindNoCase(promotionPeriodQualifications[reward.getPromotionPeriod().getPromotionPeriodID()].qualifiedFulfillmentIDList, orderItem.getOrderFulfillment().getOrderFulfillmentID())) {
											
											// Now that we know the fulfillment is ok, lets check and cache then number of times this orderItem qualifies based on the promotionPeriod
											if(!structKeyExists(promotionPeriodQualifications[reward.getPromotionPeriod().getPromotionPeriodID()].orderItems, orderItem.getOrderItemID())) {
												promotionPeriodQualifications[reward.getPromotionPeriod().getPromotionPeriodID()].orderItems[ orderItem.getOrderItemID() ] = getPromotionPeriodOrderItemQualificationCount(promotionPeriod=reward.getPromotionPeriod(), orderItem=orderItem, order=arguments.order);
											}
											
											// If the qualification count for this order item is > 0 then we can try to apply the reward
											if(promotionPeriodQualifications[reward.getPromotionPeriod().getPromotionPeriodID()].orderItems[ orderItem.getOrderItemID() ]) {
												
												// Check the reward settings to see if this orderItem applies
												if( getOrderItemInReward(reward, orderItem) ) {
													
													// setup the discountQuantity based on the qualification quantity.  If there were no qualification constrints than this will just be the orderItem quantity
													var qualificationQuantity = promotionPeriodQualifications[reward.getPromotionPeriod().getPromotionPeriodID()].orderItems[ orderItem.getOrderItemID() ];
													if(qualificationQuantity lt promotionRewardUsageDetails[ reward.getPromotionRewardID() ].maximumUsePerOrder) {
														promotionRewardUsageDetails[ reward.getPromotionRewardID() ].maximumUsePerOrder = qualificationQuantity;
													}
													
													var discountQuantity = qualificationQuantity * promotionRewardUsageDetails[ reward.getPromotionRewardID() ].maximumUsePerQualification;
													
													// If the discountQuantity is > the orderItem quantity then just set it to the orderItem quantity
													if(discountQuantity > orderItem.getQuantity()) {
														discountQuantity = orderItem.getQuantity();
													}
													
													// If the discountQuantity is > than maximumUsePerItem then set it to maximumUsePerItem
													if(discountQuantity > promotionRewardUsageDetails[ reward.getPromotionRewardID() ].maximumUsePerItem) {
														discountQuantity = promotionRewardUsageDetails[ reward.getPromotionRewardID() ].maximumUsePerItem;
													}
													
													// If there is not applied Price Group, or if this reward has the applied pricegroup as an eligible one then use priceExtended... otherwise use skuPriceExtended and then adjust the discount.
													if( isNull(orderItem.getAppliedPriceGroup()) || reward.hasEligiblePriceGroup( orderItem.getAppliedPriceGroup() ) ) {
														
														// Calculate based on price, which could be a priceGroup price
														var discountAmount = getDiscountAmount(reward, orderItem.getPrice(), discountQuantity);
														
													} else {
														
														// Calculate based on skuPrice because the price on this item is a priceGroup price and we need to adjust the discount by the difference
														var originalDiscountAmount = getDiscountAmount(reward, orderItem.getSkuPrice(), discountQuantity);
														
														// Take the original discount they were going to get without a priceGroup and subtract the difference of the discount that they are already receiving
														var discountAmount = precisionEvaluate(originalDiscountAmount - (orderItem.getExtendedSkuPrice() - orderItem.getExtendedPrice()));
														
													}
													
													// If the discountAmount is gt 0 then we can add the details in order to the potential orderItem discounts
													if(discountAmount > 0) {
														
														// First thing that we are going to want to do is add this orderItem to the orderItemQulifiedDiscounts if it doesn't already exist
														if(!structKeyExists(orderItemQulifiedDiscounts, orderItem.getOrderItemID())) {
															// Set it as a blank array
															orderItemQulifiedDiscounts[ orderItem.getOrderItemID() ] = [];
														}
														
														// If there are already values in the array then figure out where to insert
														var discountAdded = false;
															
														// loop over any discounts that might be already in assigned and pick an index where the discount amount is best
														for(var d=1; d<=arrayLen(orderItemQulifiedDiscounts[ orderItem.getOrderItemID() ]) ; d++) {
															
															if(orderItemQulifiedDiscounts[ orderItem.getOrderItemID() ][d].discountAmount < discountAmount) {
																
																// Insert this value into the potential discounts array
																arrayInsertAt(orderItemQulifiedDiscounts[ orderItem.getOrderItemID() ], d, {
																	promotionRewardID = reward.getPromotionRewardID(),
																	promotion = reward.getPromotionPeriod().getPromotion(),
																	discountAmount = discountAmount
																});
																
																discountAdded = true;
																break;
															}
														}
														
														if(!discountAdded) {
															
															// Insert this value into the potential discounts array
															arrayAppend(orderItemQulifiedDiscounts[ orderItem.getOrderItemID() ], {
																promotionRewardID = reward.getPromotionRewardID(),
																promotion = reward.getPromotionPeriod().getPromotion(),
																discountAmount = discountAmount
															});
															
														}
														
														// Increment the number of times this promotion reward has been used
														promotionRewardUsageDetails[ reward.getPromotionRewardID() ].usedInOrder += discountQuantity;
														
														var discountPerUseValue = precisionEvaluate(discountAmount / discountQuantity);
														
														var usageAdded = false;
														
														// loop over any previous orderItemUsage of this reward an place it in ASC order based on discountPerUseValue
														for(var oiu=1; oiu<=arrayLen(promotionRewardUsageDetails[ reward.getPromotionRewardID() ].orderItemsUsage) ; oiu++) {
															
															if(promotionRewardUsageDetails[ reward.getPromotionRewardID() ].orderItemsUsage[oiu].discountPerUseValue > discountPerUseValue) {
																
																// Insert this value into the potential discounts array
																arrayInsertAt(promotionRewardUsageDetails[ reward.getPromotionRewardID() ].orderItemsUsage, oiu, {
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
															arrayAppend(promotionRewardUsageDetails[ reward.getPromotionRewardID() ].orderItemsUsage, {
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


							// =============== Fulfillment Reward ======================
							} else if (!orderRewards and reward.getRewardType() eq "fulfillment" ) {
							
							
								// Loop over all the fulfillments
								for(var of=1; of<=arrayLen(arguments.order.getOrderFulfillments()); of++) {
									
									// Get this order Fulfillment
									var orderFulfillment = arguments.order.getOrderFulfillments()[of];
									
									if( ( !arrayLen(reward.getFulfillmentMethods()) || reward.hasFulfillmentMethod(orderFulfillment.getFulfillmentMethod()) ) 
										&&
										( !arrayLen(reward.getShippingMethods()) || (!isNull(orderFulfillment.getShippingMethod()) && reward.hasShippingMethod(orderFulfillment.getShippingMethod()) ) ) ) {
										
										
										var addressIsInZone = true;
										if(arrayLen(reward.getShippingAddressZones())) {
											addressIsInZone = false;
											for(var az=1; az<=arrayLen(reward.getShippingAddressZones()); az++) {
												if(getAddressService().isAddressInZone(address=orderFulfillment.getAddress(), addressZone=reward.getShippingAddressZones()[az])) {
													addressIsInZone = true;
													break;
												}
											}
										}
										
										if(addressIsInZone) {
											
											var discountAmount = getDiscountAmount(reward, orderFulfillment.getFulfillmentCharge(), 1);
											
											var addNew = false;
												
											// First we make sure that the discountAmount is > 0 before we check if we should add more discount
											if(discountAmount > 0) {
												
												// If there aren't any promotions applied to this order fulfillment yet, then we can add this one
												if(!arrayLen(orderFulfillment.getAppliedPromotions())) {
													addNew = true;
													
												// If one has already been set then we just need to check if this new discount amount is greater
												} else if ( orderFulfillment.getAppliedPromotions()[1].getDiscountAmount() < discountAmount ) {
													
													// If the promotion is the same, then we just update the amount
													if(orderFulfillment.getAppliedPromotions()[1].getPromotion().getPromotionID() == reward.getPromotionPeriod().getPromotion().getPromotionID()) {
														orderFulfillment.getAppliedPromotions()[1].setDiscountAmount(discountAmount);
														
													// If the promotion is a different then remove the original and set addNew to true
													} else {
														orderFulfillment.getAppliedPromotions()[1].removeOrderFulfillment();
														addNew = true;
													}
												}
											}
											
											// Add the new appliedPromotion
											if(addNew) {
												var newAppliedPromotion = this.newPromotionApplied();
												newAppliedPromotion.setAppliedType('orderFulfillment');
												newAppliedPromotion.setPromotion( reward.getPromotionPeriod().getPromotion() );
												newAppliedPromotion.setOrderFulfillment( orderFulfillment );
												newAppliedPromotion.setDiscountAmount( discountAmount );
											}
										}
									}
								}
							
							// ================== Order Reward =========================
							} else if (orderRewards and reward.getRewardType() eq "order" ) {
								
								
								var totalDiscountableAmount = arguments.order.getSubtotalAfterItemDiscounts() + arguments.order.getFulfillmentChargeAfterDiscountTotal();

								var discountAmount = getDiscountAmount(reward, totalDiscountableAmount, 1);
											
								var addNew = false;
									
								// First we make sure that the discountAmount is > 0 before we check if we should add more discount
								if(discountAmount > 0) {
									
									// If there aren't any promotions applied to this order fulfillment yet, then we can add this one
									if(!arrayLen(arguments.order.getAppliedPromotions())) {
										addNew = true;
										
									// If one has already been set then we just need to check if this new discount amount is greater
									} else if ( arguments.order.getAppliedPromotions()[1].getDiscountAmount() < discountAmount ) {
										
										// If the promotion is the same, then we just update the amount
										if(arguments.order.getAppliedPromotions()[1].getPromotion().getPromotionID() == reward.getPromotionPeriod().getPromotion().getPromotionID()) {
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
									var newAppliedPromotion = this.newPromotionApplied();
									newAppliedPromotion.setAppliedType('order');
									newAppliedPromotion.setPromotion( reward.getPromotionPeriod().getPromotion() );
									newAppliedPromotion.setOrder( arguments.order );
									newAppliedPromotion.setDiscountAmount( discountAmount );
								}
								
							} // ============= END ALL REWARD TYPES
							
							
							// This forces the loop to repeat looking for "order" discounts
							if(!orderRewards and pr == arrayLen(promotionRewards)) {
								pr = 0;
								orderRewards = true;
							}
							
							
						} // END Len of fulfillmentID list
					
					} // END Order Qualifies IF
				
				} // END Promotion Period OK IF
			
			} // END of PromotionReward Loop
			
			
			// Now that we has setup all the potential discounts for orderItems sorted by best price, we want to strip out any of the discounts that would exceed the maximum order use counts.
			for(var prID in promotionRewardUsageDetails) {
				
				// If this promotion reward was used more than it should have been, then lets start stripping out from the arrays in the correct order
				if(promotionRewardUsageDetails[ prID ].usedInOrder > promotionRewardUsageDetails[ prID ].maximumUsePerOrder) {
					var needToRemove = promotionRewardUsageDetails[ prID ].usedInOrder - promotionRewardUsageDetails[ reward.getPromotionRewardID() ].maximumUsePerOrder;
					
					// Loop over the items it was applied to an remove the quantity necessary to meet the total needToRemoveQuantity
					for(var x=1; x<=arrayLen(promotionRewardUsageDetails[ reward.getPromotionRewardID() ].orderItemsUsage); x++) {
						var orderItemID = promotionRewardUsageDetails[ reward.getPromotionRewardID() ].orderItemsUsage[x].orderItemID;
						var thisDiscountQuantity = promotionRewardUsageDetails[ reward.getPromotionRewardID() ].orderItemsUsage[x].discountQuantity;
						
						if(needToRemove < thisDiscountQuantity) {
							
							// Loop over to find promotionReward
							for(var y=arrayLen(orderItemQulifiedDiscounts[ orderItemID ]); y>=1; y--) {
								if(orderItemQulifiedDiscounts[ orderItemID ][y].promotionRewardID == prID) {
									
									// Set the discountAmount as some fraction of the original discountAmount
									orderItemQulifiedDiscounts[ orderItemID ][y].discountAmount = precisionEvaluate((orderItemQulifiedDiscounts[ orderItemID ][y].discountAmount / thisDiscountQuantity) * (thisDiscountQuantity - needToRemove));
									
									// Update the needToRemove
									needToRemove = 0;
									
									// Break out of the item discount loop
									break;
								}
							}
						} else {
							
							// Loop over to find promotionReward
							for(var y=arrayLen(orderItemQulifiedDiscounts[ orderItemID ]); y>=1; y--) {
								if(orderItemQulifiedDiscounts[ orderItemID ][y].promotionRewardID == prID) {
									
									// Remove from the array
									arrayDeleteAt(orderItemQulifiedDiscounts[ orderItemID ], y);
									
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
			
			// Loop over the orderItems one last time, and look for the top 1 discounts that can be applied
			for(var i=1; i<=arrayLen(arguments.order.getOrderItems()); i++) {
				
				var orderItem = arguments.order.getOrderItems()[i];
				
				// If the orderItemID exists in the qualifiedDiscounts, and the discounts have at least 1 value we can apply that top 1 discount
				if(structKeyExists(orderItemQulifiedDiscounts, orderItem.getOrderItemID()) && arrayLen(orderItemQulifiedDiscounts[ orderItem.getOrderItemID() ]) ) {
					var newAppliedPromotion = this.newPromotionApplied();
					newAppliedPromotion.setAppliedType('orderItem');
					newAppliedPromotion.setPromotion( orderItemQulifiedDiscounts[ orderItem.getOrderItemID() ][1].promotion );
					newAppliedPromotion.setOrderItem( orderItem );
					newAppliedPromotion.setDiscountAmount( orderItemQulifiedDiscounts[ orderItem.getOrderItemID() ][1].discountAmount );
				}
				
			}
			
		} // END of Sale or Exchange Loop
		
		// Return & Exchange Orders
		if( listFindNoCase("otReturnOrder,otExchangeOrder", arguments.order.getOrderType().getSystemCode()) ) {
			// TODO: In the future allow for return Items to have negative promotions applied.  This isn't import right now because you can determine how much you would like to refund ordersItems
		}

	}
	
	private boolean function getPromotionPeriodOKToApply(required any promotionPeriod, required any order) {
		if(!isNull(arguments.promotionPeriod.getMaximumUseCount()) && arguments.promotionPeriod.getMaximumUseCount() gt 0) {
			var periodUseCount = getDAO().getPromotionPeriodUseCount(promotionPeriod = arguments.promotionPeriod);	
			if(periodUseCount >= arguments.promotionPeriod.getMaximumUseCount()) {
				return false;
			} 
		}
		if(!isNull(arguments.promotionPeriod.getMaximumAccountUseCount()) && arguments.promotionPeriod.getMaximumAccountUseCount() gt 0) {
			if(!isNull(arguments.order.getAccount())) {
				var periodAccountUseCount = getDAO().getPromotionPeriodAccountUseCount(promotionPeriod = arguments.promotionPeriod, account=arguments.order.getAccount());
				if(periodAccountUseCount >= arguments.promotionPeriod.getMaximumAccountUseCount()) {
					return false;
				}	
			}
		}
		
		return true;
	}
	
	private boolean function getPromotionPeriodOkToApplyByOrderQualifiers(required any promotionPeriod, required any order) {
		// Loop over Qualifiers looking for order qualifiers
		for(var q=1; q<=arrayLen(arguments.promotionPeriod.getPromotionQualifiers()); q++) {
			
			var qualifier = arguments.promotionPeriod.getPromotionQualifiers()[q];
			
			if(qualifier.getQualifierType() == "order") {
				// Minimum Order Quantity
				if(!isNull(qualifier.getMinimumOrderQuantity()) && qualifier.getMinimumOrderQuantity() > arguments.order.getTotalSaleQuantity()) {
					return false;
				}
				// Maximum Order Quantity
				if(!isNull(qualifier.getMaximumOrderQuantity()) && qualifier.getMaximumOrderQuantity() < arguments.order.getTotalSaleQuantity()) {
					return false;
				}
				// Minimum Order Subtotal
				if(!isNull(qualifier.getMinimumOrderSubtotal()) && qualifier.getMinimumOrderSubtotal() > arguments.order.getSubtotal()) {
					return false;
				}
				// Maximum Order Substotal
				if(!isNull(qualifier.getMaximumOrderSubtotal()) && qualifier.getMaximumOrderSubtotal() < arguments.order.getSubtotal()) {
					return false;
				}
			}	
		}
		
		return true;
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
						// First check the simple value stuff
						( !isNull(qualifier.getMinimumItemPrice()) && qualifier.getMinimumItemPrice() > arguments.orderItem.getPrice() )
						||
						( !isNull(qualifier.getMaximumItemPrice()) && qualifier.getMaximumItemPrice() < arguments.orderItem.getPrice() )
						||
						// Check the basic qualification groups for this item like, sku, product, productType, brand option
						( arrayLen( qualifier.getProductTypes() ) && !qualifier.hasProductType( arguments.orderItem.getSku().getProduct().getProductType() ) )
						||
						( qualifier.hasExcludedProductType( arguments.orderItem.getSku().getProduct().getProductType() ) )
						||
						( arrayLen( qualifier.getProducts() ) && !qualifier.hasProduct( arguments.orderItem.getSku().getProduct() ) )
						||
						( qualifier.hasExcludedProduct( arguments.orderItem.getSku().getProduct() ) )
						||
						( arrayLen( qualifier.getSkus() ) && !qualifier.hasSku( arguments.orderItem.getSku() ) )
						||
						( qualifier.hasExcludedSku( arguments.orderItem.getSku() ) )
						||
						( arrayLen( qualifier.getBrands() ) && !qualifier.hasBrand( arguments.orderItem.getSku().getProduct().getBrand() ) ) 
						||
						( qualifier.hasExcludedBrand( arguments.orderItem.getSku().getProduct().getBrand() ) )
						||
						( arrayLen( qualifier.getOptions() ) && !qualifier.hasAnyOption( arguments.orderItem.getSku().getOptions() ) )
						||
						( qualifier.hasAnyExcludedOption( arguments.orderItem.getSku().getOptions() ) )
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
				if( !isNull(qualifier.getMinimumItemQuantity()) ) {
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
	
	public boolean function getOrderItemInReward(required any reward, required any orderItem) {
		
		// Check the reward settings to see if this orderItem applies
		if( ( arrayLen(arguments.reward.getProductTypes()) && !arguments.reward.hasProductType( arguments.orderItem.getSku().getProduct().getProductType() ) )
			||
			( arguments.reward.hasExcludedProductType( arguments.orderItem.getSku().getProduct().getProductType() ) )
			||
			( arrayLen( arguments.reward.getProducts() ) && !arguments.reward.hasProduct( arguments.orderItem.getSku().getProduct() ) )
			||
			( arguments.reward.hasExcludedProduct( arguments.orderItem.getSku().getProduct() ) )
			||
			( arrayLen( arguments.reward.getSkus() ) && !arguments.reward.hasSku( arguments.orderItem.getSku() ) )
			||
			( arguments.reward.hasExcludedSku( arguments.orderItem.getSku() ) )
			||
			( arrayLen( arguments.reward.getBrands() ) && ( !isNull(arguments.orderItem.getSku().getProduct().getBrand()) && !arguments.reward.hasBrand( arguments.orderItem.getSku().getProduct().getBrand() ) ) )
			||
			( arrayLen( arguments.reward.getExcludedBrands() ) && ( isNull( arguments.orderItem.getSku().getProduct().getBrand() ) || arguments.reward.hasExcludedBrand( arguments.orderItem.getSku().getProduct().getBrand() ) ) )
			||
			( arrayLen( arguments.reward.getOptions() ) && !arguments.reward.hasAnyOption( arguments.orderItem.getSku().getOptions() ) )  	
			||
			( arguments.reward.hasAnyExcludedOption( arguments.orderItem.getSku().getOptions() ) )
			) {
				
			return false;
		}
		
		return true;
	}
	
	private numeric function getDiscountAmount(required any reward, required numeric price, required numeric quantity) {
		var discountAmountPreRounding = 0;
		var roundedFinalAmount = 0;
		var originalAmount = precisionEvaluate(arguments.price * arguments.quantity);
		
		
		switch(reward.getAmountType()) {
			case "percentageOff" :
				discountAmountPreRounding = precisionEvaluate(originalAmount * (reward.getAmount()/100));
				break;
			case "amountOff" :
				discountAmountPreRounding = reward.getAmount() * quantity;
				break;
			case "amount" :
				discountAmountPreRounding = precisionEvaluate(arguments.price - reward.getAmount()) * arguments.quantity;
				break;
		}
		
		if(!isNull(reward.getRoundingRule())) {
			roundedFinalAmount = getRoundingRuleService().roundValueByRoundingRule(value=precisionEvaluate(originalAmount - discountAmountPreRounding), roundingRule=reward.getRoundingRule());
			discountAmount = precisionEvaluate(originalAmount - roundedFinalAmount);
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
	
	public struct function getSalePriceDetailsForProductSkus(required string productID) {
		var priceDetails = getUtilityService().queryToStructOfStructures(getDAO().getSalePricePromotionRewardsQuery(productID = arguments.productID), "skuID");
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
		
		var promotionRewards = getDAO().getActivePromotionRewards( rewardTypeList="fulfillment", promotionCodeList=arguments.shippingMethodOption.getOrderFulfillment().getOrder().getPromotionCodeList() );
		
		// Loop over the Promotion Rewards to look for the best discount
		for(var i=1; i<=arrayLen(promotionRewards); i++) {
			
			var reward = promotionRewards[i];
			
			// Setup the boolean for if the promotionPeriod is okToApply based on general use count
			if(!structKeyExists(promotionPeriodQualifications, reward.getPromotionPeriod().getPromotionPeriodID())) {
				promotionPeriodQualifications[ reward.getPromotionPeriod().getPromotionPeriodID() ] = {
					orderItems = {}
				};
				promotionPeriodQualifications[ reward.getPromotionPeriod().getPromotionPeriodID() ].promotionPeriodQualifies = getPromotionPeriodOKToApply(promotionPeriod=reward.getPromotionPeriod(), order=arguments.shippingMethodOption.getOrderFulfillment().getOrder());
			}
				
			// If this promotion period is ok to apply based on general useCount
			if(promotionPeriodQualifications[ reward.getPromotionPeriod().getPromotionPeriodID() ].promotionPeriodQualifies) {
				
				// Now that we know the period is ok, lets check and cache if the order qualifiers
				if(!structKeyExists(promotionPeriodQualifications[reward.getPromotionPeriod().getPromotionPeriodID()], "orderQulifies")) {
					promotionPeriodQualifications[reward.getPromotionPeriod().getPromotionPeriodID()].orderQulifies = getPromotionPeriodOkToApplyByOrderQualifiers(promotionPeriod=reward.getPromotionPeriod(), order=arguments.shippingMethodOption.getOrderFulfillment().getOrder());
				}
				
				// If order qualifies for the rewards promotion period
				if(promotionPeriodQualifications[reward.getPromotionPeriod().getPromotionPeriodID()].orderQulifies) {
			
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
			
		}
		
		return details;
	}
	
	// ===================== START: Logical Methods ===========================
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
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
