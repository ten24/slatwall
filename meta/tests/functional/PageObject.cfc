component {
	
	variables.title = "UNDEFINED";
	
	function init(selenium){
		variables.selenium = arguments.selenium;
		return this;
	}
	
	function getTitle(){
		return variables.title;
	}
	
	function waitFor(time=10000) {
		var start = getTickCount();
		selenium.waitForPageToLoad(time);
		return getTickCount() - start;
	}
	
	function isLoaded(){
		if(selenium.getTitle() eq getTitle() && selenium.isElementPresent("global-search")){
			return true;
		} else {
			writeLog("We don't appear to be on the Expected page. Expected page title #variables.title# but on #selenium.getTitle()#");
			return false;
		}
	}
}