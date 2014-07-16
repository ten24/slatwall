component extends="PageObject" {
	
	variables.slatAction = "entity.detailproduct";
	
	public any function init(selenium, pageLoadTime) {
		variables.title = selenium.getTitle();
		
		return super.init(argumentCollection=arguments);
	}
	
	public any function addOptionGroup(){
		selenium.click(addOptionGroupButton());
		
		selenium.waitForElementPresent(addOptionGroupButton_ModalXPath());
		selenium.select(addOptionGroupButton_SelectBoxXpath(), 'Test Runner Option Group');
		
		selenium.click(addOptionGroupButton_ModalAddOptionGroupButton());
		
		var loadTime = waitForPageToLoad();
		
		return new DetailProduct(selenium, loadTime);
		
	}
	
	//=============== Page Specific Locators ==========
	
	private any function addOptionGroupButton(){
		return '//*[@id="tabskus"]/div/a[2]';
	}
	
	private any function addOptionGroupButton_ModalXPath(){
		return '//*[@id="adminentityprocessproduct_addoptiongroup"]';
	}
	private any function addOptionGroupButton_SelectBoxXpath(){
		return '//*[@id="adminentityprocessproduct_addoptiongroup"]/div[2]/div/div/fieldset/div/div/select';
	}
	private any function addOptionGroupButton_ModalAddOptionGroupButton(){
		return '//*[@id="adminentityprocessproduct_addoptiongroup"]/div[3]/div/button';
	}
	
}