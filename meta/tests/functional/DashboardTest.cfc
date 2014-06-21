component extends="Slatwall.meta.tests.functional.SlatwallFunctionalTestBase" {

	function beforeTests(){
		//Dashboard is set in the superclass
		super.beforeTests();
		menuItems = flattenMenuItems(Dashboard.getMenuItems());
		
	}
	
	private function flattenMenuItems(menuItems){
		var items = [];
		for(var menu in menuItems){
			for(var item in menuItems[menu]){
				arrayAppend(items, {menu=menu, link=item});
			}
		}
		return items;
	}
	
	function menu_test(){
		var productsPage = Dashboard.openProductsMenu();
		assertPageIsLoaded(productsPage);
	}
	
	/**
	* @mxunit:dataprovider menuItems
	*/
	function simple_menu_link_check(menu){
		var page = Dashboard.openMenuLink(menu.menu, menu.link);
		assertPageIsLoaded(page);
	}
	
	
	
}