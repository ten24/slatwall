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

    public any function scope( required struct rc ) {
        param name="arguments.rc.context" default="";

        if(!len(arguments.rc.context)) {

            arguments.rc.ajaxResponse[ "account" ] = getHibachiScope().getAccountData( arguments.rc.propertyIdentifiers );
            arguments.rc.ajaxResponse[ "cart" ] = getHibachiScope().getCartData( arguments.rc.propertyIdentifiers );
            arguments.rc.ajaxResponse[ "loggedInFlag" ] = getHibachiScope().getLoggedInFlag();
            arguments.rc.ajaxResponse[ "loggedInAsAdminFlag" ] = getHibachiScope().getLoggedInAsAdminFlag();

        } else {

            var contextArray = listToArray(arguments.rc.context);

            for(var context in contextArray) {

                if ( listFindNoCase("cart,getCart,getCartData", context) ){

                    arguments.rc.ajaxResponse[ "cart" ] = getHibachiScope().getCartData( arguments.rc.propertyIdentifiers );

                // If the request is specifically just asking for account data
                } else if ( listFindNoCase("account,getAccount,getAccountData", context) ){

                    arguments.rc.ajaxResponse[ "account" ] = getHibachiScope().getAccountData( arguments.rc.propertyIdentifiers );

                // IMPORTANT TODO: MAKE THIS A WHITELIST OF FUNCTIONS IN THE PUBLIC SERVICE
                } else {

                    arguments.rc.ajaxResponse[ context ] = getPublicService().invokeMethod(context, {data=arguments.rc});
                }

                // If no errors flush to the DB, if there are then break out of this loop and stop processing
                if (!getHibachiScope().getORMHasErrors()){
                    getHibachiScope().flushORMSession();
                } else {
                    break;
                }

            }
        }
    }


}
