component accessors="true" extends="Slatwall.org.Hibachi.HibachiController"{

    property name="fw" type="any";
    property name="publicService" type="any";
    property name="hibachiService" type="any";
    property name="hibachiUtilityService" type="any";

    this.publicMethods='';
    this.publicMethods=listAppend(this.publicMethods, 'get');
    this.publicMethods=listAppend(this.publicMethods, 'post');

    public void function init( required any fw ) {
        setFW( arguments.fw );
    }

    public any function before( required struct rc ) {
        getFW().setView("public:main.blank");
        arguments.rc.requestHeaderData = getHTTPRequestData();
        arguments.rc['ajaxRequest'] = true;
        param name="rc.headers.contentType" default="application/json";
        arguments.rc.headers["Content-Type"] = rc.headers.contentType;
    }

    public any function get( required struct rc ) {
        param name="arguments.rc.propertyIdentifiers" defualt="";

        // If the request is specifically just asking for cart data
        if ( structKeyExists(arguments.rc, "context") && listFindNoCase("cart,getCart,getCartData", arguments.rc.context) ){

            arguments.rc.ajaxResponse = getHibachiScope().getCartData( arguments.rc.propertyIdentifiers );

        // If the request is specifically just asking for account data
        } else if ( structKeyExists(arguments.rc, "context") && listFindNoCase("account,getAccount,getAccountData", arguments.rc.context) ){

            arguments.rc.ajaxResponse = getHibachiScope().getAccountData( arguments.rc.propertyIdentifiers );

        // If the context was just 'get' or it wasn't defined, then we return the contents of this hibachiScope
        } else if ( !structKeyExists(arguments.rc, "context") OR (structKeyExists(arguments.rc, "context") && rc.context == "get") ){

            arguments.rc.ajaxResponse['account'] = getHibachiScope().getAccountData( arguments.rc.propertyIdentifiers );
            arguments.rc.ajaxResponse['cart'] = getHibachiScope().getCartData( arguments.rc.propertyIdentifiers );
            arguments.rc.ajaxResponse['loggedInFlag'] = getHibachiScope().getLoggedInFlag();
            arguments.rc.ajaxResponse['loggedInAsAdminFlag'] = getHibachiScope().getLoggedInAsAdminFlag();

        // If this is a get method request for a regular processing context such as 'logout' where no additional data is required
        } else if ( structKeyExists(arguments.rc, "context") && rc.context != "get" ){
            getPublicService().invokeMethod("#arguments.rc.context#", {data=arguments.rc});

        }

    }

    public any function post( required struct rc ) {
        param name="arguments.rc.context" default="save";
        var publicService = getService('PublicService');

        // If this is really a get context request just running through a post, then we can do the getter
        if (structKeyExists(arguments.rc, "context") && listFindNoCase("get,cart,getCart,getCartData,account,getAccount,getAccountData", arguments.rc.context)){

            this.get(rc);

        } else if ( structKeyExists(arguments.rc, "context") ){

            var actions = [];
            if (arguments.rc.context contains ","){
                actions = listToArray(arguments.rc.context);
            }
            if (!arrayLen(actions)){
                publicService.invokeMethod("#arguments.rc.context#", {data=arguments.rc});
            }else{
                //iterate through all the actions calling the method.
                for (var eachAction in actions){
                    //Make sure there are no errors if we have multiple.
                    if (!arguments.rc.$.slatwall.cart().hasErrors() && !arguments.rc.$.slatwall.account().hasErrors()){
                          getHibachiScope().flushORMSession();
                          publicService.invokeMethod("#eachAction#", {data=arguments['rc']});
                    }else{
                        return; //return here to push errors to the form that errored.
                    }
                }
            }
        } else {

            this.get(rc);

        }
    }

}
