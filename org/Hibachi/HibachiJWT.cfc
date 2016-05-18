/*
	jwt.cfc
	DESCRIPTION: Component for encoding and decoding JSON Web Tokens.
		Based on jwt-simple node.js library (https://github.com/hokaccha/node-jwt-simple)
	PARAMETERS: 
		key - HMAC key used for token signatures
	
			
*/
component accessors="true" persistent="false" output="false" extends="HibachiObject"{
	property name="algorithmMap";
	property name="payload";
	property name="header";
	property name="signature";
	property name="tokenString";
	property name="key";
	
	
	public any function setup(required string key){
		variables.key = arguments.key;
		variables.algorithmMap = {
			"HS" 	= "SHA",
			"HS256" = "SHA-256",
			"HS384" = "SHA-384",
			"HS512" = "SHA-512"
		};
		return this;
	}
	
	public any function getPayload(){
		if(!structKeyExists(variables,'payload')){
			try{
				decode(variables.tokenString);
			}catch(any e){
				
			}
		}
		return variables.payload;
	}
	
	public any function getHeader(){
		if(!structKeyExists(variables,'header')){
			decode(variables.tokenString);
		}
		return variables.header;
	}
	
	public any function getSignature(){
		if(!structKeyExists(variables,'signature')){
			decode(variables.tokenString);
		}
		return variables.signature;
	}
	
	public any function decode(){
		if(listLen(getTokenString(),".") neq 3){
			throw(type="Invalid Token", message="Token should contain 3 segments");
		}
		setHeader(deserializeJSON(base64UrlDecode(listGetAt(getTokenString(),1,"."))));
		setPayload(deserializeJSON(base64UrlDecode(listGetAt(getTokenString(),2,"."))));
		setSignature(listGetAt(getTokenString(),3,"."));
		
		/*Make sure the algorithm listed in the header is supported*/
		if(listFindNoCase(structKeyList(getAlgorithmMap()),getHeader().alg) == false){
			throw(type="Invalid Token", message="Algorithm not supported");
		}
		/*Verify signature*/
		var signInput = listGetAt(getTokenString(),1,".") & "." & listGetAt(getTokenString(),2,".");
		if(signature != sign(signInput,getAlgorithmMap()[getHeader().alg])){
			throw(type="Invalid Token", message="signature verification failed"); 
		}
		/*need valid iat*/
		if(!structKeyExists(getPayload(),'iat')){
			throw(type="No Valid issue at time date"); 
		}
		/*need valid exp*/
		if(!structKeyExists(getPayload(),'exp')){
			throw(type="No Valid expiration time date"); 
		}
		var currentTime = getService('hibachiUtilityService').getCurrentUtcTime();
		if(currentTime lt getPayload().iat || currentTime gt getPayload().exp){
			throw(type="Token is expired"); 
		}
		return this;
	}
	
	public any function encode(required struct payload, string algorithm="HS"){
		var hashAlgorithm = "HS";
		var segments = "";
		/*Make sure only supported algorithms are used*/
		if(listFindNoCase(structKeyList(getAlgorithmMap()),arguments.algorithm)){
			hashAlgorithm = arguments.algorithm;
		}
		/*Add Header - typ and alg fields*/
		segments = listAppend(segments, base64UrlEscape(toBase64(serializeJSON({ "typ" =  "JWT", "alg" = hashAlgorithm }),'UTF-8')),".");
		/*Add payload*/
		segments = listAppend(segments, base64UrlEscape(toBase64(serializeJSON(arguments.payload),'UTF-8')),".");
		segments = listAppend(segments, sign(segments,getAlgorithmMap()[hashAlgorithm]),".");
		return segments;
	}
	
	public boolean function verify(){
		var isValid = true;
		try{
			decode(getTokenString());
		}catch(any e){
			isValid = false;
		}
		return isValid;
	}
	/*Create an hash of provided string using the secret key and algorithm*/
	public string function sign(required string msg, string algorithm="SHA"){
		var result = hash(arguments.msg&variables.key,arguments.algorithm);
		return base64UrlEscape(toBase64(result,'UTF-8'));
	}
	/*Escapes unsafe url characters from a base64 string*/
	public string function base64UrlEscape(required string str){
		return reReplace(reReplace(reReplace(str, "\+", "-", "all"), "\/", "_", "all"),"=", "", "all");
	}
	/*restore base64 characters from an url escaped string */
	public string function base64UrlUnescape(required string str){
		var base64String = reReplace(reReplace(arguments.str, "\-", "+", "all"), "\_", "/", "all");
		var padding = repeatstring("=",4 - len(base64String) mod 4);
		return base64String & padding;
	}
	/*Decode a url encoded base64 string*/
	public string function base64UrlDecode(required string str){
		return toString(toBinary(base64UrlUnescape(arguments.str)));
	}
}
