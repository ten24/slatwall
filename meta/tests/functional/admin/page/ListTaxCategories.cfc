component extends="PageObject" {
	
	variables.title = "Tax Categories | Slatwall";
	
	public any function openCreateTaxCategoryLink() {
		selenium.click("link=Add Tax Category");
		
		var loadTime = waitForPageToLoad();
		
		return new CreateTaxCategory(selenium, loadTime);
	};
}