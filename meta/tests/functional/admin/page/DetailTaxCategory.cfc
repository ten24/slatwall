component extends="PageObject" {
	
	variables.slatAction = "entity.detailtaxcategory";
	
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
		selenium.click('//*[@id="tabrates"]/div/div/button');
		
		selenium.waitForElementPresent("//a[@title='#subMenuLink#']");
		
		selenium.click("//a[@title='#subMenuLink#']");
		
		selenium.waitForElementPresent("//*[@id='adminentitysavetaxcategoryrate']/div[1]/h3");
		
		return new CreateTaxCategoryRate( selenium );
	}
	
	public function deleteTaxCategoryRate(){
		selenium.click(getButton_DeleteTaxCategoryRate());
		var pageLoadTime = selenium.waitForElementPresent('//*[@id="adminConfirm"]');
		selenium.click('//*[@id="confirmYesLink"]');
		
		return new DetailTaxCategory( selenium, pageLoadTime );
	}
	
	public any function editTaxCategoryRateTaxAddressLookup( struct formData={} ) {
		selenium.click(getButton_EditTaxCategoryRate());
		selenium.waitForElementPresent('//*[@id="adminentitysavetaxcategoryrate"]');
		
		
		//Dynamically choose the select options based on the current iteration
		if(arguments.formData['taxCategoryRateCode'] == 'ShipToBillTest'){
			var taxAddressLookupSelectOption = 'Shipping -> Billing';
			var taxAddressZoneSelectOption = 'San Diego Test';
		} else if(arguments.formData['taxCategoryRateCode'] == 'BillToShipTest') {
			var taxAddressLookupSelectOption = 'Billing -> Shipping';
			var taxAddressZoneSelectOption = 'New York Test';
		}
		
		//Set the selct boxes
		selenium.select(getSelectBox_TaxAddressLookup(), taxAddressLookupSelectOption);
		selenium.select(getSelectBox_TaxAddressZone(), taxAddressZoneSelectOption);
		
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
	public any function getButton_DeleteTaxCategoryRate() {
		return '//*[@id="adminentitydeletetaxcategoryrate"]';
	}
	public any function getButton_EditTaxCategoryRate() {
		return '//*[@id="adminentityedittaxcategoryrate_8a8080834721af1a01473639e11a0217"]';
	}
	
	public any function getSelectBox_TaxAddressLookup() {
		return '//*[@id="adminentitysavetaxcategoryrate"]/div[2]/div/div/fieldset/div[1]/div/select';
	}
	public any function getSelectBox_TaxAddressZone() {
		return '//*[@id="adminentitysavetaxcategoryrate"]/div[2]/div/div/fieldset/div[3]/div/select';
	}
	
}