component extends="Slatwall.model.service.SiteService" accessors="true" output="false" {
    
    public any function getCountryCodeByCurrentSite() {
		var siteCodeArray = listToArray( getCurrentRequestSite().getSiteCode(), '-' );
		var siteCode = getSlatwallSiteCodeByCurrentSite();
		var countryCode = ( 'default' == siteCode ) ? 'US' : siteCode;
		
		if(countryCode == 'UK'){
			countryCode = 'GB';
		}
		
		return countryCode;
	}
	
	public any function getSlatwallSiteCodeByCurrentSite() {
		if ( !isNull( getCurrentRequestSite() ) ) {
			var siteCodeArray = listToArray( getCurrentRequestSite().getSiteCode(), '-' );
			var siteCode = ( len( siteCodeArray ) == 2 ) ? uCase( siteCodeArray[2] ) : '';
			return siteCode;
		}
	}
	
	public any function getCountryNameByCurrentSite() {
		var siteName = getCurrentRequestSite().getSiteName();
		
		// Trim out the word Monat
		var countryName = right( siteName, len( siteName ) - 6 );
		
		return countryName;
	}
}
