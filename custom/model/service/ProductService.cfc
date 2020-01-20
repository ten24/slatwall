component extends="Slatwall.model.service.ProductService" accessors="true" output="false" {
	
	/**
	 * Get Product URL by URL title
	 *
	 * @param {string} urlTitle - Product urlTitle field
	 * @return {string} Product URL
	 */
	 public string function getProductURLByUrlTitle( string urlTitle, boolean includeSiteCode = false, string optionalSiteCode = '') {
	 	
 		var productURL = '';
 		var currentSiteCode = arguments.optionalSiteCode;
 		
	 	if(arguments.includeSiteCode){
	 		currentSiteCode = getService('SiteService').getSlatwallSiteCodeByCurrentSite();
 			currentSiteCode = lCase( currentSiteCode );
			currentSiteCode = ( 'default' == currentSiteCode ) ? '' : currentSiteCode;
	 	}
	 	
		if ( len( currentSiteCode ) ) {
			productURL &= '/#currentSiteCode#';
		}
		
		productURL &= "/#getHibachiScope().setting('globalURLKeyProduct')#";
		
		if ( structKeyExists( arguments, 'urlTitle' ) ) {
			productURL &= '/#arguments.urlTitle#/';
		}
		
		return productURL;
	}

}
