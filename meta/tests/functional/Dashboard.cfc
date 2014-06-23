component extends="PageObject"{
	
	variables.title = "Dashboard | Slatwall";
	
	variables.menuItems = {
		"Products" = {
			"Products" = "ProductsPage", 
			"Product Types" = "ProductTypesPage"
		}
	};
	
	function getMenuItems(){
		return variables.menuItems;
	}
	
	function isLoaded(){
		if(selenium.getTitle() eq getTitle() && selenium.isElementPresent("global-search")){
			return true;
		} else {
			writeLog("We don't appear to be on the dashboard page. Current title is #selenium.getTitle()#");
			return false;
		}
	}
	
	function openMenuLink(menu, linkName){
		selenium.click("link=#menu#");
		//We wait here to avoid any problems with selenium moving faster than the browser
		selenium.waitForElementPresent("//a[@title='#linkName#']");
		selenium.click("//a[@title='#linkName#']"); 
		waitFor();
		return pageObjectFor(menu, linkName);
	}
	
	function openProductsMenu(){
		return openMenuLink("Products", "Products");
	}
	
	function pageObjectFor(menu, linkName){
		var pageObject = variables.menuItems[menu][linkName];
		return createObject(pageObject).init(selenium);
	}
}