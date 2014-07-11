component extends="PageObject" {
	
	variables.slatAction = "entity.listcartandquote";
	variables.title = "Carts & Quotes | Slatwall";
	
	public any function clickCreateOrderLink( struct formData={} ) {
		selenium.click("link=Create Order");
		
		selenium.waitForElementPresent('//*[@id="adminentityprocessorder_create"]');
		
		selenium.click('//*[@id="adminentityprocessorder_create"]/div[2]/div/div/fieldset/div[1]/div/label[2]/input');
		
		selenium.waitForElementPresent('//*[@id="adminentityprocessorder_create"]');
		
		selenium.type('accountID-autocompletesearch', 'test');
		selenium.typeKeys('accountID-autocompletesearch', 'test');
		
		selenium.waitForElementPresent('//*[@id="suggestionoption8a80808746d95bb30146f87fcedc0864"]');
		
		selenium.mouseDown('//*[@id="suggestionoption8a80808746d95bb30146f87fcedc0864"]');
		
		sleep(50000);
		/*
		
		selenium.typeKeys('accountID-autocompletesearch', 'test');
		
		selenium.waitForElementPresent('//*[@id="accountID_"]');
		
		selenium.select('//*[@id="accountID_"]','//*[@id="accountID_"]/li[1]');
		
		//submitForm( 'adminentityprocessorder_create', arguments.formData );
		
		var loadTime = waitForPageToLoad();
		
		return new EditOrder(selenium, loadTime);
		*/
	}
	
}