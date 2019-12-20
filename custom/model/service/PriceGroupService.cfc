component extends="Slatwall.model.service.priceGroupService" accessors="true" {

	public void function updateOrderAmountsWithPriceGroups(required any order) {

		//If this order isn't an UPGRADE order go back to core function
		if(isNull(arguments.order.getUpgradeFlag()) || !arguments.order.getUpgradeFlag() || (arguments.order.getUpgradeFlag() && isNull(arguments.order.getPriceGroup()))){
			return super.updateOrderAmountsWithPriceGroups(argumentCollection=arguments);
		}
	
		if(isNull(arguments.order.getAccount())){
			return;
		}

		var priceGroup = arguments.order.getPriceGroup();

		var totalQuantity = arguments.order.getTotalItemQuantity();
		var priceGroupCacheKey = hash(totalQuantity & priceGroup.getPriceGroupID(),'md5');
		
		if( isNull(arguments.order.getPriceGroupCacheKey()) || arguments.order.getPriceGroupCacheKey() != priceGroupCacheKey ) {
			arguments.order.setPriceGroupCacheKey(priceGroupCacheKey);
			var orderItems = arguments.order.getOrderItems(); 
			for(var orderItem in orderItems){
				orderItem.setAppliedPriceGroup( priceGroup );
				orderItem.refreshAmounts();
				orderItem.updateCalculatedProperties();
			}
		}
	}
}