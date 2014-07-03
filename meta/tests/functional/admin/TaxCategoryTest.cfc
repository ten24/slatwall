component extends="AdminTestBase" {

	function taxCategoryCreateEditAndDeleteWorks() {
		//Create Tax Category
		var taxCategoryDetail = taxCategoryCreate();
		
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
		//Create Tax Category
		var taxCategoryDetail = taxCategoryCreate();
		assertPageIsLoaded( taxCategoryDetail );

		//Create New Manual Rate
		//var createTaxCategoryRate = taxCategoryDetail.clickAddTaxCategoryRateLink();	
		
		debug(selenium.getAllLinks());
/*
		//Sets Up Form Data for Creation
		formData = {};
		formData['taxRate'] = 10;							
		formData['taxCategoryRateCode'] = "TEST-#getTickCount()#";
		
		var detailTaxCategoryRate = createTaxCategoryRate.submitCreateForm( formData );
		
		//Deletes Test Category
		taxCategoryList = taxCategoryDetail.clickDeleteLink();
		assertPageIsLoaded( taxCategoryList );*/
	}
	
	function taxCategorySave_requires_taxCategoryCode(){
		var taxCategoryList = variables.dashboardPage.clickMenuLink("Config", "Tax Categories");
		var taxCategoryDetail = taxCategoryList.clickCreateTaxCategoryLink();
		
		selenium.type("taxCategoryName", "My Tax Category Name");
		
		selenium.submit("adminentitysavetaxcategory");
		
		// Make sure that the taxCategoryDetail is loaded
		assertPageIsLoaded( taxCategoryDetail );
	}
	
	private any function taxCategoryCreate(){
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
		
		return taxCategoryDetail;
	}
	
}