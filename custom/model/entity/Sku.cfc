component {
	property name="sapItemCode" ormtype="string";
    property name="disableOnFlexshipFlag" ormtype="boolean";
    property name="disableOnRegularOrderFlag" ormtype="boolean";
	property name="onTheFlyKitFlag" ormtype="boolean";
	property name="vipFlag" ormtype="boolean" default="1";
	property name="mpFlag" ormtype="boolean" default="1";
	property name="retailFlag" ormtype="boolean" default="1";
	property name="backorderedMessaging" ormtype="string";
	
	// Non-persistent properties
    property name="personalVolumeByCurrencyCode" persistent="false";
	property name="commissionableVolumeByCurrencyCode" persistent="false";
	property name="AllowBackorderFlag" persistent="false";
	
	public string function getBackOrderedMessaging(){
		if(!StructKeyExists(variables, "backOrderedMessaging") || isNull(variables.backOrderedMessaging)) {
			return '';
		}
		return variables.backOrderedMessaging;
	}
	
	public boolean function canBePurchased(required any account, any order){
		
		var accountType = 'customer';
		
		if( !isNull(arguments.order) && !isNull(arguments.order.getAccountType()) ){
			accountType = arguments.order.getAccountType();
		} else if ( !isNull(arguments.account.getAccountType()) ) {
			accountType = arguments.account.getAccountType();
		}
	
		return canBePurchasedByAccountType(accountType);
	}
	
	public boolean function canBePurchasedByAccountType(required string accountType){
		switch (arguments.accountType) {
			case 'marketPartner':
				return this.getMpFlag() ?: false;
			case 'vip':
				return this.getVipFlag() ?: false;
			case 'customer':
				return this.getRetailFlag() ?: false;
			default:
				return true;
		}
	}
	
    public any function getPersonalVolumeByCurrencyCode(string currencyCode, string accountID){
    	if (!structKeyExists(arguments, "currencyCode") || isNull(arguments.currencyCode)){
    		arguments.currencyCode = this.getCurrencyCode();
    	}
    	
		arguments.customPriceField = 'personalVolume';
    	
        return this.getCustomPriceByCurrencyCode(argumentCollection=arguments);
    }
    
    public any function getTaxableAmountByCurrencyCode(string currencyCode, string accountID){
    	if (!structKeyExists(arguments, "currencyCode") || isNull(arguments.currencyCode)){
    		arguments.currencyCode = this.getCurrencyCode();
    	}
    	
    	arguments.customPriceField = 'taxableAmount';
        
		return this.getCustomPriceByCurrencyCode(argumentCollection=arguments);
    }
    
    public any function getCommissionableVolumeByCurrencyCode(string currencyCode, string accountID){
    	if (!structKeyExists(arguments, "currencyCode") || isNull(arguments.currencyCode)){
    		arguments.currencyCode = this.getCurrencyCode();
    	}
    	
    	arguments.customPriceField = 'commissionableVolume';
        
		return this.getCustomPriceByCurrencyCode(argumentCollection=arguments);
    }
    
    public any function getRetailCommissionByCurrencyCode(string currencyCode, string accountID){
    	if (!structKeyExists(arguments, "currencyCode") || isNull(arguments.currencyCode)){
    		arguments.currencyCode = this.getCurrencyCode();
    	}
    	
    	arguments.customPriceField = 'retailCommission';
        
		return this.getCustomPriceByCurrencyCode(argumentCollection=arguments);
    }
    
    public any function getProductPackVolumeByCurrencyCode(string currencyCode, string accountID){
    	if (!structKeyExists(arguments, "currencyCode") || isNull(arguments.currencyCode)){
    		arguments.currencyCode = this.getCurrencyCode();
    	}
    	
    	arguments.customPriceField = 'productPackVolume';
        
		return this.getCustomPriceByCurrencyCode(argumentCollection=arguments);
    }
    
    public any function getRetailValueVolumeByCurrencyCode(string currencyCode, string accountID){
    	if (!structKeyExists(arguments, "currencyCode") || isNull(arguments.currencyCode)){
    		arguments.currencyCode = this.getCurrencyCode();
    	}
    	
    	arguments.customPriceField = 'retailValueVolume';
        
		return this.getCustomPriceByCurrencyCode(argumentCollection=arguments);
    }

    public any function getCustomPriceByCurrencyCode( string customPriceField, string currencyCode='USD', numeric quantity=1, array priceGroups ) {
		var cacheKey = 'get#customPriceField#ByCurrencyCode#arguments.currencyCode#';
	
		var account = getHibachiScope().getAccount();
		if(structKeyExists(arguments,'accountID') && len(arguments.accountID)){
			account = getService('AccountService').getAccount(arguments.accountID);
		}	

		if(!structKeyExists(arguments,'priceGroups')){
			arguments.priceGroups = account.getPriceGroups(); 
		}
	
		for(var priceGroup in arguments.priceGroups){
			cacheKey &= '_#priceGroup.getPriceGroupID()#';
		}
		
		if(structKeyExists(arguments, "quantity")){
			cacheKey &= '#arguments.quantity#';
		}

		arguments.skuID = this.getSkuID(); 
		if(!structKeyExists(variables,cacheKey)){
			var skuPriceResults = getDAO("SkuPriceDAO").getSkuPricesForSkuCurrencyCodeAndQuantity(argumentCollection=arguments);

			if(!isNull(skuPriceResults) && isArray(skuPriceResults) && arrayLen(skuPriceResults) > 0){
				var sortFunction = function(a,b){
				   	if(isNull(a[customPriceField])){
						a[customPriceField] = 0;
					}
					
					if(isNull(b[customPriceField])){
						b[customPriceField] = 0;
					}
				   
				    if(a[customPriceField] < b[customPriceField]){ return -1;}
				    else if (a[customPriceField] > b[customPriceField]){ return 1; }
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
   
	public any function getAllowBackorderFlag(){
		return this.setting("skuAllowBackorderFlag");
	}
}
