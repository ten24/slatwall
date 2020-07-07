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
	property name="commissionableVolumeByCurrencyCode" persistent="false";

	public boolean function canBePurchased(required any account, any order){
		if( !isNull(arguments.order) && !isNull(arguments.order.getAccountType()) ){
			var accountType = arguments.order.getAccountType();
		} else if ( !isNull(arguments.account.getAccountType()) ) {
			var accountType = arguments.account.getAccountType();
		}
		
		if( isNull(accountType) ){
			return this.getRetailFlag() == true;
		}else{
		
			var notValidVipItem = ( accountType == "vip" && this.getVipFlag() != true );
			var notValidMpItem = ( accountType == "marketPartner" && this.getMpFlag() != true );
			var notValidRetailItem = ( accountType == "customer" && this.getRetailFlag() != true );
			
			if( notValidRetailItem || notValidVipItem || notValidMpItem ){
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
    
    public any function getSkuPricesForSkuCurrencyCodeAndQuantity(required string skuID, required string currencyCode, required numeric quantity, array priceGroups=[], string priceGroupIDList){
    	if(!structKeyExists(variables, 'skuPricesForSkuCurrencyCodeAndQuantity')){
    		variables.skuPricesForSkuCurrencyCodeAndQuantity = getDAO("SkuPriceDAO").getSkuPricesForSkuCurrencyCodeAndQuantity(argumentCollection=arguments);
    	}else{
    		return variables.skuPricesForSkuCurrencyCodeAndQuantity;
    	}
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
			var skuPriceResults = getSkuPricesForSkuCurrencyCodeAndQuantity(argumentCollection=arguments);

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
   
}
