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
		formData['taxCategoryName'] = "My First Tax Category Name";								
		formData['taxCategoryCode'] = "TEST-#getTickCount()#";
		
		var taxCategoryDetail = taxCategoryCreate.submitCreateForm( formData );
		
		assertPageIsLoaded( taxCategoryDetail );
		assertEquals( "My First Tax Category Name | Slatwall", taxCategoryDetail.getTitle() );
		assertEquals( "Yes", taxCategoryDetail.getText_ActiveFlag() );
		assertEquals( "My First Tax Category Name", taxCategoryDetail.getText_TaxCategoryName() );
		assertEquals( formData['taxCategoryCode'], taxCategoryDetail.getText_TaxCategoryCode() );
		
		// Tests Edit Button
		var taxCategoryEdit = taxCategoryDetail.clickEditLink();
		
		assertPageIsLoaded( taxCategoryEdit );
		assertEquals( "My First Tax Category Name | Slatwall", taxCategoryEdit.getTitle() );	
		
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
	
	function taxCategorySave_requires_taxCategoryCode(){
		var taxCategoryList = variables.dashboardPage.clickMenuLink("Config", "Tax Categories");
		var taxCategoryDetail = taxCategoryList.clickCreateTaxCategoryLink();
		
		selenium.type("taxCategoryName", "My Tax Category Name");
		
		selenium.submit("adminentitysavetaxcategory");
		
		// Make sure that the taxCategoryDetail is loaded
		assertPageIsLoaded( taxCategoryDetail );
	}
}