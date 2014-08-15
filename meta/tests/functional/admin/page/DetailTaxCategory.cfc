component extends="PageObject" {
	
	variables.slatAction = "entity.detailtaxcategory";
	variables.locators = {
		deleteTaxCategoryButton 	= 'link=Delete',
		editTaxRateButton 			= '//*[@id="adminentityedittaxcategoryrate_1cbafa6037ca457ca23aaf76242c5e50"]',
		editTaxRateElement 			= '//*[@id="adminentitysavetaxcategoryrate"]',
		addTaxCategoryRateButton 	= '//*[@id="tabrates"]/div/div/button',
		taxAddressLUSelect 			= '//*[@id="adminentitysavetaxcategoryrate"]/div[2]/div/div/fieldset/div[1]/div/select',
		taxAddressZoneSelect		= '//*[@id="adminentitysavetaxcategoryrate"]/div[2]/div/div/fieldset/div[3]/div/select',
		adminConfirmModal			= '//*[@id="adminConfirm"]',
		adminConfirmYes				= '//*[@id="confirmYesLink"]'
	};
	
	public any function init(selenium, pageLoadTime) {
		variables.title = selenium.getTitle();
		
		return super.init(argumentCollection=arguments);
	}
	
	public any function clickDeleteLink() {
		selenium.click('link=Delete');
		
		selenium.click('id=confirmYesLink');
		
		var pageLoadTime = waitForPageToLoad();
		
		return new ListTaxCategories(selenium, pageLoadTime);
	}
	
	public any function clickEditLink() {
		selenium.click("link=Edit");
		
		var loadTime = waitForPageToLoad();
		
		return new EditTaxCategory(selenium, loadTime);
	}
	
	public any function clickAddTaxCategoryRateDropdownLink( required string subMenuLink ){
		selenium.click(variables.locators['addTaxCategoryRateButton']);
		
		selenium.waitForElementPresent("//a[@title='#subMenuLink#']");
		
		selenium.click("//a[@title='#subMenuLink#']");
		
		selenium.waitForElementPresent("//*[@id='adminentitysavetaxcategoryrate']/div[1]/h3");
		
		return new CreateTaxCategoryRate( selenium );
	}
	
	public function deleteTaxCategory(){
		selenium.click( variables.locators['deleteTaxCategoryButton'] );
		selenium.waitForElementPresent( variables.locators['adminConfirmModal'] );
		selenium.click( variables.locators['adminConfirmYes'] );
		var pageLoadTime = waitForPageToLoad();
		return new DetailTaxCategory( selenium, pageLoadTime );
	}
	
	public any function editTaxCategoryRateTaxAddressLookup( struct formData={} ) {
		selenium.click(variables.locators['editTaxRateButton']);
		selenium.waitForElementPresent(variables.locators['editTaxRateElement']);
		
		
		//Dynamically choose the select options based on the current iteration
		if(arguments.formData['taxCategoryRateCode'] == 'ShipToBillTest'){
			var taxAddressLookupSelectOption = 'Shipping -> Billing';
			var taxAddressZoneSelectOption = 'San Diego Test';
		} else if(arguments.formData['taxCategoryRateCode'] == 'BillToShipTest') {
			var taxAddressLookupSelectOption = 'Billing -> Shipping';
			var taxAddressZoneSelectOption = 'New York Test';
		}
		
		//Set the selct boxes
		selenium.select(variables.locators['taxAddressLUSelect'], taxAddressLookupSelectOption);
		selenium.select(variables.locators['taxAddressZoneSelect'], taxAddressZoneSelectOption);
		submitForm( 'adminentitysavetaxcategoryrate', arguments.formData );
		
		var pageLoadTime = waitForPageToLoad();
		
		return new DetailTaxCategory(selenium, pageLoadTime);
	}
	

	// =============== Page Specific Locators =======================
	
	public any function getText_ActiveFlag() {
		return selenium.getText("xpath=//html/body/div[3]/div/div/div[3]/div/dl/dd[1]");
	}
	
	public any function getText_TaxCategoryName() {
		return selenium.getText("xpath=//html/body/div[3]/div/div/div[3]/div/dl/dd[2]");
	}
	
	public any function getText_TaxCategoryCode() {
		return selenium.getText("xpath=//html/body/div[3]/div/div/div[3]/div/dl/dd[3]");
	}


	
}