component extends="Slatwall.model.service.ProductService" accessors="true" output="false" {
	
	/**
	 * Get Product URL by URL title
	 *
	 * @param {string} urlTitle - Product urlTitle field
	 * @return {string} Product URL
	 */
	 public string function getProductURLByUrlTitle( string urlTitle ) {
	 	var currentSiteCode = getService('SiteService').getSlatwallSiteCodeByCurrentSite();
		
		currentSiteCode = lCase( currentSiteCode );
		currentSiteCode = ( 'default' == currentSiteCode ) ? '' : currentSiteCode;
		
		var productURL = '';
		if ( len( currentSiteCode ) ) {
			productURL &= '/#currentSiteCode#';
		}
		
		productURL &= "/#getHibachiScope().setting('globalURLKeyProduct')#";
		
		if ( structKeyExists( arguments,'urlTitle' ) ) {
			productURL &= '/#arguments.urlTitle#/';
		}
		
		return productURL;
	}

}
