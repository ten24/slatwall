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
	public void function taxCategorySave_requires_taxCategoryCode() {
		
		var ListTaxCategory = variables.dashboardPage.clickMenuLink("Config", "Tax Categories");
		
		var CreateTaxCategory = ListTaxCategory.clickCreateTaxCategoryLink();
		
		assertPageIsLoaded( CreateTaxCategory );
		
		formData = {};
		formData['taxCategoryName'] = "Test Tax Category Name";	
		formData['taxCategoryCode'] = "";								
		
		CreateTaxCategory.submitCreateForm( formData );
		
		assertEquals(1, selection.xpathCount('//*[@id="adminentitysavetaxcategory"]/div[2]/div/fieldset/div[3]/div/label'));
		
		assertEquals('This field is required.', selenium.getText('//*[@id="adminentitysavetaxcategory"]/div[2]/div/fieldset/div[3]/div/label'));
		
	}
	
	//Creates a manual tax rate and tests that it works on an order
	function taxCategoryManualRateCalculationWorks() {
		
		var DetailTaxCategory = openPage( '?slatAction=entity.detailTaxCategory&taxCategoryID=444df2c8cce9f1417627bd164a65f133', 'DetailTaxCategory');
		
		// Confirm that the Detail Page is Loaded
		assertPageIsLoaded( DetailTaxCategory );
		
		//Create New Manual Rate
		var CreateTaxCategoryRate = DetailTaxCategory.clickAddTaxCategoryRateDropdownLink( 'Manual Rate' );	
		
		//Sets Up Form Data for Creation
		formData = {};
		formData['taxRate'] = '10';							
		formData['taxCategoryRateCode'] = "TEST-#getTickCount()#";

		var DetailTaxCategoryRate = CreateTaxCategoryRate.submitCreateForm( formData );

		assertPageIsLoaded( DetailTaxCategoryRate );
		
		var CreateOrder = openPage( '?slatAction=entity.preprocessorder&processContext=create', 'CreateOrder');
		assertPageIsLoaded( CreateOrder );
		
		formData = {};
		formData['firstName'] = 'TestName1';
		formData['lastName'] = 'TestName2';	
		formData['company'] = 'TestCompany';	
		formData['phoneNumber'] = '1112223333';	
		formData['emailAddress'] = 'test@testmail.com';	
		formData['emailAddressConfirm'] = 'test@testmail.com';							

		//Saves new form Data
		var EditOrder = CreateOrder.createOrder( formData );

		assertPageIsLoaded( EditOrder );
		
		formData = {};
		formData['shippingAddress.name'] = 'Test Name';							
		formData['shippingAddress.company'] = 'Test Company';	
		formData['shippingAddress.streetAddress'] = '123 Main St';	
		formData['shippingAddress.city'] = 'San Diego';
		formData['shippingAddress.postalCode'] = '92128';	
		
		EditOrder.addItemToOrder( formData );
		
		assertPageIsLoaded( EditOrder );
		
		//***********************************************************************
		
		// Convert string to numbers
		
		var totalTaxCell = selenium.getText('//*[@id="hibachiPropertyTable1"]/tbody/tr[5]/td[2]');
		//var subTotalCell = selenium.getText('//*[@id="hibachiPropertyTable"]/tbody/tr[4]/td[2]');
		//var expectedTaxTotal = subTotalCell * .1;
		
		//assert(totalTaxCell == expectedTaxTotal);
		
		//***********************************************************************
		debug(totalTaxCell);
		sleep(10000);
		//Delete the Test Order
		EditOrder.deleteOrder();

		// Go back to Tax Category Listing Page
		var DetailTaxCategory = openPage( '?slatAction=entity.detailTaxCategory&taxCategoryID=444df2c8cce9f1417627bd164a65f133', 'DetailTaxCategory');
		
		assertPageIsLoaded( DetailTaxCategory );
		
		
		DetailTaxCategory.deleteTaxCategoryRate();

	}
	
}