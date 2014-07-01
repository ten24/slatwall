component extends="PageObject"{
	
	variables.title = "Dashboard | Slatwall";
	
	variables.menuItems = {
		"Products" = {
			"Products" = "ListProducts", 
			"Product Types" = "ListProductTypes",
			"Brands" = "ListBrands",
			"Skus" = "ListSkus",
			"Product Reviews" = "ListProductReviews",
			"Option Groups" = "ListOptionGroups"
		},
		"Orders" = {
			"Orders" = "ListOrders", 
			"Carts & Quotes" = "ListCartsAndQuotes"
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
	
	function openMenuLink(menu, menuLinkTitle){
		selenium.click("link=#menu#");
		//We wait here to avoid any problems with selenium moving faster than the browser
		selenium.waitForElementPresent("//a[@title='#menuLinkTitle#']");
		selenium.click("//a[@title='#menuLinkTitle#']"); 
		var loadTime = waitFor();
		return pageObjectFor(menu, menuLinkTitle, loadTime);
	}
	
	function pageObjectFor(menu, menuLinkTitle, loadTime){
		var pageObject = variables.menuItems[menu][menuLinkTitle];
		return createObject(pageObject).init(selenium, loadTime);
	}
}