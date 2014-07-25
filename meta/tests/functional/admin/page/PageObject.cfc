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
	
	function populateForm( struct formData={} ) {
		for(var key in arguments.formData) {
			selenium.type( key, arguments.formData[key] );
			selenium.keyUp( key, ' ' );
			/*
			for(var i=1; i<=len(arguments.formData[key]); i++) {
				chr = mid( arguments.formData[key], i, 1 );
				
				selenium.keyDown( key,  mid( arguments.formData[key], i, 1 ) );
				selenium.keyUp( key,  mid( arguments.formData[key], i, 1 ) );
			}
    		*/
		}	
	}
	
	function submitForm( required string formID, struct formData={} ) {
		populateForm(arguments.formData);
		selenium.submit(arguments.formID);
	}
	
	function isLoaded(){
		if(selenium.getTitle() eq getTitle() && selenium.isElementPresent("global-search")){
			return true;
		} else {
			return false;
		}
	}
	
	public string function getLocator( required string locatorName ) {
		if(!structKeyExists(variables.locators, arguments.locatorName)) {
			throw("There is no locator defined in your page object called: #arguments.locatorName#")
		}
		return variables.locators[ arguments.locatorName ];
	}
	
	public string function getLocatorText( required string locatorName ) {
		return selenium.getText( getLocator(arguments.locatorName) );
	}
	
	public string function getLocatorValue( required string locatorName ) {
		return selenium.getValue( getLocator( arguments.locatorName ) );
	}
	
	public any function clickLocator( required string locatorName ) {
		return selenium.click( getLocator(arguments.locatorName) );
	}
	
	public any function mousedownLocator( required string locatorName ) {
		return selenium.mousedown( getLocator(arguments.locatorName) );
	}
	
	public any function waitForLocator( required string locatorName ) {
		return selenium.waitForElementPresent( getLocator(arguments.locatorName) );
	}
	
	public any function clickLocatorWaitLocator( required string locatorName, required string elementLocatorName ) {
		clickLocator( arguments.locatorName );
		return waitForLocator( arguments.elementLocatorName );
	}
	
	public any function isLocatorPresent( required string locatorName ) {
		return selenium.isElementPresent( getLocator(arguments.locatorName) );
	}
}
