component extends="PageObject" {
	
	variables.slatAction = "entity.listcartandquote";
	variables.title = "Carts & Quotes | Slatwall";
	
	public any function clickCreateOrderLink( struct formData={} ) {
		selenium.click("link=Create Order");
		
		selenium.waitForElementPresent('//*[@id="adminentityprocessorder_create"]');
		
		submitForm( 'adminentityprocessorder_create', arguments.formData );
		
		var loadTime = waitForPageToLoad();
		
		return new EditOrder(selenium, loadTime);
	}
	
}