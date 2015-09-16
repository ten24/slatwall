 <!---
	jwt.cfc
	DESCRIPTION: Component for encoding and decoding JSON Web Tokens.
		Based on jwt-simple node.js library (https://github.com/hokaccha/node-jwt-simple)
	PARAMETERS: 
		key - HMAC key used for token signatures
	
			
--->

<cfcomponent accessors="true" output="false" persistent="false" extends="Slatwall.org.Hibachi.HibachiObject">
	<cfproperty name="algorithmMap" persistent="false"/>
	<cfproperty name="payload" persistent="false"/>
	<cfproperty name="header" persistent="false"/>
	<cfproperty name="signature" persistent="false"/>
	<cfproperty name="tokenString" persistent="false"/>
	
	<cffunction name="init" output="false">
		<cfargument name="key" required="true">
		
		<cfset variables.key = arguments.key>
		<!--- Supported algorithms --->
		<cfset variables.algorithmMap = {
			"HS" 	= "SHA",
			"HS256" = "SHA-256",
			"HS384" = "SHA-384",
			"HS512" = "SHA-512"
		}>

		<cfreturn this>
	</cffunction>
	
	<cffunction name="getPayload" output="false">
		<cfif !structKeyExists(variables,'payload')>
			<cftry>
				<cfset decode(variables.TokenString)>
			<cfcatch></cfcatch>
			</cftry>
		</cfif>
		<cfreturn variables.payload>
	</cffunction>
	
	<cffunction name="getHeader" output="false">
		<cfif !structKeyExists(variables,'header')>
			<cfset decode(variables.TokenString)>
		</cfif>
		<cfreturn variables.header>
	</cffunction>
	
	<cffunction name="getSignature" output="false">
		<cfif !structKeyExists(variables,'signature')>
			<cfset decode(variables.TokenString)>
		</cfif>
		<cfreturn variables.signature>
	</cffunction>
	

	<!--- 	decode(string) as struct
			Description:  Decode a JSON Web TokenString
	---> 
	<cffunction name="decode" output="false">
		
		<!--- TokenString should contain 3 segments --->
		<cfif listLen(getTokenString(),".") neq 3>
			<cfthrow type="Invalid Token" message="Token should contain 3 segments">
		</cfif>

		<!--- Get  --->
		<cfset setHeader(deserializeJSON(base64UrlDecode(listGetAt(getTokenString(),1,"."))))>
		<cfset setPayload(deserializeJSON(base64UrlDecode(listGetAt(getTokenString(),2,"."))))>
		<cfset setSignature(listGetAt(getTokenString(),3,"."))>

		<!--- Make sure the algorithm listed in the header is supported --->
		<cfif listFindNoCase(structKeyList(getAlgorithmMap()),getHeader().alg) eq false>
			<cfthrow type="Invalid Token" message="Algorithm not supported">
		</cfif>

		<!--- Verify signature --->
		<cfset var signInput = listGetAt(getTokenString(),1,".") & "." & listGetAt(getTokenString(),2,".")>
		<cfif signature neq sign(signInput,getAlgorithmMap()[getHeader().alg])>
			<cfthrow type="Invalid Token" message="signature verification failed">
		</cfif>
		
		<!--- need valid iat --->
		<cfif !structKeyExists(getPayload(),'iat')>
			<cfthrow type="No Valid issue at time date">
		</cfif>
		
		<!--- need valid exp --->
		<cfif !structKeyExists(getPayload(),'exp')>
			<cfthrow type="No Valid expiration time date">
		</cfif>
		
		<cfset var currentTime = getService('hibachiUtilityService').getCurrentUtcTime()/>
		<cfif currentTime lt getPayload().iat || currentTime gt getPayload().exp>
			<cfthrow type="Token is expired"/>
		</cfif>
		
		<cfreturn this>
	</cffunction>
	
	<!--- 	encode(struct,[string]) as String
			Description:  encode a data structure as a JSON Web TokenString
	---> 
	<cffunction name="encode" output="false">
		<cfargument name="payload" required="true">
		<cfargument name="algorithm" default="HS">

		<!--- Default hash algorithm --->
		<cfset var hashAlgorithm = "HS">
		<cfset var segments = "">

		<!--- Make sure only supported algorithms are used --->
		<cfif listFindNoCase(structKeyList(getAlgorithmMap()),arguments.algorithm)>
			<cfset hashAlgorithm = arguments.algorithm>
		</cfif>

		<!--- Add Header - typ and alg fields--->
		<cfset segments = listAppend(segments, base64UrlEscape(toBase64(serializeJSON({ "typ" =  "JWT", "alg" = hashAlgorithm }),'UTF-8')),".")>
		<!--- Add payload --->
		<cfset segments = listAppend(segments, base64UrlEscape(toBase64(serializeJSON(arguments.payload),'UTF-8')),".")>
		<cfset segments = listAppend(segments, sign(segments,getAlgorithmMap()[hashAlgorithm]),".")>

		<cfreturn segments>
	</cffunction>

	<!--- 	verify(token) as Boolean
			Description:  Verify the token signature
	---> 
	<cffunction name="verify" output="false">
		<cfset var isValid = true>
		<cftry>
			<cfset decode(getTokenString())>
			<cfcatch>
				<cfset isValid = false>
			</cfcatch>
		</cftry>

		<cfreturn isValid>
	</cffunction>

	<!--- 	sign(string,[string]) as String
			Description: Create an hash of provided string using the secret key and algorithm
	---> 
	<cffunction name="sign" output="false" access="private">
		<cfargument name="msg" type="string" required="true">
		<cfargument name="algorithm" default="SHA">

		<cfset var result = hash(variables.key,arguments.algorithm)>

		<cfreturn base64UrlEscape(toBase64(result,'UTF-8'))>
	</cffunction>

	<!--- 	base64UrlEscape(String) as String
			Description:  Escapes unsafe url characters from a base64 string
	---> 
	<cffunction name="base64UrlEscape" output="false" access="private">
		<cfargument name="str" required="true">

		<cfreturn reReplace(reReplace(reReplace(str, "\+", "-", "all"), "\/", "_", "all"),"=", "", "all")>
	</cffunction>

	<!--- 	base64UrlUnescape(String) as String
			Description: restore base64 characters from an url escaped string 
	---> 
	<cffunction name="base64UrlUnescape" output="false" access="private">
		<cfargument name="str" required="true">

		<!--- Unescape url characters --->
		<cfset var base64String = reReplace(reReplace(arguments.str, "\-", "+", "all"), "\_", "/", "all")>
		<cfset var padding = repeatstring("=",4 - len(base64String) mod 4)>

		<cfreturn base64String & padding>
	</cffunction>


	<!--- 	base64UrlDecode(String) as String
			Description:  Decode a url encoded base64 string
	---> 
	<cffunction name="base64UrlDecode" output="false" access="private">
		<cfargument name="str" required="true">

		<cfreturn toString(toBinary(base64UrlUnescape(arguments.str)))>
	</cffunction>

	
</cfcomponent>