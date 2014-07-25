component extends="AdminTestBase" {

	//Tests that adding an option group to a product disables the ability to add skus
	public function addingOptionGroupDisablesAddSkuTest(){
		
		//Create a product
		var CreateProduct = openPage( '?slatAction=entity.createproduct&baseProductType=merchandise', 'CreateProduct' );	
		assertPageIsLoaded( CreateProduct );	
		
		var formData = {};
		formData['productName'] = 'TestRunner Temporary Product - Add Option Group';
		formData['productCode'] = 'TRTP-AOG';
		formData['price'] = '100';
		
		var DetailProduct = CreateProduct.submitCreateForm( formData );
		
		//Add Option Group to product
		DetailProduct = DetailProduct.addOptionGroup();
		assertPageIsLoaded( DetailProduct );
		
		var assertBoolean = DetailProduct.isAddSkuButtonPresent();
		
		//Delete Product before assertion to ensure db cleanliness in case of test failure
		var ListProducts = DetailProduct.deleteProduct();
		assertPageIsLoaded( ListProducts );
		
		//Assert that add sku button is not present
		assertFalse(assertBoolean);

	}


	//Tests that adding a sku to a product disables the ability to addoption group
	public function addingSkuDisablesAddOptionGroupTest(){
		
		//Create a product
		var CreateProduct = openPage( '?slatAction=entity.createproduct&baseProductType=merchandise', 'CreateProduct' );	
		assertPageIsLoaded( CreateProduct );	
		
		var formData = {};
		formData['productName'] = 'TestRunner Temporary Product - Add Sku';
		formData['productCode'] = 'TRTP-AS';
		formData['price'] = '100';
		
		var DetailProduct = CreateProduct.submitCreateForm( formData );
		assertPageIsLoaded( DetailProduct );
		
		var skuFormData = {};
		skuFormData['//*[@id="adminentityprocessproduct_addsku"]/div[2]/div/div/fieldset/div[2]/div/input'] = 'Disabling Option Group Test';
		skuFormData['//*[@id="adminentityprocessproduct_addsku"]/div[2]/div/div/fieldset/div[3]/div/input'] = 'DOGT';
		
		//Add Sku to product
		DetailProduct = DetailProduct.addSku( skuFormData );
		assertPageIsLoaded( DetailProduct );
		
		var assertBoolean = DetailProduct.isAddOptionGroupButtonPresent();
		
		//Delete Product before assertion to ensure db cleanliness in case of test failure
		var ListProducts = DetailProduct.deleteProduct();
		assertPageIsLoaded( ListProducts );
		
		//Assert that add sku button is not present
		assertFalse(assertBoolean);

	}
	
	//Tests creating a merchandise product works
	public function createMerchProduct(){
		// Load Listing Page
		var ListProducts = variables.dashboardPage.clickMenuLink("Products", "Products");
		assertPageIsLoaded( ListProducts );	
		
		var CreateProduct = ListProducts.openCreateMerchandiseProduct();
		assertPageIsLoaded( CreateProduct );
		
		var formData = {};
		formData['productName'] = 'TestRunner Temporary Product Creation';
		formData['productCode'] = 'TRTP';
		formData['price'] = '100';
		
		var DetailProduct = CreateProduct.submitCreateForm( formData );
		assertPageIsLoaded( DetailProduct );
		
		ListProducts = DetailProduct.deleteProduct();
		assertPageIsLoaded( ListProducts );	
		
	}

}