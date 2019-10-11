component {
    property name="disableOnFlexshipFlag" ormtype="boolean";
    property name="disableOnRegularOrderFlag" ormtype="boolean";
    property name="onTheFlyKitFlag" ormtype="boolean";
    property name="personalVolumeByCurrencyCode" persistent="false";
    property name="comissionablelVolumeByCurrencyCode" persistent="false";
	property name="skuProductURL" persistent="false";
	property name="skuImagePath" persistent="false";
	property name="skuAdjustedPricing" persistent="false";

	private string function getPriceGroupIDListForAccountID(string accountID){
    	if (!structKeyExists(arguments, "accountID") || isNull(arguments.accountID) || !len(arguments.accountID)){
			return '';
		}
		
		var priceGroupCollection = getService('PriceGroupService').getPriceGroupCollectionList();
		priceGroupCollection.addFilter('accounts.accountID', arguments.accountID);
		return priceGroupCollection.getPrimaryIDList();  
	}
    
    public any function getPersonalVolumeByCurrencyCode(string currencyCode, string accountID){
    	if (!structKeyExists(arguments, "currencyCode") || isNull(arguments.currencyCode)){
    		arguments.currencyCode = this.getCurrencyCode();
    	}
    	
		arguments.priceGroupIDList = getPriceGroupIDListForAccountID(arguments.accountID); 
		arguments.customPriceField = 'personalVolume';
    	
        return this.getCustomPriceByCurrencyCode(argumentCollection=arguments);
    }
    
    public any function getTaxableAmountByCurrencyCode(string currencyCode, string accountID){
    	if (!structKeyExists(arguments, "currencyCode") || isNull(arguments.currencyCode)){
    		arguments.currencyCode = this.getCurrencyCode();
    	}
    	
		arguments.priceGroupIDList = getPriceGroupIDListForAccountID(arguments.accountID); 
    	arguments.customPriceField = 'taxableAmount';
        
		return this.getCustomPriceByCurrencyCode(argumentCollection=arguments);
    }
    
    public any function getCommissionableVolumeByCurrencyCode(string currencyCode, string accountID){
    	if (!structKeyExists(arguments, "currencyCode") || isNull(arguments.currencyCode)){
    		arguments.currencyCode = this.getCurrencyCode();
    	}
    	
		arguments.priceGroupIDList = getPriceGroupIDListForAccountID(arguments.accountID); 
    	arguments.customPriceField = 'commissionableVolume';
        
		return this.getCustomPriceByCurrencyCode(argumentCollection=arguments);
    }
    
    public any function getRetailCommissionByCurrencyCode(string currencyCode, string accountID){
    	if (!structKeyExists(arguments, "currencyCode") || isNull(arguments.currencyCode)){
    		arguments.currencyCode = this.getCurrencyCode();
    	}
    	
		arguments.priceGroupIDList = getPriceGroupIDListForAccountID(arguments.accountID); 
    	arguments.customPriceField = 'retailCommission';
        
		return this.getCustomPriceByCurrencyCode(argumentCollection=arguments);
    }
    
    public any function getProductPackVolumeByCurrencyCode(string currencyCode, string accountID){
    	if (!structKeyExists(arguments, "currencyCode") || isNull(arguments.currencyCode)){
    		arguments.currencyCode = this.getCurrencyCode();
    	}
    	
		arguments.priceGroupIDList = getPriceGroupIDListForAccountID(arguments.accountID); 
    	arguments.customPriceField = 'productPackVolume';
        
		return this.getCustomPriceByCurrencyCode(argumentCollection=arguments);
    }
    
    public any function getRetailValueVolumeByCurrencyCode(string currencyCode, string accountID){
    	if (!structKeyExists(arguments, "currencyCode") || isNull(arguments.currencyCode)){
    		arguments.currencyCode = this.getCurrencyCode();
    	}
    	
		arguments.priceGroupIDList = getPriceGroupIDListForAccountID(arguments.accountID); 
    	arguments.customPriceField = 'retailValueVolume';
        
		return this.getCustomPriceByCurrencyCode(argumentCollection=arguments);
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
			var skuPriceResults = getDAO("SkuPriceDAO").getSkuPricesForSkuCurrencyCodeAndQuantity(this.getSkuID(), arguments.currencyCode, arguments.quantity, arguments.priceGroups);
			if(!isNull(skuPriceResults) && isArray(skuPriceResults) && arrayLen(skuPriceResults) > 0){
				var sortFunction = function(a,b){
				   	if(isNull(a['price'])){
						a['price'] = 0;
					}
					
					if(isNull(b['price'])){
						b['price'] = 0;
					}
				   
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
        
		if(structKeyExists(variables, cacheKey)){
		    if(isStruct(variables[cacheKey]) && structKeyExists(variables[cacheKey],customPriceField)){
		        return variables[cacheKey][customPriceField];
		    } else if (!isStruct(variables[cacheKey])){
				return variables[cacheKey];
			} 	 
		}    
	}
    
	public any function getSkuProductURL(){
		var skuProductURL = this.getProduct().getProductURL();
		return skuProductURL;
	}
	
	public any function getSkuImagePath(){
		var skuImagePath = this.getImagePath();
		return skuImagePath;
	}
	
	public any function getSkuAdjustedPricing(){
			
		var pricegroups = getHibachiScope().getAccount().getPriceGroups();
		var priceGroupCode = arrayLen(pricegroups) ? pricegroups[1].getPriceGroupCode() : "";
		var priceGroupService = getHibachiScope().getService('PriceGroupService');
		var utilityService = getHibachiScope().getService('hibachiUtilityService');
		
		/*** TODO: FIGURE OUT HOW TO GET SITE SETTING FOR THIS AND WISHLIST AS WELL ***/
		var currencyCode = 'usd';//getHibachiScope().getCurrentRequestSite().setting('skuCurrency');
		var vipPriceGroup = priceGroupService.getPriceGroupByPriceGroupCode(3);
		var retailPriceGroup = priceGroupService.getPriceGroupByPriceGroupCode(2);
		var MPPriceGroup = priceGroupService.getPriceGroupByPriceGroupCode(1);

		var adjustedAccountPrice = this.getPriceByCurrencyCode(currencyCode);
		var adjustedVipPrice = this.getPriceByCurrencyCode(currencyCode,1,[vipPriceGroup]);
		var adjustedRetailPrice = this.getPriceByCurrencyCode(currencyCode,1,[retailPriceGroup]);
		var adjustedMPPrice = this.getPriceByCurrencyCode(currencyCode,1,[MPPriceGroup]);
		var mPPersonalVolume = this.getPersonalVolume()?:0;
		
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
