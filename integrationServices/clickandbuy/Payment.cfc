<cfcomponent accessors="true" output="false" implements="Slatwall.integrationServices.PaymentInterface" extends="Slatwall.integrationServices.BasePayment">

<cffunction name="newPayment" returnType="string" access="public" output="false">
	<cfargument name="cart" required="true" hint="cart with all order-items" />

	<cfset local.paymentService = arguments.cart.getService('paymentService') />
	<cfset local.paymentMethods	= entityLoad('SlatwallPaymentMethod',{ paymentIntegration=getIntegration() },{ maxResults=1 }) />
	<cfset local.paymentMethod	= local.paymentMethods[1] />

	<cfset local.orderPayment = local.paymentService.newOrderPayment() />
	<cfset local.orderPayment.setPaymentMethodType(getPaymentMethodTypes()) />
	<cfset local.orderPayment.setPaymentMethod(local.paymentMethod) />
	<cfset local.orderPayment.setCurrencyCode(arguments.cart.getCurrencyCode()) />
	<cfset arguments.cart.addOrderPayment(local.orderPayment) />
	<cfset ormFlush() />

	<cfset local.successUrl	= urlSessionFormat('#property('localURL')##$.createHREF(filename='checkout')#?payment=success&slatAction=clickandbuy:payment.verify#chr(35)#payment') />
	<cfset local.abortUrl		= urlSessionFormat('#property('localURL')##$.createHREF(filename='checkout')#?payment=abort&slatAction=clickandbuy:payment.abort#chr(35)#payment') />

	<cfsavecontent variable="local.soapBody"><cfoutput>
		<pay:payRequest_Request>
			<pay:authentication>
				<pay:merchantID>#xmlFormat(trim(setting('merchantId')))#</pay:merchantID>
				<pay:projectID>#xmlFormat(trim(setting('projectId')))#</pay:projectID>
				<pay:token>#xmlFormat(generateToken(setting('projectId'),setting('secretKey')))#</pay:token>
			</pay:authentication>
			<pay:details>
				<cfif len(trim(setting('consumerLanguage'))) EQ 2><pay:consumerLanguage>#xmlFormat(trim(setting('consumerLanguage')))#</pay:consumerLanguage></cfif>
				<pay:amount>
					<pay:amount>#xmlFormat(arguments.cart.getTotal())#</pay:amount>
					<cfif len(trim(setting('currency'))) EQ 3><pay:currency>#xmlFormat(trim(setting('currency')))#</pay:currency></cfif>
				</pay:amount>
				<pay:orderDetails>
					<cfif len(setting('projectDescription'))><pay:text>#xmlFormat(setting('projectDescription'))#</pay:text></cfif>
					<pay:itemList>
						<cfif setting('transferProductNames')>
							<cfloop array="#arguments.cart.getOrderItems()#" index="local.orderItem">
								<pay:item>
									<pay:itemType>#xmlFormat('TEXT')#</pay:itemType>
									<pay:description>#xmlFormat(local.orderItem.getSku().getProduct().getTitle())#</pay:description>
								</pay:item>
							</cfloop>
						</cfif>
					</pay:itemList>
				</pay:orderDetails>
				<pay:successURL>#xmlFormat(local.successUrl)#</pay:successURL>
				<pay:failureURL>#xmlFormat(local.abortUrl)#</pay:failureURL>
				<pay:externalID>#xmlFormat(local.orderPayment.getOrderPaymentId())#</pay:externalID>
			</pay:details>
		</pay:payRequest_Request>
	</cfoutput></cfsavecontent>

	<cfset local.response = doRequest(local.soapBody,'payRequest') />

	<cfif hasError(local.response)>
		<cfset local.returnValue = errorCode(local.response) />
	<cfelse>
		<cfset local.returnValue = redirectURL(local.response) />
	</cfif>

	<cfreturn local.returnValue />
</cffunction>


