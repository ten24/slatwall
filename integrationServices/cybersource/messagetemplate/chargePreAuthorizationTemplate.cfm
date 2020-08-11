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
	<grandTotalAmount>#requestMessageData.grandTotalAmount#</grandTotalAmount>
</purchaseTotals>
<ccCaptureService run="true">
	<authRequestID>#requestMessageData.authRequestID#</authRequestID>
</ccCaptureService>
</cfoutput>