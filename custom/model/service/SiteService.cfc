component extends="Slatwall.model.service.SiteService" accessors="true" output="false" {
    
    public any function getCountryCodeByCurrentSite() {
    	if(!isNull(getCurrentRequestSite())){
			return getCountryCodeBySite(getCurrentRequestSite());
    	}
    	return '';
	}
	
	public string function getSlatwallSiteCodeByCurrentSite() {
		return getSlatwallSiteCodeBySite(getCurrentRequestSite());
	}
	
	
	public string function getSlatwallSiteCodeBySite(required any site){
		if ( !isNull( arguments.site ) ) {
			var siteCodeArray = listToArray( arguments.site.getSiteCode(), '-' );
			var siteCode = ( arrayLen( siteCodeArray ) == 2 ) ? uCase( siteCodeArray[2] ) : '';
			return siteCode;
		}
		return '';
	}
	
	public string function getCountryCodeBySite(required any site){

		var siteCode = getSlatwallSiteCodeBySite(arguments.site);
		var countryCode = ( 'default' == siteCode ) ? 'US' : siteCode;
		
		if(countryCode == 'UK'){
			countryCode = 'GB';
		}
		
		return countryCode;
	}
	
	public any function getCountryNameByCurrentSite() {
		var siteName = getCurrentRequestSite().getSiteName();
		
		// Trim out the word Monat
		var countryName = right( siteName, len( siteName ) - 6 );
		
		return countryName;
	}
}
