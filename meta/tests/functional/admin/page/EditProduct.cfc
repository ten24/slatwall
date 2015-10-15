component extends="PageObject" {
	
	variables.slatAction = "entity.editproduct";
	
	public any function init(selenium, pageLoadTime) {
		variables.title = selenium.getTitle();
		
		return super.init(argumentCollection=arguments);
	}

}