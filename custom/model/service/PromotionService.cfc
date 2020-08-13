component extends="Slatwall.model.service.PromotionService" {
    
    public function init(){
    	super.init(argumentCollection=arguments);
    	variables.customPriceFields = 'personalVolume,taxableAmount,commissionableVolume,retailCommission,productPackVolume,retailValueVolume';
    }
	
	private boolean function applyPromotionToOrderItemIfValid( required any orderItem, required struct rewardStruct ){
		var appliedPromotions = arguments.orderItem.getAppliedPromotions();
		var order = arguments.orderItem.getOrder();
		if(arguments.orderItem.getOrder().hasOrderTemplate()){
			logHibachi('Checking stacking for #rewardStruct.promotionReward.getPromotionPeriod().getPromotion().getPromotionName()#');
		}
		if( rewardCanStack( appliedPromotions, arguments.rewardStruct.promotionReward )){
			if(arguments.orderItem.getOrder().hasOrderTemplate()){
				logHibachi('Can stack');
			}
			var extendedUnitPriceAfterDiscount = arguments.orderItem.getExtendedUnitPriceAfterDiscount();
			
			if(len(appliedPromotions) && arguments.rewardStruct.promotionReward.getAmountType() == 'percentageOff'){
				//Recalculate discount amount based on new price
				arguments.rewardStruct.discountAmount = getDiscountAmount(reward=arguments.rewardStruct.promotionReward, price=extendedUnitPriceAfterDiscount, quantity=arguments.rewardStruct.discountQuantity, currencyCode=arguments.orderItem.getCurrencyCode(), sku=arguments.orderItem.getSku(), account=order.getAccount());
			}
			//Custom price fields
		    for(var customPriceField in variables.customPriceFields){
				var extendedCustomUnitPriceAfterDiscount = arguments.orderItem.invokeMethod('getExtended#customPriceField#AfterDiscount') / arguments.orderItem.getQuantity();
				if(arguments.rewardStruct.promotionReward.getAmountType() == 'amountOff'){
					var rewardAmount = getProportionalRewardAmount(arguments.rewardStruct.discountAmount, extendedUnitPriceAfterDiscount,extendedCustomUnitPriceAfterDiscount);
				}else{
			        var args = {
			            reward=arguments.rewardStruct.promotionReward,
			            price=extendedCustomUnitPriceAfterDiscount,
			            quantity=arguments.rewardStruct.discountQuantity,
			            customPriceField=customPriceField,
			            sku=arguments.orderItem.getSku(),
			            account=order.getAccount()
			        };
			        var rewardAmount = getCustomDiscountAmount(argumentCollection=args);
				}
				arguments.rewardStruct['#customPriceField#DiscountAmount'] = rewardAmount;
        		
		    }

			applyPromotionToOrderItem( arguments.orderItem, arguments.rewardStruct );

			return true;
		}
		return false;
	}
	
	private void function applyPromotionToOrder(required any order,required any rewardStruct){
		var newAppliedPromotion = this.newPromotionApplied();
		newAppliedPromotion.setAppliedType('order');
		newAppliedPromotion.setPromotion( arguments.rewardStruct.promotion );
		newAppliedPromotion.setPromotionReward( arguments.rewardStruct.promotionReward );
		newAppliedPromotion.setOrder( arguments.order );
		
		for(var key in arguments.rewardStruct){
			if(right(key,14) == 'DiscountAmount'){
				newAppliedPromotion.invokeMethod('set#key#',{1=arguments.rewardStruct[key]});
			}
		}
	}
	
	private void function applyPromotionToOrderItem( required any orderItem, required struct rewardStruct ){
		if(arguments.orderItem.getOrder().hasOrderTemplate()){
			logHibachi('Applying promotion for #rewardStruct.promotionReward.getPromotionPeriod().getPromotion().getPromotionName()#');
		}
		var newAppliedPromotion = this.newPromotionApplied();
		newAppliedPromotion.setAppliedType('orderItem');
		newAppliedPromotion.setPromotion( arguments.rewardStruct.promotion );
		newAppliedPromotion.setPromotionReward( arguments.rewardStruct.promotionReward );
		newAppliedPromotion.setOrderItem( arguments.orderItem );
		
		if(!isNull(arguments.rewardStruct.sku)){
			newAppliedPromotion.setRewardSku(arguments.rewardStruct.sku);
		}
		
		for(var key in arguments.rewardStruct){
			if(right(key,14) == 'DiscountAmount'){
				newAppliedPromotion.invokeMethod('set#key#',{1=arguments.rewardStruct[key]});
			}
		}
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
			
			for(var customPriceField in variables.customPriceFields){
				var totalCustomDiscountableAmount = arguments.order.invokeMethod('get#customPriceField#SubtotalAfterItemDiscounts');
				if(!isNull(totalCustomDiscountableAmount)){
					if(arguments.promotionReward.getAmountType() == 'amountOff'){
						var rewardAmount = getProportionalRewardAmount( discountAmount, totalDiscountableAmount, totalCustomDiscountableAmount );
					}else{
						var rewardAmount = getCustomDiscountAmount(arguments.promotionReward, totalCustomDiscountableAmount, 1, arguments.order.getCurrencyCode(),customPriceField);
					}
					rewardStruct['#customPriceField#DiscountAmount'] = rewardAmount;
				}
			}
			
			// Insert this value into the potential discounts array
			arrayAppend(arguments.orderQualifiedDiscounts, rewardStruct);
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
		if(arguments.reward.getAmountType() != "amountOff"){
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
			switch(arguments.reward.getAmountType()) {
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

		if(!isNull(arguments.reward.getRoundingRule())) {
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
    
    private numeric function getProportionalRewardAmount( required numeric priceDiscountAmount, required numeric price, numeric customPrice ){
    	if(!isNull(arguments.customPrice) && arguments.customPrice != 0){
    		var discountAmount = arguments.priceDiscountAmount * arguments.customPrice / arguments.price;
    		return numberFormat(discountAmount, "0.00");
    	}
    	return 0;
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
				
				
				var qualifierProgress = promotionQualifierMessage.getQualifierProgress( arguments.order );
				
				if( !isNull( qualifierProgress ) ){
					newAppliedPromotionMessage.setQualifierProgress( qualifierProgress );
				}
				
				this.savePromotionMessageApplied(newAppliedPromotionMessage);
				messagesApplied++;
			}
			
			if(messagesApplied == maxMessages){
				break;
			}
		}

	}
	
	public void function updateOrderAmountsWithPromotions(required any order){
		super.updateOrderAmountsWithPromotions(arguments.order);
		
		var personalVolumeTotal = arguments.order.getPersonalVolumeTotal();
		var roundedPersonalVolumeTotal = round(personalVolumeTotal);
		var difference = personalVolumeTotal - roundedPersonalVolumeTotal;
		
		if(difference != 0){
			if( arguments.order.hasAppliedPromotion() ){
				var appliedPromotion = arguments.order.getAppliedPromotions()[1];
				var currentPVDiscountAmount = appliedPromotion.getPersonalVolumeDiscountAmount();
				if( !isNull(currentPVDiscountAmount) ){
				    appliedPromotion.setPersonalVolumeDiscountAmount(currentPVDiscountAmount + difference);
				}
			}
			else {
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
			
			var personalVolumeSubtotalAfterItemDiscounts = arguments.order.getPersonalVolumeSubtotalAfterItemDiscounts();
			if(!isNull(personalVolumeSubtotalAfterItemDiscounts) && personalVolumeSubtotalAfterItemDiscounts != 0){
				currentOrderItemAmountAsPercentage = orderItem.getExtendedPersonalVolumeAfterDiscount() / personalVolumeSubtotalAfterItemDiscounts;	
			}
			
			// Approximate amount to allocate (rounded to nearest penny)
		    var currentOrderItemAllocationAmount = round(currentOrderItemAmountAsPercentage * arguments.amountToDistribute * 100) / 100;
		    
		    var actualAllocatedAmountTotalUnadjusted = actualAllocatedAmountTotal + currentOrderItemAllocationAmount;
		    
		    // Recalculated each iteration for maximum precision of how much is expected to have been allocated at current stage in process
		    var expectedAllocatedAmountTotal = (actualAllocatedAmountAsPercentage + currentOrderItemAmountAsPercentage) * arguments.amountToDistribute;
		    
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
	
	public void function addRewardSkusToOrder(required array itemsToBeAdded, required any order, required any fulfillment){
	logHibachi('=============================adding reward skus to order =============================')
		if(arguments.order.getDropSkuRemovedFlag()){
				logHibachi('=============================DROP SKU REMOVED FLAG WAS SET =============================')
			return;
		}
		
		var skuService = getService('skuService');
		var currencyCode = arguments.order.getCurrencyCode() ?: 'USD';
		for(var item in arguments.itemsToBeAdded){
			
			var sku = skuService.getSku(item.skuID);
			if(isNull(sku)){
				continue;
			}
			logHibachi('=============================#sku.getSkuID()# =============================')
			var newOrderItem = getService("OrderService").newOrderItem();
			newOrderItem.setPrice(0);
			newOrderItem.setSkuPrice(0);
			newOrderItem.setUserDefinedPriceFlag(true);
			newOrderItem.setOrderItemType( getService('typeService').getTypeBySystemCode('oitSale') );
			newOrderItem.setOrderFulfillment( arguments.fulfillment );
			newOrderItem.setQuantity( item.quantity );
			newOrderItem.setSku(sku);
			newOrderItem.setOrder(arguments.order);
			newOrderItem.setRewardSkuFlag(true);
			newOrderItem.setCurrencyCode(currencyCode);
			var showInCartFlag = item.promotionReward.getShowRewardSkuInCartFlag() ?: true;
			newOrderItem.setShowInCartFlag(showInCartFlag);
			logHibachi('=============================order item has price: #newOrderItem.getPrice()#')
			getService('orderService').saveOrderItem(newOrderItem);
			
			if(!newOrderItem.hasErrors()){
				logHibachi('=============================order item has no errors #newOrderItem.getOrderItemID()#=============================');
				getPromotionDAO().insertAppliedPromotionFromOrderItem(
						orderItemID=newOrderItem.getOrderItemID(), 
						promotionID =item.promotion.getPromotionID(),
						promotionRewardID= item.promotionReward.getPromotionRewardID(),
						skuID=sku.getSkuID()
					);
			}
		}
		arguments.itemsToBeAdded = [];
	}
}
