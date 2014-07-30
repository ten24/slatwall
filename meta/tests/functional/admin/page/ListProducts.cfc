component extends="PageObject" {
	
	variables.slatAction = "entity.listproduct";
	variables.title = "Products | Slatwall";
	variables.locators = {
		createButton 				= '//*[@title="Merchandise Product"]'
	};
	
	public any function openCreateMerchandiseProduct(){
		selenium.click(variables.locators['createButton']);
		var loadTime = waitForPageToLoad();
		return new CreateProduct(selenium, loadTime);
	}
}