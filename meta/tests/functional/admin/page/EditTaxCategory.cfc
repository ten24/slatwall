component extends="PageObject" {
	
	variables.slatAction = "entity.edittaxcategory";
	
	public any function init(selenium, pageLoadTime) {
		variables.title = selenium.getTitle();
		
		return super.init(argumentCollection=arguments);
	}
	
	public any function submitSaveForm( struct formData={} ) {
		submitForm( 'adminentitysavetaxcategory', arguments.formData );
		
		var pageLoadTime = waitForPageToLoad();
		
		return new DetailTaxCategory(selenium, pageLoadTime);
	}
	
	public function turnOffActiveFlag(){
		selenium.click(activeFlagNOButton());
		
		selenium.click('//*[@id="adminentitysavetaxcategory"]/div[1]/div/div[2]/div/div[3]/button');
		
		var loadTime = waitForPageToLoad();
		
		return new DetailTaxCategory(selenium, loadTime);
	}
	
	public function turnONActiveFlag(){
		selenium.click(activeFlagYesButton());
		
		selenium.click('//*[@id="adminentitysavetaxcategory"]/div[1]/div/div[2]/div/div[3]/button');
		
		var loadTime = waitForPageToLoad();
		
		return new DetailTaxCategory(selenium, loadTime);
	}
	
	
	
	//================= ===================
	public any function activeFlagNOButton(){
		return '//*[@id="adminentitysavetaxcategory"]/div[2]/div/fieldset/div[1]/div/label[2]/input';
	}
	public any function activeFlagYESButton(){
		return '//*[@id="adminentitysavetaxcategory"]/div[2]/div/fieldset/div[1]/div/label[1]/input';
	}
}

