<cfcomponent accessors="true" extends="Slatwall.integrationServices.BasePayment" implements="Slatwall.integrationServices.PaymentInterface" hint="Click & Buy Slatwall v3 Payment">

<cfproperty name="apiURL"	setter="false" />
<cfproperty name="apiVersion"	setter="false" />
<cfproperty name="successStates"	setter="false" />


<cffunction name="init" returnType="any" access="public">
	<cfset variables.apiURL					= 'https://api.clickandbuy.com/webservices/soap/pay_1_1_0' />
	<cfset variables.sandboxURL			= 'https://api.clickandbuy-s1.com/webservices/soap/pay_1_1_0' />
	<cfset variables.apiVersion			= 'http://api.clickandbuy.com/webservices/pay_1_1_0/' />
	<cfset variables.successStates	= 'SUCCESS,IN_PROGRESS,PAYMENT_PENDING,PAYMENT_GUARANTEE' />

	<cfreturn this />
</cffunction>


<cffunction name="getPaymentMethodTypes" returntype="string" access="public">
	<cfreturn 'external' />
</cffunction>


<cffunction name="getSupportedTransactionTypes" access="public" returntype="string">
	<cfreturn 'authorize,authorizeAndCharge,chargePreAuthorization' />	<!--- todo:MarcoBetschart/ 2013.07.29 7:19:53 AM - has to be changed as soon as Slatwall v3 supports transactionTypes for optCharge in terms of external payment --->
</cffunction>


<cffunction name="getExternalPaymentHTML" returntype="string" access="public">
	<cfargument name="paymentMethod" type="any" required="true" />

	<cfsavecontent variable="local.html"><cfoutput>
		<a href="?slatAction=public:cart.addOrderPayment&newOrderPayment.paymentMethod.paymentMethodID=#arguments.paymentMethod.getPaymentMethodID()#">
			<img src="#getFullyQualifiedAssetURL()#/images/clickandbuy.png" align="left" style="margin-right:7px;">
		</a>
	</cfoutput></cfsavecontent>

	<cfreturn local.html />
</cffunction>


<cffunction name="processExternal" returnType="any" access="public">
	<cfargument name="requestBean" type="any" required="true" />

	<cfset local.order					= getService('orderService').getOrder(arguments.requestBean.getOrderID()) />
	<cfset local.orderPayment		= getService('orderService').getOrderPayment(arguments.requestBean.getOrderPaymentId()) />
	<cfset local.paymentMethod	= local.orderPayment.getPaymentMethod() />

	<cfif structKeyExists(url,'clickandbuy')>
		<cfset local.responseBean	= getTransient('externalTransactionResponseBean') />
		<cfset local.response			= requestExternalState(arguments.requestBean) />

		<cfif isXml(local.response) AND xmlPathExists(local.response,'ns2:transactionList.ns2:transaction')>
			<cfset local.responseBean.setTransactionId(local.response['ns2:transactionList']['ns2:transaction']['ns2:transactionID'].xmlText) />

			<cfif xmlPathExists(local.response,'n2:transactionList.ns2:transaction.ns2:errorDetails')>
				<cfset local.responseBean.addError(local.response['ns2:transactionList']['ns2:transaction']['ns2:errorDetails']['ns2:detailCode'].xmlText,local.response['ns2:transactionList']['ns2:transaction']['ns2:errorDetails']['ns2:description'].xmlText) />

			<cfelse>
				<cfset local.responseBean.setStatusCode(local.response['ns2:transactionList']['ns2:transaction']['ns2:transactionStatus'].xmlText) />

				<cfif listFindNoCase(getSuccessStates(),local.responseBean.getStatusCode())>
					<cfset local.responseBean.setAmountReceived(local.order.getTotal()) />

				<cfelseif local.responseBean.getStatusCode() NEQ 'ABORTED'>
					<cfset local.responseBean.addError(local.responseBean.getStatusCode(),'"#local.responseBean.getStatusCode()#" is not a valid success state. Valid success states are: #getSuccessStates()#') />
				</cfif>
			</cfif>

		<cfelse>
			<cfthrow message="Invalid response from Click & Buy: #local.response#" />
		</cfif>

	<cfelse>
		<cfset local.response	= initiateExternal(arguments.requestBean) />

		<cfif isXml(local.response) AND xmlPathExists(local.response,'ns2:transaction.ns2:redirectURL')>
			<cflocation url="#local.response['ns2:transaction']['ns2:redirectURL'].xmlText#" addToken="false" />

		<cfelse>
			<cfthrow message="Could not initiate Click & Buy payment" />
		</cfif>
	</cfif>

	<cfreturn local.responseBean />
