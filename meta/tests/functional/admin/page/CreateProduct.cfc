component extends="PageObject" {
	
	variables.slatAction = "entity.createproduct";
	variables.title = "Create Product | Slatwall";
	
	public any function submitCreateForm( struct formData={} ) {
		submitForm( 'adminentitysaveproduct', arguments.formData );
		
		var pageLoadTime = waitForPageToLoad();
		if(pageLoadTime > 0){
			return new DetailProduct(selenium, pageLoadTime);
		} else {
			return new CreateProduct(selenium, pageLoadTime);
		}
		
	}
}