component extends="AdminTestBase" {

	function beforeTests(){
		// variables.dashboardPage is set in the superclass
		super.beforeTests();
		
		variables.menuItems = flattenMenuItems( variables.dashboardPage.getMenuItems() );
	}
	
	/**
	* @mxunit:dataprovider menuItems
	*/
	function all_top_level_menu_items_render( menuItem ){
		var page = variables.dashboardPage.openMenuLink(arguments.menuItem.menu, arguments.menuItem.menuLinkTitle);	
		assertPageIsLoaded( page, "Unable to navigate to: #arguments.menuItem.menu# > #arguments.menuItem.menuLinkTitle#" );
	}
	
	// ================ Private Helpers ======================
	
	private function flattenMenuItems( menuItems ){
		var items = [];
		for(var menu in menuItems){
			for(var item in menuItems[menu]){
				arrayAppend(items, {menu=menu, menuLinkTitle=item});
			}
		}
		return items;
	}
}