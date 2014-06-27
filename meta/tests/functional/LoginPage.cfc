component extends="PageObject"{
	
	variables.title = "Login | Slatwall";
	
	function login(username, password) {
		logout();
		selenium.type("emailAddress", username);
		selenium.type("password", password);
		selenium.submit("adminLoginForm");
		var waited = waitFor();
		writeLog("Login took #waited# ms to load");
		return new Dashboard(selenium);
	}
	
	function logout(){
		if(selenium.getTitle() neq getTitle()){
			selenium.open("?slatAction=main.logout");
			waitFor();
		}
	}
}