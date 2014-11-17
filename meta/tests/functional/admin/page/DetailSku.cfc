component extends="PageObject" {
	
	variables.slatAction = "entity.detailsku";
	
	public any function init(selenium, pageLoadTime) {
		variables.title = selenium.getTitle();
		
		return super.init(argumentCollection=arguments);
	}
	
	public function deleteSku(){
		selenium.click('link=Delete');
		
		selenium.waitForElementPresent('//*[@id="adminConfirm"]');
		
		selenium.click(deleteConfirmLink());
		
		var pageLoadTime = waitForPageToLoad();
		
		return new ListSkus(selenium, pageLoadTime);	
	}
	
	//=============== Page Specific Locators ==========
	
	private any function deleteConfirmLink(){
		return '//*[@id="confirmYesLink"]';
	}
	
}