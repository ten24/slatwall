component extends="PageObject" {
	
	variables.slatAction = "entity.detailtaxcategoryrate";
	
	public any function init(selenium, pageLoadTime) {
		variables.title = selenium.getTitle();
		
		return super.init(argumentCollection=arguments);
	}
	
	public any function clickDeleteLink() {
		selenium.click('//*[@id="4028810a4644ca6d0147116c6d330fd9"]/td[4]/a[3]/i');
		
		selenium.waitForElementPresent('//*[@id="adminConfirm"]');
		
		selenium.click('id=confirmYesLink');
		
		return new DetailTaxCategory(selenium, pageLoadTime);
	}
	
	public any function clickEditLink() {
		selenium.click("link=Edit");
		
		var loadTime = waitForPageToLoad();
		
		return new EditTaxCategoryRate(selenium, loadTime);
	}
	
	// =============== GET TEXT =======================
	
	public any function getText_ManualRate() {
		return selenium.getText('xpath=//*[@id="tabrates"]/div/div/ul/li[2]/a');
	}
	

}