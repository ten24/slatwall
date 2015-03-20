component {
	
	function deployApplication() {
		// copy skeletonapp to /apps/{applicationCodeOrID} 
	}
	
	function createSite() {
		// copy skeletonsite to /apps/{applicationCodeOrID}/{siteCodeOrID}/
		
		// create 6 content nodes for this site, and map to the appropriate templates
			// home (urlTitle == '') -> /custom/apps/slatwallcms/site1/templates/home.cfm
				// product listing -> /custom/apps/slatwallcms/site1/templates/product-listing.cfm
				// shopping cart -> /custom/apps/slatwallcms/site1/templates/shopping-cart.cfm
				// my account -> /custom/apps/slatwallcms/site1/templates/my-account.cfm
				// checkout
				// order confirmation
				// templates
					// default product template
					// default product type template
					// default brand template
			
		// Update the site specific settings for product/brand/productType display template to be the corrisponding content nodes
	}
}