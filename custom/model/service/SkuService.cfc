component extends="Slatwall.model.service.SkuService" accessors="true" output="false" {

	public any function getPriceBySkuIDAndCurrencyCodeAndQuantity(required string skuID, required string currencyCode, required numeric quantity, array priceGroups) {

		var skuPriceResults = getDAO("SkuPriceDAO").getSkuPricesForSkuCurrencyCodeAndQuantity(argumentCollection=arguments);

		var price = "null";

		if(!isNull(skuPriceResults) && isArray(skuPriceResults) && arrayLen(skuPriceResults) > 0){

			ArraySort( skuPriceResults, function (a, b) {

			    // equal items sort equally
			    if (a['price'] === b['price']) {
			        return 0;
			    }
			    
			    // nulls sort after anything else
			    else if ( IsNull(a['price']) ) {
			        return 1;
			    } else if ( IsNull(b['price']) ) {
			        return -1;
			    }

			    // otherwise, we're ascending, lowest sorts first
			     return a['price'] < b['price'] ? -1 : 1;
			 });

			if( !IsNull(skuPriceResults[1]['price']) ) {
				price = skuPriceResults[1]['price']; // if it's not null it's the lowest price;
			}
		}

		return price; //not returning return the NULL null, as cf won't set that in any var
	}

	public any function processSku_skuImport(required sku, required any processObject) {
		
		getHibachiScope()
			.getService('integrationService')
			.getIntegrationByIntegrationPackage('monat')
			.getIntegrationCFC("data")
			.importMonatProducts({ 'days' : 1 });

		return arguments.sku;
	}
}

