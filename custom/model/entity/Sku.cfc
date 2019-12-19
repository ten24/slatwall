component {
	property name="sapItemCode" ormtype="string";
    property name="disableOnFlexshipFlag" ormtype="boolean";
    property name="disableOnRegularOrderFlag" ormtype="boolean";
	property name="onTheFlyKitFlag" ormtype="boolean";
	property name="vipFlag" ormtype="boolean" default="1";
	property name="mpFlag" ormtype="boolean" default="1";
	property name="retailFlag" ormtype="boolean" default="1";
	
	// Non-persistent properties
    property name="personalVolumeByCurrencyCode" persistent="false";
	property name="comissionablelVolumeByCurrencyCode" persistent="false";

	public boolean function canBePurchased(required any account){
		
		writeDump( arguments.account.getAccountType() );
		abort;
		
		if ( !isNull( arguments.account.getAccountType() ) ) {
			
			var notValidVipItem = arguments.account.getAccountType() == "vip" && this.getVipFlag() != true;
			if(notValidVipItem){
				return false;
			}
			var notValidMpItem = arguments.account.getAccountType() == "marketPartner" && this.getMpFlag() != true;
			if(notValidMpItem){
				return false;
			}
			var notValidRetailItem = arguments.account.getAccountType() == "retail" && this.getRetailFlag() != true;
			if(notValidRetailItem){
				return false;
			}
			
		} else {
			
			// If failed to get account type (not logged in usually), and isn't a retail Sku
			if ( this.getRetailFlag() != true ) {
				return false;
			}
		}

        return true; 
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
   
}
