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
			
			var priceGroups = getHibachiScope().getAccount().getPriceGroups();
			var priceGroupCode = arrayLen(priceGroups) ? priceGroups[1].getPriceGroupCode() : "";
			var currencyCode = getHibachiScope().getCurrentRequestSite().setting('skuCurrency');
			var priceGroupService = getHibachiScope().getService('priceGroupService');
			var hibachiUtilityService = getHibachiScope().getService('hibachiUtilityService');
			
			var vipPriceGroup = priceGroupService.getPriceGroupByPriceGroupCode(3);
			var retailPriceGroup = priceGroupService.getPriceGroupByPriceGroupCode(2);
			var mpPriceGroup = priceGroupService.getPriceGroupByPriceGroupCode(1);
			var adjustedAccountPrice = this.getSku().getPriceByCurrencyCode(currencyCode);
			var adjustedVipPrice = this.getSku().getPriceByCurrencyCode(currencyCode,1,[vipPriceGroup]);
			var adjustedRetailPrice = this.getSku().getPriceByCurrencyCode(currencyCode,1,[retailPriceGroup]);
			var adjustedMPPrice = this.getSku().getPriceByCurrencyCode(currencyCode,1,[MPPriceGroup]);
			var mpPersonalVolume = this.getSku().getPersonalVolumeByCurrencyCode()?:0;
			
			var formattedAccountPricing = hibachiUtilityService.formatValue_currency(adjustedAccountPrice, {currencyCode:currencyCode});
			var formattedVipPricing = hibachiUtilityService.formatValue_currency(adjustedVipPrice, {currencyCode:currencyCode});
			var formattedRetailPricing = hibachiUtilityService.formatValue_currency(adjustedRetailPrice, {currencyCode:currencyCode});
			var formattedMPPricing = hibachiUtilityService.formatValue_currency(adjustedMPPrice, {currencyCode:currencyCode});
			
			var skuAdjustedPricing = {
				adjustedPriceForAccount = formattedAccountPricing,
				vipPrice = formattedVipPricing,
				retailPrice = formattedRetailPricing,
				MPPrice = formattedMPPricing,
				personalVolume = mpPersonalVolume,
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
