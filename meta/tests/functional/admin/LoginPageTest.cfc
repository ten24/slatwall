component extends="AdminTestBase" {

	invalidLogins = [
		{u:"", p:""},
		{u:"foo", p:""},
		{u:"", p:"bar"},
		{u:"foo", p:"foo"},
		{u:"foo", p:"askdfja;lkadskfl$$$$---1111!!!!!&^%$@"},
		{u:"foo", p:"; drop table users"},
		{u:"foo", p:"<img src='' onerror='alert()'>"},
		{u:"<img src='' onerror='alert()'>", p:"<script>alert('pwnd')</script>"}
	];

	/*
	function valid_credentials_login(){
		var dashboard = variables.Login.login('testrunner@ten24web.com', 'testrunner');
		assertEquals(Dashboard.getTitle(), selenium.getTitle());
	}
	*/
	
	/**
	* @mxunit:dataprovider invalidLogins
	*/
	function invalid_credentials_all_fail(credentials){
		var potentialDashboard = variables.loginPage.login(credentials.u, credentials.p);
		
		// Make sure that the loginPage is still loaded, because we should have been bounced back there
		assertPageIsLoaded(variables.loginPage);
	}
	
	//example of how to take a screenshot; only works on firefox
	/*
	private function screenshotTest(){
		var path = expandPath("screenshot.png");
		
		selenium.captureEntirePageScreenshot(path, "");
	}
	*/
	
}