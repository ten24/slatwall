component extends="Slatwall.meta.tests.functional.SlatwallFunctionalTestBase" {

	function valid_credentials_login(){
		var dashboard = Login.login("t@ten24web.com", "uitest01");
		assertEquals(Dashboard.getTitle(), selenium.getTitle());
		assertPageIsLoaded(dashboard);
	}
	
	
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
	
	/**
	* @mxunit:dataprovider invalidLogins
	*/
	function invalid_credentials_all_fail(credentials){
		var dashboard = Login.login(credentials.u, credentials.p);
		assertPageIsLoaded(Login);
	}
	
	//example of how to take a screenshot; only works on firefox
	private function screenshotTest(){
		var path = expandPath("screenshot.png");
		debug(path);
		selenium.captureEntirePageScreenshot(path, "");
	}
	
	
}