component extends="PageObject" {
	
	variables.slatAction = "entity.createtaxcategory";
	variables.title = "Create Tax Category | Slatwall";
	
	public any function submitCreateForm( struct formData={} ) {
		submitForm( 'adminentitysavetaxcategory', arguments.formData );
		
		var pageLoadTime = waitForPageToLoad();
		
		return new DetailTaxCategory(selenium, pageLoadTime);
	}
}