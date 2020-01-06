component {
	
	/**
	 * Get Product URL based on current site.
	 *
	 * @return {string} Product URL
	 */
	public string function getProductURL() {
		
		var productURL = '';
		if ( 
			structKeyExists( request, 'context' ) 
			&& structKeyExists( request.context, 'cmsSiteID' ) 
			&& request.context.cmsSiteID != 'default'
		) {
			productUrl &= '/' & request.context.cmsSiteID;
		}
		
		productURL &= getService('ProductService').getProductUrlByUrlTitle( getUrlTitle() );
		
		return productURL;
	}
	
} 