<cffunction name="verifyPayments" returnType="any" access="public" output="false">
	<cfargument name="cart" required="true" hint="cart with all order-items" />

	<cfset local.paymentService	= $.slatwall.getService('paymentService') />
	<cfset local.paymentMethods	= entityLoad('SlatwallPaymentMethod',{ paymentIntegration=getIntegration() },{ maxResults=1 }) />
	<cfset local.paymentMethod	= local.paymentMethods[1] />

	<cfloop array="#arguments.cart.getOrderPayments()#" index="local.orderPayment">
		<cfif local.orderPayment.hasPaymentMethod() AND local.orderPayment.getPaymentMethod().getPaymentMethodId() EQ local.paymentMethod.getPaymentMethodId()>
			<cfset local.transactionStatus	= variables.transactionStatus(local.orderPayment) />

			<cfset local.paymentTransaction	= local.paymentService.newPaymentTransaction() />
			<cfset local.paymentTransaction.setTransactionDateTime(now()) />
			<cfset local.paymentTransaction.setCurrencyCode(arguments.cart.getCurrencyCode()) />
			<cfset local.paymentTransaction.setProviderTransactionId(transactionId(local.orderPayment)) />

			<cfif listFindNoCase('SUCCESS,PAYMENT_GUARANTEE',local.transactionStatus)>
				<cfset local.orderPayment.setAmount(arguments.cart.getTotal()) />
				<cfset local.orderPayment.setAmountCharged(arguments.cart.getTotal()) />
				<cfset local.paymentTransaction.setAmountAuthorized(local.orderPayment.getAmount()) />
			</cfif>

			<cfset local.orderPayment.addPaymentTransaction(local.paymentTransaction) />
		</cfif>
	</cfloop>

	<cfset ormFlush() />
</cffunction>


<cffunction name="getPaymentMethodTypes" access="public" returntype="string" hint="Get Payment-Method-Types">
	<cfreturn 'external' />
</cffunction>


<cffunction name="redirectURL" returnType="string" access="public" output="false" hint="Redirect url for payment">
	<cfargument name="soapResponse" type="xml" required="true" hint="SOAP response to get redirect url" />

	<cfset local.url = '' />

	<cfif xmlPathExists(arguments.soapResponse,'ns2:transaction.ns2:redirectURL')>
		<cfset local.url = arguments.soapResponse['ns2:transaction']['ns2:redirectURL'].xmlText />
	<cfelse>
		<cflog text="redirectURL missing: #toString(arguments.soapResponse)#" file="clickandbuy" type="error" />
	</cfif>

	<cfreturn local.url />
</cffunction>


<cffunction name="errorCode" returnType="string" access="public" output="false" hint="Get the error-code">
	<cfargument name="soapResponse" type="xml" required="true" hint="SOAP response to check" />

	<cfset local.errorCode = '' />

	<cfif xmlPathExists(arguments.soapResponse,'detail.ns2:errorDetails.ns2:detailCode')>
		<cfset local.errorCode = arguments.soapResponse['detail']['ns2:errorDetails']['ns2:detailCode'].xmlText />
	<cfelse>
		<cflog text="errorCode missing: #toString(arguments.soapResponse)#" file="clickandbuy" type="error" />
	</cfif>

	<cfreturn local.errorCode />
</cffunction>


<cffunction name="hasError" returnType="boolean" access="public" output="false" hint="Check if has errors from SOAP">
	<cfargument name="soapResponse" type="xml" required="true" hint="SOAP response to check" />

	<cfreturn arguments.soapResponse.xmlName EQ 'SOAP-ENV:Fault'>
</cffunction>


<cffunction name="eliminateSoap" returnType="xml" access="public" output="false" hint="Eliminate the SOAP-wrapper">
	<cfargument name="soapResponse" type="xml" required="true"	hint="Soap response with all SOAP-wrapper" />

	<cfreturn arguments.soapResponse.xmlRoot['SOAP-ENV:Body'].xmlChildren[1] />
</cffunction>


<cffunction name="transactionId" returnType="string" access="public" output="false" hint="Get the transaction Id">
	<cfargument name="orderPayment" required="true" hint="Order payment" />

	<cfset local.transactionId	= '' />
	<cfset local.soap						= requestStatus(arguments.orderPayment) />

	<cfif xmlPathExists(local.soap,'ns2:transactionList.ns2:transaction.ns2:transactionID')>
		<cfset local.transactionId = local.soap['ns2:transactionList']['ns2:transaction']['ns2:transactionID'].xmlText />
	<cfelse>
		<cflog text="transactionId missing: #toString(local.soap)#" file="clickandbuy" type="error" />
	</cfif>

	<cfreturn local.transactionId />
</cffunction>


<cffunction name="transactionStatus" returnType="string" access="public" output="false" hint="Get the transaction status">
	<cfargument name="orderPayment" required="true" hint="Order payment" />

	<cfset local.status = '' />
	<cfset local.soap		= requestStatus(arguments.orderPayment) />

	<cfif xmlPathExists(local.soap,'ns2:transactionList.ns2:transaction.ns2:transactionStatus')>
		<cfset local.status = local.soap['ns2:transactionList']['ns2:transaction']['ns2:transactionStatus'].xmlText />
	<cfelse>
		<cflog text="transactionStatus missing: #toString(local.soap)#" file="clickandbuy" type="error" />
	</cfif>

	<cfreturn local.status />
