<?xml version="1.0" encoding="UTF-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
<cfsilent>
	<cfparam name="requestMessageData" type="struct" default="#structNew()#" />
</cfsilent>
	<cfoutput>
	<soapenv:Header>
		<wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
			<wsse:UsernameToken>
				<wsse:Username>#requestMessageData.merchantID#</wsse:Username>
				<wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wssusername-token-profile-1.0##PasswordText">#requestMessageData.transactionKey#</wsse:Password>
			</wsse:UsernameToken>
		</wsse:Security>
	</soapenv:Header>
	<soapenv:Body>
		<requestMessage xmlns="urn:schemas-cybersource-com:transaction-data-#requestMessageData.soapApiVersion#">
			<cfif structKeyExists(requestMessageData, 'requestMessageTemplateFileName')>
				<cfinclude template="messagetemplate/#requestMessageData.requestMessageTemplateFileName#">
			<cfelse>
				<cfthrow message="Missing template file. There was no template specified by 'messageData.requestMessageTemplateFileName'." />
			</cfif>
		</requestMessage>
	</soapenv:Body>
	</cfoutput>
</soapenv:Envelope>