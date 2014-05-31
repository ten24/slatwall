component extends="Slatwall.meta.tests.functional.SlatwallFunctionalTestBase" {

	//basic version
	function invalid_credentials_fail(){
		Login.login("foo", "bar");
		assertEquals(Login.getTitle(), selenium.getTitle());
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
	
	//supercharged
	/**
	*
	* @mxunit:dataprovider invalidLogins
	*/
	function invalid_credentials_all_fail(credentials){
		var dashboard = Login.login(credentials.u, credentials.p);
		assertPageIsLoaded(Login);
//		assertEquals(Login.getTitle(), selenium.getTitle());
//		assertFalse(Dashboard.isLoaded());
	}
	
	function valid_credentials_login(){
		var dashboard = Login.login("uitest@ten24web.com", "uitest01");
		assertEquals(Dashboard.getTitle(), selenium.getTitle());
		assertPageIsLoaded(dashboard);
	}
	
	
}