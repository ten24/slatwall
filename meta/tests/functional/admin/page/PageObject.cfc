component {
	
	variables.title = "UNDEFINED";
	variables.slatAction = "UNDEFINED";
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
	
	function getSlatAction(){
		return variables.slatAction;
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
	
	function getLocator( required string locatorName ) {
		if(!structKeyExists(variables.locators, arguments.locatorName)) {
			throw("There is no locator defined in your page object called: #arguments.locatorName#")
		}
		return variables.locators[ arguments.locator ];
	}
	
	function getLocatorText( required string locatorName ) {
		return selenium.getText( getLocator(arguments.locatorName) );
	}
	
	function clickLocator( required string locatorName ) {
		selenium.click( getLocator(arguments.locatorName) );
	}
	
	function waitForLocator( required string locatorName ) {
		var start = getTickCount();
		selenium.waitForElementPresent( getLocator(arguments.locatorName) );
		return getTickCount() - start;
	}
	
	function clickLocatorWaitLocator( required string locatorName, required string elementLocatorName ) {
		clickLocator( arguments.locatorName );
		waitForLocator( arguments.elementLocatorName );
	}
}
