component extends="AdminTestBase" {
	
	//Tests FW1 Integrations Do Not Appear On Navbar once logged out
	public function fw1IntegrationsUponLogoutTest(){
		
		//Activate Mura
		var EditIntegration = openPage('?slatAction=entity.editintegration&integrationID=8a8080834721af1a01474cb5c94e109a', 'EditIntegration');
		assertPageIsLoaded(EditIntegration);
		EditIntegration.clickLocator( 'activeFlagYes' );
		EditIntegration.clickLocator( 'saveButton' );
		waitForPageToLoad();
		
		var DetailIntegration = selenium.refresh();
		
		//Go to Dashboard to logOut
		var Dashboard = openPage( '', 'Dashboard' );
		assertPageIsLoaded(Dashboard);
		
		Dashboard.clickLocatorWaitLocator('logoutMenuIcon', 'logoutDropdownMenu');
		Dashboard.clickLocator('logoutOption');
		
		//Log back in and turn off Mura
		var Login = openPage( '?slatAction=main.logout', 'Login' );
		assertPageIsLoaded(Login);
		
		//Var the result of whether or not the unwanted elements are present
		var integrationDropdownMenuPresentBooleanWithMuraActive = selenium.isElementPresent('//html/body/div[1]/div/div/ul/li[2]/a');
		var muraPicturePresentBooleanWithMuraActive = selenium.isElementPresent('//html/body/div[1]/div/div/a[2]/img');
		
		//*************************
		//Need to work on how to   
		//get accountauthentication
		//*************************
		var Dashboard = Login.login('testRunner@testRunner.com', 'testrunner');
		assertPageIsLoaded(Dashboard);
		
		var EditIntegration = openPage('?slatAction=entity.editintegration&integrationID=8a8080834721af1a01474cb5c94e109a', 'EditIntegration');
		assertPageIsLoaded(EditIntegration);
		EditIntegration.clickLocator( 'activeFlagNo' );
		EditIntegration.clickLocator( 'saveButton' );
		waitForPageToLoad();
		
		var DetailIntegration = selenium.refresh();
		
		//Go to Dashboard to logOut
		var Dashboard = openPage( '', 'Dashboard' );
		assertPageIsLoaded(Dashboard);
		
		Dashboard.clickLocatorWaitLocator('logoutMenuIcon', 'logoutDropdownMenu');
		Dashboard.clickLocator('logoutOption');
		
		//Log back in and turn off Mura
		var Login = openPage( '?slatAction=main.logout', 'Login' );
		assertPageIsLoaded(Login);
		
		//Var the result of whether or not the unwanted elements are present
		var integrationDropdownMenuPresentBooleanWithoutMuraActive = selenium.isElementPresent('//html/body/div[1]/div/div/ul/li[2]/a');
		var muraPicturePresentBooleanWithoutMuraActive = selenium.isElementPresent('//html/body/div[1]/div/div/a[2]/img');
		
		//Assertions without Mura being Active
		assertFalse(integrationDropdownMenuPresentBooleanWithoutMuraActive);
		assertFalse(muraPicturePresentBooleanWithoutMuraActive);
		
		//Assertions with Mura being Active
		assertFalse(integrationDropdownMenuPresentBooleanWithMuraActive);
		assertFalse(muraPicturePresentBooleanWithMuraActive);
		
	}

}