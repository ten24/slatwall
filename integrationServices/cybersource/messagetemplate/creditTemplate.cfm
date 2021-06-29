<cfoutput>
<merchantID>#requestMessageData.merchantID#</merchantID>
<merchantReferenceCode>#requestMessageData.merchantReferenceCode#</merchantReferenceCode>
<!--- "follow-on" or "on-demand" credit, provide reference to prior charge --->
<cfif structKeyExists(requestMessageData, 'creditCaptureRequestID') or structKeyExists(requestMessageData, 'subscriptionID')>
	<purchaseTotals>
		<currency>#requestMessageData.currency#</currency>
		<grandTotalAmount>#requestMessageData.grandTotalAmount#</grandTotalAmount>
	</purchaseTotals>
	
	<!--- "follow-on" credit --->
	<cfif structKeyExists(requestMessageData, 'creditCaptureRequestID')>
		<ccCreditService run="true">
			<captureRequestID>#requestMessageData.creditCaptureRequestID#</captureRequestID>
		</ccCreditService>

	<!--- "on-demand" credit --->
	<cfelseif structKeyExists(requestMessageData, 'subscriptionID')>
		<recurringSubscriptionInfo>
			<subscriptionID>#requestMessageData.subscriptionID#</subscriptionID>
		</recurringSubscriptionInfo>
		<!--- empty service request --->
		<ccCreditService run="true" />
	</cfif>

<!--- "stand-alone" credit, provide credit card information --->
<cfelse>
	<billTo>
		<firstName>#requestMessageData.firstName#</firstName>
		<lastName>#requestMessageData.lastName#</lastName>
		<street1>#requestMessageData.street1#</street1>
		<city>#requestMessageData.city#</city>
		<state>#requestMessageData.state#</state>
		<postalCode>#requestMessageData.postalCode#</postalCode>
		<country>#requestMessageData.country#</country>
		<email>#requestMessageData.email#</email>
	</billTo>
	<purchaseTotals>
		<currency>#requestMessageData.currency#</currency>
		<grandTotalAmount>#requestMessageData.grandTotalAmount#</grandTotalAmount>
	</purchaseTotals>
	<card>
		<accountNumber>#requestMessageData.cardNumber#</accountNumber>
		<expirationMonth>#requestMessageData.expirationMonth#</expirationMonth>
		<expirationYear>#requestMessageData.expirationYear#</expirationYear>
		<cfif requestMessageData.verifyCVNumberFlag>
		<cvNumber>#requestMessageData.cvNumber#</cvNumber>
		</cfif>
		<cfif requestMessageData.cardTypeSupportedFlag>
		<cardType>#requestMessageData.cardType#</cardType>
		</cfif>
	</card>
	<!--- empty service request --->
	<ccCreditService run="true" />
</cfif>
</cfoutput>