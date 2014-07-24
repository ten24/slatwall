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
		populateForm(arguments.formData);
		return selenium.isElementPresent(variables.locators['addVendorNameAutoComplete']);
	}
	
}