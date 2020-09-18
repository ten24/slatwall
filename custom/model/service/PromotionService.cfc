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

		if(arguments.order.getDropSkuRemovedFlag()){
			return;
		}
		
		var skuService = getService('skuService');
		var currencyCode = arguments.order.getCurrencyCode();
		if(isNull(currencyCode)){
			return;
		}
		
		for(var item in arguments.itemsToBeAdded){
			
			var sku = skuService.getSku(item.skuID);
			if(isNull(sku)){
				continue;
			}

			var newOrderItem = getService("OrderService").newOrderItem();
			var priceFields = ['personalVolume', 'taxableAmount', 'commissionableVolume', 'retailCommission', 'productPackVolume', 'retailValueVolume', 'listPrice', 'price', 'skuPrice'];
			for(var priceField in priceFields){
				newOrderItem.invokeMethod('set#priceField#', {1=0});
			}
			
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
	
			getService('orderService').saveOrderItem(newOrderItem);
			
			if(!newOrderItem.hasErrors()){

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
		newPromotionPeriod.setPromotion(arguments.processObject.getPromotion());
		
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
			
			var currencies = promotionReward.getPromotionRewardCurrencies();
			if(arrayLen(currencies)) {
				for(var promotionRewardCurrency in currencies) {
					newPromotionReward.addPromotionRewardCurrency(promotionRewardCurrency);
				}
			}
			
			var priceGroups = promotionReward.getEligiblePriceGroups();
			if(arrayLen(priceGroups)) {
				for(var eligiblePriceGroup in priceGroups ) {
					newPromotionReward.addEligiblePriceGroup(eligiblePriceGroup);
				}
			}
			
			var fulfillments = promotionReward.getFulfillmentMethods();
			if(arrayLen(fulfillments)) {
				for(var fulfillmentMethod in fulfillments ) {
					newPromotionReward.addFulfillmentMethod(fulfillmentMethod);
				}
			}
			
			var addresses = promotionReward.getShippingAddressZones();
			if(arrayLen(addresses)) {
				for(var shippingAddressZone in addresses ) {
					newPromotionReward.addShippingAddressZone(shippingAddressZone);
				}
			}
			
			var shipMethods = promotionReward.getShippingMethods();
			if(arrayLen(shipMethods)) {
				for(var shippingMethod in shipMethods) {
					newPromotionReward.addShippingMethod(shippingMethod);
				}
			}
			
			var brands = promotionReward.getBrands();
			if(arrayLen(brands)) {
				for(var brand in brands) {
					newPromotionReward.addBrand(brand);
				}
			}
			
			var options = promotionReward.getOptions();
			if(arrayLen(options)) {
				for(var option in options) {
					newPromotionReward.addOption(option);
				}
			}
			
			var skus = promotionReward.getSkus();
			if(arrayLen(skus)) {
				for(var sku in skus) {
					newPromotionReward.addSku(sku);
				}
			}
			
			var products = promotionReward.getProducts();
			if(arrayLen(products)) {
				for(var product in products) {
					newPromotionReward.addProduct(product);
				}
			}
			
			var productTypes = promotionReward.getProductTypes();
			if(arrayLen(productTypes)) {
				for(var productType in productTypes) {
					newPromotionReward.addProductType(productType);
				}
			}
			
			var excludedBrands = promotionReward.getExcludedBrands();
			if(arrayLen(excludedBrands)) {
				for(var excludedBrand in excludedBrands) {
					newPromotionReward.addExcludedBrand(excludedBrand);
				}
			}
			
			var excludedOptions = promotionReward.getExcludedOptions();
			if(arrayLen(excludedOptions)) {
				for(var excludedOption in excludedOptions) {
					newPromotionReward.addExcludedOption(excludedOption);
				}
			}
			
			var excludedSkus = promotionReward.getExcludedSkus();
			if(arrayLen(excludedSkus)) {
				for(var excludedSku in excludedSkus) {
					newPromotionReward.addExcludedSkus(excludedSku);
				}
			}
			
			var excludedProducts = promotionReward.getExcludedProducts();
			if(arrayLen(excludedProducts)) {
				for(var excludedProduct in excludedProducts) {
					newPromotionReward.addExcludedProduct(excludedProduct);
				}
			}
			
			var excludedProductTypes = promotionReward.getExcludedProductTypes();
			if(arrayLen(excludedProductTypes)) {
				for(var excludedProductType in excludedProductTypes) {
					newPromotionReward.addExcludedProductType(excludedProductType);
				}
			}
			
			if( !isNull( promotionReward.getExcludedSkusCollectionConfig() ) 
				&& len( promotionReward.getExcludedSkusCollectionConfig() ) )
			{
				newPromotionReward.setExcludedSkusCollectionConfig( promotionReward.getExcludedSkusCollectionConfig() );	
			} 
				
			if( !isNull(promotionReward.getIncludedSkusCollectionConfig() )
				&& len( promotionReward.getIncludedSkusCollectionConfig() ) )
			{
				newPromotionReward.setIncludedSkusCollectionConfig( promotionReward.getIncludedSkusCollectionConfig() );
			}
			
			if( !isNull(promotionReward.getRewardSkuQuantity()) ){
				newPromotionReward.setRewardSkuQuantity(promotionReward.getRewardSkuQuantity())
			}
			
			if( !isNull(promotionReward.getShowRewardSkuInCartFlag()) ){
				newPromotionReward.setShowRewardSkuInCartFlag(promotionReward.getShowRewardSkuInCartFlag())
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

}
