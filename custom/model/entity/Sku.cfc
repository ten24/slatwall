component {
    property name="disableOnFlexshipFlag" ormtype="boolean";
    property name="disableOnRegularOrderFlag" ormtype="boolean";
    property name="onTheFlyKitFlag" ormtype="boolean";
    property name="personalVolume" ormtype="big_decimal";
    property name="taxableAmount" ormtype="big_decimal";
    property name="commissionableVolume" ormtype="big_decimal";
    property name="retailCommission" ormtype="big_decimal";
    property name="productPackVolume" ormtype="big_decimal";
    property name="retailValueVolume" ormtype="big_decimal";
    
    
    public any function getPersonalVolumeByCurrencyCode(string currencyCode, string accountID){
    	if (!structKeyExists(arguments, "currencyCode") || isNull(arguments.currencyCode)){
    		arguments.currencyCode = this.getCurrencyCode();
    	}
    	
    	if (structKeyExists(arguments, "accountID") && !isNull(arguments.accountID) && len(arguments.accountID)){
    		var account = getService("AccountService").getAccountByAccountID(arguments.accountID);
    		if (!isNull(account)){
    			arguments.priceGroups = account.getPriceGroups();
    		}
    	}
    	arguments.customPriceField = 'personalVolume';
    	
        return this.getCustomPriceByCurrencyCode(argumentCollection=arguments);
    }
    
    public any function getTaxableAmountByCurrencyCode(string currencyCode, string accountID){
    	if (!structKeyExists(arguments, "currencyCode") || isNull(arguments.currencyCode)){
    		arguments.currencyCode = this.getCurrencyCode();
    	}
    	
    	if (structKeyExists(arguments, "accountID") && !isNull(arguments.accountID) && len(arguments.accountID)){
    		var account = getService("AccountService").getAccountByAccountID(arguments.accountID);
    		if (!isNull(account)){
    			arguments.priceGroups = account.getPriceGroups();
    		}
    	}
    	arguments.customPriceField = 'taxableAmount';
        return this.getCustomPriceByCurrencyCode(argumentCollection=arguments);
    }
    
    public any function getCommissionableVolumeByCurrencyCode(string currencyCode, string accountID){
    	if (!structKeyExists(arguments, "currencyCode") || isNull(arguments.currencyCode)){
    		arguments.currencyCode = this.getCurrencyCode();
    	}
    	
    	if (structKeyExists(arguments, "accountID") && !isNull(arguments.accountID) && len(arguments.accountID)){
    		var account = getService("AccountService").getAccountByAccountID(arguments.accountID);
    		if (!isNull(account)){
    			arguments.priceGroups = account.getPriceGroups();
    		}
    	}
    	arguments.customPriceField = 'commissionableVolume';
        return this.getCustomPriceByCurrencyCode(argumentCollection=arguments);
    }
    
    public any function getRetailCommissionByCurrencyCode(string currencyCode, string accountID){
    	if (!structKeyExists(arguments, "currencyCode") || isNull(arguments.currencyCode)){
    		arguments.currencyCode = this.getCurrencyCode();
    	}
    	
    	if (structKeyExists(arguments, "accountID") && !isNull(arguments.accountID) && len(arguments.accountID)){
    		var account = getService("AccountService").getAccountByAccountID(arguments.accountID);
    		if (!isNull(account)){
    			arguments.priceGroups = account.getPriceGroups();
    		}
    	}
    	arguments.customPriceField = 'retailCommission';
        return this.getCustomPriceByCurrencyCode(argumentCollection=arguments);
    }
    
    public any function getProductPackVolumeByCurrencyCode(string currencyCode, string accountID){
    	if (!structKeyExists(arguments, "currencyCode") || isNull(arguments.currencyCode)){
    		arguments.currencyCode = this.getCurrencyCode();
    	}
    	
    	if (structKeyExists(arguments, "accountID") && !isNull(arguments.accountID) && len(arguments.accountID)){
    		var account = getService("AccountService").getAccountByAccountID(arguments.accountID);
    		if (!isNull(account)){
    			arguments.priceGroups = account.getPriceGroups();
    		}
    	}
    	arguments.customPriceField = 'productPackVolume';
        return this.getCustomPriceByCurrencyCode(argumentCollection=arguments);
    }
    
    public any function getRetailValueVolumeByCurrencyCode(string currencyCode, string accountID){
    	if (!structKeyExists(arguments, "currencyCode") || isNull(arguments.currencyCode)){
    		arguments.currencyCode = this.getCurrencyCode();
    	}
    	
    	if (structKeyExists(arguments, "accountID") && !isNull(arguments.accountID) && len(arguments.accountID)){
    		var account = getService("AccountService").getAccountByAccountID(arguments.accountID);
    		if (!isNull(account)){
    			arguments.priceGroups = account.getPriceGroups();
    		}
    	}
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
