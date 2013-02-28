<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC

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
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

--->

<cfcomponent accessors="true" output="false" displayname="USA epay" implements="Slatwall.integrationServices.PaymentInterface" extends="Slatwall.integrationServices.BasePayment" >
	
	<cffunction name="init">

		<cfreturn this />
	</cffunction>
	
	<cffunction name="getPaymentMethodTyoes" returntype="string">
		<cfreturn "creditCard" />
	</cffunction>
	
	<cffunction name="getSupportedTransactionTypes">
		<cfreturn "authorize,authorizeAndCharge,chargePreAuthorization,credit,void" />
	</cffunction>
		
	<cffunction name="processCreditCard" returntype="any">
		<cfargument name="requestBean" type="any" required="true" />
		
		<cfset var q_auth = queryNew('empty') />
		
		<cfswitch expression="#arguments.requestBean.getTransactionType()#" >
			<cfcase value="authorize">
				<cfmodule template="usaepay.cfm"
					queryname="q_auth"
					key="#setting('key')#"
					pin="#setting('pin')#"
					sandbox="#setting('testingFlag')#"
					command="authonly"
					card="#arguments.requestBean.getCreditCardNumber()#"
					expdate="#left(arguments.requestBean.getExpirationMonth(),2)##left(arguments.requestBean.getExpirationYear(),2)#"
					amount="#arguments.requestBean.getTransactionAmount()#"
					invoice="#arguments.requestBean.getOrderID()#"
					CVV="#arguments.requestBean.getSecurityCode()#"
					email="#argumetns.requestBean.getAccountPrimaryEmailAddress()#"
					emailcustomer="false"
					custname="#arguments.requestBean.getAccountFirstName()# #argumetns.requestBean.getAccountLastName()#"						  
					avsstreet="#arguments.requestBean.getBillingStreetAddress()#"
					avszip="#arguments.requestBean.getBillingPostalCode()#"
					clientip="#cgi.REMOTE_ADDR#"
				>
			</cfcase>
			<cfcase value="authorizeAndCharge">
				<cfmodule template="usaepay.cfm"
					queryname="q_auth"
					key="#setting('key')#"
					pin="#setting('pin')#"
					sandbox="#setting('testingFlag')#"
					command="sale"
					card="#arguments.requestBean.getCreditCardNumber()#"
					expdate="#left(arguments.requestBean.getExpirationMonth(),2)##left(arguments.requestBean.getExpirationYear(),2)#"
					amount="#arguments.requestBean.getTransactionAmount()#"
					invoice="#arguments.requestBean.getOrderID()#"
					CVV="#arguments.requestBean.getSecurityCode()#"
					email="#argumetns.requestBean.getAccountPrimaryEmailAddress()#"
					emailcustomer="false"
					custname="#arguments.requestBean.getAccountFirstName()# #argumetns.requestBean.getAccountLastName()#"						  
					avsstreet="#arguments.requestBean.getBillingStreetAddress()#"
					avszip="#arguments.requestBean.getBillingPostalCode()#"
					clientip="#cgi.REMOTE_ADDR#"
				>
			</cfcase>
			<cfcase value="chargePreAuthorization">
				<!--- This needs to get changed for authorization code to show up number --->
				<cfmodule template="usaepay.cfm"
					queryname="q_auth"
					key="#setting('key')#"
					pin="#setting('pin')#"
					sandbox="#setting('testingFlag')#"
					command="capture"
					refnum="#arguments.requestBean.getProviderTransactionID()#"
					amount="#arguments.requestBean.getTransactionAmount()#"
					authcode=""
					clientip="#cgi.REMOTE_ADDR#"
				>
			</cfcase>
			<cfcase value="credit">
				<cfmodule template="usaepay.cfm"
					queryname="q_auth"
					key="#setting('key')#"
					pin="#setting('pin')#"
					sandbox="#setting('testingFlag')#"
					command="refund"
					invoice="#arguments.requestBean.getOrderID()#"
					refnum="#arguments.requestBean.getProviderTransactionID()#"
					amount="#arguments.requestBean.getTransactionAmount()#"
					custname="#arguments.requestBean.getAccountFirstName()# #argumetns.requestBean.getAccountLastName()#"						  
					clientip="#cgi.REMOTE_ADDR#"
				>
			</cfcase>
			<cfcase value="void">
				<cfmodule template="usaepay.cfm"
					queryname="q_auth"
					key="#setting('key')#"
					pin="#setting('pin')#"
					sandbox="#setting('testingFlag')#"
					command="void"
					invoice="#arguments.requestBean.getOrderID()#"
					refnum="#arguments.requestBean.getProviderTransactionID()#"
					amount="#arguments.requestBean.getTransactionAmount()#"
					custname="#arguments.requestBean.getAccountFirstName()# #argumetns.requestBean.getAccountLastName()#"						  
					clientip="#cgi.REMOTE_ADDR#"
				>
			</cfcase>
		</cfswitch>
		
		<!--- Setup Response Bean --->
		<cfset var responseBean = createObject("component", "Slatwall.com.utility.payment.CreditCardTransactionResponseBean").init() />
		
		<cfset responseBean.setData(q_auth) />
		<cfset responseBean.setTransactionID(q_auth.UMrefNum) />
		<cfset responseBean.setAuthorizationCode(q_auth.UMauthCode) />
		<cfset responseBean.setStatusCode(q_auth.UMstatus) />
		<cfset responseBean.addMessage(messageCode=q_auth.UMstatus, message=q_auth.UMresult) />
		
		<cfif q_auth.UMstatus neq "Approved">
			<cfset responseBean.addError(q_auth.UMstatus, q_auth.UMresult) />
		<cfelse>
			<!--- Place the amounts into the response bean --->
			<cfswitch expression="#arguments.requestBean.getTransactionType()#" >
				<cfcase value="authorize">
					<cfset responseBean.setAmountAuthorized(arguments.requestBean.getTransactionAmount()) />
				</cfcase>
				<cfcase value="authorizeAndCharge">
					<cfset responseBean.setAmountAuthorized(arguments.requestBean.getTransactionAmount()) />
					<cfset responseBean.setAmountCharged(arguments.requestBean.getTransactionAmount()) />
				</cfcase>
				<cfcase value="chargePreAuthorization">
					<cfset responseBean.setAmountCharged(arguments.requestBean.getTransactionAmount()) />
				</cfcase>
				<cfcase value="credit">
					<cfset responseBean.setAmountCredited(arguments.requestBean.getTransactionAmount()) />
				</cfcase>
			</cfswitch>
		</cfif>
		
		<!--- Translate AVS --->
		<cfif q_auth.UMavsResultCode eq "YYY" or q_auth.UMavsResultCode eq "Y" or q_auth.UMavsResultCode eq "YYA" or q_auth.UMavsResultCode eq "YYD">
			<cfset responseBean.setAVSCode("Y") />
		<cfelseif q_auth.UMavsResultCode eq "NYZ" or q_auth.UMavsResultCode eq "Z">
			<cfset responseBean.setAVSCode("Z") />
		<cfelseif q_auth.UMavsResultCode eq "YNA" or q_auth.UMavsResultCode eq "A" or q_auth.UMavsResultCode eq "YNY">
			<cfset responseBean.setAVSCode("A") /> 
		<cfelseif q_auth.UMavsResultCode eq "NNN" or q_auth.UMavsResultCode eq "N" or q_auth.UMavsResultCode eq "NN">
			<cfset responseBean.setAVSCode("N") /> 
		<cfelse>
			<cfset responseBean.setAVSCode("E") />
		</cfif>
		
		<!--- Translate CVV Matching --->
		<cfif q_auth.UMcvv2ResultCode eq "M">
			<cfset responseBean.setSecurityCodeMatch(true) />
		<cfelse>
			<cfset responseBean.setSecurityCodeMatch(false) />
		</cfif>
		
		<cfreturn responseBean />
	</cffunction>
	
</cfcomponent>