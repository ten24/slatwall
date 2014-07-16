component extends="PageObject" {
	
	variables.slatAction = "entity.settings";
	variables.title = "Config | Settings";
	
	public any function setupSkuSettingTaxCategory(){
	
		selenium.click('//*[@id="tabsku"]/div/table/tbody/tr[18]/td[3]/a');

		selenium.waitForElementPresent('//*[@id="adminentitysavesetting"]/div[2]/div/div/fieldset/select');

		selenium.click('//*[@id="adminentitysavesetting"]/div[3]/div/button');
		
	}

}