component extends="PageObject"{
	
	variables.slatAction = "main.login";
	variables.title = "Login | Slatwall";
	
	function login(username, password) {
		logout();
		selenium.type("emailAddress", username);
		selenium.type("password", password);
		selenium.submit("adminLoginForm");
		
		var pageLoadTime = waitForPageToLoad();
		
		return new Dashboard(selenium, pageLoadTime);
	}
	
	function logout(){
		if(selenium.getTitle() neq getTitle()){
			selenium.open("?slatAction=main.logout");
			waitForPageToLoad();
		}
	}
}