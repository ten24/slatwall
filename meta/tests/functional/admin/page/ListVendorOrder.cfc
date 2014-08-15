component extends="PageObject" {
	
	variables.slatAction = "entity.listvendororder";
	variables.title = "Vendor Orders | Slatwall";
	variables.locators = {
		addVendorOrderButton = '//*[@title="Add Vendor Order"]',
		addVendorOrderModal = '//*[@id="adminModal"]/form',
		addVendorOrderVendorSuggestionTestRunnerVendor = '//*[@id="suggestionoption4028810a475a5990014768d1206b0432"]',
		addVendorOrderHiddenVendorIDField = 'vendor.vendorID'
	};
	
}