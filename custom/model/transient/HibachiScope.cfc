component output="false" accessors="true" extends="Slatwall.model.transient.HibachiScope" {
	public struct function getHibachiConfig(){
		
		var currentRequestSite = getCurrentRequestSite();
		
		var hibachiConfig = {
			'action' : 'slatAction'
			,'basePartialsPath' : '/Slatwall/org/Hibachi/client/src/'
			,'baseURL' : '/Slatwall/'
			,'rbLocale' : getRBLocale()
			,'siteCode' : currentRequestSite.getSiteCode()
			,'currencyCode' : currentRequestSite.getCurrencyCode()
// 			,'countryCode' : getService('SiteService').getCountryCodeBySite(currentRequestSite) ?: 'US'
			,'instantiationKey' : getApplicationValue("instantiationKey")
			,'attributeCacheKey' : getService("hibachiService").getAttributeCacheKey()
			,'missingImagePath' : currentRequestSite.setting('siteMissingImagePath')
			,'currencies' : getService("currencyService").getAllActiveCurrencies(detailFlag=true)
		};
		
		
		return hibachiConfig;
	}

	// override default cart properties to get product series
	public any function getAvailableCartPropertyList(string cartDataOptions="full") {
		
		
		var availablePropertyList = super.getAvailableCartPropertyList(argumentCollection = arguments)
	
		if(arguments.cartDataOptions=='full' || listFind(arguments.cartDataOptions,'orderItem')){
			availablePropertyList&=",orderItems.sku.product.productSeries";
		}
		
		availablePropertyList = rereplace(availablePropertyList,"[[:space:]]","","all");
		
		if(right(trim(availablePropertyList),1)==','){
			availablePropertyList = left(availablePropertyList,len(trim(availablePropertyList))-1);
		}
	
		return availablePropertyList;
	}
}
