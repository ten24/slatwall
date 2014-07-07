component extends="AdminTestBase" {
	
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

	function taxCategoryRateCreateWorks() {
		
		var DetailTaxCategory = openPage( '?slatAction=entity.detailTaxCategory&taxCategoryID=444df2c8cce9f1417627bd164a65f133', 'DetailTaxCategory');
		
		// Confirm that the Detail Page is Loaded
		assertPageIsLoaded( DetailTaxCategory );
		
		//Create New Manual Rate
		var CreateTaxCategoryRate = DetailTaxCategory.clickAddTaxCategoryRateDropdownLink( 'Manual Rate' );	
		
		//Sets Up Form Data for Creation
		formData = {};
		formData['taxRate'] = '10';							
		formData['taxCategoryRateCode'] = "TEST-#getTickCount()#";
		sleep(10000);
		var DetailTaxCategoryRate = CreateTaxCategoryRate.submitCreateForm( formData );

		assertPageIsLoaded( DetailTaxCategoryRate );
	}
	
	
	public void function taxCategorySave_requires_taxCategoryCode(){
		var ListTaxCategory = variables.dashboardPage.clickMenuLink("Config", "Tax Categories");
		
		var CreateTaxCategory = ListTaxCategory.clickCreateTaxCategoryLink();
		
		formData = {};
		formData['taxCategoryName'] = "Test Tax Category Name";								
		
		CreateTaxCategory.submitCreateForm( formData );
		
		// Make sure that the TaxCategoryCreate is loaded
		//assertPageIsLoaded( CreateTaxCategory );
	}
	
	
}