component extends="AdminTestBase" {

	//Tests that adding an option group to a product disables the ability to add skus
	public function addingOptionGroupDisablesAddSkuTest(){
		
		//Open product page
		var DetailProduct = openPage( '?slatAction=entity.detailproduct&s=1&productID=63c5960bb1df4982a2e8836e720333b0', 'DetailProduct');
		assertPageIsLoaded( DetailProduct );
		
		//Add Option Group to product
		DetailProduct = DetailProduct.addOptionGroup();
		
		assertPageIsLoaded( DetailProduct );
		
		//Assert that add sku button is not present
		assertFalse(selenium.isElementPresent(addSkuButtonXPath()));
		
		//need a way to reset product back to how it was originally inserted into the db

	}


	//Tests that adding a sku to a product disables the ability to addoption group
	public function addingSkuDisablesAddgOptionGroupTest(){
		
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
		
		//need a way to reset product back to the way it was originally inserted into db

	}
	

	//================= Helper Functions ==================
	
	private any function addSkuButtonXPath(){
		return '//*[@id="tabskus"]/div/a[1]';
	}
	private any function addOptionGroupButtonXPath(){
		return '//*[@id="tabskus"]/div/a[2]';
	}
}