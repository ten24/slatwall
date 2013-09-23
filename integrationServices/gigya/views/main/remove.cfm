<!---

<cfparam name="rc.UID" default="" />
<cfparam name="rc.ts" default="" />
<cfparam name="rc.s" default="6YjD2c8AjmgBfkiN7nk+ONvrYjM=" />

<cfset JavaLoader = createObject("Component", "Slatwall.integrationServices.gigya.org.javaloader.JavaLoader").init([expandPath('/Slatwall/integrationServices/gigya/org/gigya/GSJavaSDK.jar')]) />
<cfset signatureUtilities = JavaLoader.create("com.gigya.socialize.SigUtils").init() />

<cfdump var="#JavaLoader#" />
<cfdump var="#signatureUtilities#" />
<cfdump var="#signatureUtilities.validateUserSignature(rc.UID, rc.ts, request.slatwallScope.setting('integrationGigyaSecretKey'), rc.s)#" />








<cfset restURL = "https://socialize.gigya.com/socialize.removeConnection?apiKey=#urlEncodedFormat($.slatwall.setting('integrationGigyaAPIKey'))#&secret=#urlEncodedFormat($.slatwall.setting('integrationGigyaSecretKey'))#" />

<cfhttp method="post" url="#restURL#" result="gigyaRemoveConnectionResponse">
	<cfhttpparam type="formfield" name="UID" value="#rc.UID#" />
</cfhttp>

<cfset xmlResponse = xmlParse(gigyaRemoveConnectionResponse.fileContent) />

<cfdump var="#xmlResponse#" />
<cfif structKeyExists(xmlResponse, "socialize.removeConnectionResponse")>
	<cfdump var="#xmlResponse['socialize.removeConnectionResponse'].statusCode.xmlText#" />
	<cfdump var="#xmlResponse['socialize.removeConnectionResponse'].errorCode.xmlText#" />
</cfif>

--->


<!---
<cffunction name="getSignature" access="public" returntype="any" output="false" hint="Returns signature">
	<cfargument name="UID" type="string" default="" required="true">
	<cfargument name="signatureTimestamp" type="string" default="" required="false">
	
	<cfset var stResult = {} />
	
	<cfset var binarySecret = ToBinary(request.slatwallScope.setting('integrationGigyaSecretKey'))>
	<cfset var baseString = arguments.signatureTimestamp & "_" & arguments.UID>
	
	<!---
	<cfset var loader = createObject("component", "Slatwall.integrationServices.gigya.org.javaloader.JavaLoader").init(sourceDirectories=[expandPath('/Slatwall/integrationServices/gigya/org/gigya/')]) />
	<cfset var oAuthSigner = loader.create("OAuthSignature").init() />
	<cfset stResult.signature = oAuthSigner.getOAuthSignatureBase64( binarySecret, baseString )>
	--->
	
	<cfset stResult.signatureTimestamp = arguments.signatureTimestamp>
	<cfset var thest = encrypt(baseString, request.slatwallScope.setting('integrationGigyaSecretKey'), "HMAC-SHA1", "Base64" ) />
	<cfreturn stResult>
</cffunction>

--->

<!---
<cffunction name="getSignature" access="private" returntype="String">
	<cfargument name="UID" type="string" required="true" />
	<cfargument name="timestamp" type="numeric" required="true" />
	
	<cfset var baseString = arguments.UID & "_" & arguments.timestamp />
	<!---<cfset var binaryBaseString = toBinary(toBase64(baseString)) />
	<cfset var binaryKey = toBinary(request.slatwallScope.setting('integrationGigyaSecretKey')) /> --->
	<cfset var binarySignature = HMAC_SHA1(request.slatwallScope.setting('integrationGigyaSecretKey'), baseString) />
	<cfset var stringSignature = toBase64(binarySignature) />
	<!---
	<cfdump var="#result#" />
	<cfdump var="#ToString(ToBinary(request.slatwallScope.setting('integrationGigyaSecretKey')))#" />
	<cfdump var="#HMAC_SHA1(ToString(ToBinary(request.slatwallScope.setting('integrationGigyaSecretKey'))), result)#" />
	<cfdump var="#toBase64(HMAC_SHA1(ToString(ToBinary(request.slatwallScope.setting('integrationGigyaSecretKey'))), result))#" />
	
	<cfreturn toBase64(HMAC_SHA1(ToString(ToBinary(request.slatwallScope.setting('integrationGigyaSecretKey'))), result)) />
	--->
	<cfreturn stringSignature />
</cffunction>
--->

<!---
	Props to @yakhnov: http://www.coldfusiondeveloper.com.au/go/note/2008/01/18/hmac-sha1-using-java/

<cffunction name="HMAC_SHA1" returntype="binary" access="public" output="false">
   <cfargument name="signKey" type="string" required="true" />
   <cfargument name="signMessage" type="string" required="true" />

   <cfset var jMsg = JavaCast("string",arguments.signMessage).getBytes("iso-8859-1") />
   <cfset var jKey = JavaCast("string",arguments.signKey).getBytes("iso-8859-1") />

   <cfset var key = createObject("java","javax.crypto.spec.SecretKeySpec") />
   <cfset var mac = createObject("java","javax.crypto.Mac") />

   <cfset key = key.init(jKey,"HmacSHA1") />

   <cfset mac = mac.getInstance(key.getAlgorithm()) />
   <cfset mac.init(key) />
   <cfset mac.update(jMsg) />

   <cfreturn mac.doFinal() />
</cffunction>
--->
