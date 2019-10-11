component {
    property name="personalVolume" ormtype="big_decimal";
    property name="taxableAmount" ormtype="big_decimal";
    property name="commissionableVolume" ormtype="big_decimal";
    property name="retailCommission" ormtype="big_decimal";
    property name="productPackVolume" ormtype="big_decimal";
    property name="retailValueVolume" ormtype="big_decimal";
	property name="skuProductURL" persistent="false";
	property name="skuImagePath" persistent="false";
	property name="skuAdjustedPricing" persistent="false";
	
	public any function getSkuProductURL(){
		var skuProductURL = getSku().getProduct().getProductURL();
		return skuProductURL;
	}
	
	public any function getSkuImagePath(){
		var skuImagePath = getSku().getImagePath();
		return skuImagePath;
	}
	
	public any function getSkuAdjustedPricing(){
			
		var pricegroups = getHibachiScope().getAccount().getPriceGroups();
		var priceGroupCode = arrayLen(pricegroups) ? pricegroups[1].getPriceGroupCode() : "";
		var priceGroupService = getHibachiScope().getService('PriceGroupService');
		var utilityService = getHibachiScope().getService('hibachiUtilityService');
		
		/*** TODO: FIGURE OUT HOW TO GET SITE SETTING FOR getSku() AND WISHLIST AS WELL ***/
		var currencyCode = 'usd';//getHibachiScope().getCurrentRequestSite().setting('skuCurrency');
		var vipPriceGroup = priceGroupService.getPriceGroupByPriceGroupCode(3);
		var retailPriceGroup = priceGroupService.getPriceGroupByPriceGroupCode(2);
		var MPPriceGroup = priceGroupService.getPriceGroupByPriceGroupCode(1);

		var adjustedAccountPrice = getSku().getPriceByCurrencyCode(currencyCode);
		var adjustedVipPrice = getSku().getPriceByCurrencyCode(currencyCode,1,[vipPriceGroup]);
		var adjustedRetailPrice = getSku().getPriceByCurrencyCode(currencyCode,1,[retailPriceGroup]);
		var adjustedMPPrice = getSku().getPriceByCurrencyCode(currencyCode,1,[MPPriceGroup]);
		var mPPersonalVolume = getSku().getPersonalVolumeByCurrencyCode()?:0;
		
		var formattedAccountPricing = utilityService.formatValue_currency(adjustedAccountPrice, {currencyCode:currencyCode});
		var formattedVipPricing = utilityService.formatValue_currency(adjustedVipPrice, {currencyCode:currencyCode});
		var formattedRetailPricing = utilityService.formatValue_currency(adjustedRetailPrice, {currencyCode:currencyCode});
		var formattedMPPricing = utilityService.formatValue_currency(adjustedMPPrice, {currencyCode:currencyCode});
		var formattedPersonalVolume = utilityService.formatValue_currency(mPPersonalVolume, {currencyCode:currencyCode});
		
		var skuAdjustedPricing = {
			adjustedPriceForAccount = formattedAccountPricing,
			vipPrice = formattedVipPricing,
			retailPrice = formattedRetailPricing,
			MPPrice = formattedMPPricing,
			personalVolume = formattedPersonalVolume,
			accountPriceGroup = priceGroupCode
		};

		return skuAdjustedPricing;
	}
}