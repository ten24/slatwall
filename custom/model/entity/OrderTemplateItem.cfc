component {

	//calculated properties
	property name="calculatedCommissionableVolumeTotal" ormtype="integer";
	property name="calculatedPersonalVolumeTotal" ormtype="integer";
	property name="calculatedProductPackVolumeTotal" ormtype="integer"; 
	property name="calculatedRetailCommissionTotal" ormtype="integer"; 
	property name="calculatedListPrice" ormtype="big_decimal" hb_formatType="currency";
	
	//non-persistent properties
	property name="commissionableVolumeTotal" persistent="false"; 
	property name="personalVolumeTotal" persistent="false";
	property name="productPackVolumeTotal" persistent="false"; 
	property name="retailComissionTotal" persistent="false"; 
	property name="skuProductURL" persistent="false";
	property name="skuImagePath" persistent="false";
	property name="skuAdjustedPricing" persistent="false";
	property name="kitFlagCode" ormtype="string";
	property name="skuPriceByCurrencyCode" persistent="false" hb_formatType="currency";
	property name="listPrice" persistent="false";
	
	public any function getSkuProductURL(){
		var skuProductURL = this.getSku().getProduct().getProductURL();
		return skuProductURL;
	}
	
	public any function getSkuImagePath(){
		var skuImagePath = this.getSku().getImagePath();
		return skuImagePath;
	}

	public numeric function getSkuPriceByCurrencyCode(){
		var priceGroups = !isNull(this.getOrderTemplate().getAccount()) ? this.getOrderTemplate().getAccount().getPriceGroups() : [this.getOrderTemplate().getPriceGroup()];
		return sku.getPriceByCurrencyCode(currencyCode=this.getOrderTemplate().getCurrencyCode(), priceGroups=priceGroups);   
	} 
	
	public any function getSkuAdjustedPricing(){
			
			var priceGroups = !isNull(this.getOrderTemplate().getAccount()) ? this.getOrderTemplate().getAccount().getPriceGroups() : [this.getOrderTemplate().getPriceGroup()];
			var priceGroupCode = arrayLen(priceGroups) ? priceGroups[1].getPriceGroupCode() : "";
			var priceGroupService = getHibachiScope().getService('priceGroupService');
			var hibachiUtilityService = getHibachiScope().getService('hibachiUtilityService');
			var currencyCode = this.getOrderTemplate().getCurrencyCode() ?: 'USD';
			var vipPriceGroup = priceGroupService.getPriceGroupByPriceGroupCode(3);
			var retailPriceGroup = priceGroupService.getPriceGroupByPriceGroupCode(2);
			var mpPriceGroup = priceGroupService.getPriceGroupByPriceGroupCode(1);
			var sku = this.getSku();
			var adjustedAccountPrice = sku.getPriceByCurrencyCode(currencyCode) ?: 0;
			var adjustedVipPrice = sku.getPriceByCurrencyCode(currencyCode,1,[vipPriceGroup]) ?: 0;
			var adjustedRetailPrice = sku.getPriceByCurrencyCode(currencyCode,1,[retailPriceGroup]) ?: 0;
			var adjustedMPPrice = sku.getPriceByCurrencyCode(currencyCode,1,[MPPriceGroup]) ?: 0;
			var mpPersonalVolume = sku.getPersonalVolumeByCurrencyCode(currencyCode)?:0;
			
			// var formattedAccountPricing = hibachiUtilityService.formatValue_currency(adjustedAccountPrice, {currencyCode:currencyCode});
			// var formattedVipPricing = hibachiUtilityService.formatValue_currency(adjustedVipPrice, {currencyCode:currencyCode});
			// var formattedRetailPricing = hibachiUtilityService.formatValue_currency(adjustedRetailPrice, {currencyCode:currencyCode});
			// var formattedMPPricing = hibachiUtilityService.formatValue_currency(adjustedMPPrice, {currencyCode:currencyCode});
			
			var skuAdjustedPricing = {
				adjustedPriceForAccount = adjustedAccountPrice,
				vipPrice = adjustedVipPrice,
				retailPrice = adjustedRetailPrice,
				MPPrice = adjustedMPPrice,
				personalVolume = mpPersonalVolume,
				accountPriceGroup = priceGroupCode
			};
	
			return skuAdjustedPricing;
	}

	public numeric function getProductPackVolumeTotal(string currencyCode, string accountID){
		if(!structKeyExists(variables, 'productPackVolumeTotal')){
			variables.productPackVolumeTotal = 0;
				
			if( !isNull(this.getSku()) && 
				!isNull(this.getQuantity())
			){
				variables.productPackVolumeTotal += (this.getSku().getProductPackVolumeByCurrencyCode(argumentCollection=arguments) * this.getQuantity()); 
			}
		}
		return variables.productPackVolumeTotal; 	
	}	

	public numeric function getRetailCommissionTotal(string currencyCode, string accountID){
		if(!structKeyExists(variables, 'retailComissionTotal')){
			variables.retailComissionTotal = 0; 
			
			if( !isNull(this.getSku()) && 
				!isNull(this.getQuantity())
			){
				variables.retailComissionTotal += (this.getSku().getRetailCommissionByCurrencyCode(argumentCollection=arguments) * this.getQuantity()); 
			}
		}
		return variables.retailComissionTotal; 	

	} 

	
	public numeric function getCommissionVolumeTotal(string currencyCode, string accountID){
		if(!structKeyExists(variables, 'commissionVolumeTotal')){
			variables.commissionVolumeTotal = 0; 
			
			if( !isNull(this.getSku()) && 
				!isNull(this.getQuantity())
			){
				variables.commissionVolumeTotal += (this.getSku().getCommissionableVolumeByCurrencyCode(argumentCollection=arguments) * this.getQuantity()); 
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
	
	public numeric function getListPrice(){

		if(!structKeyExists(variables, 'listPrice')){
			if(!isNull(this.getOrderTemplate().getPriceGroup() )){
				var priceGroup = [this.getOrderTemplate().getPriceGroup()];
			}else if( !isNull(this.getOrderTemplate().getAccount()) && !isNull(this.getOrderTemplate().getAccount()) && arrayLen(this.getOrderTemplate().getAccount().getPriceGroups()) ){
				var priceGroup = [this.getOrderTemplate().getAccount().getPriceGroups()[1]];
			}else{
				var priceGroup = [getService('priceGroupService').getPriceGroupByPriceGroupCode(2)] // default to retail
			}
			variables.listPrice = this.getSku().getCustomPriceByCurrencyCode(customPriceField='listPrice', currencyCode=this.getOrderTemplate().getCurrencyCode(), quantity=this.getQuantity(), priceGroups=priceGroup) ?: 0;
		}
		return variables.listPrice
	}

}
