component extends="AdminTestBase" {

	function taxCategoryCreateEditAndDeleteWorks() {
		// Load Listing Page
		var taxCategoryList = variables.dashboardPage.openMenuLink("Config", "Tax Categories");
		
		assertPageIsLoaded( taxCategoryList );
		
		// Load Create Page
		var taxCategoryCreate = taxCategoryList.openCreateTaxCategoryLink();

		assertPageIsLoaded( taxCategoryCreate );
		//Sets Up Form Data for Creation
		formData = {};
		formData['taxCategoryName'] = "Create Tax Category";
		formData['taxCategoryCode'] = "TEST-#getTickCount()#";
		
		taxCategoryDetail = taxCategoryCreate.submitCreateForm(formData);
		
		assertEquals( "Create Tax Category | Slatwall", taxCategoryDetail.getTitle() );
		
		//Tests Edit Button
		var taxCategoryEdit = taxCategoryDetail.edit();
		
		assertPageIsLoaded( taxCategoryEdit );	
	
		//Sets Up New Form Data
		formData['taxCategoryName'] = "Edit Tax Category";
		formData['taxCategoryCode'] = "TEST-#getTickCount()#";
		
		//Saves new form Data
		taxCategoryEdit = taxCategoryEdit.submitSaveForm(formData);
		
		//Asserts New Data is present
		assertEquals( "Edit Tax Category | Slatwall", taxCategoryEdit.getTitle() );
		
		//Deletes Test Category
		taxCategoryList = taxCategoryDetail.delete();
		
		assertPageIsLoaded( taxCategoryList );
	}
	
	function taxCategorySave_requires_taxCategoryCode(){
		var taxCategoryList = variables.dashboardPage.openMenuLink("Config", "Tax Categories");
		var taxCategoryDetail = taxCategoryList.openCreateTaxCategoryLink();
		
		selenium.type("taxCategoryName", "My Tax Category Name");
		
		selenium.submit("adminentitysavetaxcategory");
		
		// Make sure that the taxCategoryDetail is loaded
		assertPageIsLoaded( taxCategoryDetail );
	}
	
}