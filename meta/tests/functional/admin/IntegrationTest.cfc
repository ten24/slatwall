component extends="AdminTestBase" {
	
	//Tests FW1 Integrations Do Not Appear On Navbar once logged out
	public function fw1IntegrationsUponLogoutTest(){
		var ListIntegrations = openPage('?slatAction=entity.listintegration', 'ListIntegration');
		assertPageIsLoaded( ListIntegrations );
		
		ListIntegrations.clickLocator(variables.locators['pageTwoButton']);
		waitForPageToLoad();
		var EditIntegration = ListIntegrations.clickLocator(variables.locators['muraEditButton']);
		assertPageIsLoaded(EditIntegration);
		
		EditIntegration.clickLocator(variables.locators['activeFlagYes']);
		var DetailIntegration = EditIntegration.clickLocator(variables.locators['saveButton']);
		assertPageIsLoaded(DetailIntegration);
		
	}

}