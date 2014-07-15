component extends="AdminTestBase" {
	
	//Tests the ability to create, edit, and delete a tax category
	function taxCategoryCreateEditAndDeleteWorks() {
		// Load Listing Page
		var taxCategoryList = variables.dashboardPage.clickMenuLink("Config", "Tax Categories");  	// Tax Categories | Slatwall
		
		assertPageIsLoaded( taxCategoryList );														// Tax Categories | Slatwall
		
		// Load Create Page
		var taxCategoryCreate = taxCategoryList.clickCreateTaxCategoryLink();						// Create Tax Category | Slatwall
		
		assertPageIsLoaded( taxCategoryCreate );
		
		//Sets Up Form Data for Creation
		formData = {};
		formData['taxCategoryName'] = "Test Tax Category Name";								
		formData['taxCategoryCode'] = "TEST-#getTickCount()#";
		
		var taxCategoryDetail = taxCategoryCreate.submitCreateForm( formData );
		
		assertPageIsLoaded( taxCategoryDetail );
		assertEquals( "Test Tax Category Name | Slatwall", taxCategoryDetail.getTitle() );
		assertEquals( "Yes", taxCategoryDetail.getText_ActiveFlag() );
		assertEquals( "Test Tax Category Name", taxCategoryDetail.getText_TaxCategoryName() );
		assertEquals( formData['taxCategoryCode'], taxCategoryDetail.getText_TaxCategoryCode() );
		
		// Tests Edit Button
		var taxCategoryEdit = taxCategoryDetail.clickEditLink();
		
		assertPageIsLoaded( taxCategoryEdit );
		assertEquals( "Test Tax Category Name | Slatwall", taxCategoryEdit.getTitle() );	
		
		//Sets Up New Form Data
		formData['taxCategoryName'] = "My Tax Categories Second Name";
		
		//Saves new form Data
		taxCategoryDetail = taxCategoryEdit.submitSaveForm(formData);
		
		assertPageIsLoaded( taxCategoryDetail );
		//Asserts New Data is present
		assertEquals( "My Tax Categories Second Name | Slatwall", taxCategoryDetail.getTitle() );
		
		//Deletes Test Category
		taxCategoryList = taxCategoryDetail.clickDeleteLink();
		assertPageIsLoaded( taxCategoryList );
	}
	
	//Tests the validation of creating a tax category without a tax category code
	public void function taxCategorySaveRequiresTaxCategoryCode() {
		
		var ListTaxCategory = variables.dashboardPage.clickMenuLink("Config", "Tax Categories");
		
		var CreateTaxCategory = ListTaxCategory.clickCreateTaxCategoryLink();
		
		assertPageIsLoaded( CreateTaxCategory );
		
		formData = {};
		formData['taxCategoryName'] = "Test Tax Category Name";	
		formData['taxCategoryCode'] = "";								
		
		CreateTaxCategory.submitCreateForm( formData );

		assertEquals(1, selenium.getXpathCount('//*[@id="adminentitysavetaxcategory"]/div[3]/div/fieldset/div[3]/div/label'));
		
		assertEquals('The Tax Category Code is required.', selenium.getText('//*[@id="adminentitysavetaxcategory"]/div[3]/div/fieldset/div[3]/div/label'));
		
	}
	
	//Creates a manual tax rate and tests that it works on an order
	function taxCategoryManualRateCalculationWorks() {
		//Ensure Default is turned on and that no other tax category is turned on
		turnOFFAllTaxCategories();		
		turnONDefaultTaxCategory();

		// Ensure that the sku setting uses the correct tax category
		selectThisTaxCategoryAsSkuSetting();

		// Confirm that the Detail Page is Loaded
		DetailTaxCategory = openPage( '?slatAction=entity.detailTaxCategory&taxCategoryID=444df2c8cce9f1417627bd164a65f133', 'DetailTaxCategory');
		assertPageIsLoaded( DetailTaxCategory );
		
		//Create New Manual Rate
		var CreateTaxCategoryRate = DetailTaxCategory.clickAddTaxCategoryRateDropdownLink( 'Manual Rate' );	
		
		//Sets Up Form Data for Creation
		formData = {};
		formData['taxRate'] = '10';							
		formData['taxCategoryRateCode'] = "TEST-#getTickCount()#";

		DetailTaxCategoryRate = CreateTaxCategoryRate.submitCreateForm( formData );

		assertPageIsLoaded( DetailTaxCategoryRate );
		
		//Open Edit Order Page
		var EditOrder = openPage( '?slatAction=entity.editorder&orderID=8a8080834721af1a01473b0466e106d9', 'EditOrder');
		assertPageIsLoaded( EditOrder );
		
		//Add a product to the order
		formData = {};
		formData['shippingAddress.name'] = 'Test Name';							
		formData['shippingAddress.company'] = 'Test Company';	
		
		var EditOrderPageWithOneItem = EditOrder.addItemToOrder( formData );
		
		assertPageIsLoaded( EditOrderPageWithOneItem );
		
		// Convert string to numbers and assert totalTax equals 10 dollars as expected
		var totalTaxCell = LSParseCurrency(selenium.getText('//*[@id="hibachiPropertyTable1"]/tbody/tr[5]/td[2]'));
		assertEquals(10, totalTaxCell);
	
		//Delete the Test Order
		EditOrderPageWithOneItem.deleteOrder();

		// Go back to Tax Category Listing Page
		var DetailTaxCategory = openPage( '?slatAction=entity.detailTaxCategory&taxCategoryID=444df2c8cce9f1417627bd164a65f133', 'DetailTaxCategory');
		
		assertPageIsLoaded( DetailTaxCategory );

		DetailTaxCategory.deleteTaxCategoryRate();
		
		EditTaxCategory = openPage( '?slatAction=entity.editTaxCategory&taxCategoryID=444df2c8cce9f1417627bd164a65f133', 'EditTaxCategory');
		assertPageIsLoaded( EditTaxCategory );
		
		DetailTaxCategory = EditTaxCategory.turnONActiveFlag();
		assertPageIsLoaded( DetailTaxCategory );
	}
	
	//Tests Tax Address Lookup order
	function taxCategoryRateAddressLookupWorks(){
		//First Turn off Default Tax Category
		turnOFFAllTaxCategories();
		turnONAddressTestingTaxCategory();
		// Ensure that the sku setting uses the correct tax category
		selectThisTaxCategoryAsSkuSetting();
	
		//Open Edit Order Page
		var EditOrder = openPage( '?slatAction=entity.editorder&orderID=8a8080834721af1a01473607810d020e', 'EditOrder');
		assertPageIsLoaded( EditOrder );
		
		//Add a product to the order
		formData = {};
		formData['shippingAddress.name'] = 'Test Name';							
		formData['shippingAddress.company'] = 'Test Company';
		
		EditOrder = EditOrder.addItemToOrder( formData );
		assertPageIsLoaded( EditOrder );

		//Set up form data for Shipping to Billing Address Lookup test
		var formDataShipToBill = {};
		formDataShipToBill['taxRate'] = '25';
		formDataShipToBill['taxCategoryRateCode'] = 'ShipToBillTest';
		
		//Set up form data for Billing to Shipping Address Lookup test
		var formDataBillToShip = {};
		formDataBillToShip['taxRate'] = '50';
		formDataBillToShip['taxCategoryRateCode'] = 'BillToShipTest';
		
		var formDataArray = [formDataShipToBill, formDataBillToShip];
		var expectedTax = [25.00, 50];
		
		//Test Both Using a loop
		for(var i=1;i<=arrayLen(formDataArray);i++){
			
			//Open Detail Tax Category Page for testing
			var DetailTaxCategory = openPage( '?slatAction=entity.detailtaxcategory&taxCategoryID=8a8080834721af1a014735ac8b4201f2', 'DetailTaxCategory');
			assertPageIsLoaded( DetailTaxCategory );

			DetailTaxCategory = DetailTaxCategory.editTaxCategoryRateTaxAddressLookup( formDataArray[i] );
			assertPageIsLoaded( DetailTaxCategory );	
			
			//Open Order Page and save it then check the tax
			EditOrder = openPage( '?slatAction=entity.editorder&orderID=8a8080834721af1a01473607810d020e', 'EditOrder');
			assertPageIsLoaded( EditOrder );
			
			var DetailOrder = EditOrder.saveOrder();
			assertPageIsLoaded( DetailOrder );
			
			// Convert string to numbers and assert totalTax equals the correct dollar= amount
			var totalTaxCell = LSParseCurrency(selenium.getText('//*[@id="hibachiPropertyTable1"]/tbody/tr[5]/td[2]'));
			assertEquals(expectedTax[i], totalTaxCell);			
		
		}
		
		//Delete the Order Item
		EditOrder = openPage( '?slatAction=entity.editorder&orderID=8a8080834721af1a01473607810d020e', 'EditOrder');
		assertPageIsLoaded( EditOrder );
		EditOrder.deleteOrder();
	}
	
	//============= Helpers ======================
	public void function turnOFFAllTaxCategories(){
		//Address Testing Tax Category
		var EditTaxCategory = openPage( '?slatAction=entity.editTaxCategory&taxCategoryID=8a8080834721af1a014735ac8b4201f2', 'EditTaxCategory');
		assertPageIsLoaded( EditTaxCategory );
		
		var DetailTaxCategory = EditTaxCategory.turnOFFActiveFlag();
		assertPageIsLoaded( DetailTaxCategory );
		
		//Default
		EditTaxCategory = openPage( '?slatAction=entity.editTaxCategory&taxCategoryID=444df2c8cce9f1417627bd164a65f133', 'EditTaxCategory');
		assertPageIsLoaded( EditTaxCategory );
		
		DetailTaxCategory = EditTaxCategory.turnOFFActiveFlag();
		assertPageIsLoaded( DetailTaxCategory );
	}
	
	//Default
	public function turnONDefaultTaxCategory(){
		var EditTaxCategory = openPage( '?slatAction=entity.editTaxCategory&taxCategoryID=444df2c8cce9f1417627bd164a65f133', 'EditTaxCategory');
		assertPageIsLoaded( EditTaxCategory );
		
		var DetailTaxCategory = EditTaxCategory.turnONActiveFlag();
		assertPageIsLoaded( DetailTaxCategory );
	}
	
	//Address Testing Tax Category
	public function turnONAddressTestingTaxCategory(){
		var EditTaxCategory = openPage( '?slatAction=entity.editTaxCategory&taxCategoryID=8a8080834721af1a014735ac8b4201f2', 'EditTaxCategory');
		assertPageIsLoaded( EditTaxCategory );
		
		var DetailTaxCategory = EditTaxCategory.turnONActiveFlag();
		assertPageIsLoaded( DetailTaxCategory );
	}
	
	// Ensure that the sku setting uses the correct tax category
	public function selectThisTaxCategoryAsSkuSetting(){
		var Settings = openPage( '?slatAction=entity.settings', 'Settings');
		assertPageIsLoaded( Settings );
		
		Settings.setupSkuSettingTaxCategory();
	}
	
}