<cfoutput>
<merchantID>#requestMessageData.merchantID#</merchantID>
<merchantReferenceCode>#requestMessageData.merchantReferenceCode#</merchantReferenceCode>
<!--- Using payment token, subscriptionID is the token --->
<cfif structKeyExists(requestMessageData, 'subscriptionID')>
	<purchaseTotals>
		<currency>#requestMessageData.currency#</currency>
		<grandTotalAmount>#requestMessageData.grandTotalAmount#</grandTotalAmount>
	</purchaseTotals>
	<recurringSubscriptionInfo>
		<subscriptionID>#requestMessageData.subscriptionID#</subscriptionID>
	</recurringSubscriptionInfo>
<!--- No payment token, provide Credit Card information --->
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
</cfif>
<ccAuthService run="true"/>
<ccCaptureService run="true" />
</cfoutput>