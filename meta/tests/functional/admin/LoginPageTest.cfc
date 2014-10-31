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
	
	/**
	* @mxunit:dataprovider invalidLogins
	*/
	function invalid_credentials_all_fail(credentials){
		variables.loginPage.login(credentials.u, credentials.p);
		
		assertEquals( "Login", selenium.getText('//html/body/div[3]/div/div/div/div/h3') );
	}
	
	/*
	function valid_credentials_login(){
		var dashboard = variables.Login.login('testrunner@ten24web.com', 'testrunner');
		assertEquals(Dashboard.getTitle(), selenium.getTitle());
	}
	*/	
}