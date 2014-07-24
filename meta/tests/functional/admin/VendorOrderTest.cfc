component extends="AdminTestBase" {
	
	//Tests the autocomplete when creating vendor order
	public function autoCompleteVendorOrderWorks(){
		//Go to Vendor Order Listing Page
		var ListVendorOrder = openPage( '?slatAction=entity.listvendororder', 'ListVendorOrder');
		assertPageIsLoaded( ListVendorOrder );
		
		//Set up formData
		var formData = {};
		formData['//*[@id="adminentitysavevendororder"]/div[2]/div/div/fieldset/div[2]/div/div/input[2]'] = 'T';
		
		//Hit Create Order
		var assertionBoolean = ListVendorOrder.autoCompleteVendorOrderTest( formData );
		
		//Assert Element is present
		assert(assertionBoolean);
	}

}