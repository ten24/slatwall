component extends="AdminTestBase" {
	
	//Tests FW1 Integrations Do Not Appear On Navbar once logged out
	public function fw1IntegrationsUponLogoutTest(){
		
		//Activate Mura
		var EditIntegration = openPage('?slatAction=entity.editintegration&integrationID=8a8080834721af1a01474cb5c94e109a', 'EditIntegration');
		assertPageIsLoaded(EditIntegration);
		EditIntegration.clickLocator( 'activeFlagYes' );
		EditIntegration.clickLocator( 'saveButton' );
		waitForPageToLoad();
		
		var DetailIntegration = refresh();
		
		//Go to Dashboard to logOut
		var Dashboard = openPage( '', 'Dashboard' );
		assertPageIsLoaded(Dashboard);
		
		Dashboard.clickLocatorWaitLocator('logoutMenuIcon', 'logoutDropdownMenu');
		Dashboard.clickLocator('logoutOption');
		
		//Log back in and turn off Mura
		var Login = openPage( '?slatAction=main.logout', 'Login' );
		assertPageIsLoaded(Login);
		
		//Var the result of whether or not the unwanted elements are present
		var integrationDropdownMenuPresentBooleanWithMuraActive = Login.isLocatorPresent( 'integrationsDropdown' );
		var muraPicturePresentBooleanWithMuraActive = Login.isLocatorPresent( 'muraImage' );
		
		//Log back in to undo 
		var Dashboard = Login.login('testRunner@testRunner.com', 'testrunner');
		assertPageIsLoaded(Dashboard);
		
		var EditIntegration = openPage('?slatAction=entity.editintegration&integrationID=8a8080834721af1a01474cb5c94e109a', 'EditIntegration');
		assertPageIsLoaded(EditIntegration);
		EditIntegration.clickLocator( 'activeFlagNo' );
		EditIntegration.clickLocator( 'saveButton' );
		waitForPageToLoad();
		
		var DetailIntegration = refresh();
		
		//Go to Dashboard to logOut
		var Dashboard = openPage( '', 'Dashboard' );
		assertPageIsLoaded(Dashboard);
		
		Dashboard.clickLocatorWaitLocator('logoutMenuIcon', 'logoutDropdownMenu');
		Dashboard.clickLocator('logoutOption');
		
		//Log back in and turn off Mura
		var Login = openPage( '?slatAction=main.logout', 'Login' );
		assertPageIsLoaded(Login);
		
		//Var the result of the same elements to test if they are present without the integration activated
		var integrationDropdownMenuPresentBooleanWithoutMuraActive = Login.isLocatorPresent( 'integrationsDropdown' );
		var muraPicturePresentBooleanWithoutMuraActive = Login.isLocatorPresent( 'muraImage' );
		
		//Assertions without Mura being Active
		assertFalse(integrationDropdownMenuPresentBooleanWithoutMuraActive);
		assertFalse(muraPicturePresentBooleanWithoutMuraActive);
		
		//Assertions with Mura being Active
		assertFalse(integrationDropdownMenuPresentBooleanWithMuraActive);
		assertFalse(muraPicturePresentBooleanWithMuraActive);
		
	}

}