</cffunction>


<cffunction name="initiateExternal" returnType="any" access="public" output="false">
	<cfargument name="requestBean" type="any" required="true" />

	<cfset local.order = getService('orderService').getOrder(arguments.requestBean.getOrderID()) />

	<cfoutput><cfxml variable="local.xml">
		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
			<soapenv:Header/>
			<soapenv:Body>
				<payRequest_Request xmlns="#xmlFormat(getApiVersion())#">
					<authentication>
						<merchantID>#xmlFormat(setting('merchantId'))#</merchantID>
						<projectID>#xmlFormat(setting('projectId'))#</projectID>
						<token>#xmlFormat(generateToken(setting('projectId'),setting('secretKey')))#</token>
					</authentication>
					<details>
						<amount>
							<amount>#xmlFormat(local.order.getTotal())#</amount>
							<currency><cfif len(local.order.getCurrencyCode()) EQ 3>#xmlFormat(local.order.getCurrencyCode())#<cfelse>#xmlFormat(setting('currency'))#</cfif></currency>
						</amount>
						<orderDetails>
							<text>#xmlFormat(setting('projectDescription'))#</text>
						</orderDetails>
						<successURL>#xmlFormat(fullyQualifyURL('?clickandbuy=success'))#</successURL>
						<failureURL>#xmlFormat(fullyQualifyURL('?clickandbuy=failure'))#</failureURL>
						<externalID>#xmlFormat(generateExternalID(arguments.requestBean.getOrderId()))#</externalID>
					</details>
				</payRequest_Request>
			</soapenv:Body>
		</soapenv:Envelope>
	</cfxml></cfoutput>

	<cfreturn apiRequest(local.xml,'payRequest') />
</cffunction>


<cffunction name="requestExternalState" returnType="any" access="public" output="false">
	<cfargument name="requestBean" type="any" required="true" />

	<cfoutput><cfxml variable="local.xml">
		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
			<soapenv:Header/>
			<soapenv:Body>
				<statusRequest_Request xmlns="#xmlFormat(getApiVersion())#">
					<authentication>
						<merchantID>#xmlFormat(setting('merchantId'))#</merchantID>
						<projectID>#xmlFormat(setting('projectId'))#</projectID>
						<token>#xmlFormat(generateToken(setting('projectId'),setting('secretKey')))#</token>
					</authentication>
					<details>
						<cfif len(arguments.requestBean.getOriginalProviderTransactionID())>
							<transactionIDList>
								<transactionID>#xmlFormat(arguments.requestBean.getOriginalProviderTransactionID())#</transactionID>
							</transactionIDList>
						<cfelse>
							<externalIDList>
								<externalID>#xmlFormat(getExternalId(arguments.requestBean.getOrderId()))#</externalID>
							</externalIDList>
						</cfif>
					</details>
				</statusRequest_Request>
			</soapenv:Body>
		</soapenv:Envelope>
	</cfxml></cfoutput>

	<cfreturn apiRequest(local.xml,'statusRequest') />
</cffunction>


<cffunction name="apiRequest" returnType="any" access="private" output="false">
	<cfargument name="xml"		type="any"		required="true" />
	<cfargument name="method"	type="string"	required="true" />

	<cfset local.response = structNew() />

	<cfhttp method="post" url="#getApiURL()#" result="local.response">
		<cfhttpparam type="header" name="SOAPAction" value="#getApiVersion()##arguments.method#" />
		<cfhttpparam type="header" name="accept-encoding" value="no-compression" />
		<cfhttpparam type="xml" value="#xmlNodeTrim(arguments.xml)#" />
	</cfhttp>

	<cfif structKeyExists(local.response,'fileContent') AND len(local.response.fileContent)>
		<cfset local.response = xmlSOAPTrim(xmlParse(local.response.fileContent)) />
	</cfif>

	<cfreturn local.response />
</cffunction>


<cffunction name="getFullyQualifiedAssetURL" returnType="string" access="public" output="false">
	<cfreturn fullyQualifyURL(url='/Slatwall/integrationServices/clickandbuy/assets',useCgiPathInfo=false,sesOmitIndex=true) />
</cffunction>


