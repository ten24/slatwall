component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiController" {
    property name="vibeService";
    property name="publicService";
    
   	property name="fw";


	this.publicMethods = "";


	this.secureMethods="";


	public any function init(required any fw){
		setFW(arguments.fw);
		return this;
	}

    public any function before(required struct rc){
        arguments.rc.ajaxRequest = true;
        arguments.rc.ajaxResponse = {};
    }
    
    public void function authenticate(required struct rc){
        
        
    }
    
    public void function after( required struct rc ) {
		if(structKeyExists(arguments.rc, "fRedirectURL") && arrayLen(getHibachiScope().getFailureActions())) {
				getFW().redirectExact( redirectLocation=arguments.rc.fRedirectURL );
		} else if (structKeyExists(arguments.rc, "sRedirectURL") && !arrayLen(getHibachiScope().getFailureActions())) {
				getFW().redirectExact( redirectLocation=arguments.rc.sRedirectURL );
		} else if (structKeyExists(arguments.rc, "redirectURL")) {
				getFW().redirectExact( redirectLocation=arguments.rc.redirectURL );
		}
	}

    
}