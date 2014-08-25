component extends="PageObject"{
	
	variables.slatAction = "main.login";
	variables.title = "Login | Slatwall";
	variables.locators = {
		integrationsDropdown = '//html/body/div[1]/div/div/ul/li[2]/a',
		muraImage 			 = '//html/body/div[1]/div/div/a[2]/img'
	};
	
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