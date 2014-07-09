component extends="PageObject" {
	
	variables.slatAction = "entity.listtaxcategory";
	variables.title = "Tax Categories | Slatwall";
	
	public any function clickCreateTaxCategoryLink() {
		selenium.click("link=Add Tax Category");
		
		var loadTime = waitForPageToLoad();
		
		return new CreateTaxCategory(selenium, loadTime);
	}
}