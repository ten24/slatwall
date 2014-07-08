component extends="PageObject" {
	
	variables.slatAction = "entity.editorder";
	
	public any function init(selenium, pageLoadTime) {
		variables.title = selenium.getTitle();
		
		return super.init(argumentCollection=arguments);
	}
	
	public any function addItemToOrder( struct formData={} ) {
		selenium.click('//*[@id="4028810a4644ca6d0147118080e41002"]/td[11]/a');
		
		selenium.waitForElementPresent('//*[@id="adminentityprocessorder_addorderitem"]');
		
		selenium.select('shippingAddress.stateCode','value=CA');
		submitForm('adminentityprocessorder_addorderitem', arguments.formData);
		
		var pageLoadTime = waitForPageToLoad();

		return new EditOrder(selenium, pageLoadTime);
	}
	
	public function deleteOrder(){
		selenium.click('//*[@id="adminentitysaveorder"]/div[1]/div/div[2]/div/div[4]/a[1]');
		selenium.click('//*[@id="confirmYesLink"]');
	}
}