component extends="PageObject" {
	
	public any function init(selenium, pageLoadTime) {
		variables.title = selenium.getTitle();
		
		return super.init(argumentCollection=arguments);
	}
	
	public any function delete() {
		selenium.click('link=Delete');
		
		selenium.click('id=confirmYesLink');
		
		var pageLoadTime = waitForPageToLoad();
		
		return new ListTaxCategories(selenium, pageLoadTime);
	}
}