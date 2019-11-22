component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiController" {
    property name="publicService";
    property name="vibeService";
    property name="accountService";
    property name="hibachiEventService";

   	property name="fw";


	this.publicMethods = "authenticate";
	
	//TODO remove for development-testing only
	this.publicMethods &= ",dumpRequest";
	this.publicMethods &= ",announceTestEvent";


	this.secureMethods="";


	public any function init(required any fw){
		setFW(arguments.fw);
		return this;
	}

    public any function before( required struct rc ) {
        arguments.rc['redirectURL'] = 'https://google.com?abcd=123&pqr=xy'; //setting default-redirect url
    }

    public void function authenticate(required struct rc){
        
        if(getHibachiScope().getLoggedInFlag()){
        	getAccountService().processAccount( getHibachiScope().getAccount(), arguments.rc, 'logout' );
        }	
        
		getAccountService().processAccount(getHibachiScope().getAccount(), arguments.rc, "login");
		

		if(getHibachiScope().getLoggedInFlag()) {
			
			if(structKeyExists(arguments.rc, "sRedirectURL")) {
				arguments.rc.redirectURL = arguments.rc.sRedirectURL;
			}
			
			arguments.rc.redirectURL = getVibeService().appendVibeQueryParamsToURL(arguments.rc.redirectURL, getHibachiScope().getAccount());
			
		} else if(structKeyExists(arguments.rc, "fRedirectURL")) {
			arguments.rc.redirectURL = arguments.rc.fRedirectURL;
		}
	
    }
    
    //TODO remove for development-testing only
    public void function dumpRequest(required struct rc) {
    	dump(arguments.rc);
    	abort;
    }
    
    //TODO remove for development-testing only
	public void function announceTestEvent(required struct rc) {
		var account = getAccountService().getAccount(arguments.rc.accountID);
		
    	getHibachiEventService().announceEvent( 
    		eventName = "afterInfotraxAccountCreateSuccess", 
    		eventData = {
    			'entity' = account 
	    		} 
    		);
    	
    	getVibeService().push(account);
    	
    	dump(account.getAccountID()); abort;
    	// arguments.rc['redirectURL'] = "http://monat:8906/Slatwall/index.cfm?slatAction=vibe:main.dumpRequest&eventAnnouncedFor=#arguments.rc.accountID#";
	}
    
    
    public void function after(required struct rc){
			// getFW().redirectExact(arguments.rc.redirectURL); //not working if not logged-in
		location(arguments.rc.redirectURL);  //TODO: remove for testing only
	}
}