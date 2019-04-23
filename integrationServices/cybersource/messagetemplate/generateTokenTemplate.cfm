<cfoutput>
<merchantID>#requestMessageData.merchantID#</merchantID>
<merchantReferenceCode>#requestMessageData.merchantReferenceCode#</merchantReferenceCode>
<billTo>
	<firstName>#requestMessageData.firstName#</firstName>
	<lastName>#requestMessageData.lastName#</lastName>
	<street1>#requestMessageData.street1#</street1>
	<city>#requestMessageData.city#</city>
	<cfif !isNull(requestMessageData.state)>
		<state>#requestMessageData.state#</state>
	</cfif>
	<cfif !isNull(requestMessageData.postalCode)>
		<postalCode>#requestMessageData.postalCode#</postalCode>
	</cfif>
	<country>#requestMessageData.country#</country>
	<email>#requestMessageData.email#</email>
</billTo>
<purchaseTotals>
	<currency>#requestMessageData.currency#</currency>
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
<recurringSubscriptionInfo>
	<frequency>on-demand</frequency>
</recurringSubscriptionInfo>
<paySubscriptionCreateService run="true">
	<disableAutoAuth>#requestMessageData.disableAutoAuth#</disableAutoAuth>
</paySubscriptionCreateService>
</cfoutput>