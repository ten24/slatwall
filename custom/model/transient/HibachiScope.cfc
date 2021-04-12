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
}
