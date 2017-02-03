<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC
	
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
	
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
	
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
	
    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your 
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms 
    of your choice, provided that you follow these specific guidelines: 

	- You also meet the terms and conditions of the license of each 
	  independent module 
	- You must not alter the default display of the Slatwall name or logo from  
	  any part of the application 
	- Your custom code must not alter or create any files inside Slatwall, 
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets 
	the above guidelines as a combined work under the terms of GPL for this program, 
	provided that you include the source code of that other code when and as the 
	GNU GPL requires distribution of source code.
    
    If you modify this program, you may extend this exception to your version 
    of the program, but you are not obligated to do so.

Notes:

--->

<cfcomponent accessors="true" output="false" implements="Slatwall.integrationServices.AuthenticationInterface" extends="Slatwall.integrationServices.BaseAuthentication">

	<cfproperty name="signatureUtilities" type="any" />
	
	<!--- ============== START: Slatwall API Hooks ================= --->
	<cffunction name="verifySessionLogin" access="public" returntype="boolean">
		<cfreturn true />
	</cffunction>
	
	<cffunction name="getAdminLoginHTML" access="public" returntype="string">
		<cfreturn renderGigyaWidget('adminLoginForm', '', 'gigyaAdminUnregisteredUser') />
	</cffunction>
	
	<cffunction name="renderGigyaWidget" access="public" returntype="string">
		<cfargument name="accountLoginFormID" type="string" default="" />
		<cfargument name="accountCreateFormID" type="string" default="" />
		<cfargument name="unregisterdUserCallback" type="string" default="" />
		<cfargument name="config" default="#structNew()#" />
		
		<cfset var gigyaWidget = "" />
		
		<!--- setup the defaults --->
		<cfif not structKeyExists(arguments.config, "showTermsLink")>
			<cfset arguments.config["showTermsLink"] = false />
		</cfif>
		<cfif not structKeyExists(arguments.config, "height")>
			<cfset arguments.config["height"] = 100 />
		</cfif>
		<cfif not structKeyExists(arguments.config, "width")>
			<cfset arguments.config["width"] = 400 />
		</cfif>
		<cfif not structKeyExists(arguments.config, "containerID")>
			<cfset arguments.config["containerID"] = createUUID() />
		</cfif>
		<cfif not structKeyExists(arguments.config, "buttonsStyle")>
			<cfset arguments.config["buttonsStyle"] = "fullLogo" />
		</cfif>
		<cfif not structKeyExists(arguments.config, "autoDetectUserProviders")>
			<cfset arguments.config["autoDetectUserProviders"] = "" />
		</cfif>
		<cfif not structKeyExists(arguments.config, "facepilePosition")>
			<cfset arguments.config["facepilePosition"] = "" />
		</cfif>
		<cfif not structKeyExists(arguments.config, "context")>
			<cfset arguments.config["context"] = {} />
			<cfif len(arguments.accountLoginFormID)>
				<cfset arguments.config["context"]['accountLoginFormID'] = arguments.accountLoginFormID />
			</cfif>
			<cfif len(arguments.accountCreateFormID)>
				<cfset arguments.config["context"]['accountCreateFormID'] = arguments.accountCreateFormID />
			</cfif>
			<cfif len(arguments.unregisterdUserCallback)>
				<cfset arguments.config["context"]['unregisterdUserCallback'] = arguments.unregisterdUserCallback />
			</cfif>
		</cfif>
		
		<cfsavecontent variable="gigyaWidget">
			<cfoutput>
				<div id="#arguments.config.containerID#"></div>
				<script type="text/javascript">
					(function($){
						gigya.socialize.showLoginUI( #serializeJSON(arguments.config)# );
					})(jQuery)
				</script>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn gigyaWidget />
	</cffunction>
	
	<!--- =============== END: Slatwall API Hooks ================== --->
		
	<!--- =============== START: GIGYA REST Calls =-================ --->
		
	<!--- socialize.notifyRegistration --->
	<cffunction name="socializeNotifyRegistration">
		<cfargument name="account" type="any" required="true" />
		<cfargument name="uid" type="struct" required="true" />
		
		<cfset var rawResponse = "" />
		<cfset var xmlResponse = "" />
		
		<cfhttp method="post" url="https://socialize.gigya.com/socialize.notifyRegistration" result="rawResponse">
			<cfhttpparam type="formfield" name="apiKey" value="#setting('apiKey')#" />
			<cfhttpparam type="formfield" name="secret" value="#setting('secretKey')#" />
			<cfhttpparam type="formfield" name="UID" value="#arguments.UID#" />
			<cfhttpparam type="formfield" name="siteUID" value="#arguments.account.getAccountID()#" />
		</cfhttp>
		
		<cfset xmlResponse = xmlParse(rawResponse.fileContent) />
		
		<cfreturn xmlResponse />
	</cffunction>
	
	<!--- socialize.setUID --->
	<cffunction name="socializeSetUID">
		<cfargument name="oldUID" type="struct" required="true" />
		<cfargument name="newUID" type="struct" required="true" />
		
		<cfset var rawResponse = "" />
		<cfset var xmlResponse = "" />
		
		<cfhttp method="post" url="https://socialize.gigya.com/socialize.setUID" result="rawResponse">
			<cfhttpparam type="formfield" name="apiKey" value="#setting('apiKey')#" />
			<cfhttpparam type="formfield" name="secret" value="#setting('secretKey')#" />
			<cfhttpparam type="formfield" name="UID" value="#arguments.oldUID#" />
			<cfhttpparam type="formfield" name="siteUID" value="#arguments.newUID#" />
		</cfhttp>
		
		<cfset xmlResponse = xmlParse(rawResponse.fileContent) />
		
		<cfreturn xmlResponse />
	</cffunction>
	
	<!--- socialize.removeConnection --->
	<cffunction name="socializeRemoveConnection">
		<cfargument name="account" type="any" required="true" />
		
		<cfset var rawResponse = "" />
		<cfset var xmlResponse = "" />
		 
		<cfhttp method="post" url="https://socialize.gigya.com/socialize.removeConnection" result="rawResponse">
			<cfhttpparam type="formfield" name="apiKey" value="#setting('apiKey')#" />
			<cfhttpparam type="formfield" name="secret" value="#setting('secretKey')#" />
			<cfhttpparam type="formfield" name="UID" value="#account.getAccountID()#" />
		</cfhttp>
		
		<cfset xmlResponse = xmlParse(rawResponse.fileContent) />
		
		<cfreturn xmlResponse />
	</cffunction>
	
	<!--- socialize.logout --->
	<cffunction name="socializeNotifyLogout">
		<cfargument name="account" type="any" required="true" />
		
		<cfset var rawResponse = "" />
		<cfset var xmlResponse = "" />
		
		<cfhttp method="post" url="https://socialize.gigya.com/socialize.logout" result="rawResponse">
			<cfhttpparam type="formfield" name="apiKey" value="#setting('apiKey')#" />
			<cfhttpparam type="formfield" name="secret" value="#setting('secretKey')#" />
			<cfhttpparam type="formfield" name="UID" value="#account.getAccountID()#" />
		</cfhttp>
		
		<cfset xmlResponse = xmlParse(rawResponse.fileContent) />
		
		<cfreturn xmlResponse />
	</cffunction>
	
	<!--- socialize.notifyLogin --->
	<cffunction name="socializeNotifyLogin">
		<cfargument name="account" type="any" required="true" />
		
		<cfset var rawResponse = "" />
		<cfset var xmlResponse = "" />
		
		<cfhttp method="post" url="https://socialize.gigya.com/socialize.notifyLogin" result="rawResponse">
			<cfhttpparam type="formfield" name="apiKey" value="#setting('apiKey')#" />
			<cfhttpparam type="formfield" name="secret" value="#setting('secretKey')#" />
			<cfhttpparam type="formfield" name="siteUID" value="#account.getAccountID()#" />
		</cfhttp>
		
		<cfset xmlResponse = xmlParse(rawResponse.fileContent) />
		
		<cfreturn xmlResponse />
	</cffunction>
	
	<!--- =============== END: GIGYA REST Calls =-================ --->
		
	<!--- ============== START: Processing Methods =============== --->
		
	<cffunction name="loginGigyaUser">
		<cfargument name="uid" type="string" required="true" />
		<cfargument name="uidSignature" type="string" required="true" />
		<cfargument name="signatureTimestamp" type="string" required="true" />
		
		<cfset var accountAuthentication = "" />
		
		<!--- Validate the signature --->
		<cfif getUserSignatureValidFlag( arguments.uid, arguments.uidSignature, arguments.signatureTimestamp )>
			
			<!--- Get the account by the UID --->
			<cfset var account = getService("accountService").getAccount( arguments.uid ) />
			
			<!--- If the account wasn't found, then check for a legacyUID propertyIdentifier --->
			<cfif isNull(account) and len(setting('legacyUIDPropertyIdentifier'))>
				
				<!--- If the legacyUIDPropertyIdentifier is a custom attribute, then look up in attributes --->
				<cfif getService("hibachiService").getEntityHasAttributeByEntityName("Account", setting('legacyUIDPropertyIdentifier'))>
					
					<cfset var rs = "" />
					
					<cfquery name="rs">
						SELECT
							SwAttributeValue.accountID
						FROM
							SwAttributeValue
						  INNER JOIN
						  	SwAttribute on SwAttributeValue.attributeID = SwAttribute.attributeID
						WHERE
							accountID is not null
						  AND
						  	SwAttribute.attributeCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#setting('legacyUIDPropertyIdentifier')#" />
						  AND
						  	SwAttributeValue.attributeValue = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.uid#" />
					</cfquery>
					
					<cfif rs.recordCount>
						<cfset account = getService("accountService").getAccount( rs.accountID ) />
					</cfif>
				<cfelse>
					<cfset account = ormExecuteQuery(" FROM SlatwallAccount WHERE #setting('legacyUIDPropertyIdentifier')# = ?", [ arguments.uid ], true) />
				</cfif>
				
				<!--- If the account was found, then the first thing we need to do is notify gigya of the new accountID --->
				<cfif not isNull(account)>
					<cfset socializeSetUID( oldUID=arguments.uid, newUID=account.getAccountID() ) />
				</cfif>
				
			</cfif>
			
			<!--- Make sure the account was found --->
			<cfif !isNull(account)>
				
				<cfset var accountAuthenticationFound = false />
				
				<!--- Loop over the account authentications --->
				<cfloop array="#account.getAccountAuthentications()#" index="local.accountAuthentication">
					
					<!--- When the gigya authentication is found, login the account --->
					<cfif !isNull(accountAuthentication.getIntegration()) && accountAuthentication.getIntegration().getIntegrationPackage() eq 'gigya'>
						
						<cfset accountAuthenticationFound = true />
						
						<cfset getService("hibachiSessionService").loginAccount( account=account, accountAuthentication=accountAuthentication) />
						
						<cfbreak />
					</cfif>
					
				</cfloop>
				
				<!--- If we didn't find an accountAuthentication then it may have been removed somehow so we just add one back --->
				<cfif not accountAuthenticationFound>
					<cfset var accountAuthentication = createGigyaAccountAuthentication( account ) />
					<cfset getService("hibachiSessionService").loginAccount( account=account, accountAuthentication=accountAuthentication ) />
				</cfif>
					
			</cfif>
			
		</cfif>
		
	</cffunction>
	
	<cffunction name="createGigyaAccountAuthentication">
		<cfargument name="account" type="any" required="true" />
		
		<!--- Create authentication for this user / gigiya --->
		<cfset var newAccountAuthentication = getService("accountService").newAccountAuthentication() />
		<cfset newAccountAuthentication.setIntegration( getService("integrationService").getIntegrationByIntegrationPackage('gigya') ) />
		<cfset newAccountAuthentication.setAccount( arguments.account ) />
		
		<!--- Persist Authentication to the DB --->
		<cfset getDAO("hibachiDAO").flushORMSession() />
		
		<cfreturn newAccountAuthentication />
	</cffunction>
		
	<!--- ============== START: Processing Methods =============== --->
	
	<cffunction name="getUserSignatureValidFlag">
		<cfargument name="uid" type="string" required="true" />
		<cfargument name="uidSignature" type="string" required="true" />
		<cfargument name="signatureTimestamp" type="string" required="true" />
		
		<cfreturn getSignatureUtilities().validateUserSignature( arguments.uid, arguments.signatureTimestamp, setting('secretKey'), arguments.uidSignature ) />
	</cffunction>
		
	<cffunction name="getSignatureUtilities">
		<cfif not structKeyExists(variables, "signatureUtilities")>
			<cfset var JavaLoader = createObject("Component", "Slatwall.integrationServices.gigya.org.javaloader.JavaLoader").init([expandPath('/Slatwall/integrationServices/gigya/org/gigya/GSJavaSDK.jar')]) />
			<cfset variables.signatureUtilities = JavaLoader.create("com.gigya.socialize.SigUtils").init() />
		</cfif>
		<cfreturn variables.signatureUtilities />
	</cffunction>

</cfcomponent>