</cffunction>


<cffunction name="generateToken" returnType="string" access="public" output="false" hint="Generate the token for authentication">
	<cfargument name="projectID"	type="string"	required="true" hint="ID from Project" />
	<cfargument name="secretKey"	type="string"	required="true" hint="SecretKey from the ClickAndBuy account" />

	<cfset local.utc				= dateAdd('s',getTimezoneInfo().utcTotalOffset,now()) />
	<cfset local.timestamp	= lsDateFormat(local.utc,'yyyymmdd') & lsTimeFormat(local.utc,'HHmmss') />

	<cfreturn '#local.timestamp#::#hash('#trim(arguments.projectID)#::#trim(arguments.secretKey)#::#local.timestamp#','SHA')#' />
</cffunction>


<cffunction name="requestStatus" returnType="xml" access="public" output="false" hint="Get status request">
	<cfargument name="orderPayment" required="true" hint="Order payment to check status" />

	<cfsavecontent variable="local.soapBody"><cfoutput>
		<pay:statusRequest_Request>
			<pay:authentication>
				<pay:merchantID>#xmlFormat(trim(setting('merchantId')))#</pay:merchantID>
				<pay:projectID>#xmlFormat(trim(setting('projectId')))#</pay:projectID>
				<pay:token>#xmlFormat(generateToken(setting('projectId'),setting('secretKey')))#</pay:token>
			</pay:authentication>
			<pay:details>
				<pay:externalIDList>
					<pay:externalID>#xmlFormat(arguments.orderPayment.getOrderPaymentId())#</pay:externalID>
				</pay:externalIDList>
			</pay:details>
		</pay:statusRequest_Request>
	</cfoutput></cfsavecontent>

	<cfreturn doRequest(local.soapBody,'statusRequest') />
</cffunction>


<cffunction name="doRequest" access="private" returntype="any" hint="Execute API request">
	<cfargument name="soapBody"	required="true" hint="Content of the request" />
	<cfargument name="method"		required="true" hint="Method to execute" />

	<cfset local.result = '' />

	<cfset arguments.soapBody = reReplace(arguments.soapBody,'>\s+','>','all') />
	<cfsavecontent variable="local.soapBody">
		<cfoutput>
		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pay="#property('apiVersion')#">
			<soapenv:Header/>
			<soapenv:Body>
				#arguments.soapBody#
			</soapenv:Body>
		</soapenv:Envelope>
		</cfoutput>
	</cfsavecontent>
	<cflog text="request: #local.soapBody#" file="clickandbuy" type="information" />

	<cfhttp method="post" url="#property('apiURL')#" result="local.response">
		<cfhttpparam type="header" name="SOAPAction" value="#property('apiVersion')##arguments.method#" />
		<cfhttpparam type="header" name="accept-encoding" value="no-compression" />
		<cfhttpparam type="xml" value="#trim(local.soapBody)#" />
	</cfhttp>

	<cfset local.type = 'error' />
	<cfif isXml(local.response.fileContent)>
		<cfset local.type = 'information' />
		<cfset local.response = eliminateSoap(xmlParse(local.response.fileContent)) />

		<cflog text="response: #toString(local.response)#" file="clickandbuy" type="#local.type#" />
	<cfelse>
		<cflog text="response: #local.response.fileContent#" file="clickandbuy" type="#local.type#" />
	</cfif>

	<cfreturn local.response />
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
			<cfif setting('sandbox')>
				<cfset local.value = variables.property('sandboxURL') />
			<cfelse>
				<cfset local.value = 'https://api.clickandbuy.com/webservices/soap/pay_1_1_0' />
			</cfif>
		</cfcase>

		<cfcase value="apiversion,versionurl">
			<cfset local.value = 'http://api.clickandbuy.com/webservices/pay_1_1_0/' />
		</cfcase>

		<cfcase value="sandboxurl">
			<cfset local.value = 'https://api.clickandbuy-s1.com/webservices/soap/pay_1_1_0' />
		</cfcase>

		<cfdefaultcase>
			<cfset local.value = '' />
		</cfdefaultcase>
	</cfswitch>

	<cfreturn local.value />
</cffunction>

</cfcomponent>