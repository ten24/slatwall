component extends="PageObject" {
	
	variables.slatAction = "entity.listvendororder";
	variables.title = "Vendor Orders | Slatwall";
	variables.locators = {
		addVendorOrderButton = '//*[@title="Add Vendor Order"]',
		addVendorOrderModal = '//*[@id="adminModal"]/form',
		addVendorNameAutoComplete = '//*[@class="vendorid"]'
	};

	public boolean function autoCompleteVendorOrderTest( struct formData={} ){
		selenium.click(variables.locators['addVendorOrderButton']);
		selenium.waitForElementPresent(variables.locators['addVendorOrderModal']);
		for(var key in arguments.formData) {
			selenium.type( key, arguments.formData[key] );
		}
		return selenium.isElementPresent(variables.locators['addVendorNameAutoComplete']);
	}
	
}