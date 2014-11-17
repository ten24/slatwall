<cfcomponent accessors="true" output="false" implements="Slatwall.integrationServices.PaymentInterface" extends="Slatwall.integrationServices.BasePayment">

<cffunction name="init" returnType="any" access="public" output="false">
	<cfreturn this />
</cffunction>


<cffunction name="getPaymentMethodTypes" access="public" returntype="string">
	<cfreturn 'creditCard' />
</cffunction>


<cffunction name="getSupportedTransactionTypes" access="public" returntype="string">
	<cfreturn 'authorize,authorizeAndCharge,chargePreAuthorization' />
</cffunction>


<cffunction name="processCreditCard" returnType="any" access="public" hint="Does Credit Card procession">
	<cfargument name="requestBean" type="any" required="true" hint="" />

	<cfif structKeyExists(url,'ret_status')>
		<cfset local.responseBean = getTransient('creditCardTransactionResponseBean') />

		<cfset local.requestIsValid	= NOT len(setting('transactionSecurityKey')) OR NOT structKeyExists(url,'ret_param_checksum') />
		<cfif NOT local.requestIsValid>
			<cfset local.paramChecksum = '' />

			<cfloop list="trxuser_id,trx_amount,trx_currency,ret_authcode,ret_booknr" index="local.param">
				<cfif structKeyExists(url,local.param)>
					<cfset local.paramChecksum = '#local.paramChecksum##url[local.param]#' />
				</cfif>
			</cfloop>

			<cfset local.paramChecksum	= lCase(hash('#local.paramChecksum##setting("transactionSecurityKey")#')) />
			<cfset local.requestIsValid	= structKeyExists(url,'ret_param_checksum') AND NOT compare(local.paramChecksum,url.ret_param_checksum) />
		</cfif>

		<cfif local.requestIsValid>
			<cfif url.ret_status EQ 'SUCCESS'>
				<cfset local.responseBean.setAmountAuthorized(arguments.requestBean.getTransactionAmount()) />
				<cfif listFindNoCase('authorizeAndCharge,chargePreAuthorization',arguments.requestBean.getTransactionType())>
					<cfset local.responseBean.setAmountCharged(arguments.requestBean.getTransactionAmount()) />
				</cfif>

				<cfif structKeyExists(url,'ret_booknr')>
					<cfset local.responseBean.setTransactionId(url.ret_booknr) />
				</cfif>

			<cfelse>
				<cfif structKeyExists(url,'ret_errorCode') AND structKeyExists(url,'ret_errorMsg')>
					<cfset local.responseBean.addError(url.ret_errorCode,url.ret_errorMsg) />
				<cfelse>
					<cfset local.responseBean.addError(400,'Bad Request: #cgi.query_string#') />
				</cfif>
			</cfif>

		<cfelse>
			<cfset local.responseBean.addError(400,'Bad Request: ret_param_checksum is invalid') />
		</cfif>
	<cfelse>
		<cfset local.url = paymentURL(arguments.requestBean) />

		<cfif len(local.url)>
			<cflocation url="#local.url#" addToken="false" />
		</cfif>

		<cfthrow message="Can't redirect to 1&1 ipayment due to bad url: #local.url#" />
	</cfif>

	<cfreturn local.responseBean />
</cffunction>


<cffunction name="getApiURL" returnType="string" access="public" output="false">
	<cfreturn 'https://ipayment.de/merchant/#setting('accountId')#/processor/2.0/' />
</cffunction>


<cffunction name="paymentURL" returnType="string" access="private" output="false" hint="Builds an API URL">
	<cfargument name="requestBean" type="any" required="true" hint="The Slatwall cart object" />

	<cfset local.url = '' />

	<cfif NOT isNull(arguments.requestBean.getSecurityCode())>
		<cfset local.args = structNew() />
		<cfset local.args['trxuser_id']								= setting('applicationId') />
		<cfset local.args['trxpassword']							= setting('applicationPassword') />
		<cfset local.args['invoice_text']							= left(setting('invoiceText'),25) />
		<cfset local.args['silent']										= 1 />
		<cfset local.args['redirect_url']							= fullyQualifyURL('?') />
		<cfset local.args['silent_error_url']					= fullyQualifyURL('?') />
		<cfset local.args['trx_currency']							= setting('currency') />
		<cfset local.args['trx_amount']								= arguments.requestBean.getTransactionAmount() * 100 />
		<cfset local.args['shopper_id']								= arguments.requestBean.getOrderPaymentId() />
		<cfset local.args['addr_name']								= arguments.requestBean.getNameOnCreditCard() />
		<cfset local.args['addr_street'] 							= arguments.requestBean.getBillingStreetAddress() />
		<cfset local.args['addr_city']								= arguments.requestBean.getBillingCity() />
		<cfset local.args['addr_zip']									= arguments.requestBean.getBillingPostalCode() />
		<cfset local.args['addr_country']							= arguments.requestBean.getBillingCountryCode() />
		<cfset local.args['cc_number']								= arguments.requestBean.getCreditCardNumber() />
		<cfset local.args['cc_expdate_month']					= arguments.requestBean.getExpirationMonth() />
		<cfset local.args['cc_expdate_year']					= arguments.requestBean.getExpirationYear() />
		<cfset local.args['cc_checkcode']							= arguments.requestBean.getSecurityCode() />
		<cfset local.args['advanced_strict_id_check'] = 1 />
		<cfset local.args['trx_paymenttyp']						= 'cc' />
		<cfset local.args['trx_typ']									= 'auth' />

		<cfset local.creditCardTypeList	= 'MasterCard,VisaCard,AmexCard,DinersClubCard,JCBCard,SoloCard,DiscoverCard,MaestroCard' />
		<cfset local.creditCardTypePos	= listContainsNoCase(local.creditCardTypeList,arguments.requestBean.getCreditCardType()) />

		<cfif local.creditCardTypePos>
			<cfset local.args['cc_typ']									= listGetAt(local.creditCardTypeList,local.creditCardTypePos) />
			<cfset local.args['ignore_cc_typ_mismatch']	= 1 />
		</cfif>

		<cfif arguments.requestBean.getTransactionType() EQ 'chargePreAuthorization'>
			<cfset local.args['trx_typ'] = 'preauth' />
		</cfif>

		<cfif len(setting('transactionSecurityKey'))>
			<cfset local.args['trx_securityhash'] = lCase(hash('#local.args.trxuser_id##local.args.trx_amount##local.args.trx_currency##local.args.trxpassword##setting("transactionSecurityKey")#')) />
		</cfif>

		<cfset local.queryString = '' />
		<cfloop collection="#local.args#" item="local.key">
			<cfset local.queryString = listAppend(local.queryString,'#lCase(local.key)#=#urlEncodedFormat(local.args[local.key])#','&') />
		</cfloop>

		<cfset local.url = '#getApiURL()#?#local.queryString#' />
	</cfif>

	<cfreturn local.url />
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

</cfcomponent>