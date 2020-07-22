component {
    
    property name="personalVolumeAmount" ormtype="big_decimal" hb_formatType="custom";
    property name="taxableAmountAmount" ormtype="big_decimal" hb_formatType="custom";
    property name="commissionableVolumeAmount" ormtype="big_decimal" hb_formatType="custom";
    property name="retailCommissionAmount" ormtype="big_decimal" hb_formatType="custom";
    property name="productPackVolumeAmount" ormtype="big_decimal" hb_formatType="custom";
    property name="retailValueVolumeAmount" ormtype="big_decimal" hb_formatType="custom";
    property name="showRewardSkuInCartFlag" ormtype="boolean" default=1 hb_formatType="yesno";
        
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
    
    public string function getPersonalVolumeAmountFormatted(){
        arguments['customPriceField'] = 'personalVolume';
        return getCustomAmountFormatted(argumentCollection=arguments);
    }
    
    public string function getTaxableAmountAmountFormatted(){
        arguments['customPriceField'] = 'taxableAmount';
        return getCustomAmountFormatted(argumentCollection=arguments);
    }
    
    public string function getCommissionableVolumeAmountFormatted(){
        arguments['customPriceField'] = 'commissionableVolume';
        return getCustomAmountFormatted(argumentCollection=arguments);
    }
    
    public string function getRetailCommissionAmountFormatted(){
        arguments['customPriceField'] = 'retailCommission';
        return getCustomAmountFormatted(argumentCollection=arguments);
    }
    
    public string function getProductPackVolumeAmountFormatted(){
        arguments['customPriceField'] = 'productPackVolume';
        return getCustomAmountFormatted(argumentCollection=arguments);
    }
    
    public string function getRetailValueVolumeAmountFormatted(){
        arguments['customPriceField'] = 'retailValueVolume';
        return getCustomAmountFormatted(argumentCollection=arguments);
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
    
    public numeric function getCustomAmountByCurrencyCode(required string customPriceField, required string currencyCode, any sku, numeric quantity, any account){
		var amountParams = {
		    'customPriceField':arguments.customPriceField
		};
		if(structKeyExists(arguments,'sku')){
			amountParams['sku'] = arguments.sku;
		}
		if(structKeyExists(arguments,'account')){
			amountParams['account'] = arguments.account;
		}
		if(arguments.currencyCode != getCurrencyCode() and getAmountType() == 'amountOff'){
		    //Check for explicity defined promotion reward currencies
			for(var i=1;i<=arraylen(variables.promotionRewardCurrencies);i++){
				if(variables.promotionRewardCurrencies[i].getCurrencyCode() == arguments.currencyCode){
					return variables.promotionRewardCurrencies[i].invokeMethod('get#customPriceField#Amount');
				}
			}
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
	
	public numeric function getCustomAmount(required string customPriceField, any sku, string currencyCode, numeric quantity, any account){

		//Get price from sku prices table for fixed amount rewards
		if(getAmountType() == 'amount' && structKeyExists(arguments,'sku')){
			if(!structKeyExists(arguments,'currencyCode')){
				arguments.currencyCode = getCurrencyCode();
			}
			var skuPrice = getSkuPriceBySkuAndCurrencyCode(argumentCollection=arguments);
			if(!isNull(skuPrice)){
				return skuPrice.invokeMethod('get#customPriceField#');
			}
		}
		
		if(!structKeyExists(variables,'#customPriceField#Amount')){
			variables['#customPriceField#Amount'] = getAmount(argumentCollection=arguments);
		}
		return variables['#customPriceField#Amount'];
	}
	
    public string function getCustomAmountFormatted( required string customPriceField ) {
		if(getAmountType() == "percentageOff") {
			return formatValue(this.invokeMethod('get#customPriceField#Amount'), "percentage");
		}
		
		return formatValue(this.invokeMethod('get#customPriceField#Amount'), "currency");
	}
	
	public any function getSkuCollection(){
		return getIncludedSkusCollection();
	}
    
}

