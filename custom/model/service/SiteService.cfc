component extends="Slatwall.model.service.SiteService" accessors="true" output="false" {
    
    public any function getCountryCodeByCurrentSite() {
		var siteCodeArray = listToArray( getCurrentRequestSite().getSiteCode(), '-' );
		var siteCode = ( len( siteCodeArray ) == 2 ) ? uCase( siteCodeArray[2] ) : '';
		siteCode = ( 'default' == siteCode ) ? 'US' : siteCode;
		
		return siteCode;
	}
	
	public any function getCountryNameByCurrentSite() {
		var siteName = getCurrentRequestSite().getSiteName();
		
		// Trim out the word Monat
		var countryName = right( siteName, len( siteName ) - 6 );
		
		return countryName;
	}
}
