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
<cfcomponent output="false" accessors="true">
	
	<cffunction name="afterAccountProcess_logoutSuccess">
		<cfargument name="slatwallScope" type="any" required="true" />
		<cfargument name="account" type="any" required="true" />
		
		<!--- Get the authentication CFC --->
		<cfset var authenticationCFC = arguments.slatwallScope.getService("integrationService").getIntegrationByIntegrationPackage("gigya").getIntegrationCFC( 'authentication' ) />
		
		<cfset var gigyaResponse = authenticationCFC.socializeNotifyLogout( account=arguments.account ) />
	</cffunction>
	
	<cffunction name="afterAccountProcess_loginSuccess">
		<cfargument name="slatwallScope" type="any" required="true" />
		<cfargument name="account" type="any" required="true" />
		<cfargument name="data" type="struct" required="true" />
		
		<!--- If this was logging in with gigya credentials --->
		<cfif structKeyExists(arguments.data, "gigyaUID") && structKeyExists(arguments.data, "gigyaUIDSignature") && structKeyExists(arguments.data, "gigyaSignatureTimestamp")>
			
		
			<!--- Get the authentication CFC --->
			<cfset var gigyaIntegration = arguments.slatwallScope.getService("integrationService").getIntegrationByIntegrationPackage("gigya") />
			<cfset var authenticationCFC = gigyaIntegration.getIntegrationCFC( 'authentication' ) />
			
			<!--- Check to make sure that the UID and the accountID are different --->
			<cfif arguments.account.getAccountID() neq arguments.data.gigyaUID>
				
				<!--- Verify the signature --->
				<cfif authenticationCFC.getUserSignatureValidFlag( uid=arguments.data.gigyaUID, uidSignature=arguments.data.gigyaUIDSignature, signatureTimestamp=arguments.data.gigyaSignatureTimestamp )>
					
					<!--- Check for a legacy UID to match up --->
					<cfset var oldUID = "" />
					<cfif len(gigyaIntegration.setting('legacyUIDPropertyIdentifier'))>
						<cfset oldUID = arguments.account.getValueByPropertyIdentifier( gigyaIntegration.setting('legacyUIDPropertyIdentifier') ) />
					</cfif>
					
					<!--- If there is a legacyUID, and it matches the gigya one then just update them --->
					<cfif len(oldUID) and oldUID eq arguments.data.gigyaUID>
						
						<!--- Update gigya with the new UID --->
						<cfset var gigyaResponse = authenticationCFC.socializeSetUID( oldUID=oldUID, newUID=arguments.account.getAccountID() ) />
					
					<cfelse>
						
						<!--- Tell gigya about this user --->
						<cfset var gigyaResponse = authenticationCFC.socializeNotifyRegistration( account=arguments.account, uid=arguments.data.gigyaUID ) />
						
					</cfif>
					
					<!--- Create the accountAuthentication object --->
					<cfset authenticationCFC.createGigyaAccountAuthentication( arguments.account ) />
					
				</cfif>
				
			</cfif>
			
			<!--- Call the socialize.notifyLogin function --->
			<cfset var gigyaResponse = authenticationCFC.socializeNotifyLogin( account=arguments.account ) />
		</cfif>
		
	</cffunction>
	
	<!--- beforeAccountDelete - This is used so that if an account gets deleted and it has a 'gigya' account authentication, we tell gigya to disconnect this user --->
	<cffunction name="beforeAccountDelete">
		<cfargument name="slatwallScope" type="any" required="true" />
		<cfargument name="entity" type="any" required="true" />
		
		<cfset var accountAuthentication = "" />
		
		<!--- Loop over the authentications, and call delete on the authentication for gigya.  This will call the delete event, which will in turn call the socializeAPI --->
		<cfloop array="#arguments.entity.getAccountAuthentications()#" index="local.accountAuthentication">
			
			<cfif !isNull(accountAuthentication.getIntegration()) and accountAuthentication.getIntegration().getIntegrationPackage() eq 'gigya'>
			
				<!--- Get the authentication CFC --->
				<cfset var authenticationCFC = accountAuthentication.getIntegration().getIntegrationCFC( 'authentication' ) />
			
				<!--- Tell gigya to remove this user --->
				<cfset var gigyaResponse = authenticationCFC.socializeRemoveConnection( account=arguments.account ) />

			</cfif>
			
		</cfloop>
		
	</cffunction>
	
	<!--- beforeAccountAuthenticationDelete - This is used so that if a 'gigya' account authentication gets removed, then we tell gigya to disconnect this user --->
	<cffunction name="beforeAccountAuthenticationDelete">
		<cfargument name="slatwallScope" type="any" required="true" />
		<cfargument name="entity" type="any" required="true" />
		
		<!--- Check to see if this is a gigya authentication --->
		<cfif !isNull(entity.getIntegration()) && entity.getIntegration().getIntegrationPackage() eq 'gigya'>
			
			<!--- Get the authentication CFC --->
			<cfset var authenticationCFC = arguments.slatwallScope.getService("integrationService").getIntegrationByIntegrationPackage("gigya").getIntegrationCFC( 'authentication' ) />
			
			<!--- Tell gigya to remove this user --->
			<cfset var gigyaResponse = authenticationCFC.socializeRemoveConnection(account=entity.getAccount()) />

		</cfif>
		
	</cffunction>
	
</cfcomponent>
