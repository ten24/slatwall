component extends="AdminTestBase" {
	
	//Tests the autocomplete when creating vendor order
	public function autoCompleteVendorOrderWorks(){
		
		// Go to Vendor Order Listing Page
		var ListVendorOrder = openPage( '?slatAction=entity.listvendororder', 'ListVendorOrder');
		assertPageIsLoaded( ListVendorOrder );
		
		// Hit Create Vendor Order
		ListVendorOrder.clickLocatorWaitLocator('addVendorOrderButton', 'addVendorOrderModal');
		
		//Set up formData
		var formData = {};
		formData['vendor.vendorID-autocompletesearch'] = 'test runner';
		
		// Make sure the auto-suggest isn't there
		assertFalse(ListVendorOrder.isLocatorPresent('addVendorOrderVendorSuggestionTestRunnerVendor'));
		
		ListVendorOrder.populateForm( formData );
		ListVendorOrder.waitForLocator( 'addVendorOrderVendorSuggestionTestRunnerVendor' );
		
		// Make sure that the option is there now, (this is a bit redundent because the line above will throw an error if the locator never shows up )
		assert(ListVendorOrder.isLocatorPresent('addVendorOrderVendorSuggestionTestRunnerVendor'));
		
		// Make sure the hidden input is blank
		assertEquals('', ListVendorOrder.getLocatorValue('addVendorOrderHiddenVendorIDField') );
		
		// Click the option
		ListVendorOrder.mousedownLocator( 'addVendorOrderVendorSuggestionTestRunnerVendor' );
		
		// Make sure of what the input value is correct
		assertEquals('4028810a475a5990014768d1206b0432', ListVendorOrder.getLocatorValue('addVendorOrderHiddenVendorIDField') );
		
	}

}