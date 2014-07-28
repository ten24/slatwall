component extends="PageObject" {
	
	variables.slatAction = "entity.editintegrations";
	variables.locators = {
		activeFlagYes = '//*[@id="adminentitysaveintegration"]/div[2]/div/fieldset/div/div/label[1]/input',
		saveButton = '//*[@id="adminentitysaveintegration"]/div[1]/div/div[2]/div/div[2]/button'
	};
	
	public any function init(selenium, pageLoadTime) {
		variables.title = selenium.getTitle();
		
		return super.init(argumentCollection=arguments);
	}
	
}