component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiController" {

    property name="vibeService";
    property name="accountService";

   	property name="fw";


	this.publicMethods = "authenticate";
	
	this.secureMethods = "goToVibe";

	public any function init(required any fw){
		setFW(arguments.fw);
		return this;
	}

    public any function before( required struct rc ) {
        arguments.rc['redirectURL'] = getVibeService().setting('defaultRedirectURL'); 
    }
    
    public void function goToVibe(required struct rc){
        
        if(getHibachiScope().getLoggedInFlag()){
	        
	        if(structKeyExists(arguments.rc, "sRedirectURL")) {
				arguments.rc.redirectURL = arguments.rc.sRedirectURL;
			}

			arguments.rc.redirectURL = getVibeService().appendVibeQueryParamsToURL(arguments.rc.redirectURL, getHibachiScope().getAccount());
		} 
		else if( structKeyExists(arguments.rc, "fRedirectURL") ) {
			arguments.rc.redirectURL = arguments.rc.fRedirectURL;
		}
		
		getHibachiScope().endHibachiLifecycle();
    	//NOTE: we can't use redirect exact as it would match the url exactly (inclusing query params) with a whitelist domain, and we can't know that 
		location(arguments.rc.redirectURL); //this skips fw's lifecycle
		
    }

    public void function authenticate(required struct rc){
        
        if(getHibachiScope().getLoggedInFlag()){
        	getAccountService().processAccount( getHibachiScope().getAccount(), arguments.rc, 'logout' );
        }	
        
		getAccountService().processAccount(getHibachiScope().getAccount(), arguments.rc, "login");

		this.goToVibe(argumentcollection = arguments);
    }
    
}