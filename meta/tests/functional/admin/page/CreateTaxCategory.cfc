component extends="PageObject" {
	
	variables.slatAction = "entity.createtaxcategory";
	variables.title = "Create Tax Category | Slatwall";
	
	public any function submitCreateForm( struct formData={} ) {
		submitForm( 'adminentitysavetaxcategory', arguments.formData );
		
		var pageLoadTime = waitForPageToLoad();
		if(pageLoadTime > 0){
			return new DetailTaxCategory(selenium, pageLoadTime);
		} else {
			return new CreateTaxCategory(selenium, pageLoadTime);
		}
		
	}
}