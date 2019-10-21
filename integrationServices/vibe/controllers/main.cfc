component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiController" {
    property name="vibeService";
    property name="accountService";
    property name="publicService";

   	property name="fw";


	this.publicMethods = "authenticate";


	this.secureMethods="";


	public any function init(required any fw){
		setFW(arguments.fw);
		return this;
	}

    public void function authenticate(required struct rc){
        
        if(getHibachiScope().getLoggedInFlag()){
        	getAccountService().processAccount( getHibachiScope().getAccount(), arguments.rc, 'logout' );
        }	
        
		getAccountService().processAccount(getHibachiScope().getAccount(), arguments.rc, "login");
		
		arguments.rc.redirectURL = 'https://google.com?abcd&pqr=xy'; //setting default-redirect url

		if(getHibachiScope().getLoggedInFlag()) {
			
			if(structKeyExists(arguments.rc, "sRedirectURL")) {
				arguments.rc.redirectURL = arguments.rc.sRedirectURL;
			}
			
			arguments.rc.redirectURL = getVibeService().appendVibeQueryParamsToURL(arguments.rc.redirectURL);
			
		} else if(structKeyExists(arguments.rc, "fRedirectURL")) {
			arguments.rc.redirectURL = arguments.rc.fRedirectURL;
		}
		// getFW().redirectExact(arguments.rc.redirectURL); //not working if not logged-in
		location(arguments.rc.redirectURL);  //TODO: remove for testing only
    }
    
    public void function dumpRequest(required struct rc) {
    	dump(arguments.rc);
    }
    
    
}