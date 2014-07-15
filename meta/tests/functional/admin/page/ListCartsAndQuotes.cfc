component extends="PageObject" {
	
	variables.slatAction = "entity.listcartandquote";
	variables.title = "Carts & Quotes | Slatwall";
	
	public any function clickCreateOrderLink() {
		selenium.click("link=Create Order");
		
		selenium.waitForElementPresent(createOrderModalLocator());
		
		selenium.click(radioButtonValueNo());
		
		selenium.waitForElementPresent(createOrderModalLocator());
		
		selenium.type(accountIDAutoCompleteSearchField(), 'test');
		selenium.typeKeys(accountIDAutoCompleteSearchField(), 'test');
		
		selenium.waitForElementPresent(testAccountAutoCompleteOption());
		
		selenium.mouseDown(testAccountAutoCompleteOption());
		
		selenium.click(createOrderSubmitButton());
		
		var loadTime = waitForPageToLoad();
		
		return new EditOrder(selenium, loadTime);
		
	}
	
	//============ Page Specific Locators ================
	public any function createOrderModalLocator(){
		return '//*[@id="adminentityprocessorder_create"]';
	}
	public any function radioButtonValueNo(){
		return '//*[@id="adminentityprocessorder_create"]/div[2]/div/div/fieldset/div[1]/div/label[2]/input';
	}
	public any function accountIDAutoCompleteSearchField(){
		return 'accountID-autocompletesearch';
	}
	public any function testAccountAutoCompleteOption(){
		return '//*[@id="suggestionoption4028810a471d4864014720bc661e0037"]';
	}
	public any function createOrderSubmitButton(){
		return '//*[@id="adminentityprocessorder_create"]/div[3]/div/button';
	}
	
}