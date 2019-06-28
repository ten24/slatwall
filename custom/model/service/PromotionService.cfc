component extends="Slatwall.model.service.PromotionService" {
    
    public function init(){
    	super.init(argumentCollection=arguments);
    	variables.customPriceFields = 'personalVolume,taxableAmount,commissionableVolume,retailCommission,productPackVolume,retailValueVolume';
    }
    private void function applyTop1Discounts(required any order, required any orderItemQualifiedDiscounts){

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
			    for(var customPriceField in variables.customPriceFields){
			        var args = {
			            reward=promotionReward,
			            price=orderItem.invokeMethod('get#customPriceField#'),
			            quantity=orderItem.getQuantity(),
			            customPriceField=customPriceField,
			            sku=orderItem.getSku(),
			            account=arguments.order.getAccount()
			        };

	        		newAppliedPromotion.invokeMethod('set#customPriceField#DiscountAmount',{1=getCustomDiscountAmount(argumentCollection=args)});
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
		var totalDiscountableAmount = arguments.order.getSubtotalAfterItemDiscounts() + arguments.order.getFulfillmentChargeAfterDiscountTotal();

		var discountAmount = getDiscountAmount(arguments.promotionReward, totalDiscountableAmount, 1, order.getCurrencyCode());

		var customDiscountAmountStruct = {};
		for(var customPriceField in customPriceFields){
			var totalCustomDiscountableAmount = arguments.order.invokeMethod('get#customPriceField#SubtotalAfterItemDiscounts');
			if(!isNull(totalCustomDiscountableAmount)){
				customDiscountAmountStruct[customPriceField] = getCustomDiscountAmount(arguments.promotionReward, totalCustomDiscountableAmount, 1, order.getCurrencyCode(),customPriceField);
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
			applyPromotionToOrder(arguments.order,arguments.promotionReward.getPromotionPeriod().getPromotion(),discountAmount);
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
    
}