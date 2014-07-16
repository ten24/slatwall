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

		// Ensure that the sku setting uses the correct tax category
		selectSkuSettingTaxCategory( 'Default' );

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
		var EditOrder = openPage( '?slatAction=entity.editorder&orderID=be195c2df21744049028368cbd36e6d2', 'EditOrder');
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

		//Set up array of sku settings tax category select options
		var skuSettingsTaxCategoryOptionsArray = ['TestRunner_TaxAddressLookup_ShipToBill','TestRunner_TaxAddressLookup_BillToShip','TestRunner_TaxAddressLookup_Ship','TestRunner_TaxAddressLookup_Bill'];
		
		//Set up array of the two orders used to test each tax category and add an item to each
		var taxCategoryAddressLookupTestOrderIDArray = ['8a8080834721af1a01473607810d020e','8a8080834721af1a01473b0466e106d9'];
		
		for(var orderID in taxCategoryAddressLookupTestOrderIDArray){
			//Open Edit Order Page
			var EditOrder = openPage( '?slatAction=entity.editorder&orderID=#orderID#', 'EditOrder');
			assertPageIsLoaded( EditOrder );
			
			//Add a product to the order
			formData = {};
			EditOrder = EditOrder.addItemToOrder( formData );
			assertPageIsLoaded( EditOrder );
		}

		//Set up an array of the the two expected tax totals
		var expectedTax = [25,0];
		
		//Loop over taxAddressLookupTestTaxCategoriesArray
		for(var taxOption in skuSettingsTaxCategoryOptionsArray){

			//Set the sku setting to the current tax category
			selectSkuSettingTaxCategory( taxOption );
			
			//Loop over both orders to check success and to check failure
			for(var order in taxCategoryAddressLookupTestOrderIDArray){
				
				//Go to orders to check the totalTax cell of the view's table
				var EditOrder = openPage( '?slatAction=entity.editorder&orderID=#order#', 'EditOrder');
				assertPageIsLoaded( EditOrder );
				
				//Save the Order
				var DetailOrder = EditOrder.saveOrder();
				assertPageIsLoaded( DetailOrder );
				
				var totalTaxCell = LSParseCurrency(selenium.getText('//*[@id="hibachiPropertyTable1"]/tbody/tr[5]/td[2]'));
				
				if(order == taxCategoryAddressLookupTestOrderIDArray[1] && taxOption == 'TestRunner_TaxAddressLookup_ShipToBill'){
					assertEquals(expectedTax[1], totalTaxCell);
				} else if(order == taxCategoryAddressLookupTestOrderIDArray[2] && taxOption == 'TestRunner_TaxAddressLookup_ShipToBill'){
					assertEquals(expectedTax[2], totalTaxCell);
				} else if(order == taxCategoryAddressLookupTestOrderIDArray[1] && taxOption == 'TestRunner_TaxAddressLookup_BillToShip'){
					assertEquals(expectedTax[2], totalTaxCell);
				} else if(order == taxCategoryAddressLookupTestOrderIDArray[2] && taxOption == 'TestRunner_TaxAddressLookup_BillToShip'){
					assertEquals(expectedTax[2], totalTaxCell);
				} else if(order == taxCategoryAddressLookupTestOrderIDArray[1] && taxOption == 'TestRunner_TaxAddressLookup_Ship'){
					assertEquals(expectedTax[1], totalTaxCell);
				} else if(order == taxCategoryAddressLookupTestOrderIDArray[2] && taxOption == 'TestRunner_TaxAddressLookup_Ship'){
					assertEquals(expectedTax[2], totalTaxCell);
				} else if(order == taxCategoryAddressLookupTestOrderIDArray[1] && taxOption == 'TestRunner_TaxAddressLookup_Bill'){
					assertEquals(expectedTax[2], totalTaxCell);
				} else if(order == taxCategoryAddressLookupTestOrderIDArray[2] && taxOption == 'TestRunner_TaxAddressLookup_Bill'){
					assertEquals(expectedTax[2], totalTaxCell);
				}
				
			}	
		
		}
		
		//Delete the orders	
		for(var orderID in taxCategoryAddressLookupTestOrderIDArray){
			var EditOrder = openPage( '?slatAction=entity.editorder&orderID=#orderID#', 'EditOrder');
			assertPageIsLoaded( EditOrder );
			EditOrder.deleteOrder();
		}

	}
	
	//============= Helpers ======================

	// Ensure that the sku setting uses the correct tax category
	private function selectSkuSettingTaxCategory( required string ){
		var Settings = openPage( '?slatAction=entity.settings', 'Settings');
		assertPageIsLoaded( Settings );
		
		Settings.setupSkuSettingTaxCategory( arguments.string );
	}
	
}