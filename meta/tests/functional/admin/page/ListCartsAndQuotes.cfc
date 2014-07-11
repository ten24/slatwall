component extends="PageObject" {
	
	variables.slatAction = "entity.listcartandquote";
	variables.title = "Carts & Quotes | Slatwall";
	
	public any function clickCreateOrderLink( struct formData={} ) {
		selenium.click("link=Create Order");
		
		selenium.waitForElementPresent('//*[@id="adminentityprocessorder_create"]');
		
		selenium.click('//*[@id="adminentityprocessorder_create"]/div[2]/div/div/fieldset/div[1]/div/label[2]/input');
		
		selenium.waitForElementPresent('//*[@id="adminentityprocessorder_create"]');
		
		selenium.typeKeys('accountID-autocompletesearch', 'test');
		
		selenium.waitForElementPresent('//*[@id="accountID_"]');
		
		selenium.select('//*[@id="accountID_"]','//*[@id="accountID_"]/li[1]');
		
		//submitForm( 'adminentityprocessorder_create', arguments.formData );
		
		var loadTime = waitForPageToLoad();
		
		return new EditOrder(selenium, loadTime);
	}
	
}