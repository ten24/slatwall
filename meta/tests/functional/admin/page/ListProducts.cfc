component extends="PageObject" {
	
	variables.slatAction = "entity.listproduct";
	variables.title = "Products | Slatwall";
	variables.locators = {
		createButton 				= '//*[@id="productID"]/thead/tr[1]/th/div[2]/div/div[2]/button',
		createProductDropdown 		= '//*[@id="productID"]/thead/tr[1]/th/div[2]/div/div[2]/ul',
		createMerchProductOption	= '//*[@id="productID"]/thead/tr[1]/th/div[2]/div/div[2]/ul/li[2]/a'
	};
	
	public any function openCreateMerchandiseProduct(){
		selenium.click(variables.locators['createButton']);
		selenium.waitForElementPresent(variables.locators['createProductDropdown']);
		selenium.click(variables.locators['createMerchProductOption']);
		var loadTime = waitForPageToLoad();
		return new CreateProduct(selenium, loadTime);
	}
	
}