component extends="AdminTestBase" {

	//Tests that adding an option group to a product disables the ability to add skus
	public function addingOptionGroupDisablesAddSkuTest(){
		
		//Open product page
		
		//instead of this just create a product
	
		var DetailProduct = openPage( '?slatAction=entity.detailproduct&s=1&productID=63c5960bb1df4982a2e8836e720333b0', 'DetailProduct' );
		assertPageIsLoaded( DetailProduct );
		
		//Add Option Group to product
		DetailProduct = DetailProduct.addOptionGroup();
		
		assertPageIsLoaded( DetailProduct );
		
		//Assert that add sku button is not present
		assertFalse(selenium.isElementPresent(addSkuButtonXPath()));
		
		//Remove added option group
		//If a test fails the new record will get add to the db everytime its run until the bug is fixed.
	}


	//Tests that adding a sku to a product disables the ability to addoption group
	public function addingSkuDisablesAddOptionGroupTest(){
		
		//Open product page
		var DetailProduct = openPage( '?slatAction=entity.detailproduct&s=1&productID=c69b96edbe4945c08145155526f0b60a', 'DetailProduct');
		assertPageIsLoaded( DetailProduct );
		
		var formData = {};
		formData['//*[@id="adminentityprocessproduct_addsku"]/div[2]/div/div/fieldset/div[2]/div/input'] = 'Disabling Option Group Test';
		formData['//*[@id="adminentityprocessproduct_addsku"]/div[2]/div/div/fieldset/div[3]/div/input'] = 'DOGT';
		
		//Add Option Group to product
		DetailProduct = DetailProduct.addSku( formData );
		assertPageIsLoaded( DetailProduct );
		
		//Assert that add sku button is not present
		assertFalse(selenium.isElementPresent(addOptionGroupButtonXPath()));
		debug(selenium.getLog());
		
		//Remove added sku
		var DetailSku = DetailProduct.detailPageOfAddedSku();
		assertPageIsLoaded( DetailSku );
		
		var ListSkus = DetailSku.deleteSku();
		assertPageIsLoaded( ListSkus ); 
	}
	

	//================= Helper Functions ==================
	
	private any function addSkuButtonXPath(){
		return '//*[@id="tabskus"]/div/a[1]';
	}
	private any function addOptionGroupButtonXPath(){
		return '//*[@id="tabskus"]/div/a[2]';
	}
}