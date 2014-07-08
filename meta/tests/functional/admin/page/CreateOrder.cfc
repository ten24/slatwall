component extends="PageObject" {
	
	variables.slatAction = "entity.preprocessorder&processContext=create";
	variables.title = "Create Order | Slatwall";
	public any function createOrder( struct formData={} ) {
		
		submitForm( arguments.formData );
		
		var pageLoadTime = waitForPageToLoad();
		
		return new EditOrder(selenium, pageLoadTime);
	}
}