component extends="PageObject" {
	
	variables.slatAction = "entity.editorder";
	
	public any function init(selenium, pageLoadTime) {
		variables.title = selenium.getTitle();
		
		return super.init(argumentCollection=arguments);
	}
	
	public any function addItemToOrder( struct formData={} ) {
		selenium.click(addItemToOrderAddButton());
		
		selenium.waitForElementPresent(addItemToOrderAddButtonModal());
		
		selenium.select('shippingAddress.stateCode','value=CA');
		submitForm('adminentityprocessorder_addorderitem', arguments.formData);
		
		var pageLoadTime = waitForPageToLoad();

		return new EditOrder(selenium, pageLoadTime);
	}
	
	public function deleteOrder(){
		
		selenium.click(deleteOrderButtonLocator());
		
		selenium.waitForElementPresent('//*[@id="adminConfirm"]');
		
		selenium.click(deleteOrderConfirmYesLink());
		
		var pageLoadTime = waitForPageToLoad();
		
		return new ListCartsAndQuotes(selenium, pageLoadTime);	
	}
	
	public function saveOrder(){
		
		selenium.click('//*[@id="adminentitysaveorder"]/div[1]/div/div[2]/div/div[4]/button');

		var pageLoadTime = waitForPageToLoad();
		
		return new DetailOrder(selenium, pageLoadTime);
		
	}

	//============ Page Specific Locators ================
	
	public any function deleteOrderButtonLocator(){
		return '//*[@id="adminentitysaveorder"]/div[1]/div/div[2]/div/div[4]/a[1]';
	}
	
	public any function deleteOrderConfirmYesLink(){
		return '//*[@id="confirmYesLink"]';
	}
	
	public any function addItemToOrderAddButton(){
		return '//*[@id="adminentityprocessorder_8a8080834721af1a0147220714810083"]';
	}
	public any function addItemToOrderAddButtonModal(){
		return '//*[@id="adminentityprocessorder_addorderitem"]';
	}
}