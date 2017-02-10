component extends="Slatwall.org.Hibachi.HibachiController" output="false" accessors="true" {

    property name="fw" type="any";
  
    property name="totalwineUtilityService" type="any";

	
    this.anyPublicMethods='';
    this.anyPublicMethods=listAppend(this.anyPublicMethods, 'syncData');
    this.anyPublicMethods=listAppend(this.anyPublicMethods, 'get');

    public void function init( required any fw ) {
        setFW( arguments.fw );
    }

    public void function before () {
    	arguments.rc.apiRequest = true;
    	getFW().setView("public:main.blank");
        arguments.rc.headers["Content-Type"] = "application/json";

        if(isnull(arguments.rc.apiResponse.content)){
            arguments.rc.apiResponse.content = {};
        }
		
		if(
			structKeyExists(GetHttpRequestData(),'headers')
			&& structKeyExists(GetHttpRequestData().headers,'Content-Type')
			&& FindNoCase('application/json',GetHttpRequestData().headers['Content-Type'])
		){
			structAppend(arguments.rc,deserializeJson(ToString(GetHttpRequestData().content)));
		}
        if(!isNull(arguments.rc.context) && arguments.rc.context == 'GET'
            && structKEyExists(arguments.rc, 'serializedJSONData')
            && isSimpleValue(arguments.rc.serializedJSONData)
            && isJSON(arguments.rc.serializedJSONData)
        ) {
            StructAppend(arguments.rc,deserializeJSON(arguments.rc.serializedJSONData));
        }
    }
    
    public void function get(required any rc){
		if(!structKeyExists(arguments.rc, "entityName") && arguments.rc.entityName == "Location") {
            arguments.rc.apiResponse.content['account'] = getHibachiScope().invokeMethod("getAccountData");
            arguments.rc.apiResponse.content['cart'] = getHibachiScope().invokeMethod("getCartData");
        } else {
            
            //considering using all url variables to create a transient collectionConfig for api response
            if(!structKeyExists(arguments.rc,'entityID')){
                //should be able to add select and where filters here
                var result = getService('hibachiCollectionService').getAPIResponseForEntityName( arguments.rc.entityName,
																								 arguments.rc, false, "primaryAddress.address.addressID,primaryAddress.address.city,primaryAddress.address.stateCode,primaryAddress.address.countryCode,primaryAddress.address.postalCode");

                structAppend(arguments.rc.apiResponse.content,result);
            }else{

                var collectionEntity = getService('hibachiCollectionService').getCollectionByCollectionID( arguments.rc.entityID );
                //figure out if we have a collection or a basic entity
                if(isNull(collectionEntity)){
                    //should only be able to add selects (&propertyIdentifier=)
                    var result = getService('hibachiCollectionService').getAPIResponseForBasicEntityWithID( arguments.rc.entityName,
																										    arguments.rc.entityID,
																										    arguments.rc );
                    structAppend(arguments.rc.apiResponse.content,result);
                }else{
                    //should be able to add select and where filters here
                    var result = getService('hibachiCollectionService').getAPIResponseForCollection( collectionEntity,
																									 arguments.rc );
                    structAppend(arguments.rc.apiResponse.content,result);
                }
            }
        }
    }
}
