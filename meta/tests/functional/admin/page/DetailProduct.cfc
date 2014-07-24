component extends="PageObject" {
	
	variables.slatAction = "entity.detailproduct";
	variables.locators = {
		addSkuButton = 			'//*[@id="tabskus"]/div/a[@title="Add Sku"]',
		addSkuModal = 			'//*[@id="adminentityprocessproduct_addsku"]',
		deleteProductButton = 	'link=Delete',
		deleteConfirmYes = 		'//*[@id="confirmYesLink"]',
		addOptionGroupButton = 	'//*[@id="tabskus"]/div/a[@title="Add Option Group"]',
		addOptionGroupModal = 	'//*[@id="adminentityprocessproduct_addoptiongroup"]',
		addOptionGroupSelect = 	'//*[@id="adminentityprocessproduct_addoptiongroup"]/div[2]/div/div/fieldset/div/div/select',
		addOptionGroupOption = 	'//*[@id="adminentityprocessproduct_addoptiongroup"]/div[3]/div/button'
		
	};

	public any function init(selenium, pageLoadTime) {
		variables.title = selenium.getTitle();
		
		return super.init(argumentCollection=arguments);
	}
	
	public any function addOptionGroup(){
		selenium.click(variables.locators['addOptionGroupButton']);
		
		selenium.waitForElementPresent(variables.locators['addOptionGroupModal']);
		selenium.select(variables.locators['addOptionGroupSelect'], 'Test Runner Option Group');
		
		selenium.click(variables.locators['addOptionGroupOption']);
		
		var loadTime = waitForPageToLoad();
		
		return new DetailProduct(selenium, loadTime);
		
	}
	
	public any function deleteProduct(){

		selenium.click(variables.locators['deleteProductButton']);
		
		selenium.waitForElementPresent('//*[@id="adminConfirm"]');

		selenium.click(variables.locators['deleteConfirmYes']);
		
		var pageLoadTime = waitForPageToLoad();
		
		return new ListProducts(selenium, pageLoadTime);	
	}
	
	
	public any function addSku( struct formData={} ){
		
		selenium.click(variables.locators['addSkuButton']);
		selenium.waitForElementPresent(variables.locators['addSkuModal']);
		
		submitForm( 'adminentityprocessproduct_addsku', arguments.formData );
		
		var loadTime = waitForPageToLoad();
		
		return new DetailProduct(selenium, loadTime);
		
	}
	
	public boolean function isAddSkuButtonPresent(){
		var assertBoolean = selenium.isElementPresent( variables.locators['addSkuButton'] );
		return assertBoolean;
	}
	
	public boolean function isAddOptionGroupButtonPresent(){
		var assertBoolean = selenium.isElementPresent( variables.locators['addOptionGroupButton'] );
		return assertBoolean;
	}
	
	public any function setupSkuSettingTaxCategory( required string){
	
		selenium.click('//*[@id="tabskusettings"]/div/table/tbody/tr[18]/td[4]/a');
		
		selenium.waitForElementPresent('//*[@id="adminentitysavesetting"]');
		
		selenium.select('//*[@id="adminentitysavesetting"]/div[2]/div/div/fieldset/select', arguments.string);
		
		selenium.click('//*[@id="adminentitysavesetting"]/div[3]/div/button');
		
	}
	
}