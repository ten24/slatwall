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
		selenium.click("//*[contains(@class, 'adminentitydeletetaxcategoryrate btn btn-mini alert-confirm')]");
		selenium.click('//*[@id="confirmYesLink"]');
	}
	
	// =============== GET TEXT =======================
	
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