<cffunction name="generateToken" returnType="string" access="public" output="false" hint="Generate the Token for API authentication">
	<cfargument name="projectID"	type="string"	required="true" hint="ID from Project" />
	<cfargument name="secretKey"	type="string"	required="true" hint="SecretKey from the ClickAndBuy account" />

	<cfset local.utc				= dateAdd('s',getTimezoneInfo().utcTotalOffset,now()) />
	<cfset local.timestamp	= lsDateFormat(local.utc,'yyyymmdd') & lsTimeFormat(local.utc,'HHmmss') />

	<cfreturn '#local.timestamp#::#hash('#trim(arguments.projectID)#::#trim(arguments.secretKey)#::#local.timestamp#','SHA')#' />
</cffunction>


<cffunction name="generateExternalID" returnType="string" access="public" output="false">
	<cfargument name="orderId" type="string" required="true" />

	<cfparam name="session.clickandbuy.externalIDs"	type="struct"	default="#structNew()#" />
	<cfset session.clickandbuy.externalIDs['order_#arguments.orderId#'] = createUUID() />

	<cfreturn session.clickandbuy.externalIDs['order_#arguments.orderId#'] />
</cffunction>


<cffunction name="getExternalID" returnType="string" access="public" output="false">
	<cfargument name="orderId" type="string" required="true" />

	<cfparam name="session.clickandbuy.externalIDs.order_#arguments.orderId#"	type="string"	default="" />

	<cfreturn session.clickandbuy.externalIDs['order_#arguments.orderId#'] />
</cffunction>


<cffunction name="getApiURL" returnType="string" access="public" output="false">
	<cfset local.apiURL = variables.apiURL />

	<cfif yesNoFormat(setting('sandboxIsActive'))>
		<cfset local.apiURL = variables.sandboxURL />
	</cfif>

	<cfreturn local.apiURL />
</cffunction>


<cffunction name="fullyQualifyURL" returnType="string" access="private" output="false">
	<cfargument name="url"							type="string"		required="true" />
	<cfargument name="useCgiPathInfo"		type="boolean"	required="false"	default="true" />
	<cfargument name="useCgiScriptName"	type="boolean"	required="false"	default="true" />
	<cfargument name="sesOmitIndex"			type="boolean"	required="false"	default="false" />
	<cfargument name="useCgiServerName"	type="boolean"	required="false"	default="true" />
	<cfargument name="useCgiHttps"			type="boolean"	required="false"	default="true" />

	<cfif arguments.useCgiPathInfo AND len(cgi.path_info) AND NOT findNoCase(cgi.path_info,arguments.url) EQ 1>
		<cfset arguments.url = '#cgi.path_info##arguments.url#' />
	</cfif>

	<cfif arguments.useCgiScriptName AND NOT findNoCase(cgi.script_name,arguments.url) EQ 1>
		<cfset arguments.url = '#cgi.script_name##arguments.url#' />
	</cfif>

	<cfif arguments.sesOmitIndex>
		<cfset arguments.url = replaceNoCase(arguments.url,'/index.cfm','') />
	</cfif>

	<cfif arguments.useCgiServerName AND NOT findNoCase(cgi.server_name,arguments.url) EQ 1>
		<cfset arguments.url = '#cgi.server_name##arguments.url#' />
	</cfif>

	<cfif arguments.useCgiHttps AND cgi.https EQ 'on' AND NOT findNoCase('https://',arguments.url) EQ 1>
		<cfset arguments.url = 'https://#arguments.url#' />

	<cfelseif arguments.useCgiHttps AND cgi.https NEQ 'on' AND NOT findNoCase('http://',arguments.url) EQ 1>
		<cfset arguments.url = 'http://#arguments.url#' />
	</cfif>

	<cfreturn arguments.url />
</cffunction>


<cffunction name="xmlNodeTrim" returnType="any" access="public">
	<cfargument name="xml" type="any" required="true" />

	<cfset local.xml = reReplace(toString(arguments.xml),'>\s+','>','all') />

	<cfif isXml(arguments.xml)>
		<cfreturn xmlParse(local.xml) />
	</cfif>

	<cfreturn local.xml />
</cffunction>


<cffunction name="xmlSOAPTrim" returnType="any" access="public" output="false">
	<cfargument name="xml" type="any" required="true" />

	<cfif isXml(arguments.xml) AND xmlPathExists(arguments.xml,'soap-env:envelope.soap-env:body')>
		<cfset arguments.xml = arguments.xml['soap-env:envelope']['soap-env:body'].xmlChildren[1] />
	</cfif>

	<cfreturn arguments.xml />
</cffunction>


<cffunction name="xmlPathExists" returnType="boolean" access="public" output="false" hint="Checks if an xml key is defined">
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

</cfcomponent>