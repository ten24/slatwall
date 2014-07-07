component extends="PageObject" {
	
	variables.slatAction = "entity.detailtaxcategoryrate";
	
	public any function init(selenium, pageLoadTime) {
		variables.title = selenium.getTitle();
		
		return super.init(argumentCollection=arguments);
	}
	
	public any function clickDeleteLink() {
		selenium.click('link=Delete');
		
		selenium.click('id=confirmYesLink');
		
		var pageLoadTime = waitForPageToLoad();
		
		return new DetailTaxCategoryRate(selenium, pageLoadTime);
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