component accessors="true" extends="Slatwall.org.Hibachi.HibachiController"{

    property name="fw" type="any";
    property name="hibachiService" type="any";
    property name="hibachiUtilityService" type="any";
    property name="publicService" type="any";

    this.publicMethods='';
    this.publicMethods=listAppend(this.publicMethods, 'get');
    this.publicMethods=listAppend(this.publicMethods, 'getOrderTemplates');
    this.publicMethods=listAppend(this.publicMethods, 'getOrderTemplateItems');
    this.publicMethods=listAppend(this.publicMethods, 'getOrderTemplateDetails');
    
    this.publicMethods=listAppend(this.publicMethods, 'getWishlistItems');
    
    this.publicMethods=listAppend(this.publicMethods, 'activateOrderTemplate');
    this.publicMethods=listAppend(this.publicMethods, 'cancelOrderTemplate');
    this.publicMethods=listAppend(this.publicMethods, 'updateOrderTemplateShipping');
    this.publicMethods=listAppend(this.publicMethods, 'updateOrderTemplateBilling');
    this.publicMethods=listAppend(this.publicMethods, 'updateOrderTemplateSchedule');
    this.publicMethods=listAppend(this.publicMethods, 'updateOrderTemplateFrequency');
    
    
    this.publicMethods=listAppend(this.publicMethods, 'post');

    public void function init( required any fw ) {
        setFW( arguments.fw );
    }

    public any function before( required struct rc ) {
        getFW().setView("public:main.blank");
        arguments.rc.requestHeaderData = getHTTPRequestData();
        arguments.rc['ajaxRequest'] = true;
        arguments.rc.headers["Content-Type"] = 'application/json';
        request.layout = false;
        if ( arguments.rc.jsonRequest == true && structKeyExists( arguments.rc, 'deserializedJSONData') ){
           	structAppend(arguments.rc, arguments.rc.deserializedJSONData);
        }
        
        if(structKeyExists(arguments.rc,'cmsSiteID')){
            getHibachiScope().setCurrentRequestSite(getService('siteService').getSiteByCMSSiteID(arguments.rc.cmsSiteID));
            getHibachiScope().setCurrentRequestSitePathType('cmsSiteID');
        }
        //if we have a get request there is nothing to persist because nothing changed
        if(
            structKeyExists(arguments.rc,'context') 
            && len(arguments.rc.context) >= 3 
            && left(arguments.rc.context,3) == 'GET'
        ){
            getHibachiScope().setPersistSessionFlag(false);
        }
    }

    public any function get( required struct rc ) {
        var publicService = getService('PublicService');
        if ( structKeyExists(arguments.rc, "context") && arguments.rc.context == "getCart"){
            publicService.invokeMethod("getCartData", {data=arguments.rc});
        }else if ( structKeyExists(arguments.rc, "context") && arguments.rc.context == "getAccount"){
            publicService.invokeMethod("getAccountData", {data=arguments.rc});
        }else if ( StructKeyExists(arguments.rc, "context") && rc.context != "get"){
            publicService.invokeMethod("#arguments.rc.context#", {data=arguments.rc});
        }
    }

    public any function post( required struct rc ) {
        param name="arguments.rc.context" default="save";
        var publicService = getService('PublicService');

        if (arguments.rc.context != "get" && arguments.rc.context == "process"){
            publicService.doProcess(rc);
        }else if (arguments.rc.context == "getCart"){
            rc.context = "getCartData";
            this.get(rc);
        }else if(arguments.rc.context == "getAccount"){
            rc.context = "getAccountData";
            this.get(rc);
        }else if ( StructKeyExists(arguments.rc, "context") && rc.context != "get"){
            
            var actions = [];
            if (arguments.rc.context contains ","){
                actions = listToArray(arguments.rc.context);
            }
            if (!arrayLen(actions)){
                publicService.invokeMethod(
                    "#arguments.rc.context#", 
                    {data=arguments.rc}
                );
            }else{
                //iterate through all the actions calling the method.
                for (var eachAction in actions){
                    //Make sure there are no errors if we have multiple.
                    if (!arguments.rc.$["#getDao('hibachiDao').getApplicationValue('applicationKey')#"].cart().hasErrors() && !arguments.rc.$["#getDao('hibachiDao').getApplicationValue('applicationKey')#"].account().hasErrors()){
                          getHibachiScope().flushORMSession();
                          publicService.invokeMethod("#eachAction#", {data=arguments['rc']});
                    }else{
                        return; //return here to push errors to the form that errored.
                    }
                }
            }
        }else{
            this.get(rc);
        }
    }

	public any function getOrderTemplates( required struct rc ){
		getPublicService().getOrderTemplates(arguments.rc); 
	} 

	public any function getOrderTemplateItems( required struct rc ){
		getPublicService().getOrderTemplateItems(arguments.rc); 
	} 
	
	public any function getOrderTemplateDetails( required struct rc ){
		getPublicService().getOrderTemplateDetails(arguments.rc); 
	}	

	public any function getWishlistItems( required struct rc ){
		getPublicService().getWishlistItems(arguments.rc); 
	} 
	
	public any function updateOrderTemplateShipping( required struct rc ){
		getPublicService().updateOrderTemplateShipping(arguments.rc); 
	} 
	
	public any function updateOrderTemplateBilling(required struct rc){
	    getPublicService().updateOrderTemplateBilling(arguments.rc);
	}
	
	public any function activateOrderTemplate( required struct rc ){
		getPublicService().activateOrderTemplate(arguments.rc); 
	} 
	
	public any function cancelOrderTemplate( required struct rc ){
		getPublicService().cancelOrderTemplate(arguments.rc); 
	} 
	
	public any function updateOrderTemplateSchedule( required struct rc ){
		getPublicService().updateOrderTemplateSchedule(arguments.rc); 
	} 
	
	public any function updateOrderTemplateFrequency( required struct rc ){
		getPublicService().updateOrderTemplateFrequency(arguments.rc); 
	} 
	

}
