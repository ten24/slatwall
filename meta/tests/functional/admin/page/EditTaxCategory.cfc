component extends="PageObject" {
	
	variables.title = "Create Tax Category | Slatwall";
	
	public any function submitEditForm( struct formData={} ) {
		submitForm( 'adminentitysavetaxcategory', arguments.formData );
		
		var pageLoadTime = waitForPageToLoad();
		
		return new DetailTaxCategory(selenium, pageLoadTime);
	}
}

