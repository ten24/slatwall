component extends="PageObject" {
	
	variables.slatAction = "entity.edittaxcategoryrate";
	
	public any function init(selenium, pageLoadTime) {
		variables.title = selenium.getTitle();
		
		return super.init(argumentCollection=arguments);
	}
	
	public any function submitSaveForm( struct formData={} ) {
		submitForm( 'adminentitysavetaxcategory', arguments.formData );
		
		var pageLoadTime = waitForPageToLoad();
		
		return new DetailTaxCategoryRate(selenium, pageLoadTime);
	}
}