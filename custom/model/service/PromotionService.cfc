component extends="Slatwall.model.service.PromotionService" {
    
    private void function applyTop1Discounts(required any order, required any orderItemQualifiedDiscounts){
        var customPriceFields = 'personalVolume,taxableAmount,commissionableVolume,sponsorVolume,productPackVolume,retailValueVolume';
		// Loop over the orderItems one last time, and look for the top 1 discounts that can be applied
		for(var i=1; i<=arrayLen(arguments.order.getOrderItems()); i++) {

			var orderItem = arguments.order.getOrderItems()[i];
			// If the orderItemID exists in the qualifiedDiscounts, and the discounts have at least 1 value we can apply that top 1 discount
			if(structKeyExists(arguments.orderItemQualifiedDiscounts, orderItem.getOrderItemID()) && arrayLen(arguments.orderItemQualifiedDiscounts[ orderItem.getOrderItemID() ]) ) {
				var promotionReward = this.getPromotionReward(arguments.orderItemQualifiedDiscounts[ orderItem.getOrderItemID() ][1].promotionRewardID);
				
				var newAppliedPromotion = this.newPromotionApplied();
				newAppliedPromotion.setAppliedType('orderItem');
				newAppliedPromotion.setPromotion( arguments.orderItemQualifiedDiscounts[ orderItem.getOrderItemID() ][1].promotion );
				newAppliedPromotion.setOrderItem( orderItem );
				newAppliedPromotion.setDiscountAmount( arguments.orderItemQualifiedDiscounts[ orderItem.getOrderItemID() ][1].discountAmount );
			    
			    //Custom price fields
			    for(var customPriceField in customPriceFields){
			        var args = {
			            reward=promotionReward,
			            price=orderItem.invokeMethod('get#customPriceField#'),
			            quantity=orderItem.getQuantity(),
			            customPriceField=customPriceField
			        };

	        		newAppliedPromotion.invokeMethod('set#customPriceField#DiscountAmount',{1=getDiscountAmount(argumentCollection=args)});
			    }

				//making sure calculated props run
				getHibachiScope().addModifiedEntity(orderItem);
			}

		}
	}
	
	private numeric function getDiscountAmount(required any reward, required numeric price, required numeric quantity, string currencyCode, string customPriceField) {
		var discountAmountPreRounding = 0;
		var roundedFinalAmount = 0;
		var originalAmount = val(getService('HibachiUtilityService').precisionCalculate(arguments.price * arguments.quantity));
		
        if(structKeyExists(arguments,'customPriceField') && reward.getAmountType() == "percentageOff"){
            
			discountAmountPreRounding = val(getService('HibachiUtilityService').precisionCalculate(originalAmount * (reward.invokeMethod('get#customPriceField#Amount')/100)));
        
        }else{
    		if(structKeyExists(arguments, "currencyCode") && len(arguments.currencyCode)){
    			switch(reward.getAmountType()) {
    				case "percentageOff" :
    					discountAmountPreRounding = val(getService('HibachiUtilityService').precisionCalculate(originalAmount * (reward.getAmountByCurrencyCode(arguments.currencyCode)/100)));
    					break;
    				case "amountOff" :
    					discountAmountPreRounding = reward.getAmountByCurrencyCode(arguments.currencyCode) * quantity;
    					break;
    				case "amount" :
    					discountAmountPreRounding = val(getService('HibachiUtilityService').precisionCalculate((arguments.price - reward.getAmountByCurrencyCode(arguments.currencyCode)) * arguments.quantity));
    					break;
    			}
    		}else{
    			switch(reward.getAmountType()) {
    				case "percentageOff" :
    					discountAmountPreRounding = val(getService('HibachiUtilityService').precisionCalculate(originalAmount * (reward.getAmount()/100)));
    					break;
    				case "amountOff" :
    					discountAmountPreRounding = reward.getAmount() * quantity;
    					break;
    				case "amount" :
    					discountAmountPreRounding = val(getService('HibachiUtilityService').precisionCalculate((arguments.price - reward.getAmount()) * arguments.quantity));
    					break;
    			}
    		}
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
    
}