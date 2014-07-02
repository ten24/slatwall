component {
	
	variables.title = "UNDEFINED";
	variables.pageLoadTime = 0;
	
	function init(selenium, pageLoadTime){
		variables.selenium = arguments.selenium;
		if(structKeyExists(arguments, "pageLoadTime")) {
			variables.pageLoadTime = arguments.pageLoadTime;	
		}
		
		return this;
	}
	
	function getTitle(){
		return variables.title;
	}
	
	function getPageLoadTime(){
		return variables.loadTime;
	}
	
	function waitForPageToLoad(time=10000) {
		
		var start = getTickCount();
		
		variables.selenium.waitForPageToLoad(time);
		
		return getTickCount() - start;
	}
	
	function submitForm( required string formID, struct formData={} ) {
		for(var key in arguments.formData) {
			selenium.type( key, arguments.formData[key] );
		}
		selenium.submit(arguments.formID);
	}
	
	function isLoaded(){
		if(selenium.getTitle() eq getTitle() && selenium.isElementPresent("global-search")){
			return true;
		} else {
			return false;
		}
	}
}
