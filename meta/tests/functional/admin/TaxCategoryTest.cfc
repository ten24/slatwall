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

	
}