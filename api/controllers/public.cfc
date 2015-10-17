component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiController"{
	
	property name="fw" type="any";
	property name="hibachiService" type="any";
	property name="hibachiUtilityService" type="any";
	
	this.publicMethods='';
	this.publicMethods=listAppend(this.publicMethods, 'get');
	this.publicMethods=listAppend(this.publicMethods, 'post');
	this.publicMethods=listAppend(this.publicMethods, 'put');
	this.publicMethods=listAppend(this.publicMethods, 'delete');
	
	public void function init( required any fw ) {
		setFW( arguments.fw );
	}
	
	public any function before( required struct rc ) {
		getFW().setView("public:main.blank");
		arguments.rc.requestHeaderData = getHTTPRequestData();
		param name="rc.headers.contentType" default="application/json"; 
		arguments.rc.headers["Content-Type"] = rc.headers.contentType;
		
	}
	
	public any function get( required struct rc ) {
		var publicService = getService('PublicService');
	    if (structKeyExists(arguments.rc, "context") && arguments.rc.context == "getProcessObjectDefinition"){
            publicService.getProcessObjectDefinition(rc);
        }else if ( structKeyExists(arguments.rc, "context") && arguments.rc.url contains "getCart"){
			publicService.invokeMethod("getCartData", {rc=arguments.rc});
		}else if ( structKeyExists(arguments.rc, "context") && arguments.rc.url contains "getAccount"){
            publicService.invokeMethod("getAccountData", {rc=arguments.rc});
        }else{
			publicService.invokeMethod("getPublicContexts", {rc=arguments.rc});
		}
	}
	
	public any function post( required struct rc ) {
		param name="arguments.rc.context" default="save";
        var publicService = getService('PublicService');
		
		if(arguments.rc.context == "get" && arguments.rc.url contains "process"){
			rc.context = "getProcessObjectDefinition";
			this.get(rc);
		}else if (arguments.rc.context != "get" && arguments.rc.url contains "process"){
			publicService.doProcess(rc);
		}else if (arguments.rc.url contains "getCart"){
        	rc.context = "getCartData";
        	this.get(rc);
        }else if(arguments.rc.url contains "getAccount"){
        	rc.context = "getAccountData";
            this.get(rc);
        }else if ( StructKeyExists(arguments.rc, "context") && rc.context != "get"){
            publicService.invokeMethod("#arguments.rc.context#", {rc=arguments.rc});
        }else{
            this.get(rc);
        }
	}
}
