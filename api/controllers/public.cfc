component accessors="true" extends="Slatwall.org.Hibachi.HibachiController"{

    property name="fw" type="any";
    property name="hibachiService" type="any";
    property name="hibachiUtilityService" type="any";
    property name="publicService" type="any";

    this.publicMethods='';
    this.publicMethods=ListAppend(this.publicMethods, 'get');
    this.publicMethods=ListAppend(this.publicMethods, 'post');
    
    this.publicMethods=ListAppend(this.publicMethods, 'getOrderTemplates');
    this.publicMethods=ListAppend(this.publicMethods, 'getOrderTemplateItems');
    this.publicMethods=ListAppend(this.publicMethods, 'getOrderTemplateDetails');
    
    this.publicMethods=ListAppend(this.publicMethods, 'getWishlistItems');
    
    this.publicMethods=ListAppend(this.publicMethods, 'editOrderTemplate');
    this.publicMethods=ListAppend(this.publicMethods, 'activateOrderTemplate');
    this.publicMethods=ListAppend(this.publicMethods, 'cancelOrderTemplate');
    this.publicMethods=ListAppend(this.publicMethods, 'deleteOrderTemplate');
    
    this.publicMethods=ListAppend(this.publicMethods, 'updateOrderTemplateShipping');
    this.publicMethods=ListAppend(this.publicMethods, 'updateOrderTemplateBilling');
    this.publicMethods=ListAppend(this.publicMethods, 'updateOrderTemplateShippingAndBilling');
    this.publicMethods=ListAppend(this.publicMethods, 'updateOrderTemplateSchedule');
    this.publicMethods=ListAppend(this.publicMethods, 'updateOrderTemplateFrequency');
    this.publicMethods=ListAppend(this.publicMethods, 'getAccountGiftCards');
    this.publicMethods=ListAppend(this.publicMethods, 'getAccountAddresses');
    this.publicMethods=ListAppend(this.publicMethods, 'getAccountPaymentMethods');
    this.publicMethods=ListAppend(this.publicMethods, 'applyGiftCardToOrderTemplate');
    this.publicMethods=ListAppend(this.publicMethods, 'getOrderTemplatePromotionSkuCollectionConfig');
    this.publicMethods=ListAppend(this.publicMethods, 'getOrderTemplatePromotionSkus');

    this.publicMethods=ListAppend(this.publicMethods, 'addOrderTemplateItem');
    this.publicMethods=ListAppend(this.publicMethods, 'editOrderTemplateItem');
    this.publicMethods=ListAppend(this.publicMethods, 'removeOrderTemplateItem');
    
    //get-xxx-options
    this.publicMethods=ListAppend(this.publicMethods, 'getOptions');
    this.publicMethods=ListAppend(this.publicMethods, 'getFrequencyTermOptions');
    this.publicMethods=ListAppend(this.publicMethods, 'getFrequencyDateOptions');
    this.publicMethods=ListAppend(this.publicMethods, 'getOrderTemplateShippingMethodOptions');
    this.publicMethods=ListAppend(this.publicMethods, 'getCancellationReasonTypeOptions');
    this.publicMethods=ListAppend(this.publicMethods, 'getScheduleDateChangeReasonTypeOptions');
    this.publicMethods=ListAppend(this.publicMethods, 'getExpirationMonthOptions');
    this.publicMethods=ListAppend(this.publicMethods, 'getExpirationYearOptions');
    this.publicMethods=ListAppend(this.publicMethods, 'getStateCodeOptionsByCountryCode');
    
    

    
    
    
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
        
    }

    public any function get( required struct rc ) {
        var publicService = getService('PublicService');

        if ( structKeyExists(arguments.rc, "context") ) {
            
            if ( arguments.rc.context == "getCart"){
                publicService.invokeMethod("getCartData", {data=arguments.rc});
            }else if ( arguments.rc.context == "getAccount"){
                publicService.invokeMethod("getAccountData", {data=arguments.rc});
            }else if (  rc.context != "get"){
                publicService.invokeMethod("#arguments.rc.context#", {data=arguments.rc});
            }
            
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
                publicService.invokeMethod( "#arguments.rc.context#", {data=arguments.rc} );
            } else {
                
                //iterate through all the actions calling the method.
                for (var eachAction in actions){
                    //Make sure there are no errors if we have multiple.
                    if ( 
                        !arguments.rc.$["#getDao('hibachiDao').getApplicationValue('applicationKey')#"].cart().hasErrors() && 
                        !arguments.rc.$["#getDao('hibachiDao').getApplicationValue('applicationKey')#"].account().hasErrors()
                    ){
                        getHibachiScope().flushORMSession();
                        publicService.invokeMethod("#eachAction#", {data=arguments['rc']});
                    } else {
                        return; //return here to push errors to the form that errored.
                    }
                }
            }
        }else{
            this.get(rc);
        }
    }
    
    public any function getStateCodeOptionsByCountryCode( required struct rc ){
		getPublicService().getStateCodeOptionsByCountryCode(arguments.rc); 
	} 
	
	public any function getAccountAddresses( required struct rc ){
		getPublicService().getAccountAddresses(arguments.rc); 
	} 
	
	public any function getAccountPaymentMethods( required struct rc ){
		getPublicService().getAccountPaymentMethods(arguments.rc); 
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
	
	
	public any function updateOrderTemplateShippingAndBilling( required struct rc ){
		getPublicService().updateOrderTemplateShippingAndBilling(arguments.rc); 
	} 
	
	public any function updateOrderTemplateShipping( required struct rc ){
		getPublicService().updateOrderTemplateShipping(arguments.rc); 
	} 
	
	public any function updateOrderTemplateBilling(required struct rc){
	    getPublicService().updateOrderTemplateBilling(arguments.rc);
	}
	
	public any function editOrderTemplate( required struct rc ){
		getPublicService().editOrderTemplate(arguments.rc); 
	}
	
	public any function activateOrderTemplate( required struct rc ){
		getPublicService().activateOrderTemplate(arguments.rc); 
	} 
	
	public any function cancelOrderTemplate( required struct rc ){
		getPublicService().cancelOrderTemplate(arguments.rc); 
	} 
	
	public any function deleteOrderTemplate( required struct rc ){
		getPublicService().deleteOrderTemplate(arguments.rc); 
	} 
	
	
	public any function updateOrderTemplateSchedule( required struct rc ){
		getPublicService().updateOrderTemplateSchedule(arguments.rc); 
	} 
	
	public any function updateOrderTemplateFrequency( required struct rc ){
		getPublicService().updateOrderTemplateFrequency(arguments.rc); 
	} 
	
	public any function getAccountGiftCards( required struct rc ){
		getPublicService().getAccountGiftCards(arguments.rc); 
	} 
	
	public any function applyGiftCardToOrderTemplate( required struct rc ){
		getPublicService().applyGiftCardToOrderTemplate(arguments.rc); 
	} 
	
	public any function getOrderTemplatePromotionSkuCollectionConfig( required struct rc ){
		getPublicService().getOrderTemplatePromotionSkuCollectionConfig(arguments.rc); 
	} 
	
	public any function getOrderTemplatePromotionSkus( required struct rc ){
		getPublicService().getOrderTemplatePromotionSkus(arguments.rc); 
	} 
	
	
    public any function addOrderTemplateItem( required struct rc ){
		getPublicService().addOrderTemplateItem(arguments.rc); 
	}
	
	public any function editOrderTemplateItem( required struct rc ){
		getPublicService().editOrderTemplateItem(arguments.rc); 
	}
	
	public any function removeOrderTemplateItem( required struct rc ){
		getPublicService().removeOrderTemplateItem(arguments.rc); 
	}
	
	
	
	/// . ############# .     cart .   ################
	
	
	public any function addOrderItem(required struct rc) {
	    getPublicService().addOrderItem(arguments.rc);
	}
	
	public any function removeOrderItem(required struct rc) {
	    getPublicService().removeOrderItem(arguments.rc);
	}
	
	public any function updateOrderItemQuantity(required struct rc) {
	    getPublicService().updateOrderItemQuantity(arguments.rc);
	}
	
	public any function selectStarterPackBundle(required struct rc) {
	    getPublicService().selectStarterPackBundle(arguments.rc);
	}
	
	
	//////////////////////////////////////////////
	
	
	
	///    ############### .  getXXXOptions();  .  ###############   
    
    /**
     *  rc.optionsList = "op1,op2,op3"; 
    */ 
    public void function getOptions(required any rc){
        getPublicService().getOptions(arguments.rc);
    }
    
    public void function getFrequencyTermOptions(required any rc) {
        getPublicService().getFrequencyTermOptions(arguments.rc);
	}

    public void function getFrequencyDateOptions(required any data) {
		getPublicService().getFrequencyDateOptions(arguments.rc);
    }
    
    public void function getSiteOrderTemplateShippingMethodOptions(required any rc) {
        getPublicService().getSiteOrderTemplateShippingMethodOptions(arguments.rc);
	}
    
    public void function getCancellationReasonTypeOptions(required any rc) {
        getPublicService().getCancellationReasonTypeOptions(arguments.rc);
	}
    
    public void function getScheduleDateChangeReasonTypeOptions(required any rc) {
        getPublicService().getScheduleDateChangeReasonTypeOptions(arguments.rc);
	}
    
    public void function getExpirationMonthOptions(required any rc) {
        getPublicService().getExpirationMonthOptions(arguments.rc);
	}
    
    public void function getExpirationYearOptions(required any rc) {
        getPublicService().getExpirationYearOptions(arguments.rc);
	}
	

}
