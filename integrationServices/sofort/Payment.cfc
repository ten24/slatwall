<cfcomponent accessors="true" extends="Slatwall.integrationServices.BasePayment" implements="Slatwall.integrationServices.PaymentInterface" hint="SOFORT Überweisung Slatwall v3 Payment">

<cfproperty name="apiURL"	setter="false" />
<cfproperty name="successStates" setter="false" />


<cffunction name="init" returnType="any" access="public">
	<cfset variables.apiURL					= 'https://api.sofort.com/api/xml' />
	<cfset variables.successStates	= 'pending,received,untraceable' />

	<cfreturn this />
</cffunction>


<cffunction name="getPaymentMethodTypes" returntype="string" access="public">
	<cfreturn 'external' />
</cffunction>


<cffunction name="getSupportedTransactionTypes" access="public" returntype="string">
	<cfreturn 'authorize,authorizeAndCharge,chargePreAuthorization' />	<!--- todo:MarcoBetschart/ 2013.07.29 7:19:53 AM - has to be changed as soon as Slatwall v3 supports transactionTypes for optCharge in terms of external payment --->
</cffunction>


<cffunction name="getExternalPaymentHTML" returntype="string" access="public">
	<cfsavecontent variable="local.html"><cfoutput>
		<a href="?slatAction=public:cart.addOrderPayment&newOrderPayment.paymentMethod.paymentMethodID=#paymentMethod.getPaymentMethodID()#">
			<img src="#getFullyQualifiedAssetURL()#/images/sofort.png" align="left" style="margin-right:7px;">
		</a>
	</cfoutput></cfsavecontent>

	<cfreturn local.html />
</cffunction>


<cffunction name="processExternal" returnType="any" access="public">
	<cfargument name="requestBean" type="any" required="true" />

	<cfset local.order					= getService('orderService').getOrder(arguments.requestBean.getOrderID()) />
	<cfset local.orderPayment		= getService('orderService').getOrderPayment(arguments.requestBean.getOrderPaymentId()) />
	<cfset local.paymentMethod	= local.orderPayment.getPaymentMethod() />

	<cfif structKeyExists(url,'transactionId')>
		<cfset arguments.requestBean.setTransactionId(url.transactionId) />

		<cfset local.responseBean		= getTransient('externalTransactionResponseBean') />
		<cfset local.response				= requestExternalState(local.paymentMethod,arguments.requestBean.getTransactionId()) />

		<cfif xmlPathExists(local.response,'transactions.transaction_details.status')>
			<cfset local.responseBean.setStatusCode(local.response.transactions.transaction_details.status.xmlText) />

			<cfif listFindNoCase(getSuccessStates(true),local.response.transactions.transaction_details.status.xmlText)>
				<cfif xmlPathExists(local.response,'transactions.transaction_details.amount')>
					<cfset local.responseBean.setAmountReceived(local.response.transactions.transaction_details.amount.xmlText) />
				</cfif>

			<cfelse>
				<cfset local.responseBean.addError(local.response.transactions.transaction_details.status.xmlText,local.response.transactions.transaction_details.status_reason.xmlText) />
			</cfif>
		</cfif>

		<cfif xmlPathExists(local.response,'transactions.transaction_details.project_id')>
			<cfset local.responseBean.setAuthorizationCode(local.response.transactions.transaction_details.project_id.xmlText) />
		</cfif>

		<cfset local.responseBean.setSecurityCodeMatchFlag(true) />
		<cfset local.responseBean.setAVSCode('Y') />

	<cfelse>
		<cfset local.response	= initiateExternal(paymentMethod=local.paymentMethod,order=local.order) />

		<cfif isXml(local.response) AND xmlPathExists(local.response,'new_transaction.payment_url')>
			<cflocation url="#local.response.new_transaction.payment_url.xmlText#" addToken="false" />

		<cfelse>
			<cfthrow message="Could not initiate SOFORT Überweisen payment" />
		</cfif>
	</cfif>

	<cfreturn local.responseBean />
</cffunction>


<cffunction name="initiateExternal" returnType="any" access="public" output="false">
	<cfargument name="paymentMethod"	type="any"	required="true" />
	<cfargument name="order"					type="any"	required="true" />

	<cfoutput><cfxml variable="local.xml">
		<multipay>
			<project_id>#xmlFormat(setting('projectId'))#</project_id>
			<language_code>#xmlFormat(setting('language'))#</language_code>
			<amount>#xmlFormat(arguments.order.getTotal())#</amount>
			<currency_code>#xmlFormat(setting('currency'))#</currency_code>
			<reasons>
				<cfloop array="#arguments.order.getOrderItems()#" index="local.orderItem">
					<reason>#xmlFormat(left(reReplaceNoCase(local.orderItem.getSku().getProduct().getProductName(),'[^0-9a-z\s\+\-,\.]','','all'),27))#</reason>
				</cfloop>
			</reasons>
			<success_url>#xmlFormat(fullyQualifyURL('?transactionId=-TRANSACTION-'))#</success_url>
			<abort_url>#xmlFormat(fullyQualifyURL('?transactionId=-TRANSACTION-'))#</abort_url>
			<su>
				<customer_protection>1</customer_protection>
			</su>
		</multipay>
	</cfxml></cfoutput>

	<cfreturn apiRequest(local.xml) />
</cffunction>


<cffunction name="requestExternalState" returnType="any" access="public" output="false">
	<cfargument name="paymentMethod"	type="any"	required="true" />
	<cfargument name="transactionId"	type="any"	required="true" />

	<cfoutput><cfxml variable="local.xml">
		<transaction_request version="2">
			<transaction>#xmlFormat(arguments.transactionId)#</transaction>
		</transaction_request>
	</cfxml></cfoutput>

	<cfreturn apiRequest(local.xml) />
</cffunction>


<cffunction name="getSuccessStates" returnType="string" access="public" output="false">
	<cfargument name="considerUntraceableSetting"	type="boolean" required="false" default="false" />

	<cfset local.states = variables.successStates />

	<cfif arguments.considerUntraceableSetting AND NOT setting('assumeUntraceableAsSuccess')>
		<cfset local.states = listDeleteAt(local.successState,listFind(local.successStates,'untraceable')) />
	</cfif>

	<cfreturn local.states />
</cffunction>


<cffunction name="apiRequest" returnType="any" access="private" output="false">
	<cfargument name="xml" type="any" required="true" />

	<cfset local.response = structNew() />

	<cfhttp method="post" url="#getApiURL()#" result="local.response" username="#setting('CustomerID')#" password="#setting('APIKey')#">
		<cfhttpparam type="header" name="Content-Type" value="application/xml" />
		<cfhttpparam type="body" value="#xmlNodeTrim(arguments.xml)#" />
	</cfhttp>

	<cfif structKeyExists(local.response,'fileContent') AND len(local.response.fileContent)>
		<cfset local.response = xmlParse(local.response.fileContent) />
	</cfif>

	<cfreturn local.response />
</cffunction>


<cffunction name="getFullyQualifiedAssetURL" returnType="string" access="public" output="false">
	<cfreturn fullyQualifyURL(url='/Slatwall/integrationServices/sofort/assets',useCgiPathInfo=false,sesOmitIndex=true) />
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