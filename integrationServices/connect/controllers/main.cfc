/**
 * TODO: remove this file,  required for development time testing only
 */ 
component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiController" {
    property name="connectService";
    property name="accountService";
    property name="hibachiEventService";

   	property name="fw";

	//TODO remove for development-testing only
	this.publicMethods &= ",announceTestEvent";

	this.secureMethods="";


	public any function init(required any fw){
		setFW(arguments.fw);
		return this;
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
    	
    	getConnectService().push(account);
    	
    	dump(account.getAccountID()); abort;
	}
    
}