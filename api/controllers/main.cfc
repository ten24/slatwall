component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiControllerREST"{
    
    this.secureMethods=listAppend(this.secureMethods, 'getSkuPrices');

    
	public any function getSkuPrices(required struct rc){
		param name="arguments.rc.propertyIdentifiers" default="";
		
		if(!structKeyExists(arguments.rc, "dirtyReadFlag")){
 			arguments.rc.dirtyReadFlag = getService("SettingService").getSettingValue("globalAPIDirtyRead"); 
 		}
 		
 		arguments.rc.restRequestFlag = true;
 		
 		//should be able to add select and where filters here
        var result = getService('hibachiCollectionService').getAPIResponseForEntityName( "SkuPrice", arguments.rc);
        var defaultDisplayColumns = ListToArray(getService("SkuPriceService").getDefaultCollectionPropertiesList());

        if(structKeyExists(arguments.rc, "productID")){
            var defaultSkuPricesCollectionList = getService("SkuService").getSkuCollectionList();
            defaultSkuPricesCollectionList.addFilter("product.productID", arguments.rc.productID);
            var defaultSkuPrices = defaultSkuPricesCollectionList.getRecords(formatRecords=false);

            for(var i=1; i<=ArrayLen(defaultSkuPrices); i++){
                var currentSkuPrice = defaultSkuPrices[i];
                var pageRecord = {};
                
                for(var key in defaultDisplayColumns){
                    key = replace(key ,"sku.", "sku_");
                    if(structKeyExists(currentSkuPrice, replace(key, "sku_", ""))){
                        pageRecord[key] = currentSkuPrice[replace(key, "sku_", "")];
                    }
                }
                
                result.recordsCount++;
                
                ArrayAppend(result.pageRecords, pageRecord);
            }
        }
        
        structAppend(arguments.rc.apiResponse.content,result);
        
        if ( getService("SettingService").getSettingValue("globalLogApiRequests") ) {
            getService('HibachiUtilityService').logApiRequest(arguments.rc, "getSkuPrices");
        }
	}
}
