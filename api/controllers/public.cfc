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
		arguments.rc["APIRequest"] = true;
		
		arguments.rc.requestHeaderData = getHTTPRequestData();
		
		//Set the header for response
		param name="rc.headers.contentType" default="application/json"; 
		arguments.rc.headers["Content-Type"] = rc.headers.contentType;
		
		if(isnull(arguments.rc.apiResponse.content)){
			arguments.rc.apiResponse.content = {};
		}
	}
	
	public any function get( required struct rc ) {
		if (StructKeyExists(arguments.rc, "jsonRequest") && arguments.rc.jsonRequest){
			//If the data for public request was sent as json data, then add that data to arguments.rc as key value pairs.
			for (data in arguments.rc.deserializedJSONData){
				arguments.rc["#data#"] = arguments.rc.deserializedJSONData["#data#"];
			}
		}
		//Call the public method
		var publicService = getService('PublicService');
		if ( StructKeyExists(arguments.rc, "context") ){
			publicService.invokeMethod("#arguments.rc.context#", {rc=arguments.rc});
		}else{
			publicService.invokeMethod("getPublicContexts", {rc=arguments.rc});
		}
	}
	
	public any function post( required struct rc ) {
		param name="arguments.rc.context" default="save";
		param name="arguments.rc.entityID" default="";
		param name="arguments.rc.apiResponse.content.errors" default="";
		var structuredData = {};
		
		if(isNull(arguments.rc.apiResponse.content.messages)){
			arguments.rc.apiResponse.content['messages'] = [];
		}
		
		if (StructKeyExists(arguments.rc, "jsonRequest")){
			//If the data for public request was sent as json data, then add that data to arguments.rc as key value pairs.
			for (data in arguments.rc.deserializedJSONData){
				arguments.rc["#data#"] = arguments.rc.deserializedJSONData["#data#"];
			}
		}
		
		//Call the public service to do work.
		var publicService = getService('PublicService');
		if ( StructKeyExists(arguments.rc, "context") ){
			publicService.invokeMethod("#arguments.rc.context#", {rc=arguments.rc});
		}else{
			publicService.invokeMethod("getPublicContexts", {rc=arguments.rc});
		}
		
	}
	
	public any function put( required struct rc ) {
		
	}
	
	public any function delete( required struct rc ) {
		
	}
	
	
}