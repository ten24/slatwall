component extends="AdminTestBase" {
	
	//Tests that adding an option group to a product disables the ability to add skus
	public function addingOptionGroupDisablesAddSkuTest(){
		
		//Open product page
		var DetailProduct = openPage( '?slatAction=entity.detailproduct&s=1&productID=8a808083472135b6014721625eee0033', 'DetailProduct');
		assertPageIsLoaded( DetailProduct );
		
		//Add Option Group to product
		DetailProduct = DetailProduct.addOptionGroup();
		
		assertPageIsLoaded( DetailProduct );
		
		sleep(10000);
		
		//Assert that add sku button is not present
		assertFalse(selenium.isElementPresent(addSkuButtonXPath()));

	}
	
	
	//================= Helper Functions ==================
	
	private any function addSkuButtonXPath(){
		return '//*[@id="tabskus"]/div/a[1]';
	}
}