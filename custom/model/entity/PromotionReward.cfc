component {
    
    property name="personalVolumeAmount" ormtype="big_decimal";
    property name="taxableAmountAmount" ormtype="big_decimal";
    property name="commissionableVolumeAmount" ormtype="big_decimal";
    property name="retailCommissionAmount" ormtype="big_decimal";
    property name="productPackVolumeAmount" ormtype="big_decimal";
    property name="retailValueVolumeAmount" ormtype="big_decimal";
    
    public numeric function getPersonalVolumeAmount(any sku, string currencyCode){
        arguments['customPriceField'] = 'personalVolume';
        return getCustomAmount(argumentCollection=arguments);
    }
    
    public numeric function getTaxableAmountAmount(any sku, string currencyCode){
        arguments['customPriceField'] = 'taxableAmount';
        return getCustomAmount(argumentCollection=arguments);
    }
    
    public numeric function getCommissionableVolumeAmount(any sku, string currencyCode){
        arguments['customPriceField'] = 'commissionableVolume';
        return getCustomAmount(argumentCollection=arguments);
    }
    
    public numeric function getRetailCommissionAmount(any sku, string currencyCode){
        arguments['customPriceField'] = 'retailCommission';
        return getCustomAmount(argumentCollection=arguments);
    }
    
    public numeric function getProductPackVolumeAmount(any sku, string currencyCode){
        arguments['customPriceField'] = 'productPackVolume';
        return getCustomAmount(argumentCollection=arguments);
    }
    
    public numeric function getRetailValueVolumeAmount(any sku, string currencyCode){
        arguments['customPriceField'] = 'retailValueVolume';
        return getCustomAmount(argumentCollection=arguments);
    }
    
    public numeric function getPersonalVolumeAmountByCurrencyCode(required string currencyCode, any sku){
        arguments['customPriceField'] = 'personalVolume';
        return getCustomAmountByCurrencyCode(argumentCollection=arguments);
    }
    
    public numeric function getTaxableAmountAmountByCurrencyCode(required string currencyCode, any sku){
        arguments['customPriceField'] = 'taxableAmount';
        return getCustomAmountByCurrencyCode(argumentCollection=arguments);
    }
    
    public numeric function getCommissionableVolumeAmountByCurrencyCode(required string currencyCode, any sku){
        arguments['customPriceField'] = 'commissionableVolume';
        return getCustomAmountByCurrencyCode(argumentCollection=arguments);
    }
    
    public numeric function getRetailCommissionAmountByCurrencyCode(required string currencyCode, any sku){
        arguments['customPriceField'] = 'retailCommission';
        return getCustomAmountByCurrencyCode(argumentCollection=arguments);
    }
    
    public numeric function getProductPackVolumeAmountByCurrencyCode(required string currencyCode, any sku){
        arguments['customPriceField'] = 'productPackVolume';
        return getCustomAmountByCurrencyCode(argumentCollection=arguments);
    }
    
    public numeric function getRetailValueVolumeAmountByCurrencyCode(required string currencyCode, any sku){
        arguments['customPriceField'] = 'retailValueVolume';
        return getCustomAmountByCurrencyCode(argumentCollection=arguments);
    }
    
    public numeric function getCustomAmountByCurrencyCode(required string customPriceField, required string currencyCode, any sku){
		var amountParams = {
		    'customPriceField':arguments.customPriceField
		};
		if(structKeyExists(arguments,'sku')){
			amountParams['sku'] = arguments.sku;
		}
		if(arguments.currencyCode neq getCurrencyCode() and getAmountType() eq 'amountOff'){
			//Check for defined conversion rate 
			var currencyRate = getService("currencyService").getCurrencyDAO().getCurrentCurrencyRateByCurrencyCodes(originalCurrencyCode=getCurrencyCode(), convertToCurrencyCode=arguments.currencyCode, conversionDateTime=now());
			if(!isNull(currencyRate)) {
				return getService('HibachiUtilityService').precisionCalculate(currencyRate.getConversionRate()*invokeMethod('get#customPriceField#Amount'));
			}
		
		}else if(arguments.currencyCode != getCurrencyCode()){
			amountParams['currencyCode'] = arguments.currencyCode;
		}
		//Either no conversion was needed, or we couldn't find a conversion rate.
		return getCustomAmount(argumentCollection=amountParams);
	}
	
	public numeric function getCustomAmount(required string customPriceField, any sku, string currencyCode){

		//Get price from sku prices table for fixed amount rewards
		if(getAmountType() == 'amount' && structKeyExists(arguments,'sku')){
			if(structKeyExists(arguments,'currencyCode')){
				var currencyCode = arguments.currencyCode;
			}else{
				var currencyCode = getCurrencyCode();
			}
			var skuPrice = getSkuPriceBySkuAndCurrencyCode(arguments.sku,currencyCode);
			if(!isNull(skuPrice)){
				return skuPrice.invokeMethod('get#customPriceField#');
			}
		}else{
    		if(!structKeyExists(variables,'#customPriceField#Amount')){
    			variables['#customPriceField#Amount'] = getAmount(argumentCollection=arguments);
    		}
    		return variables['#customPriceField#Amount'];
		}
	}
    
}

