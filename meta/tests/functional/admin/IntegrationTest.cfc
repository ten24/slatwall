component extends="AdminTestBase" {
	/*
	//Tests FW1 Integrations/Mura Icon Do Not Appear On Navbar once logged out
	public function fw1IntegrationsUponLogoutTest(){
		
		turnMuraOffAndOn( 'activeFlagYes' );

		//Log back in and turn off Mura
		var Login = openPage( '?slatAction=main.logout', 'Login' );
		assertPageIsLoaded(Login);
		
		//Var the result of whether or not the unwanted elements are present
		var integrationDropdownMenuPresentBooleanWithMuraActive = Login.isLocatorPresent( 'integrationsDropdown' );
		var muraPicturePresentBooleanWithMuraActive = Login.isLocatorPresent( 'muraImage' );
		
		//Log back in to undo 
		var Dashboard = Login.login('testRunner@testRunner.com', 'testrunner');
		assertPageIsLoaded(Dashboard);
		
		turnMuraOffAndOn( 'activeFlagNo' );

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
	
	private function turnMuraOffAndOn( required locator ){
		var EditIntegration = openPage('?slatAction=entity.editintegration&integrationID=8a8080834721af1a01474cb5c94e109a', 'EditIntegration');
		assertPageIsLoaded(EditIntegration);
		EditIntegration.clickLocator( arguments.locator );
		EditIntegration.clickLocator( 'saveButton' );
		waitForPageToLoad();
	}
	*/

}