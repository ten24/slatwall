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
	/*
	function taxCategoryManualRateCalculationWorks() {

		// Ensure that the sku setting uses the correct tax category
		selectSkuSettingTaxCategory( 'TestRunner Manual Rate' );

		// Confirm that the Detail Page is Loaded
		DetailTaxCategory = openPage( '?slatAction=entity.detailTaxCategory&taxCategoryID=bf046da61f434a58a2be28d099017214', 'DetailTaxCategory');
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
		var EditOrder = openPage( '?slatAction=entity.editorder&orderID=be195c2df21744049028368cbd36e6d2', 'EditOrder');
		assertPageIsLoaded( EditOrder );

		var DetailOrder = EditOrder.saveOrder();
		assertPageIsLoaded( DetailOrder );
		
		// Convert string to numbers and assert totalTax equals 10 dollars as expected
		var totalTaxCell = LSParseCurrency(selenium.getText('//*[@id="hibachiPropertyTable1"]/tbody/tr[5]/td[2]'));
		
		if( totalTaxCell == 10 ){
			var assertionBoolean = true;
		} else {
			var assertionBoolean = false;
		}
		
		// Go back to Tax Category Page
		var DetailTaxCategory = openPage( '?slatAction=entity.detailTaxCategory&taxCategoryID=bf046da61f434a58a2be28d099017214', 'DetailTaxCategory');
		assertPageIsLoaded( DetailTaxCategory );
		DetailTaxCategory.deleteTaxCategory();
		
		
		assert( assertionBoolean );
	}
	
	//Tests Tax Address Lookup order
	function taxCategoryRateAddressLookupWorks(){

		//Set up product settings formData struct
		selectSkuSettingTaxCategory( 'TestRunner_TaxAddressLookupTest' );	

		//Set up form data for Shipping to Billing Address Lookup test
		var formDataShipToBill = {};
		formDataShipToBill['taxRate'] = '25';
		formDataShipToBill['taxCategoryRateCode'] = 'ShipToBillTest';
		
		//Set up form data for Billing to Shipping Address Lookup test
		var formDataBillToShip = {};
		formDataBillToShip['taxRate'] = '50';
		formDataBillToShip['taxCategoryRateCode'] = 'BillToShipTest';
		
		var formDataArray = [formDataBillToShip, formDataShipToBill];
		var expectedTax = [50, 25];
		
		//Test Both Using a loop
		for(var i=1;i<=arrayLen(formDataArray);i++){
			
			//Open Detail Tax Category Page for testing
			var DetailTaxCategory = openPage( '?slatAction=entity.detailtaxcategory&taxCategoryID=e744f32c9ad9451fb12dc37bcc8c22f3', 'DetailTaxCategory');
			assertPageIsLoaded( DetailTaxCategory );

			DetailTaxCategory = DetailTaxCategory.editTaxCategoryRateTaxAddressLookup( formDataArray[i] );
			assertPageIsLoaded( DetailTaxCategory );	
			
			//Open Order Page and save it then check the tax
			EditOrder = openPage( '?slatAction=entity.editorder&orderID=be195c2df21744049028368cbd36e6d2', 'EditOrder');
			assertPageIsLoaded( EditOrder );
			
			var DetailOrder = EditOrder.saveOrder();
			assertPageIsLoaded( DetailOrder );
			
			// Convert string to numbers and assert totalTax equals the correct dollar= amount
			var totalTaxCell = LSParseCurrency(selenium.getText('//*[@id="hibachiPropertyTable1"]/tbody/tr[5]/td[2]'));
			assertEquals(expectedTax[i], totalTaxCell);			
		
		}

	}
	*/	
	//============= Helpers ======================

	// Ensure that the sku setting uses the correct tax category
	private function selectSkuSettingTaxCategory( required string ){
		var DetailProduct = openPage( '?slatAction=entity.detailproduct&productID=8a808083472135b6014721625eee0033', 'DetailProduct');
		assertPageIsLoaded( DetailProduct );
		
		DetailProduct.setupSkuSettingTaxCategory( arguments.string );
	}
	
}