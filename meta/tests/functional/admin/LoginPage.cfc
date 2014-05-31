component extends="PageObject"{
	
	variables.title = "Login | Slatwall";
	
	function login(username, password) {
		logout();
		selenium.type("emailAddress", username);
		selenium.type("password", password);
		selenium.submit("adminLoginForm");
		selenium.waitForPageToLoad(30000);
		return new Dashboard(selenium);
	}
	
	function logout(){
		if(selenium.getTitle() neq getTitle()){
			selenium.open("?slatAction=main.logout");
			selenium.waitForPageToLoad(30000);
		}
	}
}