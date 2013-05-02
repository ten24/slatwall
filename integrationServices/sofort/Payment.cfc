<cfcomponent accessors="true" output="false" implements="Slatwall.integrationServices.PaymentInterface" extends="Slatwall.integrationServices.BasePayment">

<cffunction name="newPayment" access="public" returntype="string" hint="Get payment request">
	<cfargument name="cart" required="true" hint="cart with all order-items" />

	<cfset local.result 				= '' />
	<cfset local.paymentService = arguments.cart.getService('paymentService') />
	<cfset local.paymentMethods	= entityLoad('SlatwallPaymentMethod',{ paymentIntegration=getIntegration() },{ maxResults=1 }) />
	<cfset local.paymentMethod	= local.paymentMethods[1] />

	<cfset local.orderPayment = local.paymentService.newOrderPayment() />
	<cfset local.orderPayment.setPaymentMethodType(getPaymentMethodTypes()) />
	<cfset local.orderPayment.setPaymentMethod(local.paymentMethod) />
	<cfset local.orderPayment.setCurrencyCode(arguments.cart.getCurrencyCode()) />
	<cfset local.orderPayment.setAmount(arguments.cart.getTotal()) />
	<cfset arguments.cart.addOrderPayment(local.orderPayment) />
	<cfset ormFlush() />

	<cfset local.successUrl	= urlSessionFormat('#property('localURL')##$.createHREF(filename='checkout')#?payment=success&slatAction=sofort:payment.verify&transactionId=-TRANSACTION-#chr(35)#payment') />
	<cfset local.abortUrl		= urlSessionFormat('#property('localURL')##$.createHREF(filename='checkout')#?payment=abort&slatAction=sofort:payment.abort&transactionId=-TRANSACTION-#chr(35)#payment') />

	<cfsavecontent variable="local.xmlContent"><cfoutput>
		<multipay>
			<project_id>#xmlFormat(setting('projectId'))#</project_id>
			<language_code>#xmlFormat(setting('language'))#</language_code>
			<interface_version>#xmlFormat(property('interfaceVersion'))#</interface_version>
			<currency_code>#xmlFormat(setting('currency'))#</currency_code>
			<amount>#xmlFormat(arguments.cart.getTotal())#</amount>
			<success_url>#xmlFormat(local.successUrl)#</success_url>
			<abort_url>#xmlFormat(local.abortUrl)#</abort_url>
			<su>
				<amount>#arguments.cart.getTotal()#</amount>
				<reasons>
					<cfloop array="#arguments.cart.getOrderItems()#" index="local.orderItem">
						<cfset local.maxLength	= 27 />
						<cfset local.length			= 27 />
						<cfset local.reason			= left(local.orderItem.getSku().getProduct().getTitle(),local.length) />

						<cfloop condition="len(local.reason) GT local.maxLength">
							<cfset local.length -= 1 />
							<cfset local.reason = left(local.reason,local.length) />
						</cfloop>

						<cfif setting('transferProductNames')>
							<reason>#xmlFormat(left(reReplaceNoCase(local.reason,'[^0-9a-z\s\+\-,\.]','','all'),27))#</reason> <!--- Es sind nur 27 Zeichen erlaubt --->
						<cfelse>
							<reason>#xmlFormat(left(hash(local.reason),27))#</reason>
						</cfif>
					</cfloop>
				</reasons>
			</su>
		</multipay>
	</cfoutput></cfsavecontent>

	<cfset local.xmlResponse = doRequest(local.xmlContent) />

	<cfif structKeyExists(local.xmlResponse,'new_transaction')>
		<cfset local.result	= local.xmlResponse.new_transaction.payment_url.xmlText />
	<cfelseif structKeyExists(local.xmlResponse,'errors')>
		<cfset local.result	= local.xmlResponse.errors.error.code.xmlText />
	</cfif>

	<cfreturn local.result />
</cffunction>


