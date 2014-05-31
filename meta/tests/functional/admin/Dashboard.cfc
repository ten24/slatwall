component {
	
	function init(selenium){
		structAppend(variables, arguments);
	}
	
	function getTitle(){
		return "Dashboard | Slatwall";
	}
	
	function isLoaded(){
		if(selenium.getTitle() eq getTitle() && selenium.isElementPresent("global-search")){
			return true;
		} else {
			writeLog("We don't appear to be on the dashboard page. Current title is #selenium.getTitle()#");
			return false;
		}
	}
}