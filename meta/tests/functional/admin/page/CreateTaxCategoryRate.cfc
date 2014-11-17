component extends="PageObject" {
	
	//variables.slatAction = "entity.createtaxcategoryrate";
	variables.title = "Create Tax Category Rate | Slatwall";
	
	public any function submitCreateForm( struct formData={} ) {
		submitForm( 'adminentitysavetaxcategoryrate', arguments.formData );
		
		var pageLoadTime = waitForPageToLoad();
		
		return new DetailTaxCategoryRate(selenium, pageLoadTime);
	}
}