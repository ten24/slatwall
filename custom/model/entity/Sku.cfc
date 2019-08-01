component {
    property name="disableOnFlexshipFlag" ormtype="boolean";
    property name="disableOnRegularOrderFlag" ormtype="boolean";
    property name="onTheFlyKitFlag" ormtype="boolean";
    
    public any function getPersonalVolumeByCurrencyCode(required string currencyCode){
        return this.getCustomPriceByCurrencyCode('personalVolume',this.getCurrencyCode());
    }
    
    public any function getTaxableAmountByCurrencyCode(required string currencyCode){
        return this.getCustomPriceByCurrencyCode('taxableAmount',this.getCurrencyCode());
    }
    
    public any function getCommissionableVolumeByCurrencyCode(required string currencyCode){
        return this.getCustomPriceByCurrencyCode('commissionableVolume',this.getCurrencyCode());
    }
    
    public any function getRetailCommissionByCurrencyCode(required string currencyCode){
        return this.getCustomPriceByCurrencyCode('retailCommission',this.getCurrencyCode());
    }
    
    public any function getProductPackVolumeByCurrencyCode(required string currencyCode){
        return this.getCustomPriceByCurrencyCode('productPackVolume',this.getCurrencyCode());
    }
    
    public any function getRetailValueVolumeByCurrencyCode(required string currencyCode){
        return this.getCustomPriceByCurrencyCode('retailValueVolume',this.getCurrencyCode());
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
				
				var sortFunction = function(a,b){
				    if(a['price'] < b['price']){ return -1;}
				    else if (a['price'] > b['price']){ return 1; }
				    else{ return 0; }
					
				};
				ArraySort(skuPriceResults, 
				sortFunction
				);
				variables[cacheKey]= skuPriceResults[1];
			} 
			
			if(structKeyExists(variables,cacheKey) && structKeyExists(variables[cacheKey],customPriceField)){
				return variables[cacheKey][customPriceField];
			}
			
			var baseSkuPrice = getDAO("SkuPriceDAO").getBaseSkuPriceForSkuByCurrencyCode(this.getSkuID(), arguments.currencyCode);  
			if(!isNull(baseSkuPrice)){
				variables[cacheKey] = baseSkuPrice.invokeMethod('get#customPriceField#'); 
			}
			
		}
        
		if(structKeyExists(variables,cacheKey)){
		    if(isStruct(variables[cacheKey]) && structKeyExists(variables[cacheKey],customPriceField)){
		        return variables[cacheKey][customPriceField];
		    }
			return variables[cacheKey];
		}
    }
    
}