<cffunction name="verifyPayments" returnType="any" access="public" output="false">
	<cfargument name="cart"						required="true" hint="Cart with all order-items" />
	<cfargument name="transactionId"	required="true"	hint="TransactionId of remote system" />

	<cfset local.paymentService		= $.slatwall.getService('paymentService') />
	<cfset local.paymentMethods		= entityLoad('SlatwallPaymentMethod',{ paymentIntegration=getIntegration() },{ maxResults=1 }) />
	<cfset local.paymentMethod		= local.paymentMethods[1] />
	<cfset local.transactionInfo	= transactionInformation(arguments.transactionId) />

	<cfloop array="#arguments.cart.getOrderPayments()#" index="local.orderPayment">
		<cfif local.orderPayment.hasPaymentMethod() AND local.orderPayment.getPaymentMethod().getPaymentMethodId() EQ local.paymentMethod.getPaymentMethodId()>
			<cfset local.paymentTransaction	= local.paymentService.newPaymentTransaction() />
			<cfset local.paymentTransaction.setTransactionDateTime(now()) />
			<cfset local.paymentTransaction.setCurrencyCode($.slatwall.cart().getCurrencyCode()) />
			<cfset local.paymentTransaction.setProviderTransactionId(arguments.transactionId) />

			<cfif xmlPathExists(local.transactionInfo,'transactions.transaction_details.status') AND listFindNoCase('received,pending',local.transactionInfo.transactions.transaction_details.status.xmlText)
				OR xmlPathExists(local.transactionInfo,'transactions.transaction_details.test') AND local.transactionInfo.transactions.transaction_details.test.xmlText EQ 1>
				<cfset local.paymentTransaction.setAmountAuthorized(arguments.cart.getTotal()) />
			</cfif>

			<cfset local.orderPayment.addPaymentTransaction(local.paymentTransaction) />
		</cfif>
	</cfloop>

	<cfset ormFlush() />
</cffunction>


<cffunction name="getPaymentMethodTypes" access="public" returntype="string" hint="Get Payment-Method-Types">
	<cfreturn 'external' />
</cffunction>


<cffunction name="transactionInformation" access="public" returntype="xml" hint="Get the transaction information">
	<cfargument name="transactionId" required="true" hint="Transaction Id" />

	<cfsavecontent variable="local.xmlContent"><cfoutput>
		<transaction_request version="1.0">
			<transaction>#arguments.transactionId#</transaction>
		</transaction_request>
	</cfoutput></cfsavecontent>

	<cfreturn doRequest(local.xmlContent) />
</cffunction>


<cffunction name="doRequest" access="private" returntype="any" hint="Do the request to the API">
	<cfargument name="content" required="true" hint="Content for the API-request" />

	<cfset local.result					= '' />
	<cfset arguments.content		= reReplace(arguments.content,'>\s+','>','all') />
	<cfset local.objSecurity		= createObject("java", "java.security.Security") />
	<cfset local.storeProvider	= local.objSecurity.getProvider("JsafeJCE") />
	<cfset local.objSecurity.removeProvider("JsafeJCE") />

	<cflog text="request: #arguments.content#" file="sofort" type="information" />
	<cfhttp method="post" url="#property('apiURL')#" result="local.response" username="#setting('CustomerID')#" password="#setting('APIKey')#">
		<cfhttpparam type="header" name="Content-Type" value="application/xml" />
		<cfhttpparam type="body" value="#arguments.content#" />
	</cfhttp>
	<cflog text="response: #local.response.fileContent#" file="sofort" type="information" />

	<cfif NOT isNull(local.storeProvider)>
		<cfset objSecurity.insertProviderAt(local.storeProvider, 1) />
	</cfif>

	<cfif isXml(local.response.fileContent)>
		<cfset local.result = xmlParse(local.response.fileContent) />
	</cfif>

	<cfreturn local.result />
</cffunction>


<cffunction name="xmlPathExists" returnType="boolean" access="private" output="false" hint="Checks if an xml key is defined">
	<cfargument name="xml"	type="xml"		required="true"	hint="Xml element to check for the path" />
	<cfargument name="path"	type="string"	required="true"	hint="Path to check for existance" />

	<cfset local.exists = true />
	<cfset local.xml		= arguments.xml />

	<cfloop list="#arguments.path#" index="local.key" delimiters=".">
		<cfif structKeyExists(local.xml,trim(local.key))>
			<cfset local.xml = local.xml[local.key] />
		<cfelse>
			<cfset local.exists = false />

			<cfloop array="#local.xml.xmlChildren#" index="local.child">
				<cfif local.child.xmlName EQ local.key>
					<cfset local.xml		= local.child />
					<cfset local.exists	= true />
					<cfbreak />
				</cfif>
			</cfloop>

			<cfif NOT local.exists><cfbreak /></cfif>
		</cfif>
	</cfloop>

	<cfreturn local.exists />
</cffunction>


<cffunction name="property" returnType="string" access="public" output="false" hint="Gets a property of the payment object">
	<cfargument name="property" type="string" required="true" hint="Property name to get the value from" />

	<cfswitch expression="#lCase(arguments.property)#">
		<cfcase value="localurl">
			<cfset local.value = iif(cgi.https EQ 'on',de('https'),de('http')) & '://' & cgi.http_host />
		</cfcase>

		<cfcase value="apiurl">
			<cfset local.value = 'https://api.sofort.com/api/xml' />
		</cfcase>

		<cfcase value="interfaceversion">
			<cfset local.value = 'Slatwall v' />
		</cfcase>

		<cfdefaultcase>
			<cfset local.value = '' />
		</cfdefaultcase>
	</cfswitch>

	<cfreturn local.value />
</cffunction>

</cfcomponent>