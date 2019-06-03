component {
    property name="disableOnFlexshipFlag" ormtype="boolean";
    property name="disableOnRegularOrderFlag" ormtype="boolean";
    property name="onTheFlyKitFlag" ormtype="boolean";
    property name="personalVolume" ormtype="big_decimal";
    property name="taxableAmount" ormtype="big_decimal";
    property name="commissionableVolume" ormtype="big_decimal";
    property name="sponsorVolume" ormtype="big_decimal";
    property name="productPackVolume" ormtype="big_decimal";
    property name="retailValueVolume" ormtype="big_decimal";
    
    public any function getPersonalVolumeByCurrencyCode(required string currencyCode){
        if(!structKeyExists(variables,'personalVolume')){
            variables.personalVolume = this.getCustomPriceByCurrencyCode('personalVolume',this.getCurrencyCode());
        }
        return variables.personalVolume;
    }
    
    public any function getTaxableAmountByCurrencyCode(required string currencyCode){
        if(!structKeyExists(variables,'taxableAmount')){
            variables.taxableAmount = this.getCustomPriceByCurrencyCode('taxableAmount',this.getCurrencyCode());
        }
        return variables.taxableAmount;
    }
    
    public any function getCommissionableVolumeByCurrencyCode(required string currencyCode){
        if(!structKeyExists(variables,'commissionableVolume')){
            variables.commissionableVolume = this.getCustomPriceByCurrencyCode('commissionableVolume',this.getCurrencyCode());
        }
        return variables.commissionableVolume;
    }
    
    public any function getSponsorVolumeByCurrencyCode(required string currencyCode){
        if(!structKeyExists(variables,'sponsorVolume')){
            variables.sponsorVolume = this.getCustomPriceByCurrencyCode('sponsorVolume',this.getCurrencyCode());
        }
        return variables.sponsorVolume;
    }
    
    public any function getProductPackVolumeByCurrencyCode(required string currencyCode){
        if(!structKeyExists(variables,'productPackVolume')){
            variables.productPackVolume = this.getCustomPriceByCurrencyCode('productPackVolume',this.getCurrencyCode());
        }
        return variables.productPackVolume;
    }
    
    public any function getRetailValueVolumeByCurrencyCode(required string currencyCode){
        if(!structKeyExists(variables,'retailValueVolume')){
            variables.retailValueVolume = this.getCustomPriceByCurrencyCode('retailValueVolume',this.getCurrencyCode());
        }
        return variables.retailValueVolume;
    }

    public any function getCustomPriceByCurrencyCode( string customPriceField, string currencyCode='USD', numeric quantity=1, array priceGroups=getHibachiScope().getAccount().getPriceGroups() ) {
		var cacheKey = 'get#customPriceField#ByCurrencyCode#arguments.currencyCode#';
		
		for(var priceGroup in arguments.priceGroups){
			cacheKey &= '_#priceGroup.getPriceGroupID()#';
		}
		
		if(structKeyExists(arguments, "quantity")){
			cacheKey &= '#arguments.quantity#';
		}
		
		if(!structKeyExists(variables,cacheKey)){
			var skuPriceResults = getDAO("SkuPriceDAO").getSkuPricesForSkuCurrencyCodeAndQuantity(this.getSkuID(), arguments.currencyCode, arguments.quantity,arguments.priceGroups);
			if(!isNull(skuPriceResults) && isArray(skuPriceResults) && arrayLen(skuPriceResults) > 0){
				var prices = [];
				for(var i=1; i <= arrayLen(skuPriceResults); i++){
					ArrayAppend(prices, skuPriceResults[i][customPriceField]);
				}
				ArraySort(prices, "numeric","asc");
				variables[cacheKey]= prices[1];
			} 
			
			if(structKeyExists(variables,cacheKey)){
				return variables[cacheKey];
			}
			
			var baseSkuPrice = getDAO("SkuPriceDAO").getBaseSkuPriceForSkuByCurrencyCode(this.getSkuID(), arguments.currencyCode);  
			if(!isNull(baseSkuPrice)){
				variables[cacheKey] = baseSkuPrice.invokeMethod('get#customPriceField#'); 
			}
			
		}
		
		if(structKeyExists(variables,cacheKey)){
			return variables[cacheKey];
		}
    }
    
}