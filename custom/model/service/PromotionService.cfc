component extends="Slatwall.model.service.PromotionService" {
    
    public function init(){
    	super.init(argumentCollection=arguments);
    	variables.customPriceFields = 'personalVolume,taxableAmount,commissionableVolume,retailCommission,productPackVolume,retailValueVolume';
    }
    private void function applyTop1Discounts(required any order, required any orderItemQualifiedDiscounts){

		// Loop over the orderItems one last time, and look for the top 1 discounts that can be applied
		var orderItemsCount = arrayLen(arguments.order.getOrderItems()); 	
		for(var i=1; i<=orderItemsCount; i++) {

			var orderItem = arguments.order.getOrderItems()[i];
			// If the orderItemID exists in the qualifiedDiscounts, and the discounts have at least 1 value we can apply that top 1 discount
			if(structKeyExists(arguments.orderItemQualifiedDiscounts, orderItem.getOrderItemID()) && arrayLen(arguments.orderItemQualifiedDiscounts[ orderItem.getOrderItemID() ]) ) {
				var promotionReward = this.getPromotionReward(arguments.orderItemQualifiedDiscounts[ orderItem.getOrderItemID() ][1].promotionRewardID);
			
				//if we weren't able to find a reward keep going
				if(isNull(promotionReward)){ 
					continue; 
				} 
					
				var newAppliedPromotion = this.newPromotionApplied();
				newAppliedPromotion.setAppliedType('orderItem');
				newAppliedPromotion.setPromotion( arguments.orderItemQualifiedDiscounts[ orderItem.getOrderItemID() ][1].promotion );
				newAppliedPromotion.setOrderItem( orderItem );
				newAppliedPromotion.setDiscountAmount( arguments.orderItemQualifiedDiscounts[ orderItem.getOrderItemID() ][1].discountAmount );
			    //Custom price fields
			    for(var customPriceField in variables.customPriceFields){
					
					if(promotionReward.getAmountType() == 'amountOff'){
						var rewardAmount = getProportionalRewardAmount(newAppliedPromotion.getDiscountAmount(), orderItem.getPrice(),orderItem.invokeMethod('get#customPriceField#'));
					}else{
				        var args = {
				            reward=promotionReward,
				            price=orderItem.invokeMethod('get#customPriceField#'),
				            quantity=orderItem.getQuantity(),
				            customPriceField=customPriceField,
				            sku=orderItem.getSku(),
				            account=arguments.order.getAccount()
				        };
				        var rewardAmount = getCustomDiscountAmount(argumentCollection=args);
					}
	        		newAppliedPromotion.invokeMethod('set#customPriceField#DiscountAmount',{1=rewardAmount});
			    }
				//making sure calculated props run
				getHibachiScope().addModifiedEntity(orderItem);
			}

		}
	}
	
	private void function applyPromotionToOrder(required any order,required any promotion, required numeric discountAmount, struct customDiscountAmountStruct){
		var newAppliedPromotion = this.newPromotionApplied();
		newAppliedPromotion.setAppliedType('order');
		newAppliedPromotion.setPromotion( arguments.promotion );
		newAppliedPromotion.setOrder( arguments.order );
		newAppliedPromotion.setDiscountAmount( arguments.discountAmount );
		
		if(structKeyExists(arguments,'customDiscountAmountStruct')){
			for(var key in arguments.customDiscountAmountStruct){
				newAppliedPromotion.invokeMethod('set#key#DiscountAmount',{1=arguments.customDiscountAmountStruct[key]});
			}
		}
	}
	
	private void function processOrderRewards(required any order, required any promotionReward){
		var totalDiscountableAmount = arguments.order.getSubtotalAfterItemDiscounts();

		var discountAmount = getDiscountAmount(arguments.promotionReward, totalDiscountableAmount, 1, order.getCurrencyCode());

		var customDiscountAmountStruct = {};
		for(var customPriceField in variables.customPriceFields){
			var totalCustomDiscountableAmount = arguments.order.invokeMethod('get#customPriceField#SubtotalAfterItemDiscounts');
			if(!isNull(totalCustomDiscountableAmount)){
				if(arguments.promotionReward.getAmountType() == 'amountOff'){
					var rewardAmount = getProportionalRewardAmount( discountAmount, totalDiscountableAmount, totalCustomDiscountableAmount );
				}else{
					var rewardAmount = getCustomDiscountAmount(arguments.promotionReward, totalCustomDiscountableAmount, 1, order.getCurrencyCode(),customPriceField);
				}
				customDiscountAmountStruct[customPriceField] = rewardAmount;
			}
		}
		var addNew = false;

		// First we make sure that the discountAmount is > 0 before we check if we should add more discount
		if(discountAmount > 0) {

			// If there aren't any promotions applied to this order fulfillment yet, then we can add this one
			if(!arrayLen(arguments.order.getAppliedPromotions())) {
				addNew = true;

			// If one has already been set then we just need to check if this new discount amount is greater
			} else if ( arguments.order.getAppliedPromotions()[1].getDiscountAmount() < discountAmount ) {
				var appliedPromotion = arguments.order.getAppliedPromotions()[1];
				// If the promotion is the same, then we just update the amount
				if(appliedPromotion.getPromotion().getPromotionID() == arguments.promotionReward.getPromotionPeriod().getPromotion().getPromotionID()) {
					appliedPromotion.setDiscountAmount(discountAmount);
					for(var key in customDiscountAmountStruct){
						appliedPromotion.invokeMethod('set#key#DiscountAmount',{1=customDiscountAmountStruct[key]});
					}

				// If the promotion is a different then remove the original and set addNew to true
				} else {
					appliedPromotion.removeOrder();
					addNew = true;
				}
			}
		}

		// Add the new appliedPromotion
		if(addNew) {
			applyPromotionToOrder(arguments.order,arguments.promotionReward.getPromotionPeriod().getPromotion(),discountAmount,customDiscountAmountStruct);
		}

	}
	
	private numeric function getCustomDiscountAmount(required any reward, required numeric price, required numeric quantity, string currencyCode, string customPriceField, any sku, any account) {
		var discountAmountPreRounding = 0;
		var roundedFinalAmount = 0;
		var originalAmount = val(getService('HibachiUtilityService').precisionCalculate(arguments.price * arguments.quantity));

		var amountMethod = '';
		var amountParams = {
			quantity:arguments.quantity
		};
		if(reward.getAmountType() != "amountOff"){
			if(structKeyExists(arguments,'customPriceField')){
				amountMethod &= 'get#arguments.customPriceField#Amount';
			}else{
				amountMethod &= 'getAmount';
			}
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
		}else{
			
		}
		
		var rewardAmount = arguments.reward.invokeMethod(amountMethod,amountParams);
		if(!isNull(rewardAmount)){
			switch(reward.getAmountType()) {
				case "percentageOff" :
					discountAmountPreRounding = val(getService('HibachiUtilityService').precisionCalculate(originalAmount * (rewardAmount/100)));
					break;
				case "amountOff" :
					discountAmountPreRounding = rewardAmount * quantity;
					break;
				case "amount" :
					discountAmountPreRounding = val(getService('HibachiUtilityService').precisionCalculate((arguments.price - rewardAmount) * arguments.quantity));
					break;
	        }
		}else{
			discountAmountPreRounding = 0;
		}

		if(!isNull(reward.getRoundingRule())) {
			roundedFinalAmount = getRoundingRuleService().roundValueByRoundingRule(value=val(getService('HibachiUtilityService').precisionCalculate(originalAmount - discountAmountPreRounding)), roundingRule=reward.getRoundingRule());
			discountAmount = val(getService('HibachiUtilityService').precisionCalculate(originalAmount - roundedFinalAmount));
		} else {
			discountAmount = discountAmountPreRounding;
		}

		// This makes sure that the discount never exceeds the original amount
		if(discountAmountPreRounding > originalAmount) {
			discountAmount = originalAmount;
		}

		return numberFormat(discountAmount, "0.00");
	}
    
    private numeric function getProportionalRewardAmount( required numeric priceDiscountAmount, required numeric price, numeric customPrice ){
    	if(!isNull(arguments.customPrice) && arguments.customPrice != 0){
    		var discountAmount = arguments.priceDiscountAmount * arguments.customPrice / arguments.price;
    		return numberFormat(discountAmount, "0.00");
    	}
    	return 0;
    }
    
    private void function applyPromotionQualifierMessagesToOrder(required any order, required array orderQualifierMessages){
		
		ArraySort(arguments.orderQualifierMessages,function(a,b){
			if(a.getPriority() <= b.getPriority()){
				return -1;
			}else{
				return 1;
			}
		});
		
		var maxMessages = getService('SettingService').getSettingValue('globalMaximumPromotionMessages');

		if(maxMessages < arrayLen(arguments.orderQualifierMessages)){
			arguments.orderQualifierMessages = arraySlice(arguments.orderQualifierMessages,1,maxMessages);
		}
		
		for(var promotionQualifierMessage in arguments.orderQualifierMessages){
			var newAppliedPromotionMessage = this.newPromotionMessageApplied();
			
			newAppliedPromotionMessage.setOrder( arguments.order );
			newAppliedPromotionMessage.setPromotionQualifierMessage( promotionQualifierMessage );
			newAppliedPromotionMessage.setMessage( promotionQualifierMessage.getInterpolatedMessage( arguments.order ) );
			newAppliedPromotionMessage.setPromotionPeriod(promotionQualifierMessage.getPromotionQualifier().getPromotionPeriod());
			newAppliedPromotionMessage.setPromotion(newAppliedPromotionMessage.getPromotionPeriod().getPromotion());

			var qualifierProgress = promotionQualifierMessage.getQualifierProgress( arguments.order );
			
			if( !isNull( qualifierProgress ) ){
				newAppliedPromotionMessage.setQualifierProgress( qualifierProgress );
			}
			
			this.savePromotionMessageApplied(newAppliedPromotionMessage);
		}

	}
	
	public void function updateOrderAmountsWithPromotions(required any order){
		super.updateOrderAmountsWithPromotions(arguments.order);
		
		var personalVolumeTotal = arguments.order.getPersonalVolumeTotal();
		var roundedPersonalVolumeTotal = round(personalVolumeTotal);
		var difference = personalVolumeTotal - roundedPersonalVolumeTotal;
		
		if(difference != 0){
			if(arguments.order.hasAppliedPromotion()){
				
				var appliedPromotion = arguments.order.getAppliedPromotions()[1];
				var currentPVDiscountAmount = appliedPromotion.getPersonalVolumeDiscountAmount();
				appliedPromotion.setPersonalVolumeDiscountAmount(currentPVDiscountAmount + difference);
			}else{
				
				this.allocatePersonalVolumeDiscountToOrderItems(arguments.order, difference);
			}
		}

	}
	
	public void function allocatePersonalVolumeDiscountToOrderItems(required any order, required amountToDistribute){
		// Allocate the order-level discount amount total in appropriate proportions to all order items and if necessary handle any remainder due to uneven division
		var actualAllocatedAmountTotal = 0;
		var actualAllocatedAmountAsPercentage = 0;
		var orderItemCount = 0;
		var orderItems = arguments.order.getOrderItems()  
		for (var orderItem in orderItems) {
			orderItemCount++;
			
			// The percentage of overall order discount that needs to be properly allocated to the order item. This is to perform weighted calculations.
			var currentOrderItemAmountAsPercentage=0;
			
			if(!isNull(arguments.order.getPersonalVolumeSubtotalAfterItemDiscounts()) && arguments.order.getPersonalVolumeSubtotalAfterItemDiscounts() != 0){
				currentOrderItemAmountAsPercentage = orderItem.getExtendedPersonalVolumeAfterDiscount() / arguments.order.getPersonalVolumeSubtotalAfterItemDiscounts();	
			}
			
			// Approximate amount to allocate (rounded to nearest penny)
		    var currentOrderItemAllocationAmount = round(currentOrderItemAmountAsPercentage * amountToDistribute * 100) / 100;
		    
		    var actualAllocatedAmountTotalUnadjusted = actualAllocatedAmountTotal + currentOrderItemAllocationAmount;
		    
		    // Recalculated each iteration for maximum precision of how much is expected to have been allocated at current stage in process
		    var expectedAllocatedAmountTotal = (actualAllocatedAmountAsPercentage + currentOrderItemAmountAsPercentage) * amountToDistribute;
		    
			// Rather than letting a sum of discrepancies accumulate during each iteration and become a significant adjustment to the final order item, lets handle it immediately and make minor adjustment to order item
			// This allows the discrepancy of no more than a cent to be accumulated, and appropriately allocated to the current order item when it first appears
			// NOTE: If instead we deferred handling the discrepancy the likelihood that a noticeable discrepancy will need to be offset on the final order item increases as the number of order items increases on an order.
		    var currentDiscrepancyAmount =  actualAllocatedAmountTotalUnadjusted - expectedAllocatedAmountTotal;
		    
		    // If there is a discrepancy greater than 1/2 cent let's deal with it now, adjust the allocation amount by rounding up or down to nearest cent
		    if (abs(currentDiscrepancyAmount) >= .005) {
		    	// Need to decrease the allocation amount by a cent to prevent over allocating
		        if (currentDiscrepancyAmount > 0) {
		            currentOrderItemAllocationAmount = (ceiling(currentOrderItemAllocationAmount * 100) - 1) / 100;
		            
		        // Need to increase the allocation by a cent to prevent under allocating 
		        } else if (currentDiscrepancyAmount < 0) {
		            currentOrderItemAllocationAmount = (floor(currentOrderItemAllocationAmount * 100) + 1) / 100;
		        }
		    }
		    
		    // Update the actuals to retain maximum precision
		    actualAllocatedAmountTotal += currentOrderItemAllocationAmount;
		    actualAllocatedAmountAsPercentage += currentOrderItemAmountAsPercentage;
		    
		    // Finally update the order item
		    if(orderItem.hasAppliedPromotion()){
		    	var appliedPromotion = orderItem.getAppliedPromotions()[1];
		    	var currentPVDiscountAmount = appliedPromotion.getPersonalVolumeDiscountAmount();
		    	
				appliedPromotion.setPersonalVolumeDiscountAmount(currentPVDiscountAmount + currentOrderItemAllocationAmount);
		    }else{
		    	var newAppliedPromotion = this.newPromotionApplied();
				newAppliedPromotion.setAppliedType('orderItem');
				newAppliedPromotion.setOrderItem( orderItem );
				newAppliedPromotion.setPersonalVolumeDiscountAmount( currentOrderItemAllocationAmount );
				
				this.savePromotionApplied(newAppliedPromotion);
		    }
		}
	}
}
