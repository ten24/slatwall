component extends="Slatwall.model.service.SkuService" accessors="true" output="false" {
	
	
	public any function getPriceBySkuIDAndCurrencyCodeAndQuantity(required string skuID, required string currencyCode, required numeric quantity, array priceGroups) {
		
		var skuPriceResults = getDAO("SkuPriceDAO").getSkuPricesForSkuCurrencyCodeAndQuantity(argumentCollection=arguments);
		
		if(!isNull(skuPriceResults) && isArray(skuPriceResults) && arrayLen(skuPriceResults) > 0){
			var prices = [];
			for(var i=1; i <= arrayLen(skuPriceResults); i++){
				if(isNull(skuPriceResults[i]['price'])){
					skuPriceResults[i]['price'] = 0; //
				}
				ArrayAppend(prices, skuPriceResults[i]['price']);
			}
			
			ArraySort(prices, "numeric","asc");
			return prices[1];
		}
		
		return "null"; //can't return null as cf won't set that in the struct
	}

	
}
