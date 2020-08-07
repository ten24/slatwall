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
		
		var tokenArray = listToArray(getTokenString(),'.');
		
		setHeader(deserializeJSON(base64UrlDecode(tokenArray[1])));
		setPayload(deserializeJSON(base64UrlDecode(tokenArray[2])));
		setSignature(tokenArray[3]);
		
		/*Make sure the algorithm listed in the header is supported*/
		if(listFindNoCase(structKeyList(getAlgorithmMap()),getHeader().alg) == false){
			throw(type="Invalid Token", message="Algorithm not supported");
		}
		/*Verify signature*/
		var signInput = tokenArray[1] & "." & tokenArray[2];
		if(signature != sign(signInput,getAlgorithmMap()[getHeader().alg])){
			throw(type="Invalid Token", message="signature verification failed"); 
		}
		/*need valid iat*/
		if(!structKeyExists(getPayload(),'iat')){
			throw(type="No Valid issue at time date",message="No Valid issue at time date"); 
		}
		/*need valid iat*/
		if(!structKeyExists(getPayload(),'issuer')){
			throw(type="No Valid issuer",message="No Valid issuer"); 
		}
		/*need valid exp*/
		if(!structKeyExists(getPayload(),'exp')){
			throw(type="No Valid expiration time date",message="No Valid expiration time date"); 
		}
		/*need valid account*/
		if(!structKeyExists(getPayload(), 'accountID')){
			throw(type="No Account ID",message="No Account ID");
		}

		/*if has session then verify session account against token*/
		if(
			!isNull(getHibachiScope().getSession())
			&& !getHibachiScope().getSession().getAccount().getNewFlag()
			&& getHibachiScope().getSession().getAccount().getAccountID() != getPayload().accountID
		){
			throw(type='AccountID is not valid',message='AccountID is not valid');
		}

		var currentTime = getService('hibachiUtilityService').getCurrentUtcTime();
		if(currentTime lt getPayload().iat || currentTime gt getPayload().exp){
			throw(type="Token is expired",message="Token is expired"); 
		}
		
		var serverName = CGI['server_name'];
		if(getPayload().issuer != serverName){
			throw(type="Invalid token issuer",message="Invalid token issuer");
		}
		return this;
	}
	
	public any function encode(required struct payload, string algorithm="HS"){
		var hashAlgorithm = "HS";
		var segments = [];
		/*Make sure only supported algorithms are used*/
		if(listFindNoCase(structKeyList(getAlgorithmMap()),arguments.algorithm)){
			hashAlgorithm = arguments.algorithm;
		}
		/*Add Header - typ and alg fields*/
		arrayAppend(segments, base64UrlEscape(toBase64(serializeJSON({ "typ" =  "JWT", "alg" = hashAlgorithm }),'UTF-8')));
		/*Add payload*/
		arrayAppend(segments, base64UrlEscape(toBase64(serializeJSON(arguments.payload),'UTF-8')));
		arrayAppend(segments, sign(arrayToList(segments,'.'),getAlgorithmMap()[hashAlgorithm]));
		return arrayToList(segments,'.');
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