component {

	property name="commissionableVolumeTotal" persistent="false"; 
	property name="personalVolumeTotal" persistent="false"; 
	property name="skuProductURL" persistent="false";
	property name="skuImagePath" persistent="false";
	property name="skuAdjustedPricing" persistent="false";

	
	public any function getSkuProductURL(){
		var skuProductURL = this.getSku().getProduct().getProductURL();
		return skuProductURL;
	}
	
	public any function getSkuImagePath(){
		var skuImagePath = this.getSku().getImagePath();
		return skuImagePath;
	}
	
	public any function getSkuAdjustedPricing(){
			
			var pricegroups = getHibachiScope().getAccount().getPriceGroups();
			var priceGroupCode = arrayLen(pricegroups) ? pricegroups[1].getPriceGroupCode() : "";
			var currencyCode = getHibachiScope().getCurrentRequestSite().setting('skuCurrency');
			var vipPriceGroup = getHibachiScope().getService('PriceGroupService').getPriceGroupByPriceGroupCode(3);
			var retailPriceGroup = getHibachiScope().getService('PriceGroupService').getPriceGroupByPriceGroupCode(2);
			var MPPriceGroup = getHibachiScope().getService('PriceGroupService').getPriceGroupByPriceGroupCode(1);

			
			var adjustedAccountPrice = this.getSku().getPriceByCurrencyCode(currencyCode);
			var adjustedVipPrice = this.getSku().getPriceByCurrencyCode(currencyCode,1,[vipPriceGroup]);
			var adjustedRetailPrice = this.getSku().getPriceByCurrencyCode(currencyCode,1,[retailPriceGroup]);
			var adjustedMPPrice = this.getSku().getPriceByCurrencyCode(currencyCode,1,[MPPriceGroup]);
			var mPPersonalVolume = this.getSku().getPersonalVolumeByCurrencyCode()?:0;
			
			var formattedAccountPricing = getHibachiScope().getService('hibachiUtilityService').formatValue_currency(adjustedAccountPrice, {currencyCode:currencyCode});
			var formattedVipPricing = getHibachiScope().getService('hibachiUtilityService').formatValue_currency(adjustedVipPrice, {currencyCode:currencyCode});
			var formattedRetailPricing = getHibachiScope().getService('hibachiUtilityService').formatValue_currency(adjustedRetailPrice, {currencyCode:currencyCode});
			var formattedMPPricing = getHibachiScope().getService('hibachiUtilityService').formatValue_currency(adjustedMPPrice, {currencyCode:currencyCode});
			var formattedPersonalVolume = getHibachiScope().getService('hibachiUtilityService').formatValue_currency(mPPersonalVolume, {currencyCode:currencyCode});
			
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
	
	public numeric function getCommissionVolumeTotal(string currencyCode, string accountID){
		if(!structKeyExists(variables, 'commissionVolumeTotal')){
			variables.commissionVolumeTotal = 0; 
			
			if( !isNull(this.getSku()) && 
				!isNull(this.getQuantity())
			){
				variables.commissionVolumeTotal += (this.getSku().getCommissionVolumeByCurrencyCode(argumentCollection=arguments) * this.getQuantity()); 
			}	
		}
		return variables.commissionVolumeTotal; 	
	}	

	public numeric function getPersonalVolumeTotal(string currencyCode, string accountID){
		if(!structKeyExists(variables, 'personalVolumeTotal')){
			variables.personalVolumeTotal = 0; 
			
			if( !isNull(this.getSku()) && 
				!isNull(this.getQuantity())
			){
				variables.personalVolumeTotal += (this.getSku().getPersonalVolumeByCurrencyCode(argumentCollection=arguments) * this.getQuantity()); 
			}	
		}
		return variables.personalVolumeTotal; 	
	} 
}
