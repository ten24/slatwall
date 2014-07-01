component extends="PageObject"{
	
	variables.title = "Login | Slatwall";
	
	function login(username, password) {
		logout();
		selenium.type("emailAddress", username);
		selenium.type("password", password);
		selenium.submit("adminLoginForm");
		
		var pageLoadTime = waitFor();
		
		return new Dashboard(selenium, pageLoadTime);
	}
	
	function logout(){
		if(selenium.getTitle() neq getTitle()){
			selenium.open("?slatAction=main.logout");
			waitFor();
		}
	}
}