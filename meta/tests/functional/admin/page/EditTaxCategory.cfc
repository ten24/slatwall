component extends="PageObject" {
	
	variables.title = "Create Tax Category | Slatwall";
	
	public any function submitSaveForm( struct formData={} ) {
		submitForm( 'adminentitysavetaxcategory', arguments.formData );
		
		var pageLoadTime = waitForPageToLoad();
		
		return new DetailTaxCategory(selenium, pageLoadTime);
	}
}

