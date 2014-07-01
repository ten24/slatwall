component extends="AdminTestBase" {

	function taxCategoryCreateAndDeleteWorks() {
		// Load Listing Page
		var taxCategoryList = variables.dashboardPage.openMenuLink("Config", "Tax Categories");
		
		assertPageIsLoaded( taxCategoryList );
		
		// Load Create Page
		var taxCategoryCreate = taxCategoryList.openCreateTaxCategoryLink();
		
		assertPageIsLoaded( taxCategoryCreate );
		
		formData = {};
		formData['taxCategoryName'] = "My Tax Category Name";
		formData['taxCategoryCode'] = "TEST-#getTickCount()#";
		
		taxCategoryDetail = taxCategoryCreate.submitCreateForm(formData);
		
		assertEquals( "My Tax Category Name | Slatwall", taxCategoryDetail.getTitle() );
		
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
	
	function taxCategoryEditandSaveWorks(){
		
		// Load Listing Page
		var taxCategoryList = variables.dashboardPage.openMenuLink("Config", "Tax Categories");
		
		assertPageIsLoaded( taxCategoryList );
		
		// Load Create Page
		var taxCategoryCreate = taxCategoryList.openCreateTaxCategoryLink();
		
		assertPageIsLoaded( taxCategoryCreate );
		//Sets Up Form Data for Creation
		formData = {};
		formData['taxCategoryName'] = "Edit Tax Category Test Name";
		formData['taxCategoryCode'] = "TEST-#getTickCount()#";
		
		taxCategoryDetail = taxCategoryCreate.submitCreateForm(formData);
		
		assertEquals( "Edit Tax Category Test Name | Slatwall", taxCategoryDetail.getTitle() );
		//Tests Edit Button
		var taxCategoryEdit = taxCategoryDetail.edit();
		
		assertPageIsLoaded( taxCategoryEdit );		
		//Sets Up New Form Data
		formData['taxCategoryName'] = "Edit Tax Category Test Name Number 2";
		formData['taxCategoryCode'] = "TEST-#getTickCount()#";
		//Saves new form Data
		taxCategoryDetail = taxCategoryEdit.submitEditForm(formData);
		
		//Asserts New Data is present
		assertEquals( "Edit Tax Category Test Name Number 2 | Slatwall", taxCategoryDetail.getTitle() );
		
		//Deletes Test Category
		taxCategoryList = taxCategoryDetail.delete();
		
		assertPageIsLoaded( taxCategoryList );
		
	}

	
}