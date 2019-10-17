component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiController" {
    property name="vibeService";
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
        	getHibachiScope().getAccount().logout();
        }	
        
		getAccountService().processAccount(getHibachiScope().getAccount(), arguments.rc, "login");
		rc.redirectURL = 'http://google.com';

		if(getHibachiScope().getLoggedInFlag()) {
			if(structKeyExists(rc, "sRedirectURL")) {
				rc.redirectURL = rc.sRedirectURL;
			}
			//append the payload to the url
			
		}
		getFW().redirectExact(rc.redirectURL); 
    }
    
    
}